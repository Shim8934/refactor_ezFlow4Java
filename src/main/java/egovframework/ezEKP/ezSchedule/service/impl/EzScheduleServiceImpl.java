package egovframework.ezEKP.ezSchedule.service.impl;

import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.annotation.Resource;

import org.apache.commons.beanutils.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.w3c.dom.NodeList;

import com.sun.org.apache.xml.internal.security.utils.Base64;

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
import egovframework.ezEKP.ezSchedule.vo.ScheduleInfoVO;
import egovframework.ezEKP.ezSchedule.vo.ScheduleReceiveListVO;
import egovframework.ezEKP.ezSchedule.vo.ScheduleSecretaryVO;
import egovframework.let.utl.fcc.service.CommonUtil;

@Service("EzScheduleService")
public class EzScheduleServiceImpl implements EzScheduleService{
	
	@Resource(name="EzScheduleDAO")
	private EzScheduleDAO ezScheduleDAO;
	
	@Resource(name="EzResourceService")
	private EzResourceService ezResourceService;
	
	@Autowired
	private CommonUtil commonUtil;

	@Override
	public List<ScheGetHolidayVO> getTholiday(String companyId, String userCompany, int tenantId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_COMPANYID", companyId);
		map.put("v_USERCOMPANY", userCompany);
		map.put("v_TENANTID", tenantId);
		
		return ezScheduleDAO.getTholiday(map);
	}

	@Override
	public ScheduleConfigVO getScheduleConfig(String userId, int tenantId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_USERID", userId);
		map.put("v_TENANTID", tenantId);
		
		return ezScheduleDAO.getScheduleConfig(map);
	}

	@Override
	public ScheduleInfoVO getScheduleInfo(String scheduleId, String offSetMin, int tenantId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_SCHEDULEID", scheduleId);
		map.put("v_OFFSETMIN", offSetMin);
		map.put("v_TENANTID", tenantId);
		
		return ezScheduleDAO.getScheduleInfo(map);
	}

	@Override
	public List<AttendantListVO> getAttendantList(String scheduleId, String offSetMin, int tenantId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_SCHEDULEID", scheduleId);
		map.put("v_OFFSETMIN", offSetMin);
		map.put("v_TENANTID", tenantId);
		
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
	public List<ScheduleSecretaryVO> getPublicScheduleSec(String userId, String lang, int tenantId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_CN", userId);
		map.put("v_LANG", lang);
		map.put("v_TENANTID", tenantId);
		
		return ezScheduleDAO.getPublicScheduleSec(map);
	}

	@Override
	public List<ScheduleDeptVO> getPublicScheduleDept(String userId, String lang, int tenantId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_CN", userId);
		map.put("v_LANG", lang);
		map.put("v_TENANTID", tenantId);
		
		return ezScheduleDAO.getPublicScheduleDept(map);
	}

	@Override
	public List<ScheduleCumulerVO> getPublicScheduleCumuler(String userId, String lang, int tenantId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_CN", userId);
		map.put("v_LANG", lang);
		map.put("v_TENANTID", tenantId);
		
		return ezScheduleDAO.getPublicScheduleCumuler(map);
	}

	@Override
	public int getReceiveCount(String pUserId, int tenantId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();		
		map.put("v_USERID", pUserId);
		map.put("v_TENANTID", tenantId);
		
		return ezScheduleDAO.getReceiveCount(map);
	}

	@Override
	public int getInviteScheduleGroupCnt(String pUserId, int tenantId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_USERID", pUserId);
		map.put("v_TENANTID", tenantId);
		
		return ezScheduleDAO.getInviteScheduleGroupCnt(map);
	}

	@Override
	public List<ScheduleInfoVO> getScheduleList(String pidList, String filter, String utcStartDate, String utcEndDate, String orgStartDate, String orgEndDate, String keyword, String offSetMin, int tenantId) throws Exception {						
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PIDLIST", pidList);		
		map.put("v_PFILTER", filter);
		map.put("v_PSTARTDATE", utcStartDate);
		map.put("v_PENDDATE", utcEndDate);
		map.put("v_PKEYWORD", keyword);
		map.put("v_OFFSETMIN", offSetMin);
		map.put("v_TENANTID", tenantId);
		
		List<ScheduleInfoVO> sList = ezScheduleDAO.getScheduleList(map);
		List<ScheduleInfoVO> resultList = new ArrayList<ScheduleInfoVO>();
		
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
												
				Calendar sDate_cal = Calendar.getInstance();
				Calendar eDate_cal = Calendar.getInstance();
				Calendar date_cal = Calendar.getInstance();
				
				SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
				SimpleDateFormat nsdf = new SimpleDateFormat("yyyy-MM-dd");
				
				sDate_cal.setTime(sdf.parse(orgStartDate));
				eDate_cal.setTime(sdf.parse(endDate));
				date_cal.setTime(sdf.parse(vo.getStartDate()));
				
				switch (info[2]) {
					case "0" :
						while (true) {
							if (date_cal.compareTo(eDate_cal) > 0) break;
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
						int weekcount = 6 - date_cal.get(Calendar.DAY_OF_WEEK) - 1;
						
						while (true) {
							if (date_cal.compareTo(eDate_cal) > 0) break;
							if (maxCount == count) break;
							
							boolean generated = false;

							if (info[4].indexOf((date_cal.get(Calendar.DAY_OF_WEEK) - 1) + "") > -1) {
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
							
							if (weekcount == 0) {
								date_cal.add(Calendar.DATE, (Integer.parseInt(info[3]) - 1) * 7 + 1);
								weekcount = 6;
							} else {
								date_cal.add(Calendar.DATE, 1);
								weekcount--;
							}
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
								
								if (calcuDate.compareTo(orgStartDate.substring(0,10)) >= 0 && calcuDate.compareTo(orgEndDate.substring(0,10)) <= 0) {
									//row 추가
									if (!rList.contains(calcuDate)) {
										ScheduleInfoVO rVo = addRepeatRow(vo, newCal.getTime(), count, info[1]);
										resultList.add(rVo);
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
									
							if (year > eDate_cal.get(Calendar.YEAR)) break;
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
								
								if (calcuDate.compareTo(orgStartDate.substring(0,10)) >= 0 && calcuDate.compareTo(orgEndDate.substring(0,10)) <= 0) {
									//row 추가
									if (!rList.contains(calcuDate)) {
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
			}
			//반복일정 구현 끝
			else {
				resultList.add(vo);
			}
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
		
		return innerVO; 
	}
	
	@Override
	public List<ScheduleGroupListVO> getScheduleGroupList(String userID, int tenantId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_USERID", userID);
		map.put("v_TENANTID", tenantId);
		
		List<ScheduleGroupListVO> gList = ezScheduleDAO.getScheduleGroupList(map);
		
		return gList;
	}

	@Override
	public List<ScheduleGroupListVO> getMyGroupList(String userID, int tenantID) throws Exception {	
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_USERID", userID);
		map.put("v_TENANTID", tenantID);
		
		List<ScheduleGroupListVO> gList = ezScheduleDAO.getMyGroupList(map);
		
		return gList;
	}
	
	@Override
	public int getMyGroupMemberListCnt(String groupId, String lang, int tenantId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_GROUPID", groupId);
		map.put("v_LANG", lang);
		map.put("v_TENANTID", tenantId);
		
		int cnt = ezScheduleDAO.getMyGroupMemberListCnt(map);
		
		return cnt;
	}

	@Override
	public String getMyGroupMemberList(String groupId, String lang, int tenantId) throws Exception {
		StringBuilder sb = new StringBuilder("<DATA>");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_GROUPID", groupId);
		map.put("v_LANG", lang);
		map.put("v_TENANTID", tenantId);
		
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
	public List<ScheduleGroupListVO> getGroupMemberList(String groupID,	int tenantId, String offSetMin) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_GROUPID", groupID);		
		map.put("v_TENANTID", tenantId);
		map.put("v_OFFSETMIN", offSetMin);
		
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
	public void updateScheduleMember(String groupId, String memberId, String status, int tenantId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_GROUPID", groupId);
		map.put("v_MEMBERID", memberId);
		map.put("v_STATUS", status);
		map.put("v_TENANTID", tenantId);
		
		ezScheduleDAO.updateScheduleMember(map);
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
	public String getDeptMemberList(String deptId, String subDept, String lang, int tenantId) throws Exception {
		StringBuilder sb = new StringBuilder("<DATA>");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_DEPTID", deptId);
		map.put("v_SUBDEPT", subDept);
		map.put("v_LANG", lang);		
		map.put("v_TENANTID", tenantId);
		
		List<OrganUserVO> gList = ezScheduleDAO.getDeptMemberList(map);
		
		for(int i = 0; i < gList.size(); i++){			
			OrganUserVO data = gList.get(i);
			
			sb.append(commonUtil.getQueryResult(data));
		}
		sb.append("</DATA>");
		
		return sb.toString();		
	}

	@Override
	public void insertScheduleGroup(String gUID, String id, String displayName,	String displayName2, String groupName, String description, int tenantId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_GUID", gUID);
		map.put("v_USERID", id);
		map.put("v_DISPLAYNAME", displayName);
		map.put("v_DISPLAYNAME2", displayName2);
		map.put("v_GROUPNAME", groupName);
		map.put("v_DESCRIPTION", description);
		map.put("v_TENANTID", tenantId);
		
		ezScheduleDAO.insertScheduleGroup(map);
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
	public List<ScheduleSecretaryVO> getSecretaryList(String userId, int tenantId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_USERID", userId);		
		map.put("v_TENANTID", tenantId);
		
		List<ScheduleSecretaryVO> sList = ezScheduleDAO.getSecretaryList(map);
		
		return sList;
	}

	@Override
	public void deleteScheduleConfig(String userID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_USERID", userID);		
		map.put("v_TENANTID", tenantID);
		
		ezScheduleDAO.deleteScheduleConfig(map);
	}

	@Override
	public void deleteSecretary(String userID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_USERID", userID);		
		map.put("v_TENANTID", tenantID);
		
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
		
		ezScheduleDAO.insertScheduleConfig(map);
	}

	@Override
	public void insertSecretary(String userID, String displayName, String displayName2, String secretaryID, String secretaryName, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_USERID", userID);
		map.put("v_DISPLAYNAME", displayName);
		map.put("v_DISPLAYNAME2", displayName2);
		map.put("v_SECRETARYID", secretaryID);
		map.put("v_SECRETARYNAME", secretaryName);		
		map.put("v_TENANTID", tenantID);
		
		ezScheduleDAO.insertSecretary(map);
	}

	@Override
	public int insertSchedule(String ownerid, String ownername, String ownername2, String creatorid, String creatorname, String creatorname2, String scheduletype, String importance,
		String ispublic, String datetype, String startdate, String enddate,	String repetition, String title, String location, String content, NodeList attach, NodeList attendantId, 
		NodeList attendantName, NodeList attendantName2, NodeList attendantDeptName, NodeList attendantDeptName2, String defaultPath, int tenantId) throws Exception {
		
		//본문내용 MHT 저장
		String mhtPath = commonUtil.separator + "doc";
		String uploadFilePath = commonUtil.separator + "uploadFile";
		String contentPath = defaultPath + mhtPath;
		File file = new File(contentPath);

		if (!file.exists()) {			
			file.mkdirs();
		}
		
		InputStream stream = null;
		OutputStream bos = null;		
		int sID = 0;
		
		try {
			String schedulePath = commonUtil.separator + "{" + UUID.randomUUID().toString() + "}" + ".mht";
			contentPath += schedulePath;

			byte[] ct = Base64.decode(content);
			stream = new ByteArrayInputStream(ct);
			bos = new FileOutputStream(contentPath);
	
			int bytesRead = 0;
			byte[] buffer = new byte[2048];
			
			while ((bytesRead = stream.read(buffer, 0, 2048)) != -1) {
				bos.write(buffer, 0, bytesRead);
			}

			//첨부파일 카운트
			String hasattach = "N";
			
			if(attach.getLength() > 0) {				
				hasattach = "Y";
			}
			//비서정보 카운트
			String hasattendant = "N";
			
			if(attendantId.getLength() > 0) {				
				hasattendant = "Y";
			}			
			//일정 정보 저장
			schedulePath = mhtPath + schedulePath;
			
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
			
			ezScheduleDAO.insertSchedule(map);
			
			int scheduleId = ezScheduleDAO.getCurScheduleId(null);
			
			//첨부파일 저장
			Map<String, Object> attachMap = new HashMap<String, Object>();
						
			for (int i=0; i < attach.getLength(); i++) {
				String[] files = attach.item(i).getTextContent().split("/");				
				String fileName = files[1];
				String filePath = files[0];
				String fileSize = files[2];
				
				filePath = uploadFilePath + commonUtil.separator + filePath;

				attachMap.put("v_SCHEDULEID", scheduleId);
				attachMap.put("v_FILENAME", fileName);
				attachMap.put("v_FILEPATH", filePath);
				attachMap.put("v_FILESIZE", fileSize);
				attachMap.put("v_TENANTID", tenantId);
				
				ezScheduleDAO.insertScheduleAttach(attachMap);
			}					
			
			//참석자 관련 데이터 저장 로직			
			for (int i=0; i < attendantId.getLength(); i++) {								
				String v_attendantId = attendantId.item(i).getTextContent();				
				String v_attendantName = attendantName.item(i).getTextContent();
				String v_attendantName2 = attendantName2.item(i).getTextContent();
				String v_attendantDeptName = attendantDeptName.item(i).getTextContent();
				String v_attendantDeptName2 = attendantDeptName2.item(i).getTextContent();
				
				insertScheduleAttendant(Integer.toString(scheduleId), v_attendantId, v_attendantName, v_attendantName2, v_attendantDeptName, v_attendantDeptName2, tenantId);
			}
			
			sID = scheduleId;			
		} catch (Exception e) {
			
		} finally {
			if (stream != null) stream.close();				
			if (bos != null) bos.close();
		}
		return sID;
	}
	
	
	@Override
	public int updateSchedule(String scheduleid, String creatorid, String creatorname, String creatorname2, String importance, String ispublic, String datetype, String startdate, String enddate,
		String repetition, String title, String location, String content, NodeList attach, String defaultPath, int tenantId) throws Exception {
		
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

		ezScheduleDAO.updateSchedule(map);
		
		//mht 내용 변경
		InputStream stream = null;
		OutputStream bos = null;		
		
		try {
			byte[] ct = Base64.decode(content);
			stream = new ByteArrayInputStream(ct);
			bos = new FileOutputStream(defaultPath);
			
			int bytesRead = 0;
			byte[] buffer = new byte[2048];
			
			while ((bytesRead = stream.read(buffer, 0, 2048)) != -1) {
				bos.write(buffer, 0, bytesRead);
			}
		} catch (Exception e) {
			
		} finally {
			if (stream != null) stream.close();				
			if (bos != null) bos.close();
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
			
			filePath = uploadFilePath + commonUtil.separator + filePath;

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
				
		ezScheduleDAO.deleteScheduleAttach(map);
		ezScheduleDAO.deleteAttendant(map);
		ezScheduleDAO.deleteSchedule(map);
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
	public void insertScheduleAttendant(String scheduleId, String attendantId, String attendantName, String attendantName2, String attendantDeptName, String attendantDeptName2, int tenantId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_SCHEDULEID", scheduleId);
		map.put("v_ATTENDANTID", attendantId);
		map.put("v_ATTENDANTNAME", attendantName);		
		map.put("v_ATTENDANTNAME2", attendantName2);
		map.put("v_ATTENDANTDEPTNAME", attendantDeptName);
		map.put("v_ATTENDANTDEPTNAME2", attendantDeptName2);
		map.put("v_TENANTID", tenantId);
		
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
	public List<ScheduleReceiveListVO> getReceiveList(String id, int tenantId, String offSetMin) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_USERID", id);
		map.put("v_TENANTID", tenantId);
		map.put("v_OFFSETMIN", offSetMin);		
		
		List<ScheduleReceiveListVO> sList = ezScheduleDAO.getReceiveList(map);
		
		return sList;
	}

	@Override
	public void updateAttendant(String scheduleId, String attendantId, String displayName, String displayName2, String status, int tenantId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
				
		map.put("v_SCHEDULEID", scheduleId);
		map.put("v_ATTENDANTID", attendantId);
		map.put("v_ATTENDANTNAME", displayName);		
		map.put("v_ATTENDANTNAME2", displayName2);
		map.put("v_STATUS", status);
		map.put("v_TENANTID", tenantId);
		
		ezScheduleDAO.updateAttendantStatus(map);
		
		if (status.equals("1")) {
			ezScheduleDAO.insertAttendantSchedule(map);
		}
	}

	@Override
	public List<ScheduleGroupListVO> getInviteScheduleGroupList(String id, int tenantId, String offSetMin) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_USERID", id);
		map.put("v_TENANTID", tenantId);
		map.put("v_OFFSETMIN", offSetMin);
		
		List<ScheduleGroupListVO> iList = ezScheduleDAO.getInviteScheduleGroupList(map);
		
		return iList;
	}

	@Override
	public void insertScheduleRepeDel(String scheduleId, String startDate, int tenantId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_SCHEDULEID", scheduleId);
		map.put("v_STARTDATE", startDate);
		map.put("v_TENANTID", tenantId);		
		
		ezScheduleDAO.insertScheduleRepeDel(map);
	}

	@Override
	public void deleteScheduleRepe(String scheduleId, int tenantId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_SCHEDULEID", scheduleId);		
		map.put("v_TENANTID", tenantId);		
		
		ezScheduleDAO.deleteScheduleRepe(map);
	}
	
	
	
	
}

