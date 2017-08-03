package egovframework.ezMobile.ezResource.service.impl;


import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.poi.ss.formula.functions.T;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.w3c.dom.Document;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezResource.vo.ResGetScheduleRepetitionVO;
import egovframework.ezEKP.ezResource.vo.ResGetScheduleVO;
import egovframework.ezEKP.ezResource.vo.ResScheduleRepetitionVO;
import egovframework.ezMobile.ezResource.dao.MResourceDAO;
import egovframework.ezMobile.ezResource.service.MResourceService;
import egovframework.ezMobile.ezResource.vo.MResourceGetAdmSubClsTreeVO;
import egovframework.ezMobile.ezResource.vo.MResourceGetScheduleVO;
import egovframework.ezMobile.ezResource.vo.MResourceScheduleVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service("MResourceService")
public class MResourceServiceImpl extends EgovAbstractServiceImpl implements MResourceService{
	
	private static final Logger LOGGER = LoggerFactory.getLogger(MResourceServiceImpl.class);
	
	@Resource(name="MResourceDAO")
	private MResourceDAO mResourceDAO;
	
	@Resource(name="EzCommonService")
	private EzCommonService ezCommonService;
	
	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;
	
	@Autowired
	private CommonUtil commonUtil;

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
		LOGGER.debug("size of list: " + list.size());
		return list;
	}

	@Override
	public MResourceScheduleVO getResScheduleDetail(String resourceId, String ScheduleId,
			String companyId, int tenantId) {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_POWNERID", resourceId);
		map.put("v_PNUM", ScheduleId);
		map.put("v_PCOMPANYID", companyId);
		map.put("tenantID", tenantId);
		return mResourceDAO.getResScheduleDetail(map);
	}

	@Override
	public List<MResourceGetAdmSubClsTreeVO> getResBrdList(String brdId,
			String brdCompany, int tenantId) {
		
		LOGGER.debug("brdId: " + brdId);
		LOGGER.debug("brdCompany: " + brdCompany);
		LOGGER.debug("tenantId: " + tenantId);
		
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_PBRDID", brdId);
		map.put("v_PBRDCOMPANY", brdCompany);
		map.put("tenantID", tenantId);
		return mResourceDAO.getResBrdList(map);
	}

	@Override
	public List<MResourceGetAdmSubClsTreeVO> getResFavoriteList(String userId,
			int tenantId) {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_PUSERID", userId);
		map.put("tenantID", tenantId);
		return mResourceDAO.getResFavoriteList(map);
	}

	@Override
	public void addResSch(String ownerId, String companyId, int tenantId,
			String pNum, String writerId, String deptNm, String ownerNm,
			String title, String location, String timeDisplay,
			String startDate, String endDate, String allDay, String alterTime,
			String content, String importance, String writeDay,
			String entryList, String attachFlag, String approveFlag,
			String scheduleId) {
		
		LOGGER.debug("in addResSch!!! ");
		
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
		map.put("v_PREFLAG", "0");
		map.put("v_PGRESFLAG", "");
		map.put("v_PCHARACTERID", 0);
		//map.put("v_PNUM", "26");
		LOGGER.debug("map: " + map);
		mResourceDAO.addResSch(map);
	}

	@Override
	public void modifyResSch(String title, String location, String timeDisplay,
			String startDate, String endDate, String alterTime, String content,
			String importance, String reFlag, String gresFlag, String allDay,
			String writeDay, String entryList, String attachFlag,
			String characterId, String companyId, String num, String ownerId,
			int tenantId) {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_OWNERID", ownerId);
		map.put("v_COMPANYID", companyId);
		map.put("tenantID", tenantId);
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
		map.put("v_PREFLAG", reFlag);
		map.put("v_PGRESFLAG", gresFlag);
		map.put("v_PNUM", num);
		mResourceDAO.modifyResSch(map);
	}

	@Override
	public void delResSch(String companyId, String ownerId, String num,
			int tenantId) {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_PCOMPANYID", companyId);
		map.put("v_POWNERID", ownerId);
		map.put("v_PNUM", num);
		map.put("tenantID", tenantId);
		mResourceDAO.delResSch(map);
	}

	@Override
	public void addResFavor(String resId, String userId, int tenantId) {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_PRESID", resId);
		map.put("v_PUSERID", userId);
		map.put("tenantID", tenantId);
		mResourceDAO.addResFavor(map);
	}

	@Override
	public void delResFavor(String resId, String userId, int tenantId) {
		Map<String,Object> map = new HashMap<String, Object>();
		
		LOGGER.debug("resId: " + resId);
		LOGGER.debug("userId: " + userId);
		LOGGER.debug("tenantId: " + tenantId);
		
		map.put("v_PRESID", resId);
		map.put("v_PUSERID", userId);
		map.put("tenantID", tenantId);
		mResourceDAO.delResFavor(map);
	}
	
	@Override
	public Map<String, Object> getScheduleList(String ownerID, String companyID, String groupID, String gubun, String sDate, String eDate, String pType, String pWriterName, String pWriterDept, int tenantID, String offset) throws Exception {
		LOGGER.debug("getScheduleList Start");

		Map<String, Object> result = new HashMap<>();
		String startDateLimit = eDate + " 23:59:59";
		String endDateLimit = sDate + " 00:00:01";

		// 스케줄 정보 가져옴(tbl_schedule에서 반복예약이 아닌 것만 가져옴)
/*		if (pType.equals("")) {
			List<ResGetScheduleVO> getScheduleList = getScheduleList(ownerID, companyID, startDateLimit, endDateLimit, pWriterName, pWriterDept, offset, tenantID);
			LOGGER.debug("getScheduleListSize=" + getScheduleList.size());
			

		} else if (pType.equals("MAIN")) {
			List<ResGetScheduleVO> getScheduleListMain = getScheduleListMain(ownerID, companyID, startDateLimit, endDateLimit, offset, tenantID);
			LOGGER.debug("getScheduleListMainSize=" + getScheduleListMain.size());

		}*/

		List<ResGetScheduleVO> getScheduleList = getScheduleList(ownerID, companyID, startDateLimit, endDateLimit, pWriterName, pWriterDept, offset, tenantID);
		
		LOGGER.debug("getScheduleList: " + getScheduleList);
		
		List<ResGetScheduleVO> getRepeatResult= new ArrayList<ResGetScheduleVO>();
			
		// 스케줄 정보 가져옴(tbl_schedule에서 반복예약인 것만 가져옴)
/*		if (pType.equals("")) {
			List<ResGetScheduleVO> getScheduleListRept = getScheduleListRepetiti(ownerID, companyID, startDateLimit, endDateLimit, pWriterName, pWriterDept, offset, tenantID);
			
			if(getScheduleListRept.size() > 0){
				getRepeatResult.addAll(getScheduleListRept);
			}
			
			for(int j=0; j<getScheduleListRept.size(); j++) {
				
			}
		} else {
			List<ResGetScheduleVO> getScheduleListReptMain = getScheduleListRepetitim(ownerID, companyID, startDateLimit, tenantID, offset);
			
			if(getScheduleListReptMain.size() > 0){
				getRepeatResult.addAll(getScheduleListReptMain);
			}
			
			for(int j=0; j<getScheduleListReptMain.size(); j++) {
				
			}
		}
		*/
		
		List<ResGetScheduleVO> getScheduleListRept = getScheduleListRepetiti(ownerID, companyID, startDateLimit, endDateLimit, pWriterName, pWriterDept, offset, tenantID);
		
		LOGGER.debug("getScheduleListRept: " + getScheduleListRept);
		
		getRepeatResult.addAll(getScheduleListRept);
		
		// return할 xml string 생성(반복예약)
		if (getRepeatResult.size() > 0 ) {
			
			SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			for (int i=0; i<getRepeatResult.size(); i++) {
				String reCompanyID = getRepeatResult.get(i).getCompanyID();
				String reNum = Integer.toString(getRepeatResult.get(i).getNum());
				String reOwnerID = getRepeatResult.get(i).getOwnerID();
				
				// tbl_schedulerepetition에서 정보 가져옴
				ResGetScheduleRepetitionVO vo = getRepDateTimes(reOwnerID, reCompanyID, Integer.parseInt(reNum), tenantID);
				
				if (vo != null) {
					
					vo.setStartDateTime(commonUtil.getDateStringInUTC(vo.getStartDateTime(), offset, false));
					vo.setEndDateTime(commonUtil.getDateStringInUTC(vo.getEndDateTime(), offset, false));
					
					// ResGetScheduleRepetitionVO -> ResScheduleRepetitionVO
					ResScheduleRepetitionVO rvo = resStruct(vo);
					
					// 반복예약의 반복되는 날짜리스트 뽑아옴
					List<Date[]> returnRepDateTimes = getRepDateTimes(rvo, sDate, eDate, offset);
					
					// 반복예약 중에 삭제된 예약 가져옴
					List<String> deletedDateStrList = getDeletedRepScheduleDate(Integer.parseInt(reNum), reCompanyID, reOwnerID, tenantID);
					LOGGER.debug("deletedDateStrList.size=" + deletedDateStrList.size());
					
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
						temp.setOwnerID(getRepeatResult.get(i).getOwnerID());
						temp.setTitle(getRepeatResult.get(i).getTitle());
						temp.setLocation(getRepeatResult.get(i).getLocation());
						temp.setTimeDisplay(getRepeatResult.get(i).getTimeDisplay());
						temp.setStartDate(format.format(dateArr[0]));
						temp.setEndDate(format.format(dateArr[1]));
						temp.setAlertTime(getRepeatResult.get(i).getAlertTime());
						temp.setReFlag(getRepeatResult.get(i).getReFlag());
						temp.setGresFlag(getRepeatResult.get(i).getGresFlag());
						temp.setWriterID(getRepeatResult.get(i).getWriterID());
						temp.setImportance(getRepeatResult.get(i).getImportance());
						temp.setEntryList(getRepeatResult.get(i).getEntryList());
						temp.setAllDay(getRepeatResult.get(i).getAllDay());
						temp.setWriteDay(getRepeatResult.get(i).getWriteDay());
						temp.setAttachFlag(getRepeatResult.get(i).getAttachFlag());
						temp.setCharacterID(getRepeatResult.get(i).getCharacterID());
						temp.setApproveFlag(getRepeatResult.get(i).getApproveFlag());
						temp.setOwnerNm(getRepeatResult.get(i).getOwnerNm());
						temp.setDeptNm(getRepeatResult.get(i).getDeptNm());
						
						getScheduleList.add(temp);
					}
					
				}
				
			}
		}
		
		LOGGER.debug("getScheduleList: " + getScheduleList);
		
		result.put("getScheduleList", getScheduleList);
		result.put("count", getScheduleList.size());
		
		LOGGER.debug("getScheduleList End");
		return result;
	}
	
	public List<Date[]> getRepDateTimes(ResScheduleRepetitionVO vo, String sDate, String eDate, String offset) throws Exception {
		LOGGER.debug("getRepDeteTimes started");
		
		int maxTemp = 100;
		
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
		
		LOGGER.debug("returnList.size()=" + returnList.size());
		LOGGER.debug("getRepDeteTimes ended");
		
		return returnList;
	}
	
	public List<Date[]> getDailyRepDateTimes(ResScheduleRepetitionVO vo, String sDate, String eDate, int maxTemp) throws Exception {
		int selType = vo.getSelType();
		int interval = vo.getInterval();
		int endRecurType = vo.getEndRecurType();
		int instances = vo.getInstances();
		int tempYoil = 0;
		
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
		
		LOGGER.debug("sDate=" + sDate);
		LOGGER.debug("eDate=" + eDate);
		LOGGER.debug("selType=" + selType);
		LOGGER.debug("interval=" + interval);
		LOGGER.debug("endRecurType=" + endRecurType);
		LOGGER.debug("instances=" + instances);
		LOGGER.debug("startDate=" + sdf.format(startDate));
		LOGGER.debug("endDate=" + sdf.format(endDate));
		LOGGER.debug("resStartDate=" + sdf.format(resStartDate));
		LOGGER.debug("resEndDate=" + sdf.format(resEndDate));
		LOGGER.debug("tmpStartDate=" + sdf.format(tmpStartDate));
		LOGGER.debug("tmpEndDate=" + sdf.format(tmpEndDate));
		
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
				LOGGER.debug("Repeat time over 1000.");
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
		
		LOGGER.debug("sDate=" + sDate);
		LOGGER.debug("eDate=" + eDate);
		LOGGER.debug("interval=" + interval);
		LOGGER.debug("endRecurType=" + endRecurType);
		LOGGER.debug("instances=" + instances);
		LOGGER.debug("startDate=" + sdf.format(startDate));
		LOGGER.debug("endDate=" + sdf.format(endDate));
		LOGGER.debug("resStartDate=" + sdf.format(resStartDate));
		LOGGER.debug("resEndDate=" + sdf.format(resEndDate));
		LOGGER.debug("tmpStartDate=" + sdf.format(tmpStartDate));
		LOGGER.debug("tmpEndDate=" + sdf.format(tmpEndDate));
		
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
				LOGGER.debug("Repeat time over 1000.");
				break;
			}
			
		}
		
		return returnList;
	}
	
	public List<Date[]> getMonthlyRepDateTimes(ResScheduleRepetitionVO vo, String sDate, String eDate, int maxTemp) throws Exception {
		LOGGER.debug("getMonthlyRepDateTimes started.");
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
		
		LOGGER.debug("sDate=" + sDate);
		LOGGER.debug("eDate=" + eDate);
		LOGGER.debug("interval=" + interval);
		LOGGER.debug("endRecurType=" + endRecurType);
		LOGGER.debug("instances=" + instances);
		LOGGER.debug("startDate=" + sdf.format(startDate));
		LOGGER.debug("endDate=" + sdf.format(endDate));
		LOGGER.debug("resStartDate=" + sdf.format(resStartDate));
		LOGGER.debug("resEndDate=" + sdf.format(resEndDate));
		LOGGER.debug("tmpStartDate=" + sdf.format(tmpStartDate));
		LOGGER.debug("tmpEndDate=" + sdf.format(tmpEndDate));
		
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
				LOGGER.debug("Repeat time over 1000.");
				break;
			}
			
		}
		
		LOGGER.debug("getMonthlyRepDateTimes End");
		return returnList;
	}
	
	public List<ResGetScheduleVO> getScheduleList(String ownerID, String companyID, String startDate, String endDate, String writerName, String writerDept, String offset, int tenantID) throws Exception {
		startDate = commonUtil.getDateStringInUTC(startDate, offset, true);
		endDate = commonUtil.getDateStringInUTC(endDate, offset, true);
		
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_POWNERID", ownerID);
		map.put("v_PCOMPANYID", companyID);
		map.put("v_PSTARTDATE", startDate);
		map.put("v_PENDDATE", endDate);
		map.put("v_WRITERNAME", writerName);
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

	public List<ResGetScheduleVO> getScheduleListRepetiti(String ownerID, String companyID, String startDate, String endDate, String writerName, String writerDept, String offset, int tenantID) throws Exception {
		startDate = commonUtil.getDateStringInUTC(startDate, offset, true);
		endDate = commonUtil.getDateStringInUTC(endDate, offset, true);
		
		Map<String,Object> map = new HashMap<String, Object>();
		
		map.put("v_POWNERID", ownerID);
		map.put("v_PCOMPANYID", companyID);
		map.put("v_PSTARTDATE", startDate);
		map.put("v_PENDDATE", endDate);
		map.put("v_WRITERNAME", writerName);
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
		LOGGER.debug("resStruct started");

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
		
		LOGGER.debug("resStruct ended");
		return result;
	}
	
	public ResScheduleRepetitionVO resStruct(ResGetScheduleRepetitionVO vo) throws Exception {
		LOGGER.debug("resStruct started");

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
		
		LOGGER.debug("resStruct ended");
		return result;
	}
	
}

