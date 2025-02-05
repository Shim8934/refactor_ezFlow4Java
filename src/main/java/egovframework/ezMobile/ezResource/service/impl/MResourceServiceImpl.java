package egovframework.ezMobile.ezResource.service.impl;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import egovframework.ezEKP.ezOrgan.service.EzOrganAdminService;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.ezEKP.ezOrgan.vo.OrganUserVO;
import egovframework.ezMobile.ezOption.vo.MCommonVO;
import egovframework.ezMobile.ezResource.dao.MResourceDAO;
import egovframework.ezMobile.ezResource.service.MResourceService;
import egovframework.ezMobile.ezResource.vo.MResourceGetAdmSubClsTreeVO;
import egovframework.ezMobile.ezResource.vo.MResourceScheduleVO;
import egovframework.ezMobile.ezResource.vo.ResGetScheduleRepetitionVO;
import egovframework.ezMobile.ezResource.vo.ResGetScheduleVO;
import egovframework.ezMobile.ezResource.vo.ResScheGetHolidayVO;
import egovframework.ezMobile.ezResource.vo.ResScheduleRepetitionVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service("MResourceService")
public class MResourceServiceImpl extends EgovAbstractServiceImpl implements MResourceService{
	
	private static final Logger logger = LoggerFactory.getLogger(MResourceServiceImpl.class);
	
	@Resource(name="MResourceDAO")
	private MResourceDAO mResourceDAO;
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private EzOrganService ezOrganService;
	
	@Autowired
	private EzOrganAdminService ezOrganAdminService;

	@Override
	public List<MResourceGetAdmSubClsTreeVO> getAdmSubClsTree(String parentID, String companyID, String treeType, int tenantID) {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_P_ParentID", parentID);
		map.put("v_P_CompanyID", companyID);
		map.put("v_P_TreeType", treeType);
		map.put("tenantID", tenantID);
		return mResourceDAO.getAdmSubClsTree(map);
	}



	@Override
	public List<MResourceScheduleVO> getResScheduleMainList(
			String utcStartDate, String utcEndDate, String companyId,
			int page, String firstWriteDay, String lastWriteDay, int tenantId) {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_PSTARTDATE", utcStartDate);
		map.put("v_PENDDATE", utcEndDate);
		map.put("v_PCOMPANYID", companyId);
		map.put("v_PPAGE", page);
		map.put("v_PFIRSTWRITEDAY", firstWriteDay);
		map.put("v_PLASTWRITEDAY", lastWriteDay);
		map.put("tenantID", tenantId);
		List<MResourceScheduleVO> list = mResourceDAO.getResScheduleMainList(map);
		return list;
	}

	@Override
	public List<MResourceScheduleVO> getResScheduleList(String startDate,
			String endDate, String companyId, String ownerId, int tenantId) {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_PSTARTDATE", startDate);
		map.put("v_PENDDATE", endDate);
		map.put("v_PCOMPANYID", companyId);
		map.put("v_POWNERID", ownerId);
		map.put("tenantID", tenantId);
		List<MResourceScheduleVO> list = mResourceDAO.getResScheduleList(map);
		logger.debug("size of list: " + list.size());
		return list;
	}

	@Override
	public MResourceScheduleVO getResScheduleDetail(String resourceId, String ScheduleId,
			String companyId, int tenantId, String langStr) {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_POWNERID", resourceId);
		map.put("v_PNUM", ScheduleId);
		map.put("v_PCOMPANYID", companyId);
		map.put("tenantID", tenantId);
		
		MResourceScheduleVO resultVO = mResourceDAO.getResScheduleDetail(map);
		
		if(Integer.parseInt(langStr) != 1){
			resultVO.setBrdNm(resultVO.getBrdNm2());
		}
		
		return resultVO;
	}

	@Override
	public List<MResourceGetAdmSubClsTreeVO> getResBrdList(String brdId,
			String brdCompany, String userId, String userCompany, String userDept, int tenantId, String langStr, String authYn) throws Exception {	
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_PBRDID", brdId);
		map.put("v_PBRDCOMPANY", brdCompany);
		map.put("v_PUSERID", userId);
		map.put("v_PUSERCOMPANY", userCompany);
		map.put("v_PUSERDEPT", userDept);
		map.put("v_PAUTHYN", authYn);
		map.put("tenantID", tenantId);
		
		List<MResourceGetAdmSubClsTreeVO> result = mResourceDAO.getResBrdList(map);
		
		if(Integer.parseInt(langStr) != 1){
			for (MResourceGetAdmSubClsTreeVO resultVO : result) {
					resultVO.setBrdNm(resultVO.getBrdNm2());
			}
		}
		
        //자원명으로 정렬
/*        Collections.sort(result, new Comparator<MResourceGetAdmSubClsTreeVO>() {
			@Override
			public int compare(MResourceGetAdmSubClsTreeVO o1, MResourceGetAdmSubClsTreeVO o2) {
				return o1.getBrdNm().compareTo(o2.getBrdNm());
			}
		});*/
		
		return result;
	}

	@Override
	public List<MResourceScheduleVO> getResFavoriteList(String userId,
			String companyId,int tenantId, String langStr) {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_PUSERID", userId);
		map.put("tenantID", tenantId);
		map.put("v_PCOMPANYID", companyId);
		
		List<MResourceScheduleVO> result = mResourceDAO.getResFavoriteList(map);

		if(Integer.parseInt(langStr) != 1){
			for (MResourceScheduleVO resultVO : result) {
					resultVO.setBrdNm(resultVO.getBrdNm2());
			}
		}
		
        //자원명으로 정렬
        Collections.sort(result, new Comparator<MResourceScheduleVO>() {
			@Override
			public int compare(MResourceScheduleVO o1, MResourceScheduleVO o2) {
				return o1.getBrdNm().compareTo(o2.getBrdNm());
			}
		});
		
		return result;
	}

	@Override
	public Integer addResSch(String ownerId, String companyId, int tenantId,
			String pNum, String writerId, String deptNm, String ownerNm,
			String title, String location, String timeDisplay,
			String startDate, String endDate, String allDay, String alterTime,
			String content, String importance, String writeDay,
			String entryList, String attachFlag, String approveFlag, String reFlag,
			String scheduleId) {

		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_POWNERID", ownerId);
		map.put("v_PCOMPANYID", companyId);
		map.put("tenantID", tenantId);
		map.put("v_PPNUM", 0);
		map.put("v_PWRITERID", writerId);
		map.put("v_PDEPTNM", deptNm);
		map.put("v_POWNERNM", ownerNm);
		map.put("v_PTITLE", title);
		map.put("v_PLOCATION", location);
		map.put("v_PTIMEDISPLAY", timeDisplay);
		map.put("v_PSTARTDATE", startDate);
		map.put("v_PENDDATE", endDate);
		map.put("v_PALLDAY", allDay);
		map.put("v_PALTERTIME", alterTime);
		map.put("v_PCONTENT", content);
		map.put("v_PIMPORTANCE", importance);
		map.put("v_PWRITEDAY", writeDay);
		map.put("v_PENTRYLIST", entryList);
		map.put("v_PATTACHFLAG", attachFlag);
		map.put("v_PAPPROVEFLAG", approveFlag);
		map.put("v_PSCHEDULEID", scheduleId);
		map.put("v_PREFLAG", reFlag);
		map.put("v_PGRESFLAG", "");
		map.put("v_PCHARACTERID", 0);

		logger.debug("map: " + map);
		return mResourceDAO.addResSch(map);
	}

	@Override
	public void modifyResSch(String title, String startDate, String endDate, 
			String alterTime, String content,String importance, String reFlag, String allDay, String approveFlag,
			String companyId, String num, String ownerId, int tenantId) {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_POWNERID", ownerId);
		map.put("v_PCOMPANYID", companyId);
		map.put("tenantID", tenantId);
		map.put("v_PTITLE", title);
		map.put("v_PSTARTDATE", startDate);
		map.put("v_PENDDATE", endDate);
		map.put("v_PALTERTIME", alterTime);
		map.put("v_PCONTENT", content);
		map.put("v_PIMPORTANCE", importance);
		map.put("v_PREFLAG", reFlag);
		map.put("v_PALLDAY", allDay);
		map.put("v_PAPPROVEFLAG", approveFlag);
		map.put("v_PNUM", num);
		
		logger.debug("map in modifyResSch: " + map);
		
		mResourceDAO.modifyResSch(map);
	}

	@Override
	public void delResSch(String companyId, String ownerId, String num, String startDate, String endDate, String offset, String reFlag, int tenantId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_PCOMPANYID", companyId);
		map.put("v_POWNERID", ownerId);
		map.put("v_PNUM", num);
		map.put("tenantID", tenantId);
		
		String nowDate = commonUtil.getTodayUTCTime("yyyy-MM-dd HH:mm:ss");
		map.put("v_PNOWDATE", nowDate);
		
		if(reFlag.equals("1")){
			
			//모바일 반복일정 삭제 -> 단일삭제에서 전체삭제로 변경2018.02.22
/*			int maxNum = mResourceDAO.getResSchMaxNum(map);
			map.put("v_PMAXNUM", maxNum);
			startDate = commonUtil.getDateStringInUTC(startDate, offset, true);
			endDate = commonUtil.getDateStringInUTC(endDate, offset, true);			
			logger.debug("startDate in repeat :", startDate);
			logger.debug("endDate in repeat :", endDate);
			map.put("v_PSTARTDATE", startDate);
			map.put("v_PENDDATE", endDate);
			mResourceDAO.delResSch_I(map);*/
			
			mResourceDAO.delResSch(map);
			mResourceDAO.delResSchRepet(map);
		} else {
			mResourceDAO.delResSch(map);
		}
		
		
	}

	@Override
	public void addResFavor(String resId, String companyId, String userId, int tenantId) {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_PRESID", resId);
		map.put("v_PCOMPANYID", companyId);
		map.put("v_PUSERID", userId);
		map.put("tenantID", tenantId);
		mResourceDAO.addResFavor(map);
	}

	@Override
	public void delResFavor(String resId, String userId, int tenantId) {
		Map<String,Object> map = new HashMap<String, Object>();
		
		logger.debug("resId: " + resId);
		logger.debug("userId: " + userId);
		logger.debug("tenantId: " + tenantId);
		
		map.put("v_PRESID", resId);
		map.put("v_PUSERID", userId);
		map.put("tenantID", tenantId);
		mResourceDAO.delResFavor(map);
	}
	
	@Override
	public Map<String, Object> getScheduleList(String ownerID, String companyID, String sDate, String eDate, String pWriterDept, int tenantID, String offset, String listCnt, String check, String checkNum, String checkSDate, String checkEDate, String langStr) throws Exception {
		logger.debug("getScheduleList Start");
	
		Map<String, Object> result = new HashMap<>();
		String startDateLimit = eDate + " 23:59:59";
		String endDateLimit = sDate + " 00:00:01";

		startDateLimit = commonUtil.getDateStringInUTC(startDateLimit, offset, true);
		endDateLimit = commonUtil.getDateStringInUTC(endDateLimit, offset, true);
		
		logger.debug("startDateLimit : " + startDateLimit);
		logger.debug("endDateLimit : " + endDateLimit);
		
		
		// 스케줄 정보 가져옴(tbl_schedule에서 반복예약이 아닌 것만 가져옴)
		List<ResGetScheduleVO> getScheduleList = getScheduleNormalList(ownerID, companyID, startDateLimit, endDateLimit, pWriterDept, offset, tenantID);
		
		//logger.debug("getScheduleList : " + getScheduleList);
		
		for (ResGetScheduleVO resVO : getScheduleList) {
			resVO.setStartDate(commonUtil.getDateStringInUTC(resVO.getStartDate(), offset, false));
			resVO.setEndDate(commonUtil.getDateStringInUTC(resVO.getEndDate(), offset, false));
			resVO.setDate(resVO.getStartDate().substring(0,10));
			
			if(Integer.parseInt(langStr) != 1){
				resVO.setBrdNm(resVO.getBrdNm2());
			}
		}
		
		List<ResGetScheduleVO> getRepeatResult= new ArrayList<ResGetScheduleVO>();
			
		// 스케줄 정보 가져옴(tbl_schedule에서 반복예약인 것만 가져옴)
		List<ResGetScheduleVO> getScheduleListRept = getScheduleListRepetiti(ownerID, companyID, startDateLimit, endDateLimit, pWriterDept, offset, tenantID);
		
		//logger.debug("getScheduleListRept: " + getScheduleListRept);
		
		getRepeatResult.addAll(getScheduleListRept);
		
		// return할 ResGetScheduleVO getScheduleList 에 추가(반복예약)
		if (getRepeatResult.size() > 0 ) {
			
			SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			for (int i=0; i<getRepeatResult.size(); i++) {
				String reCompanyID = getRepeatResult.get(i).getCompanyId();
				String reNum = Integer.toString(getRepeatResult.get(i).getNum());
				String reOwnerID = getRepeatResult.get(i).getOwnerId();
				
				// tbl_schedulerepetition에서 정보 가져옴
				ResGetScheduleRepetitionVO vo = getRepDateTimes(reOwnerID, reCompanyID, Integer.parseInt(reNum), tenantID);
				
				if (vo != null) {
					
					vo.setStartDateTime(commonUtil.getDateStringInUTC(vo.getStartDateTime(), offset, false));
					vo.setEndDateTime(commonUtil.getDateStringInUTC(vo.getEndDateTime(), offset, false));
					
					// ResGetScheduleRepetitionVO -> ResScheduleRepetitionVO
					ResScheduleRepetitionVO rvo = resStruct(vo);
					//logger.debug("ResScheduleRepetitionVO: " + rvo);
					
					// 반복예약의 반복되는 날짜리스트 뽑아옴
					List<Date[]> returnRepDateTimes = getRepDateTimes(rvo, sDate, eDate, offset);
					
					// 반복예약 중에 삭제된 예약 가져옴
					List<String> deletedDateStrList = getDeletedRepScheduleDate(Integer.parseInt(reNum), reCompanyID, reOwnerID, tenantID);
					logger.debug("deletedDateStrList.size=" + deletedDateStrList.size());
					
					for (int j=0; j<deletedDateStrList.size(); j++) {
						deletedDateStrList.set(j, commonUtil.getDateStringInUTC(deletedDateStrList.get(j), offset, false));
					}
					
					for (Date[] dateArr : returnRepDateTimes) {
						// 삭제된 예약이면 넘어감
						if (deletedDateStrList.contains(format.format(dateArr[0]))) {
							continue;
						}
						
						ResGetScheduleVO temp = new ResGetScheduleVO();
						
						temp.setNum(getRepeatResult.get(i).getNum());
						temp.setpNum(getRepeatResult.get(i).getNum());
						temp.setOwnerId(getRepeatResult.get(i).getOwnerId());
						temp.setTitle(getRepeatResult.get(i).getTitle());
						temp.setLocation(getRepeatResult.get(i).getLocation());
						temp.setTimeDisplay(getRepeatResult.get(i).getTimeDisplay());
						temp.setStartDate(format.format(dateArr[0]));
						temp.setEndDate(format.format(dateArr[1]));
						temp.setAlertTime(getRepeatResult.get(i).getAlertTime());
						temp.setReFlag(getRepeatResult.get(i).getReFlag());
						temp.setGresFlag(getRepeatResult.get(i).getGresFlag());
						temp.setWriterId(getRepeatResult.get(i).getWriterId());
						temp.setImportance(getRepeatResult.get(i).getImportance());
						temp.setEntryList(getRepeatResult.get(i).getEntryList());
						temp.setAllDay(getRepeatResult.get(i).getAllDay());
						temp.setWriteDay(getRepeatResult.get(i).getWriteDay());
						temp.setAttachFlag(getRepeatResult.get(i).getAttachFlag());
						temp.setCharacterId(getRepeatResult.get(i).getCharacterId());
						temp.setApproveFlag(getRepeatResult.get(i).getApproveFlag());
						temp.setResApproveFlag(getRepeatResult.get(i).getResApproveFlag());
						temp.setOwnerNm(getRepeatResult.get(i).getOwnerNm());
						temp.setDeptNm(getRepeatResult.get(i).getDeptNm());
						temp.setBrdNm(getRepeatResult.get(i).getBrdNm());
						temp.setOwnerNm2(getRepeatResult.get(i).getOwnerNm2());
						temp.setDeptNm2(getRepeatResult.get(i).getDeptNm2());
						temp.setBrdNm2(getRepeatResult.get(i).getBrdNm2());
						
						if(Integer.parseInt(langStr) != 1){
							temp.setBrdNm(getRepeatResult.get(i).getBrdNm2());
						}
						
						temp.setDate(format.format(dateArr[0]).substring(0,10));
						temp.setValue(getRepeatResult.get(i).getOwnerId());
						
						getScheduleList.add(temp);
					}
					
				}
				
			}
		}
		

		//자원별 일정 정렬
	    //시간순, 제목순
        Collections.sort(getScheduleList, new Comparator<ResGetScheduleVO>() {
			@Override
			public int compare(ResGetScheduleVO o1, ResGetScheduleVO o2) {
					
				if(o1.getAllDay().compareTo(o2.getAllDay()) == 0){
					if(o1.getStartDate().compareTo(o2.getStartDate()) == 0){
						
						if(o1.getEndDate().compareTo(o2.getEndDate()) == 0){
							
							return o1.getTitle().compareTo(o2.getTitle());
						}else {
							return o1.getEndDate().compareTo(o2.getEndDate());
						}
						
					}else {
						return o1.getStartDate().compareTo(o2.getStartDate());
					}	
				}else {
					return o1.getAllDay().compareTo(o2.getAllDay());
				}
							
			}
		});
						
		logger.debug("getScheduleList: " + getScheduleList);		
		
		int count = getScheduleList.size();
		
		List<ResGetScheduleVO> resultList = new ArrayList<ResGetScheduleVO>();
		
		if(!listCnt.equals("")&&(listCnt != null)){
			int index = 0;
			index =	Integer.parseInt(listCnt);
			logger.debug("index: " + index);
			
			
			if(count > index){
				for (int k = 0; k < index; k++) {
					resultList.add(getScheduleList.get(k));
				}
			}else{
				resultList = getScheduleList;
			}	
		}else{
			resultList = getScheduleList;
		}
		
		String repeatYn = "N";

		if(check.equals("Y")) {
			for (ResGetScheduleVO vo : resultList) {
	
				if((Long.parseLong(vo.getStartDate().substring(0,17).replaceAll("-", "").replaceAll(":", "").replaceAll(" ", "")) <= Long.parseLong(checkSDate.replaceAll("-", "").replaceAll(":", "").replaceAll(" ", "")) && Long.parseLong(checkSDate.replaceAll("-", "").replaceAll(":", "").replaceAll(" ", "")) < Long.parseLong(vo.getEndDate().substring(0,17).replaceAll("-", "").replaceAll(":", "").replaceAll(" ", "")))
				||(Long.parseLong(vo.getStartDate().substring(0,17).replaceAll("-", "").replaceAll(":", "").replaceAll(" ", "")) < Long.parseLong(checkEDate.replaceAll("-", "").replaceAll(":", "").replaceAll(" ", "")) && Long.parseLong(checkEDate.replaceAll("-", "").replaceAll(":", "").replaceAll(" ", "")) <= Long.parseLong(vo.getEndDate().substring(0,17).replaceAll("-", "").replaceAll(":", "").replaceAll(" ", "")))
				|| (Long.parseLong(vo.getEndDate().substring(0,17).replaceAll("-", "").replaceAll(":", "").replaceAll(" ", "")) <= Long.parseLong(checkEDate.replaceAll("-", "").replaceAll(":", "").replaceAll(" ", "")) && Long.parseLong(checkSDate.replaceAll("-", "").replaceAll(":", "").replaceAll(" ", "")) <= Long.parseLong(vo.getStartDate().substring(0,17).replaceAll("-", "").replaceAll(":", "").replaceAll(" ", "")) )){
					if(Integer.parseInt(checkNum) != 0) {
						if(Integer.parseInt(checkNum) != vo.getNum()) {
							repeatYn = "Y";
						}
					} else {
						repeatYn = "Y";
					}
				}
			}
		}
		
		logger.debug("resultList: " + resultList);
			
		result.put("scheduleList", resultList);
		result.put("count", count);
		result.put("repeatYn", repeatYn);
		logger.debug("getScheduleList End");
		return result;
	}
	
	public List<Date[]> getRepDateTimes(ResScheduleRepetitionVO vo, String sDate, String eDate, String offset) throws Exception {
		logger.debug("getRepDeteTimes started");
		
		int maxTemp = 1000;
		
		List<Date[]> returnList = new ArrayList<Date[]>();
			
		int freq = vo.getFreq();
		
		if (sDate.length() == 10) {
			sDate += " 00:00:00";
		}
		if (eDate.length() == 10) {
			eDate += " 23:59:59";
		}
		
		if (freq == 4) {
			returnList = getDailyRepDateTimes(vo, sDate, eDate, maxTemp); 
		} else if (freq == 5) {
			returnList = getWeeklyRepDateTime(vo, sDate, eDate, maxTemp);
		} else if (freq == 6 || freq == 7) {
			returnList = getMonthlyRepDateTimes(vo, sDate, eDate, maxTemp);
		}
		
		logger.debug("returnList.size()=" + returnList.size());
		logger.debug("getRepDeteTimes ended");
		
		return returnList;
	}
	
	public List<Date[]> getDailyRepDateTimes(ResScheduleRepetitionVO vo, String sDate, String eDate, int maxTemp) throws Exception {
		int selType = vo.getSelType();
		int interval = vo.getInterval();
		int endRecurType = vo.getEndRecurType();
		int instances = vo.getInstances();
		int tempYoil = 0;
		
		// 자원예약 기간
		Date resEndDate = vo.getEndDate();
		
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		
		// 요청 기간
		Date startDate = sdf.parse(sDate);
		Date endDate = sdf.parse(eDate);

		String tmpStartDateStr = sdf.format(vo.getStartDate());
		String tmpEndDateStr = tmpStartDateStr.substring(0, 10) + sdf.format(vo.getEndDate()).substring(10);
		
		Date tmpStartDate = vo.getStartDate();
		Date tmpEndDate = sdf.parse(tmpEndDateStr);
		
		Calendar tempStartCal = Calendar.getInstance();
		tempStartCal.setTime(tmpStartDate);
		
		Calendar tempEndCal = Calendar.getInstance();
		tempEndCal.setTime(tmpEndDate);
		
		// timezone으로 인해 tmpStartDate가 tmpEndDate보다 늦은 경우 tmpEndDate를 하루 늘려준다.
		if (tmpStartDate.after(tmpEndDate)) {
			tempEndCal.add(Calendar.DATE, 1);
			tmpEndDate = tempEndCal.getTime();
		}
		
		long diff = tmpEndDate.getTime() - tmpStartDate.getTime();
		
		List<Date[]> returnList = new ArrayList<Date[]>();
		
		int temp = maxTemp; // 최대 maxTemp번 반복
		while (true) {
			
			// 40일 때(매 n일)
			if (selType == 0) {
				// 종료일 지정 안했을 경우
				if (endRecurType == 0) {
					if (tmpStartDate.after(endDate)) {
						break;
					} else if (!tmpStartDate.before(startDate)) {
						tempEndCal.setTime(tmpStartDate);
						tempEndCal.add(Calendar.MILLISECOND, (int)diff);
						
						returnList.add(new Date[] {
								tmpStartDate, 
								tempEndCal.getTime()
						});
					}
				}
				// 종료일 지정했을 경우
				else if (endRecurType == 2) {
					if (tmpStartDate.after(endDate) || tmpStartDate.after(resEndDate)) {
						break;
					} else if (!tmpStartDate.before(startDate)) {
						tempEndCal.setTime(tmpStartDate);
						tempEndCal.add(Calendar.MILLISECOND, (int)diff);
						
						returnList.add(new Date[] {
								tmpStartDate, 
								tempEndCal.getTime()
						});
					}
				}
				// 반복 횟수 지정했을 경우
				else if (endRecurType == 1) {
					if (tmpStartDate.after(endDate) || instances <= 0) {
						break;
					} else {
						if (!tmpStartDate.before(startDate)) {
							tempEndCal.setTime(tmpStartDate);
							tempEndCal.add(Calendar.MILLISECOND, (int)diff);
							
							returnList.add(new Date[] {
									tmpStartDate, 
									tempEndCal.getTime()
							});
						}
						
						instances--;
					}
				}
			}
			// 41일 때(평일 매일)
			else {
				tempYoil = tempStartCal.get(Calendar.DAY_OF_WEEK);
				
				// 종료일 지정 안했을 경우
				if (endRecurType == 0) {
					if (tmpStartDate.after(endDate)) {
						break;
					} else if (!tmpStartDate.before(startDate) && tempYoil > 1 && tempYoil < 7) {
						tempEndCal.setTime(tmpStartDate);
						tempEndCal.add(Calendar.MILLISECOND, (int)diff);
						
						returnList.add(new Date[] {
								tmpStartDate, 
								tempEndCal.getTime()
						});
					}
				}
				// 종료일 지정했을 경우
				else if (endRecurType == 2) {
					if (tmpStartDate.after(endDate) || tmpStartDate.after(resEndDate)) {
						break;
					} else if (!tmpStartDate.before(startDate) &&tempYoil > 1 && tempYoil < 7) {
						tempEndCal.setTime(tmpStartDate);
						tempEndCal.add(Calendar.MILLISECOND, (int)diff);
						
						returnList.add(new Date[] {
								tmpStartDate, 
								tempEndCal.getTime()
						});
					}
				}
				// 반복 횟수 지정했을 경우
				else if (endRecurType == 1) {
					if (tmpStartDate.after(endDate) || instances <= 0) {
						break;
					} else if (tempYoil > 1 && tempYoil < 7) {
						if (!tmpStartDate.before(startDate)) {
							tempEndCal.setTime(tmpStartDate);
							tempEndCal.add(Calendar.MILLISECOND, (int)diff);
							
							returnList.add(new Date[] {
									tmpStartDate, 
									tempEndCal.getTime()
							});
						}
						
						instances--;
					}
				}
			}
			
			tempStartCal.add(Calendar.DATE, interval);
			tmpStartDate = tempStartCal.getTime();
			
			temp--;
			
			if (temp < 0) {
				logger.debug("Repeat time over 1000.");
				break;
			}
		}
		
		return returnList;
	}
	
	public List<Date[]> getWeeklyRepDateTime (ResScheduleRepetitionVO vo, String sDate, String eDate, int maxTemp) throws Exception  {
		int interval = vo.getInterval();
		int endRecurType = vo.getEndRecurType();
		int instances = vo.getInstances();
		List<Integer> wDay = vo.getDaysOfWeek();
		
		if (wDay != null && wDay.size() > 0) {
			instances = instances * wDay.size();
		}
		
		// 자원예약 기간
		Date resStartDate = vo.getStartDate();
		Date resEndDate = vo.getEndDate();
		
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		
		// 요청 기간
		Date startDate = sdf.parse(sDate);
		Date endDate = sdf.parse(eDate);

		String tmpStartDateStr = sdf.format(vo.getStartDate());
		String tmpEndDateStr = tmpStartDateStr.substring(0, 10) + sdf.format(vo.getEndDate()).substring(10);
		
		Date tmpStartDate = vo.getStartDate();
		Date tmpEndDate = sdf.parse(tmpEndDateStr);
		
		Calendar tempStartCal = Calendar.getInstance();
		tempStartCal.setTime(tmpStartDate);
		
		Calendar tempEndCal = Calendar.getInstance();
		tempEndCal.setTime(tmpEndDate);
		
		// timezone으로 인해 tmpStartDate가 tmpEndDate보다 늦은 경우 tmpEndDate를 하루 늘려준다.
		if (tmpStartDate.after(tmpEndDate)) {
			tempEndCal.add(Calendar.DATE, 1);
			tmpEndDate = tempEndCal.getTime();
		}
		
		long diff = tmpEndDate.getTime() - tmpStartDate.getTime();
		
		List<Date[]> returnList = new ArrayList<Date[]>();
		
		int temp = maxTemp; // 최대 maxTemp번 반복
		
		boolean loopFlag = true;
		while (loopFlag) {
			
			for (int i=0; i<wDay.size(); i++) {
				tempStartCal.set(Calendar.DAY_OF_WEEK, wDay.get(i) + 1);
				tmpStartDate = tempStartCal.getTime();
				
				// 종료일 지정 안했을 경우
				if (endRecurType == 0) {
					if (tmpStartDate.after(endDate)) {
						loopFlag = false;
						break;
					} else if (!tmpStartDate.before(startDate) && !tmpStartDate.before(resStartDate)) {
						tempEndCal.setTime(tmpStartDate);
						tempEndCal.add(Calendar.MILLISECOND, (int)diff);
						
						returnList.add(new Date[] {
								tmpStartDate, 
								tempEndCal.getTime()
						});
					}
				}
				// 종료일 지정했을 경우
				else if (endRecurType == 2) {
					if (tmpStartDate.after(endDate) || tmpStartDate.after(resEndDate)) {
						loopFlag = false;
						break;
					} else if (!tmpStartDate.before(startDate) && !tmpStartDate.before(resStartDate)) {
						tempEndCal.setTime(tmpStartDate);
						tempEndCal.add(Calendar.MILLISECOND, (int)diff);
						
						returnList.add(new Date[] {
								tmpStartDate, 
								tempEndCal.getTime()
						});
					}
				}
				// 반복 횟수 지정했을 경우
				else if (endRecurType == 1) {
					if (tmpStartDate.after(endDate) || instances <= 0) {
						loopFlag = false;
						break;
					} else if (!tmpStartDate.before(resStartDate)) {
						instances--;
						
						if (!tmpStartDate.before(startDate)) {
							tempEndCal.setTime(tmpStartDate);
							tempEndCal.add(Calendar.MILLISECOND, (int)diff);
							
							returnList.add(new Date[] {
									tmpStartDate, 
									tempEndCal.getTime()
							});
						}
					}
				}
				
			}
			
			tempStartCal.add(Calendar.DATE, interval * 7);
			
			temp--;
			
			if (temp < 0) {
				logger.debug("Repeat time over 1000.");
				break;
			}
			
		}
		
		return returnList;
	}
	
	public List<Date[]> getMonthlyRepDateTimes(ResScheduleRepetitionVO vo, String sDate, String eDate, int maxTemp) throws Exception {
		logger.debug("getMonthlyRepDateTimes started.");
		int freq = vo.getFreq();
		int selType = vo.getSelType();
		int interval = vo.getInterval();
		int daysOfMonth = vo.getDaysOfMonth();
		int monthsOfYear = vo.getMonthsOfYear();
		int byPosition = vo.getByPosition();
		int endRecurType = vo.getEndRecurType();
		int instances = vo.getInstances();
		List<Integer> wDay = vo.getDaysOfWeek();
		
		if (wDay != null && wDay.size() > 0) {
			instances = instances * wDay.size();
		}
		
		// 자원예약 기간
		Date resStartDate = vo.getStartDate();
		Date resEndDate = vo.getEndDate();
		
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		
		// 요청 기간
		Date startDate = sdf.parse(sDate);
		Date endDate = sdf.parse(eDate);

		String tmpStartDateStr = sdf.format(vo.getStartDate());
		String tmpEndDateStr = tmpStartDateStr.substring(0, 10) + sdf.format(vo.getEndDate()).substring(10);
		
		Date tmpStartDate = vo.getStartDate();
		Date tmpEndDate = sdf.parse(tmpEndDateStr);
		
		Calendar tempStartCal = Calendar.getInstance();
		tempStartCal.setTime(tmpStartDate);
		
		Calendar tempEndCal = Calendar.getInstance();
		tempEndCal.setTime(tmpEndDate);
		
		// timezone으로 인해 tmpStartDate가 tmpEndDate보다 늦은 경우 tmpEndDate를 하루 늘려준다.
		if (tmpStartDate.after(tmpEndDate)) {
			tempEndCal.add(Calendar.DATE, 1);
			tmpEndDate = tempEndCal.getTime();
		}
		
		long diff = tmpEndDate.getTime() - tmpStartDate.getTime();
		
		List<Date[]> returnList = new ArrayList<Date[]>();
		
		int temp = maxTemp; // 최대 maxTemp번 반복
		
		List<Date> tsdList = new ArrayList<Date>();
		
		boolean loopFlag = true;
		while (loopFlag) {
			tsdList.clear();
			
			if (freq == 7) {
				tempStartCal.set(Calendar.MONTH, monthsOfYear - 1);
			}
			
			// 날짜
			if (selType == 0) {
				// daysOfMonth가 해당 달의 마지막날보다 크지 않으면 list에 추가
				int lastDate = tempStartCal.getActualMaximum(Calendar.DAY_OF_MONTH);
				if (daysOfMonth <= lastDate) {
					tempStartCal.set(Calendar.DAY_OF_MONTH, daysOfMonth);
					tsdList.add(tempStartCal.getTime());
				}
			}
			// 요일
			else {
				// 마지막 요일일 때
				if (byPosition == -1) {
					// 해당 달의 뒤에서 부터 원하는 요일의 날짜를 찾아감.
					int lastDate = tempStartCal.getActualMaximum(Calendar.DAY_OF_MONTH);
					tempStartCal.set(Calendar.DATE, lastDate);
					int lastYoil = tempStartCal.get(Calendar.DAY_OF_WEEK) - 1;
					
					// 발견할 때까지 날짜 줄여나감
					while (!wDay.contains(lastYoil)) {
						tempStartCal.add(Calendar.DATE, -1);
						lastYoil = tempStartCal.get(Calendar.DAY_OF_WEEK) - 1;
					}
					
					// 발견하면 그때부터 list에 추가
					while (wDay.contains(lastYoil)) {
						tsdList.add(tempStartCal.getTime());
						
						tempStartCal.add(Calendar.DATE, -1);
						lastYoil = tempStartCal.get(Calendar.DAY_OF_WEEK) - 1;
					}
					
					//뒤에서부터 찾았기 때문에 횟수제한이 있을 때에는 문제가 있으므로 reverse해줌.
					Collections.reverse(tsdList);
				}
				// 마지막 요일 아닐 때
				else {
					// 해당 달의 앞에서 부터 n번째 요일의 날짜를 찾아감.
					tempStartCal.set(Calendar.DATE, 1);
					int firstYoil = tempStartCal.get(Calendar.DAY_OF_WEEK) - 1;
					
					//발견할 때까지 날짜 늘려나감
					while (!wDay.contains(firstYoil)) {
						tempStartCal.add(Calendar.DATE, 1);
						firstYoil = tempStartCal.get(Calendar.DAY_OF_WEEK) - 1;
					}
					
					tempStartCal.add(Calendar.DATE, (byPosition - 1) * 7);
					
					// 발견하면 그때부터 list에 추가
					while (wDay.contains(firstYoil)) {
						tsdList.add(tempStartCal.getTime());
						
						tempStartCal.add(Calendar.DATE, 1);
						firstYoil = tempStartCal.get(Calendar.DAY_OF_WEEK) - 1;
					}
				}
			}
			
			for (Date tsd : tsdList) {
				// 종료일 지정 안했을 경우
				if (endRecurType == 0) {
					if (tsd.after(endDate)) {
						loopFlag = false;
						break;
					} else if (!tsd.before(startDate) && !tsd.before(resStartDate)) {
						tempEndCal.setTime(tsd);
						tempEndCal.add(Calendar.MILLISECOND, (int)diff);
						
						returnList.add(new Date[] {
								tsd, 
								tempEndCal.getTime()
						});
					}
				}
				// 종료일 지정했을 경우
				else if (endRecurType == 2) {
					if (tsd.after(endDate) || tsd.after(resEndDate)) {
						loopFlag = false;
						break;
					} else if (!tsd.before(startDate) && !tsd.before(resStartDate)) {
						tempEndCal.setTime(tsd);
						tempEndCal.add(Calendar.MILLISECOND, (int)diff);
						
						returnList.add(new Date[] {
								tsd, 
								tempEndCal.getTime()
						});
					}
				}
				// 반복 횟수 지정했을 경우
				else if (endRecurType == 1) {
					if (tsd.after(endDate) || instances <= 0) {
						loopFlag = false;
						break;
					} else if (!tsd.before(resStartDate)) {
						instances--;
						
						if (!tsd.before(startDate)) {
							tempEndCal.setTime(tsd);
							tempEndCal.add(Calendar.MILLISECOND, (int)diff);
							
							returnList.add(new Date[] {
									tsd, 
									tempEndCal.getTime()
							});
						}
					}
				}
			}
			
			if (freq == 6) {
				tempStartCal.add(Calendar.MONTH, interval);
			} else {
				tempStartCal.add(Calendar.YEAR, 1);
			}
			
			temp--;
			
			if (temp < 0) {
				logger.debug("Repeat time over 1000.");
				break;
			}
			
		}
		
		logger.debug("getMonthlyRepDateTimes End");
		return returnList;
	}
	
	public List<ResGetScheduleVO> getScheduleNormalList(String ownerID, String companyID, String startDate, String endDate, String writerDept, String offset, int tenantID) throws Exception {

		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_POWNERID", ownerID);
		map.put("v_PCOMPANYID", companyID);
		map.put("v_PSTARTDATE", startDate);
		map.put("v_PENDDATE", endDate);
		map.put("v_WRITERDEPT", writerDept);
		map.put("tenantID", tenantID);
		return mResourceDAO.getScheduleList(map);
	}

	public List<ResGetScheduleVO> getScheduleListMain(String ownerID, String companyID, String startDate, String endDate, String offset, int tenantID) throws Exception {
		startDate = commonUtil.getDateStringInUTC(startDate, offset, true);
		endDate = commonUtil.getDateStringInUTC(endDate, offset, true);
		
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_pOwnerID", ownerID);
		map.put("v_pCompanyID", companyID);
		map.put("v_pStartDate", startDate);
		map.put("v_pEndDate", endDate);
		map.put("tenantID", tenantID);
		
		return mResourceDAO.getScheduleListMain(map);
	}

	public List<ResGetScheduleVO> getScheduleListRepetiti(String ownerID, String companyID, String startDate, String endDate, String writerDept, String offset, int tenantID) throws Exception {
		
		Map<String,Object> map = new HashMap<String, Object>();
		
		map.put("v_POWNERID", ownerID);
		map.put("v_PCOMPANYID", companyID);
		map.put("v_PSTARTDATE", startDate);
		map.put("v_PENDDATE", endDate);
		map.put("v_WRITERDEPT", writerDept);
		map.put("tenantID", tenantID);
		
		return mResourceDAO.getScheduleListRepetiti(map);
	}
	
	public List<ResGetScheduleVO> getScheduleListRepetitim( String ownerID, String companyID, String startDate, int tenantID, String offset) throws Exception {
		startDate = commonUtil.getDateStringInUTC(startDate, offset, true);
		
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_POWNERID", ownerID);
		map.put("v_PCOMPANYID", companyID);
		map.put("v_PSTARTDATE", startDate);
		map.put("tenantID", tenantID);
		
		return mResourceDAO.getScheduleListRepetitim(map);
	}
	
	public List<String> getDeletedRepScheduleDate(int pNum, String companyID, String ownerID, int tenantID) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_P_pNum", pNum);
		map.put("v_P_companyID", companyID);
		map.put("v_P_ownerID", ownerID);
		map.put("tenantID", tenantID);
		return mResourceDAO.getDeletedRepScheduleDate(map);
	}
	
	
	public ResGetScheduleRepetitionVO getRepDateTimes(String ownerID, String companyID, int num, int tenantID) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_pOwnerID", ownerID);
		map.put("v_pCompanyID", companyID);
		map.put("v_pNum", num);
		map.put("tenantID", tenantID);
		return mResourceDAO.getRepDateTimes(map);
	}
	
	public ResScheduleRepetitionVO resStruct(String strFrequency, String strSelType, String strEndRecurType, String strStartDateTime, String strEndDateTime, 
			String strInterval, String strDaysOfWeek, String strInstances, String strByPosition, String strDaysOfMonth, String strMonthsOfYear) throws Exception {
		logger.debug("resStruct started");

		ResScheduleRepetitionVO result = new ResScheduleRepetitionVO();
		
		if (strFrequency != null && !strFrequency.trim().equals("")) {
			result.setFreq(Integer.parseInt(strFrequency));
		}
		
		if (strSelType != null && !strSelType.trim().equals("")) {
			result.setSelType(Integer.parseInt(strSelType));
		} else {
			result.setSelType(-1);
		}
		
		if (strInterval != null && !strInterval.trim().equals("")) {
			result.setInterval(Integer.parseInt(strInterval));
		}
		
		if (strEndRecurType != null && !strEndRecurType.trim().equals("")) {
			result.setEndRecurType(Integer.parseInt(strEndRecurType));
		} else {
			result.setEndRecurType(-1);
		}
		
		if (strInstances != null && !strInstances.trim().equals("")) {
			result.setInstances(Integer.parseInt(strInstances));
		}
		
		if (strDaysOfWeek != null && !strDaysOfWeek.trim().equals("")) {
			List<Integer> yoilList = new ArrayList<Integer>();
			String[] yoilArr = strDaysOfWeek.split(",");
			
			for (String yoil : yoilArr) {
				yoilList.add(Integer.parseInt(yoil.trim())); 
			}
			
			result.setDaysOfWeek(yoilList);
		}
		
		if (strDaysOfMonth != null && !strDaysOfMonth.trim().equals("")) {
			result.setDaysOfMonth(Integer.parseInt(strDaysOfMonth));
		}
		
		if (strMonthsOfYear != null && !strMonthsOfYear.trim().equals("")) {
			result.setMonthsOfYear(Integer.parseInt(strMonthsOfYear));
		}
		
		if (strByPosition != null && !strByPosition.trim().equals("")) {
			result.setByPosition(Integer.parseInt(strByPosition));
		}
		
		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		
		if (strStartDateTime != null && !strStartDateTime.trim().equals("")) {
			result.setStartDate(format.parse(strStartDateTime));
		}
		
		if (strEndDateTime != null && !strEndDateTime.trim().equals("")) {
			result.setEndDate(format.parse(strEndDateTime));
		}
		
		logger.debug("resStruct ended");
		return result;
	}
	
	public ResScheduleRepetitionVO resStruct(ResGetScheduleRepetitionVO vo) throws Exception {
		logger.debug("resStruct started");

		ResScheduleRepetitionVO result = new ResScheduleRepetitionVO();
		
		if (vo.getReWay() != null && vo.getReWay().length() == 2) {
			result.setFreq(Integer.parseInt(vo.getReWay().substring(0, 1)));
			result.setSelType(Integer.parseInt(vo.getReWay().substring(1)));
		} else {
			result.setSelType(-1);
		}
		
		if (vo.getReNum() != null && !vo.getReNum().trim().equals("")) {
			result.setInterval(Integer.parseInt(vo.getReNum().trim()));
		}
		
		if (vo.getEndFlag() != null && !vo.getEndFlag().trim().equals("")) {
			result.setEndRecurType(Integer.parseInt(vo.getEndFlag().trim()));
		} else {
			result.setEndRecurType(-1);
		}
		
		if (vo.getReCount() != null && !vo.getReCount().trim().equals("")) {
			result.setInstances(Integer.parseInt(vo.getReCount().trim()));
		}
		
		if (vo.getReYoil() != null && !vo.getReYoil().trim().equals("")) {
			List<Integer> yoilList = new ArrayList<Integer>();
			String[] yoilArr = vo.getReYoil().split(",");
			
			for (String yoil : yoilArr) {
				yoilList.add(Integer.parseInt(yoil.trim())); 
			}
			
			result.setDaysOfWeek(yoilList);
		}
		
		if (vo.getReDay() != null && !vo.getReDay().trim().equals("")) {
			result.setDaysOfMonth(Integer.parseInt(vo.getReDay().trim()));
		}
		
		if (vo.getReMonth() != null && !vo.getReMonth().trim().equals("")) {
			result.setMonthsOfYear(Integer.parseInt(vo.getReMonth().trim()));
		}
		
		if (vo.getReOrd() != null && !vo.getReOrd().trim().equals("")) {
			result.setByPosition(Integer.parseInt(vo.getReOrd().trim()));
		}
		
		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		
		if (vo.getStartDateTime() != null && !vo.getStartDateTime().trim().equals("")) {
			result.setStartDate(format.parse(vo.getStartDateTime()));
		}
		
		if (vo.getEndDateTime() != null && !vo.getEndDateTime().trim().equals("")) {
			result.setEndDate(format.parse(vo.getEndDateTime().trim()));
		}
		
		if (vo.getAllDay() != null && vo.getAllDay().equals("1")) {
			result.setAllDay(true);
		}
		
		logger.debug("resStruct ended");
		return result;
	}

	@Override
	public Map<String, Object> getScheduleMainList(MCommonVO info,
			String listCnt, String langStr) throws Exception {
		
		String ownerId = "";
		String utcStartDate = "";
		String utcEndDate = "";
		String companyId = "";
		String writerDt = "";
		int tenantId = 0;
		String offset = "";
		//String today = commonUtil.getTodayUTCTime("yyyy-MM-dd HH:mm:ss");

		String today = new SimpleDateFormat("yyyy-MM-dd").format(new Date());
		
		companyId = info.getCompanyId();
		offset = info.getOffSet();
		writerDt = info.getDeptId();
		tenantId = info.getTenantId();
		utcStartDate = today.substring(0,10);
    	utcEndDate = today.substring(0,10);
  	
		Map<String, Object> result = getScheduleList(ownerId, companyId, utcStartDate, utcEndDate, writerDt, tenantId, offset, listCnt, "", "", "", "", langStr);
		
		return result;
	}

	//휴일가져오기
	@Override
	public List<ResScheGetHolidayVO> getTholiday(String companyId,
			String userCompany, int tenantId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_COMPANYID", companyId);
		map.put("v_USERCOMPANY", userCompany);
		map.put("v_TENANTID", tenantId);
		
		return mResourceDAO.getTholiday(map);
	}
	
	//자원상세정보 가져오기
	@Override
	public MResourceScheduleVO getResBrdDetail(String ownerId, String companyId, int tenantId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PBRDID", ownerId);
		map.put("tenantID", tenantId);
		map.put("v_PCOMPANYID", companyId);
		
		return mResourceDAO.getResBrdDetail(map);
	}



	@Override
	public Map<String, Object> getScheduleApprList(String ownerID, String companyID, String sDate, String eDate, String userId, String deptId, String writerName, String approveType, int tenantID, String offset, String check, String checkNum, String checkSDate, String checkEDate, String langStr, String authYn) throws Exception {
		
		logger.debug("getScheduleList Start");
		
		Map<String, Object> result = new HashMap<>();
		String startDateLimit = eDate + " 23:59:59";
		String endDateLimit = sDate + " 00:00:01";

		startDateLimit = commonUtil.getDateStringInUTC(startDateLimit, offset, true);
		endDateLimit = commonUtil.getDateStringInUTC(endDateLimit, offset, true);
		logger.debug("");
		
		logger.debug("startDateLimit" + startDateLimit);
		logger.debug("endDateLimit" + endDateLimit);
		
		
		// 스케줄 정보 가져옴(tbl_schedule에서 반복예약이 아닌 것만 가져옴)
		List<ResGetScheduleVO> getScheduleList = getScheduleApprNormalList(ownerID, companyID, startDateLimit, endDateLimit, userId, deptId, writerName, approveType, tenantID, check, authYn);
		
		for (ResGetScheduleVO resVO : getScheduleList) {
			resVO.setStartDate(commonUtil.getDateStringInUTC(resVO.getStartDate(), offset, false));
			resVO.setEndDate(commonUtil.getDateStringInUTC(resVO.getEndDate(), offset, false));
			resVO.setDate(resVO.getStartDate().substring(0,10));
			
			if(Integer.parseInt(langStr) != 1){
				resVO.setBrdNm(resVO.getBrdNm2());
			}
		}
		
		List<ResGetScheduleVO> getRepeatResult= new ArrayList<ResGetScheduleVO>();
			
		// 스케줄 정보 가져옴(tbl_schedule에서 반복예약인 것만 가져옴)
		List<ResGetScheduleVO> getScheduleListRept = getScheduleApprRepetList(ownerID, companyID, startDateLimit, endDateLimit, userId, deptId, writerName, approveType, tenantID, check, authYn);
		
		logger.debug("getScheduleListRept: " + getScheduleListRept);
		
		getRepeatResult.addAll(getScheduleListRept);
		
		// return할 ResGetScheduleVO getScheduleList 에 추가(반복예약)
		if (getRepeatResult.size() > 0 ) {
			
			SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			for (int i=0; i<getRepeatResult.size(); i++) {
				String reCompanyID = getRepeatResult.get(i).getCompanyId();
				String reNum = Integer.toString(getRepeatResult.get(i).getNum());
				String reOwnerID = getRepeatResult.get(i).getOwnerId();
				
				// tbl_schedulerepetition에서 정보 가져옴
				ResGetScheduleRepetitionVO vo = getRepDateTimes(reOwnerID, reCompanyID, Integer.parseInt(reNum), tenantID);
				
				if (vo != null) {
					
					vo.setStartDateTime(commonUtil.getDateStringInUTC(vo.getStartDateTime(), offset, false));
					vo.setEndDateTime(commonUtil.getDateStringInUTC(vo.getEndDateTime(), offset, false));
					
					// ResGetScheduleRepetitionVO -> ResScheduleRepetitionVO
					ResScheduleRepetitionVO rvo = resStruct(vo);
					logger.debug("ResScheduleRepetitionVO: " + rvo);
					
					// 반복예약의 반복되는 날짜리스트 뽑아옴
					List<Date[]> returnRepDateTimes = getRepDateTimes(rvo, sDate, eDate, offset);
					
					// 반복예약 중에 삭제된 예약 가져옴
					List<String> deletedDateStrList = getDeletedRepScheduleDate(Integer.parseInt(reNum), reCompanyID, reOwnerID, tenantID);
					logger.debug("deletedDateStrList.size=" + deletedDateStrList.size());
					
					for (int j=0; j<deletedDateStrList.size(); j++) {
						deletedDateStrList.set(j, commonUtil.getDateStringInUTC(deletedDateStrList.get(j), offset, false));
					}
					
					for (Date[] dateArr : returnRepDateTimes) {
						// 삭제된 예약이면 넘어감
						if (deletedDateStrList.contains(format.format(dateArr[0]))) {
							continue;
						}
						
						ResGetScheduleVO temp = new ResGetScheduleVO();
						
						temp.setNum(getRepeatResult.get(i).getNum());
						temp.setpNum(getRepeatResult.get(i).getNum());
						temp.setOwnerId(getRepeatResult.get(i).getOwnerId());
						temp.setTitle(getRepeatResult.get(i).getTitle());
						temp.setLocation(getRepeatResult.get(i).getLocation());
						temp.setTimeDisplay(getRepeatResult.get(i).getTimeDisplay());
						temp.setStartDate(format.format(dateArr[0]));
						temp.setEndDate(format.format(dateArr[1]));
						temp.setAlertTime(getRepeatResult.get(i).getAlertTime());
						temp.setReFlag(getRepeatResult.get(i).getReFlag());
						temp.setGresFlag(getRepeatResult.get(i).getGresFlag());
						temp.setWriterId(getRepeatResult.get(i).getWriterId());
						temp.setImportance(getRepeatResult.get(i).getImportance());
						temp.setEntryList(getRepeatResult.get(i).getEntryList());
						temp.setAllDay(getRepeatResult.get(i).getAllDay());
						temp.setWriteDay(getRepeatResult.get(i).getWriteDay());
						temp.setAttachFlag(getRepeatResult.get(i).getAttachFlag());
						temp.setCharacterId(getRepeatResult.get(i).getCharacterId());
						temp.setApproveFlag(getRepeatResult.get(i).getApproveFlag());
						temp.setOwnerNm(getRepeatResult.get(i).getOwnerNm());
						temp.setDeptNm(getRepeatResult.get(i).getDeptNm());
						temp.setBrdNm(getRepeatResult.get(i).getBrdNm());
						temp.setBrdStep(getRepeatResult.get(i).getBrdStep());
						temp.setBrdUpper(getRepeatResult.get(i).getBrdUpper());
						temp.setBrdUpperStep(getRepeatResult.get(i).getBrdUpperStep());
						temp.setOwnerNm2(getRepeatResult.get(i).getOwnerNm2());
						temp.setDeptNm2(getRepeatResult.get(i).getDeptNm2());
						temp.setBrdNm2(getRepeatResult.get(i).getBrdNm2());
						
						if(Integer.parseInt(langStr) != 1){
							temp.setBrdNm(getRepeatResult.get(i).getBrdNm2());
						}
						temp.setDate(format.format(dateArr[0]).substring(0,10));
						temp.setValue(getRepeatResult.get(i).getOwnerId());
						
						getScheduleList.add(temp);
					}
					
				}
				
			}
		}
		
		//승인자원정렬
        //자원순, 시작일 순으로 정렬
        Collections.sort(getScheduleList, new Comparator<ResGetScheduleVO>() {
			@Override
			public int compare(ResGetScheduleVO o1, ResGetScheduleVO o2) {
				
				if(Integer.parseInt(o1.getBrdUpper()) == Integer.parseInt(o2.getBrdUpper())){
					
					if(Integer.parseInt(o1.getBrdUpperStep()) == Integer.parseInt(o2.getBrdUpperStep())){
					
						if(Integer.parseInt(o1.getBrdStep()) == Integer.parseInt(o2.getBrdStep())){
				
							if(o2.getStartDate().compareTo(o1.getStartDate()) == 0){
								
								if(o2.getEndDate().compareTo(o1.getEndDate()) == 0){
									
									return o1.getTitle().compareTo(o2.getTitle());
								}else {
									return o2.getEndDate().compareTo(o1.getEndDate());
								}
								
							}else {
								return o2.getStartDate().compareTo(o1.getStartDate());
							}
									
						}else {
							return Integer.parseInt(o1.getBrdStep()) < Integer.parseInt(o2.getBrdStep()) ? -1: Integer.parseInt(o1.getBrdStep()) > Integer.parseInt(o2.getBrdStep()) ? 1:0;
						}
					
					}else {
						return Integer.parseInt(o1.getBrdUpperStep()) < Integer.parseInt(o2.getBrdUpperStep()) ? -1: Integer.parseInt(o1.getBrdUpperStep()) > Integer.parseInt(o2.getBrdUpperStep()) ? 1:0;
					}
					
				}else {
					return Integer.parseInt(o1.getBrdUpper()) < Integer.parseInt(o2.getBrdUpper()) ? -1: Integer.parseInt(o1.getBrdUpper()) > Integer.parseInt(o2.getBrdUpper()) ? 1:0;
				}
			
			}
		});
		
		String repeatYn = "N";

		if(check.equals("Y")) {
			logger.debug("checkSDate" + checkSDate);
			logger.debug("checkEDate" + checkEDate);
			
			for (ResGetScheduleVO vo : getScheduleList) {
			
				logger.debug("vo in loop for cheking repeat " + vo.toString());
				logger.debug("vo.getStartDate() " + Long.parseLong(vo.getStartDate().replaceAll("-", "").replaceAll(":", "").replaceAll(" ", "").substring(0,14)));
				logger.debug("vo.getEndDate() " + Long.parseLong(vo.getEndDate().replaceAll("-", "").replaceAll(":", "").replaceAll(" ", "").substring(0,14))); 
				logger.debug("checkSDate() " + Long.parseLong(checkSDate.replaceAll("-", "").replaceAll(":", "").replaceAll(" ", "").substring(0,14)));
				logger.debug("checkEDate() " + Long.parseLong(checkEDate.replaceAll("-", "").replaceAll(":", "").replaceAll(" ", "").substring(0,14)));
				
				if((Long.parseLong(vo.getStartDate().replaceAll("-", "").replaceAll(":", "").replaceAll(" ", "").substring(0,14)) <= Long.parseLong(checkSDate.replaceAll("-", "").replaceAll(":", "").replaceAll(" ", "")) && Long.parseLong(checkSDate.replaceAll("-", "").replaceAll(":", "").replaceAll(" ", "")) < Long.parseLong(vo.getEndDate().replaceAll("-", "").replaceAll(":", "").replaceAll(" ", "").substring(0,14)))
				||(Long.parseLong(vo.getStartDate().replaceAll("-", "").replaceAll(":", "").replaceAll(" ", "").substring(0,14)) < Long.parseLong(checkEDate.replaceAll("-", "").replaceAll(":", "").replaceAll(" ", "")) && Long.parseLong(checkEDate.replaceAll("-", "").replaceAll(":", "").replaceAll(" ", "")) <= Long.parseLong(vo.getEndDate().replaceAll("-", "").replaceAll(":", "").replaceAll(" ", "").substring(0,14)))
				||(Long.parseLong(vo.getEndDate().replaceAll("-", "").replaceAll(":", "").replaceAll(" ", "").substring(0,14)) <= Long.parseLong(checkEDate.replaceAll("-", "").replaceAll(":", "").replaceAll(" ", "")) && Long.parseLong(checkSDate.replaceAll("-", "").replaceAll(":", "").replaceAll(" ", "")) <= Long.parseLong(vo.getStartDate().replaceAll("-", "").replaceAll(":", "").replaceAll(" ", "").substring(0,14)) )){
					logger.debug("repeat repeat repaet !!!!");	
					repeatYn = "Y";
				}
			}
		}
				
		logger.debug("resultList: " + getScheduleList);		
		
		result.put("scheduleList", getScheduleList);
		result.put("count", getScheduleList.size());
		result.put("repeatYn", repeatYn);
		logger.debug("getScheduleList End");
		return result;
	}
	
	public List<ResGetScheduleVO> getScheduleApprNormalList(String ownerID, String companyID, String sDate, String eDate, String userId, String deptId, String writerName, String approveType, int tenantID, String check, String authYn) throws Exception {

		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_POWNERID", ownerID);
		map.put("v_PCOMPANYID", companyID);
		map.put("v_PSTARTDATE", sDate);
		map.put("v_PENDDATE", eDate);
		map.put("v_PUSERID", userId);
		map.put("v_PDEPTID", deptId);
		map.put("v_WRITERNAME", writerName);
		map.put("v_APPROVETYPE", approveType);
		map.put("v_PAUTHYN", authYn);
		map.put("tenantID", tenantID);
		map.put("check", check);
		
		return mResourceDAO.getScheduleApprList(map);
	}
	
	public List<ResGetScheduleVO> getScheduleApprRepetList(String ownerID, String companyID, String sDate, String eDate, String userId, String deptId, String writerName, String approveType, int tenantID, String check, String authYn) throws Exception {
		
		Map<String,Object> map = new HashMap<String, Object>();		
		map.put("v_POWNERID", ownerID);
		map.put("v_PCOMPANYID", companyID);
		map.put("v_PSTARTDATE", sDate);
		map.put("v_PENDDATE", eDate);
		map.put("v_PUSERID", userId);
		map.put("v_PDEPTID", deptId);
		map.put("v_WRITERNAME", writerName);
		map.put("v_APPROVETYPE", approveType);
		map.put("v_PAUTHYN", authYn);
		map.put("tenantID", tenantID);
		map.put("check", check);
		return mResourceDAO.getScheduleApprListRepetiti(map);
	}
	
	@Override
	public List<MResourceGetAdmSubClsTreeVO> getResApprBrdList(String brdCompany, String userId, String userCompany, String userDept, int tenantId, String langStr, String authYn) {	
		logger.debug("getResApprBrdList start.");
		
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_PBRDCOMPANY", brdCompany);
		map.put("v_PUSERID", userId);
		map.put("v_PUSERCOMPANY", userCompany);
		map.put("v_PUSERDEPT", userDept);
		map.put("v_PAUTHYN", authYn);
		map.put("tenantID", tenantId);
		
		List<MResourceGetAdmSubClsTreeVO> result = mResourceDAO.getResApprBrdList(map);

		if(Integer.parseInt(langStr) != 1){
			for (MResourceGetAdmSubClsTreeVO resultVO : result) {
					resultVO.setBrdNm(resultVO.getBrdNm2());
			}
		}
		
		return result;
	}
	
	@Override
	public List<MResourceGetAdmSubClsTreeVO> getResApprBrdListCheck(String brdCompany, String userId, String userCompany, String userDept, int tenantId, String langStr, String authYn, String brdID) throws Exception {	
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_PBRDCOMPANY", brdCompany);
		map.put("v_PUSERID", userId);
		map.put("v_PUSERCOMPANY", userCompany);
		map.put("v_PUSERDEPT", userDept);
		map.put("v_PAUTHYN", authYn);
		map.put("tenantID", tenantId);
		
		if(!brdID.equals("")) {
			map.put("v_brdID", brdID);
		}
		
		List<MResourceGetAdmSubClsTreeVO> result = mResourceDAO.getResApprBrdListCheck(map);
		
		String deptPath = ezOrganService.getDeptPath(userDept, tenantId);

		List<String> deptIds = new ArrayList<String>();
		Collections.addAll(deptIds, deptPath.split(","));
		Collections.reverse(deptIds);
		deptIds.remove(0);		// 현재 부서ID 삭제
		
		for(int i=0; i<deptIds.size(); i++) {
			map.put("v_PUSERDEPT", deptIds.get(i));
			List<MResourceGetAdmSubClsTreeVO> result2 = mResourceDAO.getResApprBrdListCheck2(map);
			
			if(result2.size() > 0)
				result.addAll(result2);
		}
		
		// 사내 겸직 권한 체크
		List<OrganUserVO> userAddJobList = ezOrganAdminService.getUserAddJobList(userId, "1", tenantId);

		if(userAddJobList.size() > 0) {
			for(int i=0; i<userAddJobList.size(); i++) {
				String addJobDeptPath = ezOrganService.getDeptPath(userAddJobList.get(i).getDepartment(), tenantId);
				List<String> addJobDeptIds = new ArrayList<String>();
				Collections.addAll(addJobDeptIds, addJobDeptPath.split(","));
				addJobDeptIds.remove(0);				// companyID 삭제
				if(addJobDeptIds.size() > 0) {
					Collections.reverse(addJobDeptIds);
					
					for(int j=0; j<addJobDeptIds.size(); j++) {
						map.put("v_PUSERDEPT", addJobDeptIds.get(j));
						List<MResourceGetAdmSubClsTreeVO> result2 = mResourceDAO.getResApprBrdListCheck2(map);
						
						if(result2.size() > 0)
							result.addAll(result2);
					}
				}
			}
		}
					
		if(Integer.parseInt(langStr) != 1){
			for (MResourceGetAdmSubClsTreeVO resultVO : result) {
					resultVO.setBrdNm(resultVO.getBrdNm2());
			}
		}
		
		return result;
	}
	
	@Override
	public List<String> getResAdminAuth(String userId, int tenantId, String companyId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userId", userId);
		map.put("tenantId", tenantId);
		map.put("companyId", companyId);
		
		return mResourceDAO.getResAdminAuth(map);
	}
	
	@Override
	public String getResUpperBrdID(String ownerId, int tenantId, String companyId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("ownerId", ownerId);
		map.put("tenantId", tenantId);
		map.put("companyId", companyId);
		
		return mResourceDAO.getResUpperBrdID(map);
	}
}

