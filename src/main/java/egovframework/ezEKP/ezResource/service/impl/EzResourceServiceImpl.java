package egovframework.ezEKP.ezResource.service.impl;


import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.annotation.Resource;
import javax.xml.parsers.DocumentBuilderFactory;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.CookieValue;
import org.w3c.dom.Document;
import org.w3c.dom.NodeList;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezResource.dao.EzResourceDAO;
import egovframework.ezEKP.ezResource.service.EzResourceService;
import egovframework.ezEKP.ezResource.vo.ResAdminVO;
import egovframework.ezEKP.ezResource.vo.ResBrdListVO;
import egovframework.ezEKP.ezResource.vo.ResBrdVO;
import egovframework.ezEKP.ezResource.vo.ResDateVO;
import egovframework.ezEKP.ezResource.vo.ResGetAdmSubClsTreeVO;
import egovframework.ezEKP.ezResource.vo.ResGetAdminFlagVO;
import egovframework.ezEKP.ezResource.vo.ResGetItemListVO;
import egovframework.ezEKP.ezResource.vo.ResGetScheduleRepetitionVO;
import egovframework.ezEKP.ezResource.vo.ResGetScheduleVO;
import egovframework.ezEKP.ezResource.vo.ResGetSendMailToUserVO;
import egovframework.ezEKP.ezResource.vo.ResMakeDupResultVO;
import egovframework.ezEKP.ezResource.vo.ResScheduleRepetitionVO;
import egovframework.ezEKP.ezResource.vo.ResSelectFormIDVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.fcc.service.EgovDateUtil;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service("EzResourceService")
public class EzResourceServiceImpl extends EgovAbstractServiceImpl implements EzResourceService{
	
	private static final Logger logger = LoggerFactory.getLogger(EzResourceServiceImpl.class);
	
	@Resource(name="EzResourceDAO")
	private EzResourceDAO ezResourceDAO;
	
	@Resource(name="EzCommonService")
	private EzCommonService ezCommonService;
	
	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;
	
	@Autowired
	private CommonUtil commonUtil;

	@Override
	public List<ResGetAdmSubClsTreeVO> getAdmSubClsTree(String parentID,String companyID, String treeType, int tenantID) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_P_ParentID", parentID);
		map.put("v_P_CompanyID", companyID);
		map.put("v_P_TreeType", treeType);
		map.put("tenantID", tenantID);
		return ezResourceDAO.getAdmSubClsTree(map);
	}

	@Override
	public List<ResGetAdmSubClsTreeVO> getSubClsTree(String parentID, String companyID, String treeType, String pUserID, String comID, String deptID, String userID, int tenantID) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_P_ParentID", parentID);
		map.put("v_P_CompanyID", companyID);
		map.put("v_P_TreeType", treeType);
		map.put("v_P_USERID", pUserID);
		map.put("v_PCOMID", comID);
		map.put("v_PDEPTID", deptID);
		map.put("v_PUSERID", userID);
		map.put("tenantID", tenantID);
		return ezResourceDAO.getSubClsTree(map);
	}
	
	@Override
	public ResGetAdminFlagVO getAdmFlag(String companyID, String resID,String memberID, int tenantID) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("resID", resID);
		map.put("memberID", memberID);
		map.put("tenantID", tenantID);
		return ezResourceDAO.getAdmFlag(map);
	}

	@Override
	public List<ResGetItemListVO> getBrdMainList(String brdID,String companyID, String lang, int tenantID) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_BRD_ID", brdID);
		map.put("v_COMPANY", companyID);
		map.put("v_LANG", lang);
		map.put("tenantID", tenantID);
		return ezResourceDAO.getBrdMainList(map);
	}
	
	public List<ResDateVO> getScheduleDateList(String ownerID, String companyID, String startDate, String endDate, String offset, int tenantID) throws Exception {
		startDate = commonUtil.getDateStringInUTC(startDate, offset, true);
		endDate = commonUtil.getDateStringInUTC(endDate, offset, true);
		
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_POWNERID", ownerID);
		map.put("v_PCOMPANYID", companyID);
		map.put("v_PSTARTDATE", startDate);
		map.put("v_PENDDATE", endDate);
		map.put("tenantID", tenantID);
		return ezResourceDAO.getScheduleDateList(map);
	}
	
	@Override
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
		return ezResourceDAO.getScheduleList(map);
	}

	@Override
	public List<ResGetScheduleVO> getScheduleListMain(String ownerID, String companyID, String startDate, String endDate, String offset, int tenantID) throws Exception {
		startDate = commonUtil.getDateStringInUTC(startDate, offset, true);
		endDate = commonUtil.getDateStringInUTC(endDate, offset, true);
		
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_pOwnerID", ownerID);
		map.put("v_pCompanyID", companyID);
		map.put("v_pStartDate", startDate);
		map.put("v_pEndDate", endDate);
		map.put("tenantID", tenantID);
		
		return ezResourceDAO.getScheduleListMain(map);
	}

	@Override
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
		
		return ezResourceDAO.getScheduleListRepetiti(map);
	}

	@Override
	public List<ResGetScheduleVO> getScheduleListRepetitim( String ownerID, String companyID, String startDate, int tenantID, String offset) throws Exception {
		startDate = commonUtil.getDateStringInUTC(startDate, offset, true);
		
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_POWNERID", ownerID);
		map.put("v_PCOMPANYID", companyID);
		map.put("v_PSTARTDATE", startDate);
		map.put("tenantID", tenantID);
		
		return ezResourceDAO.getScheduleListRepetitim(map);
	}

	@Override
	public List<String> getDeletedRepScheduleDate(int pNum, String companyID, String ownerID, int tenantID) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_P_pNum", pNum);
		map.put("v_P_companyID", companyID);
		map.put("v_P_ownerID", ownerID);
		map.put("tenantID", tenantID);
		return ezResourceDAO.getDeletedRepScheduleDate(map);
	}
	
	@Override
	public ResGetScheduleRepetitionVO getRepDateTimes(String ownerID, String companyID, int num, int tenantID) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_pOwnerID", ownerID);
		map.put("v_pCompanyID", companyID);
		map.put("v_pNum", num);
		map.put("tenantID", tenantID);
		return ezResourceDAO.getRepDateTimes(map);
	}

	@Override
	public List<ResBrdListVO> getBrdList(int topCnt, int brdID, String CompanyID, String ownDeptNm, String ownerNm, String ownerPosition, String brdNm, int tenantID) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_PTOPCNT", topCnt);
		map.put("v_PBRDID", brdID);
		map.put("v_PCOMPANYID", CompanyID);
		map.put("v_POWNDEPTNM", ownDeptNm);
		map.put("v_POWNERNM", ownerNm);
		map.put("v_POWNERPOSITION", ownerPosition);
		map.put("v_PBRDNM", brdNm);
		map.put("tenantID", tenantID);
		return ezResourceDAO.getBrdList(map);
	}

	@Override
	public int getBrdCnt(int brdID, String companyID, int tenantID) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_PBRDID", brdID);
		map.put("v_PCOMPANYID", companyID);
		map.put("tenantID", tenantID);
		return ezResourceDAO.getBrdCnt(map);
	}

	@Override
	public ResBrdVO getBrd(int brdID, String companyID, int tenantID) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_pBrdID", brdID);
		map.put("v_pCompanyID", companyID);
		map.put("tenantID", tenantID);
		return ezResourceDAO.getBrd(map);
	}
	
	@Override
	public void delResData(String brdID, String companyID, int tenantID) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_P_Brd_ID", brdID);
		map.put("v_P_CompanyID", companyID);
		map.put("tenantID", tenantID);
		
		ezResourceDAO.delResData(map);
		ezResourceDAO.delResData_U(map);
		ezResourceDAO.delResData1(map);
		ezResourceDAO.delResData3(map);
	}
	
	@Override
	public void modifyResData(String brdID, String deptID, String deptNm, String ownerID, String ownerNm, String ownerPos, String ownerCall, String brdNm, String resLocation,
	String brdExplain,String companyID, String approve, String brdNm2, String deptNm2, String ownerNm2, String ownerPos2, int tenantID) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_P_Brd_ID", brdID);
		map.put("v_P_ODeptID", deptID);
		map.put("v_P_ODeptNm", deptNm);
		map.put("v_P_OwnerID", ownerID);
		map.put("v_P_OwnerNm", ownerNm);
		map.put("v_P_OwnerPos", ownerPos);
		map.put("v_P_OwnerCall", ownerCall);
		map.put("v_P_Brd_NM", brdNm);
		map.put("v_P_ResLocation", resLocation);
		map.put("v_P_Brd_Explain", brdExplain);
		map.put("v_P_CompanyID", companyID);
		map.put("v_P_Approve", approve);
		map.put("v_P_Brd_NM2", brdNm2);
		map.put("v_P_ODeptNm2", deptNm2);
		map.put("v_P_OwnerNm2", ownerNm2);
		map.put("v_P_OwnerPos2", ownerPos2);
		map.put("tenantID", tenantID);
		ezResourceDAO.modifyResData(map);
	}
	
	@Override
	public void addResData(String classGB, String deptID, String deptNm, String ownerID, String ownerNm, String ownerPos, String ownerCall, String brdNm, String resLocation,
	String brdExplain, String companyID, String approve, String brdNm2, String deptNm2, String ownerNm2, String ownerPos2,String strBreAccess, int tenantID) throws Exception {
		logger.debug("addResData Start");
		
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("tenantID", tenantID);
		
		int brdID = ezResourceDAO.addResData_S1(map);
		
		map.put("v_P_ClassGB", classGB);
		map.put("v_P_ODeptID", deptID);
		map.put("v_P_ODeptNm", deptNm);
		map.put("v_P_OwnerID", ownerID);
		map.put("v_P_OwnerNm", ownerNm);
		map.put("v_P_OwnerPos", ownerPos);
		map.put("v_P_OwnerCall", ownerCall);
		map.put("v_P_Brd_NM", brdNm);
		map.put("v_P_ResLocation", resLocation);
		map.put("v_P_Brd_Explain", brdExplain);
		map.put("v_P_CompanyID", companyID);
		map.put("v_P_Approve", approve);
		map.put("v_P_Brd_NM2", brdNm2);
		map.put("v_P_ODeptNm2", deptNm2);
		map.put("v_P_OwnerNm2", ownerNm2);
		map.put("v_P_OwnerPos2", ownerPos2);
		map.put("v_Brd_GB", "2");
		map.put("v_Brd_ID", brdID);
		map.put("v_Brd_Access", strBreAccess);
		
		Map<String,Object> map2 = new HashMap<String, Object>();
		logger.debug("classGB="+classGB);
		logger.debug("companyID="+companyID);
		logger.debug("tenantID="+tenantID);
		map2.put("v_P_ClassGB", classGB);
		map2.put("v_P_CompanyID", companyID);
		map2.put("tenantID", tenantID);
		
		int v_Brd_Level = 0;
		v_Brd_Level = ezResourceDAO.addResData_S2(map2);
		
		int v_Brd_Step = ezResourceDAO.addResData_S3(map2);
		map.put("v_Brd_Level", v_Brd_Level);
		map.put("v_Brd_Step", v_Brd_Step);
		ezResourceDAO.addResData(map);
		logger.debug("addResData End");
	}
	
	@Override
	public void updateScheduleDateTime(int num, String ownerID, String companyID, String startDate, String endDate, int tenantID) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_pNum", num);
		map.put("v_pOwnerID", ownerID);
		map.put("v_pCompanyID", companyID);
		map.put("v_pStartDate", startDate);
		map.put("v_pEndDate", endDate);
		map.put("tenantID", tenantID);
		ezResourceDAO.updateScheduleDateTime(map);
	}
	
	@Override
	public ResGetScheduleVO getSchedule(int pNum, String ownerID, String companyID, int tenantID) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_pNum", pNum);
		map.put("v_pOwnerID", ownerID);
		map.put("v_pCompanyID", companyID);
		map.put("tenantID", tenantID);
		return ezResourceDAO.getSchedule(map);
	}
	
	@Override
	public void insertScheduleRepetition(int num, String ownerID, String startDateTime, String endDateTime, String reWay, String reDay, String reNum, String reYoil, String reMonth,
			String reOrd, String endFlag, String reCount, String companyID, int tenantID, String offset) throws Exception {
		logger.debug("insertScheduleRepetition started");
		
		startDateTime = commonUtil.getDateStringInUTC(startDateTime, offset, true);
		endDateTime = commonUtil.getDateStringInUTC(endDateTime, offset, true);
		
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_pNum", num);
		map.put("v_pOwnerID", ownerID);
		map.put("v_pStartDateTime", startDateTime);
		map.put("v_pEndDateTime", endDateTime);
		map.put("v_pReWay", reWay);
		map.put("v_pReDay", reDay);
		map.put("v_pReNum", reNum);
		map.put("v_pReYoil", reYoil);
		map.put("v_pReMonth", reMonth);
		map.put("v_pReOrd",  reOrd);
		map.put("v_pEndFlag", endFlag);
		map.put("v_pReCount", reCount);
		map.put("v_pCompanyID", companyID);
		map.put("tenantID", tenantID);
		
		ezResourceDAO.insertScheduleRepetition(map);

		logger.debug("insertScheduleRepetition ended");
	}
	
	@Override
	public List<ResGetScheduleVO> getScheduleInfo(int pNum, String entryID, String ownerID, String companyID, int tenantID) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_pNum", pNum);
		map.put("v_pEntryID", entryID);
		map.put("v_pOwnerID", ownerID);
		map.put("v_pCompanyID", companyID);
		map.put("tenantID", tenantID);
		return ezResourceDAO.getScheduleInfo(map);
	}
	
	@Override
	public void updateScheduleRepetition(int pNum, String ownerID, String startDateTime, String endDateTime, String reWay, String reDay, String reNum, String reYoil, String reMonth,
			String reOrd, String endFlag, String reCount, String companyID, int tenantID, String offset) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_pNum", pNum);
		map.put("v_pOwnerID", ownerID);
		map.put("v_pStartDateTime", commonUtil.getDateStringInUTC(startDateTime, offset, true));
		map.put("v_pEndDateTime", commonUtil.getDateStringInUTC(endDateTime, offset, true));
		map.put("v_pReWay", reWay);
		map.put("v_pReDay", reDay);
		map.put("v_pReNum", reNum);
		map.put("v_pReYoil", reYoil);
		map.put("v_pReMonth", reMonth);
		map.put("v_pReOrd", reOrd);
		map.put("v_pEndFlag", endFlag);
		map.put("v_pReCount", reCount);
		map.put("v_pCompanyID", companyID);
		map.put("tenantID", tenantID);
		ezResourceDAO.updateScheduleRepetition(map);
	}
	
	@Override
	public void deleteRepetition(String ownerID, int pNum, int tenantID) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_pOwnerID", ownerID);
		map.put("v_pNum", pNum);
		map.put("tenantID", tenantID);
		ezResourceDAO.deleteRepetition(map);
	}
	
	@Override
	public List<ResGetScheduleRepetitionVO> getScheduleRepetition(int pNum, String ownerID, String companyID, int tenantID) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_pNum", pNum);
		map.put("v_pOwnerID", ownerID);
		map.put("v_pCompanyID", companyID);
		map.put("tenantID", tenantID);
		return ezResourceDAO.getScheduleRepetition(map);
	}
	
	@Override
	public ResSelectFormIDVO selectFormID(String resID, int tenantID) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_pRESID", resID);
		map.put("tenantID", tenantID);
		return ezResourceDAO.selectFormID(map);
	}
	
	@Override
	public String getAclTblBrd(String companyID, String brdID, String userID, String mode, int tenantID) throws Exception {
		logger.debug("getAclTblBrd Start");
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_PCOMPANYID", companyID);
		map.put("v_PBRDID", brdID);
		map.put("v_PUSERID", userID);
		map.put("v_PMODE", mode);
		map.put("tenantID", tenantID);
		logger.debug(companyID);
		logger.debug(brdID);
		logger.debug(userID);
		logger.debug(mode);
		String ownerID = "";
		String brdUpper = "";
		String accessLvl = "";
		String result = "";
		ownerID = ezResourceDAO.getAclTblBrd_S1(map);
		logger.debug("ownerID="+ownerID);
		
		if (ownerID == null || ownerID.equals("")) {
			brdUpper = ezResourceDAO.getAclTblBrd_S2(map);
			map.put("v_BRD_UPPER", brdUpper);
			accessLvl = ezResourceDAO.getAclTblBrd_S3(map);
			logger.debug("brdUpper="+brdUpper);
			logger.debug("accessLvl="+accessLvl);
			if (accessLvl != null && accessLvl.trim().equals("1")) {
				logger.debug("111");
				result = "Y";
			} else {
				if (accessLvl != null && accessLvl.trim().equals("2")) {
					logger.debug("222");
					result = "U";
				} else {
					 if (mode.equals("everyone")) {
							map.put("v_PUSERID", "everyone");
							accessLvl = ezResourceDAO.getAclTblBrd_S3(map);
							logger.debug("333");
							if (accessLvl != null && accessLvl.trim().equals("1")) {
								logger.debug("444");	
								result = "Y";
							} else {
								if (accessLvl != null && accessLvl.trim().equals("2")) {
									logger.debug("555");
									result = "U";
								} else {
									logger.debug("666");
									result = "";
								}
							}
							
						} else {
							logger.debug("777");
							result = "";
						}
				}	
			}
			
	
			
		} else {
			result = "Y";
		}
		logger.debug("result="+result);
		logger.debug("getAclTblBrd End");
		return result;
	}
	
	@Override
	public String getBrdApproveFlag(int brdID, String companyID, int tenantID) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_PBRDID", brdID);
		map.put("v_PCOMPANYID", companyID);
		map.put("tenantID", tenantID);
		return ezResourceDAO.getBrdApproveFlag(map);
	}
	
	@Override
	public void insertForm(String resID, String brdNm, String formText, int tenantID) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_RESID", resID);
		map.put("v_BRDNM", brdNm);
		map.put("v_FORMTEXT", formText);
		map.put("tenantID", tenantID);
		
		int count = ezResourceDAO.insertForm_S(map);
		
		if (count == 0) {
			ezResourceDAO.insertForm_I(map);
		} else if (count > 0) {
			ezResourceDAO.insertForm_U(map);
		}
		
		//ezResourceDAO.insertForm(map);
	}
	
	@Override
	public void delFormID(String delCode, int tenantID) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_DELCODE", delCode);
		map.put("tenantID", tenantID);
		ezResourceDAO.delFormID(map);
	}
	
	@Override
	public void updateSchedule(int num, String ownerID, String companyID, String approve, int tenantID) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_PNUM", num);
		map.put("v_POWNERID", ownerID);
		map.put("v_PCOMPANYID", companyID);
		map.put("v_PAPPROVE", approve);
		map.put("tenantID", tenantID);
		ezResourceDAO.updateSchedule(map);
	}

	
	@Override
	public void modifyResSch(String ownerID, String num, String pNum, String companyID, String writerID, String title, String location, String timeDisplay, String startDate, String endDate,
			String allDay, String alertTime, String content, String importance, String reFlag, String gresFlag, String entryList, String characterID, String attachFlag, String typeVal,
			String approve, int tenantID, String offset) throws Exception {
		logger.debug("modifyResSch Start");
		
		startDate = commonUtil.getDateStringInUTC(startDate, offset, true);
		endDate = commonUtil.getDateStringInUTC(endDate, offset, true);
		String nowDate = commonUtil.getTodayUTCTime("yyyy-MM-dd HH:mm:ss");
		
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_P_ownerID", ownerID);
		map.put("v_P_num", num);
		map.put("v_P_pnum", pNum);
		map.put("v_P_companyID", companyID);
		map.put("v_P_writerID", writerID);
		map.put("v_P_title", title);
		map.put("v_P_location", location);
		map.put("v_P_timeDisplay", timeDisplay);
		map.put("v_P_startDate", startDate);
		map.put("v_P_endDate", endDate);
		map.put("v_P_allDay", allDay);
		map.put("v_P_alertTime", alertTime);
		map.put("v_P_content", content);
		map.put("v_P_importance", importance);
		map.put("v_P_reFlag", reFlag);
		map.put("v_P_gresFlag", gresFlag);
		map.put("v_P_entryList", entryList);
		map.put("v_P_characterID", characterID);
		map.put("v_P_attachFlag", attachFlag);
		map.put("v_P_typeVal", typeVal);
		map.put("v_P_Approve", approve);
		map.put("maxNum", "");
		map.put("tenantID", tenantID);
		map.put("nowDate", nowDate);
		
		logger.debug("typeVal=" + typeVal);
		
		if (reFlag.equals("1") && typeVal.equals("MASTER")) {
			String ownerNm = ezResourceDAO.modifyResSch_S1(map);
			String deptNm = ezResourceDAO.modifyResSch_S2(map);
			
			ezResourceDAO.modifyResSch_D1(map);
			
			map.put("v_tmpOwnerNm", ownerNm);
			map.put("v_tmpDeptNm", deptNm);
			
			ezResourceDAO.modifyResSch_I1(map);
		} else if (typeVal.equals("INSTANCE")) {
			int result = ezResourceDAO.modifyResSch_U1(map);
			
			logger.debug("result=" + result);
			
			if (result == 0) {
				ezResourceDAO.modifyResSch_I2(map);
			}
		} else {
			ezResourceDAO.modifyResSch_D2(map);
			ezResourceDAO.modifyResSch_U2(map);
		}
		logger.debug("modifyResSch End");
	}

	@Override
	public void delResSch(String ownerID, String num, String pNum, String companyID, String writerID, String sDate, String eDate, int insType, String offset, int tenantID) throws Exception {
		logger.debug("delResSch Start");
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_P_ownerID", ownerID);
		map.put("v_P_num", num);
		map.put("v_P_pnum", pNum);
		map.put("v_P_companyID", companyID);
		map.put("v_P_writerID",  writerID);
		map.put("v_P_insType", insType);
		map.put("tenantID", tenantID);
		
		String nowDate = commonUtil.getTodayUTCTime("yyyy-MM-dd HH:mm:ss");
		map.put("nowDate", nowDate);
		
		//ezResourceDAO.delResSch(map);
		logger.debug("insType="+insType);
		if (insType == 3) {
			if (ezResourceDAO.delResSch_S1(map) != null && ezResourceDAO.delResSch_S1(map).equals("1")) {
				ezResourceDAO.delResSch_U(map);
			} else {
				int maxNum = ezResourceDAO.delResSch_S2(map);
				logger.debug("maxNum="+maxNum);
				map.put("v_MaxNum", maxNum);
				
				ResGetScheduleVO vo = getSchedule(Integer.parseInt(pNum), ownerID, companyID, tenantID);
				sDate += " " + commonUtil.getDateStringInUTC(vo.getStartDate(), offset, false).substring(11);
				eDate += " " + commonUtil.getDateStringInUTC(vo.getEndDate(), offset, false).substring(11);
				
				sDate = commonUtil.getDateStringInUTC(sDate, offset, true);
				eDate = commonUtil.getDateStringInUTC(eDate, offset, true);
				
				map.put("v_P_sDate", sDate);
				map.put("v_P_eDate", eDate);
				
				ezResourceDAO.delResSch_I(map);
			}
		} else {
			logger.debug("delResSch_delete");
			logger.debug("companyID="+companyID);
			logger.debug("ownerID="+ownerID);
			logger.debug("num="+num);
			logger.debug("pNum="+pNum);
			ezResourceDAO.delResSch_D1(map);
			ezResourceDAO.delResSch_D2(map);
			ezResourceDAO.delResSch_D3(map);
		}
		logger.debug("delResSch End");
	}
	
	@Override
	public int addResSch(String ownerID, String pNum, String companyID, String writerID, String title, String location, String timeDisplay,
			String startDate, String endDate, String allDay, String alertTime, String content, String importance, String reFlag, String gresFlag,
			String entryList, String characterID, String attachFlag, String deptNm, String ownerNm, String approve, String scheduleID, int tenantID, String offset) throws Exception {
		startDate = commonUtil.getDateStringInUTC(startDate, offset, true);
		endDate = commonUtil.getDateStringInUTC(endDate, offset, true);
		String nowDate = commonUtil.getTodayUTCTime("yyyy-MM-dd HH:mm:ss");
		
		if (pNum == null || pNum.equals("")) {
			pNum = "0";
		}
		
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_P_ownerID", ownerID);
		map.put("v_P_pnum", pNum);
		map.put("v_P_companyID", companyID);
		map.put("v_P_writerID", writerID);
		map.put("v_P_title", title);
		map.put("v_P_location", location);
		map.put("v_P_timeDisplay", timeDisplay);
		map.put("v_P_startDate", startDate);
		map.put("v_P_endDate", endDate);
		map.put("v_P_allDay", allDay);
		map.put("v_P_alertTime", alertTime);
		map.put("v_P_content", content);
		map.put("v_P_importance", importance);
		map.put("v_P_reFlag", reFlag);
		map.put("v_P_gresFlag", gresFlag);
		map.put("v_P_entryList", entryList);
		map.put("v_P_characterID", characterID);
		map.put("v_P_attachFlag", attachFlag);
		map.put("v_P_deptNM", deptNm);
		map.put("v_P_ownerNM", ownerNm);
		map.put("v_P_Approve", approve);
		map.put("v_P_ScheduleID", scheduleID);
		map.put("v_Num", "");
		map.put("v_WriteDay", "");
		map.put("tenantID", tenantID);
		map.put("nowDate", nowDate);

		String approveFlag = ezResourceDAO.addRessch_S1(map);
		
		if (approveFlag.equals("1")) {
			approveFlag = "0";
		} else {
			approveFlag = "1";
		}
		
		map.put("v_P_Approve", approveFlag);
		
		ezResourceDAO.addResSch(map);
		
		return ezResourceDAO.addRessch_S2(map);
	}
	
	@Override
	public List<ResGetScheduleRepetitionVO> getRepResourceRepeat(String ownerID, int num, String cmd, String companyID, int tenantID) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_p_ownerID", ownerID);
		map.put("v_p_num", num);
		map.put("v_p_cmd", cmd);
		map.put("v_p_companyID", companyID);
		map.put("tenantID", tenantID);
		return ezResourceDAO.getRepResourceRepeat(map);
	}
	
	@Override
	public ResAdminVO getResourceAdminInfo(String brdID, int tenantID) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_BRD_ID", brdID);
		map.put("tenantID", tenantID);
		return ezResourceDAO.getResourceAdminInfo(map);
	}
	
	@Override
	public ResGetSendMailToUserVO getSendMailToUser(String resID, int num, int tenantID) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("resID", resID);
		map.put("num", num);
		map.put("tenantID", tenantID);
		return ezResourceDAO.getSendMailToUser(map);
	}

	@Override
	public String getScheduleXML(String xmlStr, String ownerID, String companyID, String groupID, String gubun, String pType, String pWriterName, String pWriterDept, int tenantID, String offset) throws Exception {
		logger.debug("getScheduleXML Start");
		
		Document xmlRes = commonUtil.convertStringToDocument(xmlStr);
		String sDate = xmlRes.getElementsByTagName("STARTDATETIME").item(0).getTextContent();
		String eDate = xmlRes.getElementsByTagName("ENDDATETIME").item(0).getTextContent();
		String app = xmlRes.getElementsByTagName("APP").item(0).getTextContent().trim();
		
		// 스케줄 정보 가져옴
		String scheRs = getScheduleList(ownerID, companyID, groupID, gubun, sDate, eDate, pType, pWriterName, pWriterDept, tenantID, offset);
		
		Document scheRSDom = commonUtil.convertStringToDocument(scheRs);
		
		//return할 xml string 생성
		StringBuilder returnStr = new StringBuilder();
		returnStr.append("<root>");
		
		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Calendar cal = Calendar.getInstance();
		
		for (int i=0; i<scheRSDom.getElementsByTagName("ROW").getLength(); i++) {
			String num = scheRSDom.getElementsByTagName("num").item(i).getTextContent();
			String pNum = scheRSDom.getElementsByTagName("pnum").item(i).getTextContent();
			String ownerIDStr = scheRSDom.getElementsByTagName("ownerID").item(i).getTextContent();
			String writerIDStr = scheRSDom.getElementsByTagName("writerID").item(i).getTextContent();
			String title = scheRSDom.getElementsByTagName("title").item(i).getTextContent();
			String loc = scheRSDom.getElementsByTagName("location").item(i).getTextContent();
			String startDateTime = scheRSDom.getElementsByTagName("startDate").item(i).getTextContent();
			String endDateTime = scheRSDom.getElementsByTagName("endDate").item(i).getTextContent();
			String reFlag = scheRSDom.getElementsByTagName("reFlag").item(i).getTextContent();
			String gresFlag = scheRSDom.getElementsByTagName("gresFlag").item(i).getTextContent();
			String allDay = scheRSDom.getElementsByTagName("allDay").item(i).getTextContent();
			String writeDay = commonUtil.getDateStringInUTC(scheRSDom.getElementsByTagName("writeDay").item(i).getTextContent(), offset, false);
			String jobTitle = "";
			String jobTitle2 = "";
				
			if (pType.equals("") || pType == null) {
				 jobTitle = scheRSDom.getElementsByTagName("jobtitle").item(i).getTextContent();
				 jobTitle2 = scheRSDom.getElementsByTagName("jobtitle2").item(i).getTextContent();
			}
			if (app.equals("0")) {
				returnStr.append("<appointment>");
					
				returnStr.append("<dtstart>" + startDateTime + "</dtstart>");
				returnStr.append("<dtend>" + endDateTime + "</dtend>");
				returnStr.append("<alldayevent>" + allDay + "</alldayevent>");
					
				String timeDisplay = scheRSDom.getElementsByTagName("timeDisplay").item(i).getTextContent(); 
				if (timeDisplay.equals("1")) {
					timeDisplay = "Busy";
				} else if (timeDisplay.equals("2")) {
					timeDisplay = "Tentative";
				} else if (timeDisplay.equals("3")) {
					timeDisplay = "OOF";
				} else if (timeDisplay.equals("4")) {
					timeDisplay = "Free";
				} else {
					timeDisplay = "";
				}
				returnStr.append("<busystatus>"+timeDisplay+"</busystatus>");
				returnStr.append("</appointment>");
			} else {
				returnStr.append("<appointment>");
				returnStr.append("<number>" + num + "</number>");
					
				if (pNum.equals("Null") || pNum.equals("NULL")) {
					pNum = "";
				}
				returnStr.append("<pnumber>" + pNum + "</pnumber>");
				returnStr.append("<owner_id>" + ownerIDStr + "</owner_id>");
					
				if (writerIDStr.equals("Null") || writerIDStr.equals("NULL")) {
					writerIDStr = "";
				}
				returnStr.append("<writer_id>" + writerIDStr + "</writer_id>");
					
				if (title.equals("Null") || title.equals("NULL")) {
					title = "";
				}
				returnStr.append("<subject><![CDATA[" + title + "]]></subject>");
				returnStr.append("<instancetype>" + reFlag + "</instancetype>");
					
				if (loc.equals("Null") || loc.equals("NULL")) {
					loc = "";
				}
				returnStr.append("<location><![CDATA[" + loc + "]]></location>");
				returnStr.append("<dtstart>" + startDateTime + "</dtstart>");
				returnStr.append("<dtend>" + endDateTime + "</dtend>");
				
				cal.setTime(format.parse(startDateTime));
				returnStr.append("<dstartTime>" + (cal.get(Calendar.HOUR_OF_DAY) * 60 + cal.get(Calendar.MINUTE)) + "</dstartTime>");
				returnStr.append("<dsDaytype>" + (cal.get(Calendar.DAY_OF_WEEK) - 1) + "</dsDaytype>");
				
				cal.setTime(format.parse(endDateTime));
				returnStr.append("<dendTime>" + (cal.get(Calendar.HOUR_OF_DAY) * 60 + cal.get(Calendar.MINUTE)) + "</dendTime>");
				returnStr.append("<deDaytype>" + (cal.get(Calendar.DAY_OF_WEEK) - 1) + "</deDaytype>");
				returnStr.append("<alldayevent>"+ allDay +"</alldayevent>");
				
				String timeDisplay = scheRSDom.getElementsByTagName("timeDisplay").item(i).getTextContent();
					
				if (timeDisplay.equals("1")) {
					timeDisplay = "Busy";
				} else if (timeDisplay.equals("2")) {
					timeDisplay = "Tentative";
				} else if (timeDisplay.equals("3")) {
					timeDisplay = "OOF";
				} else if (timeDisplay.equals("4")) {
					timeDisplay = "Free";
				} else {
					timeDisplay = "";
				}
				returnStr.append("<busystatus>"+ timeDisplay +"</busystatus>");
				if (gresFlag.equals("Null") || gresFlag.equals("NULL")) {
					gresFlag = "";
				}
				returnStr.append("<groupflag>"+ gresFlag +"</groupflag>");
				returnStr.append("<gubunFlag>"+ gubun +"</gubunFlag>");
				returnStr.append("<importance>"+ scheRSDom.getElementsByTagName("importance").item(i).getTextContent() +"</importance>");
				returnStr.append("<approveFlag>"+ scheRSDom.getElementsByTagName("approveFlag").item(i).getTextContent() +"</approveFlag>");
				returnStr.append("<owner_nm><![CDATA[" + scheRSDom.getElementsByTagName("owner_nm").item(i).getTextContent() + "]]></owner_nm>");
				returnStr.append("<dept_name><![CDATA[" + scheRSDom.getElementsByTagName("dept_name").item(i).getTextContent() + "]]></dept_name>");
				returnStr.append("<writeDay>"+ writeDay +"</writeDay>");
					
				if (pType.equals("") || pType == null) {
					returnStr.append("<owner_nm2><![CDATA[" + scheRSDom.getElementsByTagName("owner_nm2").item(i).getTextContent() + "]]></owner_nm2>");
					returnStr.append("<dept_name2><![CDATA[" + scheRSDom.getElementsByTagName("dept_name2").item(i).getTextContent() + "]]></dept_name2>");
					returnStr.append("<jobtitle><![CDATA[" +jobTitle + "]]></jobtitle>");
					returnStr.append("<jobtitle2><![CDATA[" + jobTitle2 + "]]></jobtitle2>");
				}
				returnStr.append("</appointment>");
			}
		}
		returnStr.append("</root>");
		
		logger.debug("getScheduleXML End");
		return returnStr.toString();
	}
	
	public String getScheduleList(String ownerID, String companyID, String groupID, String gubun, String sDate, String eDate, String pType, String pWriterName, String pWriterDept, int tenantID, String offset) throws Exception {
		logger.debug("getScheduleList Start");

		String startDateLimit = eDate + " 23:59:59";
		String endDateLimit = sDate + " 00:00:01";

		// 스케줄 정보 가져옴(tbl_schedule에서 반복예약이 아닌 것만 가져옴)
		String returnSchedule = "<DATA>";
		if (pType.equals("")) {
			List<ResGetScheduleVO> getScheduleList = getScheduleList(ownerID, companyID, startDateLimit, endDateLimit, pWriterName, pWriterDept, offset, tenantID);
			logger.debug("getScheduleListSize=" + getScheduleList.size());
			
			for (ResGetScheduleVO vo :  getScheduleList) {
				returnSchedule += commonUtil.getQueryResult(vo);
			}
		} else if (pType.equals("MAIN")) {
			List<ResGetScheduleVO> getScheduleListMain = getScheduleListMain(ownerID, companyID, startDateLimit, endDateLimit, offset, tenantID);
			logger.debug("getScheduleListMainSize=" + getScheduleListMain.size());
			
			for (ResGetScheduleVO vo :  getScheduleListMain) {
				returnSchedule += commonUtil.getQueryResult(vo);
			}
		}
		returnSchedule += "</DATA>";
		
		Document returnDom1 = commonUtil.convertStringToDocument(returnSchedule);
		
		// return할 xml string 생성(반복예약 제외)
		StringBuilder returnStr = new StringBuilder();
		returnStr.append("<DATA>");
		
		if (returnDom1 != null) {
			for (int m=0; m<returnDom1.getElementsByTagName("ROW").getLength(); m++) {
				returnStr.append("<ROW>");
				returnStr.append("<num>" + returnDom1.getElementsByTagName("NUM").item(m).getTextContent() + "</num>");
				returnStr.append("<pnum>" + returnDom1.getElementsByTagName("PNUM").item(m).getTextContent() + "</pnum>");
				returnStr.append("<ownerID>" + returnDom1.getElementsByTagName("OWNERID").item(m).getTextContent() + "</ownerID>");
				returnStr.append("<title><![CDATA[" + returnDom1.getElementsByTagName("TITLE").item(m).getTextContent() + "]]></title>");
				returnStr.append("<location><![CDATA[" + returnDom1.getElementsByTagName("LOCATION").item(m).getTextContent() + "]]></location>");
				returnStr.append("<timeDisplay><![CDATA[" + returnDom1.getElementsByTagName("TIMEDISPLAY").item(m).getTextContent() + "]]></timeDisplay>");
				returnStr.append("<startDate>" + commonUtil.getDateStringInUTC(returnDom1.getElementsByTagName("STARTDATE").item(m).getTextContent(), offset, false) + "</startDate>");
				returnStr.append("<endDate>" + commonUtil.getDateStringInUTC(returnDom1.getElementsByTagName("ENDDATE").item(m).getTextContent(), offset, false) + "</endDate>");
				returnStr.append("<alertTime>" + returnDom1.getElementsByTagName("ALERTTIME").item(m).getTextContent() + "</alertTime>");
				returnStr.append("<reFlag>" + returnDom1.getElementsByTagName("REFLAG").item(m).getTextContent() + "</reFlag>");
				returnStr.append("<gresFlag>" + returnDom1.getElementsByTagName("GRESFLAG").item(m).getTextContent() + "</gresFlag>");
				returnStr.append("<writerID>" + returnDom1.getElementsByTagName("WRITERID").item(m).getTextContent() + "</writerID>");
				returnStr.append("<importance>" + returnDom1.getElementsByTagName("IMPORTANCE").item(m).getTextContent() + "</importance>");
				returnStr.append("<entryList>" + returnDom1.getElementsByTagName("ENTRYLIST").item(m).getTextContent() + "</entryList>");
				returnStr.append("<allDay>" + returnDom1.getElementsByTagName("ALLDAY").item(m).getTextContent() + "</allDay>");
				returnStr.append("<writeDay>" + commonUtil.getDateStringInUTC(returnDom1.getElementsByTagName("WRITEDAY").item(m).getTextContent(), offset, false) + "</writeDay>");
				returnStr.append("<attachFlag>" + returnDom1.getElementsByTagName("ATTACHFLAG").item(m).getTextContent() + "</attachFlag>");
				returnStr.append("<characterID>" + returnDom1.getElementsByTagName("CHARACTERID").item(m).getTextContent() + "</characterID>");
				returnStr.append("<approveFlag>" + returnDom1.getElementsByTagName("APPROVEFLAG").item(m).getTextContent() + "</approveFlag>");
				returnStr.append("<owner_nm><![CDATA[" + returnDom1.getElementsByTagName("OWNERNM").item(m).getTextContent() + "]]></owner_nm>");
				returnStr.append("<dept_name><![CDATA[" + returnDom1.getElementsByTagName("DEPTNM").item(m).getTextContent() + "]]></dept_name>");
				
				if (pType.equals("")) {
					returnStr.append("<owner_nm2><![CDATA[" + returnDom1.getElementsByTagName("OWNERNM2").item(m).getTextContent() + "]]></owner_nm2>");
					returnStr.append("<dept_name2><![CDATA[" + returnDom1.getElementsByTagName("DEPTNM2").item(m).getTextContent() + "]]></dept_name2>");
					returnStr.append("<jobtitle><![CDATA[" + returnDom1.getElementsByTagName("JOBTITLE").item(m).getTextContent() + "]]></jobtitle>");
					returnStr.append("<jobtitle2><![CDATA[" + returnDom1.getElementsByTagName("JOBTITLE2").item(m).getTextContent() + "]]></jobtitle2>");
				}
				
				returnStr.append("</ROW>");
			}
		}
			
		// 스케줄 정보 가져옴(tbl_schedule에서 반복예약인 것만 가져옴)
		String returnRepetition = "<DATA>";
		if (pType.equals("")) {
			List<ResGetScheduleVO> getScheduleListRept = getScheduleListRepetiti(ownerID, companyID, startDateLimit, endDateLimit, pWriterName, pWriterDept, offset, tenantID);
			
			for(int j=0; j<getScheduleListRept.size(); j++) {
				returnRepetition += commonUtil.getQueryResult(getScheduleListRept.get(j));
			}
		} else {
			List<ResGetScheduleVO> getScheduleListReptMain = getScheduleListRepetitim(ownerID, companyID, startDateLimit, tenantID, offset);

			for(int j=0; j<getScheduleListReptMain.size(); j++) {
				returnRepetition += commonUtil.getQueryResult(getScheduleListReptMain.get(j));
			}
		}
		returnRepetition += "</DATA>";
		
		Document returnRepetitionDom = commonUtil.convertStringToDocument(returnRepetition);
		
		// return할 xml string 생성(반복예약)
		if (returnRepetitionDom != null) {
			
			SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			for (int i=0; i<returnRepetitionDom.getElementsByTagName("ROW").getLength(); i++) {
				String reCompanyID = returnRepetitionDom.getElementsByTagName("COMPANYID").item(i).getTextContent();
				String reNum = returnRepetitionDom.getElementsByTagName("NUM").item(i).getTextContent();
				String reOwnerID = returnRepetitionDom.getElementsByTagName("OWNERID").item(i).getTextContent();
				
				// tbl_schedulerepetition에서 정보 가져옴
				ResGetScheduleRepetitionVO vo = getRepDateTimes(reOwnerID, reCompanyID, Integer.parseInt(reNum), tenantID);
				vo.setStartDateTime(commonUtil.getDateStringInUTC(vo.getStartDateTime(), offset, false));
				vo.setEndDateTime(commonUtil.getDateStringInUTC(vo.getEndDateTime(), offset, false));
				
				// ResGetScheduleRepetitionVO -> ResScheduleRepetitionVO
				ResScheduleRepetitionVO rvo = resStruct(vo);
				
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
					
					returnStr.append("<ROW>");
					returnStr.append("<num>" + returnRepetitionDom.getElementsByTagName("NUM").item(i).getTextContent() + "</num>");
					returnStr.append("<pnum>" + returnRepetitionDom.getElementsByTagName("PNUM").item(i).getTextContent() + "</pnum>");
					returnStr.append("<ownerID>" + returnRepetitionDom.getElementsByTagName("OWNERID").item(i).getTextContent() + "</ownerID>");
					returnStr.append("<title><![CDATA[" + returnRepetitionDom.getElementsByTagName("TITLE").item(i).getTextContent() + "]]></title>");
					returnStr.append("<location><![CDATA[" + returnRepetitionDom.getElementsByTagName("LOCATION").item(i).getTextContent() + "]]></location>");
					returnStr.append("<timeDisplay><![CDATA[" + returnRepetitionDom.getElementsByTagName("TIMEDISPLAY").item(i).getTextContent() + "]]></timeDisplay>");
					returnStr.append("<startDate>" + format.format(dateArr[0]) + "</startDate>");
					returnStr.append("<endDate>" + format.format(dateArr[1]) + "</endDate>");
					returnStr.append("<alertTime>" + returnRepetitionDom.getElementsByTagName("ALERTTIME").item(i).getTextContent() + "</alertTime>");
					returnStr.append("<reFlag>" + returnRepetitionDom.getElementsByTagName("REFLAG").item(i).getTextContent() + "</reFlag>");
					returnStr.append("<gresFlag>" + returnRepetitionDom.getElementsByTagName("GRESFLAG").item(i).getTextContent() + "</gresFlag>");
					returnStr.append("<writerID>" + returnRepetitionDom.getElementsByTagName("WRITERID").item(i).getTextContent() + "</writerID>");
					returnStr.append("<importance>" + returnRepetitionDom.getElementsByTagName("IMPORTANCE").item(i).getTextContent() + "</importance>");
					returnStr.append("<entryList>" + returnRepetitionDom.getElementsByTagName("ENTRYLIST").item(i).getTextContent() + "</entryList>");
					returnStr.append("<allDay>" + returnRepetitionDom.getElementsByTagName("ALLDAY").item(i).getTextContent() + "</allDay>");
					returnStr.append("<writeDay>" + commonUtil.getDateStringInUTC(returnRepetitionDom.getElementsByTagName("WRITEDAY").item(i).getTextContent(), offset, false) + "</writeDay>");
					returnStr.append("<attachFlag>" + returnRepetitionDom.getElementsByTagName("ATTACHFLAG").item(i).getTextContent() + "</attachFlag>");
					returnStr.append("<characterID>" + returnRepetitionDom.getElementsByTagName("CHARACTERID").item(i).getTextContent() + "</characterID>");
					returnStr.append("<approveFlag>" + returnRepetitionDom.getElementsByTagName("APPROVEFLAG").item(i).getTextContent() + "</approveFlag>");
					returnStr.append("<owner_nm><![CDATA[" + returnRepetitionDom.getElementsByTagName("OWNERNM").item(i).getTextContent() + "]]></owner_nm>");
					returnStr.append("<dept_name><![CDATA[" + returnRepetitionDom.getElementsByTagName("DEPTNM").item(i).getTextContent() + "]]></dept_name>");
					
					if (pType == null || pType.equals("")) {
						returnStr.append("<owner_nm2><![CDATA[" + returnRepetitionDom.getElementsByTagName("OWNERNM2").item(i).getTextContent() + "]]></owner_nm2>");
						returnStr.append("<dept_name2><![CDATA[" + returnRepetitionDom.getElementsByTagName("DEPTNM2").item(i).getTextContent() + "]]></dept_name2>");
						returnStr.append("<jobtitle><![CDATA[" + returnRepetitionDom.getElementsByTagName("JOBTITLE").item(i).getTextContent() + "]]></jobtitle>");
						returnStr.append("<jobtitle2><![CDATA[" + returnRepetitionDom.getElementsByTagName("JOBTITLE2").item(i).getTextContent() + "]]></jobtitle2>");
					}
					
					returnStr.append("</ROW>");
					
				}
			}
		}
		returnStr.append("</DATA>");
		logger.debug("getScheduleList End");
		return returnStr.toString();
	}
	
	public List<Date[]> getRepDateTimes(ResScheduleRepetitionVO vo, String sDate, String eDate, String offset) throws Exception {
		logger.debug("getRepDeteTimes started");
		
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
		
		logger.debug("sDate=" + sDate);
		logger.debug("eDate=" + eDate);
		logger.debug("selType=" + selType);
		logger.debug("interval=" + interval);
		logger.debug("endRecurType=" + endRecurType);
		logger.debug("instances=" + instances);
		logger.debug("startDate=" + sdf.format(startDate));
		logger.debug("endDate=" + sdf.format(endDate));
		logger.debug("resStartDate=" + sdf.format(resStartDate));
		logger.debug("resEndDate=" + sdf.format(resEndDate));
		logger.debug("tmpStartDate=" + sdf.format(tmpStartDate));
		logger.debug("tmpEndDate=" + sdf.format(tmpEndDate));
		
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
		
		logger.debug("sDate=" + sDate);
		logger.debug("eDate=" + eDate);
		logger.debug("interval=" + interval);
		logger.debug("endRecurType=" + endRecurType);
		logger.debug("instances=" + instances);
		logger.debug("startDate=" + sdf.format(startDate));
		logger.debug("endDate=" + sdf.format(endDate));
		logger.debug("resStartDate=" + sdf.format(resStartDate));
		logger.debug("resEndDate=" + sdf.format(resEndDate));
		logger.debug("tmpStartDate=" + sdf.format(tmpStartDate));
		logger.debug("tmpEndDate=" + sdf.format(tmpEndDate));
		
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
		
		logger.debug("sDate=" + sDate);
		logger.debug("eDate=" + eDate);
		logger.debug("interval=" + interval);
		logger.debug("endRecurType=" + endRecurType);
		logger.debug("instances=" + instances);
		logger.debug("startDate=" + sdf.format(startDate));
		logger.debug("endDate=" + sdf.format(endDate));
		logger.debug("resStartDate=" + sdf.format(resStartDate));
		logger.debug("resEndDate=" + sdf.format(resEndDate));
		logger.debug("tmpStartDate=" + sdf.format(tmpStartDate));
		logger.debug("tmpEndDate=" + sdf.format(tmpEndDate));
		
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
	
	@Override
	public String getAdminFlag(String companyID, String brdID, String userID, int tenantID) throws Exception {
		String accessLvl = "";

		
		ResGetAdminFlagVO resGetAdminFlag = getAdmFlag(companyID, brdID, userID, tenantID);

		String strXML = "<DATA>"+commonUtil.getQueryResult(resGetAdminFlag)+"</DATA>";
		Document xmlDom = commonUtil.convertStringToDocument(strXML);
	
		if(xmlDom.getElementsByTagName("ROW") != null) {
			for(int i=0; i<xmlDom.getElementsByTagName("ROW").getLength(); i++) {
				accessLvl = xmlDom.getElementsByTagName("ACCESSLVL").item(i).getTextContent().trim();
			}
		}
	
		if(accessLvl.trim().equals("1")) {
			return "Y";
		} else if(accessLvl.trim().equals("2")) {
			return "U";
		} else {
			return "";
		}
	
	}
	
	@Override
	public String getItemList(@CookieValue("loginCookie") String loginCookie,String brdID) throws Exception {
		String childBrd = "";
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		List<ResGetItemListVO> list = getBrdMainList(brdID, userInfo.getCompanyID(), userInfo.getPrimary(), userInfo.getTenantId());
		
		for(int i=0; i<list.size(); i++) {
			childBrd += list.get(i).getBrd_ID() + "/" + commonUtil.cleanValue(list.get(i).getBrd_Nm()) + "/" + list.get(i).getApproveFlag() + ",";
		}
		
		return childBrd;
	}
	
	@Override
	public String getSubClsTree(String xmlStr, String langStr, String pComID, String pDeptID, String pUserID, int tenantID) throws Exception {
        String strUserID = "";
        String strDeptPath = "";
        String returnXML = "";
   
        Document xmlRes = commonUtil.convertStringToDocument(xmlStr);
        String strParentID = xmlRes.getElementsByTagName("PARENT_ID").item(0).getTextContent().trim();
        String strCompanyID = xmlRes.getElementsByTagName("COMPANY_ID").item(0).getTextContent().trim();
        String strAccessFlag = xmlRes.getElementsByTagName("ACCESS_FLAG").item(0).getTextContent().trim();
        String strFirstNode = xmlRes.getElementsByTagName("FIRST_NODE").item(0).getTextContent().trim();
        String strTreeType = xmlRes.getElementsByTagName("TREE_TYPE").item(0).getTextContent().trim();

        if(xmlRes.getElementsByTagName("BRDLIST").getLength() > 5) {
        	strUserID = xmlRes.getElementById("BRDLIST").getChildNodes().item(5).getTextContent().trim();
        	strDeptPath = xmlRes.getElementById("BRDLIST").getChildNodes().item(6).getTextContent().trim();
        	strDeptPath = "'" + strDeptPath.replace("," , "', '")+ "'";
        }
        
        List<ResGetAdmSubClsTreeVO> resGetAdmSubClsTree = new ArrayList<ResGetAdmSubClsTreeVO>();
        if(strAccessFlag.equals("0")) {
        	resGetAdmSubClsTree = getAdmSubClsTree(strParentID, strCompanyID, strTreeType, tenantID);
        } else {
        	resGetAdmSubClsTree = getSubClsTree(strParentID, strCompanyID, strTreeType, strUserID, pComID, pDeptID, pUserID, tenantID);
        }

        StringBuilder strTreeStyle = new StringBuilder();
        if(strFirstNode.equals("Y")) {
        	strTreeStyle.append("<TREEVIEWDATA>");
        	strTreeStyle.append("<TEXTCOLOR>");
        	strTreeStyle.append("<NAME>ENTUMTEXTCOLOR</NAME>");
        	strTreeStyle.append("<DEFAULT></DEFAULT>");
        	strTreeStyle.append("<DEFAULTTEXTCOLOR>black</DEFAULTTEXTCOLOR>");					
        	strTreeStyle.append("<DEFAULTBGCOLOR>ffffff</DEFAULTBGCOLOR>");
        	strTreeStyle.append("<SELECTEDTEXTCOLOR>164AAD</SELECTEDTEXTCOLOR>");
        	strTreeStyle.append("<SELECTEDBGCOLOR>ffffff</SELECTEDBGCOLOR>");
        	strTreeStyle.append("<HOTTRACKINGTEXTCOLOR>164AAD</HOTTRACKINGTEXTCOLOR>");
        	strTreeStyle.append("<HOTTRACKINGBGCOLOR>ffffff</HOTTRACKINGBGCOLOR>");
        	strTreeStyle.append("</TEXTCOLOR>");
        	strTreeStyle.append("<NODEICONIMAGE>");
        	strTreeStyle.append("<NAME>RESCLASS</NAME>");
        	strTreeStyle.append("<DEFAULT></DEFAULT>");
        	strTreeStyle.append("<LEAFDEFAULTICON>/images/left/tree_01.gif</LEAFDEFAULTICON>");
        	strTreeStyle.append("<LEAFSELECTEDICON>/images/left/tree_01.gif</LEAFSELECTEDICON>");
        	strTreeStyle.append("<BRANCHDEFAULTICON>/images/left/tree_01.gif</BRANCHDEFAULTICON>");
        	strTreeStyle.append("<BRANCHSELECTEDICON>/images/left/tree_01.gif</BRANCHSELECTEDICON>");
        	strTreeStyle.append("</NODEICONIMAGE>");
        	strTreeStyle.append("<NODEICONIMAGE>");
        	strTreeStyle.append("<NAME>RESOURCE</NAME>");
        	strTreeStyle.append("<DEFAULT></DEFAULT>");
        	strTreeStyle.append("<LEAFDEFAULTICON>/images/left/tree_02.gif</LEAFDEFAULTICON>");
        	strTreeStyle.append("<LEAFSELECTEDICON>/images/left/tree_02.gif</LEAFSELECTEDICON>");
        	
        	strTreeStyle.append("<BRANCHDEFAULTICON>/images/left/tree_02.gif</BRANCHDEFAULTICON>");
        	strTreeStyle.append("<BRANCHSELECTEDICON>/images/left/tree_02.gif</BRANCHSELECTEDICON>");
        	strTreeStyle.append("</NODEICONIMAGE>");
        	strTreeStyle.append("<HERITAGEICONIMAGE>");
        	strTreeStyle.append("<DEFAULT></DEFAULT>");
        	strTreeStyle.append("<BLANKICON>/images/left/blank.gif</BLANKICON>");
        	strTreeStyle.append("<VERTICALLINEICON>/images/left/vline.gif</VERTICALLINEICON>");
        	strTreeStyle.append("<NODEICON>/images/left/02.gif</NODEICON>");
        	strTreeStyle.append("<MNODEICON>/images/left/02_minus.gif</MNODEICON>");
        	strTreeStyle.append("<PNODEICON>/images/left/02_plus.gif</PNODEICON>");
        	strTreeStyle.append("<ROOTNODEICON>/images/left/03.gif</ROOTNODEICON>");
        	strTreeStyle.append("<MROOTNODEICON>/images/left/03_minus.gif</MROOTNODEICON>");
        	strTreeStyle.append("<PROOTNODEICON>/images/left/03_plus.gif</PROOTNODEICON>");
        	strTreeStyle.append("<LASTNODEICON>/images/left/03.gif</LASTNODEICON>");
        	strTreeStyle.append("<MLASTNODEICON>/images/left/03_minus.gif</MLASTNODEICON>");
        	strTreeStyle.append("<FIRSTROOTNODEICON>/images/left/02.gif</FIRSTROOTNODEICON>");
        	strTreeStyle.append("<MFIRSTROOTNODEICON>/images/left/02_minus.gif</MFIRSTROOTNODEICON>");
        	strTreeStyle.append("<PFIRSTROOTNODEICON>/images/left/02_plus.gif</PFIRSTROOTNODEICON>");
        	strTreeStyle.append("</HERITAGEICONIMAGE>");
        
        	returnXML = strTreeStyle.toString();
        } else {
        	strTreeStyle.append("<NODES>");
        	returnXML = strTreeStyle.toString();
        }
        
        if(strFirstNode.equals("Y")) {
        	for(int i=0; i<resGetAdmSubClsTree.size(); i++) {
        		if(i == 0) {
        			 returnXML += makeNodesFromADOFlds(commonUtil.getQueryResult(resGetAdmSubClsTree.get(i)), true, langStr);
        		} else {
        			returnXML += makeNodesFromADOFlds(commonUtil.getQueryResult(resGetAdmSubClsTree.get(i)), false, langStr);
        		}
        	}
        	returnXML += "</TREEVIEWDATA>";
        } else {
        	for(int i=0; i<resGetAdmSubClsTree.size(); i++) {
        		returnXML += makeNodesFromADOFlds(commonUtil.getQueryResult(resGetAdmSubClsTree.get(i)), false, langStr);

        	}

        	returnXML += "</NODES>";
        }
		return returnXML;
	}
	
	public String makeNodesFromADOFlds(String xmlStr, boolean blnFirstNode, String langStr) throws Exception{
		String returnXML = "";
        String strData2 = "";
        int intSubCnt = 0;
        String strIsLeaf = "";
        String strSetNodeIconByName = "";
        
        Document xmlRes = DocumentBuilderFactory.newInstance().newDocumentBuilder().newDocument();
        xmlRes = commonUtil.convertStringToDocument(xmlStr);
        String strData1 = xmlRes.getElementsByTagName("BRDID").item(0).getTextContent();
        
        if(langStr.equals("1")) {
        	strData2 = xmlRes.getElementsByTagName("BRDNM").item(0).getTextContent();
        } else {
        	strData2 = xmlRes.getElementsByTagName("BRDNM"+langStr).item(0).getTextContent();
        }
        String strData3 = xmlRes.getElementsByTagName("BRDLEVEL").item(0).getTextContent();
        String strData4 = xmlRes.getElementsByTagName("BRDSTEP").item(0).getTextContent();
        String strData5 = xmlRes.getElementsByTagName("BRDPOSTTERM").item(0).getTextContent();
        String strData6 = xmlRes.getElementsByTagName("BRDUPPER").item(0).getTextContent();
        String strData7 = xmlRes.getElementsByTagName("BRDGB").item(0).getTextContent();
        String strData8 = xmlRes.getElementsByTagName("BRDURL").item(0).getTextContent();
        String strData9 = xmlRes.getElementsByTagName("BRDEXPLAIN").item(0).getTextContent();
        String strData10 = xmlRes.getElementsByTagName("BRDACCESS").item(0).getTextContent();
        String strData11 = xmlRes.getElementsByTagName("ATTACHSIZE").item(0).getTextContent();
        String strData12 = xmlRes.getElementsByTagName("SUBCLSCNT").item(0).getTextContent();
        String strData13 = xmlRes.getElementsByTagName("SUBRESCNT").item(0).getTextContent();
        String strData14 = xmlRes.getElementsByTagName("ACCESSLVL").item(0).getTextContent();
        String strData15 = xmlRes.getElementsByTagName("APPROVEFLAG").item(0).getTextContent();
  
        intSubCnt = Integer.parseInt(strData12.trim()) + Integer.parseInt(strData13.trim());
        
        String strValue = strData2;
        String strStyle = "font-weight:normal;height:10px;";
        
        returnXML += "<NODE>";
        returnXML += makeXMLElement(strValue, "VALUE", true);
        returnXML += makeXMLElement(strStyle, "STYLE", false);
        returnXML += makeXMLElement(strData1, "DATA1", false);
        returnXML += makeXMLElement(strData2, "DATA2", true);
        returnXML += makeXMLElement(strData3, "DATA3", false);
        returnXML += makeXMLElement(strData4, "DATA4", false);
        returnXML += makeXMLElement(strData5, "DATA5", false);
        returnXML += makeXMLElement(strData6, "DATA6", false);
        returnXML += makeXMLElement(strData7, "DATA7", false);
        returnXML += makeXMLElement(strData8, "DATA8", true);
        returnXML += makeXMLElement(strData9, "DATA9", true);
        returnXML += makeXMLElement(strData10, "DATA10", true);
        returnXML += makeXMLElement(strData11, "DATA11", false);
        returnXML += makeXMLElement(strData12, "DATA12", false);
        returnXML += makeXMLElement(strData13, "DATA13", false);
        returnXML += makeXMLElement(strData14, "DATA14", false);
        returnXML += makeXMLElement(strData15, "DATA15", false);
        
        if(intSubCnt == 0) {
        	strIsLeaf = "TRUE";
        } else {
        	strIsLeaf = "FALSE";
        }
        
        if(strData7.equals("1")) {
        	strSetNodeIconByName = "RESCLASS";
        } else {
        	strSetNodeIconByName = "RESOURCE";
        }
        
        returnXML += makeXMLElement(strIsLeaf, "ISLEAF", false);
        returnXML += makeXMLElement(strSetNodeIconByName, "SETNODEICONBYNAME", false);
        returnXML += makeXMLElement("FALSE", "EXPANDED", false);
        
        if(blnFirstNode == true) {
        	returnXML += makeXMLElement("", "SELECT", true);
        }
        returnXML += "</NODE>";
		return returnXML;
	}
	
	public String makeXMLElement(String strElementText, String strElementName, boolean blnCData) {
		if(blnCData == true) {
			return "<"+strElementName+"><![CDATA["+strElementText+"]]></"+strElementName+">";
		} else {
			return "<"+strElementName+">"+strElementText+"</"+strElementName+">";
		}
	}
	
	@Override
	public boolean multiDelResData(String xmlStr, int tenantID) throws Exception {
		String brdID = "";
		String companyID = "";
		
		Document xmlRes = commonUtil.convertStringToDocument(xmlStr);
		brdID = xmlRes.getElementsByTagName("DATA").item(0).getTextContent().trim();
		companyID = xmlRes.getElementsByTagName("DATA").item(1).getTextContent().trim();

		for (int i=0; i<brdID.split(",").length; i++) {
			delResData(brdID.split(",")[i], companyID, tenantID);
		}
		return true;
	}
	
	@Override
	public boolean modifyResData(String xmlStr, int tenantID) throws Exception {
		String strBrdID = "";
		String strODeptID = "";
		String strODeptNm = "";
		String strOwnerID = "";
		String strOwnerNm = "";
		String strOwnerPos = "";
	    String strOwnerCall = "";
	    String strBrdNm = "";
	    String strResLocation = "";
	    String strBrdExplain = "";
	    String strCompanyID = "";
	    String strApprove = "";
	    String strBrdNm2 = "";
	    String strODeptNm2 = "";
	    String strOwnerNm2 = "";
	    String strOwnerPos2 = "";
	    
		Document xmlRes = commonUtil.convertStringToDocument(xmlStr);
		strBrdID = xmlRes.getElementsByTagName("DATA").item(0).getTextContent().trim();
		strODeptID = xmlRes.getElementsByTagName("DATA").item(1).getTextContent().trim();
		strODeptNm = xmlRes.getElementsByTagName("DATA").item(2).getTextContent().trim();
		strOwnerID = xmlRes.getElementsByTagName("DATA").item(3).getTextContent().trim();
		strOwnerNm = xmlRes.getElementsByTagName("DATA").item(4).getTextContent().trim();
		strOwnerPos = xmlRes.getElementsByTagName("DATA").item(5).getTextContent().trim();
		strOwnerCall = xmlRes.getElementsByTagName("DATA").item(6).getTextContent().trim();
		strBrdNm = xmlRes.getElementsByTagName("DATA").item(7).getTextContent().trim();
		strResLocation = xmlRes.getElementsByTagName("DATA").item(8).getTextContent().trim();
		strBrdExplain = xmlRes.getElementsByTagName("DATA").item(9).getTextContent().trim();
		strCompanyID = xmlRes.getElementsByTagName("DATA").item(10).getTextContent().trim();
		strApprove = xmlRes.getElementsByTagName("DATA").item(11).getTextContent().trim();
		strBrdNm2 = xmlRes.getElementsByTagName("DATA").item(12).getTextContent().trim();
		strODeptNm2 = xmlRes.getElementsByTagName("DATA").item(13).getTextContent().trim();
		strOwnerNm2 = xmlRes.getElementsByTagName("DATA").item(14).getTextContent().trim();
		strOwnerPos2 = xmlRes.getElementsByTagName("DATA").item(15).getTextContent().trim();
			
		modifyResData(strBrdID, strODeptID, strODeptNm, strOwnerID, strOwnerNm, strOwnerPos, strOwnerCall, strBrdNm, strResLocation, strBrdExplain, strCompanyID, strApprove, strBrdNm2, strODeptNm2, strOwnerNm2, strOwnerPos2, tenantID);

		return true;
	}
	
	@Override
	public boolean addResData(String xmlStr, int tenantID,Locale locale) throws Exception {
		String strClassGB = "";
		String strODeptID = "";
		String strODeptNm = "";
		String strOwnerID = "";
		String strOwnerNm = "";
		String strOwnerPos = "";
	    String strOwnerCall = "";
	    String strBrdNm = "";
	    String strResLocation = "";
	    String strBrdExplain = "";
	    String strCompanyID = "";
	    String strApprove = "";
	    String strBrdNm2 = "";
	    String strODeptNm2 = "";
	    String strOwnerNm2 = "";
	    String strOwnerPos2 = "";
	    String strBreAccess = "";
	    
	   	Document xmlRes = commonUtil.convertStringToDocument(xmlStr);
		strClassGB = xmlRes.getElementsByTagName("DATA").item(0).getTextContent().trim();
		strODeptID = xmlRes.getElementsByTagName("DATA").item(1).getTextContent().trim();
		strODeptNm = xmlRes.getElementsByTagName("DATA").item(2).getTextContent().trim();
		strOwnerID = xmlRes.getElementsByTagName("DATA").item(3).getTextContent().trim();
		strOwnerNm = xmlRes.getElementsByTagName("DATA").item(4).getTextContent().trim();
		strOwnerPos = xmlRes.getElementsByTagName("DATA").item(5).getTextContent().trim();
		strOwnerCall = xmlRes.getElementsByTagName("DATA").item(6).getTextContent().trim();
		strBrdNm = xmlRes.getElementsByTagName("DATA").item(7).getTextContent().trim();
		strResLocation = xmlRes.getElementsByTagName("DATA").item(8).getTextContent().trim();
		strBrdExplain = xmlRes.getElementsByTagName("DATA").item(9).getTextContent().trim();
		strCompanyID = xmlRes.getElementsByTagName("DATA").item(10).getTextContent().trim();
		strApprove = xmlRes.getElementsByTagName("DATA").item(11).getTextContent().trim();
		strBrdNm2 = xmlRes.getElementsByTagName("DATA").item(12).getTextContent().trim();
		strODeptNm2 = xmlRes.getElementsByTagName("DATA").item(13).getTextContent().trim();
		strOwnerNm2 = xmlRes.getElementsByTagName("DATA").item(14).getTextContent().trim();
		strOwnerPos2 = xmlRes.getElementsByTagName("DATA").item(15).getTextContent().trim();
		strBreAccess = egovMessageSource.getMessage("ezResource.t58", locale);
			
		addResData(strClassGB, strODeptID, strODeptNm, strOwnerID, strOwnerNm, strOwnerPos, strOwnerCall, strBrdNm, strResLocation, strBrdExplain, strCompanyID, strApprove, strBrdNm2, strODeptNm2, strOwnerNm2, strOwnerPos2, strBreAccess, tenantID);

		return true;
	}
	
	@Override
	public String updateScheduleDateTime(String xmlStr, String companyID, int tenantID, String offset) throws Exception {
		Document xmlDom = commonUtil.convertStringToDocument(xmlStr);
		String num = xmlDom.getElementsByTagName("NUM").item(0).getTextContent();
		String ownerID = xmlDom.getElementsByTagName("OWNERID").item(0).getTextContent();
		String sDate = xmlDom.getElementsByTagName("STARTDATETIME").item(0).getTextContent();
		String eDate = xmlDom.getElementsByTagName("ENDDATETIME").item(0).getTextContent();

		updateScheduleDateTime(Integer.parseInt(num), ownerID, companyID, commonUtil.getDateStringInUTC(sDate, offset, true), commonUtil.getDateStringInUTC(eDate, offset, true), tenantID);
		return xmlStr;
	}
	
	@Override
	public boolean saveRepetition(String companyID, String num, String ownerID, String xmlStr, String cmd, int tenantID, String offset) throws Exception {
		String interval = "";
		String daysOfWeek = "";
		String daysOfMonth = "";
		String byPosition = "";
		String monthsOfYear = "";
		String instances = "";
		String reWay = "";
		String reDay = "";
		String reNum = "";
		String reYoil = "";
		String reMonth = "";
		String reOrd = "";
		String endFlag = "";
		String reCount = "";
		
		Document xmlRes = commonUtil.convertStringToDocument(xmlStr);
		String frequency = xmlRes.getElementsByTagName("frequency").item(0).getTextContent().trim();
		String selType = xmlRes.getElementsByTagName("selType").item(0).getTextContent();
		String endRecurType = xmlRes.getElementsByTagName("endRecurType").item(0).getTextContent();
		String startDateTime = xmlRes.getElementsByTagName("startDateTime").item(0).getTextContent();
		String endDateTime = xmlRes.getElementsByTagName("endDateTime").item(0).getTextContent();
		
		startDateTime = EgovDateUtil.convertDate(startDateTime, "yyyy-MM-dd HH:mm", "yyyy-MM-dd HH:mm:ss", "");
		endDateTime = EgovDateUtil.convertDate(endDateTime, "yyyy-MM-dd HH:mm", "yyyy-MM-dd HH:mm:ss", "");

		if (frequency.equals("4")) {
			interval = xmlRes.getElementsByTagName("interval").item(0).getTextContent();
			daysOfWeek = "";
			daysOfMonth = "";
			byPosition = "";
			monthsOfYear = "";
		} else if (frequency.equals("5")) {
			interval = xmlRes.getElementsByTagName("interval").item(0).getTextContent();
			daysOfWeek = xmlRes.getElementsByTagName("daysOfWeek").item(0).getTextContent();
			daysOfMonth = "";
			byPosition = "";
			monthsOfYear = "";
		} else if (frequency.equals("6")) {
			if (selType.equals("0")) {
				interval = xmlRes.getElementsByTagName("interval").item(0).getTextContent();
				daysOfMonth = xmlRes.getElementsByTagName("daysOfMonth").item(0).getTextContent();
				daysOfWeek = "";
				byPosition = "";
			} else {
				interval = xmlRes.getElementsByTagName("interval").item(0).getTextContent(); 
				byPosition = xmlRes.getElementsByTagName("byPosition").item(0).getTextContent();
				daysOfWeek = xmlRes.getElementsByTagName("daysOfWeek").item(0).getTextContent();
				daysOfMonth = "";
			}
			monthsOfYear = "";
		} else if (frequency.equals("7")) {
			if (selType.equals("0")) {
				monthsOfYear = xmlRes.getElementsByTagName("monthsOfYear").item(0).getTextContent();
				daysOfMonth = xmlRes.getElementsByTagName("daysOfMonth").item(0).getTextContent();
				daysOfWeek = "";
				byPosition = "";
			} else {
				monthsOfYear = xmlRes.getElementsByTagName("monthsOfYear").item(0).getTextContent();
				byPosition = xmlRes.getElementsByTagName("byPosition").item(0).getTextContent();
				daysOfWeek = xmlRes.getElementsByTagName("daysOfWeek").item(0).getTextContent();
				daysOfMonth = "";
			}
			interval = "";
		}
		
		if (endRecurType.trim().equals("1")) {
			instances = xmlRes.getElementsByTagName("instances").item(0).getTextContent();
		} else {
			instances = "";
		}
		reWay = frequency.trim() + selType.trim();
		reDay = daysOfMonth.trim();
		reNum = interval.trim();
		reYoil = daysOfWeek.trim();
		reMonth = monthsOfYear.trim();
		reOrd = byPosition.trim();
		endFlag = endRecurType.trim();
		reCount = instances.trim();
		
		String orgGresFlag = "";
		String orgEntryList = "";
		
		ResGetScheduleVO resGetSchedule = new ResGetScheduleVO();
		try {
			resGetSchedule = getSchedule(Integer.parseInt(num), ownerID, companyID, tenantID);
		} catch (Exception e) {
			e.printStackTrace();
		}
		if (resGetSchedule != null) {
			orgGresFlag = resGetSchedule.getGresFlag();
			orgEntryList = resGetSchedule.getEntryList();
		} else {
			orgGresFlag = "0";
			orgEntryList = "";
		}
		
		String[] entry;
		int entryNum = 0;
		String[] entryArr;
		String[] entryEmail;
		String entryID = "";
//		String entryName = "";
		
		if (cmd.equals("add")) {
			if (!orgGresFlag.equals("0") && !orgEntryList.equals("")) {
				insertScheduleRepetition(Integer.parseInt(num), ownerID, startDateTime, endDateTime, reWay, reDay, reNum, reYoil, reMonth, reOrd, endFlag, reCount, companyID, tenantID, offset);
				
				entry = orgEntryList.split(">");
				entryNum = entry.length;
				
				for (int i=0; i<entryNum; i++) {
					entryArr = entry[i].split("<");
//					entryName = entryArr[0];
					entryEmail = entryArr[1].split("@");
					entryID = entryEmail[0];
					
					List<ResGetScheduleVO> resGetScheduleInfo = getScheduleInfo(Integer.parseInt(num), entryID, ownerID, companyID, tenantID);
					
					for (ResGetScheduleVO list : resGetScheduleInfo) {
						insertScheduleRepetition((list.getNum()), entryID, startDateTime, endDateTime, reWay, reDay, reNum, reYoil, reMonth, reOrd, endFlag, reCount, companyID, tenantID, offset);
					}
				}
			} else {
				insertScheduleRepetition(Integer.parseInt(num), ownerID, startDateTime, endDateTime, reWay, reDay, reNum, reYoil, reMonth, reOrd, endFlag, reCount, companyID, tenantID, offset);
			}
		} else if (cmd.equals("mod")) {
			if (!orgGresFlag.equals("0") && !orgEntryList.equals("")) {
				entry = orgEntryList.split(">");
				entryNum = entry.length;
				for (int i=0; i<entryNum; i++) {
					entryArr = entry[i].split("<");
					//entryName = entryArr[0];
					entryEmail = entryArr[1].split("@");
					entryID = entryEmail[0];
					
					List<ResGetScheduleVO> resGetScheduleInfo = getScheduleInfo(Integer.parseInt(num), entryID, ownerID, companyID, tenantID);
					
					for (ResGetScheduleVO list : resGetScheduleInfo) {
						 List<ResGetScheduleRepetitionVO> getScheduleRepetition =  getScheduleRepetition(list.getNum(), entryID, companyID, tenantID);
						 
						 if (getScheduleRepetition != null) {
							 for (ResGetScheduleRepetitionVO list1 : getScheduleRepetition) {
								 updateScheduleRepetition(list1.getNum(), entryID, startDateTime, endDateTime, reWay, reDay, reNum, reYoil, reMonth, reOrd, endFlag, reCount, companyID, tenantID, offset);
							 }
						 } else {
							 insertScheduleRepetition(list.getNum(), entryID, startDateTime, endDateTime, reWay, reDay, reNum, reYoil, reMonth, reOrd, endFlag, reCount, companyID, tenantID, offset);
						 }
					}
				}
			}
			updateScheduleRepetition(Integer.parseInt(num), ownerID, startDateTime, endDateTime, reWay, reDay, reNum, reYoil, reMonth, reOrd, endFlag, reCount, companyID, tenantID, offset);
		}
		
		return true;
	}
	
	@Override
	public boolean deleteRepetition(String xmlStr, int tenantID) throws Exception {
		String num = "";
		String ownerID = "";
		
		Document xmlRes = commonUtil.convertStringToDocument(xmlStr);
		num = xmlRes.getElementsByTagName("PARAMETER").item(0).getChildNodes().item(0).getTextContent().trim();
		ownerID = xmlRes.getElementsByTagName("PARAMETER").item(0).getChildNodes().item(1).getTextContent().trim();
		
		deleteRepetition(ownerID, Integer.parseInt(num), tenantID);
	
		return true;
	}
	
	@Override
	public String getRepetition(String xmlStr, int tenantID, String offset) throws Exception {
		String num = "";
		String ownerID = "";
		String companyID = "";
		StringBuilder resultXml = new StringBuilder();
		
		Document xmlRes = commonUtil.convertStringToDocument(xmlStr);
		num = xmlRes.getElementsByTagName("NUM").item(0).getTextContent().trim();
		ownerID = xmlRes.getElementsByTagName("OWNERID").item(0).getTextContent().trim();
		companyID = xmlRes.getElementsByTagName("companyID").item(0).getTextContent().trim();
		
		List<ResGetScheduleRepetitionVO> getScheduleRepetition = getScheduleRepetition(Integer.parseInt(num), ownerID, companyID, tenantID);
		
		String startDateTime = "";
		String endDateTime = "";
		String reWay = "";
		String reDay = "";
		String reNum = "";
		String reYoil = "";
		String reMonth = "";
		String reOrd = "";
		String endFlag = "";
		String reCount = "";
		String freq = "";
		String sel = "";
		
		for (ResGetScheduleRepetitionVO vo : getScheduleRepetition) {
			startDateTime = commonUtil.getDateStringInUTC(vo.getStartDateTime(), offset, false);
			endDateTime = commonUtil.getDateStringInUTC(vo.getEndDateTime(), offset, false);
			reWay = vo.getReWay();
			reNum = vo.getReNum();
			reYoil = vo.getReYoil();
			reMonth = vo.getReMonth();
			reOrd = vo.getReOrd();
			endFlag = vo.getEndFlag();
			reCount = vo.getReCount();
		}
		
		freq = reWay.substring(0, 1);
		sel = reWay.substring(1);
		
		resultXml.append("<recurrence>");
		resultXml.append("<frequency>" + freq + "</frequency>");
		resultXml.append("<selType>" + sel + "</selType>");
		resultXml.append("<endRecurType>" + endFlag + "</endRecurType>");
		resultXml.append("<startDateTime>" + startDateTime + "</startDateTime>");
		resultXml.append("<endDateTime>" + endDateTime + "</endDateTime>");
		
		if (freq.equals("4")) {
			if (sel.equals("0")) {
				resultXml.append("<interval>" + reNum + "</interval>");
			}
		} else if (freq.equals("5")) {
			resultXml.append("<interval>" + reNum + "</interval>");
			resultXml.append("<daysOfWeek>" + reYoil + "</daysOfWeek>");
		} else if (freq.equals("6")) {
			if (sel.equals("0")) {
				resultXml.append("<interval>" + reNum + "</interval>");
				resultXml.append("<daysOfWeek>" + reDay + "</daysOfWeek>");
			} else {
				resultXml.append("<interval>" + reNum + "</interval>");
				resultXml.append("<byPosition>" + reOrd + "</byPosition>");
				resultXml.append("<daysOfWeek>" + reYoil + "</daysOfWeek>");
			}
		} else if (freq.equals("7")) {
			if (sel.equals("0")) {
				resultXml.append("<monthsOfYear>" + reMonth + "</monthsOfYear>");
				resultXml.append("<daysOfMonth>" + reDay + "</daysOfMonth>");
			} else {
				resultXml.append("<monthsOfYear>" + reMonth + "</monthsOfYear>");
				resultXml.append("<byPosition>" + reOrd + "</byPosition>");
				resultXml.append("<daysOfWeek>" + reYoil + "</daysOfWeek>");
			}
		}
		if (endFlag.equals("1")) {
			resultXml.append("<instances>" + reCount + "</instances>");
		}
		resultXml.append("</recurrence>");
			
	
		return resultXml.toString();
	}
	
	@Override
	public String getACL(String pCompanyID, String pBrdID, String pUserID, String pMode, int tenantID) throws Exception {
		String aclTblBrd = "";
		
		 aclTblBrd = getAclTblBrd(pCompanyID, pBrdID, pUserID, pMode, tenantID);
			
		return aclTblBrd;
	}
	
	@Override
	public boolean delResSch(String xmlStr, int tenantID, String offset) throws Exception {
		Document xmlRes = commonUtil.convertStringToDocument(xmlStr);
		
		String ownerID = xmlRes.getElementsByTagName("OWNERID").item(0).getTextContent();
		String num = xmlRes.getElementsByTagName("NUM").item(0).getTextContent();
		String pNum = xmlRes.getElementsByTagName("PNUM").item(0).getTextContent();
		String companyID = xmlRes.getElementsByTagName("COMPANYID").item(0).getTextContent();
		String writerID = xmlRes.getElementsByTagName("WRITERID").item(0).getTextContent();
		
		String sDate = EgovDateUtil.convertDate(xmlRes.getElementsByTagName("STARTDATE").item(0).getTextContent(), "yyyy-M-d", "yyyy-MM-dd", "");
		String eDate = EgovDateUtil.convertDate(xmlRes.getElementsByTagName("ENDDATE").item(0).getTextContent(), "yyyy-M-d", "yyyy-MM-dd", "");
		
		String insType = xmlRes.getElementsByTagName("INSTYPE").item(0).getTextContent();
			
		delResSch(ownerID, num, pNum, companyID, writerID, sDate, eDate, Integer.parseInt(insType), offset, tenantID);
		return true;
	}
	
	@Override
	public String modifyResSch(String xmlStr, int tenantID, String offset) throws Exception {
		Document xmlRes = commonUtil.convertStringToDocument(xmlStr);
		String attachFlag = "";
		
		NodeList nodeList = xmlRes.getElementsByTagName("PARAMETER").item(0).getChildNodes();
		
		String title = nodeList.item(0).getTextContent().trim();
		String location = nodeList.item(1).getTextContent().trim();
		String timeDisplay = nodeList.item(2).getTextContent().trim();
		String startDate = nodeList.item(3).getTextContent().trim();
		String endDate = nodeList.item(4).getTextContent().trim();
		String allDay = nodeList.item(5).getTextContent().trim();
		String alertTime = nodeList.item(6).getTextContent().trim();
		String content = nodeList.item(7).getTextContent().trim();
		String writerID = nodeList.item(8).getTextContent().trim();
		String importance = nodeList.item(9).getTextContent().trim();
		String entryList = nodeList.item(10).getTextContent().trim();
		String reFlag = nodeList.item(11).getTextContent().trim();
		String gresFlag = nodeList.item(12).getTextContent().trim();
		String num = nodeList.item(13).getTextContent().trim();
		String pNum = nodeList.item(14).getTextContent().trim();
		String ownerID = nodeList.item(15).getTextContent().trim();
		String attachFiles = nodeList.item(16).getTextContent().trim();
		String companyID = nodeList.item(17).getTextContent().trim();
		String characterID = nodeList.item(18).getTextContent().trim();
		String typeVal = nodeList.item(19).getTextContent().trim();
		String strApprove = xmlRes.getElementsByTagName("APPROVE").item(0).getTextContent().trim();
			
		if (attachFiles != null && !attachFiles.equals("")) {
			attachFlag = "1";
		} else {
			attachFlag = "0";
		}
			
		modifyResSch(ownerID, num, pNum, companyID, writerID, title, location, timeDisplay, startDate, endDate, allDay, alertTime, content, importance,
							reFlag, gresFlag, entryList, characterID, attachFlag, typeVal, strApprove, tenantID, offset);
		String returnStr = "";
		returnStr += "<RTN_DATA>";
        returnStr += "<NUM>" + num + "</NUM>";
        returnStr += "<OWNERID>" + ownerID + "</OWNERID>";
        returnStr += "</RTN_DATA>";

        return returnStr;
	}
	
	@Override
	public String addResSch(String xmlStr, int tenantID, String offset) throws Exception {
		logger.debug("addResSch Start");
		Document xmlRes = commonUtil.convertStringToDocument(xmlStr);
		String attachFlag = "";
		String scheduleID = "";
		
		NodeList nodeList = xmlRes.getElementsByTagName("PARAMETER").item(0).getChildNodes();
		
		String title = nodeList.item(0).getTextContent().trim();
		String location = nodeList.item(1).getTextContent().trim();
		String timeDisplay = nodeList.item(2).getTextContent().trim();
		String startDate = nodeList.item(3).getTextContent().trim();
		String endDate = nodeList.item(4).getTextContent().trim();
		String allDay = nodeList.item(5).getTextContent().trim();
		String alertTime = nodeList.item(6).getTextContent().trim();
		String content = nodeList.item(7).getTextContent().trim();
		String writerID = nodeList.item(8).getTextContent().trim();
		String importance = nodeList.item(9).getTextContent().trim();
		String entryList = nodeList.item(10).getTextContent().trim();
		String reFlag = nodeList.item(11).getTextContent().trim();
		String gresFlag = nodeList.item(12).getTextContent().trim();
		String pNum = nodeList.item(14).getTextContent().trim();
		String ownerID = nodeList.item(15).getTextContent().trim();
		String attachFiles = nodeList.item(16).getTextContent().trim();
		String companyID = nodeList.item(17).getTextContent().trim();
		String characterID = nodeList.item(18).getTextContent().trim();
		String deptNm = nodeList.item(20).getTextContent().trim();
		String ownerNm = nodeList.item(21).getTextContent().trim();
		String strApprove = nodeList.item(22).getTextContent().trim();
			
		if (nodeList.getLength() > 23) {
			scheduleID = nodeList.item(23).getTextContent().trim();
		}
		
		if (attachFiles != null && !attachFiles.equals("")) {
			attachFlag = "1";
		} else {
			attachFlag = "0";
		}
		
		timeDisplay = "1";
		int num = addResSch(ownerID, pNum, companyID, writerID, title, location, timeDisplay, startDate, endDate, allDay, alertTime, content, importance, reFlag, gresFlag, 
				entryList, characterID, attachFlag, deptNm, ownerNm, strApprove, scheduleID, tenantID, offset);
		String returnStr = "";
		returnStr += "<RTN_DATA>";
        returnStr += "<NUM>" + num + "</NUM>";
        returnStr += "<OWNERID>" + writerID + "</OWNERID>";
        returnStr += "</RTN_DATA>";
        
        logger.debug("returnStr=" + returnStr);
        logger.debug("addResSch End");
        return returnStr;
	}
	
	//반복예약일때
	@Override
	public boolean getRepResource(String strFrequency, String strSelType, String strEndRecurType, String strStartDateTime, String strEndDateTime, String strInterval,
		String strDaysOfWeek, String strInstances, String strByPosition, String strDaysOfMonth, String strMonthsOfYear, String strPownerID, String strPnum, String strPcmd, String companyID, List<ResMakeDupResultVO> dtResult, int tenantID, String offset) throws Exception {
		logger.debug("getRepResource Start");
		logger.debug("===반복예약일때===");
		
		strStartDateTime = EgovDateUtil.convertDate(strStartDateTime, "yyyy-MM-dd HH:mm", "yyyy-MM-dd HH:mm:ss", "");
		strEndDateTime = EgovDateUtil.convertDate(strEndDateTime, "yyyy-MM-dd HH:mm", "yyyy-MM-dd HH:mm:ss", "");
		
		String pOwnerID = strPownerID.equals("") ? null : strPownerID;
		String pCmd = strPcmd.equals("") ? "" : strPcmd;
		
		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

		ResScheduleRepetitionVO vo = resStruct(strFrequency, strSelType, strEndRecurType, strStartDateTime, strEndDateTime, strInterval, strDaysOfWeek, strInstances, strByPosition, strDaysOfMonth, strMonthsOfYear);
		
		//TODO: sDate,eDate setting
		List<Date[]> dateList = getRepDateTimes(vo, "2000-01-01", "2999-12-31", offset);

		boolean isDup = false;
		
		//자원의 일반예약 스케줄을 가져옴 TODO: sDate,eDate 수정해야함. -> dateList 정렬후 처음과 끝
		List<ResDateVO> scheduleDateList = getScheduleDateList(pOwnerID, companyID, "2999-12-31 23:59:59", "2000-01-01 00:00:00", offset, tenantID);
		logger.debug("scheduleDateList.size=" + scheduleDateList.size());
		
		List<Date[]> dateList2 = new ArrayList<Date[]>();
		for (ResDateVO dateVO : scheduleDateList) {
			dateList2.add(new Date[] {
					format.parse(commonUtil.getDateStringInUTC(dateVO.getStartDate(), offset, false)),
					format.parse(commonUtil.getDateStringInUTC(dateVO.getEndDate(), offset, false))
			});
		}
		
		if (dateList2.size() != 0) {
			isDup = chkTableRepeat(dateList, dateList2, null, offset);
			
			if (isDup) {
				logger.debug("getRepResource End. isDup=" + isDup);
				return isDup;
			}
		}
		
		//자원의 반복예약 스케줄을 가져옴 TODO: 이거 말고 딴거 타게 하자. sDate,eDate 조건있게
		List<ResGetScheduleRepetitionVO> repScheduledList = getRepResourceRepeat(pOwnerID, 0, pCmd, companyID, tenantID);
		logger.debug("repScheduledList.size=" + repScheduledList.size());
		
		for (ResGetScheduleRepetitionVO schedule : repScheduledList) {
			schedule.setStartDateTime(commonUtil.getDateStringInUTC(schedule.getStartDateTime(), offset, false));
			schedule.setEndDateTime(commonUtil.getDateStringInUTC(schedule.getEndDateTime(), offset, false));
			
			ResScheduleRepetitionVO vo2 = resStruct(schedule);

			//TODO: sDate,eDate 수정해야함. -> dateList 정렬후 처음과 끝
			dateList2 = getRepDateTimes(vo2, "2000-01-01", "2999-12-31", offset);
			
			// 반복예약 중에 삭제된 예약 가져옴
			List<String> deletedDateStrList = getDeletedRepScheduleDate(schedule.getNum(), companyID, pOwnerID, tenantID);
			logger.debug("deletedDateStrList.size=" + deletedDateStrList.size());
			
			for (String date : deletedDateStrList) {
				date = commonUtil.getDateStringInUTC(date, offset, false);
			}
			
			if (dateList2.size() == 0) {
				continue;
			}

			isDup = chkTableRepeat(dateList, dateList2, deletedDateStrList, offset);
			
			if (isDup) {
				break;
			}
		}

		logger.debug("getRepResource End. isDup=" + isDup);
		return isDup;
	}
	
	//일반예약일때
	@Override
	public boolean getRepResource(String strStartDateTime, String strEndDateTime, String strPownerID, String strPnum, String strPcmd, String companyID, List<ResMakeDupResultVO> dtResult, int tenantID, String offset) throws Exception {
		logger.debug("getRepResource started");
		logger.debug("===일반예약일때===");
		
		strStartDateTime = EgovDateUtil.convertDate(strStartDateTime, "yyyy-MM-dd HH:mm", "yyyy-MM-dd HH:mm:ss", "");
		strEndDateTime = EgovDateUtil.convertDate(strEndDateTime, "yyyy-MM-dd HH:mm", "yyyy-MM-dd HH:mm:ss", "");

		String pOwnerID = strPownerID.equals("") ? null : strPownerID;
		String pCmd = strPcmd.equals("") ? null : strPcmd;
		
		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		
		List<Date[]> dateList = new ArrayList<Date[]>();
		dateList.add(new Date[] {
				format.parse(strStartDateTime),
				format.parse(strEndDateTime)
		});
		
		boolean isDup = false;
		
		//자원의 일반예약 스케줄을 가져옴 TODO: sDate,eDate 수정해야함. -> dateList 정렬후 처음과 끝
		List<ResDateVO> scheduleDateList = getScheduleDateList(pOwnerID, companyID, strEndDateTime, strStartDateTime, offset, tenantID);
		List<Date[]> dateList2 = new ArrayList<Date[]>();
		for (ResDateVO dateVO : scheduleDateList) {
			dateList2.add(new Date[] {
					format.parse(commonUtil.getDateStringInUTC(dateVO.getStartDate(), offset, false)),
					format.parse(commonUtil.getDateStringInUTC(dateVO.getEndDate(), offset, false))
			});
		}
		
		if (dateList2.size() != 0) {
			isDup = chkTableRepeat(dateList, dateList2, null, offset);
			
			if (isDup) {
				logger.debug("getRepResource End. isDup=" + isDup);
				return isDup;
			}
		}
		
		//자원의 반복예약 스케줄을 가져옴 TODO: 이거 말고 딴거 타게 하자. sDate,eDate 조건있게
		List<ResGetScheduleRepetitionVO> repScheduledList = getRepResourceRepeat(pOwnerID, 0, pCmd, companyID, tenantID);
		logger.debug("repScheduledList.size=" + repScheduledList.size());
		
		for (ResGetScheduleRepetitionVO schedule : repScheduledList) {
			schedule.setStartDateTime(commonUtil.getDateStringInUTC(schedule.getStartDateTime(), offset, false));
			schedule.setEndDateTime(commonUtil.getDateStringInUTC(schedule.getEndDateTime(), offset, false));
			
			ResScheduleRepetitionVO vo2 = resStruct(schedule);

			dateList2 = getRepDateTimes(vo2, strStartDateTime, strEndDateTime, offset);
			
			// 반복예약 중에 삭제된 예약 가져옴
			List<String> deletedDateStrList = getDeletedRepScheduleDate(schedule.getNum(), companyID, pOwnerID, tenantID);
			logger.debug("deletedDateStrList.size=" + deletedDateStrList.size());
			
			for (String date : deletedDateStrList) {
				date = commonUtil.getDateStringInUTC(date, offset, false);
			}
			
			if (dateList2.size() == 0) {
				continue;
			}

			isDup = chkTableRepeat(dateList, dateList2, deletedDateStrList, offset);
			
			if (isDup) {
				break;
			}
		}

		logger.debug("getRepResource End. isDup=" + isDup);
		return isDup;
	}
	
	public boolean chkTableRepeat(List<Date[]> dateList, List<Date[]> dateList2, List<String> deletedList, String offset) throws Exception {
		logger.debug("============ chkTableRepeat started ============");
		
		logger.debug("dateList.size=" + dateList.size());
		logger.debug("dateList2.size=" + dateList2.size());
		
		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		if (deletedList == null || deletedList.size() == 0) {
			for (Date[] dateVO : dateList) {
				for (Date[] dateVO2 : dateList2) {
					if (!(!dateVO[0].before(dateVO2[1]) || !dateVO[1].after(dateVO2[0]))) {
						logger.debug("chkTableRepeat ended.");
						return true;
					}
				}
			}
		} else {
			for (Date[] dateVO : dateList) {
				for (Date[] dateVO2 : dateList2) {
					if (!(!dateVO[0].before(dateVO2[1]) || !dateVO[1].after(dateVO2[0]))) {
						if (!deletedList.contains(format.format(dateVO2[0]))) {
							logger.debug("chkTableRepeat ended.");
							return true;
						}
					}
				}
			}
		}

		logger.debug("chkTableRepeat ended");
		return false;
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
			result.setInterval(Integer.parseInt(vo.getReNum()));
		}
		
		if (vo.getEndFlag() != null && !vo.getEndFlag().trim().equals("")) {
			result.setEndRecurType(Integer.parseInt(vo.getEndFlag()));
		} else {
			result.setEndRecurType(-1);
		}
		
		if (vo.getReCount() != null && !vo.getReCount().trim().equals("")) {
			result.setInstances(Integer.parseInt(vo.getReCount()));
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
			result.setDaysOfMonth(Integer.parseInt(vo.getReDay()));
		}
		
		if (vo.getReMonth() != null && !vo.getReMonth().trim().equals("")) {
			result.setMonthsOfYear(Integer.parseInt(vo.getReMonth()));
		}
		
		if (vo.getReOrd() != null && !vo.getReOrd().trim().equals("")) {
			result.setByPosition(Integer.parseInt(vo.getReOrd()));
		}
		
		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		
		if (vo.getStartDateTime() != null && !vo.getStartDateTime().trim().equals("")) {
			result.setStartDate(format.parse(vo.getStartDateTime()));
		}
		
		if (vo.getEndDateTime() != null && !vo.getEndDateTime().trim().equals("")) {
			result.setEndDate(format.parse(vo.getEndDateTime()));
		}
		
		if (vo.getAllDay() != null && vo.getAllDay().equals("1")) {
			result.setAllDay(true);
		}
		
		logger.debug("resStruct ended");
		return result;
	}
	
}

