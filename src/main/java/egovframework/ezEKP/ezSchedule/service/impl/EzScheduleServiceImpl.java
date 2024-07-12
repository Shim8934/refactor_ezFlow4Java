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
import java.util.Map;
import java.util.UUID;
import java.util.Base64;

import javax.annotation.Resource;
import javax.mail.internet.InternetAddress;

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
import egovframework.ezEKP.ezEmail.util.EzEmailUtil;
import egovframework.ezEKP.ezEmail.service.EzEmailService;
import egovframework.ezEKP.ezOrgan.service.EzOrganAdminService;
import egovframework.ezEKP.ezOrgan.vo.OrganUserVO;
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
	private CommonUtil commonUtil;
	
	@Autowired
	private EzAttitudeDAO ezAttitudeDAO;
	
	private static final Logger logger = LoggerFactory.getLogger(EzScheduleServiceImpl.class);

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
	public List<ScheduleInfoVO> getScheduleList(String indiList, String pidList, String filter, String utcStartDate, String utcEndDate, String orgStartDate, String orgEndDate, String keyword, String offSetMin, String searchTitle, int tenantId, String companyID, String userID, String deptID, String useAnnualScheduleYN) throws Exception {						

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_INDILIST", indiList);
		map.put("v_PIDLIST", pidList);		
		map.put("v_PFILTER", filter);
		map.put("v_PSTARTDATE", utcStartDate);
		map.put("v_PENDDATE", utcEndDate);
		map.put("v_PKEYWORD", keyword);
		map.put("v_OFFSETMIN", offSetMin);
		map.put("v_TENANTID", tenantId);
		/* 2021-10-20 홍승비 - 일정의 제목, 위치 검색조건 나눠지도록 수정 (v_SEARCHTITLE값이 존재하면 항상 제목 조건을 추가하게 됨) */
		if (filter != null && !filter.equalsIgnoreCase("location")) { // filter 조건 null 처리 추가 (검색조건 없이 모든 리스트 가져오는 경우 대응)
			map.put("v_SEARCHTITLE", searchTitle);
		}
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
		map.put("v_PKEYWORD", keyword);
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
	public void scheduleSendMail(int scheduleId, String v_attendantId, String v_attendantName, String title, String period, String type, LoginVO userInfo, String loginCookie) throws Exception {
		String subject = "";
		StringBuilder bodyContent = new StringBuilder("");
		
		switch(type) {
			case "add" :	// 참석자 추가
				subject = egovMessageSource.getMessage("ezSchedule.kmss01", userInfo.getLocale());
				
				bodyContent.append(" " + userInfo.getDisplayName() + egovMessageSource.getMessage("ezSchedule.kmss02", userInfo.getLocale()) +  "</br><br>" + " ");
				//bodyContent.append(" &nbsp;&nbsp;- " + egovMessageSource.getMessage("ezCircular.t32", userInfo.getLocale()) + " : " + "<span id='schedule_read' style=\"color:blue;cursor:pointer;text-decoration:underline;\" onclick=\"javascript:open_schedule('" + scheduleId + "')\">" + commonUtil.cleanValue(title) + "</span></br>");
				bodyContent.append(" &nbsp;&nbsp;- " + egovMessageSource.getMessage("ezCircular.t32", userInfo.getLocale()) + " : " + "<span id='schedule_read' >" + commonUtil.cleanValue(title) + "</span></br>");
				bodyContent.append(" &nbsp;&nbsp;- " + egovMessageSource.getMessage("ezSchedule.t318", userInfo.getLocale()) + " : " + period + " ");
				//bodyContent.append("<br><br>" + "<span id='schedule_read' style=\"color:blue;cursor:pointer;text-decoration:underline;\" onclick=\"javascript:window.open('/ezSchedule/scheduleIndex.do?funCode=2', '', 'width=1400px, height=900px, status = no, toolbar=no, menubar=no,location=no, resizable=1, scrollbars=0' )\">" + egovMessageSource.getMessage("ezEmail.t805", userInfo.getLocale()) + "</span></br>");
				break;
			case "del" :		// 참석자 삭제
				subject = egovMessageSource.getMessage("ezSchedule.kmss03", userInfo.getLocale());
				
				bodyContent.append(" " + userInfo.getDisplayName() + egovMessageSource.getMessage("ezSchedule.kmss04", userInfo.getLocale()) + "</br><br>" + " ");
				bodyContent.append(" &nbsp;&nbsp;- " + egovMessageSource.getMessage("ezCircular.t32", userInfo.getLocale()) + " : " + commonUtil.cleanValue(title) + "</br>");
				bodyContent.append(" &nbsp;&nbsp;- " + egovMessageSource.getMessage("ezSchedule.t318", userInfo.getLocale()) + " : " + period + " ");
				break;
			case "acc" :		// 참석 수락
				subject = egovMessageSource.getMessage("ezSchedule.kmss05", userInfo.getLocale());
				
				bodyContent.append(" " + userInfo.getDisplayName() + egovMessageSource.getMessage("ezSchedule.kmss06", userInfo.getLocale()) + "</br><br>" + " ");
				//bodyContent.append(" &nbsp;&nbsp;- " + egovMessageSource.getMessage("ezCircular.t32", userInfo.getLocale()) + " : " + "<span id='schedule_read' style=\"color:blue;cursor:pointer;text-decoration:underline;\" onclick=\"javascript:open_schedule('" + scheduleId + "')\">" + commonUtil.cleanValue(title) + "</span></br>");
				bodyContent.append(" &nbsp;&nbsp;- " + egovMessageSource.getMessage("ezCircular.t32", userInfo.getLocale()) + " : " + "<span id='schedule_read' >" + commonUtil.cleanValue(title) + "</span></br>");
				bodyContent.append(" &nbsp;&nbsp;- " + egovMessageSource.getMessage("ezSchedule.t318", userInfo.getLocale()) + " : " + period + " ");
				//bodyContent.append("<br><br>" + "<span id='schedule_read' style=\"color:blue;cursor:pointer;text-decoration:underline;\" onclick=\"javascript:window.open('/ezSchedule/scheduleIndex.do?funCode=2', '', 'width=1400px, height=900px, status = no, toolbar=no, menubar=no,location=no, resizable=1, scrollbars=0' )\">" + egovMessageSource.getMessage("ezEmail.t805", userInfo.getLocale()) + "</span></br>");
				break;
			case "rej" :		// 참석 거절
				subject = egovMessageSource.getMessage("ezSchedule.kmss07", userInfo.getLocale());
				
				bodyContent.append(" " + userInfo.getDisplayName() + egovMessageSource.getMessage("ezSchedule.kmss08", userInfo.getLocale()) + "</br><br>" + " ");
				//bodyContent.append(" &nbsp;&nbsp;- " + egovMessageSource.getMessage("ezCircular.t32", userInfo.getLocale()) + " : " + "<span id='schedule_read' style=\"color:blue;cursor:pointer;text-decoration:underline;\" onclick=\"javascript:open_schedule('" + scheduleId + "')\">" + commonUtil.cleanValue(title) + "</span></br>");
				bodyContent.append(" &nbsp;&nbsp;- " + egovMessageSource.getMessage("ezCircular.t32", userInfo.getLocale()) + " : " + "<span id='schedule_read' >" + commonUtil.cleanValue(title) + "</span></br>");
				bodyContent.append(" &nbsp;&nbsp;- " + egovMessageSource.getMessage("ezSchedule.t318", userInfo.getLocale()) + " : " + period + " ");
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
		map.put("v_PKEYWORD", keyword);
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

