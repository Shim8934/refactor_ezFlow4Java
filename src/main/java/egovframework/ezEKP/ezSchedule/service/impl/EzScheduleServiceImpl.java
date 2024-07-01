package egovframework.ezEKP.ezSchedule.service.impl;

import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
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
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
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
import egovframework.ezEKP.ezSchedule.vo.ScheGetHolidayVO;
import egovframework.ezEKP.ezSchedule.vo.ScheduleConfigVO;
import egovframework.ezEKP.ezSchedule.vo.ScheduleCumulerVO;
import egovframework.ezEKP.ezSchedule.vo.ScheduleDeptVO;
import egovframework.ezEKP.ezSchedule.vo.ScheduleGroupListVO;
import egovframework.ezEKP.ezSchedule.vo.ScheduleGroupVO;
import egovframework.ezEKP.ezSchedule.vo.ScheduleInfoVO;
import egovframework.ezEKP.ezSchedule.vo.ScheduleReceiveListVO;
import egovframework.ezEKP.ezSchedule.vo.ScheduleSecretaryVO;
import egovframework.ezEKP.ezSchedule.vo.ScheduleTokenInfoVO;
import egovframework.ezMobile.ezOption.vo.MCommonVO;
import egovframework.ezMobile.ezSchedule.vo.MScheduleInfoVO;
import egovframework.ezEKP.ezSchedule.vo.ScheduleMailConfigVO;
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
		map.put("v_INDILIST", indiList);
		map.put("v_PIDLIST", pidList);		
		map.put("v_PFILTER", filter);
		map.put("v_PSTARTDATE", utcStartDate);
		map.put("v_PENDDATE", utcEndDate);
		map.put("v_OFFSETMIN", offSetMin);
		map.put("v_TENANTID", tenantId);
		map.put("v_SEARCHTITLE", searchTitle);
		map.put("v_SEARCHALL", searchAll);
		map.put("v_SEARCHLOCATION", searchLocation);
		map.put("v_COMPANYID", companyID);
		map.put("v_USERID", userID);
		map.put("v_DEPTID", deptID);
		map.put("useAnnualScheduleYN", useAnnualScheduleYN);
		
		List<ScheduleInfoVO> sList = ezScheduleDAO.getScheduleList(map);

		// 2020-02-24 김정언 - 근태 현황 일정관리 연동
		if(!useAnnualScheduleYN.equals("0")){
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
			//반복일정 구현 끝
			else {
				resultList.add(vo);
			}
		}
		
		String useWorkspaceSchedule = ezCommonService.getTenantConfig("useWorkspaceSchedule", tenantId);
	    logger.debug("useWorkspaceSchedule : " + useWorkspaceSchedule);
		
		if (useWorkspaceSchedule == null || useWorkspaceSchedule.equals("")) {
			useWorkspaceSchedule = "NO";
		}
		
	    // 협업 일정 가져오기
	    if(useWorkspaceSchedule.equalsIgnoreCase("yes")) {
	    	String[] sDate = orgStartDate.split("-");
			String sMon = (sDate[1].length() == 1 ? "0" + sDate[1] : sDate[1]);
			String sDay = (sDate[2].length() == 1 ? "0" + sDate[2] : sDate[2]);
			
			String startDate = sDate[0] + "-" + sMon + "-" + sDay;
			
			String[] eDate = orgEndDate.split("-");		
			String eMon = (eDate[1].length() == 1 ? "0" + eDate[1] : eDate[1]);
			String eDay = (eDate[2].length() == 1 ? "0" + eDate[2] : eDate[2]);
			
			String endDate = eDate[0] + "-" + eMon + "-" + eDay;
			
			String workspaceHostUrl = ezCommonService.getTenantConfig("workspaceHostUrl", tenantId);
	        
			String domain = workspaceHostUrl + "/ezWorkspace/api/GroupwareApi/post/scheduleread/";
	    	String params = "userAccountId=" + URLEncoder.encode(userID, "UTF-8") + "&startDate=" + URLEncoder.encode(startDate, "UTF-8") 
	    						+ "&endDate=" + URLEncoder.encode(endDate, "UTF-8") + "&searchTerm=" + "&bMobile=" + URLEncoder.encode("false", "UTF-8");
	    	String workspaceScheduleLists = ezEmailUtil.getWebServiceResult(domain, params);
	    	
	    	if(workspaceScheduleLists != null && !workspaceScheduleLists.equals("")) {
		    	JSONParser jsonparser = new JSONParser();
		    	JSONArray jsonarray = (JSONArray)jsonparser.parse(workspaceScheduleLists);
		    	
		    	logger.debug("data.length = " + jsonarray.size());
		    	
		    	for(int i=0; i<jsonarray.size(); i++) {
		    		ScheduleInfoVO sVo = new ScheduleInfoVO();
		    		JSONObject jsonobject = (JSONObject)jsonarray.get(i);
		    		
		    		sVo.setDateType(jsonobject.get("ItemDateType").toString());
					sVo.setScheduleType("4");
					sVo.setScheduleId("collaboration:" + jsonobject.get("ItemId").toString());
					sVo.setParentId("collaboration:" + jsonobject.get("ItemPostId").toString());
					sVo.setStartDate(jsonobject.get("ItemStartDate").toString().replace("T", " "));
					sVo.setEndDate(jsonobject.get("ItemEndDate").toString().replace("T", " "));
					sVo.setCreatorName(jsonobject.get("ItemUserName").toString());
					sVo.setTitle(jsonobject.get("ItemPostTitle").toString());
					sVo.setOwnerId(jsonobject.get("ItemUserAccountId").toString());
					sVo.setOwnerName(jsonobject.get("ItemUserName").toString());
					sVo.setRepeatCount(Integer.parseInt(jsonobject.get("ItemRepeatCount").toString()));
					
					int importance = Integer.parseInt(jsonobject.get("ItemImportance").toString()) + 1;
					sVo.setImportance(importance + "");
	
					resultList.add(sVo);
		    	}
			}
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
		map.put("v_INDILIST", indiList);
		map.put("v_PIDLIST", pidList);		
		map.put("v_PFILTER", filter);
		map.put("v_PSTARTDATE", utcStartDate);
		map.put("v_PENDDATE", utcEndDate);
		map.put("v_OFFSETMIN", offSetMin);
		map.put("v_TENANTID", tenantId);
		map.put("v_SEARCHTITLE", searchTitle);
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
	public void insertScheduleGroupMember(String groupId, String memberId, String memberName, String memberName2, int tenantId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_GROUPID", groupId);
		map.put("v_MEMBERID", memberId);
		map.put("v_MEMBERNAME", memberName);
		map.put("v_MEMBERNAME2", memberName2);
		map.put("v_TENANTID", tenantId);
		
		ezScheduleDAO.insertScheduleGroupMember(map);
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
	public void insertScheduleConfig(String userID, String defaultView,	String startDay, String startTime, String endTime, String autoDelete, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_USERID", userID);		
		map.put("v_DEFAULTVIEW", defaultView);
		map.put("v_STARTDAY", startDay);
		map.put("v_STARTTIME", startTime);
		map.put("v_ENDTIME", endTime);
		map.put("v_AUTODELETE", autoDelete);
		map.put("v_TENANTID", tenantID);
		
		if(ezScheduleDAO.getUserScheduleConfig(map) == null) {			
			map.put("v_INVITATIONMAIL", "Y");
			map.put("v_CANCELLATIONMAIL", "Y");
			map.put("v_ATTENDANCEMAIL", "Y");
			map.put("v_REJECTEDMAIL", "Y");
			
			ezScheduleDAO.insertScheduleConfig(map);
		}
		else {
			ezScheduleDAO.modifyScheduleConfig(map);
		}
		
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
		NodeList attendantName, NodeList attendantName2, NodeList attendantDeptName, NodeList attendantDeptName2, String defaultPath, int tenantId, String companyID, String showtop) throws Exception {
		
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
	public void updateAttendant(String scheduleId, String attendantId, String displayName, String displayName2, String status, int tenantId, String showtop) throws Exception {
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
	public void updateDragSchedule(String scheduleid, String userId, String displayName1, String displayName2, String utcStartTime, String utcEndTime,int tenantId, String companyID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_SCHEDULEID", scheduleid);
		map.put("v_MODIFIERID", userId);
		map.put("v_MODIFIERNAME", displayName1);
		map.put("v_MODIFIERNAME2", displayName2);
		map.put("v_STARTDATE", utcStartTime);
		map.put("v_ENDDATE", utcEndTime);
		map.put("v_TENANTID", tenantId);
		map.put("v_COMPANYID", companyID);

		ezScheduleDAO.updateDragSchedule(map);
		
	}

	@Override
	public void copySchedule(String dragId, String startDate, String endDate, String defaultPath, String offSetMin, int tenantId, String companyId) throws Exception {
		
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
				bodyContent.append("<br><br> &nbsp;&nbsp; <span id='attendanceChk' style=\"color:blue;cursor:pointer;text-decoration:underline;\" onclick='openAttendChk()'>" + egovMessageSource.getMessage("ezSchedule.mail.hth03") + "</span>");
				
				//bodyContent.append("<br><br>" + "<span id='schedule_read' style=\"color:blue;cursor:pointer;text-decoration:underline;\" onclick=\"javascript:window.open('/ezSchedule/scheduleIndex.do?funCode=2', '', 'width=1400px, height=900px, status = no, toolbar=no, menubar=no,location=no, resizable=1, scrollbars=0' )\">" + egovMessageSource.getMessage("ezEmail.t805", userInfo.getLocale()) + "</span></br>");
				break;
			case "del" :		// 참석자 삭제
				subject = egovMessageSource.getMessage("ezSchedule.kmss03", userInfo.getLocale());
				
				bodyContent.append(" " + userInfo.getDisplayName() + egovMessageSource.getMessage("ezSchedule.kmss04", userInfo.getLocale()) + "</br><br>" + " ");
				bodyContent.append(" &nbsp;&nbsp;- " + egovMessageSource.getMessage("ezCircular.t32", userInfo.getLocale()) + " : " + commonUtil.cleanValue(title) + "</br>");
				bodyContent.append(periodContent);
				bodyContent.append("<br><br> &nbsp;&nbsp; <span id='scheduleInfo' style=\"color:blue;cursor:pointer;text-decoration:underline;\" scheduleId='" + scheduleId + "' startDate='" + startDate + "' endDate='" + endDate + "' onclick='openScheduleInfo()'>" + egovMessageSource.getMessage("ezSchedule.mail.hth03") + "</span>");
				break;
			case "acc" :		// 참석 수락
				subject = egovMessageSource.getMessage("ezSchedule.kmss05", userInfo.getLocale());
				
				bodyContent.append(" " + userInfo.getDisplayName() + egovMessageSource.getMessage("ezSchedule.kmss06", userInfo.getLocale()) + "</br><br>" + " ");
				//bodyContent.append(" &nbsp;&nbsp;- " + egovMessageSource.getMessage("ezCircular.t32", userInfo.getLocale()) + " : " + "<span id='schedule_read' style=\"color:blue;cursor:pointer;text-decoration:underline;\" onclick=\"javascript:open_schedule('" + scheduleId + "')\">" + commonUtil.cleanValue(title) + "</span></br>");
				bodyContent.append(" &nbsp;&nbsp;- " + egovMessageSource.getMessage("ezCircular.t32", userInfo.getLocale()) + " : " + "<span id='schedule_read' >" + commonUtil.cleanValue(title) + "</span></br>");
				bodyContent.append(periodContent);
				bodyContent.append("<br><br> &nbsp;&nbsp; <span id='scheduleInfo' style=\"color:blue;cursor:pointer;text-decoration:underline;\" scheduleId='" + scheduleId + "' startDate='" + startDate + "' endDate='" + endDate + "' onclick='openScheduleInfo()'>" + egovMessageSource.getMessage("ezSchedule.mail.hth03") + "</span>");
				//bodyContent.append("<br><br>" + "<span id='schedule_read' style=\"color:blue;cursor:pointer;text-decoration:underline;\" onclick=\"javascript:window.open('/ezSchedule/scheduleIndex.do?funCode=2', '', 'width=1400px, height=900px, status = no, toolbar=no, menubar=no,location=no, resizable=1, scrollbars=0' )\">" + egovMessageSource.getMessage("ezEmail.t805", userInfo.getLocale()) + "</span></br>");
				break;
			case "rej" :		// 참석 거절
				subject = egovMessageSource.getMessage("ezSchedule.kmss07", userInfo.getLocale());
				
				bodyContent.append(" " + userInfo.getDisplayName() + egovMessageSource.getMessage("ezSchedule.kmss08", userInfo.getLocale()) + "</br><br>" + " ");
				//bodyContent.append(" &nbsp;&nbsp;- " + egovMessageSource.getMessage("ezCircular.t32", userInfo.getLocale()) + " : " + "<span id='schedule_read' style=\"color:blue;cursor:pointer;text-decoration:underline;\" onclick=\"javascript:open_schedule('" + scheduleId + "')\">" + commonUtil.cleanValue(title) + "</span></br>");
				bodyContent.append(" &nbsp;&nbsp;- " + egovMessageSource.getMessage("ezCircular.t32", userInfo.getLocale()) + " : " + "<span id='schedule_read' >" + commonUtil.cleanValue(title) + "</span></br>");
				bodyContent.append(periodContent);
				bodyContent.append("<br><br> &nbsp;&nbsp; <span id='scheduleInfo' style=\"color:blue;cursor:pointer;text-decoration:underline;\" scheduleId='" + scheduleId + "' startDate='" + startDate + "' endDate='" + endDate + "' onclick='openScheduleInfo()'>" + egovMessageSource.getMessage("ezSchedule.mail.hth03") + "</span>");
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
		
		logger.debug("getScheduleCompleteIsAllRep ended. isAllRep = " + result);
		return result;
	}
	
	/* 2021-11-26 홍승비 - 일정 리스트 데이터를 전달받아 일정완료 데이터를 추가 가공하여 리턴 */
	public List<ScheduleInfoVO> applyScheduleCompleteData(List<ScheduleInfoVO> sList, String offset, int tenantId, String companyID) throws Exception {
		logger.debug("applyScheduleCompleteData started. list size = " + sList.size());
		List<ScheduleInfoVO> result = sList;
		
		if (sList.size() > 0) {
			for (int i = 0; i < sList.size(); i++) {
				String isAllRep = "";
				ScheduleInfoVO tempVO  = sList.get(i);
				
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
		String notiRecipientIdList = "";
		String separator = ";;";
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
					notiRecipientIdList += v_attendantId + separator;
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
			bodyContent.append("<br><br> &nbsp;&nbsp; <span id='scheduleInfo' style=\"color:blue;cursor:pointer;text-decoration:underline;\" scheduleId='" + scheduleid + "' startDate='" + startdate + "' endDate='" + enddate + "' repeatcount='" + repeatCount + "' onclick='openScheduleInfo()'>" + egovMessageSource.getMessage("ezSchedule.mail.hth03") + "</span>");
		} else {
			bodyContent.append("<br><br> &nbsp;&nbsp; <span id='scheduleInfo' style=\"color:blue;cursor:pointer;text-decoration:underline;\" scheduleId='" + scheduleid + "' startDate='" + startdate + "' endDate='" + enddate + "' onclick='openScheduleInfo()'>" + egovMessageSource.getMessage("ezSchedule.mail.hth03") + "</span>");
		}
		
		String content_ = commonUtil.createNotiMailContent(bodyContent.toString(), loginVO.getTenantId(), loginVO.getLocale());
		ezEmailService.sendMail(loginCookie, from, toList.toArray(new InternetAddress[toList.size()]), null, null, subject, content_, false);
		
		notiRecipientIdList.substring(0, notiRecipientIdList.length() - separator.length());
		
		String linkUrl = "";
		String linkUrlMobile = "";
		if (Integer.parseInt(repeatCount) > 0) {
			linkUrl = "/ezSchedule/scheduleRead.do?id=" + scheduleid + "&repeatCount=" + repeatCount;
			linkUrlMobile = "/mobile/ezSchedule/mScheduleDetail.do?scheduleId=" + scheduleid + "&startDate=" + startdate + "&endDate=" + enddate + "&repeatCount=" + repeatCount + "&type=monthList" + "&purpose=scheduleInfoDetail" ;
	    } else {
	    	linkUrl = "/ezSchedule/scheduleRead.do?id=" + scheduleid + "&isReceive=Y";
	    	linkUrlMobile = "/mobile/ezSchedule/mScheduleDetail.do?scheduleId=" + scheduleid + "&startDate=" + startdate + "&endDate=" + enddate + "&type=monthList" + "&purpose=scheduleInfoDetail";
	    }
		
		
		ezNotificationService.sendNoti(request, beforeSche.getCreatorId(), creatorName, notiRecipientIdList, "SCHEDULE", "MOD", title, "popup", "760", "750", linkUrl, linkUrlMobile, "");
		logger.debug("sendInviteModNoti ended");
				
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
		String notiRecipientIdList = "";
		String separator = ";;";
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
					notiRecipientIdList += attendant.getAttendantId() + separator;
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
			bodyContent.append("<br><br> &nbsp;&nbsp; <span id='scheduleInfo' style=\"color:blue;cursor:pointer;text-decoration:underline;\" scheduleId='" + scheduleId + "' repeatCount= '" + repeatCount + "' startDate='" + selectedDate + "' endDate='" + selectedDate + "' onclick='openScheduleInfo()'>" + egovMessageSource.getMessage("ezSchedule.mail.hth03") + "</span>");
		} else {
			bodyContent.append(scheDateContent);
			bodyContent.append("<br><span>&nbsp;&nbsp; - ").append(egovMessageSource.getMessage("ezSchedule.t67", loginVO.getLocale()) + " : " + scheTimeContent);
		}
		
		String content_ = commonUtil.createNotiMailContent(bodyContent.toString(), loginVO.getTenantId(), loginVO.getLocale());
		ezEmailService.sendMail(loginCookie, from, toList.toArray(new InternetAddress[toList.size()]), null, null, subject, content_, false);
		
		notiRecipientIdList.substring(0, notiRecipientIdList.length() - separator.length());

		String linkUrl = "";
							
		String linkUrlMobile = "";
				
		ezNotificationService.sendNoti(request, scheduleInfo.getCreatorId(), creatorName, notiRecipientIdList, "SCHEDULE", "DELETE", title, "popup", "760", "750", linkUrl, linkUrlMobile, "");
		
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
		String notiRecipientIdList = creatorId;
		
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
			bodyContent.append("<br><br> &nbsp;&nbsp; <span id='scheduleInfo' style=\"color:blue;cursor:pointer;text-decoration:underline;\" scheduleId='" + scheduleId + "' startDate='" + startDate + "' endDate='" + endDate + "' onclick='openScheduleInfo()'>" + egovMessageSource.getMessage("ezSchedule.mail.hth03") + "</span>");
			notiSubType = "ACCEPT";
			break;
		case "rej" :		// 참석 거절
			subject = egovMessageSource.getMessage("ezSchedule.kmss07", locale);
			
			bodyContent.append(" " + userName + egovMessageSource.getMessage("ezSchedule.kmss08", locale) + "</br><br>" + " ");
			bodyContent.append(" &nbsp;&nbsp;- " + egovMessageSource.getMessage("ezCircular.t32", locale) + " : " + "<span id='schedule_read' >" + commonUtil.cleanValue(title) + "</span></br>");
			bodyContent.append(periodContent);
			bodyContent.append("<br><br> &nbsp;&nbsp; <span id='scheduleInfo' style=\"color:blue;cursor:pointer;text-decoration:underline;\" scheduleId='" + scheduleId + "' startDate='" + startDate + "' endDate='" + endDate + "' onclick='openScheduleInfo()'>" + egovMessageSource.getMessage("ezSchedule.mail.hth03") + "</span>");
			notiSubType = "REJECT";
			break;
		}
		
		if (!ezPersonalService.hasNotiDiableItem(creatorId, NotiType.fromString("SCHEDULE_" + notiSubType), NotiPlatform.MAIL, userInfo.getTenantId())) {
			ezEmailService.sendMail(userEmail, password, locale, from, toList.toArray(new InternetAddress[toList.size()]), null, null, subject, commonUtil.createNotiMailContent(bodyContent.toString(), tenantId, locale), false, EmailImportance.NORMAL);
		}
		
		String linkUrl = "/ezSchedule/scheduleRead.do?id=" + scheduleId + "&isReceive=Y";
			
		String linkUrlMobile = "/mobile/ezSchedule/mScheduleDetail.do?scheduleId=" + scheduleId + "&startDate=" + startDate + "&endDate=" + endDate + "&type=monthList" + "&purpose=scheduleInfoDetail";
			
		ezNotificationService.sendNoti(request, userInfo.getUserId(), creatorName, notiRecipientIdList, "schedule", notiSubType, title, "popup", "760", "750", linkUrl, linkUrlMobile, "");
		
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
		
		String notiRecipientIdList = "";
		String separator = ";;";
		for (AttendantListVO attendant : attendantList) {
			String attendanceStatus = attendant.getStatus();
			if (attendanceStatus != null && attendanceStatus.equals("1")) {
				if (!ezPersonalService.hasNotiDiableItem(attendant.getAttendantId(), NotiType.SCHEDULE_MOD, NotiPlatform.MAIL, tenantId)) {
					InternetAddress to;
					to = new InternetAddress();
					to.setAddress(ezOrganService.getPropertyValue(attendant.getAttendantId(), "mail", tenantId));
					to.setPersonal(userInfo.getPrimary().equals(userInfo.getLang()) ? attendant.getAttendantName() : attendant.getAttendantName2(), "UTF-8");
					toList.add(to);
					notiRecipientIdList += attendant.getAttendantId() + separator;
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
		
		bodyContent.append("<br><br> &nbsp;&nbsp; <span id='scheduleInfo' style=\"color:blue;cursor:pointer;text-decoration:underline;\" scheduleId='" + scheduleId + "' startDate='" + startdate + "' endDate='" + enddate + "' onclick='openScheduleInfo()'>" + egovMessageSource.getMessage("ezSchedule.mail.hth03") + "</span>");
		
		ezEmailService.sendMail(userEmail, password, locale, from, toList.toArray(new InternetAddress[toList.size()]), null, null, subject, commonUtil.createNotiMailContent(bodyContent.toString(), tenantId, locale), false, EmailImportance.NORMAL);
		
		notiRecipientIdList.substring(0, notiRecipientIdList.length() - separator.length());
		
		String linkUrl = "/ezSchedule/scheduleRead.do?id=" + scheduleId + "&isReceive=Y";
			
		String linkUrlMobile = "/mobile/ezSchedule/mScheduleDetail.do?scheduleId=" + scheduleId + "&startDate=" + startdate + "&endDate=" + enddate + "&type=monthList" + "&purpose=scheduleInfoDetail";
			
		ezNotificationService.sendNoti(request, beforeSche.getCreatorId(), ownerName, notiRecipientIdList, "SCHEDULE", "MOD", title, "popup", "760", "750", linkUrl, linkUrlMobile, "");
		
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
		
		String notiRecipientIdList = "";
		String separator = ";;";
		
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
					notiRecipientIdList += attendant.getAttendantId() + separator;
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
		
		notiRecipientIdList.substring(0, notiRecipientIdList.length() - separator.length());

		String linkUrl = "";
				
		String linkUrlMobile = "";
				
		ezNotificationService.sendNoti(request, scheduleInfo.getCreatorId(), creatorName, notiRecipientIdList, "SCHEDULE", "DELETE", title, "popup", "730", "370", linkUrl, linkUrlMobile, "");
		
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
			map.put("v_SEARCHTITLE", searchTitle);
		}
		map.put("v_COMPANYID", companyID);
		map.put("v_USERID", userID);
		map.put("v_DEPTID", deptID);
		map.put("v_ISPUBLIIC", ISPUBLIIC);
		map.put("useAnnualScheduleYN", useAnnualScheduleYN);

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

}

