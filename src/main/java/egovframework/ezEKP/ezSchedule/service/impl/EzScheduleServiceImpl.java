package egovframework.ezEKP.ezSchedule.service.impl;

import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.UUID;
import java.util.Base64;

import javax.annotation.Resource;
import javax.mail.internet.InternetAddress;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.beanutils.BeanUtils;
import org.apache.commons.io.FileUtils;
import org.apache.logging.log4j.util.Strings;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.w3c.dom.NodeList;

//import com.sun.org.apache.xml.internal.security.utils.Base64;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezAttitude.dao.EzAttitudeDAO;
import egovframework.ezEKP.ezAttitude.vo.AttitudeVO;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezEmail.util.EmailImportance;
import egovframework.ezEKP.ezEmail.util.EzEmailUtil;
import egovframework.ezEKP.ezNotification.service.EzNotificationService;
import egovframework.ezEKP.ezEmail.service.EzEmailService;
import egovframework.ezEKP.ezOrgan.service.EzOrganAdminService;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.ezEKP.ezOrgan.vo.OrganUserVO;
import egovframework.ezEKP.ezPersonal.service.EzPersonalService;
import egovframework.ezEKP.ezPersonal.type.NotiPlatform;
import egovframework.ezEKP.ezPersonal.type.NotiType;
import egovframework.ezEKP.ezResource.service.EzResourceService;
import egovframework.ezEKP.ezResource.vo.ResGetScheduleVO;
import egovframework.ezEKP.ezSchedule.dao.EzScheduleDAO;
import egovframework.ezEKP.ezSchedule.service.EzScheduleService;
import egovframework.ezEKP.ezSchedule.vo.AttachListVO;
import egovframework.ezEKP.ezSchedule.vo.AttendantListVO;
import egovframework.ezEKP.ezSchedule.vo.ScheDeptVO;
import egovframework.ezEKP.ezSchedule.vo.ScheGetHolidayVO;
import egovframework.ezEKP.ezSchedule.vo.ScheSecretaryVO;
import egovframework.ezEKP.ezSchedule.vo.ScheduleConfigVO;
import egovframework.ezEKP.ezSchedule.vo.ScheduleCumulerVO;
import egovframework.ezEKP.ezSchedule.vo.ScheduleDeptVO;
import egovframework.ezEKP.ezSchedule.vo.ScheduleGroupListVO;
import egovframework.ezEKP.ezSchedule.vo.ScheduleGroupVO;
import egovframework.ezEKP.ezSchedule.vo.ScheduleInfoVO;
import egovframework.ezEKP.ezSchedule.vo.ScheduleReceiveListVO;
import egovframework.ezEKP.ezSchedule.vo.ScheduleReminderVO;
import egovframework.ezEKP.ezSchedule.vo.ScheduleSecretaryVO;
import egovframework.ezEKP.ezSchedule.vo.ScheduleTokenInfoVO;
import egovframework.ezEKP.ezSchedule.vo.ScheduleTypeConfigVO;
import egovframework.ezMobile.ezOption.vo.MCommonVO;
import egovframework.ezMobile.ezSchedule.vo.MScheduleInfoVO;
import egovframework.ezEKP.ezSystem.dao.EzSystemAdminDAO;
import egovframework.ezEKP.ezSystem.vo.SysParamVO;
import egovframework.ezEKP.ezSchedule.vo.ScheduleMailConfigVO;
import egovframework.let.user.login.service.LoginService;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;

@Service("EzScheduleService")
public class EzScheduleServiceImpl implements EzScheduleService{
	
	@Resource(name="EzScheduleDAO")
	private EzScheduleDAO ezScheduleDAO;
	
	@Resource(name="EzResourceService")
	private EzResourceService ezResourceService;
	
	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;

	@Resource(name="EzCommonService")
	private EzCommonService ezCommonService;
	
	@Autowired
	private EzEmailUtil ezEmailUtil;
	
	@Autowired
	private EzEmailService ezEmailService;
	
	@Autowired
	private EzOrganAdminService ezOrganAdminService;
	
	@Autowired
	private EzOrganService ezOrganService;
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private EzAttitudeDAO ezAttitudeDAO;
	
	@Autowired
	private EzPersonalService ezPersonalService;
	
	@Autowired
	private EzNotificationService ezNotificationService;
	
	@Autowired
	private EzSystemAdminDAO ezSystemAdminDAO;
	
	private static final Logger logger = LoggerFactory.getLogger(EzScheduleServiceImpl.class);
	
	@Resource(name = "jspw")
	private String jspw;

	@Override
	public List<ScheGetHolidayVO> getTholiday(String companyId, String userCompany, int tenantId, String isRest) throws Exception {
		logger.debug("===== getTholiday Start =====");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_COMPANYID", companyId);
		map.put("v_USERCOMPANY", userCompany);
		map.put("v_TENANTID", tenantId);
		map.put("isRest", isRest);
		
		List<ScheGetHolidayVO> List = ezScheduleDAO.getTholiday(map); 
		logger.debug("===== getTholiday Ended =====");
		return List;
	}
	
	@Override
	public List<ScheGetHolidayVO> getTholidayYear(String companyId,String userCompany, int tenantId, String isRest, String holidayYear) throws Exception {
		logger.debug("===== getTholidayYear Start =====");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_COMPANYID", companyId);
		map.put("v_USERCOMPANY", userCompany);
		map.put("v_TENANTID", tenantId);
		map.put("isRest", isRest);
		map.put("holidayYear", holidayYear);
		
		List<ScheGetHolidayVO> List = ezScheduleDAO.getTholidayYear(map); 
		logger.debug("===== getTholidayYear Ended =====");
		return List;
	}

	@Override
	public ScheduleConfigVO getScheduleConfig(String userId, int tenantId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_USERID", userId);
		map.put("v_TENANTID", tenantId);
		
		return ezScheduleDAO.getScheduleConfig(map);
	}

	@Override
	public ScheduleInfoVO getScheduleInfo(String scheduleId, String offSetMin, int tenantId, String companyID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_SCHEDULEID", scheduleId);
		map.put("v_OFFSETMIN", offSetMin);
		map.put("v_TENANTID", tenantId);
		map.put("v_COMPANYID", companyID);
		
		return ezScheduleDAO.getScheduleInfo(map);
	}

	@Override
	public List<AttendantListVO> getAttendantList(String scheduleId, String offSetMin, int tenantId, String companyID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_SCHEDULEID", scheduleId);
		map.put("v_OFFSETMIN", offSetMin);
		map.put("v_TENANTID", tenantId);
		map.put("v_COMPANYID", companyID);
		
		return ezScheduleDAO.getAttendantList(map);
	}

	@Override
	public List<AttachListVO> getAttachList(String scheduleId, int tenantId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_SCHEDULEID", scheduleId);
		map.put("v_TENANTID", tenantId);
		
		return ezScheduleDAO.getAttachList(map);
	}

	@Override
	public List<ScheduleSecretaryVO> getPublicScheduleSec(String userId, String lang, int tenantId ,String companyID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_CN", userId);
		map.put("v_LANG", lang);
		map.put("v_TENANTID", tenantId);
		map.put("v_COMPANYID", companyID);
		
		return ezScheduleDAO.getPublicScheduleSec(map);
	}

	@Override
	public List<ScheduleDeptVO> getPublicScheduleDept(String userId, String lang, int tenantId ,String companyID) throws Exception {
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_CN", userId);
		map.put("v_LANG", lang);
		map.put("v_TENANTID", tenantId);
		map.put("v_COMPANYID", companyID);
		
		return ezScheduleDAO.getPublicScheduleDept(map);
	}

	@Override
	public List<ScheduleCumulerVO> getPublicScheduleCumuler(String userId, String lang, int tenantId, String companyID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_CN", userId);
		map.put("v_LANG", lang);
		map.put("v_TENANTID", tenantId);
		map.put("v_COMPANYID", companyID);
		
		return ezScheduleDAO.getPublicScheduleCumuler(map);
	}

	@Override
	public int getReceiveCount(String pUserId, int tenantId, String companyID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();		
		map.put("v_USERID", pUserId);
		map.put("v_TENANTID", tenantId);
		map.put("v_COMPANYID", companyID);
		
		return ezScheduleDAO.getReceiveCount(map);
	}

	@Override
	public int getInviteScheduleGroupCnt(String pUserId, int tenantId, String companyID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_USERID", pUserId);
		map.put("v_TENANTID", tenantId);
		map.put("v_COMPANYID", companyID);
		
		return ezScheduleDAO.getInviteScheduleGroupCnt(map);
	}

	public List<ScheduleInfoVO> realList (List<ScheduleInfoVO> resultList, List<ScheduleInfoVO> tempResultList, String startDate, String endDate) throws Exception {
		
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
			
			if (vosDate_cal.compareTo(sDate_cal) >= 0 && voeDate_cal.compareTo(eDate_cal) <= 0) {
				resultList.add(svo);
			}
		}
		
		return resultList;
	}
	
	@Override
	public List<ScheduleInfoVO> getScheduleList(String indiList, String pidList, String filter, String utcStartDate, String utcEndDate, String orgStartDate, String orgEndDate, String offSetMin, String searchTitle, String searchLocation, String searchAll, int tenantId, String companyID, String userID, String deptID, String useAnnualScheduleYN) throws Exception {						

		Map<String, Object> map = new HashMap<String, Object>();
		
		// 2025-03-17 이가은 - 관리자 > 회사일정관리인지 체크
		boolean adminPage = false;
		if (indiList.startsWith("ADMIN_PAGE")) {
			adminPage = true;
			indiList = indiList.split("ADMIN_PAGE")[1];
		}
		
		/* 2024-07-05 홍승비 - SQL Injection 수정 > 문자열 대신 배열 리스트 파라미터 전달 */
		map.put("v_INDILIST", indiList.replace("'", "").replace("\\", "").replace(" ", "").split(","));
		map.put("v_PIDLIST", pidList.replace("'", "").replace("\\", "").replace(" ", "").split(","));		
		map.put("v_PFILTER", filter.toUpperCase()); // TITLE, LOCATION, ISPUBLIC 검색조건
		map.put("v_PSTARTDATE", utcStartDate);
		map.put("v_PENDDATE", utcEndDate);
		map.put("v_OFFSETMIN", offSetMin);
		map.put("v_TENANTID", tenantId);
		map.put("v_SEARCHTITLE", commonUtil.insertEscapeCharBackslash(searchTitle));
		map.put("v_SEARCHALL", commonUtil.insertEscapeCharBackslash(searchAll));
		map.put("v_SEARCHLOCATION", commonUtil.insertEscapeCharBackslash(searchLocation));
		map.put("v_COMPANYID", companyID);
		map.put("v_USERID", userID);
		map.put("v_DEPTID", deptID);
		map.put("useAnnualScheduleYN", useAnnualScheduleYN);

		List<ScheduleInfoVO> sList = ezScheduleDAO.getScheduleList(map);

		// 2020-02-24 김정언 - 근태 현황 일정관리 연동
		if (!useAnnualScheduleYN.equals("0")) {
			/* 2024-07-25 홍승비 - SQL Injection 수정 > 근태 현황 관련 다국어 처리를 위한 lang 파라미터 추가 */
			map.put("lang", commonUtil.getMultiData(ezCommonService.selectUserGetLang(userID, tenantId), tenantId));
			
			List<AttitudeVO> aList = ezAttitudeDAO.getAnuualListSchedule(map);

			for (int j = 0; j < aList.size(); j++) {
				AttitudeVO aVo = new AttitudeVO();
				ScheduleInfoVO sVo = new ScheduleInfoVO();

				aVo = aList.get(j);

				if (aVo != null) {
					sVo.setDateType("4");
					if(useAnnualScheduleYN.equals("1")){ //부서일정일 경우
						sVo.setScheduleType("2");						
					} else if(useAnnualScheduleYN.equals("2")){ //회사일정일 경우
						sVo.setScheduleType("3");
					}
					sVo.setScheduleId(aVo.getAttitudeId());
					sVo.setParentId(aVo.getTypeId());
					sVo.setStartDate(aVo.getStartDate());
					// 조퇴와 결근은 종료일을 시작일로 설정
					if(aVo.getEndDate() == null || aVo.getEndDate().length() == 0){
						sVo.setEndDate(aVo.getStartDate());
					}else{
						sVo.setEndDate(aVo.getEndDate());						
					}
					sVo.setCreatorName(aVo.getWriterName());
					sVo.setCreatorName2(aVo.getWriterDeptName());
					sVo.setTitle(aVo.getTypeName());
					sVo.setContentPath(aVo.getImgPath());
					if(useAnnualScheduleYN.equals("1")){ //부서일정일 경우
						sVo.setOwnerId(deptID);
					} else if(useAnnualScheduleYN.equals("2")){ //회사일정일 경우
						sVo.setOwnerId(companyID);
					}
					sList.add(sVo);
				}
			}
		}
		
		List<ScheduleInfoVO> resultList = new ArrayList<ScheduleInfoVO>();
		List<ScheduleInfoVO> tempResultList = new ArrayList<ScheduleInfoVO>();
		
		for (int i=0; i < sList.size(); i++) {
			ScheduleInfoVO vo = sList.get(i);
						
			//반복일정 구현 시작
			if (vo.getDateType().equals("3") && vo.getRepetition() != null && !vo.getRepetition().trim().equals("")) {
				map.put("v_SCHEDULEID", vo.getScheduleId());
				
				List<String> rList = ezScheduleDAO.getScheduleRepeDelList(map);
				
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

								if (calcuDate.compareTo(orgStartDate.substring(0,10)) >= 0 && calcuDate.compareTo(orgEndDate.substring(0,10)) <= 0) {	
									//row 추가
									if (!rList.contains(calcuDate)) {
										ScheduleInfoVO rVo = addRepeatRow(vo, date_cal.getTime(), count, info[1]);
										resultList.add(rVo);
									}
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
						//repeatDayList = setDayInfo(dayInfo);
						
						if(dayInfo != null && !dayInfo.trim().equals("")){
							char[] yoilArr = new char[info[4].length()]; // 스트링을 담을 배열

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
						int weeklyMaxCount = maxCount * repeatDayList.size();
						
						while (true) {
							if (scheduleCalendar.compareTo(lastDateOfCalendar) > 0) {
								calculatedScheduleEndDateCalendar.setTime(lastDateOfCalendar.getTime());
								calculatedScheduleEndDateCalendar.add(Calendar.DATE, (Integer.parseInt(weeklyInterval)) * 7);
								if(scheduleCalendar.compareTo(calculatedScheduleEndDateCalendar) > 0) {
									break;
								}
							}
							
							if (Integer.parseInt(isExistEndDate) > 0) {
								if (weeklyMaxCount <= count) break;
							} 
							
							if (count > MAXSCHEDULECOUNT) {
								break;
							}
							
							String scheduleDate = nsdf.format(scheduleCalendar.getTime());
								
								if(isExistEndDate.equals("0")){ //isExistEndDate Code "0" : 종료일 있음
									for (int k = 0; k < repeatDayList.size(); k++) {
										scheduleCalendar.set(Calendar.DAY_OF_WEEK,repeatDayList.get(k)+1);
										scheduleDate = nsdf.format(scheduleCalendar.getTime());
										if (scheduleCalendar.getTime().compareTo(scheduleStartDate) >= 0 && scheduleCalendar.getTime().compareTo(sdf.parse(endDate)) <= 0) {
											if (!rList.contains(scheduleDate)) {
												count++;
												int weeklyCount = (int) Math.ceil(count / (double)repeatDayList.size());
												ScheduleInfoVO rVo = addRepeatRow(vo, scheduleCalendar.getTime(), weeklyCount, isAllday);									
												tempResultList.add(rVo);
											} else {
												count++;
											}
										}
									}
								} else if (Integer.parseInt(isExistEndDate) > 0) { //isExistEndDate Code > 0 : 숫자만큼 일정을 반복
									for (int k = 0; k < repeatDayList.size(); k++) {
										scheduleCalendar.set(Calendar.DAY_OF_WEEK,repeatDayList.get(k)+1);
										scheduleDate = nsdf.format(scheduleCalendar.getTime());
										if (scheduleCalendar.getTime().compareTo(scheduleStartDate) >= 0 && scheduleCalendar.getTime().compareTo(sdf.parse(endDate)) <= 0) {
											if (weeklyMaxCount > count) {
												if (!rList.contains(scheduleDate)) {
													count++;
													int weeklyCount = (int) Math.ceil(count / (double)repeatDayList.size());
													ScheduleInfoVO rVo = addRepeatRow(vo, scheduleCalendar.getTime(), weeklyCount, isAllday);									
													tempResultList.add(rVo);
												} else {
													count++;
												}
											} else {
												break;
											}
										} 
									}
								} else { //isExistEndDate Code "-1" : 종료일 없음
									for (int k = 0; k < repeatDayList.size(); k++) {
										scheduleCalendar.set(Calendar.DAY_OF_WEEK,repeatDayList.get(k)+1);
										scheduleDate = nsdf.format(scheduleCalendar.getTime());
										if (scheduleCalendar.getTime().compareTo(scheduleStartDate) >= 0 && scheduleCalendar.getTime().compareTo(sdf.parse(endDate)) <= 0) {
											if (!rList.contains(scheduleDate)) {
												count++;
												int weeklyCount = (int) Math.ceil(count / (double)repeatDayList.size());
												ScheduleInfoVO rVo = addRepeatRow(vo, scheduleCalendar.getTime(), weeklyCount, isAllday);									
												tempResultList.add(rVo);
											} else {
												count++;
											}
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
									if (calcuDate.compareTo(orgStartDate.substring(0,10)) >= 0 && calcuDate.compareTo(endDate.substring(0,10)) <= 0) {
										//row 추가
										if (!rList.contains(calcuDate)) {
											ScheduleInfoVO rVo = addRepeatRow(vo, newCal.getTime(), count, info[1]);
											resultList.add(rVo);
										}
									}
								} else {
									if (calcuDate.compareTo(orgStartDate.substring(0,10)) >= 0 && calcuDate.compareTo(orgEndDate.substring(0,10)) <= 0) {
										//row 추가
										if (!rList.contains(calcuDate)) {
											ScheduleInfoVO rVo = addRepeatRow(vo, newCal.getTime(), count, info[1]);
											resultList.add(rVo);
										}
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
								
								 /*  2023-08-31 한태훈 - 이게 필요한가..? 2일 날짜에만 특별히 조건을 주는 이유는 없어보입니다. 2월 달인 경우 음력으로 newCal과 date_cal을 만들어서 조건을 주려고 하는 건지,, 모르겠음.
							  		그러려면 info[4].eqlaus("2") 일때를 봐야함.
								if (info[5].equals("2")) {
									//음력으로 newCal 다시 만듬									
									if (!isFirst || newCal.compareTo(date_cal) >= 0) {
										generated = true;
									}
								}
								*/
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
							
							if (newCal.get(Calendar.MONTH) + 1 == month && (!isFirst || newCal.compareTo(date_cal) >= 0)) { // 달이 다를 수 있는데, 날짜만 비교하면 안됨.
								generated = true;
							}
							
							isFirst = false;
							
							if (generated) {
								count++;
								
								String calcuDate = nsdf.format(newCal.getTime());
								
								if (info[0].equals("0")) {
									if (calcuDate.compareTo(orgStartDate.substring(0,10)) >= 0 && calcuDate.compareTo(endDate.substring(0,10)) <= 0 && calcuDate.compareTo(vo.getStartDate().substring(0,10)) >= 0) {
										//row 추가
										if (!rList.contains(calcuDate)) {
											ScheduleInfoVO rVo = addRepeatRow(vo, newCal.getTime(), count, info[1]);
											resultList.add(rVo);
										}
									}
								} else {
									if (calcuDate.compareTo(orgStartDate.substring(0,10)) >= 0 && calcuDate.compareTo(orgEndDate.substring(0,10)) <= 0 && calcuDate.compareTo(vo.getStartDate().substring(0,10)) >= 0) {
										//row 추가
										if (!rList.contains(calcuDate)) {
											ScheduleInfoVO rVo = addRepeatRow(vo, newCal.getTime(), count, info[1]);
											resultList.add(rVo);
										}
									}
								}
							}
							
							date_cal.add(Calendar.DATE, 1 - date_cal.get(Calendar.DATE));
							date_cal.add(Calendar.YEAR, 1);
						}						
					break;	
				}				
			}
			//반복일정 구현 끝
			else {
				resultList.add(vo);
			}
		}
		
		String useWorkspaceSchedule = ezCommonService.getTenantConfig("useWorkspaceSchedule", tenantId);
	    logger.debug("useWorkspaceSchedule : " + useWorkspaceSchedule);
		
		if (useWorkspaceSchedule == null || useWorkspaceSchedule.equals("") || adminPage) {
			useWorkspaceSchedule = "NO";
		}
		
		try {
			// 협업 일정 가져오기
			if(useWorkspaceSchedule.equalsIgnoreCase("yes")) {
				String workspaceHostUrl = ezCommonService.getTenantConfig("workspaceHostUrl", tenantId);
				String workspaceAppPath = ezCommonService.getTenantConfig("workspaceAppPath", tenantId);
			
				/* 2025-04-11 전인하 - ezWork 협업을 위해 검색키워드 지정 (전체검색일 경우 키워드 넘김, 상세검색일 경우 제목 넘김. */
				String ezWorkSearchKeyword = Strings.isBlank(searchAll) && !Strings.isNotBlank(searchTitle) ? searchTitle : searchAll;
				/* 2025-03-13 홍승비 - 협업 모듈에 고정된 하드코딩 문자열 제거 (ezWorkspace), 테넌트 컨피그 workspaceAppPath로 협업 웹응용프로그램 경로를 분리하여 사용 ("" 또는 "/ezWork" 등) */
				String domain = workspaceHostUrl + workspaceAppPath + "/api/GroupwareApi/post/scheduleread/";
				String params = "userAccountId=" + URLEncoder.encode(userID, "UTF-8") + "&startDate=" + URLEncoder.encode(orgStartDate, "UTF-8")
						+ "&endDate=" + URLEncoder.encode(orgEndDate, "UTF-8") + "&searchTerm=" + ezWorkSearchKeyword + "&bMobile=" + URLEncoder.encode("false", "UTF-8");
				String workspaceScheduleLists = ezEmailUtil.getWebServiceResult(domain, params);

				if(workspaceScheduleLists != null && !workspaceScheduleLists.equals("")) {
					JSONParser jsonparser = new JSONParser();
					JSONArray jsonarray = (JSONArray)jsonparser.parse(workspaceScheduleLists);

					logger.debug("data.length = " + jsonarray.size());

					for(int i=0; i<jsonarray.size(); i++) {
						ScheduleInfoVO sVo = new ScheduleInfoVO();
						JSONObject jsonobject = (JSONObject)jsonarray.get(i);

						// 협업에 없는 값들의 경우 null로 반환되기 때문에 ""로 설정해주는 작업 진행
						sVo.setScheduleId("collaboration:" + jsonobject.get("ItemId"));
						sVo.setParentId("collaboration:" + jsonobject.get("ItemPostId").toString());
						sVo.setOwnerId(jsonobject.get("ItemUserAccountId").toString());
						sVo.setOwnerName(jsonobject.get("ItemUserName").toString());
						sVo.setCreatorName(jsonobject.get("ItemUserName").toString());
						// 협업의 api에 createdate가 없기 때문에 updatedate = createdate로 취급
						sVo.setCreateDate(jsonobject.get("ItemUpdateDate").toString().replace("T", " "));
						// 협업의 타입은 4로 고정됨.
						sVo.setScheduleType("4");
						sVo.setImportance((Integer.parseInt(jsonobject.get("ItemImportance").toString()) + 1) + "");
						// 협업에 없는 기능으로 연구소에서 default Y로 요청함.
						sVo.setIsPublic("Y");
						sVo.setDateType(jsonobject.get("ItemDateType").toString());
						sVo.setStartDate(jsonobject.get("ItemStartDate").toString().replace("T", " "));
						sVo.setEndDate(jsonobject.get("ItemEndDate").toString().replace("T", " "));
						sVo.setRepetition(jsonobject.get("ItemRepetition").toString());
						sVo.setTitle(jsonobject.get("ItemPostTitle").toString());
						sVo.setLocation(jsonobject.get("ItemLocation").toString());
						sVo.setContent(jsonobject.get("ItemContents").toString());
						sVo.setRepeatCount(Integer.parseInt(jsonobject.get("ItemRepeatCount").toString()));
						sVo.setRepeatedScheduleOffset(0);
						sVo.setGroupColor("rgb(63, 81, 181)");
						// 협업에 없는 기능으로 연구소에서 default N로 요청함.
						sVo.setShowTop("N");

						resultList.add(sVo);
					}
				}
			}
		} catch (java.net.UnknownHostException e) {
			logger.error("workspace host error : " + e.getMessage());
		} catch (java.net.ConnectException e) {
			logger.error("workspace connect error : " + e.getMessage());
		} catch (Exception e) {
			logger.error("error : " + e.getMessage());
		}

		logger.debug("=====getScheduleList Ended=====");
		if (tempResultList != null) {
			resultList = realList(resultList, tempResultList, orgStartDate, orgEndDate);
		}
		
		return resultList;
	}
	
	@Override
	public List<ScheduleInfoVO> getScheduleListForWorkspace(String indiList, String pidList, String filter, String utcStartDate, String utcEndDate, String orgStartDate, String orgEndDate, String keyword, String offSetMin, String searchTitle, int tenantId, String companyID, String userID, String deptID) throws Exception {						
		logger.debug("=====getScheduleListForWorkspace start=====");
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		/* 2024-07-05 홍승비 - SQL Injection 수정 > 문자열 대신 배열 리스트 파라미터 전달 */
		map.put("v_INDILIST", indiList.replace("'", "").replace("\\", "").replace(" ", "").split(","));
		map.put("v_PIDLIST", pidList.replace("'", "").replace("\\", "").replace(" ", "").split(","));		
		map.put("v_PFILTER", filter.toUpperCase());
		map.put("v_PSTARTDATE", utcStartDate);
		map.put("v_PENDDATE", utcEndDate);
		map.put("v_OFFSETMIN", offSetMin);
		map.put("v_TENANTID", tenantId);
		map.put("v_SEARCHTITLE", commonUtil.insertEscapeCharBackslash(searchTitle));
		map.put("v_COMPANYID", companyID);
		map.put("v_USERID", userID);
		map.put("v_DEPTID", deptID);
		
		List<ScheduleInfoVO> sList = ezScheduleDAO.getScheduleList(map);
		List<ScheduleInfoVO> resultList = new ArrayList<ScheduleInfoVO>();
		List<ScheduleInfoVO> tempResultList = new ArrayList<ScheduleInfoVO>();
		
		for (int i=0; i < sList.size(); i++) {
			ScheduleInfoVO vo = sList.get(i);
						
			//반복일정 구현 시작
			if (vo.getDateType().equals("3")) {
				map.put("v_SCHEDULEID", vo.getScheduleId());
				
				List<String> rList = ezScheduleDAO.getScheduleRepeDelList(map);
				
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

								if (calcuDate.compareTo(orgStartDate.substring(0,10)) >= 0 && calcuDate.compareTo(orgEndDate.substring(0,10)) <= 0) {	
									//row 추가
									if (!rList.contains(calcuDate)) {
										ScheduleInfoVO rVo = addRepeatRow(vo, date_cal.getTime(), count, info[1]);
										resultList.add(rVo);
									}
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
						//repeatDayList = setDayInfo(dayInfo);
						
						if(dayInfo != null && !dayInfo.trim().equals("")){
							char[] yoilArr = new char[info[4].length()]; // 스트링을 담을 배열

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
						int weeklyMaxCount = maxCount * repeatDayList.size();
						
						while (true) {
							if (scheduleCalendar.compareTo(lastDateOfCalendar) > 0) {
								calculatedScheduleEndDateCalendar.setTime(lastDateOfCalendar.getTime());
								calculatedScheduleEndDateCalendar.add(Calendar.DATE, (Integer.parseInt(weeklyInterval)) * 7);
								if(scheduleCalendar.compareTo(calculatedScheduleEndDateCalendar) > 0) {
									break;
								}
							}
							
							if (Integer.parseInt(isExistEndDate) > 0) {
								if (weeklyMaxCount <= count) break;
							} 
							
							if (count > MAXSCHEDULECOUNT) {
								break;
							}
							
							String scheduleDate = nsdf.format(scheduleCalendar.getTime());
								
								if(isExistEndDate.equals("0")){ //isExistEndDate Code "0" : 종료일 있음
									for (int k = 0; k < repeatDayList.size(); k++) {
										scheduleCalendar.set(Calendar.DAY_OF_WEEK,repeatDayList.get(k)+1);
										scheduleDate = nsdf.format(scheduleCalendar.getTime());
										if (scheduleCalendar.getTime().compareTo(scheduleStartDate) >= 0 && scheduleCalendar.getTime().compareTo(sdf.parse(endDate)) <= 0) {
											if (!rList.contains(scheduleDate)) {
												count++;
												int weeklyCount = (int) Math.ceil(count / (double)repeatDayList.size());
												ScheduleInfoVO rVo = addRepeatRow(vo, scheduleCalendar.getTime(), weeklyCount, isAllday);									
												tempResultList.add(rVo);
											} else {
												count++;
											}
										}
									}
								} else if (Integer.parseInt(isExistEndDate) > 0) { //isExistEndDate Code > 0 : 숫자만큼 일정을 반복
									for (int k = 0; k < repeatDayList.size(); k++) {
										scheduleCalendar.set(Calendar.DAY_OF_WEEK,repeatDayList.get(k)+1);
										scheduleDate = nsdf.format(scheduleCalendar.getTime());
										if (scheduleCalendar.getTime().compareTo(scheduleStartDate) >= 0 && scheduleCalendar.getTime().compareTo(sdf.parse(endDate)) <= 0) {
											if (weeklyMaxCount > count) {
												if (!rList.contains(scheduleDate)) {
													count++;
													int weeklyCount = (int) Math.ceil(count / (double)repeatDayList.size());
													ScheduleInfoVO rVo = addRepeatRow(vo, scheduleCalendar.getTime(), weeklyCount, isAllday);									
													tempResultList.add(rVo);
												} else {
													count++;
												}
											} else {
												break;
											}
										} 
									}
								} else { //isExistEndDate Code "-1" : 종료일 없음
									for (int k = 0; k < repeatDayList.size(); k++) {
										scheduleCalendar.set(Calendar.DAY_OF_WEEK,repeatDayList.get(k)+1);
										scheduleDate = nsdf.format(scheduleCalendar.getTime());
										if (scheduleCalendar.getTime().compareTo(scheduleStartDate) >= 0 && scheduleCalendar.getTime().compareTo(sdf.parse(endDate)) <= 0) {
											if (!rList.contains(scheduleDate)) {
												count++;
												int weeklyCount = (int) Math.ceil(count / (double)repeatDayList.size());
												ScheduleInfoVO rVo = addRepeatRow(vo, scheduleCalendar.getTime(), weeklyCount, isAllday);									
												tempResultList.add(rVo);
											} else {
												count++;
											}
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
									if (calcuDate.compareTo(orgStartDate.substring(0,10)) >= 0 && calcuDate.compareTo(endDate.substring(0,10)) <= 0) {
										//row 추가
										if (!rList.contains(calcuDate)) {
											ScheduleInfoVO rVo = addRepeatRow(vo, newCal.getTime(), count, info[1]);
											resultList.add(rVo);
										}
									}
								} else {
									if (calcuDate.compareTo(orgStartDate.substring(0,10)) >= 0 && calcuDate.compareTo(orgEndDate.substring(0,10)) <= 0) {
										//row 추가
										if (!rList.contains(calcuDate)) {
											ScheduleInfoVO rVo = addRepeatRow(vo, newCal.getTime(), count, info[1]);
											resultList.add(rVo);
										}
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
								/* 2023-09-11 한태훈 - 해당 로직은 불필요해보여서 삭제
								if (info[5].equals("2")) {
									//음력으로 newCal 다시 만듬									
									if (!isFirst || newCal.compareTo(date_cal) >= 0) {
										generated = true;
									}
								}
								*/
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
							
							if (newCal.get(Calendar.MONTH) + 1 == month && (!isFirst || newCal.compareTo(date_cal) >= 0)) {
								generated = true;
							}
							
							isFirst = false;
							
							if (generated) {
								count++;
								
								String calcuDate = nsdf.format(newCal.getTime());
								
								if (info[0].equals("0")) {
									if (calcuDate.compareTo(orgStartDate.substring(0,10)) >= 0 && calcuDate.compareTo(endDate.substring(0,10)) <= 0 && calcuDate.compareTo(vo.getStartDate().substring(0,10)) >= 0) {
										//row 추가
										if (!rList.contains(calcuDate)) {
											ScheduleInfoVO rVo = addRepeatRow(vo, newCal.getTime(), count, info[1]);
											resultList.add(rVo);
										}
									}
								} else {
									if (calcuDate.compareTo(orgStartDate.substring(0,10)) >= 0 && calcuDate.compareTo(orgEndDate.substring(0,10)) <= 0 && calcuDate.compareTo(vo.getStartDate().substring(0,10)) >= 0) {
										//row 추가
										if (!rList.contains(calcuDate)) {
											ScheduleInfoVO rVo = addRepeatRow(vo, newCal.getTime(), count, info[1]);
											resultList.add(rVo);
										}
									}
								}
							}
							
							date_cal.add(Calendar.DATE, 1 - date_cal.get(Calendar.DATE));
							date_cal.add(Calendar.YEAR, 1);
						}						
					break;	
				}				
			}
			//반복일정 구현 끝
			else {
				resultList.add(vo);
			}
		}

		logger.debug("=====getScheduleListForWorkspace Ended=====");
		if (tempResultList != null) {
			resultList = realList(resultList, tempResultList, orgStartDate, orgEndDate);
		}
		
		return resultList;
	}
	
	public ScheduleInfoVO addRepeatRow(ScheduleInfoVO vo, Date date, int count, String dateType) throws Exception {
		
		SimpleDateFormat nsdf = new SimpleDateFormat("yyyy-MM-dd");
		ScheduleInfoVO innerVO = new ScheduleInfoVO();
	
		String dateTime1 = nsdf.format(date) + vo.getStartDate().substring(10);
		String dateTime2 = nsdf.format(date) + vo.getEndDate().substring(10);		
				
		if (dateTime1.compareTo(dateTime2) > 0) {
			Calendar cal = Calendar.getInstance();
			
			cal.setTime(date);
			cal.add(Calendar.DATE, 1);
			
			dateTime2 = nsdf.format(cal.getTime()) + vo.getEndDate().substring(10); 
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
	
	@Override
	public List<ScheduleGroupListVO> getScheduleGroupList(String userID, int tenantId, String companyID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_USERID", userID);
		map.put("v_TENANTID", tenantId);
		map.put("v_COMPANYID", companyID);
		
		List<ScheduleGroupListVO> gList = ezScheduleDAO.getScheduleGroupList(map);
		
		return gList;
	}

	@Override
	public List<ScheduleGroupVO> getMyGroupList(String userID, int tenantID, String companyID) throws Exception {	
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_USERID", userID);
		map.put("v_TENANTID", tenantID);
		map.put("v_COMPANYID", companyID);
		
		List<ScheduleGroupVO> gList = ezScheduleDAO.getMyGroupList(map);
		
		return gList;
	}
		
	@Override
	public int getMyGroupMemberListCnt(String groupId, String lang, int tenantId, String companyID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_GROUPID", groupId);
		map.put("v_LANG", lang);
		map.put("v_TENANTID", tenantId);
		map.put("v_COMPANYID", companyID);
		
		int cnt = ezScheduleDAO.getMyGroupMemberListCnt(map);
		
		return cnt;
	}

	@Override
	public String getMyGroupMemberList(String groupId, String lang, int tenantId, String companyID) throws Exception {
		StringBuilder sb = new StringBuilder("<DATA>");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_GROUPID", groupId);
		map.put("v_LANG", lang);
		map.put("v_TENANTID", tenantId);
		map.put("v_COMPANYID", companyID);
		
		List<ScheduleGroupListVO> gList = ezScheduleDAO.getMyGroupMemberList(map);
		
		for(int j = 0; j < gList.size(); j++){			
			ScheduleGroupListVO data = gList.get(j);
			
			sb.append(commonUtil.getQueryResult(data));
		}
		sb.append("</DATA>");
		
		return sb.toString();
	}
	

	@Override
	public void deleteScheduleGroup(String groupId, int tenantId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_GROUPID", groupId);		
		map.put("v_TENANTID", tenantId);
		
		ezScheduleDAO.deleteScheduleGroup(map);
		ezScheduleDAO.deleteScheduleGroupMember(map);
	}

	@Override
	public List<ScheduleGroupListVO> getGroupMemberList(String groupID,	String lang, int tenantId, String offSetMin, String companyID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_GROUPID", groupID);		
		map.put("v_LANG", lang);
		map.put("v_TENANTID", tenantId);
		map.put("v_OFFSETMIN", offSetMin);
		map.put("v_COMPANYID", companyID);
		
		List<ScheduleGroupListVO> gList = ezScheduleDAO.getGroupMemberList(map);
		
		return gList;
	}

	@Override
	public void deleteScheduleMember(String groupId, String memberId, int tenantId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_GROUPID", groupId);
		map.put("v_MEMBERID", memberId);
		map.put("v_TENANTID", tenantId);
		
		ezScheduleDAO.deleteScheduleMember(map);
	}
	

	@Override
	public void updateManageScheduleMember(String groupID, String memberId, String memberName, String memberName2, int tenantId, String loginUserId, String loginUserName, String loginUserName2) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_GROUPID", groupID);
		map.put("v_MEMBERID", memberId);
		map.put("v_MEMBERNAME", memberName);
		map.put("v_MEMBERNAME2", memberName2);
		map.put("v_TENANTID", tenantId);
		
		ScheduleGroupVO creatorVO = ezScheduleDAO.selectCreatorMember(map);
		map.put("v_CREATORID", creatorVO.getCreatorid());
		map.put("v_CREATORNAME", creatorVO.getCreatorname());
		map.put("v_CREATORNAME2", creatorVO.getCreatorname2());
		
		ezScheduleDAO.updateManageScheduleGroupMember(map);
		ezScheduleDAO.updateManageScheduleMember(map);

	}

	@Override
	public void updateScheduleMember(String groupId, String memberId, String status, int tenantId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_GROUPID", groupId);
		map.put("v_MEMBERID", memberId);
		map.put("v_STATUS", status);
		map.put("v_TENANTID", tenantId);
		
		ezScheduleDAO.updateScheduleMember(map);
	}
	
	@Override
	public void updateAttendantStatus(String scheduleId, String attendantId, String status, int tenantId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_SCHEDULEID", scheduleId);
		map.put("v_ATTENDANTID", attendantId);
		map.put("v_STATUS", status);
		map.put("v_TENANTID", tenantId);
		
		ezScheduleDAO.updateAttendantStatus(map);
	}

	@Override
	public void insertScheduleGroupMember(String groupId, String memberId, String memberName, String memberName2, String memberDeptId, int tenantId, String writePermission) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_GROUPID", groupId);
		map.put("v_MEMBERID", memberId);
		map.put("v_MEMBERNAME", memberName);
		map.put("v_MEMBERNAME2", memberName2);
		map.put("v_MEMBERDEPTID", memberDeptId);
		map.put("v_TENANTID", tenantId);
		map.put("v_WRITEPERMISSION", writePermission);
		
		ScheduleGroupListVO scheduleGroupMember = ezScheduleDAO.selectScheduleGroupMember(map);
		
		if (scheduleGroupMember == null) {
			ezScheduleDAO.insertScheduleGroupMember(map);
		} else {
			ezScheduleDAO.updateScheduleGroupMember(map);
		}
	}

	@Override
	public String getDeptMemberList(String deptId, String subDept, String lang, int tenantId, String companyID) throws Exception {
		StringBuilder sb = new StringBuilder("<DATA>");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_DEPTID", deptId);
		map.put("v_SUBDEPT", subDept);
		map.put("v_LANG", lang);		
		map.put("v_TENANTID", tenantId);
		map.put("v_COMPANYID", companyID);
		
		List<OrganUserVO> gList = ezScheduleDAO.getDeptMemberList(map);
		
		for(int i = 0; i < gList.size(); i++){			
			OrganUserVO data = gList.get(i);
			
			sb.append(commonUtil.getQueryResult(data));
		}
		sb.append("</DATA>");
		
		return sb.toString();		
	}

	@Override
	public void insertScheduleGroup(String gUID, String id, String displayName,	String displayName2, String groupName, String description, int tenantId, String companyID, String groupColor) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_GUID", gUID);
		map.put("v_USERID", id);
		map.put("v_DISPLAYNAME", displayName);
		map.put("v_DISPLAYNAME2", displayName2);
		map.put("v_GROUPNAME", groupName);
		map.put("v_DESCRIPTION", description);
		map.put("v_TENANTID", tenantId);
		map.put("v_COMPANYID", companyID);
		map.put("v_GROUPCOLOR", groupColor);
		
		ezScheduleDAO.insertScheduleGroup(map);
	}

	@Override
	public void updateScheduleGroup(String groupId, String id, String displayName,	String displayName2, String groupName, String description, int tenantId, String companyID, String groupColor) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_GUID", groupId);
		map.put("v_USERID", id);
		map.put("v_DISPLAYNAME", displayName);
		map.put("v_DISPLAYNAME2", displayName2);
		map.put("v_GROUPNAME", groupName);
		map.put("v_DESCRIPTION", description);
		map.put("v_TENANTID", tenantId);
		map.put("v_COMPANYID", companyID);
		map.put("v_GROUPCOLOR", groupColor);
		
		ezScheduleDAO.updateScheduleGroup(map);
	}

	
	@Override
	public String scheduleGetLunarUse(String companyID, int tenantId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_COMPANYID", companyID);
		map.put("v_TENANTID", tenantId);
		
		String result = ezScheduleDAO.scheduleGetLunarUse(map);
		
		if (result == null || result.equals("")) {
			result = "0";
		}		
		return result;
	}
	
	@Override
	public String getCumDeptId(String userID, int tenantID, String companyID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_COMPANYID", companyID);
		map.put("v_TENANTID", tenantID);
		map.put("v_USERID", userID);
		
		String result = ezScheduleDAO.getCumDeptId(map);
		
		return result;
	}

	@Override
	public String scheduleGetRegi(String companyID, int tenantId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_COMPANYID", companyID);
		map.put("v_TENANTID", tenantId);
		
		String result = ezScheduleDAO.scheduleGetRegi(map);
		
		if (result == null || result.equals("")) {
			result = "0";
		}		
		return result;
	}

	@Override
	public List<ScheduleSecretaryVO> getSecretaryList(String userId, int tenantId, String companyID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_USERID", userId);		
		map.put("v_TENANTID", tenantId);
		map.put("v_COMPANYID", companyID);
		
		List<ScheduleSecretaryVO> sList = ezScheduleDAO.getSecretaryList(map);
		
		return sList;
	}
	
	@Override
	public ScheduleMailConfigVO getScheduleMailNotiConfig(String userId, int tenantId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_USERID", userId);		
		map.put("v_TENANTID", tenantId);
		
		return ezScheduleDAO.getScheduleMailNotiConfig(map);
	}
	
	@Override
	public void setScheduleMailNotiConfig(String userMailNoti, String userId, int tenantId) throws Exception {
		String[] userMailNotiList = userMailNoti.split(";");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_USERID", userId);		
		map.put("v_TENANTID", tenantId);
		map.put("v_INVITATIONMAIL", userMailNotiList[0]);
		map.put("v_CANCELLATIONMAIL", userMailNotiList[1]);
		map.put("v_ATTENDANCEMAIL", userMailNotiList[2]);
		map.put("v_REJECTEDMAIL", userMailNotiList[3]);
		map.put("v_INVITESCHEMODMAIL", userMailNotiList[4]);
		
		if(ezScheduleDAO.getUserScheduleConfig(map) == null) {			
			map.put("v_DEFAULTVIEW", "2");
			map.put("v_STARTDAY", "7");
			map.put("v_STARTTIME", "540");
			map.put("v_ENDTIME", "1080");
			map.put("v_AUTODELETE", "0");
			
			ezScheduleDAO.insertScheduleConfig(map);
		}
		else {
			ezScheduleDAO.setScheduleMailNotiConfig(map);
		}
	}

	@Override
	public void deleteScheduleConfig(String userID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_USERID", userID);		
		map.put("v_TENANTID", tenantID);
		
		ezScheduleDAO.deleteScheduleConfig(map);
	}

	@Override
	public void deleteSecretary(String userID, int tenantID, String companyID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_USERID", userID);		
		map.put("v_TENANTID", tenantID);
		map.put("v_COMPANYID", companyID);
		
		ezScheduleDAO.deleteSecretary(map);
	}

	@Override
	public void insertSecretary(String userID, String displayName, String displayName2, String secretaryID, String secretaryName, int tenantID, String companyID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_USERID", userID);
		map.put("v_DISPLAYNAME", displayName);
		map.put("v_DISPLAYNAME2", displayName2);
		map.put("v_SECRETARYID", secretaryID);
		map.put("v_SECRETARYNAME", secretaryName);		
		map.put("v_TENANTID", tenantID);
		map.put("v_COMPANYID", companyID);
		
		ezScheduleDAO.insertSecretary(map);
	}

	@Override
	public int insertSchedule(String ownerid, String ownername, String ownername2, String creatorid, String creatorname, String creatorname2, String scheduletype, String importance,
		String ispublic, String datetype, String startdate, String enddate,	String repetition, String title, String location, String content, NodeList attach, NodeList attendantId, 
		NodeList attendantName, NodeList attendantName2, NodeList attendantDeptName, NodeList attendantDeptName2, String defaultPath, int tenantId, String companyID, String showtop, String offSet, String lang) throws Exception {
		
		//본문내용 MHT 저장
		String mhtPath = commonUtil.separator + "doc";
		String uploadFilePath = commonUtil.separator + "uploadFile";
		String contentPath = commonUtil.detectPathTraversal(defaultPath + mhtPath);
		File file = new File(contentPath);

		if (!file.exists()) {			
			file.mkdirs();
		}
		
		InputStream stream = null;
		//OutputStream bos = null;		
		int sID = 0;
		
		String schedulePath = commonUtil.separator + "{" + UUID.randomUUID().toString() + "}" + ".mht";
		contentPath += schedulePath;
			
		try (OutputStream bos = new FileOutputStream(commonUtil.detectPathTraversal(contentPath))) {
			//byte[] ct = Base64.decode(content);
			//stream = new ByteArrayInputStream(ct);
			//bos = new FileOutputStream(contentPath);
			
			//2018-10-24 김혜정 ics파일 데이터를 위해 조건 추가
			if (attach == null) {
				stream = new ByteArrayInputStream(content.getBytes("UTF-8"));
			}else{
				//byte[] ct = Base64.decode(content);
				byte[] ct = Base64.getUrlDecoder().decode(content);
				stream = new ByteArrayInputStream(ct);
			}
			
			//bos = new FileOutputStream(commonUtil.detectPathTraversal(contentPath));
			
			int bytesRead = 0;
			byte[] buffer = new byte[2048];
			
			while ((bytesRead = stream.read(buffer, 0, 2048)) != -1) {
				bos.write(buffer, 0, bytesRead);
			}

			//첨부파일 카운트
			String hasattach = "N";
			
			//2018-10-24 김혜정 ics파일 데이터를 위해 조건 추가
			if(attach != null) {
				if(attach.getLength() > 0) {				
					hasattach = "Y";
				}
			}
			//비서정보 카운트
			String hasattendant = "N";
			
			//2018-10-24 김혜정 ics파일 데이터를 위해 조건 추가
			if(attendantId != null) {
				if(attendantId.getLength() > 0) {				
					hasattendant = "Y";
				}
			}
			//일정 정보 저장
			schedulePath = commonUtil.detectPathTraversal(mhtPath + schedulePath);
			
			Map<String, Object> map = new HashMap<String, Object>();
			
			map.put("v_OWNERID", ownerid);
			map.put("v_OWNERNAME", ownername);
			map.put("v_OWNERNAME2", ownername2);
			map.put("v_CREATORID", creatorid);
			map.put("v_CREATORNAME", creatorname);
			map.put("v_CREATORNAME2", creatorname2);
			map.put("v_SCHEDULETYPE", scheduletype);
			map.put("v_IMPORTANCE", importance);
			map.put("v_HASATTENDANT", hasattendant);
			map.put("v_HASATTACH", hasattach);
			map.put("v_ISPUBLIC", ispublic);
			map.put("v_DATETYPE", datetype);
			map.put("v_STARTDATE", startdate);
			map.put("v_ENDDATE", enddate);
			map.put("v_REPETITION", repetition);
			map.put("v_TITLE", title);
			map.put("v_LOCATION", location);
			map.put("v_CONTENTPATH", schedulePath);
			map.put("v_TENANTID", tenantId);
			map.put("v_COMPANYID", companyID);
			map.put("v_SHOWTOP", showtop);

			ezScheduleDAO.insertSchedule(map);
			
			int scheduleId = ezScheduleDAO.getCurScheduleId(null);
			
			//첨부파일 저장
			Map<String, Object> attachMap = new HashMap<String, Object>();
			//2018-10-24 김혜정 ics파일 데이터를 위해 조건 추가
			if(attach != null) {
				for (int i=0; i < attach.getLength(); i++) {
					String[] files = attach.item(i).getTextContent().split("/");				
					String fileName = files[1];
					String filePath = files[0];
					String fileSize = files[2];
					
					filePath = commonUtil.detectPathTraversal(uploadFilePath + commonUtil.separator + filePath);
	
					attachMap.put("v_SCHEDULEID", scheduleId);
					attachMap.put("v_FILENAME", fileName);
					attachMap.put("v_FILEPATH", filePath);
					attachMap.put("v_FILESIZE", fileSize);
					attachMap.put("v_TENANTID", tenantId);
					
					ezScheduleDAO.insertScheduleAttach(attachMap);
				}
			}
			
			//참석자 관련 데이터 저장 로직
			//2018-10-24 김혜정 ics파일 데이터를 위해 조건 추가
			if(attendantId != null) {
				for (int i=0; i < attendantId.getLength(); i++) {								
					String v_attendantId = attendantId.item(i).getTextContent();				
					String v_attendantName = attendantName.item(i).getTextContent();
					String v_attendantName2 = attendantName2.item(i).getTextContent();
					String v_attendantDeptName = attendantDeptName.item(i).getTextContent();
					String v_attendantDeptName2 = attendantDeptName2.item(i).getTextContent();
					
					insertScheduleAttendant(Integer.toString(scheduleId), v_attendantId, v_attendantName, v_attendantName2, v_attendantDeptName, v_attendantDeptName2, tenantId, companyID);
				}
			}
			
			// 2023-09-04 한태훈 - 개인 일정의 경우 미리알림 스케줄러에 데이터 추가
			if (scheduletype.equals("1")) {
				map.put("v_SCHEDULEID", scheduleId);
				map.put("v_REMINDERSTATUS", "0");
				map.put("v_OFFSET", offSet);
				map.put("v_LANG", lang);
				map.put("v_OFFSETMIN", commonUtil.getMinuteUTC(offSet));
				ezScheduleDAO.insertReminderSchedule(map);
			}
			
			sID = scheduleId;			
		} catch (Exception e) {
			logger.error(e.getMessage(), e); //테스트를 위해 추가
		} finally {
			if (stream != null) stream.close();				
			//if (bos != null) bos.close();
		}
		return sID;
	}
	
	
	@Override
	public int updateSchedule(String scheduleid, String creatorid, String creatorname, String creatorname2, String importance, String ispublic, String datetype, String startdate, String enddate,
		String repetition, String title, String location, String content, NodeList attach, String defaultPath, int tenantId, String companyID, String showtop) throws Exception {
		
		Map<String, Object> map = new HashMap<String, Object>();
		String uploadFilePath = commonUtil.separator + "uploadFile";
		
		//첨부파일 카운트
		String hasattach = "N";
		
		if(attach.getLength() > 0) {				
			hasattach = "Y";
		}
		
		map.put("v_SCHEDULEID", scheduleid);
		map.put("v_MODIFIERID", creatorid);
		map.put("v_MODIFIERNAME", creatorname);
		map.put("v_MODIFIERNAME2", creatorname2);
		map.put("v_IMPORTANCE", importance);
		map.put("v_HASATTACH", hasattach);
		map.put("v_ISPUBLIC", ispublic);
		map.put("v_DATETYPE", datetype);
		map.put("v_STARTDATE", startdate);
		map.put("v_ENDDATE", enddate);
		map.put("v_REPETITION", repetition);
		map.put("v_TITLE", title);
		map.put("v_LOCATION", location);
		map.put("v_TENANTID", tenantId);
		map.put("v_COMPANYID", companyID);
		map.put("v_SHOWTOP", showtop);

		ezScheduleDAO.updateSchedule(map);
		
		//mht 내용 변경
		InputStream stream = null;
		//OutputStream bos = null;		
		
		try (OutputStream bos = new FileOutputStream(commonUtil.detectPathTraversal(defaultPath))) {
			//byte[] ct = Base64.decode(content);
			byte[] ct = Base64.getUrlDecoder().decode(content);
			stream = new ByteArrayInputStream(ct);
			//bos = new FileOutputStream(commonUtil.detectPathTraversal(defaultPath));
			
			int bytesRead = 0;
			byte[] buffer = new byte[2048];
			
			while ((bytesRead = stream.read(buffer, 0, 2048)) != -1) {
				bos.write(buffer, 0, bytesRead);
			}
		} catch (Exception e) {
			logger.debug("e.message=" + e.getMessage());
		} finally {
			if (stream != null) stream.close();				
			//if (bos != null) bos.close();
		}
		//첨부파일 경로 삭제
		ezScheduleDAO.deleteScheduleAttach(map);
		//첨부파일 정보 등록		
		Map<String, Object> attachMap = new HashMap<String, Object>();
					
		for (int i=0; i < attach.getLength(); i++) {
			String[] files = attach.item(i).getTextContent().split("/");				
			String fileName = files[1];
			String filePath = files[0];
			String fileSize = files[2];
			
			filePath = commonUtil.detectPathTraversal(uploadFilePath + commonUtil.separator + filePath);

			attachMap.put("v_SCHEDULEID", scheduleid);
			attachMap.put("v_FILENAME", fileName);
			attachMap.put("v_FILEPATH", filePath);
			attachMap.put("v_FILESIZE", fileSize);
			attachMap.put("v_TENANTID", tenantId);
			
			ezScheduleDAO.insertScheduleAttach(attachMap);
		}	
		
		// 2023-09-15 - 한태훈 : 일정관리 > 미리알림 스케줄러 미완료 상태로 변경.
		map.put("v_REMINDERSTATUS", "0");
		ezScheduleDAO.updateReminderSchedule(map);
		
		return 0;
	}

	@Override
	public void deleteSchedule(String scheduleId, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_SCHEDULEID", scheduleId);
		map.put("v_TENANTID", tenantID);
				
		ezScheduleDAO.deleteScheduleRepeChild(map);
		ezScheduleDAO.deleteScheduleAttach(map);
		ezScheduleDAO.deleteAttendant(map);
		/* 2023-09-04 한태훈 미리알림 스케줄러에서 제외 */
		ezScheduleDAO.deleteReminderSchedule(map);
		ezScheduleDAO.deleteSchedule(map);
		/* 2021-11-26 홍승비 - 일정 삭제 시 일정완료 레코드도 삭제 */
		ezScheduleDAO.deleteScheduleComplete(map);
	}	

	@Override
	public void deleteResource(String scheduleId, int tenantId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_SCHEDULEID", scheduleId);
		map.put("v_TENANTID", tenantId);
		
		List<ResGetScheduleVO> list = ezScheduleDAO.getResourceSchedule(map);
		
		//자원 반복예약일 경우 자원 반복정보 삭제
		for (ResGetScheduleVO vo : list) {
			if (vo.getReFlag().equals("1")) {
				ezResourceService.deleteRepetition(vo.getOwnerID(), vo.getNum(), vo.getCompanyID(), tenantId);
			}
		}
		
		ezScheduleDAO.deleteResource(map);
	}

	@Override
	public int getResourceCount(String scheduleId, int tenantId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_SCHEDULEID", scheduleId);
		map.put("v_TENANTID", tenantId);
		
		int cnt = ezScheduleDAO.getResourceCount(map);
		
		return cnt;		
	}

	@Override
	public void scheduleDelAttendant(String scheduleId, String attendantId, int tenantId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_SCHEDULEID", scheduleId);
		map.put("v_ATTENDANTID", attendantId);
		map.put("v_TENANTID", tenantId);		
		
		ezScheduleDAO.deleteAttendantID(map);
		ezScheduleDAO.deleteAttendantSchedule(map);
		ezScheduleDAO.deleteAttendantReminderSchedule(map); // 2023-10-27 한태훈 - 참석자 제외의 경우 미리알림에서도 제외
		
		int cnt = ezScheduleDAO.getAttendantCount(map);
		
		if (cnt == 0) {
			updateAttendantSchedule("N", scheduleId, tenantId);
		}
		
	}

	@Override
	public void insertScheduleAttendant(String scheduleId, String attendantId, String attendantName, String attendantName2, String attendantDeptName, String attendantDeptName2, int tenantId, String companyID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_SCHEDULEID", scheduleId);
		map.put("v_ATTENDANTID", attendantId);
		map.put("v_ATTENDANTNAME", attendantName);		
		map.put("v_ATTENDANTNAME2", attendantName2);
		map.put("v_ATTENDANTDEPTNAME", attendantDeptName);
		map.put("v_ATTENDANTDEPTNAME2", attendantDeptName2);
		map.put("v_TENANTID", tenantId);
		map.put("v_COMPANYID", companyID);
		
		ezScheduleDAO.insertScheduleAttendant(map);		
	}

	@Override
	public void updateAttendantSchedule(String hasAttendant, String scheduleId,	int tenantId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_HASATTENDANT", hasAttendant);
		map.put("v_SCHEDULEID", scheduleId);
		map.put("v_TENANTID", tenantId);		
		
		ezScheduleDAO.updateAttendantSchedule(map);
	}

	@Override
	public List<ScheduleReceiveListVO> getReceiveList(String id, int tenantId, String offSetMin, String companyID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_USERID", id);
		map.put("v_TENANTID", tenantId);
		map.put("v_OFFSETMIN", offSetMin);		
		
		List<ScheduleReceiveListVO> sList = ezScheduleDAO.getReceiveList(map);
		
		return sList;
	}

	@Override
	public void updateAttendant(String scheduleId, String attendantId, String displayName, String displayName2, String status, int tenantId, String showtop, String lang, String offSet) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
				
		map.put("v_SCHEDULEID", scheduleId);
		map.put("v_ATTENDANTID", attendantId);
		map.put("v_ATTENDANTNAME", displayName);		
		map.put("v_ATTENDANTNAME2", displayName2);
		map.put("v_STATUS", status);
		map.put("v_TENANTID", tenantId);
		map.put("v_SHOWTOP", showtop);

		ezScheduleDAO.updateAttendantStatus(map);
		
		if (status.equals("1")) {
			ezScheduleDAO.insertAttendantSchedule(map);
			ezScheduleDAO.insertAttendantScheduleDel(map);
			/* 2021-11-29 홍승비 - 참석자 초대 수락 시, 부모 일정의 일정완료 레코드도 동일하게 삽입 */
			ezScheduleDAO.insertAttendantScheduleComplete(map);
			
			ScheduleInfoVO scheduleInfo = getScheduleInfo(scheduleId, commonUtil.getMinuteUTC(offSet), tenantId, "");
			/* 2023-09-04 한태훈 - 개인 일정의 경우 미리알림 스케줄러에 데이터 추가 */
			if (scheduleInfo.getScheduleType().equals("1")) {
				map.put("scheInfo", scheduleInfo);
				map.put("v_REMINDERSTATUS", "0");
				map.put("v_OFFSET", offSet);
				map.put("v_LANG", lang);
				map.put("v_OFFSETMIN", commonUtil.getMinuteUTC(offSet));
				map.put("v_STARTDATE", commonUtil.getDateStringInUTC(scheduleInfo.getStartDate(), offSet, true));
				map.put("v_ENDDATE", commonUtil.getDateStringInUTC(scheduleInfo.getEndDate(), offSet, true));
				
				if (ezScheduleDAO.checkReminderScheduleExists(map) > 0) {
					ezScheduleDAO.updateReminderSchedule(map);
				} else {
					ezScheduleDAO.insertAttendantReminderSchedule(map);
				}
			}
		}
	}

	@Override
	public List<ScheduleGroupListVO> getInviteScheduleGroupList(String id, int tenantId, String offSetMin, String companyID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_USERID", id);
		map.put("v_TENANTID", tenantId);
		map.put("v_OFFSETMIN", offSetMin);
		
		List<ScheduleGroupListVO> iList = ezScheduleDAO.getInviteScheduleGroupList(map);
		
		return iList;
	}

	@Override
	public void insertScheduleRepeDel(String scheduleId, String startDate, int tenantId, String companyID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_SCHEDULEID", scheduleId);
		map.put("v_STARTDATE", startDate);
		map.put("v_TENANTID", tenantId);
		map.put("v_COMPANYID", companyID);
		
		ezScheduleDAO.insertScheduleRepeDel(map);
		ezScheduleDAO.insertScheduleRepeDelChild(map);
	}

	@Override
	public void deleteScheduleRepe(String scheduleId, int tenantId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_SCHEDULEID", scheduleId);		
		map.put("v_TENANTID", tenantId);		
		
		ezScheduleDAO.deleteScheduleRepe(map);
		ezScheduleDAO.deleteScheduleComplete(map); // 전체 반복일정 삭제 시 일정완료 레코드도 함께 삭제
	}

	@Override
	public void updateDragSchedule(String scheduleid, String userId, String displayName1, String displayName2, String utcStartTime, String utcEndTime,int tenantId, String companyID, String datetype, String repetition, String title) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_SCHEDULEID", scheduleid);
		map.put("v_MODIFIERID", userId);
		map.put("v_MODIFIERNAME", displayName1);
		map.put("v_MODIFIERNAME2", displayName2);
		map.put("v_STARTDATE", utcStartTime);
		map.put("v_ENDDATE", utcEndTime);
		map.put("v_TENANTID", tenantId);
		map.put("v_COMPANYID", companyID);
		map.put("v_TITLE", title);

		ezScheduleDAO.updateDragSchedule(map);
		
		//해당 일정이 완료 일정이라면, 완료일정의 시작시각과 끝 시각 변경.
		ezScheduleDAO.updateScheduleComplete(map);
		
		// 미리알림 스케줄러 미완료 상태로 변경.
		map.put("v_REMINDERSTATUS", "0");
		ezScheduleDAO.updateReminderSchedule(map);

	}

	@Override
	public void copySchedule(String dragId, String startDate, String endDate, String defaultPath, String offSetMin, int tenantId, String companyId, String lang, String offSet, String completeFG) throws Exception {
		
		ScheduleInfoVO info = getScheduleInfo(dragId, offSetMin, tenantId, companyId);
		
		String[] Repetition = info.getRepetition().split("\\|");
		String dateType = Repetition[1].equals("0") ? "1" : "2"; //info[0]이면시간지정
		logger.debug("Repetition[1]: " + Repetition[1]);
		logger.debug("dateType: " + dateType);
		
		String mhtPath      = commonUtil.separator + "doc";
		String attachPath   = commonUtil.separator + "uploadFile";
		String schedulePath = commonUtil.separator + "{" + UUID.randomUUID().toString() + "}" + ".mht";
		String resultPath   = mhtPath + schedulePath;
		copyMhtFile(defaultPath, mhtPath, info.getContentPath(), resultPath);
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_OWNERID", info.getOwnerId());
		map.put("v_OWNERNAME", info.getOwnerName());
		map.put("v_OWNERNAME2", info.getOwnerName2());
		map.put("v_CREATORID", info.getCreatorId());
		map.put("v_CREATORNAME", info.getCreatorName());
		map.put("v_CREATORNAME2", info.getCreatorName2());
		map.put("v_SCHEDULETYPE", info.getScheduleType());
		map.put("v_IMPORTANCE", info.getImportance());
		map.put("v_HASATTENDANT", info.getHasAttendant());
		map.put("v_HASATTACH", info.getHasAttach());
		map.put("v_ISPUBLIC", info.getIsPublic());
		map.put("v_DATETYPE", dateType);
		map.put("v_STARTDATE", startDate);
		map.put("v_ENDDATE", endDate);
		map.put("v_REPETITION", null);
		map.put("v_TITLE", info.getTitle());
		map.put("v_LOCATION", info.getLocation());
		map.put("v_CONTENTPATH", resultPath);
		map.put("v_TENANTID", tenantId);
		map.put("v_COMPANYID", companyId);
		
		ezScheduleDAO.insertSchedule(map);
		int scheduleId = ezScheduleDAO.getCurScheduleId(null);
		
		//Save attach
		List<AttachListVO> attachList = getAttachList(dragId, tenantId);
		copyAttach(scheduleId, defaultPath, attachPath, attachList, tenantId);
		
		//Save attendList
		List<AttendantListVO> attendList = getAttendantList(dragId, offSetMin, tenantId, companyId);
		for (int i = 0; i < attendList.size(); i++) {
			String attendantId = attendList.get(i).getAttendantId();
			String attendantName = attendList.get(i).getAttendantName();
			String attendantName2 = attendList.get(i).getAttendantName2();
			String attendantDeptName = attendList.get(i).getAttendantDeptName();
			String attendantDeptName2 = attendList.get(i).getAttendantDeptName2();
			
			insertScheduleAttendant(Integer.toString(scheduleId), attendantId, attendantName, attendantName2, attendantDeptName, attendantDeptName2, tenantId, companyId);
		}
		// 2023-09-04 한태훈 - 개인 일정의 경우 미리알림 스케줄러에 데이터 추가
		if (info.getScheduleType().equals("1")) {
			map.put("v_SCHEDULEID", scheduleId);
			map.put("v_REMINDERSTATUS", "0");
			map.put("v_OFFSET", offSet);
			map.put("v_LANG", lang);
			map.put("v_OFFSETMIN", commonUtil.getMinuteUTC(offSet));
			
			ezScheduleDAO.insertReminderSchedule(map);
		}
		
		if (completeFG != null && completeFG.equals("Y")) { // 일정완료 삽입
        	insertScheduleComplete(scheduleId + "", "0", "N", startDate, tenantId, companyId);
        }
	}
	
	private String copyMhtFile(String defaultPath, String mhtPath, String contentPath, String resultPath) throws Exception {
		logger.debug("copyMhtFile start");
		logger.debug(defaultPath);
		
		File file = new File(commonUtil.detectPathTraversal(defaultPath + mhtPath));
		if (!file.exists()) {
			file.mkdirs();
		}
		
		String newContentPath  = commonUtil.detectPathTraversal(defaultPath + resultPath);
		String orgContentPath  = commonUtil.detectPathTraversal(defaultPath + contentPath);
		
		try {
			FileUtils.copyFile(new File(orgContentPath), new File(newContentPath));
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}
		
		logger.debug("copyMhtFile ended");
		
		return resultPath;
	}
	
	private void copyAttach(int scheduleId, String defaultPath, String attachPath, List<AttachListVO> attachList, int tenantId) throws Exception {
		logger.debug("copyAttach start");
		
		File file = new File(commonUtil.detectPathTraversal(defaultPath + attachPath));
		if (!file.exists()) {
			file.mkdirs();
		}

		String orgFileName;
		int orgFileDot;
		String orgFilePath;
		String destFilePath;
		
		Map<String, Object> attachMap = new HashMap<String, Object>();
		for (int i = 0; i < attachList.size(); i++) {
			
			orgFileName  = attachList.get(i).getFileName();
			orgFilePath  = attachList.get(i).getFilePath();
			orgFileDot   = orgFileName.indexOf(".");
			destFilePath = attachPath + commonUtil.separator + "{" + UUID.randomUUID() + "}_" + orgFileName.substring(orgFileDot);
			
			attachMap.put("v_SCHEDULEID", scheduleId);
			attachMap.put("v_FILENAME", attachList.get(i).getFileName());
			attachMap.put("v_FILEPATH", destFilePath);
			attachMap.put("v_FILESIZE", attachList.get(i).getFileSize());
			attachMap.put("v_TENANTID", tenantId);
			
			ezScheduleDAO.insertScheduleAttach(attachMap);
			FileUtils.copyFile(new File(commonUtil.detectPathTraversal(defaultPath + orgFilePath)), new File(commonUtil.detectPathTraversal(defaultPath + destFilePath)));
		}
		logger.debug("copyAttach ended");
	}
	
	@Override
	public void scheduleSendMail(int scheduleId, String v_attendantId, String v_attendantName, String title, String periodContent, String type, LoginVO userInfo, String loginCookie, String startDate, String endDate) throws Exception {
		String subject = "";
		StringBuilder bodyContent = new StringBuilder("");
		
		switch(type) {
			case "add" :	// 참석자 추가
				subject = egovMessageSource.getMessage("ezSchedule.kmss01", userInfo.getLocale());
				
				bodyContent.append(" " + userInfo.getDisplayName() + egovMessageSource.getMessage("ezSchedule.kmss02", userInfo.getLocale()) +  "</br><br>" + " ");
				//bodyContent.append(" &nbsp;&nbsp;- " + egovMessageSource.getMessage("ezCircular.t32", userInfo.getLocale()) + " : " + "<span id='schedule_read' style=\"color:blue;cursor:pointer;text-decoration:underline;\" onclick=\"javascript:open_schedule('" + scheduleId + "')\">" + commonUtil.cleanValue(title) + "</span></br>");
				bodyContent.append(" &nbsp;&nbsp;- " + egovMessageSource.getMessage("ezCircular.t32", userInfo.getLocale()) + " : " + "<span id='schedule_read' >" + commonUtil.cleanValue(title) + "</span></br>");
				bodyContent.append(periodContent);
				bodyContent.append("<br><br> &nbsp;&nbsp; <span id='attendanceChk' style=\"color:blue;cursor:pointer;text-decoration:underline;\" onclick='openAttendChk()'>" + egovMessageSource.getMessage("ezSchedule.mail.hth03", userInfo.getLocale()) + "</span>");
				
				//bodyContent.append("<br><br>" + "<span id='schedule_read' style=\"color:blue;cursor:pointer;text-decoration:underline;\" onclick=\"javascript:window.open('/ezSchedule/scheduleIndex.do?funCode=2', '', 'width=1400px, height=900px, status = no, toolbar=no, menubar=no,location=no, resizable=1, scrollbars=0' )\">" + egovMessageSource.getMessage("ezEmail.t805", userInfo.getLocale()) + "</span></br>");
				break;
			case "del" :		// 참석자 삭제
				subject = egovMessageSource.getMessage("ezSchedule.kmss03", userInfo.getLocale());
				
				bodyContent.append(" " + userInfo.getDisplayName() + egovMessageSource.getMessage("ezSchedule.kmss04", userInfo.getLocale()) + "</br><br>" + " ");
				bodyContent.append(" &nbsp;&nbsp;- " + egovMessageSource.getMessage("ezCircular.t32", userInfo.getLocale()) + " : " + commonUtil.cleanValue(title) + "</br>");
				bodyContent.append(periodContent);
				bodyContent.append("<br><br> &nbsp;&nbsp; <span id='scheduleInfo' style=\"color:blue;cursor:pointer;text-decoration:underline;\" scheduleId='" + scheduleId + "' startDate='" + startDate + "' endDate='" + endDate + "' date='" + startDate + "' onclick='openScheduleInfo()'>" + egovMessageSource.getMessage("ezSchedule.mail.hth03", userInfo.getLocale()) + "</span>");
				break;
			case "acc" :		// 참석 수락
				subject = egovMessageSource.getMessage("ezSchedule.kmss05", userInfo.getLocale());
				
				bodyContent.append(" " + userInfo.getDisplayName() + egovMessageSource.getMessage("ezSchedule.kmss06", userInfo.getLocale()) + "</br><br>" + " ");
				//bodyContent.append(" &nbsp;&nbsp;- " + egovMessageSource.getMessage("ezCircular.t32", userInfo.getLocale()) + " : " + "<span id='schedule_read' style=\"color:blue;cursor:pointer;text-decoration:underline;\" onclick=\"javascript:open_schedule('" + scheduleId + "')\">" + commonUtil.cleanValue(title) + "</span></br>");
				bodyContent.append(" &nbsp;&nbsp;- " + egovMessageSource.getMessage("ezCircular.t32", userInfo.getLocale()) + " : " + "<span id='schedule_read' >" + commonUtil.cleanValue(title) + "</span></br>");
				bodyContent.append(periodContent);
				bodyContent.append("<br><br> &nbsp;&nbsp; <span id='scheduleInfo' style=\"color:blue;cursor:pointer;text-decoration:underline;\" scheduleId='" + scheduleId + "' startDate='" + startDate + "' endDate='" + endDate + "' date='" + startDate + "' onclick='openScheduleInfo()'>" + egovMessageSource.getMessage("ezSchedule.mail.hth03", userInfo.getLocale()) + "</span>");
				//bodyContent.append("<br><br>" + "<span id='schedule_read' style=\"color:blue;cursor:pointer;text-decoration:underline;\" onclick=\"javascript:window.open('/ezSchedule/scheduleIndex.do?funCode=2', '', 'width=1400px, height=900px, status = no, toolbar=no, menubar=no,location=no, resizable=1, scrollbars=0' )\">" + egovMessageSource.getMessage("ezEmail.t805", userInfo.getLocale()) + "</span></br>");
				break;
			case "rej" :		// 참석 거절
				subject = egovMessageSource.getMessage("ezSchedule.kmss07", userInfo.getLocale());
				
				bodyContent.append(" " + userInfo.getDisplayName() + egovMessageSource.getMessage("ezSchedule.kmss08", userInfo.getLocale()) + "</br><br>" + " ");
				//bodyContent.append(" &nbsp;&nbsp;- " + egovMessageSource.getMessage("ezCircular.t32", userInfo.getLocale()) + " : " + "<span id='schedule_read' style=\"color:blue;cursor:pointer;text-decoration:underline;\" onclick=\"javascript:open_schedule('" + scheduleId + "')\">" + commonUtil.cleanValue(title) + "</span></br>");
				bodyContent.append(" &nbsp;&nbsp;- " + egovMessageSource.getMessage("ezCircular.t32", userInfo.getLocale()) + " : " + "<span id='schedule_read' >" + commonUtil.cleanValue(title) + "</span></br>");
				bodyContent.append(periodContent);
				bodyContent.append("<br><br> &nbsp;&nbsp; <span id='scheduleInfo' style=\"color:blue;cursor:pointer;text-decoration:underline;\" scheduleId='" + scheduleId + "' startDate='" + startDate + "' endDate='" + endDate + "' date='" + startDate + "' onclick='openScheduleInfo()'>" + egovMessageSource.getMessage("ezSchedule.mail.hth03", userInfo.getLocale()) + "</span>");
				//bodyContent.append("<br><br>" + "<span id='schedule_read' style=\"color:blue;cursor:pointer;text-decoration:underline;\" onclick=\"javascript:window.open('/ezSchedule/scheduleIndex.do?funCode=2', '', 'width=1400px, height=900px, status = no, toolbar=no, menubar=no,location=no, resizable=1, scrollbars=0' )\">" + egovMessageSource.getMessage("ezEmail.t805", userInfo.getLocale()) + "</span></br>");
				break;
		}

    	String content_ = commonUtil.createNotiMailContent(bodyContent.toString(), userInfo.getTenantId(), userInfo.getLocale());

		OrganUserVO AccessUserInfo = ezOrganAdminService.getUserInfo(v_attendantId.trim(), userInfo.getPrimary(), userInfo.getTenantId());
			
		InternetAddress from = new InternetAddress();
		from.setPersonal(userInfo.getDisplayName(), "UTF-8");
		from.setAddress(userInfo.getEmail());
		
		InternetAddress to = new InternetAddress();
		
		to.setPersonal(v_attendantName.trim(), "UTF-8");
		to.setAddress(AccessUserInfo.getMail());
		
		ezEmailService.sendMail(loginCookie, from, new InternetAddress[]{to}, null, null, subject, content_, false);
		
	}
	
	/* 2021-11-25 홍승비 - 일정완료여부 데이터를 삽입하는 메서드 */
	public void insertScheduleComplete(String scheduleId, String repeatCount, String isAllRep, String startdate, int tenantId, String companyID) throws Exception {
		logger.debug("insertScheduleComplete started, scheduleId = " + scheduleId + " / repeatCount = " + repeatCount + " / isAllRep = " + isAllRep);
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_SCHEDULEID", scheduleId);
		map.put("v_REPEATCOUNT", repeatCount);
		map.put("v_ISALLREP", isAllRep);
		map.put("v_STARTDATE", startdate);
		map.put("v_TENANTID", tenantId);
		map.put("v_COMPANYID", companyID);
		
		// SCHEDULEID, REPEATCOUNT, ISALLREP, STARTDATE, TENANT_ID, COMPANYID값이 완전히 일치하는 기존 일정완료 레코드가 존재하는지 체크
		int cnt = ezScheduleDAO.getScheduleCompleteCnt(map);
		if (cnt < 1) { // 레코드가 존재하지 않는 경우에만 삽입
			ezScheduleDAO.insertScheduleComplete(map);
			logger.debug("insertScheduleComplete ended. (new record inserted)");
		} else {
			logger.debug("insertScheduleComplete ended. (record already exists, do nothing)");
		}
		
		// 동일한 SCHEDULEID에 대하여 ISALLREP 칼럼값 중 'Y', 'N'이 모두 존재하는 경우(즉 현재 반복일정 완료 <-> 전체 반복일정 완료 간의 변경이 일어났을 때), 현재 삽입한 레코드를 제외한 다른 레코드를 전부 삭제
		List<String> isAllRepList = ezScheduleDAO.getScheduleCompleteIsAllRep(map);
		if (isAllRepList.contains("Y") && isAllRepList.contains("N")) {
			ezScheduleDAO.deleteScheduleCompleteDiffCurr(map);
		}
	}
	
	/* 2021-11-25 홍승비 - 일정완료 데이터를 삭제하는 메서드 */
	public void deleteScheduleComplete(String scheduleId, String repeatCount, String isAllRep, String startdate, int tenantId, String companyID) throws Exception {
		logger.debug("deleteScheduleComplete started, scheduleId = " + scheduleId + " / repeatCount = " + repeatCount + " / isAllRep = " + isAllRep);
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_SCHEDULEID", scheduleId);
		map.put("v_REPEATCOUNT", repeatCount);
		map.put("v_ISALLREP", isAllRep);
		map.put("v_STARTDATE", startdate);
		map.put("v_TENANTID", tenantId);
		map.put("v_COMPANYID", companyID);
		
		// 단일 일정완료 레코드의 삭제
		if (repeatCount.equals("0")) {
			ezScheduleDAO.deleteScheduleComplete(map);
		}
		// 반복 일정완료 레코드의 삭제
		else {
			List<String> isAllRepList = ezScheduleDAO.getScheduleCompleteIsAllRep(map);
			if (isAllRepList.contains("N")) { // 현재 반복일정 완료 해제
				map.put("v_USECOND_REPCNT_SDATE_ISALLREP", "Y");
				ezScheduleDAO.deleteScheduleComplete(map);
			}
			else if (isAllRepList.contains("Y")) { // 전체 반복일정 완료 해제
				ezScheduleDAO.deleteScheduleComplete(map);
			}
		}
		
		logger.debug("deleteScheduleComplete ended.");
	}
	
	/* 2021-11-26 홍승비 - 해당 반복일정의 일정완료 레코드 삭제 (전체 반복완료 레코드는 유지해야 하므로 삭제조건의 isAllRep값은 'N'으로 고정) */
	public void deleteScheduleCompleteOneRep(String scheduleId, String repeatCount, String isAllRep, String startdate, int tenantId) throws Exception {
		logger.debug("deleteScheduleCompleteOneRep started, scheduleId = " + scheduleId + " / repeatCount = " + repeatCount + " / startdate = " + startdate);
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_SCHEDULEID", scheduleId);
		map.put("v_REPEATCOUNT", repeatCount);
		map.put("v_ISALLREP", isAllRep);
		map.put("v_STARTDATE", startdate);
		map.put("v_TENANTID", tenantId);
		map.put("v_USECOND_REPCNT_SDATE_ISALLREP", "Y");
		
		ezScheduleDAO.deleteScheduleComplete(map);
		
		logger.debug("deleteScheduleCompleteOneRep ended.");
	}
	
	/* 2021-11-26 홍승비 - 일정완료 레코드가 존재하는 경우, 해당 레코드의 ISALLREP 값을 리턴하는 메서드 */
	public String getScheduleCompleteIsAllRep(String scheduleId, String repeatCount, String startdate, String dateType, int tenantId, String companyID) throws Exception {
		logger.debug("getScheduleCompleteIsAllRep started, scheduleId = " + scheduleId + " / repeatCount = " + repeatCount + " / startdate = " + startdate);
		
		String result = "";
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_SCHEDULEID", scheduleId);
		map.put("v_REPEATCOUNT", repeatCount);
		map.put("v_STARTDATE", startdate);
		map.put("v_TENANTID", tenantId);
		map.put("v_COMPANYID", companyID);
		
		// 화면에 표출하기 위한 일정 리스트의 경우, 반복일정의 dateType이 3이 아니므로 repeatCount를 대신 사용한다. (repeatCount = 0인 경우 반드시 단일 일정)
		if (dateType.equals("3") || !repeatCount.equals("0")) {
			map.put("v_USECOND_REPCNT_SDATE", "Y");
		}
		
		List<String> isAllRepList = ezScheduleDAO.getScheduleCompleteIsAllRep(map);
		if (isAllRepList.size() > 0) {
			if (isAllRepList.contains("Y")) {
				result = "Y";
			} else if (isAllRepList.contains("N")) {
				result = "N";
			}
		}
		// 반복일정인 경우, 해당 일정에 대한 일정완료 레코드가 없다면 전체 반복일정 완료 레코드를 확인한다. 
		else if ((dateType.equals("3") || !repeatCount.equals("0")) && isAllRepList.size() <= 0) {
			map.put("v_USECOND_REPCNT_SDATE", "N");
			
			List<String> isAllRepList2 = ezScheduleDAO.getScheduleCompleteIsAllRep(map);
			if (isAllRepList2.size() > 0 && isAllRepList2.contains("Y")) {
				result = "Y";
			}
		}
		
		logger.debug("getScheduleCompleteIsAllRep ended. isAllRep size = {}", result);
		return result;
	}
	
	/* 2021-11-26 홍승비 - 일정 리스트 데이터를 전달받아 일정완료 데이터를 추가 가공하여 리턴 */
	public List<ScheduleInfoVO> applyScheduleCompleteData(List<ScheduleInfoVO> sList, String offset, int tenantId, String companyID) throws Exception {
		logger.debug("applyScheduleCompleteData started. list size = " + sList.size());
		List<ScheduleInfoVO> result = sList;
		
		if (sList.size() > 0) {
			for (int i = 0; i < sList.size(); i++) {
				ScheduleInfoVO tempVO  = sList.get(i);
				
				if (tempVO.getScheduleId() != null && tempVO.getScheduleId().startsWith("collaboration:")) {
					continue;
				}
				
				String isAllRep = "";
				
				isAllRep = getScheduleCompleteIsAllRep(tempVO.getScheduleId(), String.valueOf(tempVO.getRepeatCount()), commonUtil.getDateStringInUTC(tempVO.getStartDate().substring(0, 19), offset, true), tempVO.getDateType(), tenantId, companyID) ;
				
				// 일정완료 레코드가 존재한다면, isAllRep값이 Y 또는 N이다.
				if (!isAllRep.equals("")) {
					sList.get(i).setCompleteFG("Y");
					sList.get(i).setIsAllRep(isAllRep);
					sList.get(i).setRepStartDate(tempVO.getStartDate().substring(0, 19));
				}
				// 공백이라면 일정완료 레코드가 없음
				else {
					sList.get(i).setCompleteFG("N");
					sList.get(i).setIsAllRep("");
					sList.get(i).setRepStartDate("");
				}
			}
		}
		
		logger.debug("applyScheduleCompleteData ended.");
		return result;
	}
	
	@Override
	public ScheduleTokenInfoVO scheduleGetTokenInfo(String userID, int tenantID, String companyID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_USERID", userID);
		map.put("v_COMPANYID", companyID);
		map.put("v_TENANTID", tenantID);
		
		ScheduleTokenInfoVO tokenData = ezScheduleDAO.getScheduleTokenInfo(map);
		
		if (tokenData == null) {
			tokenData = new ScheduleTokenInfoVO();
			tokenData.setUserID(userID);
			tokenData.setTenantID(tenantID);
			tokenData.setCompanyID(companyID);
		}
		
		return tokenData;
	}
	
	@Override
	public void scheduleSaveTokenInfo(String userID, String googleAccessToken, String googleRefreshToken, String todayUtcTime, int tenantID, String companyID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_USERID", userID);
		map.put("v_COMPANYID", companyID);
		map.put("v_TENANTID", tenantID);
		map.put("v_TODAYUTCTIME", todayUtcTime);
		
		ScheduleTokenInfoVO syncData = ezScheduleDAO.getScheduleTokenInfo(map);
		
		map.put("v_GOOGLEACCESSTOKEN", googleAccessToken);
		map.put("v_GOOGLEREFRESHTOKEN", googleRefreshToken);
		
		if (syncData == null) {
			ezScheduleDAO.insertScheduleTokenInfo(map);
		} else {
			ezScheduleDAO.updateScheduleTokenInfo(map);
		}
	}
	
	/* 2023-07-19 홍승비 - 일정그룹의 관리자(그룹장) CREATORID(USERID)값을 리턴하는 메서드 */
	@Override
	public String getScheduleGroupCreatorID(String groupID) throws Exception {
		logger.debug("getScheduleGroupCreatorID started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_GROUPID", groupID); // PRI KEY는 GROUPID만 사용
		
		ScheduleGroupVO creatorVO = ezScheduleDAO.selectCreatorMember(map);
		
		logger.debug("getScheduleGroupCreatorID ended. result = " + creatorVO.getCreatorid());
		return creatorVO.getCreatorid();
	}

	/* 2023-09-22 한태훈 - 일정관리 > 초대 일정 참석 여부 리턴하는 메서드 */
	@Override
	public String selectAttendanceStatus(String scheduleid, String v_attendantId, int tenantId) throws Exception {
		logger.debug("selectAttendanceStatus started.");
		Map<String, Object> map = new HashMap<String,Object>();
		map.put("v_SCHEDULEID", scheduleid);
		map.put("v_ATTENDANTID", v_attendantId);
		map.put("v_TENANTID", tenantId);
		
		logger.debug("selectAttendanceStatus ended.");
		return ezScheduleDAO.selectAttendanceStatus(map);
	}
	
	/* 2023-10-17 한태훈 - 일정관리 > 참석자 초대 일정 수정 시 메일 발송 메서드 */
	@Override
	public void sendInviteModNoti(HttpServletRequest request, String scheduleid, NodeList attendantId, NodeList attendantName, String location, String title, String importance, String ispublic, String startdate, String enddate, String datetype, String repetition, ScheduleInfoVO beforeSche, String repStartdate, String repeatCount, String isAllRep, String completeFG, LoginVO loginVO, String loginCookie) throws Exception {
		logger.debug("sendInviteModNoti started");
		String subject = "";
		StringBuilder bodyContent = new StringBuilder("");
		
		startdate = commonUtil.getDateStringInUTC(startdate, loginVO.getOffset(), false);
   		enddate = commonUtil.getDateStringInUTC(enddate, loginVO.getOffset(), false);
		
		StringBuilder mailContent = new StringBuilder("");
		mailContent.append("<span> * ").append(egovMessageSource.getMessage("ezSchedule.mail.hth04", loginVO.getLocale())).append("</span> <br>");
		if (!beforeSche.getLocation().trim().equals(location.trim())) {
			mailContent = makeScheModMailForm(mailContent, egovMessageSource.getMessage("ezSchedule.t273", loginVO.getLocale()), beforeSche.getLocation(), location, loginVO.getLocale());
		}
		
		if (!beforeSche.getTitle().trim().equals(title.trim())) {
			mailContent = makeScheModMailForm(mailContent, egovMessageSource.getMessage("ezSchedule.t272", loginVO.getLocale()), beforeSche.getTitle(), title, loginVO.getLocale());
		}
		
		if (!beforeSche.getImportance().trim().equals(importance.trim())) {
			mailContent = makeScheModMailForm(mailContent, egovMessageSource.getMessage("ezSchedule.t310", loginVO.getLocale()), decodeColumnValue("importance", beforeSche.getImportance(), loginVO.getLocale()), decodeColumnValue("importance", importance, loginVO.getLocale()), loginVO.getLocale());
		}
		
		if (!beforeSche.getIsPublic().trim().equals(ispublic.trim())) {
			mailContent = makeScheModMailForm(mailContent, egovMessageSource.getMessage("ezSchedule.mail.hth15", loginVO.getLocale()), decodeColumnValue("ispublic", beforeSche.getIsPublic(), loginVO.getLocale()), decodeColumnValue("ispublic", ispublic, loginVO.getLocale()), loginVO.getLocale());
		}
		
		String beforeScheDateContent = makeScheDateContent(beforeSche.getDateType(), beforeSche.getRepetition(), beforeSche.getStartDate(), beforeSche.getEndDate(), loginVO.getLocale());
		String afterScheDateContent = makeScheDateContent(datetype, repetition, startdate, enddate, loginVO.getLocale());
		
		if (!beforeScheDateContent.equals(afterScheDateContent)) {
			mailContent = makeScheModMailForm(mailContent, egovMessageSource.getMessage("ezSchedule.t318", loginVO.getLocale()), beforeScheDateContent, afterScheDateContent, loginVO.getLocale());
		}
		
		String beforeScheTime = makeScheTimeContent(beforeSche.getStartDate(), beforeSche.getEndDate(), beforeSche.getDateType(), beforeSche.getRepetition(), loginVO.getLocale()); 
		String afterScheTime = makeScheTimeContent(startdate, enddate, datetype, repetition, loginVO.getLocale());
				
		if (!beforeScheTime.equals(afterScheTime)) {
			mailContent = makeScheModMailForm(mailContent, egovMessageSource.getMessage("ezSchedule.t67", loginVO.getLocale()), beforeScheTime, afterScheTime, loginVO.getLocale());
		}
		
		String beforeRepetition = makeRepetitionContent(beforeSche.getRepetition(), loginVO.getLocale());
		String afterRepetition = makeRepetitionContent(repetition, loginVO.getLocale());
		
		if (!beforeRepetition.equals(afterRepetition)) {
			mailContent = makeScheModMailForm(mailContent, egovMessageSource.getMessage("ezSchedule.t71", loginVO.getLocale()), beforeRepetition, afterRepetition, loginVO.getLocale());
		}
		
		String beforeScheIsAllRep = "";
        String beforeScheCompleteFG = "N";
        if (!scheduleid.equals("")) {
        	beforeScheIsAllRep = getScheduleCompleteIsAllRep(scheduleid, repeatCount, commonUtil.getDateStringInUTC(repStartdate, loginVO.getOffset(), true), beforeSche.getDateType(), loginVO.getTenantId(), loginVO.getCompanyID());
        	if (!beforeScheIsAllRep.equals("")) { // 해당 일정에 대한 완료여부 레코드가 존재한다면 completeFG 설정
        		beforeScheCompleteFG = "Y";
        	}
        }
        
        String beforeCompletContent = makeCompleteContent(beforeSche.getDateType(), beforeScheIsAllRep, beforeScheCompleteFG, beforeSche.getRepStartDate(), loginVO.getLocale());
		String afterCompleteContent = makeCompleteContent(datetype, isAllRep, completeFG, repStartdate, loginVO.getLocale());
		
		if (!beforeCompletContent.equals(afterCompleteContent)) {
			mailContent = makeScheModMailForm(mailContent, egovMessageSource.getMessage("ezSchedule.mail.hth05", loginVO.getLocale()), beforeCompletContent, afterCompleteContent, loginVO.getLocale());
		}
		
		String creatorName = "";
		if (commonUtil.getPrimaryData(loginVO.getLang(), loginVO.getTenantId()).equals("1")) {
			creatorName = beforeSche.getCreatorName();
		} else {
			creatorName = beforeSche.getCreatorName2();
		}
		
		InternetAddress from = new InternetAddress();
		from.setPersonal(creatorName, "UTF-8");
		from.setAddress(ezOrganService.getPropertyValue(beforeSche.getCreatorId(), "mail", loginVO.getTenantId()));
		
		List<InternetAddress> toList = new ArrayList<>();
		List<Map<String,Object>> notiRecipientList = new ArrayList<Map<String, Object>> ();
		for (int i = 0; i < attendantId.getLength(); i++) {						
			String v_attendantId = attendantId.item(i).getTextContent();				
			String v_attendantName = attendantName.item(i).getTextContent();
			String attendanceStatus = selectAttendanceStatus(scheduleid, v_attendantId, loginVO.getTenantId());
			if (attendanceStatus != null && attendanceStatus.equals("1")) {
				if (!ezPersonalService.hasNotiDiableItem(v_attendantId, NotiType.SCHEDULE_MOD, NotiPlatform.MAIL, loginVO.getTenantId())) {
					InternetAddress to = new InternetAddress();
					to.setPersonal(v_attendantName.trim(), "UTF-8");
					to.setAddress(ezOrganService.getPropertyValue(v_attendantId, "mail", loginVO.getTenantId()));
					toList.add(to);
					Map<String, Object> recipientMap = new HashMap<String, Object>();
	        		recipientMap.put("userType", "PERSON");
	        		recipientMap.put("companyId", loginVO.getCompanyID());
	        		recipientMap.put("cn", v_attendantId);
	        		notiRecipientList.add(recipientMap);
				}
			}
		}
		
		if (toList.size() <= 0) {
			return;
		}
		
		subject = egovMessageSource.getMessage("ezSchedule.mail.hth01", loginVO.getLocale());
		bodyContent.append(" " + creatorName + egovMessageSource.getMessage("ezSchedule.mail.hth02", loginVO.getLocale()) + " ");
		bodyContent.append("(" + egovMessageSource.getMessage("ezSchedule.mail.hth06", loginVO.getLocale()) + " : " + beforeSche.getTitle() + " - ");
		bodyContent.append(beforeScheDateContent + " ");
		bodyContent.append(beforeScheTime + ")" + "<br><br>");
		bodyContent.append(mailContent.toString());
		
		if (Integer.parseInt(repeatCount) > 0) {
			bodyContent.append("<br><br> &nbsp;&nbsp; <span id='scheduleInfo' style=\"color:blue;cursor:pointer;text-decoration:underline;\" scheduleId='" + scheduleid + "' startDate='" + startdate + "' endDate='" + enddate + "' date='" + repStartdate + "' repeatcount='" + repeatCount + "' onclick='openScheduleInfo()'>" + egovMessageSource.getMessage("ezSchedule.mail.hth03", loginVO.getLocale()) + "</span>");
		} else {
			bodyContent.append("<br><br> &nbsp;&nbsp; <span id='scheduleInfo' style=\"color:blue;cursor:pointer;text-decoration:underline;\" scheduleId='" + scheduleid + "' startDate='" + startdate + "' endDate='" + enddate + "' date='" + startdate + "' onclick='openScheduleInfo()'>" + egovMessageSource.getMessage("ezSchedule.mail.hth03", loginVO.getLocale()) + "</span>");
		}
		
		String content_ = commonUtil.createNotiMailContent(bodyContent.toString(), loginVO.getTenantId(), loginVO.getLocale());
		ezEmailService.sendMail(loginCookie, from, toList.toArray(new InternetAddress[toList.size()]), null, null, subject, content_, false);
		
		String linkUrl = "";
		String linkUrlMobile = "";
		if (Integer.parseInt(repeatCount) > 0) {
			linkUrl = "/ezSchedule/scheduleRead.do?id=" + scheduleid + "&repeatCount=" + repeatCount;
			linkUrlMobile = "/mobile/ezSchedule/mScheduleDetail.do?scheduleId=" + scheduleid + "&startDate=" + startdate + "&endDate=" + enddate + "&date=" + repStartdate + "&repeatCount=" + repeatCount + "&type=monthList" + "&purpose=scheduleInfoDetail" ;
	    } else {
	    	linkUrl = "/ezSchedule/scheduleRead.do?id=" + scheduleid + "&isReceive=Y";
	    	linkUrlMobile = "/mobile/ezSchedule/mScheduleDetail.do?scheduleId=" + scheduleid + "&startDate=" + startdate + "&endDate=" + enddate + "&date=" + startdate + "&type=monthList" + "&purpose=scheduleInfoDetail";
	    }
		
		
		ezNotificationService.sendNoti(request, beforeSche.getCreatorId(), creatorName, notiRecipientList, "SCHEDULE", "MOD", title, "popup", "760", "750", linkUrl, linkUrlMobile, "");
		logger.debug("sendInviteModNoti ended");
				
	}
	
	// 2024-11-19 한태훈 - 일정관리 > 초대 일정 드래그로 수정 시 메일 및 알림 발송 메서드
	// 반복일정이 아닌 경우에만 수정 메일 발송.
	@Override
	public void sendInviteModNotiForDrag(HttpServletRequest request, String dragId, ScheduleInfoVO beforeSche, String startDate, String endDate, LoginVO loginVO, String loginCookie) throws Exception {
		String subject = "";
		StringBuilder bodyContent = new StringBuilder("");
		StringBuilder mailContent = new StringBuilder("");
		mailContent.append("<span> * ").append(egovMessageSource.getMessage("ezSchedule.mail.hth04", loginVO.getLocale())).append("</span> <br>");
		String beforeScheDateContent = makeScheDateContent(beforeSche.getDateType(), beforeSche.getRepetition(), beforeSche.getStartDate(), beforeSche.getEndDate(), loginVO.getLocale());
		String afterScheDateContent = makeScheDateContent("1", "", startDate, endDate, loginVO.getLocale());
		
		if (!beforeScheDateContent.equals(afterScheDateContent)) {
			mailContent = makeScheModMailForm(mailContent, egovMessageSource.getMessage("ezSchedule.t318", loginVO.getLocale()), beforeScheDateContent, afterScheDateContent, loginVO.getLocale());
		}
		
		String beforeScheTime = makeScheTimeContent(beforeSche.getStartDate(), beforeSche.getEndDate(), beforeSche.getDateType(), beforeSche.getRepetition(), loginVO.getLocale()); 
				
		String creatorName = "";
		if (commonUtil.getPrimaryData(loginVO.getLang(), loginVO.getTenantId()).equals("1")) {
			creatorName = beforeSche.getCreatorName();
		} else {
			creatorName = beforeSche.getCreatorName2();
		}
		
		InternetAddress from = new InternetAddress();
		from.setPersonal(creatorName, "UTF-8");
		from.setAddress(ezOrganService.getPropertyValue(beforeSche.getCreatorId(), "mail", loginVO.getTenantId()));
		
		List<InternetAddress> toList = new ArrayList<>();
		List<Map<String,Object>> notiRecipientList = new ArrayList<Map<String, Object>> ();
		
		String hasAttendant = beforeSche.getHasAttendant();
        if (hasAttendant.equals("Y")) {            	
            String parentId = (beforeSche.getParentId().equals("0") ? dragId : beforeSche.getParentId());                
            List<AttendantListVO> attendantList = getAttendantList(parentId, commonUtil.getMinuteUTC(loginVO.getOffset()), loginVO.getTenantId(), loginVO.getCompanyID());
            
            for (int i = 0; i < attendantList.size(); i++) {
            	AttendantListVO attendant = attendantList.get(i);
    			String v_attendantId = attendant.getAttendantId();				
    			String v_attendantName = attendant.getAttendantName();
    			String attendanceStatus = selectAttendanceStatus(dragId, v_attendantId, loginVO.getTenantId());
    			if (attendanceStatus != null && attendanceStatus.equals("1")) {
    				if (!ezPersonalService.hasNotiDiableItem(v_attendantId, NotiType.SCHEDULE_MOD, NotiPlatform.MAIL, loginVO.getTenantId())) {
    					InternetAddress to = new InternetAddress();
    					to.setPersonal(v_attendantName.trim(), "UTF-8");
    					to.setAddress(ezOrganService.getPropertyValue(v_attendantId, "mail", loginVO.getTenantId()));
    					toList.add(to);
    					Map<String, Object> recipientMap = new HashMap<String, Object>();
    	        		recipientMap.put("userType", "PERSON");
    	        		recipientMap.put("companyId", loginVO.getCompanyID());
    	        		recipientMap.put("cn", v_attendantId);
    	        		notiRecipientList.add(recipientMap);
    				}
    			}
    		}
        }
        
        if (toList.size() <= 0) {
			return;
		}
		
		subject = egovMessageSource.getMessage("ezSchedule.mail.hth01", loginVO.getLocale());
		bodyContent.append(" " + creatorName + egovMessageSource.getMessage("ezSchedule.mail.hth02", loginVO.getLocale()) + " ");
		bodyContent.append("(" + egovMessageSource.getMessage("ezSchedule.mail.hth06", loginVO.getLocale()) + " : " + beforeSche.getTitle() + " - ");
		bodyContent.append(beforeScheDateContent + " ");
		bodyContent.append(beforeScheTime + ")" + "<br><br>");
		bodyContent.append(mailContent.toString());
		
		bodyContent.append("<br><br> &nbsp;&nbsp; <span id='scheduleInfo' style=\"color:blue;cursor:pointer;text-decoration:underline;\" scheduleId='" + dragId + "' startDate='" + startDate + "' endDate='" + endDate + "' date='" + startDate + "' onclick='openScheduleInfo()'>" + egovMessageSource.getMessage("ezSchedule.mail.hth03", loginVO.getLocale()) + "</span>");
		
		String content_ = commonUtil.createNotiMailContent(bodyContent.toString(), loginVO.getTenantId(), loginVO.getLocale());
		ezEmailService.sendMail(loginCookie, from, toList.toArray(new InternetAddress[toList.size()]), null, null, subject, content_, false);
		
		String linkUrl = "";
		String linkUrlMobile = "";
		
    	linkUrl = "/ezSchedule/scheduleRead.do?id=" + dragId + "&isReceive=Y";
    	linkUrlMobile = "/mobile/ezSchedule/mScheduleDetail.do?scheduleId=" + dragId + "&startDate=" + startDate + "&endDate=" + endDate + "&date=" + startDate + "&type=monthList" + "&purpose=scheduleInfoDetail";
		
		ezNotificationService.sendNoti(request, beforeSche.getCreatorId(), creatorName, notiRecipientList, "SCHEDULE", "MOD", beforeSche.getTitle(), "popup", "760", "750", linkUrl, linkUrlMobile, "");
	}
	
	// 2023-09-25 한태훈 - 일정관리 > 참석자 초대 일정 수정 알림 메일 전송시 변경 내용 양식 만들기
	@Override
	public StringBuilder makeScheModMailForm(StringBuilder mailContent, String category, String beforeContent, String afterContent, Locale locale) throws Exception {
    	mailContent.append("<span> - ");
    	mailContent.append(category);
    	mailContent.append(" : ");
		mailContent.append(beforeContent == null || beforeContent.trim().equals("") ? egovMessageSource.getMessage("ezSchedule.mail.hth11", locale) : beforeContent);
		mailContent.append(" -&gt; ");
		mailContent.append(afterContent == null || afterContent.trim().equals("") ? egovMessageSource.getMessage("ezSchedule.mail.hth11", locale) : afterContent);
		mailContent.append("</span><br>");
    	return mailContent;
    }
    
	// 2023-09-25 한태훈 - 일정관리 > 참석자 초대 일정 수정 알림 메일 전송시 중요도, 공개여부 컬럼 코드값 변경
	@Override
    public String decodeColumnValue(String column, String originString, Locale locale) throws Exception {
    	String returnStr = "";
    	switch (column) {
		case "importance":
			String [] returnString = {egovMessageSource.getMessage("ezSchedule.t325", locale), egovMessageSource.getMessage("ezSchedule.t326", locale), egovMessageSource.getMessage("ezSchedule.t327", locale)};
	    	returnStr = returnString[Integer.parseInt(originString.trim()) - 1];
			break;

		case "ispublic":
			if (originString.equalsIgnoreCase("Y")) {
				returnStr = egovMessageSource.getMessage("ezSchedule.t359", locale);
	    	} else if (originString.equalsIgnoreCase("N")) {
	    		returnStr = egovMessageSource.getMessage("ezSchedule.t360", locale);
	    	}
			break;
		}
    	
    	return returnStr;
    }
	
	// 2023-09-25 한태훈 - 일정관리 > 참석자 초대 일정 수정 알림 메일 전송시 일정 기간 내용 만들기
	@Override
	public String makeScheDateContent(String dateType, String repetition, String startDate, String endDate, Locale locale) throws Exception {
		StringBuilder retStr = new StringBuilder();
		switch (dateType) {
		case("1") :
		case("2") :
			retStr.append(startDate.substring(0, 10));
			retStr.append(" ~ ");
			retStr.append(endDate.substring(0, 10));
			break;
		case("3") : 
			String [] repetitionMethod = repetition.split("\\|");
			retStr.append(startDate.substring(0, 10));
			retStr.append(" ~ ");
			if (repetitionMethod[0].equals("0")) {
				retStr.append(endDate.substring(0, 10));
			} else if (repetitionMethod[0].equals("-1")) {
				retStr.append(egovMessageSource.getMessage("ezSchedule.t111", locale));
			} else if (Integer.parseInt(repetitionMethod[0]) > 0) {
				retStr.append(egovMessageSource.getMessage("ezSchedule.mail.hth26", locale));
				retStr.append(repetitionMethod[0] + egovMessageSource.getMessage("ezSchedule.mail.hth27", locale));
			}
			break;
		}
		
		return retStr.toString();
	}
	
	// 2023-09-25 한태훈 - 일정관리 > 참석자 초대 일정 수정 알림 메일 전송 시 시간 내용 만들기
	@Override
	public String makeScheTimeContent(String startdate, String enddate, String datetype, String repetition, Locale locale) throws Exception {
		String retStr = "";
		
		if (datetype.equals("2") || (datetype.equals("3") && repetition.split("\\|")[1].equals("1"))) {
			retStr = egovMessageSource.getMessage("ezSchedule.t128", locale);
		} else if (datetype.equals("1") || (datetype.equals("3") && repetition.split("\\|")[1].equals("0"))) {
			retStr = startdate.substring(11, 16) + " ~ "  + enddate.substring(11, 16);
		}
		
		return retStr;
	}
	
	// 2023-09-25 한태훈 - 일정관리 > 참석자 초대 일정 수정 알림 메일 전송 시 반복주기 내용 만들기
	@Override
	public String makeRepetitionContent(String repetition, Locale locale) throws Exception {
		StringBuilder retStr = new StringBuilder();
		if (repetition == null || repetition.trim().equals("")) {
			retStr.append(egovMessageSource.getMessage("ezSchedule.mail.hth11", locale));
			return retStr.toString();
		}
		
		String[] repetMethod = repetition.split("\\|"); 
		String[] dayArr = {egovMessageSource.getMessage("ezSchedule.t81", locale), egovMessageSource.getMessage("ezSchedule.t82", locale), egovMessageSource.getMessage("ezSchedule.t83", locale), egovMessageSource.getMessage("ezSchedule.t84", locale), egovMessageSource.getMessage("ezSchedule.t85", locale), egovMessageSource.getMessage("ezSchedule.t86", locale), egovMessageSource.getMessage("ezSchedule.t87", locale)};
		String[] weekArr = egovMessageSource.getMessage("ezSchedule.mail.hth28", locale).split("\\|");
		switch (repetMethod[2]) {
		case "0":
			if (repetMethod[3].equals("0")) {
				retStr.append(egovMessageSource.getMessage("ezSchedule.mail.hth12", locale)); // 매 평일 반복
			}
			else if (repetMethod[3].equals("1")) {
				retStr.append(egovMessageSource.getMessage("ezSchedule.mail.hth13", locale)); // 매일 반복
			} else {
				retStr.append(egovMessageSource.getMessage("ezSchedule.mail.hth16", locale)).append(repetMethod[3]).append(egovMessageSource.getMessage("ezSchedule.mail.hth17", locale)).append(" ").append(egovMessageSource.getMessage("ezSchedule.mail.hth18", locale)); // 매 n일마다 반복
			}
			break;
		case "1":
			retStr.append(egovMessageSource.getMessage("ezSchedule.mail.hth16", locale)).append(repetMethod[3]).append(egovMessageSource.getMessage("ezSchedule.mail.hth29", locale));
			
			String[] repDays = repetMethod[4].split("");
			
			retStr.append(egovMessageSource.getMessage("ezSchedule.mail.hth19", locale));
			for (int i = 0; i < repDays.length; i++) {
				if (i == repDays.length - 1) {
					retStr.append(dayArr[Integer.parseInt(repDays[i])]);
				} else {
					retStr.append(dayArr[Integer.parseInt(repDays[i])] + ", ");
				}
			}
			retStr.append(egovMessageSource.getMessage("ezSchedule.mail.hth20", locale));
			break;
		case "2":
			retStr.append(egovMessageSource.getMessage("ezSchedule.mail.hth16", locale));
			retStr.append(repetMethod[4]).append(egovMessageSource.getMessage("ezSchedule.mail.hth21", locale));
			if (repetMethod[3].equals("1")) {
				retStr.append(egovMessageSource.getMessage("ezSchedule.mail.hth22", locale));
				retStr.append(repetMethod[5]);
				String[] ordinalNumbers = egovMessageSource.getMessage("ezSchedule.mail.hth23", locale).split(";");
				
				if (Integer.parseInt(repetMethod[5]) <= 3) {
					retStr.append(ordinalNumbers[Integer.parseInt(repetMethod[5]) - 1]);
				} else if ((Integer.parseInt(repetMethod[5]) >= 21 && Integer.parseInt(repetMethod[5]) <= 23) || Integer.parseInt(repetMethod[5]) == 31) {
					retStr.append(ordinalNumbers[Integer.parseInt(repetMethod[5].substring(1, 2)) - 1]);
				}
				else {
					retStr.append(ordinalNumbers[3]);
				}
			} else {
				retStr.append(weekArr[Integer.parseInt(repetMethod[5]) - 1]).append(dayArr[Integer.parseInt(repetMethod[6])]);
				retStr.append(egovMessageSource.getMessage("ezSchedule.mail.hth25", locale));
			}
			
			break;
		case "3":
			retStr.append(egovMessageSource.getMessage("ezSchedule.mail.hth16", locale));
			String[] months = egovMessageSource.getMessage("ezSchedule.mail.hth24", locale).split("\\|");
			retStr.append(months[Integer.parseInt(repetMethod[4]) - 1]);
			
			if (repetMethod[3].equals("1")) {
				retStr.append(repetMethod[5]);
				String[] ordinalNumbers = egovMessageSource.getMessage("ezSchedule.mail.hth23", locale).split(";");
				
				if (Integer.parseInt(repetMethod[5]) <= 3) {
					retStr.append(ordinalNumbers[Integer.parseInt(repetMethod[5]) - 1]);
				} else if ((Integer.parseInt(repetMethod[5]) >= 21 && Integer.parseInt(repetMethod[5]) <= 23) || Integer.parseInt(repetMethod[5]) == 31) {
					retStr.append(ordinalNumbers[Integer.parseInt(repetMethod[5].substring(1, 2)) - 1]);
				}
				else {
					retStr.append(ordinalNumbers[3]);
				}
			} else {
				retStr.append(weekArr[Integer.parseInt(repetMethod[5]) - 1]).append(dayArr[Integer.parseInt(repetMethod[6])]);
				retStr.append(egovMessageSource.getMessage("ezSchedule.mail.hth25", locale));
			}
			break;
		}
		
		return retStr.toString();
	}
	
	// 2023-09-25 한태훈 - 일정관리 > 참석자 초대 일정 수정 알림 메일 전송 시 완료 여부 내용 만들기
	@Override
	public String makeCompleteContent(String dateType, String isAllRep, String completeFG, String repStartdate, Locale locale) throws Exception {
		String retStr = "";
		if (dateType.equals("3")) {
			if (completeFG.equalsIgnoreCase("N")) {
				retStr = egovMessageSource.getMessage("ezSchedule.mail.hth07", locale);
			} else {
				if (isAllRep.equals("Y")) {
					retStr = egovMessageSource.getMessage("ezSchedule.mail.hth08", locale);
				} else {
					retStr = repStartdate.substring(0, 10) + " " + egovMessageSource.getMessage("ezSchedule.mail.hth09", locale);
				}
			}
		} else {
			if (completeFG.equalsIgnoreCase("N")) {
				retStr = egovMessageSource.getMessage("ezSchedule.mail.hth07", locale);
			} else {
				retStr = egovMessageSource.getMessage("ezSchedule.HSBCp01", locale);
			}
		}
		return retStr;
	}

	@Override
	public void sendInviteScheDelNoti(HttpServletRequest request, List<AttendantListVO> attendantList, ScheduleInfoVO scheduleInfo, String selectedDate, String repeatCount, LoginVO loginVO, String loginCookie) throws Exception {
		logger.debug("sendInviteScheDelNoti started");
		
		String scheduleId = scheduleInfo.getScheduleId();
		String dateType = scheduleInfo.getDateType();
		String repetition = scheduleInfo.getRepetition();
		String startDate = scheduleInfo.getStartDate();
		String endDate = scheduleInfo.getEndDate();
		String title = scheduleInfo.getTitle();
		String scheDateContent = makeScheDateContent(dateType, repetition, startDate, endDate, loginVO.getLocale());
		String scheTimeContent = makeScheTimeContent(startDate, endDate, dateType, repetition, loginVO.getLocale());
		String repetitionContent = makeRepetitionContent(repetition, loginVO.getLocale());
		
		selectedDate = commonUtil.getDateStringInUTC(selectedDate, loginVO.getOffset(), false);
		
		String creatorName = "";
		if (commonUtil.getPrimaryData(loginVO.getLang(), loginVO.getTenantId()).equals("1")) {
			creatorName = scheduleInfo.getCreatorName();
		} else {
			creatorName = scheduleInfo.getCreatorName2();
		}
		
		InternetAddress from = new InternetAddress();
		from.setPersonal(creatorName, "UTF-8");
		from.setAddress(ezOrganService.getPropertyValue(scheduleInfo.getCreatorId(), "mail", loginVO.getTenantId()));
		
		List<InternetAddress> toList = new ArrayList<>();
		
		List<Map<String,Object>> notiRecipientList = new ArrayList<Map<String, Object>> ();
		
		for (AttendantListVO attendant : attendantList) {
			String attendantName = "";
			if (commonUtil.getPrimaryData(loginVO.getLang(), loginVO.getTenantId()).equals("1")) {
				attendantName = attendant.getAttendantName();
			} else {
				attendantName = attendant.getAttendantName2();
			}
			
			if (attendant.getStatus().equalsIgnoreCase("1")) {
				if (!ezPersonalService.hasNotiDiableItem(attendant.getAttendantId(), NotiType.SCHEDULE_DELETE, NotiPlatform.MAIL, loginVO.getTenantId())) {
					// 반복일정 전체 일정 삭제, 반복 일정이 아닌 일정 삭제의 경우 selectedDate = null, repeatCount를 0으로 전달.
					InternetAddress to = new InternetAddress();
					to.setPersonal(attendantName.trim(), "UTF-8");
					to.setAddress(ezOrganService.getPropertyValue(attendant.getAttendantId(), "mail", loginVO.getTenantId()));
					toList.add(to);
					Map<String, Object> recipientMap = new HashMap<String, Object>();
	        		recipientMap.put("userType", "PERSON");
	        		recipientMap.put("companyId", loginVO.getCompanyID());
	        		recipientMap.put("cn", attendant.getAttendantId());
	        		notiRecipientList.add(recipientMap);
				}
			}
		}
		
		if (toList.size() <= 0) {
			return;
		}
		
		String subject = "";
		StringBuilder bodyContent = new StringBuilder("");
		subject = egovMessageSource.getMessage("ezSchedule.mail.hth30", loginVO.getLocale());
		bodyContent.append(" " + creatorName + egovMessageSource.getMessage("ezSchedule.mail.hth31", loginVO.getLocale()) + " ");
		bodyContent.append("<br><br><span>&nbsp;&nbsp; - ").append(egovMessageSource.getMessage("ezSchedule.t272", loginVO.getLocale()) + " : " + title);
		bodyContent.append("<br><span>&nbsp;&nbsp; - ").append(egovMessageSource.getMessage("ezSchedule.t318", loginVO.getLocale()) + " : ");
		
		if (dateType.equals("3") && repeatCount.equals("0")) {
			bodyContent.append(scheDateContent + " (" + egovMessageSource.getMessage("ezSchedule.mail.hth33", loginVO.getLocale()) + ")");
			bodyContent.append("<br><span>&nbsp;&nbsp; - ").append(egovMessageSource.getMessage("ezSchedule.t71", loginVO.getLocale()) + " : " + repetitionContent);
			bodyContent.append("<br><span>&nbsp;&nbsp; - ").append(egovMessageSource.getMessage("ezSchedule.t67", loginVO.getLocale()) + " : " + scheTimeContent);
		} else if (dateType.equals("3") && !repeatCount.equals("0")) {
			bodyContent.append(egovMessageSource.getMessage("ezSchedule.t343", loginVO.getLocale()));
			bodyContent.append("(" + repeatCount + egovMessageSource.getMessage("ezSchedule.mail.hth32", loginVO.getLocale()) + selectedDate);
			bodyContent.append("<br><span>&nbsp;&nbsp; - ").append(egovMessageSource.getMessage("ezSchedule.t71", loginVO.getLocale()) + " : " + repetitionContent);
			//bodyContent.append("<br><br> &nbsp;&nbsp; <span id='scheduleInfo' style=\"color:blue;cursor:pointer;text-decoration:underline;\" scheduleId='" + scheduleId + "' repeatCount= '" + repeatCount + "' startDate='" + selectedDate + "' endDate='" + selectedDate + "' date='" + selectedDate + "' onclick='openScheduleInfo()'>" + egovMessageSource.getMessage("ezSchedule.mail.hth03") + "</span>");
		} else {
			bodyContent.append(scheDateContent);
			bodyContent.append("<br><span>&nbsp;&nbsp; - ").append(egovMessageSource.getMessage("ezSchedule.t67", loginVO.getLocale()) + " : " + scheTimeContent);
		}
		
		String content_ = commonUtil.createNotiMailContent(bodyContent.toString(), loginVO.getTenantId(), loginVO.getLocale());
		ezEmailService.sendMail(loginCookie, from, toList.toArray(new InternetAddress[toList.size()]), null, null, subject, content_, false);
		
		String linkUrl = "";
							
		String linkUrlMobile = "";
				
		ezNotificationService.sendNoti(request, scheduleInfo.getCreatorId(), creatorName, notiRecipientList, "SCHEDULE", "DELETE", title, "popup", "760", "750", linkUrl, linkUrlMobile, "");
		
		logger.debug("sendInviteScheDelNoti ended");
	}
	
	// 2023-10-17 한태훈 - 일정관리 > 모바일 초대 일정메일 발송 (참석 수락, 거절 메일)
	@Override
	public void sendScheduleNotiForMobile(HttpServletRequest request, MCommonVO userInfo, String creatorId, String creatorName, String title, String periodContent, String type, String scheduleId, String startDate, String endDate) throws Exception {
		logger.debug("sendScheduleNotiForMobile started");
		
		String subject = null;
		StringBuilder bodyContent = new StringBuilder("");
		
		String domainName = ezCommonService.getTenantConfig("DomainName", userInfo.getTenantId());
		String userEmail = userInfo.getUserId() + "@" + domainName;
		String password = jspw;
		//to User
		List<InternetAddress> toList = new ArrayList<>();
		Locale locale = new Locale(commonUtil.getTwoLetterLangFromLangNum(userInfo.getLang()));

		//from User
		String userName = userInfo.getPrimary().equals(userInfo.getLang()) ? userInfo.getUserName() : userInfo.getUserName2(); 
		int tenantId = userInfo.getTenantId();

		InternetAddress from = new InternetAddress();
		from.setAddress(userInfo.getEmail());
		from.setPersonal(userName, "UTF-8");

		InternetAddress to;
		to = new InternetAddress();
		to.setAddress(ezOrganService.getPropertyValue(creatorId, "mail", tenantId));
		to.setPersonal(creatorName, "UTF-8");
		
		toList.add(to);
		
		List<Map<String,Object>> notiRecipientList = new ArrayList<Map<String, Object>> ();
		Map<String, Object> recipientMap = new HashMap<String, Object>();
		recipientMap.put("userType", "PERSON");
		recipientMap.put("companyId", userInfo.getCompanyId());
		recipientMap.put("cn", creatorId);
		notiRecipientList.add(recipientMap);
		
		if (toList.size() <= 0) {
			return;
		}
		
		String notiSubType = "";
		switch(type) {
		case "acc" :		// 참석 수락
			subject = egovMessageSource.getMessage("ezSchedule.kmss05", locale);
			
			bodyContent.append(" " + userName + egovMessageSource.getMessage("ezSchedule.kmss06", locale) + "</br><br>" + " ");
			bodyContent.append(" &nbsp;&nbsp;- " + egovMessageSource.getMessage("ezCircular.t32", locale) + " : " + "<span id='schedule_read' >" + commonUtil.cleanValue(title) + "</span></br>");
			bodyContent.append(periodContent);
			bodyContent.append("<br><br> &nbsp;&nbsp; <span id='scheduleInfo' style=\"color:blue;cursor:pointer;text-decoration:underline;\" scheduleId='" + scheduleId + "' startDate='" + startDate + "' endDate='" + endDate + "' date='" + startDate + "' onclick='openScheduleInfo()'>" + egovMessageSource.getMessage("ezSchedule.mail.hth03", locale) + "</span>");
			notiSubType = "ACCEPT";
			break;
		case "rej" :		// 참석 거절
			subject = egovMessageSource.getMessage("ezSchedule.kmss07", locale);
			
			bodyContent.append(" " + userName + egovMessageSource.getMessage("ezSchedule.kmss08", locale) + "</br><br>" + " ");
			bodyContent.append(" &nbsp;&nbsp;- " + egovMessageSource.getMessage("ezCircular.t32", locale) + " : " + "<span id='schedule_read' >" + commonUtil.cleanValue(title) + "</span></br>");
			bodyContent.append(periodContent);
			bodyContent.append("<br><br> &nbsp;&nbsp; <span id='scheduleInfo' style=\"color:blue;cursor:pointer;text-decoration:underline;\" scheduleId='" + scheduleId + "' startDate='" + startDate + "' endDate='" + endDate + "' date='" + startDate + "' onclick='openScheduleInfo()'>" + egovMessageSource.getMessage("ezSchedule.mail.hth03", locale) + "</span>");
			notiSubType = "REJECT";
			break;
		}
		
		if (!ezPersonalService.hasNotiDiableItem(creatorId, NotiType.fromString("SCHEDULE_" + notiSubType), NotiPlatform.MAIL, userInfo.getTenantId())) {
			ezEmailService.sendMail(userEmail, password, locale, from, toList.toArray(new InternetAddress[toList.size()]), null, null, subject, commonUtil.createNotiMailContent(bodyContent.toString(), tenantId, locale), false, EmailImportance.NORMAL);
		}
		
		String linkUrl = "/ezSchedule/scheduleRead.do?id=" + scheduleId + "&isReceive=Y";
			
		String linkUrlMobile = "/mobile/ezSchedule/mScheduleDetail.do?scheduleId=" + scheduleId + "&startDate=" + startDate + "&endDate=" + endDate + "&date=" + startDate + "&type=monthList" + "&purpose=scheduleInfoDetail";
			
		ezNotificationService.sendNoti(request, userInfo.getUserId(), creatorName, notiRecipientList, "schedule", notiSubType, title, "popup", "760", "750", linkUrl, linkUrlMobile, "");
		
		logger.debug("sendScheduleNotiForMobile ended");
	}
	
	// 2023-10-17 한태훈 - 일정관리 > 모바일 초대 일정 수정 메일 및 알림 발송
	@Override
	public void sendInviteModNotiForMoblie(HttpServletRequest request, String scheduleId, String ownerId, String ownerName, List<AttendantListVO> attendantList, String location, String title, String importance, String ispublic, String startdate, String enddate, String datetype, MScheduleInfoVO beforeSche, MCommonVO userInfo) throws Exception {
		logger.debug("sendInviteModNotiForMoblie started");
		
		String subject = null;
		StringBuilder bodyContent = new StringBuilder("");
		
		String domainName = ezCommonService.getTenantConfig("DomainName", userInfo.getTenantId());
		String userEmail = ownerId + "@" + domainName;
		String password = jspw;
		//to User
		List<InternetAddress> toList = new ArrayList<>();
		Locale locale = new Locale(commonUtil.getTwoLetterLangFromLangNum(userInfo.getLang()));

		//from User
		int tenantId = userInfo.getTenantId();

		InternetAddress from = new InternetAddress();
		from.setAddress(ezOrganService.getPropertyValue(ownerId, "mail", tenantId));
		from.setPersonal(ownerName, "UTF-8");
		
		List<Map<String,Object>> notiRecipientList = new ArrayList<Map<String, Object>> ();
		
		for (AttendantListVO attendant : attendantList) {
			String attendanceStatus = attendant.getStatus();
			if (attendanceStatus != null && attendanceStatus.equals("1")) {
				if (!ezPersonalService.hasNotiDiableItem(attendant.getAttendantId(), NotiType.SCHEDULE_MOD, NotiPlatform.MAIL, tenantId)) {
					InternetAddress to;
					to = new InternetAddress();
					to.setAddress(ezOrganService.getPropertyValue(attendant.getAttendantId(), "mail", tenantId));
					to.setPersonal(userInfo.getPrimary().equals(userInfo.getLang()) ? attendant.getAttendantName() : attendant.getAttendantName2(), "UTF-8");
					toList.add(to);
					Map<String, Object> recipientMap = new HashMap<String, Object>();
	        		recipientMap.put("userType", "PERSON");
	        		recipientMap.put("companyId", userInfo.getCompanyId());
	        		recipientMap.put("cn", attendant.getAttendantId());
	        		notiRecipientList.add(recipientMap);
				}
			}
		}
		
		if (toList.size() <= 0) {
			logger.debug("sendInviteModNotiForMoblie ended");
			return;
		}
		
		StringBuilder mailContent = new StringBuilder();
		mailContent.append("<span> * ").append(egovMessageSource.getMessage("ezSchedule.mail.hth04", locale)).append("</span> <br>");
		
		if (!beforeSche.getLocation().trim().equals(location.trim())) {
			mailContent = makeScheModMailForm(mailContent, egovMessageSource.getMessage("ezSchedule.t273", locale), beforeSche.getLocation(), location, locale);
		}
		
		if (!beforeSche.getTitle().trim().equals(title.trim())) {
			mailContent = makeScheModMailForm(mailContent, egovMessageSource.getMessage("ezSchedule.t272", locale), beforeSche.getTitle(), title, locale);
		}
		
		if (!beforeSche.getImportance().trim().equals(importance.trim())) {
			mailContent = makeScheModMailForm(mailContent, egovMessageSource.getMessage("ezSchedule.t310", locale), decodeColumnValue("importance", beforeSche.getImportance(), locale), decodeColumnValue("importance", importance, locale), locale);
		}
		
		if (!beforeSche.getIsPublic().trim().equals(ispublic.trim())) {
			mailContent = makeScheModMailForm(mailContent, egovMessageSource.getMessage("ezSchedule.mail.hth15", locale), decodeColumnValue("ispublic", beforeSche.getIsPublic(), locale), decodeColumnValue("ispublic", ispublic, locale), locale);
		}
		
		String beforeScheDateContent = makeScheDateContent(beforeSche.getDateType(), beforeSche.getRepetition(), beforeSche.getStartDate(), beforeSche.getEndDate(), locale);
		String afterScheDateContent = makeScheDateContent(datetype, beforeSche.getRepetition(), startdate, enddate, locale); // 2023-10-25 한태훈 - 모바일에서는 반복주기가 바뀌지 않음.
		
		if (!beforeScheDateContent.equals(afterScheDateContent)) {
			mailContent = makeScheModMailForm(mailContent, egovMessageSource.getMessage("ezSchedule.t318", locale), beforeScheDateContent, afterScheDateContent, locale);
		}
		
		String beforeScheTime = makeScheTimeContent(beforeSche.getStartDate(), beforeSche.getEndDate(), beforeSche.getDateType(), beforeSche.getRepetition(), locale); 
		String afterScheTime = makeScheTimeContent(startdate, enddate, datetype, beforeSche.getRepetition(), locale); // 2023-10-25 한태훈 - 모바일에서는 반복주기가 바뀌지 않음.
				
		if (!beforeScheTime.equals(afterScheTime)) {
			mailContent = makeScheModMailForm(mailContent, egovMessageSource.getMessage("ezSchedule.t67", locale), beforeScheTime, afterScheTime, locale);
		}
		
		subject = egovMessageSource.getMessage("ezSchedule.mail.hth01", locale);
		
		bodyContent.append(" " + ownerName + egovMessageSource.getMessage("ezSchedule.mail.hth02", locale) + " ");
		bodyContent.append("(" + egovMessageSource.getMessage("ezSchedule.mail.hth06", locale) + " : " + beforeSche.getTitle() + " - ");
		bodyContent.append(beforeScheDateContent + " ");
		bodyContent.append(beforeScheTime + ")" + "<br><br>");
		bodyContent.append(mailContent.toString());
		
		bodyContent.append("<br><br> &nbsp;&nbsp; <span id='scheduleInfo' style=\"color:blue;cursor:pointer;text-decoration:underline;\" scheduleId='" + scheduleId + "' startDate='" + startdate + "' endDate='" + enddate + "' date='" + startdate + "' onclick='openScheduleInfo()'>" + egovMessageSource.getMessage("ezSchedule.mail.hth03", locale) + "</span>");
		
		ezEmailService.sendMail(userEmail, password, locale, from, toList.toArray(new InternetAddress[toList.size()]), null, null, subject, commonUtil.createNotiMailContent(bodyContent.toString(), tenantId, locale), false, EmailImportance.NORMAL);
		
		String linkUrl = "/ezSchedule/scheduleRead.do?id=" + scheduleId + "&isReceive=Y";
			
		String linkUrlMobile = "/mobile/ezSchedule/mScheduleDetail.do?scheduleId=" + scheduleId + "&startDate=" + startdate + "&endDate=" + enddate + "&date=" + startdate + "&type=monthList" + "&purpose=scheduleInfoDetail";
			
		ezNotificationService.sendNoti(request, beforeSche.getCreatorId(), ownerName, notiRecipientList, "SCHEDULE", "MOD", title, "popup", "760", "750", linkUrl, linkUrlMobile, "");
		
		logger.debug("sendInviteModNotiForMoblie ended");
	}
	
	// 2023-10-25 한태훈 - 일정관리 > 모바일 초대 일정 삭제 메일 발송
	@Override
	public void sendInviteScheDelNotiForMobile(HttpServletRequest request, List<AttendantListVO> attendantList, ScheduleInfoVO scheduleInfo, MCommonVO info) throws Exception {
		logger.debug("sendInviteScheDelNotiForMobile started");
		
		String dateType = scheduleInfo.getDateType();
		String repetition = scheduleInfo.getRepetition();
		String startDate = scheduleInfo.getStartDate();
		String endDate = scheduleInfo.getEndDate();
		String title = scheduleInfo.getTitle();
		Locale locale = new Locale(commonUtil.getTwoLetterLangFromLangNum(info.getLang()));
		String scheDateContent = makeScheDateContent(dateType, repetition, startDate, endDate, locale);
		String scheTimeContent = makeScheTimeContent(startDate, endDate, dateType, repetition, locale);
		String repetitionContent = makeRepetitionContent(repetition, locale);
		
		String domainName = ezCommonService.getTenantConfig("DomainName", info.getTenantId());
		String userEmail = scheduleInfo.getOwnerId() + "@" + domainName;
		String password = jspw;
		
		String creatorName = "";
		if (commonUtil.getPrimaryData(info.getLang(), info.getTenantId()).equals("1")) {
			creatorName = scheduleInfo.getCreatorName();
		} else {
			creatorName = scheduleInfo.getCreatorName2();
		}
		
		InternetAddress from = new InternetAddress();
		from.setPersonal(creatorName, "UTF-8");
		from.setAddress(ezOrganService.getPropertyValue(scheduleInfo.getCreatorId(), "mail", info.getTenantId()));
		
		List<Map<String,Object>> notiRecipientList = new ArrayList<Map<String, Object>> ();
		
		List<InternetAddress> toList = new ArrayList<>();
		for (AttendantListVO attendant : attendantList) {
			String attendantName = "";
			if (commonUtil.getPrimaryData(info.getLang(), info.getTenantId()).equals("1")) {
				attendantName = attendant.getAttendantName();
			} else {
				attendantName = attendant.getAttendantName2();
			}
			
			if (attendant.getStatus().equalsIgnoreCase("1")) {
				if (!ezPersonalService.hasNotiDiableItem(attendant.getAttendantId(), NotiType.SCHEDULE_DELETE, NotiPlatform.MAIL, info.getTenantId())) {
					// 반복일정 전체 일정 삭제, 반복 일정이 아닌 일정 삭제의 경우 selectedDate = null, repeatCount를 0으로 전달.
					InternetAddress to = new InternetAddress();
					to.setPersonal(attendantName.trim(), "UTF-8");
					to.setAddress(ezOrganService.getPropertyValue(attendant.getAttendantId(), "mail", info.getTenantId()));
					toList.add(to);
					Map<String, Object> recipientMap = new HashMap<String, Object>();
	        		recipientMap.put("userType", "PERSON");
	        		recipientMap.put("companyId", info.getCompanyId());
	        		recipientMap.put("cn", attendant.getAttendantId());
	        		notiRecipientList.add(recipientMap);
				}
			}
		}
		
		if (toList.size() <= 0) {
			return;
		}
		
		String subject = "";
		StringBuilder bodyContent = new StringBuilder("");
		subject = egovMessageSource.getMessage("ezSchedule.mail.hth30", locale);
		bodyContent.append(" " + creatorName + egovMessageSource.getMessage("ezSchedule.mail.hth31", locale) + " ");
		bodyContent.append("<br><br><span>&nbsp;&nbsp; - ").append(egovMessageSource.getMessage("ezSchedule.t272", locale) + " : " + title);
		bodyContent.append("<br><span>&nbsp;&nbsp; - ").append(egovMessageSource.getMessage("ezSchedule.t318", locale) + " : ");
		
		if (dateType.equals("3")) {
			bodyContent.append(scheDateContent + " (" + egovMessageSource.getMessage("ezSchedule.mail.hth33", locale) + ")");
			bodyContent.append("<br><span>&nbsp;&nbsp; - ").append(egovMessageSource.getMessage("ezSchedule.t71", locale) + " : " + repetitionContent);
			bodyContent.append("<br><span>&nbsp;&nbsp; - ").append(egovMessageSource.getMessage("ezSchedule.t67", locale) + " : " + scheTimeContent);
		} else {
			bodyContent.append(scheDateContent);
			bodyContent.append("<br><span>&nbsp;&nbsp; - ").append(egovMessageSource.getMessage("ezSchedule.t67", locale) + " : " + scheTimeContent);
		}
		
		ezEmailService.sendMail(userEmail, password, locale, from, toList.toArray(new InternetAddress[toList.size()]), null, null, subject, commonUtil.createNotiMailContent(bodyContent.toString(), info.getTenantId(), locale), false, EmailImportance.NORMAL);
		
		String linkUrl = "";
				
		String linkUrlMobile = "";
				
		ezNotificationService.sendNoti(request, scheduleInfo.getCreatorId(), creatorName, notiRecipientList, "SCHEDULE", "DELETE", title, "popup", "730", "370", linkUrl, linkUrlMobile, "");
		
		logger.debug("sendInviteScheDelNotiForMobile ended");
	}

	/* 2023-10-06 기민혁 - 사용자일정 검색시 일정 List 호출 메서드 */
	@Override
	public List<ScheduleInfoVO> getUserSearchScheduleList(String indiList, String pidList, String filter, String utcStartDate, String utcEndDate, String orgStartDate, String orgEndDate, String keyword, String offSetMin, String searchTitle, int tenantId, String companyID, String userID, String deptID, String useAnnualScheduleYN) throws Exception {

		String ISPUBLIIC = "Y";
		Map<String, Object> map = new HashMap<String, Object>();
		
		String[] indiListArr = indiList.replace(" ", "").replace("\'", "").split(",");
		if (indiListArr.length == 0) {
			indiListArr = new String[1];
			indiListArr[0] = "";
		}
		map.put("v_INDILIST", indiListArr);

		String[] pidListArr = pidList.replace(" ", "").replace("\'", "").split(",");
		if (pidListArr.length == 0) {
			pidListArr = new String[1];
			pidListArr[0] = "";
		}
		map.put("v_PIDLIST", pidListArr);
		
		map.put("v_PFILTER", filter);
		map.put("v_PSTARTDATE", utcStartDate);
		map.put("v_PENDDATE", utcEndDate);
		map.put("v_OFFSETMIN", offSetMin);
		map.put("v_TENANTID", tenantId);
		/* 2021-10-20 홍승비 - 일정의 제목, 위치 검색조건 나눠지도록 수정 (v_SEARCHTITLE값이 존재하면 항상 제목 조건을 추가하게 됨) */
		if (filter != null && !filter.equalsIgnoreCase("location")) { // filter 조건 null 처리 추가 (검색조건 없이 모든 리스트 가져오는 경우 대응)
			map.put("v_SEARCHTITLE", commonUtil.insertEscapeCharBackslash(searchTitle));
		}
		map.put("v_COMPANYID", companyID);
		map.put("v_USERID", userID);
		map.put("v_DEPTID", deptID);
		map.put("v_ISPUBLIIC", ISPUBLIIC);
		map.put("useAnnualScheduleYN", useAnnualScheduleYN);

		// 임원일정 조회가능범위 설정여부
		String useExecSchedulePublic = ezCommonService.getTenantConfig("useExecSchedulePublic", tenantId);
		map.put("useExecSchedulePublic", useExecSchedulePublic);

		List<ScheduleInfoVO> sList = ezScheduleDAO.getUserSearchScheduleList(map);

		List<ScheduleInfoVO> resultList = new ArrayList<ScheduleInfoVO>();
		List<ScheduleInfoVO> tempResultList = new ArrayList<ScheduleInfoVO>();

		for (int i=0; i < sList.size(); i++) {
			ScheduleInfoVO vo = sList.get(i);

			//반복일정 구현 시작
			if (vo.getDateType().equals("3")) {
				map.put("v_SCHEDULEID", vo.getScheduleId());

				List<String> rList = ezScheduleDAO.getScheduleRepeDelList(map);

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

								if (calcuDate.compareTo(orgStartDate.substring(0,10)) >= 0 && calcuDate.compareTo(orgEndDate.substring(0,10)) <= 0) {
									//row 추가
									if (!rList.contains(calcuDate)) {
										ScheduleInfoVO rVo = addRepeatRow(vo, date_cal.getTime(), count, info[1]);
										resultList.add(rVo);
									}
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
						//repeatDayList = setDayInfo(dayInfo);

						if(dayInfo != null && !dayInfo.trim().equals("")){
							char[] yoilArr = new char[info[4].length()]; // 스트링을 담을 배열

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
						int weeklyMaxCount = maxCount * repeatDayList.size();

						while (true) {
							if (scheduleCalendar.compareTo(lastDateOfCalendar) > 0) {
								//TODO boolean 리턴함수
								calculatedScheduleEndDateCalendar.setTime(lastDateOfCalendar.getTime());
								calculatedScheduleEndDateCalendar.add(Calendar.DATE, (Integer.parseInt(weeklyInterval)) * 7);
								if(scheduleCalendar.compareTo(calculatedScheduleEndDateCalendar) > 0) {
									break;
								}
							}

							if (Integer.parseInt(isExistEndDate) > 0) {
								if (weeklyMaxCount <= count) break;
							}

							if (count > MAXSCHEDULECOUNT) {
								break;
							}

							String scheduleDate = nsdf.format(scheduleCalendar.getTime());

							if(isExistEndDate.equals("0")){ //isExistEndDate Code "0" : 종료일 있음
								//TODO makeFunction
								for (int k = 0; k < repeatDayList.size(); k++) {
									scheduleCalendar.set(Calendar.DAY_OF_WEEK,repeatDayList.get(k)+1);
									scheduleDate = nsdf.format(scheduleCalendar.getTime());
									if (scheduleCalendar.getTime().compareTo(scheduleStartDate) >= 0 && scheduleCalendar.getTime().compareTo(sdf.parse(endDate)) <= 0) {
										if (!rList.contains(scheduleDate)) {
											count++;
											int weeklyCount = (int) Math.ceil(count / (double)repeatDayList.size());
											ScheduleInfoVO rVo = addRepeatRow(vo, scheduleCalendar.getTime(), weeklyCount, isAllday);
											tempResultList.add(rVo);
										} else {
											count++;
										}
									}
								}
							} else if (Integer.parseInt(isExistEndDate) > 0) { //isExistEndDate Code > 0 : 숫자만큼 일정을 반복
								for (int k = 0; k < repeatDayList.size(); k++) {
									scheduleCalendar.set(Calendar.DAY_OF_WEEK,repeatDayList.get(k)+1);
									scheduleDate = nsdf.format(scheduleCalendar.getTime());
									if (scheduleCalendar.getTime().compareTo(scheduleStartDate) >= 0 && scheduleCalendar.getTime().compareTo(sdf.parse(endDate)) <= 0) {
										if (weeklyMaxCount > count) {
											if (!rList.contains(scheduleDate)) {
												count++;
												int weeklyCount = (int) Math.ceil(count / (double)repeatDayList.size());
												ScheduleInfoVO rVo = addRepeatRow(vo, scheduleCalendar.getTime(), weeklyCount, isAllday);
												tempResultList.add(rVo);
											} else {
												count++;
											}
										} else {
											break;
										}
									}
								}
							} else { //isExistEndDate Code "-1" : 종료일 없음
								for (int k = 0; k < repeatDayList.size(); k++) {
									scheduleCalendar.set(Calendar.DAY_OF_WEEK,repeatDayList.get(k)+1);
									scheduleDate = nsdf.format(scheduleCalendar.getTime());
									if (scheduleCalendar.getTime().compareTo(scheduleStartDate) >= 0 && scheduleCalendar.getTime().compareTo(sdf.parse(endDate)) <= 0) {
										if (!rList.contains(scheduleDate)) {
											count++;
											int weeklyCount = (int) Math.ceil(count / (double)repeatDayList.size());
											ScheduleInfoVO rVo = addRepeatRow(vo, scheduleCalendar.getTime(), weeklyCount, isAllday);
											tempResultList.add(rVo);
										} else {
											count++;
										}
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
									if (calcuDate.compareTo(orgStartDate.substring(0,10)) >= 0 && calcuDate.compareTo(endDate.substring(0,10)) <= 0) {
										//row 추가
										if (!rList.contains(calcuDate)) {
											ScheduleInfoVO rVo = addRepeatRow(vo, newCal.getTime(), count, info[1]);
											resultList.add(rVo);
										}
									}
								} else {
									if (calcuDate.compareTo(orgStartDate.substring(0,10)) >= 0 && calcuDate.compareTo(orgEndDate.substring(0,10)) <= 0) {
										//row 추가
										if (!rList.contains(calcuDate)) {
											ScheduleInfoVO rVo = addRepeatRow(vo, newCal.getTime(), count, info[1]);
											resultList.add(rVo);
										}
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
									if (calcuDate.compareTo(orgStartDate.substring(0,10)) >= 0 && calcuDate.compareTo(endDate.substring(0,10)) <= 0 && calcuDate.compareTo(vo.getStartDate().substring(0,10)) >= 0) {
										//row 추가
										if (!rList.contains(calcuDate)) {
											ScheduleInfoVO rVo = addRepeatRow(vo, newCal.getTime(), count, info[1]);
											resultList.add(rVo);
										}
									}
								} else {
									if (calcuDate.compareTo(orgStartDate.substring(0,10)) >= 0 && calcuDate.compareTo(orgEndDate.substring(0,10)) <= 0 && calcuDate.compareTo(vo.getStartDate().substring(0,10)) >= 0) {
										//row 추가
										if (!rList.contains(calcuDate)) {
											ScheduleInfoVO rVo = addRepeatRow(vo, newCal.getTime(), count, info[1]);
											resultList.add(rVo);
										}
									}
								}
							}

							date_cal.add(Calendar.DATE, 1 - date_cal.get(Calendar.DATE));
							date_cal.add(Calendar.YEAR, 1);
						}
						break;
				}
			}
			else {
				resultList.add(vo);
			}
		}

		logger.debug("=====getScheduleList Ended=====");
		if (tempResultList != null) {
			resultList = realList(resultList, tempResultList, orgStartDate, orgEndDate);
		}

		return resultList;
	}

	@Value("${config.cron.checkReminder}")
	private String checkReminder;

	@Resource(name = "loginService")
    private LoginService loginService;
	
	@Override
	public Map<String, List<ScheduleReminderVO>> selectReminderScheList(String nowTimeStr, int tenantId) throws Exception {
		logger.debug("selectReminderScheList started");
		//offSet 구하기 -- 한국시간으로 통일.
		
		List<ScheduleReminderVO> reminderScheList = new ArrayList<ScheduleReminderVO>(); // 미리알림 대상 일정 리스트
		List<ScheduleReminderVO> reminderRepeatScheList = new ArrayList<ScheduleReminderVO>(); // 반복일정 리스트
		Map <Integer, ScheduleReminderVO> repScheForRemind = new HashMap<Integer, ScheduleReminderVO>(); // 반복일정 중 미리 알림 대상
		List<ScheduleReminderVO> reminderCompleteList = new ArrayList<ScheduleReminderVO> (); // 미리알림 완료 일정 - reminderStatus 를 완료로 변경 목적.
		
		String cronMinute = checkReminder.split(" ")[1].split("/")[1];
		String allDaySTime = ezCommonService.getTenantConfig("allDaySTimeForReminder", tenantId);
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("cronMinute", cronMinute);
		map.put("nowTime", nowTimeStr);
		map.put("tenantId", tenantId);
		map.put("allDaySTime", allDaySTime);
		// 반복 일정 설정 아니면서 완료 일정이 아닌 스케쥴 리스트 가져오기. -> 모두 미리알림 대상임.
		reminderScheList = ezScheduleDAO.selectNoRepeatRemindScheList(map);
		
		// 반복 일정 설정이 아닌 경우 미리알림 상태 완료로 변경.
		for (ScheduleReminderVO sche : reminderScheList) {
			reminderCompleteList.add(sche);
		}
		
		// 반복 일정이면서 전체 완료 일정이 아닌 스케줄 리스트 가져오기.
		reminderRepeatScheList = ezScheduleDAO.selectRepeatRemindScheList(map);
		
		SimpleDateFormat fm = new SimpleDateFormat("yyyy-MM-dd HH:mm");
		
		Calendar schedulerStartTime = Calendar.getInstance(); // 스케줄러 포함 시작 시각
		Calendar schedulerSTimePlusCronMin = Calendar.getInstance(); // 스케줄러 시작 시간에 cron 반복 주기 분 더한 시간.
		Calendar schedulerStartDate = Calendar.getInstance(); // 마지막 반복 주기 날짜와 스케줄러 시간 비교 목적.(시간 정보는 제외하고 날짜만 남기기 위해)
		Calendar schedulerEndTime = Calendar.getInstance(); // 스케줄러 포함 끝 시각
		for (ScheduleReminderVO repeatSche : reminderRepeatScheList) {
			schedulerStartTime.setTime(fm.parse(nowTimeStr));
			schedulerStartTime.add(Calendar.MINUTE, Integer.parseInt(repeatSche.getOffSetMin()));
			
			if (Integer.parseInt(repeatSche.getStartDate().substring(8,10)) != Integer.parseInt(repeatSche.getRemindStartDate().substring(8,10))) {
				schedulerStartTime.add(Calendar.DATE, 1); // 하루전 알림으로 했을 시 스케줄러가 돌아가는 시점(nowTime)에 하루를 더한 날짜로 비교를 해야한다.
			}
			
			schedulerSTimePlusCronMin.setTime(schedulerStartTime.getTime());
			schedulerSTimePlusCronMin.add(Calendar.MINUTE, Integer.parseInt(cronMinute));
			
			schedulerStartDate.setTime(schedulerStartTime.getTime());
			setToMidnight(schedulerStartDate);
			
			int repeatCount = 1; // 반복횟수
			
			schedulerEndTime.setTime(schedulerStartTime.getTime());
			schedulerEndTime.add(Calendar.MINUTE, Integer.parseInt(cronMinute));
			
			String[] repRules = repeatSche.getRepetition().split("\\|");
			String repCycleRule = repRules[2];
			String remindStartDate = repeatSche.getRemindStartDate();
			int maxCycleCount = Integer.parseInt(repRules[0]); // 반복 횟수
			Calendar startCycleDate = Calendar.getInstance();
			Calendar lastCycleDate = Calendar.getInstance();
			
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			Date startTime = sdf.parse(remindStartDate);
			
			Calendar endDate = Calendar.getInstance();
			endDate.setTime(sdf.parse(repeatSche.getEndDate()));
			startCycleDate.setTime(startTime);
		
			switch (repCycleRule) {
			case "0": // 일반복
				int repCycleDate = Integer.parseInt(repRules[3]); // 반복 주기
				
				if (repCycleDate == 0) { // 매 평일 반복시
					if (schedulerStartTime.get(Calendar.DAY_OF_WEEK) == 1 || schedulerStartTime.get(Calendar.DAY_OF_WEEK) == 7) { // 주말이라면 패스
						continue;
					} else {
						repeatCount += countWeekDay(startCycleDate, schedulerStartTime);
					}
					
					while (startCycleDate.get(Calendar.DAY_OF_WEEK) == 1 || startCycleDate.get(Calendar.DAY_OF_WEEK) == 7) {
						startCycleDate.add(Calendar.DATE, 1);
					}
				} else { // 매 repCycleDate 마다 반복 시
			        long diffDateCount = (schedulerStartTime.getTime().getTime() - startCycleDate.getTime().getTime()) / (1000 * 60 * 60 * 24);
			        if (diffDateCount % repCycleDate != 0) { // 반복주기에 해당하는 날이 아니라면 패스
			        	continue;
			        } else {
			        	repeatCount += diffDateCount / repCycleDate;
			        }
				}
				
				if (startCycleDate.compareTo(schedulerSTimePlusCronMin) > 0) {
					continue; // 아직 반복 시작 날짜가 아닌 경우 
				}
				
				lastCycleDate.setTime(startCycleDate.getTime());
				setToMidnight(lastCycleDate);
				
				// 마지막 반복날짜 구함.
				if (maxCycleCount > 0) { // 반복 횟수가 지정되어있는 경우
					if (repCycleDate == 0) { // 매 평일 반복시, 매 평일 반복 시 한 주에 일정 가능 날은 5일이다.
						int repeatCnt = 1;
						while (repeatCnt < maxCycleCount) {
							lastCycleDate.add(Calendar.DATE, 1);
							if (lastCycleDate.get(Calendar.DAY_OF_WEEK) != 1 && lastCycleDate.get(Calendar.DAY_OF_WEEK) != 7) {
								repeatCnt++;
							}
						}
						
					} else {
						lastCycleDate.add(Calendar.DAY_OF_MONTH, (maxCycleCount - 1) * repCycleDate); // 마지막 반복 일정 날짜의 일정 시작 시각으로 세팅됨.
					}
					if (lastCycleDate.compareTo(schedulerStartDate) == 0) { // 반복횟수가 지정되어있는 경우, 해당 일정의 날짜가 이미 지난 일정인지 확인. 시작 시각과 스케줄러 시각은 아래에서 공통으로 비교함.
	        			//마지막 반복 주기라면 완료 일정에 추가 
	        			reminderCompleteList.add(repeatSche);
	        		} else if (lastCycleDate.compareTo(schedulerStartDate) < 0) { //반복일정의 경우 완료된 일정날에 삭제가 되지만, 혹시 몰라 일정이 지난 경우 완료될 수 있도록 추가.
	        			reminderCompleteList.add(repeatSche);
	        			continue;
	        		}
	        	}
	        	
				break;
			case "1": // 주반복
				int repCycleWeek = Integer.parseInt(repRules[3]);
				
				String[] tempRepDays = repRules[4].split(""); // 반복 요일 리스트 (일요일이 0, 토요일이 6)
				List <Integer> repDays = new ArrayList <Integer>(); // 반복 요일만 존재
				List <Integer> repDaysAddedStartday = new ArrayList <Integer>(); // 반복 요일에 일정 시작 요일 추가
				for (String day : tempRepDays) {
					repDays.add(Integer.parseInt(day) + 1); // (Calendar 객체에선 일요일이 1, 토요일이 7)
					repDaysAddedStartday.add(Integer.parseInt(day) + 1);
				}
				
				// 현재 시각이 반복 요일에 해당하는 요일이 아니라면 패스
				if (!repDays.contains(schedulerStartTime.get(Calendar.DAY_OF_WEEK))) {
					// 매 주 - 반복 요일이 아님.
					continue;
				}
				
				int startDay = startCycleDate.get(Calendar.DAY_OF_WEEK);
				repDaysAddedStartday.add(startDay);
				
				Collections.sort(repDaysAddedStartday);

				int repStartDay = -1;
				int repEndDay = -1;
				// 반복 첫 주기 날짜 구하기
				for (int i = 0; i < repDaysAddedStartday.size(); i++) {
					int repDay = repDaysAddedStartday.get(i);
					if (repDay >= startDay) {
						// 첫 반복 주기의 시작 날짜 구하기
						if (i == repDaysAddedStartday.size() - 1) { // 반복 요일들보다 일정 시작 요일이 늦은 경우 일정 시작 날짜의 다음 반복주기 주 첫 반복 요일이 첫 반복 주기의 시작 날짜이다.
							repStartDay = repDays.get(0);
							repEndDay = repDays.get(repDays.size() - 1);
							startCycleDate.add(Calendar.DAY_OF_MONTH, repCycleWeek * 7 - (startDay - repStartDay));
						} else { // 그 외의 경우에는 일정 요일과 같거나 반복 요일 중에서 일정 요일 바로 다음으로 오는 요일이 첫 반복 주기의 시작 날짜가 된다.
							repStartDay = repDays.get(i);
							startCycleDate.add(Calendar.DAY_OF_MONTH, repStartDay - startDay);
							if (i == 0) {
								repEndDay = repDays.get(repDays.size() - 1);
							} else {
								repEndDay = repDays.get(i - 1);
							}
						}
						
						break;
					}
				}
				
				if (startCycleDate.compareTo(schedulerSTimePlusCronMin) > 0) {
					// 아직 반복 일정 시작 일이 아님.
					continue;
				}
				
				long diffWeekCount = countDiffWeek(startCycleDate, schedulerStartTime);
				if (diffWeekCount % repCycleWeek != 0) { // 반복주기에 해당하는 주가 아니라면 패스
		        	continue;
				} else {
					if (schedulerStartTime.get(Calendar.DAY_OF_WEEK) >= repStartDay) {
						repeatCount += diffWeekCount / repCycleWeek; // 반복 시작 요일보다 현재 요일이 같거나 늦으면, 반복 시작 요일의 반복이 끝나는 주와 동일한 주에 끝남.
					} else {
						repeatCount += diffWeekCount / repCycleWeek;
						repeatCount -= 1; // 반복 시작 요일보다 현재 요일이 빠르면, 반복 시작 요일이 끝나는 주 다음 반복 주차에 끝남.
					}
				}
				
				lastCycleDate.setTime(startCycleDate.getTime());
				setToMidnight(lastCycleDate);
				
				// 마지막 반복날짜 구함.
				if (maxCycleCount > 0) { // 반복 횟수가 지정되어있는 경우
					if (repStartDay == repDays.get(0)) {
						lastCycleDate.add(Calendar.WEEK_OF_YEAR, (maxCycleCount - 1) * repCycleWeek);
					} else {
						lastCycleDate.add(Calendar.WEEK_OF_YEAR, (maxCycleCount) * repCycleWeek);
					}
					
					lastCycleDate.add(Calendar.DAY_OF_MONTH, repEndDay - repStartDay);
				
					if (lastCycleDate.compareTo(schedulerStartDate) == 0) {
						//마지막 반복 주기라면 완료 일정에 추가 
		        		reminderCompleteList.add(repeatSche);
					} else if (lastCycleDate.compareTo(schedulerStartDate) < 0) { //반복일정의 경우 완료된 일정날에 삭제가 되지만, 혹시 몰라 일정이 지난 경우 완료될 수 있도록 추가.
	        			reminderCompleteList.add(repeatSche);
	        			continue;
	        		}
				}
				
				break;
			case "2": // 월반복
				int repCycleMonth = Integer.parseInt(repRules[4]);
				switch (repRules[3]) {
				case "1": // 날짜 반복
					int repCycleDateOfMonth = Integer.parseInt(repRules[5]);
					if (schedulerStartTime.get(Calendar.DAY_OF_MONTH) !=  repCycleDateOfMonth) {
						// 반복 일자에 해당하는 날이 아님
						continue;
					}
					
					// 시작 날짜 구하기.
					boolean isExistStartCycleDate = false;
					if (startCycleDate.getActualMaximum(Calendar.DAY_OF_MONTH) >= repCycleDateOfMonth) {
						if (startCycleDate.get(Calendar.DAY_OF_MONTH) <= repCycleDateOfMonth) {
							startCycleDate.set(Calendar.DAY_OF_MONTH, repCycleDateOfMonth);
							isExistStartCycleDate = true;
						}
					}
					
					while (!isExistStartCycleDate) {
						startCycleDate.add(Calendar.MONTH, repCycleMonth);
						if (startCycleDate.getActualMaximum(Calendar.DAY_OF_MONTH) >= repCycleDateOfMonth) {
							startCycleDate.set(Calendar.DAY_OF_MONTH, repCycleDateOfMonth);
							isExistStartCycleDate = true;
							break;
						}
					}
					
					if (startCycleDate.compareTo(schedulerSTimePlusCronMin) > 0) {
						// 아직 첫 일정 시작일이 아님.
						continue;
					}
					
					int diffMonthCount = countDiffMonth(startCycleDate, schedulerStartTime);
					
					if (diffMonthCount % repCycleMonth != 0) {
						// 반복 주기에 해당하는 달이 아님.
						continue;
					}
					
					if (maxCycleCount > 0) {
						lastCycleDate.setTime(startCycleDate.getTime());
						setToMidnight(lastCycleDate);
						// 반복 횟수 지정 시 반복 일정 확인.
						while (repeatCount < maxCycleCount) {
							lastCycleDate.add(Calendar.MONTH, repCycleMonth);
							// 해당 달에 반복 일자가 없으면 패스
							if (lastCycleDate.getActualMaximum(Calendar.DAY_OF_MONTH) < repCycleDateOfMonth) {
								continue;
							} else {
								// repCycleDateOfMonth 31일 같은 경우 MONTH를 1 증가 시킬 때마다 마지막 날짜가 변경될 수 있음.
								lastCycleDate.set(Calendar.DAY_OF_MONTH, repCycleDateOfMonth);
							}
							repeatCount++;
							if (lastCycleDate.compareTo(schedulerStartDate) == 0) {
								// 반복 주기를 도는 도중에 현재 날짜를 발견
								break;
							}
						}
						// 마지막 반복 일자까지 구했는데 해당 일정이 이미 지난 일정이라면 패스
						if (repeatCount == maxCycleCount && lastCycleDate.compareTo(schedulerStartDate) == 0) {
							//마지막 반복 주기라면 완료 일정에 추가 
							reminderCompleteList.add(repeatSche);
						}  else if (repeatCount == maxCycleCount && lastCycleDate.compareTo(schedulerStartDate) < 0) { //반복일정의 경우 완료된 일정날에 삭제가 되지만, 혹시 몰라 일정이 지난 경우 완료될 수 있도록 추가.
		        			reminderCompleteList.add(repeatSche);
		        			continue;
		        		}
					} else { 
						Calendar tempCal = Calendar.getInstance();
						tempCal.setTime(startCycleDate.getTime());
						setToMidnight(tempCal);
						boolean repeatFlag = false;
						if (maxCycleCount == 0) {// 종료일자가 정해져있는 경우
							lastCycleDate.setTime(endDate.getTime());
							setToMidnight(lastCycleDate);
							repeatFlag = tempCal.compareTo(lastCycleDate) <= 0;
						} else {
							repeatFlag = true;
						}
						
						while(repeatFlag) {
							if (tempCal.compareTo(schedulerStartDate) == 0 || tempCal.compareTo(schedulerStartDate) > 0) {
								// 반복 주기를 도는 도중에 현재 날짜를 발견하면 멈춤. 현재날짜보다 큰 경우는 없을 텐데 혹시 무한 루프 돌 수 있어서 추가.
								break;
							}
							
							tempCal.add(Calendar.MONTH, repCycleMonth);
							// 해당 달에 반복 일자가 없으면 패스
							if (tempCal.getActualMaximum(Calendar.DAY_OF_MONTH) < repCycleDateOfMonth) {
								continue;
							} else {
								// repCycleDateOfMonth 31일 같은 경우 MONTH를 1 증가 시킬 때마다 마지막 날짜가 변경될 수 있음.
								tempCal.set(Calendar.DAY_OF_MONTH, repCycleDateOfMonth);
							}
							repeatCount++;
							
							if (maxCycleCount == 0) {
								repeatFlag = tempCal.compareTo(lastCycleDate) < 0;
							}
							
						}
					}
				
					break;
				
				case "2": // 요일 반복
					int weekOrder = Integer.parseInt(repRules[5]); // 몇째주
					int repDayOfWeek = Integer.parseInt(repRules[6]) + 1; // 요일 (Calendar 요일에 맞게 + 1을 함)
					
					if (schedulerStartTime.get(Calendar.DAY_OF_WEEK) != repDayOfWeek) {
						// 반복 요일에 해당하지 않음
						continue;
					}
					
					Calendar targetDate = Calendar.getInstance(); // 첫 반복 시작 일정이 시작 일정의 달에 있는지 판단하기 위한 임시 객체 
					targetDate.setTime(startCycleDate.getTime());
					
					// 첫 시작 일자 구하기
					targetDate = setTargetWeekDay(targetDate, weekOrder, repDayOfWeek);
					
					if (targetDate.compareTo(startCycleDate) >= 0) {
						startCycleDate.setTime(targetDate.getTime());
					} else {
						startCycleDate.add(Calendar.MONTH, repCycleMonth);
						startCycleDate = setTargetWeekDay(startCycleDate, weekOrder, repDayOfWeek);
					}
					
					if (startCycleDate.compareTo(schedulerSTimePlusCronMin) > 0) {
						// 아직 일정 시작날짜가 아님.
						continue;
					}

					long diffMonths = countDiffMonth(startCycleDate, schedulerStartTime);
					
					if (diffMonths % repCycleMonth != 0) {
						// 반복 주기 월에 해당하지 않음.
						continue;
					} else {
						repeatCount += diffMonths / repCycleMonth;
					}
					
					Calendar targetCal = Calendar.getInstance();
					targetCal.setTime(startCycleDate.getTime());
					
					targetCal.add(Calendar.MONTH, (int) diffMonths);
					targetCal = setTargetWeekDay(targetCal, weekOrder, repDayOfWeek);
					
					if (targetCal.get(Calendar.DAY_OF_MONTH) != schedulerStartTime.get(Calendar.DAY_OF_MONTH)) {
						// 반복 주기 월의 날짜가 현재 날짜와 일치하지 않음.
						continue;
					}
					
					lastCycleDate.setTime(startCycleDate.getTime());
					setToMidnight(lastCycleDate);
					
					if (maxCycleCount > 0) {
						lastCycleDate.add(Calendar.MONTH, (maxCycleCount - 1) * repCycleMonth);
						lastCycleDate = setTargetWeekDay(lastCycleDate, weekOrder, repDayOfWeek);
						
						if (lastCycleDate.compareTo(schedulerStartDate) == 0) {
							//마지막 반복 주기라면 완료 일정에 추가 
							reminderCompleteList.add(repeatSche);
						} else if (lastCycleDate.compareTo(schedulerStartDate) < 0) { //반복일정의 경우 완료된 일정날에 삭제가 되지만, 혹시 삭제가 되지 않은 경우를 대비해 일정이 지난 경우 완료될 수 있도록 추가.
		        			reminderCompleteList.add(repeatSche);
		        			continue;
		        		}
					}
						
					break;
				}
				
				break;
			case "3": // 년반복
				int repMonth = Integer.parseInt(repRules[4]) - 1; //Calendar 객체에는 1월이 0부터 시작.
				if (schedulerStartTime.get(Calendar.MONTH) != repMonth) {
					// 매년 반복 월이 아님.
					continue;
				}
				
				int lastCycleYear = -1;
				Calendar targetCal = Calendar.getInstance();
				targetCal.setTime(startCycleDate.getTime()); // 시작 일정의 시간으로 targetCal 세팅
				switch (repRules[3]) {
				case "1": // 특정 월 일 반복 
					int repDate = Integer.parseInt(repRules[5]);
					if (repDate != schedulerStartTime.get(Calendar.DAY_OF_MONTH)) {
						// 매년 반복 일이 아님.
						continue;
					}
					
					// 마지막 반복 일정 비교 목적 세팅
					targetCal.set(Calendar.YEAR, startCycleDate.get(Calendar.YEAR));
					targetCal.set(Calendar.MONTH, repMonth);
					targetCal.set(Calendar.DAY_OF_MONTH, repDate);
					
					break;
				case "2": // 특정 월 주 요일
					int weekOrder = Integer.parseInt(repRules[5]); // 몇째주
					int repDayOfWeek = Integer.parseInt(repRules[6]) + 1; // 요일 (Calendar 요일에 맞게 + 1을 함)
					
					targetCal.set(Calendar.YEAR, schedulerStartTime.get(Calendar.YEAR));
					targetCal.set(Calendar.MONTH, repMonth);
					targetCal = setTargetWeekDay(targetCal, weekOrder, repDayOfWeek);
					
					if (targetCal.get(Calendar.DAY_OF_MONTH) != schedulerStartTime.get(Calendar.DAY_OF_MONTH)) {
						// 매년 반복 주 요일이 아님.
						continue;
					}
					
					// 첫번째 반복 일정 날짜 구하기 위한 목적 세팅.
					targetCal.set(Calendar.YEAR, startCycleDate.get(Calendar.YEAR));
					targetCal = setTargetWeekDay(targetCal, weekOrder, repDayOfWeek);
					
					break;	
				}
				
				// 첫 반복일정 시작 날짜 구함.
				if (targetCal.get(Calendar.DAY_OF_YEAR) >= startCycleDate.get(Calendar.DAY_OF_YEAR)) {
					// 일정 시작 날짜의 해당 년도부터 반복 시작.
					repeatCount += schedulerStartTime.get(Calendar.YEAR) - startCycleDate.get(Calendar.YEAR);
					startCycleDate.setTime(targetCal.getTime());
				} else {
					// 일정 시작 날짜의 다음 년도부터 반복 시작.
					repeatCount += schedulerStartTime.get(Calendar.YEAR) - startCycleDate.get(Calendar.YEAR) - 1;
					startCycleDate.setTime(targetCal.getTime());
					startCycleDate.add(Calendar.YEAR, 1);
					
					if (repRules[3] == "2") { // 특정 월 주 요일 반복 시 일자 다시 세팅.
						int weekOrder = Integer.parseInt(repRules[5]); // 몇째주
						int repDayOfWeek = Integer.parseInt(repRules[6]) + 1; // 요일 (Calendar 요일에 맞게 + 1을 함)
						startCycleDate = setTargetWeekDay(startCycleDate, weekOrder, repDayOfWeek);
					}
				}
				
				if (startCycleDate.compareTo(schedulerSTimePlusCronMin) > 0) {
					continue; // 아직 일정 시작 날짜가 아님.
				}
				
				// 마지막 반복 일정 비교
				if (maxCycleCount > 0) {
					lastCycleYear = startCycleDate.get(Calendar.YEAR) + (maxCycleCount - 1);
					
					if (lastCycleYear == schedulerStartDate.get(Calendar.YEAR)) {
						//마지막 반복 주기라면 완료 일정에 추가 
						reminderCompleteList.add(repeatSche);
					} else if (lastCycleYear < schedulerStartDate.get(Calendar.YEAR)) { //반복일정의 경우 완료된 일정날에 삭제가 되지만, 혹시 몰라 일정이 지난 경우 완료될 수 있도록 추가.
	        			reminderCompleteList.add(repeatSche);
	        			continue;
	        		}
					
				}
				
				break;
			} // switch문 종료
			repeatSche.setRepeatCount(repeatCount);
			SimpleDateFormat dateSdf = new SimpleDateFormat("yyyy-MM-dd");
			String todayDate = dateSdf.format(schedulerStartTime.getTime());
			repeatSche.setTodayDate(todayDate);
			
			repScheForRemind.put(repeatSche.getScheduleId(), repeatSche);
			
			// 종료일자가 정해져 있는 경우, 현재 날짜가 마지막 종료일자라면, reminderStatus를 완료로 변경해줘야함.
			if (maxCycleCount == 0) {
				setToMidnight(endDate);
				if (schedulerStartDate.compareTo(endDate) == 0) { // 종료일자가 정해져있는 경우,종료일이 이미 지난 일정은 쿼리에서 데이터를 가져오지 않음.
					reminderCompleteList.add(repeatSche);
				}
			}
		} // 반복일정 for문 종료
		
		if (repScheForRemind.size() > 0) {
			// 반복 일정 중 삭제 일정은 알림에서 제거.
			List<ScheduleReminderVO> repeatDelScheList = ezScheduleDAO.selectRepeatDelScheList(map);
			for (ScheduleReminderVO delSche : repeatDelScheList) {
				int delScheId = delSche.getScheduleId();
				repScheForRemind.remove(delScheId);
				// 삭제 일정 제외
			}
			
			// 반복 일정 중 완료 일정은 알림에서 제거.
			List<ScheduleReminderVO> repCompletScheList = ezScheduleDAO.selectRepeatCompletScheList(map);
			for (ScheduleReminderVO comSche : repCompletScheList) {
				int comScheId = comSche.getScheduleId();
				repScheForRemind.remove(comScheId);
				// 완료 일정 제외
			}
		}
		
		for (ScheduleReminderVO reminder : repScheForRemind.values()) {
			reminderScheList.add(reminder);
		}
		
		List<ScheduleReminderVO> expiredScheduleList = ezScheduleDAO.selectExpiredSchedule(map); // 반복일정 중 종료 일정이 지정된 일정의 경우, 종료일정이 현재 시각보다 지난 일정은 reminderStatus를 완료로 변경해준다.
		
		if (expiredScheduleList != null && expiredScheduleList.size() > 0) {
			reminderCompleteList.addAll(expiredScheduleList);
		}

		Map<String, List<ScheduleReminderVO>> returnMap = new HashMap<String, List<ScheduleReminderVO>>();
		returnMap.put("reminderScheList", reminderScheList);
		returnMap.put("reminderCompleteList", reminderCompleteList);
		
		logger.debug("selectReminderScheList ended");
		return returnMap;
	}
	
	private int countWeekDay(Calendar startCycleDate, Calendar schedulerStartTime) {
		int weekDayCount = 0;
		Calendar tempCal = Calendar.getInstance();
		tempCal.setTime(startCycleDate.getTime());
		tempCal.add(Calendar.DAY_OF_MONTH, 1); // 시작 일정 다음날 부터 판단.
		while (tempCal.compareTo(schedulerStartTime) <= 0) {
			int dayOfWeek = tempCal.get(Calendar.DAY_OF_WEEK);
			if (dayOfWeek != 1 && dayOfWeek != 7) {
				weekDayCount++;
			}
			tempCal.add(Calendar.DAY_OF_MONTH, 1);
		}
		if (startCycleDate.get(Calendar.DAY_OF_WEEK) == 1 || startCycleDate.get(Calendar.DAY_OF_WEEK) == 7) {
			weekDayCount -= 1; // 토요일 또는 일요일이 시작 일정이라면, 해당 날짜는 회차에 포함하면 안됨.
		}
		
		return weekDayCount;
	}
	
	private long countDiffWeek(Calendar startCycleDate, Calendar schedulerStartTime) {
		// 일정 시작 날짜
		LocalDate startDate = LocalDate.of(startCycleDate.get(Calendar.YEAR), startCycleDate.get(Calendar.MONTH) + 1, startCycleDate.get(Calendar.DAY_OF_MONTH));
		// 현재시각
		LocalDate targetDate = LocalDate.of(schedulerStartTime.get(Calendar.YEAR), schedulerStartTime.get(Calendar.MONTH) + 1, schedulerStartTime.get(Calendar.DAY_OF_MONTH));
		long weeksBetween = ChronoUnit.WEEKS.between(startDate, targetDate);
		
		if (startCycleDate.get(Calendar.DAY_OF_WEEK) > schedulerStartTime.get(Calendar.DAY_OF_WEEK)) {
			weeksBetween += 1; // 날짜의 차이를 가지고 주를 계산하기 때문에, 주 계산시 오차를 없앰. (ex ) 두 날짜의 차이가 20일이라면 주의 차이가 실제로는 3주가 될 수 있지만, weeksBetween값이 2가 된다.)
		}
		
		return weeksBetween;
	}
	
	private int countDiffMonth(Calendar startCycleDate, Calendar schedulerStartTime) {
		// 일정 시작 날짜
		int startDateYear = startCycleDate.get(Calendar.YEAR);
		int startDateMonth = startCycleDate.get(Calendar.MONTH);
		int schedulerYear = schedulerStartTime.get(Calendar.YEAR);
		int schedulerMonth = schedulerStartTime.get(Calendar.MONTH);
		int monthBetween = (schedulerYear - startDateYear) * 12 + schedulerMonth - startDateMonth;
		return monthBetween;
	}

	// 2023-08-30 한태훈 - 일정관리 > 미리알림 > 몇째 주 무슨 요일에 해당하는 날 반환 메소드 
	public Calendar setTargetWeekDay(Calendar targetDate, int weekOrder, int repDayOfWeek) {
		int targetDay = -1;
		if (weekOrder != 5) {// 몇 째주의 설정값(weekOrder)이 마지막 주가 아닌 첫째, 둘째, 셋째, 넷째 주 인경우
			targetDate.set(Calendar.DAY_OF_MONTH, 1);
			targetDay = targetDate.get(Calendar.DAY_OF_WEEK);
			targetDate.add(Calendar.DAY_OF_MONTH, (weekOrder - 1) * 7);
			targetDate.add(Calendar.DAY_OF_MONTH, repDayOfWeek - targetDay >= 0 ? repDayOfWeek - targetDay : repDayOfWeek - targetDay + 7);
		} else {// 몇 째주의 설정값(weekOrder)이 마지막 주인경우
			targetDate.set(Calendar.DAY_OF_MONTH, targetDate.getActualMaximum(Calendar.DAY_OF_MONTH));
			targetDay = targetDate.get(Calendar.DAY_OF_WEEK);
			targetDate.add(Calendar.DAY_OF_MONTH, repDayOfWeek - targetDay <= 0 ? repDayOfWeek - targetDay : repDayOfWeek - targetDay - 7);
		}
		
		return targetDate;
	}

	@Override
	public void updateCompleteScheduleStatus(List<ScheduleReminderVO> reminderCompleteList, int tenantId) throws Exception {
		logger.debug("updateCompleteScheduleStatus started");
		
		Map<String, Object> reminderStatusMap = new HashMap<String, Object> ();
		for (ScheduleReminderVO comReminder : reminderCompleteList) {
			reminderStatusMap.put("v_SCHEDULEID", comReminder.getScheduleId());
			reminderStatusMap.put("v_REMINDERSTATUS", 1);
			reminderStatusMap.put("v_TENANTID", tenantId);
			ezScheduleDAO.updateReminderStatus(reminderStatusMap);
		}
		
		logger.debug("updateCompleteScheduleStatus ended");
	}

	@Override
	public void sendReminderMail(ScheduleReminderVO reminderSche) throws Exception {
		String offSet = reminderSche.getOffSetInfo();
		String datetype = reminderSche.getDateType();
		String startdate = reminderSche.getStartDate();
		String enddate = reminderSche.getEndDate();
		String lang = reminderSche.getLang();
		LoginVO tempLoginVO1 = new LoginVO();
		tempLoginVO1.setId(reminderSche.getCreatorId());
		tempLoginVO1.setTenantId(reminderSche.getTenantId());
		tempLoginVO1.setDn("NOPASSWORD");
		
		LoginVO fromUserInfo = loginService.selectUser(tempLoginVO1);
		fromUserInfo.setLang(lang); // 수신알림메일 발송 시 필요한 데이터 추가 (다국어 지원)
		fromUserInfo.setOffset(offSet);
		Locale locale = new Locale(commonUtil.getTwoLetterLangFromLangNum(fromUserInfo.getLang()));
		
		LoginVO tempLoginVO2 = new LoginVO();
		tempLoginVO2.setId(reminderSche.getOwnerId());
		tempLoginVO2.setTenantId(reminderSche.getTenantId());
		tempLoginVO2.setDn("NOPASSWORD");
		
		LoginVO toUserInfo = loginService.selectUser(tempLoginVO2);
		toUserInfo.setLang(lang); // 수신알림메일 발송 시 필요한 데이터 추가 (다국어 지원)
		toUserInfo.setOffset(offSet);
		
		String period = "";
		
		String todayDate = reminderSche.getTodayDate();
		
		String repetAllDayFlag = "";
		if (reminderSche.getRepetition() != null) {
			repetAllDayFlag = reminderSche.getRepetition().split("\\|")[1];
		}
		
		if (datetype.equals("3") && repetAllDayFlag.equals("0")) {
			period = todayDate + " " + startdate.substring(10,16) + " ~ "+ enddate.substring(10,16) + " (" + egovMessageSource.getMessage("ezSchedule.t343", locale) + ")";
        } else if (datetype.equals("2")) {
        	period = todayDate + " (" + egovMessageSource.getMessage("ezSchedule.t280", locale);        	
        } else if (datetype.equals("3") && repetAllDayFlag.equals("1")) {
        	period = todayDate + " (" + egovMessageSource.getMessage("ezSchedule.t280", locale) + " (" + egovMessageSource.getMessage("ezSchedule.t343", locale) + ")";
        } else {
        	period = todayDate + " " + startdate.substring(10,16) + " ~ "+ enddate.substring(10,16);
        }
		
		String primaryData = "";
		if (commonUtil.getPrimaryData(lang, reminderSche.getTenantId()).equals("1")) {
			primaryData = "1";
		} else {
			primaryData = "2";
		}
		
		String fromName = primaryData.equals("1") ? reminderSche.getCreatorName() : reminderSche.getCreatorName2();
		String toName = primaryData.equals("1") ? reminderSche.getOwnerName() : reminderSche.getOwnerName2();
		String title = reminderSche.getTitle();
		
		InternetAddress from = new InternetAddress();
		from.setPersonal(fromName, "UTF-8");
		from.setAddress(fromUserInfo.getEmail());
		
		List<InternetAddress> toList = new ArrayList<InternetAddress>();
		InternetAddress to = new InternetAddress();
		to.setPersonal(toName, "UTF-8");
		to.setAddress(toUserInfo.getEmail());
		toList.add(to);
		InternetAddress[] toArr = toList.toArray(new InternetAddress[toList.size()]);
		String userId = fromUserInfo.getId();
		String domainName = ezCommonService.getTenantConfig("DomainName", fromUserInfo.getTenantId());
		String userAccount = userId + "@" + domainName;
		String password  = jspw;
		
		String subject = egovMessageSource.getMessage("ezSchedule.hth05", locale) + " " + reminderSche.getTitle(); // [일정미리알림] + 일정 제목
		StringBuilder contentBuilder = new StringBuilder("<table width='750' cellpadding='0' cellspacing='0' border='0' ><tr align='left'><td>");
		int scheduleId = reminderSche.getScheduleId();
		String otherid = "";
		int repeatcount = reminderSche.getRepeatCount();
		String date = reminderSche.getTodayDate();
		String type = reminderSche.getScheduleType();
		String dateType = reminderSche.getDateType();
		String pattern = "0";
		contentBuilder.append("<span style='font-size:13px;'>" + egovMessageSource.getMessage("ezEmail.csj17", locale) + ": " + title + "</span><br>");
		contentBuilder.append("<span style='font-size:13px;'>" + egovMessageSource.getMessage("ezSchedule.hth06", locale) + ": " + fromName + "</span><br>");
		contentBuilder.append("<span style='font-size:13px;'>" + egovMessageSource.getMessage("ezSchedule.hth07", locale) + ": " + period + "</span><br><br>");
		contentBuilder.append("<a id='reminder_link' ");
		contentBuilder.append("scheId='" + scheduleId + "' otherid='" + otherid + "' repeatcount='" + repeatcount + "' date='" + date + "' type='" + type +"' dateType='" + dateType + "' pattern='" + pattern +"'");
		contentBuilder.append(" sche-sdate='" + startdate + "' sche-edate='" + enddate + "'");
		contentBuilder.append(" onclick='javascript:reminderMailLink();' style='cursor: pointer; font-size: 13px; color: blue;'><br>");
		contentBuilder.append(egovMessageSource.getMessage("ezEmail.hth01", locale));
		contentBuilder.append("</a>");
		contentBuilder.append("</td></tr></table>");
		
		ezEmailService.sendMail(userAccount, password, locale, from, toArr, null, null, subject, commonUtil.createNotiMailContent(contentBuilder.toString(), fromUserInfo.getTenantId(), locale), false, EmailImportance.NORMAL);
		String linkUrl = "/ezSchedule/scheduleRead.do?";
		linkUrl += "id=" + reminderSche.getScheduleId() + "&repeatcount=" + repeatcount + "&date=" + date + "&type=" + type + "&datetype=" + datetype + "&pattern=" + pattern;
		
		String linkUrlMobile = "";
		if (repeatcount > 0) {
			linkUrlMobile = "/mobile/ezSchedule/mScheduleDetail.do?scheduleId=" + reminderSche.getScheduleId() + "&startDate=" + startdate + "&endDate=" + enddate + "&date=" + date + "&repeatCount=" + repeatcount + "&type=monthList" + "&purpose=scheduleInfoDetail" ;
		} else {
			linkUrlMobile = "/mobile/ezSchedule/mScheduleDetail.do?scheduleId=" + reminderSche.getScheduleId() + "&startDate=" + startdate + "&endDate=" + enddate + "&date=" + date + "&type=monthList" + "&purpose=scheduleInfoDetail";
		}
		
		List<Map<String,Object>> notiRecipientList = new ArrayList<Map<String, Object>> ();
		Map<String, Object> recipientMap = new HashMap<String, Object>();
		recipientMap.put("userType", "PERSON");
		recipientMap.put("companyId", reminderSche.getCompanyId());
		recipientMap.put("cn", reminderSche.getOwnerId());
		notiRecipientList.add(recipientMap);
		
		ezNotificationService.sendNoti(reminderSche.getCreatorId(), fromName, notiRecipientList, "SCHEDULE", "REMINDER", title, "popup", "760", "750", linkUrl, linkUrlMobile, "notChkSetting");
	}
	
	// 2023-09-15 한태훈 - 일정관리 > 일정그룹 정보 가져오기
	@Override
	public ScheduleGroupListVO selectScheduleGroupInfo(String groupId, int tenantId) throws Exception {
		Map <String, Object> map = new HashMap<String, Object> ();
		map.put("v_GROUPID", groupId);
		map.put("v_TENANTID", tenantId);

		return ezScheduleDAO.selectScheduleGroupInfo(map);
	}

	@Override
	public void updateAllDaySTimeForReminder(String allDaySTimeForReminder, int tenantId) throws Exception {
		SysParamVO sysParamVO = new SysParamVO();
		sysParamVO.setTenantID(tenantId);
		sysParamVO.setName("allDaySTimeForReminder");
		sysParamVO.setValue(allDaySTimeForReminder);
		
		ezSystemAdminDAO.updateSysParam(sysParamVO);
	}
	
	// 시간을 제외한 날짜만 남기기 위해 시간, 분, 초, 밀리초를 0으로 설정하는 메소드
    private void setToMidnight(Calendar calendar) {
        calendar.set(Calendar.HOUR_OF_DAY, 0);
        calendar.set(Calendar.MINUTE, 0);
        calendar.set(Calendar.SECOND, 0);
        calendar.set(Calendar.MILLISECOND, 0);
    }

	@Override
	public void updateScheduleWritePermission(String groupId, List<Map<String, String>> memberList, int tenantId) throws Exception {
		logger.debug("updateScheduleWritePermission started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		
   		map.put("v_GROUPID", groupId);
		map.put("v_TENANTID", tenantId);
		
		for (Map<String, String> member : memberList) {
            String memberId = member.get("memberId");
            String writePermission = member.get("writePermission");
            
    		map.put("v_MEMBERID", memberId);
    		map.put("v_WRITEPERMISSION", writePermission);

            ezScheduleDAO.updateWritePermission(map);
		}

		logger.debug("updateScheduleWritePermission ended");
	}
	
	@Override
	public String checkExecutiveType(String userID, String companyID, int tenantID) throws Exception {
		logger.debug("checkExecutiveType started.");

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_USERID", userID);
		map.put("v_TENANTID", tenantID);
		map.put("v_COMPANYID", companyID);

		String userType = ezScheduleDAO.checkExecutiveType(map);

		logger.debug("checkExecutiveType ended. result = " + userType);
		return userType;
	}

	@Override
	public String checkExecutiveUsage(String userID, String companyID, int tenantID) throws Exception {
		logger.debug("checkExecutiveUsage started.");

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_USERID", userID);
		map.put("v_TENANTID", tenantID);
		map.put("v_COMPANYID", companyID);

		String usage = ezScheduleDAO.checkExecutiveUsage(map);

		logger.debug("checkExecutiveUsage ended. result = " + usage);
		return usage;
	}
	
	/* 2023-09-27 임정은 - 모아보기 그룹 관리 리스트 리턴하는 메서드 */
	@Override
	public List<ScheduleGroupListVO> getMyGatherList(String userID, int tenantID, String companyID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_USERID", userID);
		map.put("v_TENANTID", tenantID);
		map.put("v_COMPANYID", companyID);

		List<ScheduleGroupListVO> gList = ezScheduleDAO.getMyGatherList(map);

		return gList;
	}

	/* 2023-09-27 임정은 - 모아보기 그룹 관리 리스트별 멤버 수 리턴하는 메서드 */
	@Override
	public int getMyGatherMemberCnt(String groupId, String lang, int tenantId, String companyID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_GROUPID", groupId);
		map.put("v_LANG", lang);
		map.put("v_TENANTID", tenantId);
		map.put("v_COMPANYID", companyID);

		int cnt = ezScheduleDAO.getMyGatherMemberCnt(map);

		return cnt;
	}

	/* 2023-10-04 임정은 - 모아보기 그룹 추가 시 tbl_schedulegather에 insert하는 메서드 */
	@Override
	public void insertScheduleGather(String gUID, String id, String displayName,	String displayName2, String groupName, String description, int tenantId, String companyID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_GUID", gUID);
		map.put("v_USERID", id);
		map.put("v_DISPLAYNAME", displayName);
		map.put("v_DISPLAYNAME2", displayName2);
		map.put("v_GROUPNAME", groupName);
		map.put("v_DESCRIPTION", description);
		map.put("v_TENANTID", tenantId);
		map.put("v_COMPANYID", companyID);

		ezScheduleDAO.insertScheduleGather(map);
	}

	/* 2023-10-04 임정은 - 모아보기 그룹 추가 시 tbl_schedulegathermember에 insert하는 메서드 / 모아보기 그룹 관리 > 그룹 관리 버튼 > 구성원 추가/편집 버튼 > 구성원 추가 */
	@Override
	public void insertScheduleGatherMember(String groupId, String memberId, String memberName, String memberName2, String memberDeptId, int tenantId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_GROUPID", groupId);
		map.put("v_MEMBERID", memberId);
		map.put("v_MEMBERNAME", memberName);
		map.put("v_MEMBERNAME2", memberName2);
		map.put("v_MEMBERDEPTID", memberDeptId);
		map.put("v_TENANTID", tenantId);
		ScheduleGroupListVO scheduleGatherMember = ezScheduleDAO.selectScheduleGatherMember(map);
		
		if (scheduleGatherMember == null) {
			ezScheduleDAO.insertScheduleGatherMember(map);
		} else {
			ezScheduleDAO.updateScheduleGatherMember(map);
		}
	}

	/* 2023-10-04 임정은 - 모아보기 그룹 관리 > 그룹 선택 시 상세 정보 리턴하는 메소드 */
	public List<ScheduleGroupListVO> getMyGatherMemberList(String groupId, String lang, int tenantId, String companyID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_GROUPID", groupId);
		map.put("v_LANG", lang);
		map.put("v_TENANTID", tenantId);
		map.put("v_COMPANYID", companyID);

		List<ScheduleGroupListVO> gList = ezScheduleDAO.getMyGatherMemberList(map);

		return gList;
	}

	/* 2023-10-04 임정은 - 모아보기 그룹 관리 > 그룹 선택 후 삭제 버튼 */
	@Override
	public void deleteScheduleGather(String groupId, int tenantId, String memberId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_GROUPID", groupId);
		map.put("v_TENANTID", tenantId);

		if ("".equals(memberId)) {
			ezScheduleDAO.deleteScheduleGather(map);
		} else {
			map.put("v_MEMBERID", memberId);
		}
		ezScheduleDAO.deleteScheduleGatherMember(map);
	}

	/* 2023-10-04 임정은 - 모아보기 그룹 관리 > 그룹 관리 버튼 */
	@Override
	public List<ScheduleGroupListVO> getGatherMemberList(String groupID, String lang, int tenantId, String offSetMin, String companyID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_GROUPID", groupID);
		map.put("v_LANG", lang);
		map.put("v_TENANTID", tenantId);
		map.put("v_OFFSETMIN", offSetMin);
		map.put("v_COMPANYID", companyID);

		List<ScheduleGroupListVO> gList = ezScheduleDAO.getGatherMemberList(map);

		return gList;
	}

	/* 2023-10-05 임정은 - 모아보기 그룹 관리 > 그룹 관리 버튼 > 그룹명, 설명 수정 후 저장 버튼 */
	@Override
	public void updateScheduleGather(String groupId, String id, String groupName, String description, int tenantId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_GUID", groupId);
		map.put("v_USERID", id);
		map.put("v_GROUPNAME", groupName);
		map.put("v_DESCRIPTION", description);
		map.put("v_TENANTID", tenantId);

		ezScheduleDAO.updateScheduleGather(map);
	}

	@Override
	public List<ScheSecretaryVO> getPublicExceSchedule(Map<String, Object> param) throws Exception {
		logger.debug("getPublicExceSchedule started.");
		
		List<ScheSecretaryVO> result = ezScheduleDAO.getPublicExceSchedule(param);
		
		logger.debug("getPublicExceSchedule ended.");
		
		return result;
	}
	
	@Override
	public void setScheduleViewStatus(String userId, int tenantId, String status) throws Exception {
		logger.debug("setScheduleViewStatus started");

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userId",userId);
		map.put("tenantId",tenantId);
		map.put("status", status);
		
		ezScheduleDAO.setScheduleViewStatus(map);
		
		
		logger.debug("setScheduleViewStatus ended");
		
	}

	@Override
	public void insertScheduleConfig(String userID, String defaultView, String startDay, String startTime,
			String endTime, String autoDelete, int tenantID, String reminderTime, String defaultViewCheckBox, List<ScheduleTypeConfigVO> tagColors) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_USERID", userID);		
		map.put("v_DEFAULTVIEW", defaultView);
		map.put("v_STARTDAY", startDay);
		map.put("v_STARTTIME", startTime);
		map.put("v_ENDTIME", endTime);
		map.put("v_AUTODELETE", autoDelete);
		map.put("v_TENANTID", tenantID);
		map.put("v_REMINDERTIME", reminderTime);
		map.put("v_DEFAULTVIEWCHECKBOX", defaultViewCheckBox);
		
		if(ezScheduleDAO.getUserScheduleConfig(map) == null) {			
			ezScheduleDAO.insertScheduleConfig(map);
		}
		else {
			ezScheduleDAO.modifyScheduleConfig(map);
		}
		
		// 이후 진행되는 로직이 있기 때문에 try-catch 블럭
		try {
			for (ScheduleTypeConfigVO vo : tagColors) {
				ezScheduleDAO.upsertUserScheTagColor(vo);
			}
		} catch (Exception e) {
			logger.debug("Exception occurred in ezScheduleDAO.upsertUserScheTagColor(): {}", e.getMessage());
		}
	}

	@Override
	public List<ScheduleTypeConfigVO> getUserScheduleTypeConfig(String userID, String companyID, int tenantID) throws Exception {
		Map<String, Object> param = new HashMap<>();
		param.put("userID", userID);
		param.put("tenantID", tenantID);
		param.put("companyID", companyID);
		
		return ezScheduleDAO.getUserScheduleTypeConfig(param);
	}

	@Override
	public String saveIsTagChecked(String userID, String scheduleType, String relatedID, String isChecked, int tenantID, String companyID) {
		
		try {
			Map<String, Object> param = new HashMap<>();
			param.put("userID", userID);
			param.put("scheduleType", scheduleType);
			param.put("relatedID", relatedID);
			param.put("isChecked", Integer.parseInt(isChecked));
			param.put("tenantID", tenantID);
			param.put("companyID", companyID);
			
			ezScheduleDAO.saveIsTagChecked(param);
		} catch (Exception e) {
			logger.debug("Error occurred while executing ezScheduleService.saveIsTagChecked(): {}", e.getMessage());
			return "FALSE";
		}
		
		return "TRUE";
	}

	@Override
	public String getUserScheduleTypeColor(String userId, String companyId, int tenantId, String scheduleType, String relatedId) {
		Map<String, Object> param = new HashMap<>();
		param.put("userID", userId);
		param.put("companyID", companyId);
		param.put("tenantID", tenantId);
		param.put("scheduleType", scheduleType);
		param.put("relatedId", relatedId);
		
		return ezScheduleDAO.getUserScheduleTypeColor(param);
	}

	@Override
	public List<ScheDeptVO> getShareScheduleDept(Map<String, Object> param) throws Exception {
		logger.debug("getShareScheduleDept started.");
		
		List<ScheDeptVO> result = ezScheduleDAO.getShareScheduleDept(param);
		
		logger.debug("getShareScheduleDept ended.");
		
		return result;
	}

	@Override
	public List<ScheDeptVO> getAddJobSchedule(Map<String, Object> param) throws Exception {
		logger.debug("getAddJobSchedule started.");
		
		List<ScheDeptVO> result = ezScheduleDAO.getAddJobSchedule(param);
		
		logger.debug("getAddJobSchedule ended.");
		
		return result;
	}
}
