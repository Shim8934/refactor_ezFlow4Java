package egovframework.ezEKP.ezResource.service.impl;


import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.TimeZone;

import javax.annotation.Resource;
import javax.xml.parsers.DocumentBuilderFactory;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.CookieValue;
import org.w3c.dom.Document;

import com.ibm.icu.impl.LocaleDisplayNamesImpl.DataTable;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezResource.dao.EzResourceDAO;
import egovframework.ezEKP.ezResource.service.EzResourceService;
import egovframework.ezEKP.ezResource.vo.ResAdminVO;
import egovframework.ezEKP.ezResource.vo.ResBrdListVO;
import egovframework.ezEKP.ezResource.vo.ResBrdVO;
import egovframework.ezEKP.ezResource.vo.ResGetAdmSubClsTreeVO;
import egovframework.ezEKP.ezResource.vo.ResGetAdminFlagVO;
import egovframework.ezEKP.ezResource.vo.ResGetItemListVO;
import egovframework.ezEKP.ezResource.vo.ResGetRepDateTimesVO;
import egovframework.ezEKP.ezResource.vo.ResGetRepResourceRepeatVO;
import egovframework.ezEKP.ezResource.vo.ResGetRepResourceVO;
import egovframework.ezEKP.ezResource.vo.ResGetScheduleListMainVO;
import egovframework.ezEKP.ezResource.vo.ResGetScheduleListRepetitionVO;
import egovframework.ezEKP.ezResource.vo.ResGetScheduleListTermVO;
import egovframework.ezEKP.ezResource.vo.ResGetScheduleListVO;
import egovframework.ezEKP.ezResource.vo.ResGetScheduleRepetitionVO;
import egovframework.ezEKP.ezResource.vo.ResGetScheduleVO;
import egovframework.ezEKP.ezResource.vo.ResGetSendMailToUserVO;
import egovframework.ezEKP.ezResource.vo.ResMakeDupResultVO;
import egovframework.ezEKP.ezResource.vo.ResObjArrayDestVO;
import egovframework.ezEKP.ezResource.vo.ResRecDurationVO;
import egovframework.ezEKP.ezResource.vo.ResRecParamVO;
import egovframework.ezEKP.ezResource.vo.ResSelectFormIDVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.fcc.service.EgovDateUtil;
import egovframework.let.utl.fcc.service.EgovStringUtil;
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

	@Override
	public List<ResGetScheduleListVO> getScheduleList(String ownerID, String companyID, String startDate, String endDate, String writerName, String writerDept, int tenantID) throws Exception {
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
	public List<ResGetScheduleListMainVO> getScheduleListMain(String ownerID, String companyID, String startDate, String endDate, int tenantID) throws Exception {
		logger.debug("getScheduleListMain Start");
		logger.debug("ownerID="+ownerID);
		logger.debug("companyID="+companyID);
		logger.debug("startDate="+startDate);
		logger.debug("endDate="+endDate);
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_pOwnerID", ownerID);
		map.put("v_pCompanyID", companyID);
		map.put("v_pStartDate", startDate);
		map.put("v_pEndDate", endDate);
		map.put("tenantID", tenantID);
		logger.debug("getScheduleListMain End");
		return ezResourceDAO.getScheduleListMain(map);
	}

	@Override
	public List<ResGetScheduleListRepetitionVO> getScheduleListRepetiti(String ownerID, String companyID, String startDate, String endDate, String writerName, String writerDept, int tenantID) throws Exception {
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
	public List<ResGetScheduleListMainVO> getScheduleListRepetitim( String ownerID, String companyID, String startDate, int tenantID) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_POWNERID", ownerID);
		map.put("v_PCOMPANYID", companyID);
		map.put("v_PSTARTDATE", startDate);
		map.put("tenantID", tenantID);
		
		return ezResourceDAO.getScheduleListRepetitim(map);
	}

	@Override
	public ResGetRepDateTimesVO getRepDateTimes(String ownerID, String companyID, int num, int tenantID) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_pOwnerID", ownerID);
		map.put("v_pCompanyID", companyID);
		map.put("v_pNum", num);
		map.put("tenantID", tenantID);
		return ezResourceDAO.getRepDateTimes(map);
	}

	@Override
	public ResGetScheduleListTermVO getScheduleListTerm(int num, String companyID, String ownerID, String startDate, String endDate, String writerName, String writerDept, int tenantID) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_PNUM", num);
		map.put("v_PCOMPANYID", companyID);
		map.put("v_POWNERID", ownerID);
		map.put("v_PSTARTDATE", startDate);
		map.put("v_PENDDATE", endDate);
		map.put("v_WRITERNAME", writerName);
		map.put("v_WRITERDEPT", writerDept);
		map.put("tenantID", tenantID);
		return ezResourceDAO.getScheduleListTerm(map);
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
		ezResourceDAO.delResData2(map);
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
		map.put("v_Brd_ID", ezResourceDAO.addResData_S1());
		map.put("v_Brd_Access", strBreAccess);
		map.put("tenantID", tenantID);
		
		
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
	public void insertScheduleRepetition(int pNum, String ownerID, String startDateTime, String endDateTime, String reWay, String reDay, String reNum, String reYoil, String reMonth,
			String reOrd, String endFlag, String reCount, String companyID, int tenantID, String offset) throws Exception {
		logger.debug("insertScheduleRepetition started");
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_pNum", pNum);
		map.put("v_pOwnerID", ownerID);
		logger.debug("startDateTime="+startDateTime);
		logger.debug("endDateTime="+endDateTime);
		logger.debug("pStartDateTime="+commonUtil.getDateStringInUTC(startDateTime, offset, true));
		logger.debug("pEndDateTime="+commonUtil.getDateStringInUTC(endDateTime, offset, true));
		map.put("v_pStartDateTime", commonUtil.getDateStringInUTC(startDateTime, offset, true));
		map.put("v_pEndDateTime", commonUtil.getDateStringInUTC(endDateTime, offset, true));
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
		
		Map<String,Object> map2 = new HashMap<String, Object>();
		map2.put("v_pCompanyID", companyID);
		map2.put("v_pOwnerID", ownerID);
		int num = ezResourceDAO.insertScheduleRepetition_S(map2);
		
		map.put("v_Num", num);
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
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_P_ownerID", ownerID);
		map.put("v_P_num", num);
		map.put("v_P_pnum", pNum);
		map.put("v_P_companyID", companyID);
		map.put("v_P_writerID", writerID);
		map.put("v_P_title", title);
		map.put("v_P_location", location);
		map.put("v_P_timeDisplay", timeDisplay);
		map.put("v_P_startDate", commonUtil.getDateStringInUTC(startDate, offset, true));
		map.put("v_P_endDate", commonUtil.getDateStringInUTC(endDate, offset, true));
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
		
		SimpleDateFormat date = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		date.setTimeZone(TimeZone.getTimeZone("GMT"));
		String nowDate = date.format(new Date());
		map.put("nowDate", nowDate);
		logger.debug("typeVal="+typeVal);
		if (reFlag.equals("1") && typeVal.equals("MASTER")) {
			String ownerNm = ezResourceDAO.modifyResSch_S1(map);
			String deptNm = ezResourceDAO.modifyResSch_S2(map);
			
			ezResourceDAO.modifyResSch_D1(map);
			
			map.put("v_tmpOwnerNm", ownerNm);
			map.put("v_tmpDeptNm", deptNm);
			ezResourceDAO.modifyResSch_I1(map);
			
		} else {
			if (typeVal.equals("INSTANCE")) {
				int result = ezResourceDAO.modifyResSch_U1(map);
				logger.debug("result="+result);
				if (result == 0) {
					ezResourceDAO.modifyResSch_I2(map);
				}
				
			} else {
				ezResourceDAO.modifyResSch_U2(map);
			}
		}
		logger.debug("modifyResSch End");
		//ezResourceDAO.modifyResSch(map);
	}

	@Override
	public void delResSch(String ownerID, String num, String pNum, String companyID, String writerID, String sDate, String eDate, int insType, int tenantID) throws Exception {
		logger.debug("delResSch Start");
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_P_ownerID", ownerID);
		map.put("v_P_num", num);
		map.put("v_P_pnum", pNum);
		map.put("v_P_companyID", companyID);
		map.put("v_P_writerID",  writerID);
		map.put("v_P_sDate", sDate);
		map.put("v_P_eDate", eDate);
		map.put("v_P_insType", insType);
		map.put("tenantID", tenantID);
		
		SimpleDateFormat date = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		date.setTimeZone(TimeZone.getTimeZone("GMT"));
		String nowDate = date.format(new Date());
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
	public void addResSch(String ownerID, String pNum, String companyID, String writerID, String title, String location, String timeDisplay,
			String startDate, String endDate, String allDay, String alertTime, String content, String importance, String reFlag, String gresFlag,
			String entryList, String characterID, String attachFlag, String deptNm, String ownerNm, String approve, String scheduleID, int tenantID, String offset) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_P_ownerID", ownerID);
		if (pNum == null || pNum.equals("")) {
			pNum = "0";
		}
		map.put("v_P_pnum", pNum);
		map.put("v_P_companyID", companyID);
		map.put("v_P_writerID", writerID);
		map.put("v_P_title", title);
		map.put("v_P_location", location);
		map.put("v_P_timeDisplay", timeDisplay);
		map.put("v_P_startDate", commonUtil.getDateStringInUTC(startDate, offset, true));
		map.put("v_P_endDate", commonUtil.getDateStringInUTC(endDate, offset, true));
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
		
		SimpleDateFormat date = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		date.setTimeZone(TimeZone.getTimeZone("GMT"));
		String nowDate = date.format(new Date());
		map.put("nowDate", nowDate);
		
		String approveFlag = ezResourceDAO.addRessch_S1(map);
		
		if (approveFlag.equals("1")) {
			approveFlag = "0";
		} else {
			approveFlag = "1";
		}
		
		map.put("v_P_Approve", approveFlag);
		
		ezResourceDAO.addResSch(map);
	}
	
	@Override
	public List<ResGetRepResourceRepeatVO> getRepResourceRepeat(String ownerID, int num, String cmd, String companyID, int tenantID) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_p_ownerID", ownerID);
		map.put("v_p_num", num);
		map.put("v_p_cmd", cmd);
		map.put("v_p_companyID", companyID);
		map.put("tenantID", tenantID);
		return ezResourceDAO.getRepResourceRepeat(map);
	}

	@Override
	public List<ResGetRepResourceVO> getRepResource(int frequency, int selType, int endRecurType, String startDateTime, String endDateTime, int interval,
			String daysOfWeek, int instances, int byPosition, String daysOfMonth, String ownerID, int num, String cmd, String companyID, int tenantID, String offset) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		logger.debug("getRepResource Start");
		logger.debug("ownerID="+ownerID);
		logger.debug("num="+num);
		logger.debug("cmd="+cmd);
		logger.debug("companyID="+companyID);
		map.put("v_rec_frequency", frequency);
		map.put("v_rec_selType", selType);
		map.put("v_rec_endRecurType", endRecurType);
		map.put("v_rec_startDateTime", startDateTime);
		map.put("v_rec_endDateTime", endDateTime);
		map.put("v_rec_interval", interval);
		map.put("v_rec_daysOfWeek", daysOfWeek);
		map.put("v_rec_instances", instances);
		map.put("v_rec_byPosition", byPosition);
		map.put("v_rec_daysOfMonth", daysOfMonth);
		map.put("v_p_ownerID", ownerID);
		map.put("v_p_num", num);
		map.put("v_p_cmd", cmd);
		map.put("v_p_companyID", companyID);
		map.put("tenantID", tenantID);
		logger.debug("getRepResource End");
		return ezResourceDAO.getRepResource(map);
	}
	
	@Override
	public ResGetRepResourceVO chkDeletedRepResource(String ownerID, int tenantID) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_p_ownerID", ownerID);
		map.put("tenantID", tenantID);
		return ezResourceDAO.chkDeletedRepResource(map);
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

	@SuppressWarnings("deprecation")
	public String getScheduleXML(String xmlStr, String ownerID, String companyID, String groupID, String gubun, String pType, String pWriterName, String pWriterDept, int tenantID, String offset) throws Exception {
		logger.debug("getScheduleXML Start");
		StringBuilder returnStr = new StringBuilder();
		
		Document xmlRes = commonUtil.convertStringToDocument(xmlStr);
		String sDate = xmlRes.getElementsByTagName("STARTDATETIME").item(0).getTextContent().trim();
		String eDate = xmlRes.getElementsByTagName("ENDDATETIME").item(0).getTextContent().trim();
		String app = xmlRes.getElementsByTagName("APP").item(0).getTextContent().trim();
			
		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			
		String scheRs = getScheduleList(ownerID, companyID, groupID, gubun, sDate, eDate, pType, pWriterName, pWriterDept, tenantID, offset);
		logger.debug("getScheduleList="+scheRs);
		Document scheRSDom = commonUtil.convertStringToDocument(scheRs);

		returnStr.append("<root>");
			
		for (int i=0; i<scheRSDom.getElementsByTagName("ROW").getLength(); i++) {
			String num = scheRSDom.getElementsByTagName("num").item(i).getTextContent();
			String pNum = scheRSDom.getElementsByTagName("pnum").item(i).getTextContent();
			String ownerIDStr = scheRSDom.getElementsByTagName("ownerID").item(i).getTextContent();
			String writerIDStr = scheRSDom.getElementsByTagName("writerID").item(i).getTextContent();
			String title = scheRSDom.getElementsByTagName("title").item(i).getTextContent();
			String loc = scheRSDom.getElementsByTagName("location").item(i).getTextContent();
			String startDateTime = commonUtil.getDateStringInUTC(scheRSDom.getElementsByTagName("startDate").item(i).getTextContent(), offset, false);
			String endDateTime = commonUtil.getDateStringInUTC(scheRSDom.getElementsByTagName("endDate").item(i).getTextContent(), offset, false);
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
					
				returnStr.append("<dtstart>"+EgovDateUtil.convertDate(startDateTime, "yyyy-MM-dd HH:mm:ss", "yyyy-MM-dd HH:mm:ss","")+"</dtstart>");
				returnStr.append("<dtend>"+EgovDateUtil.convertDate(endDateTime, "yyyy-MM-dd HH:mm:ss", "yyyy-MM-dd HH:mm:ss","")+"</dtend>");
				returnStr.append("<alldayevent>"+allDay+"</alldayevent>");
					
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
				returnStr.append("<dtstart>"+EgovDateUtil.convertDate(startDateTime, "yyyy-MM-dd HH:mm:ss", "yyyy-MM-dd HH:mm:ss","")+"</dtstart>");
				returnStr.append("<dtend>"+EgovDateUtil.convertDate(endDateTime, "yyyy-MM-dd HH:mm:ss", "yyyy-MM-dd HH:mm:ss","")+"</dtend>");
				returnStr.append("<dstartTime>"+(format.parse(startDateTime).getHours()*60 +format.parse(startDateTime).getMinutes())+"</dstartTime>");
				returnStr.append("<dendTime>"+(format.parse(endDateTime).getHours()*60 +format.parse(endDateTime).getMinutes())+"</dendTime>");
				returnStr.append("<dsDaytype>"+(int)format.parse(startDateTime).getDay()+"</dsDaytype>");
				returnStr.append("<deDaytype>"+(int)format.parse(endDateTime).getDay()+"</deDaytype>");
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
		logger.debug("returnStr="+returnStr);
		logger.debug("getScheduleXML End");
		return returnStr.toString();
	}
	
	public String getScheduleList(String ownerID, String companyID, String groupID, String gubun, String sDate, String eDate, String pType, String pWriterName, String pWriterDept, int tenantID, String offset) throws Exception {
		logger.debug("getScheduleList Start");
		StringBuilder returnStr = new StringBuilder();
		String reCompanyID = "";
		String reOwnerID = "";
		String reNum = "";
		
		returnStr.append("<DATA>");
		String todayStartStr = eDate + " 23:59:59";
		String todayEndStr = sDate + " 00:00:01";
		
		String returnSchedule = "";
			
		if (pType.equals("")) {
			List<ResGetScheduleListVO> getScheduleList = getScheduleList(ownerID, companyID, commonUtil.getDateStringInUTC(todayStartStr, offset, true), commonUtil.getDateStringInUTC(todayEndStr, offset, true), pWriterName, pWriterDept, tenantID);
			returnSchedule += "<DATA>";
			
			for (ResGetScheduleListVO vo :  getScheduleList) {
				returnSchedule += commonUtil.getQueryResult(vo);
			}
			returnSchedule += "</DATA>";
					
		} else if (pType.equals("MAIN")) {
	
			List<ResGetScheduleListMainVO> getScheduleListMain = getScheduleListMain(ownerID, companyID, commonUtil.getDateStringInUTC(todayStartStr, offset, true), commonUtil.getDateStringInUTC(todayEndStr, offset, true), tenantID);
			returnSchedule += "<DATA>";
			logger.debug("getScheduleListMainSize="+getScheduleListMain.size());
			
			for (ResGetScheduleListMainVO vo :  getScheduleListMain) {
				returnSchedule += commonUtil.getQueryResult(vo);
			}
			returnSchedule += "</DATA>";
		}
		logger.debug("returnSchedule="+returnSchedule);	
		Document returnDom1 = commonUtil.convertStringToDocument(returnSchedule);
				
		if (returnDom1 != null) {
			for (int m=0; m<returnDom1.getElementsByTagName("ROW").getLength(); m++) {
		/*		returnStr.append("<ROW>");
				returnStr.append("<num>"+returnDom1.getElementsByTagName("ROW").item(m).getChildNodes().item(0).getTextContent()+"</num>");
				returnStr.append("<pnum>"+returnDom1.getElementsByTagName("ROW").item(m).getChildNodes().item(1).getTextContent()+"</pnum>");
				returnStr.append("<ownerID>"+returnDom1.getElementsByTagName("ROW").item(m).getChildNodes().item(2).getTextContent()+"</ownerID>");
				returnStr.append("<title><![CDATA["+returnDom1.getElementsByTagName("ROW").item(m).getChildNodes().item(3).getTextContent()+"]]></title>");
				returnStr.append("<location><![CDATA["+returnDom1.getElementsByTagName("ROW").item(m).getChildNodes().item(4).getTextContent()+"]]></location>");
				returnStr.append("<timeDisplay><![CDATA["+returnDom1.getElementsByTagName("ROW").item(m).getChildNodes().item(5).getTextContent()+"]]></timeDisplay>");
				returnStr.append("<startDate>"+returnDom1.getElementsByTagName("ROW").item(m).getChildNodes().item(6).getTextContent()+"</startDate>");
				returnStr.append("<endDate>"+returnDom1.getElementsByTagName("ROW").item(m).getChildNodes().item(7).getTextContent()+"</endDate>");
				returnStr.append("<alertTime>"+returnDom1.getElementsByTagName("ROW").item(m).getChildNodes().item(8).getTextContent()+"</alertTime>");
				returnStr.append("<reFlag>"+returnDom1.getElementsByTagName("ROW").item(m).getChildNodes().item(9).getTextContent()+"</reFlag>");
				returnStr.append("<gresFlag>"+returnDom1.getElementsByTagName("ROW").item(m).getChildNodes().item(10).getTextContent()+"</gresFlag>");
				returnStr.append("<writerID>"+returnDom1.getElementsByTagName("ROW").item(m).getChildNodes().item(11).getTextContent()+"</writerID>");
				returnStr.append("<content><![CDATA["+returnDom1.getElementsByTagName("ROW").item(m).getChildNodes().item(12).getTextContent()+"]]></content>");
				returnStr.append("<importance>"+returnDom1.getElementsByTagName("ROW").item(m).getChildNodes().item(13).getTextContent()+"</importance>");
				returnStr.append("<entryList>"+returnDom1.getElementsByTagName("ROW").item(m).getChildNodes().item(14).getTextContent()+"</entryList>");
				returnStr.append("<allDay>"+returnDom1.getElementsByTagName("ROW").item(m).getChildNodes().item(15).getTextContent()+"</allDay>");
				returnStr.append("<writeDay>"+returnDom1.getElementsByTagName("ROW").item(m).getChildNodes().item(16).getTextContent()+"</writeDay>");
				returnStr.append("<attachFlag>"+returnDom1.getElementsByTagName("ROW").item(m).getChildNodes().item(17).getTextContent()+"</attachFlag>");
				returnStr.append("<characterID>"+returnDom1.getElementsByTagName("ROW").item(m).getChildNodes().item(18).getTextContent()+"</characterID>");
				returnStr.append("<approveFlag>"+returnDom1.getElementsByTagName("ROW").item(m).getChildNodes().item(19).getTextContent()+"</approveFlag>");
				returnStr.append("<owner_nm><![CDATA["+returnDom1.getElementsByTagName("ROW").item(m).getChildNodes().item(20).getTextContent()+"]]></owner_nm>");
				returnStr.append("<dept_name><![CDATA["+returnDom1.getElementsByTagName("ROW").item(m).getChildNodes().item(21).getTextContent()+"]]></dept_name>");
				if (pType.equals("")) {
					returnStr.append("<owner_nm2><![CDATA["+returnDom1.getElementsByTagName("ROW").item(m).getChildNodes().item(21).getTextContent()+"]]></owner_nm2>");
					returnStr.append("<dept_name2><![CDATA["+returnDom1.getElementsByTagName("ROW").item(m).getChildNodes().item(22).getTextContent()+"]]></dept_name2>");
					returnStr.append("<jobtitle><![CDATA["+returnDom1.getElementsByTagName("ROW").item(m).getChildNodes().item(23).getTextContent()+"]]></jobtitle>");
					returnStr.append("<jobtitle2><![CDATA["+returnDom1.getElementsByTagName("ROW").item(m).getChildNodes().item(24).getTextContent()+"]]></jobtitle2>");
				}
				returnStr.append("</ROW>");*/
				returnStr.append("<ROW>");
				returnStr.append("<num>"+returnDom1.getElementsByTagName("NUM").item(m).getTextContent()+"</num>");
				returnStr.append("<pnum>"+returnDom1.getElementsByTagName("PNUM").item(m).getTextContent()+"</pnum>");
				returnStr.append("<ownerID>"+returnDom1.getElementsByTagName("OWNERID").item(m).getTextContent()+"</ownerID>");
				returnStr.append("<title><![CDATA["+returnDom1.getElementsByTagName("TITLE").item(m).getTextContent()+"]]></title>");
				returnStr.append("<location><![CDATA["+returnDom1.getElementsByTagName("LOCATION").item(m).getTextContent()+"]]></location>");
				returnStr.append("<timeDisplay><![CDATA["+returnDom1.getElementsByTagName("TIMEDISPLAY").item(m).getTextContent()+"]]></timeDisplay>");
				returnStr.append("<startDate>"+returnDom1.getElementsByTagName("STARTDATE").item(m).getTextContent()+"</startDate>");
				returnStr.append("<endDate>"+returnDom1.getElementsByTagName("ENDDATE").item(m).getTextContent()+"</endDate>");
				returnStr.append("<alertTime>"+returnDom1.getElementsByTagName("ALERTTIME").item(m).getTextContent()+"</alertTime>");
				returnStr.append("<reFlag>"+returnDom1.getElementsByTagName("REFLAG").item(m).getTextContent()+"</reFlag>");
				returnStr.append("<gresFlag>"+returnDom1.getElementsByTagName("GRESFLAG").item(m).getTextContent()+"</gresFlag>");
				returnStr.append("<writerID>"+returnDom1.getElementsByTagName("WRITERID").item(m).getTextContent()+"</writerID>");
				returnStr.append("<content><![CDATA["+returnDom1.getElementsByTagName("CONTENT").item(m).getTextContent()+"]]></content>");
				returnStr.append("<importance>"+returnDom1.getElementsByTagName("IMPORTANCE").item(m).getTextContent()+"</importance>");
				returnStr.append("<entryList>"+returnDom1.getElementsByTagName("ENTRYLIST").item(m).getTextContent()+"</entryList>");
				returnStr.append("<allDay>"+returnDom1.getElementsByTagName("ALLDAY").item(m).getTextContent()+"</allDay>");
				returnStr.append("<writeDay>"+returnDom1.getElementsByTagName("WRITEDAY").item(m).getTextContent()+"</writeDay>");
				returnStr.append("<attachFlag>"+returnDom1.getElementsByTagName("ATTACHFLAG").item(m).getTextContent()+"</attachFlag>");
				returnStr.append("<characterID>"+returnDom1.getElementsByTagName("CHARACTERID").item(m).getTextContent()+"</characterID>");
				returnStr.append("<approveFlag>"+returnDom1.getElementsByTagName("APPROVEFLAG").item(m).getTextContent()+"</approveFlag>");
				returnStr.append("<owner_nm><![CDATA["+returnDom1.getElementsByTagName("OWNERNM").item(m).getTextContent()+"]]></owner_nm>");
				returnStr.append("<dept_name><![CDATA["+returnDom1.getElementsByTagName("DEPTNM").item(m).getTextContent()+"]]></dept_name>");
				if (pType.equals("")) {
					returnStr.append("<owner_nm2><![CDATA["+returnDom1.getElementsByTagName("OWNERNM2").item(m).getTextContent()+"]]></owner_nm2>");
					returnStr.append("<dept_name2><![CDATA["+returnDom1.getElementsByTagName("DEPTNM2").item(m).getTextContent()+"]]></dept_name2>");
					returnStr.append("<jobtitle><![CDATA["+returnDom1.getElementsByTagName("JOBTITLE").item(m).getTextContent()+"]]></jobtitle>");
					returnStr.append("<jobtitle2><![CDATA["+returnDom1.getElementsByTagName("JOBTITLE2").item(m).getTextContent()+"]]></jobtitle2>");
				}
				returnStr.append("</ROW>");
				
			}
		}

			
		String returnRepetition = "";
			
		if (pType.equals("")) {
			List<ResGetScheduleListRepetitionVO> getScheduleListRept= getScheduleListRepetiti(ownerID, companyID, todayStartStr, todayEndStr, pWriterName, pWriterDept, tenantID);
			returnRepetition = "<DATA>";
			for(int j=0; j<getScheduleListRept.size(); j++) {
				returnRepetition += commonUtil.getQueryResult(getScheduleListRept.get(j));
			}
			returnRepetition += "</DATA>";
		} else {
			List<ResGetScheduleListMainVO> getScheduleListReptMain = getScheduleListRepetitim(ownerID, companyID, todayStartStr, tenantID);

			returnRepetition = "<DATA>";
			for(int j=0; j<getScheduleListReptMain.size(); j++) {
				returnRepetition += commonUtil.getQueryResult(getScheduleListReptMain.get(j));
			}
			returnRepetition += "</DATA>";
		}

		Document returnRepetitionDom = commonUtil.convertStringToDocument(returnRepetition);

		if (returnRepetitionDom != null) {
			logger.debug("returnRepetitionDom="+returnRepetition);
			for (int i=0; i<returnRepetitionDom.getElementsByTagName("ROW").getLength(); i++) {
				 reCompanyID = returnRepetitionDom.getElementsByTagName("COMPANYID").item(i).getTextContent();
				 reNum = returnRepetitionDom.getElementsByTagName("NUM").item(i).getTextContent();
				 reOwnerID = returnRepetitionDom.getElementsByTagName("OWNERID").item(i).getTextContent();
				
				String returnRepDateTimes = getRepDeteTimes(reCompanyID, reNum, reOwnerID, sDate, eDate, tenantID, offset);
				logger.debug("getRepDeteTimes="+returnRepDateTimes);
					
				if (returnRepDateTimes != null && !returnRepDateTimes.trim().equals("")) {
					Document returnRepDateTimesDom = commonUtil.convertStringToDocument(returnRepDateTimes);

					for (int j=0; j<returnRepDateTimesDom.getElementsByTagName("f_sDate").getLength(); j++) {

						String fSDate = returnRepDateTimesDom.getElementsByTagName("f_sDate").item(j).getTextContent().substring(0, 10);
						String fEDate = returnRepDateTimesDom.getElementsByTagName("f_eDate").item(j).getTextContent().substring(0, 10);
						
						ResGetScheduleListTermVO getScheduleListTerm = getScheduleListTerm(Integer.parseInt(reNum), companyID, reOwnerID, fSDate.substring(0,  10)+" 23:59:59", fEDate, pWriterName, pWriterDept, tenantID);
							
						if (getScheduleListTerm != null) {
							if (!getScheduleListTerm.getReFlag().equals("4")) {
								String reStartDate = getScheduleListTerm.getStartDate().substring(11, 19);
								String reEndDate = getScheduleListTerm.getEndDate().substring(11, 19);
									
								String reSDate = fSDate + reStartDate;
								String reEDate = fEDate + reEndDate;
									
								returnStr.append("<ROW>");
								returnStr.append("<num>" + getScheduleListTerm.getNum() + "</num>");
								returnStr.append("<pnum>" + getScheduleListTerm.getpNum() + "</pnum>");
								returnStr.append("<ownerID>" + getScheduleListTerm.getOwnerID() + "</ownerID>");
								returnStr.append("<title><![CDATA[" + getScheduleListTerm.getTitle() + "]]></title>");
								returnStr.append("<location><![CDATA[" + getScheduleListTerm.getLocation() + "]]></location>");
								returnStr.append("<timeDisplay><![CDATA[" + getScheduleListTerm.getTimeDisplay() + "]]></timeDisplay>");
								returnStr.append("<startDate>" + reSDate + "</startDate>");
								returnStr.append("<endDate>" + reEDate + "</endDate>");
								returnStr.append("<alertTime>" + getScheduleListTerm.getAlertTime() + "</alertTime>");
								returnStr.append("<reFlag>" + getScheduleListTerm.getReFlag() + "</reFlag>");
								returnStr.append("<gresFlag>" + getScheduleListTerm.getgResFlag() + "</gresFlag>");
								returnStr.append("<writerID>" + getScheduleListTerm.getWriterID() + "</writerID>");
								returnStr.append("<content><![CDATA[" + getScheduleListTerm.getContent() + "]]></content>");
								returnStr.append("<importance>" + getScheduleListTerm.getImportance() + "</importance>");
								returnStr.append("<entryList>" + getScheduleListTerm.getEntryList() + "</entryList>");
								returnStr.append("<allDay>" + getScheduleListTerm.getAllDay() + "</allDay>");
								returnStr.append("<writeDay>" + getScheduleListTerm.getWriteDay() + "</writeDay>");
								returnStr.append("<attachFlag>" + getScheduleListTerm.getAttachFlag() + "</attachFlag>");
								returnStr.append("<characterID>" + getScheduleListTerm.getCharacterID() + "</characterID>");
								returnStr.append("<approveFlag>" + getScheduleListTerm.getApproveFlag() + "</approveFlag>");
								returnStr.append("<owner_nm><![CDATA[" + getScheduleListTerm.getOwnerNm() + "]]></owner_nm>");
								returnStr.append("<dept_name><![CDATA[" + getScheduleListTerm.getDeptNm() + "]]></dept_name>");
									
								if (pType.equals("") || pType == null) {
									returnStr.append("<jobtitle><![CDATA[" + getScheduleListTerm.getJobTitle() + "]]></jobtitle>");
									returnStr.append("<jobtitle2><![CDATA[" + getScheduleListTerm.getJobTitle2() + "]]></jobtitle2>");
								}
								returnStr.append("</ROW>");
							}
						} else {
							returnStr.append("<ROW>");
							returnStr.append("<num>" + returnRepetitionDom.getElementsByTagName("NUM").item(i).getTextContent() + "</num>");
							returnStr.append("<pnum>" + returnRepetitionDom.getElementsByTagName("PNUM").item(i).getTextContent() + "</pnum>");
							returnStr.append("<ownerID>" + returnRepetitionDom.getElementsByTagName("OWNERID").item(i).getTextContent() + "</ownerID>");
							returnStr.append("<title><![CDATA[" + returnRepetitionDom.getElementsByTagName("TITLE").item(i).getTextContent() + "]]></title>");
							returnStr.append("<location><![CDATA[" + returnRepetitionDom.getElementsByTagName("LOCATION").item(i).getTextContent() + "]]></location>");
							returnStr.append("<timeDisplay><![CDATA[" + returnRepetitionDom.getElementsByTagName("TIMEDISPLAY").item(i).getTextContent() + "]]></timeDisplay>");
							returnStr.append("<startDate>" + returnRepDateTimesDom.getElementsByTagName("f_sDate").item(j).getTextContent() + "</startDate>");
							returnStr.append("<endDate>" + returnRepDateTimesDom.getElementsByTagName("f_eDate").item(j).getTextContent() + "</endDate>");
							returnStr.append("<alertTime>" + returnRepetitionDom.getElementsByTagName("ALERTTIME").item(i).getTextContent() + "</alertTime>");
							returnStr.append("<reFlag>" + returnRepetitionDom.getElementsByTagName("REFLAG").item(i).getTextContent() + "</reFlag>");
							returnStr.append("<gresFlag>" + returnRepetitionDom.getElementsByTagName("GRESFLAG").item(i).getTextContent() + "</gresFlag>");
							returnStr.append("<writerID>" + returnRepetitionDom.getElementsByTagName("WRITERID").item(i).getTextContent() + "</writerID>");
							returnStr.append("<content><![CDATA[" + returnRepetitionDom.getElementsByTagName("CONTENT").item(i).getTextContent() + "]]></content>");
							returnStr.append("<importance>" + returnRepetitionDom.getElementsByTagName("IMPORTANCE").item(i).getTextContent() + "</importance>");
							returnStr.append("<entryList>" + returnRepetitionDom.getElementsByTagName("ENTRYLIST").item(i).getTextContent() + "</entryList>");
							returnStr.append("<allDay>" + returnRepetitionDom.getElementsByTagName("ALLDAY").item(i).getTextContent() + "</allDay>");
							returnStr.append("<writeDay>" + returnRepetitionDom.getElementsByTagName("WRITEDAY").item(i).getTextContent() + "</writeDay>");
							returnStr.append("<attachFlag>" + returnRepetitionDom.getElementsByTagName("ATTACHFLAG").item(i).getTextContent() + "</attachFlag>");
							returnStr.append("<characterID>" + returnRepetitionDom.getElementsByTagName("CHARACTERID").item(i).getTextContent() + "</characterID>");
							returnStr.append("<approveFlag>" + returnRepetitionDom.getElementsByTagName("APPROVEFLAG").item(i).getTextContent() + "</approveFlag>");
							returnStr.append("<owner_nm><![CDATA[" + returnRepetitionDom.getElementsByTagName("OWNERNM").item(i).getTextContent() + "]]></owner_nm>");
							returnStr.append("<dept_name><![CDATA[" + returnRepetitionDom.getElementsByTagName("DEPTNM").item(i).getTextContent() + "]]></dept_name>");
							if (pType.equals("") || pType == null) {
								returnStr.append("<owner_nm2><![CDATA[" + returnRepetitionDom.getElementsByTagName("OWNERNM2").item(i).getTextContent() + "]]></owner_nm2>");
								returnStr.append("<dept_name2><![CDATA[" + returnRepetitionDom.getElementsByTagName("DEPTNM2").item(i).getTextContent() + "]]></dept_name2>");
								returnStr.append("<jobtitle><![CDATA[" + returnRepetitionDom.getElementsByTagName("JOBTITLE").item(i).getTextContent() + "]]></jobtitle>");
								returnStr.append("<jobtitle2><![CDATA[" + returnRepetitionDom.getElementsByTagName("JOBTITLE2").item(i).getTextContent() + "]]></jobtitle2>");
							}
							returnStr.append("</ROW>");
						}
					}
				}
			}
		}
		returnStr.append("</DATA>");
		logger.debug("returnStr="+returnStr.toString());
		logger.debug("getScheduleList End");
		return returnStr.toString();
	}
	
	public String getRepDeteTimes(String companyID, String num, String ownerID, String sDate, String eDate, int tenantID, String offset) throws Exception {
		logger.debug("getRepDeteTimes started");

		String returnStr = "";
		
		logger.debug("ownerID="+ownerID);
		logger.debug("companyID="+companyID);
		logger.debug("num="+num);
		ResGetRepDateTimesVO getRepDateTimes = getRepDateTimes(ownerID, companyID, Integer.parseInt(num), tenantID);
		logger.debug("getRepDateTimes="+getRepDateTimes);
		if (getRepDateTimes != null) {
			String startDateTime = getRepDateTimes.getStartDateTime();
			String endDateTime = getRepDateTimes.getEndDateTime();
			
			startDateTime = EgovDateUtil.convertDate(startDateTime, "yyyy-MM-dd HH:mm:ss", "yyyy-MM-dd HH:mm:ss", "");
			endDateTime = EgovDateUtil.convertDate(endDateTime, "yyyy-MM-dd HH:mm:ss", "yyyy-MM-dd HH:mm:ss", "");
			String reWay = getRepDateTimes.getReWay();
			String reDay = getRepDateTimes.getReDay();
			String reNum = getRepDateTimes.getReNum();
			String reYoil = getRepDateTimes.getReYoil();
			String reMonth = getRepDateTimes.getReMonth();
			String reOrd = getRepDateTimes.getReOrd();
			String endFlag = getRepDateTimes.getEndFlag();
			String reCount = getRepDateTimes.getReCount();
			String freq = reWay.substring(0, 1);
			String sel = reWay.substring(reWay.length()-1, reWay.length());
				
			if (reNum.equals("Null") || reNum.equals("NULL")) {
				reNum = "";
			}
			if (reYoil.equals("Null") || reYoil.equals("NULL")) {
				reYoil = "";
			}
			if (reDay.equals("Null") || reDay.equals("NULL")) {
				reDay = "";
			}
			if (reMonth.equals("Null") || reMonth.equals("NULL")) {
				reMonth = "";
			}
			if (reCount.equals("Null") || reCount.equals("NULL")) {
				reCount = "";
			}
			
			StringBuilder reXMLStr = new StringBuilder();
			reXMLStr.append("<recurrence>");
			reXMLStr.append("<frequency>"+freq+"</frequency>");
			reXMLStr.append("<selType>"+sel+"</selType>");
			reXMLStr.append("<endRecurType>"+endFlag+"</endRecurType>");
			reXMLStr.append("<startDateTime>"+startDateTime+"</startDateTime>");
			reXMLStr.append("<endDateTime>"+endDateTime+"</endDateTime>");
			reXMLStr.append("<interval>"+reNum+"</interval>");
			reXMLStr.append("<daysOfWeek>"+reYoil+"</daysOfWeek>");
			reXMLStr.append("<daysOfMonth>"+reDay+"</daysOfMonth>");
			reXMLStr.append("<byPosition>"+reOrd+"</byPosition>");
			reXMLStr.append("<monthsOfYear>"+reMonth+"</monthsOfYear>");
			reXMLStr.append("<instances>"+reCount+"</instances>");
			reXMLStr.append("</recurrence>");
	
			if (freq.equals("4")) {
				returnStr = getDailyRepDateTimes(reXMLStr.toString(), sDate, eDate); 
			} else if (freq.equals("5")) {
				returnStr = getWeeklyRepDateTime(reXMLStr.toString(), sDate, eDate);
			} else if (freq.equals("6")) {
				returnStr = getMonthlyRepDateTimes(reXMLStr.toString(), sDate, eDate);
			} else if (freq.equals("7")) {
				returnStr = getYearlyRepDateTimes(reXMLStr.toString(), sDate, eDate);
			}
		}
	
		logger.debug("getRepDeteTimes="+returnStr.toString());
		logger.debug("getRepDeteTimes ended");
		return returnStr.toString();
	}
	
	public String getDailyRepDateTimes(String xmlStr, String sDate, String eDate) throws Exception {
		StringBuilder returnXML = new StringBuilder();
		
		
		Document xmlRes = commonUtil.convertStringToDocument(xmlStr);
		String selType = xmlRes.getElementsByTagName("selType").item(0).getTextContent().trim();
		String startDateTime = xmlRes.getElementsByTagName("startDateTime").item(0).getTextContent().trim();
		String endDateTime = xmlRes.getElementsByTagName("endDateTime").item(0).getTextContent().trim();
		String interval2 = xmlRes.getElementsByTagName("interval").item(0).getTextContent().trim();
		int interval = Integer.parseInt(interval2);
		String endRecurType = xmlRes.getElementsByTagName("endRecurType").item(0).getTextContent().trim();
		String instances = xmlRes.getElementsByTagName("instances").item(0).getTextContent().trim();
			
		String tmpSTime = startDateTime.substring(11, 19);
		String tmpETime = endDateTime.substring(11, 19);
	
		String tmpDTStr = startDateTime.substring(0, 10);
		String tmpEDTStr = endDateTime.substring(0, 10);
			
		String tmpSDTStr = tmpDTStr;
		String tmpEDTStr1 = tmpEDTStr;
			
		if (number(tmpSTime) > number(tmpETime)) {
			startDateTime = EgovDateUtil.convertDate(EgovDateUtil.addDay(startDateTime, 1, "yyyy-MM-dd HH:mm:ss"), "yyyy-MM-dd HH:mm:ss", "yyyy-MM-dd HH:mm:ss", "");
			tmpSDTStr = startDateTime.substring(0, 10);
		}
			
		String orgTmpDTStr = tmpDTStr;
		int n = 1;
			
		returnXML.append("<DATA>");
			
		int temp = 0;
		boolean whileFlag = true;
		while (whileFlag) {
			if (selType.equals("0")) {
				if (endRecurType.equals("0")) {
					if (number(tmpDTStr) > number(eDate)) {
						break;
					} else {
						if (number(tmpDTStr) >= number(sDate) && number(tmpDTStr) >= number(orgTmpDTStr)) {
							returnXML.append("<ROW>");
							returnXML.append("<f_sDate>" + tmpDTStr + " " + tmpSTime + "</f_sDate>");
							returnXML.append("<f_eDate>" + tmpSDTStr + " " + tmpETime + "</f_eDate>");
							returnXML.append("</ROW>");
						}
					}
				} else if (endRecurType.equals("1")) {
					if (number(tmpDTStr) > number(eDate) || n > number(instances)) {
						break;
					} else {
						if (number(tmpDTStr) >= number(sDate) && number(tmpDTStr) >= number(orgTmpDTStr)) {
							returnXML.append("<ROW>");
							returnXML.append("<f_sDate>" + tmpDTStr + " " + tmpSTime + "</f_sDate>");
							returnXML.append("<f_eDate>" + tmpSDTStr + " " + tmpETime + "</f_eDate>");
							returnXML.append("</ROW>");
						}
						
						if (number(tmpDTStr) >= number(orgTmpDTStr)) {
							n = n+1;
						}
					}
				} else if (endRecurType.equals("2")) {
					if (number(tmpDTStr) > number(eDate) || number(tmpDTStr) >= number(orgTmpDTStr) && number(tmpSDTStr) <= number(tmpEDTStr1)) {
						returnXML.append("<ROW>");
						returnXML.append("<f_sDate>" + tmpDTStr + " " + tmpSTime + "</f_sDate>");
						returnXML.append("<f_eDate>" + tmpSDTStr + " " + tmpETime + "</f_eDate>");
						returnXML.append("</ROW>");
					}
				}
				tmpDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpDTStr, interval, "yyyy-MM-dd"), "yyyy-MM-dd", "yyyy-MM-dd", "");
				tmpSDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpSDTStr, interval, "yyyy-MM-dd"), "yyyy-MM-dd", "yyyy-MM-dd", "");
			} else {
				if (endRecurType.equals("0")) {
					if (number(tmpDTStr) > number(eDate)) {
						break;
					} else if (weekDay(tmpDTStr) > 1 && weekDay(tmpDTStr) < 7) {
						if (number(tmpDTStr) >= number(sDate) && number(tmpDTStr) >= number(orgTmpDTStr)) {
							returnXML.append("<ROW>");
							returnXML.append("<f_sDate>" + tmpDTStr + " " + tmpSTime + "</f_sDate>");
							returnXML.append("<f_eDate>" + tmpSDTStr + " " + tmpETime + "</f_eDate>");
							returnXML.append("</ROW>");
						}
					}
				} else if (endRecurType.equals("1")) {
					if (number(tmpDTStr) > number(eDate) || n > number(instances)) {
						break;
					} else if (weekDay(tmpDTStr) > 1 && weekDay(tmpDTStr) < 7) {
						if (number(tmpDTStr) >= number(sDate) && number(tmpDTStr) >= number(orgTmpDTStr)) {
							returnXML.append("<ROW>");
							returnXML.append("<f_sDate>" + tmpDTStr + " " + tmpSTime + "</f_sDate>");
							returnXML.append("<f_eDate>" + tmpSDTStr + " " + tmpETime + "</f_eDate>");
							returnXML.append("</ROW>");
						}
							
						if (number(tmpDTStr) >= number(orgTmpDTStr)) {
							n = n+1;
						}
					}
				} else if (endRecurType.equals("2")) {
					if (number(tmpDTStr) > number(eDate) || number(tmpDTStr) > number(tmpEDTStr)) {
						break;
					} else if (weekDay(tmpDTStr) > 1 && weekDay(tmpDTStr) < 7) {
						if (number(tmpDTStr) >= number(sDate) && number(tmpDTStr) >= number(orgTmpDTStr) && number(tmpSDTStr) <= number(tmpEDTStr1)) {
							returnXML.append("<ROW>");
							returnXML.append("<f_sDate>" + tmpDTStr + " " + tmpSTime + "</f_sDate>");
							returnXML.append("<f_eDate>" + tmpSDTStr + " " + tmpETime + "</f_eDate>");
							returnXML.append("</ROW>");
						}
					}
				}

				tmpDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpDTStr, 1, "yyyy-MM-dd"), "yyyy-MM-dd", "yyyy-MM-dd", "");
				tmpSDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpSDTStr, 1, "yyyy-MM-dd"), "yyyy-MM-dd", "yyyy-MM-dd", "");
			}
			temp++;
			if (temp > 1000) {
				break;
			}
		}
		returnXML.append("</DATA>");
		
		return returnXML.toString();
	}
	
	public String getWeeklyRepDateTime (String xmlStr, String sDate, String eDate) throws Exception  {
		StringBuilder returnXML = new StringBuilder();
		
		
		Document xmlRes = commonUtil.convertStringToDocument(xmlStr);
			
		String startDateTime = xmlRes.getElementsByTagName("startDateTime").item(0).getTextContent().trim();
		String endDateTime = xmlRes.getElementsByTagName("endDateTime").item(0).getTextContent().trim();
		String interval2 = xmlRes.getElementsByTagName("interval").item(0).getTextContent().trim();
		int interval = Integer.parseInt(interval2);
		String daysOfWeek = xmlRes.getElementsByTagName("daysOfWeek").item(0).getTextContent().trim();

		String endRecurType = xmlRes.getElementsByTagName("endRecurType").item(0).getTextContent().trim();
		String instances = xmlRes.getElementsByTagName("instances").item(0).getTextContent().trim();
			
		String tmpSTime = startDateTime.substring(11, 19);
		String tmpETime = endDateTime.substring(11, 19);
			
		String tmpDTStr = startDateTime.substring(0, 10);
		String tmpEDTStr = endDateTime.substring(0, 10);
			
		String tmpSDTStr = tmpDTStr;
		String tmpEDTStr1 = tmpEDTStr;

		if (number(tmpSTime) > number(tmpETime)) {
			startDateTime = EgovDateUtil.convertDate(EgovDateUtil.addDay(startDateTime, 1, "yyyy-MM-dd HH:mm:ss"), "yyyy-MM-dd HH:mm:ss", "yyyy-MM-dd HH:mm:ss", "");
			tmpSDTStr = startDateTime.substring(0, 10);
		}
			
		boolean isFirst = true;
		String orgTmpDTStr = tmpDTStr;
		String selDTStr = "";
		int temp = 0;
		int temp2 = 0;
		int n = 1;
		String[] wDay;
		wDay = daysOfWeek.split(",");
		int wDayCnt = wDay.length;

		returnXML.append("<DATA>");
			
		boolean whileFlag = true;
		while (whileFlag) {
			selDTStr = tmpDTStr;
			boolean secondWhileFlag = true;
			while (secondWhileFlag == true) {
				for (int i=0; i<wDayCnt; i++) {
					if (wDay[i].equals("")) {
						wDay[i] = "0";
					}
					if (orgTmpDTStr.equals(selDTStr) && weekDay(tmpDTStr) == Integer.parseInt(wDay[i]) + 1 && isFirst == true) {
						isFirst = false;
						secondWhileFlag = false;
						break;
					} else if (weekDay(tmpDTStr) < Integer.parseInt(wDay[i]) + 1 || !selDTStr.equals(tmpDTStr)) {

						int tmpWeekDay = weekDay(tmpDTStr);
						tmpDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpDTStr, Integer.parseInt(wDay[i]) + 1 - weekDay(tmpDTStr), "yyyy-MM-dd"), "yyyy-MM-dd", "yyyy-MM-dd", "");
						tmpEDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpEDTStr, Integer.parseInt(wDay[i] ) + 1 - tmpWeekDay, "yyyy-MM-dd"), "yyyy-MM-dd", "yyyy-MM-dd", "");
						tmpSDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpSDTStr, Integer.parseInt(wDay[i] ) + 1 - tmpWeekDay, "yyyy-MM-dd"), "yyyy-MM-dd", "yyyy-MM-dd", "");
							
						secondWhileFlag = false;
						break;
					}
				}
				if (secondWhileFlag == false) {
					break;
				}
				tmpDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpDTStr, (interval * 7), "yyyy-MM-dd"), "yyyy-MM-dd", "yyyy-MM-dd", "");
				tmpEDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpEDTStr, (interval * 7), "yyyy-MM-dd"), "yyyy-MM-dd", "yyyy-MM-dd", "");
				tmpSDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpSDTStr, (interval * 7), "yyyy-MM-dd"), "yyyy-MM-dd", "yyyy-MM-dd", "");
					
				if (weekDay(tmpDTStr) != 1) {

					int tmpWeekDay = weekDay(tmpDTStr);
						
					tmpDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpDTStr, (1- weekDay(tmpDTStr)), "yyyy-MM-dd"), "yyyy-MM-dd", "yyyy-MM-dd", "");
					tmpEDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpEDTStr, (1 - tmpWeekDay), "yyyy-MM-dd"), "yyyy-MM-dd", "yyyy-MM-dd", "");
					tmpSDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpSDTStr, (1 - tmpWeekDay), "yyyy-MM-dd"), "yyyy-MM-dd", "yyyy-MM-dd", "");
				}
				for (int i=0; i<wDayCnt; i++) {
					if (wDay[i].equals("")) {
						wDay[i] = "0";
					}


					if (weekDay(tmpDTStr) != (Integer.parseInt(wDay[i]) + 1)) {

						int tmpWeekDay = weekDay(tmpDTStr);
							
						tmpDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpDTStr, Integer.parseInt(wDay[i]) + 1 - weekDay(tmpDTStr), "yyyy-MM-dd"), "yyyy-MM-dd", "yyyy-MM-dd", "");
						tmpEDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpEDTStr, Integer.parseInt(wDay[i]) + 1 - tmpWeekDay, "yyyy-MM-dd"), "yyyy-MM-dd", "yyyy-MM-dd", "");
						tmpSDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpSDTStr, Integer.parseInt(wDay[i]) + 1 - tmpWeekDay, "yyyy-MM-dd"), "yyyy-MM-dd", "yyyy-MM-dd", "");
					}
				}
				temp2 ++;
				if (temp2 > 1000) {
					break;
				}
			}

				
			if (endRecurType.equals("0")) {
				if (number(tmpDTStr) > number(eDate)) {
					break;
				} else {
					if (number(tmpDTStr) >= number(sDate) && number(tmpDTStr) >= number(orgTmpDTStr)) {
						returnXML.append("<ROW>");
						returnXML.append("<f_sDate>" + tmpDTStr + " " + tmpSTime + "</f_sDate>");
						returnXML.append("<f_eDate>" + tmpDTStr + " " + tmpETime + "</f_eDate>");
						returnXML.append("</ROW>");

					}
				}
			} else if (endRecurType.equals("1")) {
				if (number(tmpDTStr) > number(eDate) || n > number(instances) * (wDayCnt)) {
					break;
				} else {
					if (number(tmpDTStr) >= number(sDate) && number(tmpDTStr) >= number(orgTmpDTStr)) {
						returnXML.append("<ROW>");
						returnXML.append("<f_sDate>" + tmpDTStr + " " + tmpSTime + "</f_sDate>");
						returnXML.append("<f_eDate>" + tmpDTStr + " " + tmpETime + "</f_eDate>");
						returnXML.append("</ROW>");
					}
						
					if (number(tmpDTStr) >= number(orgTmpDTStr)) {
						n = n +1;
					}
				}
			} else if (endRecurType.equals("2")) {
				if (number(tmpDTStr) > number(eDate) || number(tmpDTStr) > number(tmpEDTStr)) {
					break;
				} else  {
					if ((number(tmpDTStr) >= number(sDate) && number(tmpDTStr) >= number(orgTmpDTStr) && number(tmpSDTStr) <= number(tmpEDTStr1))) {
						returnXML.append("<ROW>");
						returnXML.append("<f_sDate>" + tmpDTStr + " " + tmpSTime + "</f_sDate>");
						returnXML.append("<f_eDate>" + tmpSDTStr + " " + tmpETime + "</f_eDate>");
						returnXML.append("</ROW>");
					}
				}
			}
			temp++;
			if (temp > 1000) {
				break;
			}
		}
		returnXML.append("</DATA>");

		return returnXML.toString();
	}
	
	@SuppressWarnings("deprecation")
	public String getMonthlyRepDateTimes(String xmlStr, String sDate, String eDate) throws Exception {
		logger.debug("getMonthlyRepDateTimes Start");
		logger.debug("xmlStr="+xmlStr);
		StringBuilder returnXML = new StringBuilder();
		
		Document xmlRes = commonUtil.convertStringToDocument(xmlStr);
		
		String selType = xmlRes.getElementsByTagName("selType").item(0).getTextContent().trim();
		String startDateTime = xmlRes.getElementsByTagName("startDateTime").item(0).getTextContent().trim();
		String endDateTime = xmlRes.getElementsByTagName("endDateTime").item(0).getTextContent().trim();
		String interval2 = xmlRes.getElementsByTagName("interval").item(0).getTextContent().trim();
		int interval = Integer.parseInt(interval2);
		String daysOfWeek = xmlRes.getElementsByTagName("daysOfWeek").item(0).getTextContent().trim();
		if (daysOfWeek.equals("")) {
			daysOfWeek = "0";
		}
		String daysOfMonth = xmlRes.getElementsByTagName("daysOfMonth").item(0).getTextContent().trim();
		String byPosition = xmlRes.getElementsByTagName("byPosition").item(0).getTextContent().trim();
		String endRecurType = xmlRes.getElementsByTagName("endRecurType").item(0).getTextContent().trim();
		String instances = xmlRes.getElementsByTagName("instances").item(0).getTextContent().trim();
		String[] wDay = daysOfWeek.split(",");
		String tmpSTime = startDateTime.substring(11, 19);
		String tmpETime = endDateTime.substring(11, 19);
		String tmpDTStr = startDateTime.substring(0, 10);
		String tmpEDTStr = endDateTime.substring(0, 10);
		String tmpSDTStr = tmpDTStr;
		String tmpEDTStr1 = tmpEDTStr;
		
		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");

		if (number(tmpSTime) > number(tmpETime)) {
			startDateTime = EgovDateUtil.convertDate(EgovDateUtil.addDay(startDateTime, 1, "yyyy-MM-dd HH:mm:ss"), "yyyy-MM-dd HH:mm:ss", "yyyy-MM-dd HH:mm:ss", "");
			tmpSDTStr = startDateTime.substring(0, 10);
		}
		String orgtmpDTStr = tmpDTStr;
		int n = 1;
		returnXML.append("<DATA>");
		
		int temp = 0;
		boolean whileFlag = true;
		while(whileFlag) {
			int wDayCnt = wDay.length;
			if (wDayCnt != 0) {
				wDayCnt = wDayCnt - 1;
			}
			if (daysOfWeek.indexOf(",") < 0) {
				wDayCnt = 0;
			}
			logger.debug("selType="+selType);
			if (selType.equals("0")) {
				int datePartDay = format.parse(tmpDTStr).getDate();
				int datePartMonth = format.parse(tmpDTStr).getMonth()+1;
				int datePartYear = format.parse(tmpDTStr).getYear();
				boolean checkLastDate = true;
				logger.debug("datePartMonth="+datePartMonth);
				if (daysOfMonth.equals("31") && (datePartMonth == 2 || datePartMonth == 4 || datePartMonth == 6 || datePartMonth == 9 || datePartMonth == 11)) {
					checkLastDate = false;
				} else if (daysOfMonth.equals("30") && datePartMonth == 2) {
					checkLastDate = false;
				} else if (daysOfMonth.equals("29") && datePartMonth == 2 && !(datePartYear % 4 == 0 && datePartYear % 100 != 0 || datePartYear % 400 == 0)) {
					checkLastDate = false;
				}
				
				if (checkLastDate) {
					tmpDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpDTStr, Integer.parseInt(daysOfMonth) - datePartDay, "yyyy-MM-dd"), "yyyy-MM-dd", "yyyy-MM-dd", "");
					tmpEDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpEDTStr, Integer.parseInt(daysOfMonth) - datePartDay, "yyyy-MM-dd"), "yyyy-MM-dd", "yyyy-MM-dd", "");
					tmpSDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpSDTStr, Integer.parseInt(daysOfMonth) - datePartDay, "yyyy-MM-dd"), "yyyy-MM-dd", "yyyy-MM-dd", "");
					
					if (endRecurType.equals("0")) {
						if (number(tmpDTStr) > number(eDate)) {
							break;
						} else {
							if (number(tmpDTStr) >= number(sDate) && number(tmpDTStr) >= number(orgtmpDTStr)) {
								returnXML.append("<ROW>");
								returnXML.append("<f_sDate>" + tmpDTStr + " " + tmpSTime + "</f_sDate>");
								returnXML.append("<f_eDate>" + tmpDTStr + " " + tmpETime + "</f_eDate>");
								returnXML.append("</ROW>");
							}
						}
					} else if (endRecurType.equals("1")) {
						if (number(tmpDTStr) > number(eDate) || n > number(instances)) {
							break;
						} else {
							if (number(tmpDTStr) >= number(sDate) && number(tmpDTStr) >= number(orgtmpDTStr)) {
								returnXML.append("<ROW>");
								returnXML.append("<f_sDate>" + tmpDTStr + " " + tmpSTime + "</f_sDate>");
								returnXML.append("<f_eDate>" + tmpDTStr + " " + tmpETime + "</f_eDate>");
								returnXML.append("</ROW>");
							}
							
							if (number(tmpDTStr) >= number(orgtmpDTStr)) {
								n = n+1;
							}
						}
					} else if (endRecurType.equals("2")) {
						if (number(tmpDTStr) > number(eDate) || number(tmpDTStr) > number(tmpEDTStr)) {
							break;
						} else {
							if (number(tmpDTStr) >= number(sDate) && number(tmpDTStr) >= number(orgtmpDTStr) && number(tmpSDTStr) <= number(tmpEDTStr1)) {
								returnXML.append("<ROW>");
								returnXML.append("<f_sDate>" + tmpDTStr + " " + tmpSTime + "</f_sDate>");
								returnXML.append("<f_eDate>" + tmpSDTStr + " " + tmpETime + "</f_eDate>");
								returnXML.append("</ROW>");
							}
						}
					}
				}
			} else {
				int count = 1;
				int datePartDay = format.parse(tmpDTStr).getDate();
				
				tmpDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpDTStr, 1 - datePartDay, "yyyy-MM-dd"), "yyyy-MM-dd", "yyyy-MM-dd", "");
				tmpEDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpEDTStr, 1 - datePartDay, "yyyy-MM-dd"), "yyyy-MM-dd", "yyyy-MM-dd", "");
				tmpSDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpSDTStr, 1 - datePartDay, "yyyy-MM-dd"), "yyyy-MM-dd", "yyyy-MM-dd", "");
				
				String sTmpDTStr = tmpDTStr;
				
				if (!byPosition.equals("-1")) {
					while (true) {
						if (wDayCnt == 0) {
							if (weekDay(tmpDTStr) == Integer.parseInt(daysOfWeek) + 1) {
								break;
							}
						} else if (wDayCnt == 2) {
							if (weekDay(tmpDTStr) == 7) {
								break;
							}
						} else {
							if (byPosition.equals("1") && weekDay(tmpDTStr) > 2 && weekDay(tmpDTStr) < 7) {
								if (weekDay(tmpDTStr) > 1 && weekDay(tmpDTStr) < 7 && weekDay(tmpDTStr) == 6) {
									break;
								}
							} else {
								if (weekDay(tmpDTStr) > 1 && weekDay(tmpDTStr) < 7 && weekDay(tmpDTStr) == 2) {
									break;
								}
							}
						}
						count ++;
						
						tmpDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpDTStr, 1, "yyyy-MM-dd"), "yyyy-MM-dd", "yyyy-MM-dd", "");
						tmpEDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpEDTStr, 1, "yyyy-MM-dd"), "yyyy-MM-dd", "yyyy-MM-dd", "");
						tmpSDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpSDTStr, 1, "yyyy-MM-dd"), "yyyy-MM-dd", "yyyy-MM-dd", "");
						
					}
					if (byPosition.equals("1") && weekDay(tmpDTStr) > 2 && weekDay(tmpDTStr) < 7 && wDayCnt == 5) {
						tmpDTStr = sTmpDTStr;
						wDayCnt = count;
					}
					logger.debug("byPosition="+byPosition);
					if (!byPosition.equals("1")) {
						if (wDayCnt == 5) {
							logger.debug("getDate="+format.parse(tmpDTStr).getDate());
							if (format.parse(tmpDTStr).getDate() == 1) {
								tmpDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpDTStr, (Integer.parseInt(byPosition) -1) * 7, "yyyy-MM-dd"), "yyyy-MM-dd", "yyyy-MM-dd", "");
							} else {
								if (weekDay(sTmpDTStr) == 1 || weekDay(sTmpDTStr) == 7) {
									tmpDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpDTStr, (Integer.parseInt(byPosition) -1) * 7, "yyyy-MM-dd"), "yyyy-MM-dd", "yyyy-MM-dd", "");
								} else {
									tmpDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpDTStr, (Integer.parseInt(byPosition) -2) * 7, "yyyy-MM-dd"), "yyyy-MM-dd", "yyyy-MM-dd", "");
								}
							}
							logger.debug("tmpDtStr="+tmpDTStr);
						} else {
							tmpDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpDTStr, (Integer.parseInt(byPosition) -1) * 7, "yyyy-MM-dd"), "yyyy-MM-dd", "yyyy-MM-dd", "");
							tmpEDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpEDTStr, (Integer.parseInt(byPosition) -1) * 7, "yyyy-MM-dd"), "yyyy-MM-dd", "yyyy-MM-dd", "");
							tmpSDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpSDTStr, (Integer.parseInt(byPosition) -1) * 7, "yyyy-MM-dd"), "yyyy-MM-dd", "yyyy-MM-dd", "");
							logger.debug("tmpDTStr="+tmpDTStr);
							logger.debug("tmpEDTStr="+tmpEDTStr);
							logger.debug("tmpSDTStr="+tmpSDTStr);
						}
					}
				} else {
					int count1 = 1;
					logger.debug("tmpDTStr2="+tmpDTStr);
					tmpDTStr = EgovDateUtil.convertDate(EgovDateUtil.addMonth(tmpDTStr, 1, "yyyy-MM-dd"), "yyyy-MM-dd", "yyyy-MM-dd", "");
					tmpDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpDTStr, -1, "yyyy-MM-dd"), "yyyy-MM-dd", "yyyy-MM-dd", "");
					logger.debug("tmpDTStr3="+tmpDTStr);
					int tmpWeekDay = weekDay(tmpDTStr);
					
					while (true) {
						if (wDayCnt == 0) {
							if (weekDay(tmpDTStr) == Integer.parseInt(daysOfWeek) + 1) {
								break;
							}
						} else if (wDayCnt == 2) {
							if (weekDay(tmpDTStr) == 7) {
								break;
							}
						} else {
							if (weekDay(tmpDTStr) > 1 && weekDay(tmpDTStr) < 7 && weekDay(tmpDTStr) == 2) {
								break;
							}
						}
						count1++;
						
						tmpDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpDTStr, -1, "yyyy-MM-dd"), "yyyy-MM-dd", "yyyy-MM-dd", "");
						tmpEDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpEDTStr, -1, "yyyy-MM-dd"), "yyyy-MM-dd", "yyyy-MM-dd", "");
						tmpSDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpSDTStr, -1, "yyyy-MM-dd"), "yyyy-MM-dd", "yyyy-MM-dd", "");
					}
					if (wDayCnt == 2) {
						if (tmpWeekDay == 7) {
							wDayCnt = 0;
						}
					} else if (wDayCnt == 5) {
						if (tmpWeekDay == 1 || tmpWeekDay == 7) {
							wDayCnt = 5;
						} else {
							wDayCnt = count1;
						}
					}
				}
				if (endRecurType.equals("0")) {
					if (number(tmpDTStr) > number(eDate)) {
						break;
					} else {
						if (wDayCnt != 0) {
							for (int i=0; i<wDayCnt; i++) {
								if (i>0) {
									tmpDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpDTStr, 1, "yyyy-MM-dd"), "yyyy-MM-dd", "yyyy-MM-dd", "");
								}
								if (number(tmpDTStr) >= number(sDate) && number(tmpDTStr) >= number(orgtmpDTStr)) {
									returnXML.append("<ROW>");
									returnXML.append("<f_sDate>" + tmpDTStr + " " + tmpSTime + "</f_sDate>");
									returnXML.append("<f_eDate>" + tmpDTStr + " " + tmpETime + "</f_eDate>");
									returnXML.append("</ROW>");
								}
							}
						} else {
							if (number(tmpDTStr) >= number(sDate) && number(tmpDTStr) >= number(orgtmpDTStr)) {
								returnXML.append("<ROW>");
								returnXML.append("<f_sDate>" + tmpDTStr + " " + tmpSTime + "</f_sDate>");
								returnXML.append("<f_eDate>" + tmpDTStr + " " + tmpETime + "</f_eDate>");
								returnXML.append("</ROW>");
							}
						}
					}
				} else if (endRecurType.equals("1")) {
					if (number(tmpDTStr) > number(eDate) || n > number(instances)) {
						break;
					} else {
						if (wDayCnt != 0) {
							for (int i=0; i<wDayCnt; i++) {
								if (i>0) {
									tmpDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpDTStr, 1, "yyyy-MM-dd"), "yyyy-MM-dd", "yyyy-MM-dd", "");
									logger.debug("tmpDTStr1="+tmpDTStr);
								}
								if (number(tmpDTStr) >= number(sDate) && number(tmpDTStr) >= number(orgtmpDTStr)) {
									returnXML.append("<ROW>");
									returnXML.append("<f_sDate>" + tmpDTStr + " " + tmpSTime + "</f_sDate>");
									returnXML.append("<f_eDate>" + tmpDTStr + " " + tmpETime + "</f_eDate>");
									returnXML.append("</ROW>");
								}
							}
						} else {
							if (number(tmpDTStr) >= number(sDate) && number(tmpDTStr) >= number(orgtmpDTStr)) {
								returnXML.append("<ROW>");
								returnXML.append("<f_sDate>" + tmpDTStr + " " + tmpSTime + "</f_sDate>");
								returnXML.append("<f_eDate>" + tmpDTStr + " " + tmpETime + "</f_eDate>");
								returnXML.append("</ROW>");
							}
						}
						if (number(tmpDTStr) >= number(orgtmpDTStr)) {
							n = n + 1;
						}
					}
				} else if (endRecurType.equals("2")) {
					if (number(tmpDTStr) > number(eDate) || number(tmpDTStr) > number(tmpEDTStr1)) {
						break;
					} else {
						if (wDayCnt != 0) {
							for (int i=0; i<wDayCnt; i++) {
								if (i>0) {
									tmpDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpDTStr, 1, "yyyy-MM-dd"), "yyyy-MM-dd", "yyyy-MM-dd", "");
								}
								
								if (number(tmpDTStr) >= number(sDate) && number(tmpDTStr) >= number(orgtmpDTStr) && number(tmpDTStr) <= number(tmpEDTStr1)) {
									returnXML.append("<ROW>");
									returnXML.append("<f_sDate>" + tmpDTStr + " " + tmpSTime + "</f_sDate>");
									returnXML.append("<f_eDate>" + tmpDTStr + " " + tmpETime + "</f_eDate>");
									returnXML.append("</ROW>");
								}
								
								if (tmpDTStr.equals(tmpEDTStr1)) {
									break;
								}
							}
						} else {
							if (number(tmpDTStr) >= number(sDate) && number(tmpDTStr) >= number(orgtmpDTStr) && number(tmpDTStr) <= number(tmpEDTStr1)) {
								returnXML.append("<ROW>");
								returnXML.append("<f_sDate>" + tmpDTStr + " " + tmpSTime + "</f_sDate>");
								returnXML.append("<f_eDate>" + tmpDTStr + " " + tmpETime + "</f_eDate>");
								returnXML.append("</ROW>");
							}
						}
					}
				}
			}
			tmpDTStr = EgovDateUtil.convertDate(EgovDateUtil.addMonth(tmpDTStr, interval, "yyyy-MM-dd"), "yyyy-MM-dd", "yyyy-MM-dd", "");
			tmpEDTStr = EgovDateUtil.convertDate(EgovDateUtil.addMonth(tmpEDTStr, interval, "yyyy-MM-dd"), "yyyy-MM-dd", "yyyy-MM-dd", "");
			tmpSDTStr = EgovDateUtil.convertDate(EgovDateUtil.addMonth(tmpSDTStr, interval, "yyyy-MM-dd"), "yyyy-MM-dd", "yyyy-MM-dd", "");
			logger.debug("tmpDTStr="+tmpDTStr);
			logger.debug("tmpEDTStr="+tmpEDTStr);
			logger.debug("tmpSDTStr="+tmpSDTStr);
			
			temp++;
			if (temp > 1000) {
				break;
			}
		}
		returnXML.append("</DATA>");
		
		logger.debug("getMonthlyRepDateTimes End");
		return returnXML.toString();
	}
	
	@SuppressWarnings("deprecation")
	public String getYearlyRepDateTimes (String xmlStr, String sDate, String eDate) throws Exception {
		logger.debug("getYearlyRepDateTimes Start");
		StringBuilder returnXML = new StringBuilder();
		
		Document xmlRes = commonUtil.convertStringToDocument(xmlStr);
		logger.debug("xmlStr="+xmlStr);
		String selType = xmlRes.getElementsByTagName("selType").item(0).getTextContent().trim();
		String startDateTime = xmlRes.getElementsByTagName("startDateTime").item(0).getTextContent().trim();
		String endDateTime = xmlRes.getElementsByTagName("endDateTime").item(0).getTextContent().trim();
		String daysOfWeek = xmlRes.getElementsByTagName("daysOfWeek").item(0).getTextContent().trim();
		String daysOfMonth = xmlRes.getElementsByTagName("daysOfMonth").item(0).getTextContent().trim();
		String byPosition = xmlRes.getElementsByTagName("byPosition").item(0).getTextContent().trim();
		String monthsOfYear = xmlRes.getElementsByTagName("monthsOfYear").item(0).getTextContent().trim();
		String endRecurType = xmlRes.getElementsByTagName("endRecurType").item(0).getTextContent().trim();
		String instances = xmlRes.getElementsByTagName("instances").item(0).getTextContent().trim();
		String[] wDay = daysOfWeek.split(",");
		String tmpSTime = startDateTime.substring(11, 19);
		String tmpETime = endDateTime.substring(11, 19);
		String tmpDTStr = startDateTime.substring(0, 10);
		String tmpEDTStr = endDateTime.substring(0, 10);
		String tmpSDTStr = tmpDTStr;
		String tmpEDTStr1 = tmpEDTStr;
		
		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
		
		if (number(tmpSTime) > number(tmpETime)) {
			startDateTime = EgovDateUtil.convertDate(EgovDateUtil.addDay(startDateTime, 1, "yyyy-MM-dd HH:mm:ss"), "yyyy-MM-dd HH:mm:ss", "yyyy-MM-dd HH:mm:ss", "");
			tmpSDTStr = startDateTime.substring(0, 10);
		}
		String orgtmpDTStr = tmpDTStr;
		int n = 1;
		returnXML.append("<DATA>");
		
		int temp = 0;
		boolean whileFlag = true;
		while(whileFlag) {
			int wDayCnt = wDay.length;
			if (wDayCnt != 0) {
				wDayCnt = wDayCnt - 1;
			}
			if (daysOfWeek.indexOf(",") < 0) {
				wDayCnt = 0;
			}
			
			int datePartMonth = format.parse(tmpDTStr).getMonth()+1;

			tmpDTStr = EgovDateUtil.convertDate(EgovDateUtil.addMonth(tmpDTStr,(Integer.parseInt(monthsOfYear) - datePartMonth), "yyyy-MM-dd"), "yyyy-MM-dd", "yyyy-MM-dd", "");
			tmpEDTStr = EgovDateUtil.convertDate(EgovDateUtil.addMonth(tmpEDTStr,(Integer.parseInt(monthsOfYear) - datePartMonth), "yyyy-MM-dd"), "yyyy-MM-dd", "yyyy-MM-dd", "");
			tmpSDTStr = EgovDateUtil.convertDate(EgovDateUtil.addMonth(tmpSDTStr,(Integer.parseInt(monthsOfYear) - datePartMonth), "yyyy-MM-dd"), "yyyy-MM-dd", "yyyy-MM-dd", "");

			if (selType.equals("0")) {
				int datePartDay = format.parse(tmpDTStr).getDate();
				int datePartYear = format.parse(tmpDTStr).getYear()+1900;
				int tmpDatePartMonth = format.parse(tmpDTStr).getMonth()+1;
				boolean checkLastDate = true;
				
				if (daysOfMonth.equals("31") && (tmpDatePartMonth == 2 || tmpDatePartMonth == 4 || tmpDatePartMonth == 6 || tmpDatePartMonth == 9 || tmpDatePartMonth == 11)) {
					checkLastDate = false;
				} else if (daysOfMonth.equals("30") && tmpDatePartMonth == 2){
					checkLastDate = false;
				} else if (daysOfMonth.equals("29") && tmpDatePartMonth == 2 && !(datePartYear % 4 == 0 && datePartYear % 100 != 0 || datePartYear % 400 == 0)) {
					checkLastDate = false;
				}
				
				if (checkLastDate) {
					if (daysOfMonth != null && !daysOfMonth.equals("")) {
						tmpDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpDTStr, (Integer.parseInt(daysOfMonth) - datePartDay), "yyyy-MM-dd"), "yyyy-MM-dd", "yyyy-MM-dd", "");
						tmpEDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpEDTStr, (Integer.parseInt(daysOfMonth) - datePartDay), "yyyy-MM-dd"), "yyyy-MM-dd", "yyyy-MM-dd", "");
						tmpSDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpSDTStr, (Integer.parseInt(daysOfMonth) - datePartDay), "yyyy-MM-dd"), "yyyy-MM-dd", "yyyy-MM-dd", "");
					}
					
					
					if (endRecurType.equals("0")) {
						if (number(tmpDTStr) > number(eDate)) {
							break;
						} else {
							if (number(tmpDTStr) >= number(sDate) && number(tmpDTStr) >= number(orgtmpDTStr)) {
								returnXML.append("<ROW>");
								returnXML.append("<f_sDate>" + tmpDTStr + " " + tmpSTime + "</f_sDate>");
								returnXML.append("<f_eDate>" + tmpDTStr + " " + tmpETime + "</f_eDate>");
								returnXML.append("</ROW>");
							}
						}
					} else if (endRecurType.equals("1")) {
						if (number(tmpDTStr) > number(eDate) || n > number(instances)) {
							break;
						} else {
							if (number(tmpDTStr) >= number(sDate) && number(tmpDTStr) >= number(orgtmpDTStr)) {
								returnXML.append("<ROW>");
								returnXML.append("<f_sDate>" + tmpDTStr + " " + tmpSTime + "</f_sDate>");
								returnXML.append("<f_eDate>" + tmpDTStr + " " + tmpETime + "</f_eDate>");
								returnXML.append("</ROW>");
							}
							
							if (number(tmpDTStr) >= number(orgtmpDTStr)) {
								n = n+1;
							}
						}
					} else if (endRecurType.equals("2")) {
						if (number(tmpDTStr) > number(eDate) || number(tmpDTStr) > number(tmpEDTStr)) {
							break;
						} else {
							if (number(tmpDTStr) >= number(sDate) && number(tmpDTStr) >= number(orgtmpDTStr) && number(tmpSDTStr) <= number(tmpEDTStr1)) {
								returnXML.append("<ROW>");
								returnXML.append("<f_sDate>" + tmpDTStr + " " + tmpSTime + "</f_sDate>");
								returnXML.append("<f_eDate>" + tmpSDTStr + " " + tmpETime + "</f_eDate>");
								returnXML.append("</ROW>");
							}
						}
					}
				}
			} else {
				int count = 1;
				int datePartDay = format.parse(tmpDTStr).getDate();
				
				tmpDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpDTStr, (1 - datePartDay), "yyyy-MM-dd"), "yyyy-MM-dd", "yyyy-MM-dd", "");
				tmpEDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpEDTStr, (1 - datePartDay), "yyyy-MM-dd"), "yyyy-MM-dd", "yyyy-MM-dd", "");
				tmpSDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpSDTStr, (1 - datePartDay), "yyyy-MM-dd"), "yyyy-MM-dd", "yyyy-MM-dd", "");
				
				String sTmpDTStr = tmpDTStr;
				
				if (!byPosition.equals("-1")) {
					while (true) {
						if (wDayCnt == 0) {
							if (weekDay(tmpDTStr) == Integer.parseInt(daysOfWeek) + 1) {
								break;
							}
						} else if (wDayCnt == 2) {
							if (weekDay(tmpDTStr) == 7) {
								break;
							}
						} else {
							if (byPosition.equals("1") && weekDay(tmpDTStr) > 2 && weekDay(tmpDTStr) < 7) {
								if (weekDay(tmpDTStr) > 1 && weekDay(tmpDTStr) < 7 && weekDay(tmpDTStr) == 6) {
									break;
								}
							} else {
								if (weekDay(tmpDTStr) > 1 && weekDay(tmpDTStr) < 7 && weekDay(tmpDTStr) == 2) {
									break;
								}
							}
						}
						count ++;
						
						tmpDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpDTStr, 1, "yyyy-MM-dd"), "yyyy-MM-dd", "yyyy-MM-dd", "");
						tmpEDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpEDTStr, 1, "yyyy-MM-dd"), "yyyy-MM-dd", "yyyy-MM-dd", "");
						tmpSDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpSDTStr, 1, "yyyy-MM-dd"), "yyyy-MM-dd", "yyyy-MM-dd", "");
					}
					if (byPosition.equals("1") && weekDay(tmpDTStr) > 2 && weekDay(tmpDTStr) < 7 && wDay.length > 1) {
						tmpDTStr = sTmpDTStr;
						wDayCnt = count;
					}
					
					if (!byPosition.equals("1")) {
						if (wDayCnt == 5) {
							if (format.parse(tmpDTStr).getDate() == 1) {
								tmpDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpDTStr, (Integer.parseInt(byPosition) -1) * 7, "yyyy-MM-dd"), "yyyy-MM-dd", "yyyy-MM-dd", "");
							} else {
								if (weekDay(sTmpDTStr) == 1 || weekDay(sTmpDTStr) == 7) {
									tmpDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpDTStr, (Integer.parseInt(byPosition) -1) * 7, "yyyy-MM-dd"), "yyyy-MM-dd", "yyyy-MM-dd", "");
								} else {
									tmpDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpDTStr, (Integer.parseInt(byPosition) -2) * 7, "yyyy-MM-dd"), "yyyy-MM-dd", "yyyy-MM-dd", "");
								}
							} 
						} else {
							tmpDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpDTStr, (Integer.parseInt(byPosition) -1) * 7, "yyyy-MM-dd"), "yyyy-MM-dd", "yyyy-MM-dd", "");
							tmpEDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpEDTStr, (Integer.parseInt(byPosition) -1) * 7, "yyyy-MM-dd"), "yyyy-MM-dd", "yyyy-MM-dd", "");
							tmpSDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpSDTStr, (Integer.parseInt(byPosition) -1) * 7, "yyyy-MM-dd"), "yyyy-MM-dd", "yyyy-MM-dd", "");
						}
					}
				} else {
					int count1 = 1;
					
					tmpDTStr = EgovDateUtil.convertDate(EgovDateUtil.addMonth(tmpDTStr, 1, "yyyy-MM-dd"), "yyyy-MM-dd", "yyyy-MM-dd", "");
					tmpEDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpEDTStr, -1, "yyyy-MM-dd"), "yyyy-MM-dd", "yyyy-MM-dd", "");
					
					if (format.parse(tmpDTStr).getMonth()+1 != Integer.parseInt(monthsOfYear)) {
						tmpDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpDTStr, -1, "yyyy-MM-dd"), "yyyy-MM-dd", "yyyy-MM-dd", "");
					}
					
					int tmpWeekDay = weekDay(tmpDTStr);
					
					while (true) {
						if (wDayCnt == 0) {
							if (weekDay(tmpDTStr) == Integer.parseInt(daysOfWeek) + 1) {
								break;
							}
						} else if (wDayCnt == 2) {
							if (weekDay(tmpDTStr) == 7) {
								break;
							}
						} else {
							if (weekDay(tmpDTStr) > 1 && weekDay(tmpDTStr) < 7 && weekDay(tmpDTStr) == 2) {
								break;
							}
						}
						count1++;
						
						tmpDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpDTStr, -1, "yyyy-MM-dd"), "yyyy-MM-dd", "yyyy-MM-dd", "");
						tmpEDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpDTStr, -1, "yyyy-MM-dd"), "yyyy-MM-dd", "yyyy-MM-dd", "");
						tmpSDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpDTStr, -1, "yyyy-MM-dd"), "yyyy-MM-dd", "yyyy-MM-dd", "");
					}
					if (wDayCnt == 2) {
						if (tmpWeekDay == 7) {
							wDayCnt = 0;
						}
					} else if (wDayCnt == 5) {
						if (tmpWeekDay == 1 || tmpWeekDay == 7) {
							wDayCnt = 5;
						} else {
							wDayCnt = count1;
						}
					}
				}
				if (endRecurType.equals("0")) {
					if (number(tmpDTStr) > number(eDate)) {
						break;
					} else {
						if (wDayCnt != 0) {
							for (int i=0; i<wDayCnt; i++) {
								if (i>0) {
									tmpDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpDTStr, 1, "yyyy-MM-dd"), "yyyy-MM-dd", "yyyy-MM-dd", "");
								}
								if (number(tmpDTStr) >= number(sDate) && number(tmpDTStr) >= number(orgtmpDTStr)) {
									returnXML.append("<ROW>");
									returnXML.append("<f_sDate>" + tmpDTStr + " " + tmpSTime + "</f_sDate>");
									returnXML.append("<f_eDate>" + tmpDTStr + " " + tmpETime + "</f_eDate>");
									returnXML.append("</ROW>");
								}
							}
						} else {
							if (number(tmpDTStr) >= number(sDate) && number(tmpDTStr) >= number(orgtmpDTStr)) {
								returnXML.append("<ROW>");
								returnXML.append("<f_sDate>" + tmpDTStr + " " + tmpSTime + "</f_sDate>");
								returnXML.append("<f_eDate>" + tmpDTStr + " " + tmpETime + "</f_eDate>");
								returnXML.append("</ROW>");
							}
						}
					}
				} else if (endRecurType.equals("1")) {
					if (number(tmpDTStr) > number(eDate) || n > number(instances)) {
						break;
					} else {
						if (wDayCnt != 0) {
							for (int i=0; i<wDayCnt; i++) {
								if (i>0) {
									tmpDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpDTStr, 1, "yyyy-MM-dd"), "yyyy-MM-dd", "yyyy-MM-dd", "");
								}
								if (number(tmpDTStr) >= number(sDate) && number(tmpDTStr) >= number(orgtmpDTStr) && format.parse(tmpDTStr).getMonth()+1 == Integer.parseInt(monthsOfYear)) {
									returnXML.append("<ROW>");
									returnXML.append("<f_sDate>" + tmpDTStr + " " + tmpSTime + "</f_sDate>");
									returnXML.append("<f_eDate>" + tmpDTStr + " " + tmpETime + "</f_eDate>");
									returnXML.append("</ROW>");
								}
							}
						} else {
							if (number(tmpDTStr) >= number(sDate) && number(tmpDTStr) >= number(orgtmpDTStr)) {
								returnXML.append("<ROW>");
								returnXML.append("<f_sDate>" + tmpDTStr + " " + tmpSTime + "</f_sDate>");
								returnXML.append("<f_eDate>" + tmpDTStr + " " + tmpETime + "</f_eDate>");
								returnXML.append("</ROW>");
							}
						}
						if (number(tmpDTStr) >= number(orgtmpDTStr)) {
							n = n + 1;
						}
					}
				} else if (endRecurType.equals("2")) {
					if (number(tmpDTStr) > number(eDate) || number(tmpDTStr) > number(tmpEDTStr1)) {
						break;
					} else {
						if (wDayCnt != 0) {
							for (int i=0; i<wDayCnt; i++) {
								if (i>0) {
									tmpDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpDTStr, 1, "yyyy-MM-dd"), "yyyy-MM-dd", "yyyy-MM-dd", "");
								}
								
								if (number(tmpDTStr) >= number(sDate) && number(tmpDTStr) >= number(orgtmpDTStr) && number(tmpSDTStr) <= number(tmpEDTStr1)) {
									returnXML.append("<ROW>");
									returnXML.append("<f_sDate>" + tmpDTStr + " " + tmpSTime + "</f_sDate>");
									returnXML.append("<f_eDate>" + tmpDTStr + " " + tmpETime + "</f_eDate>");
									returnXML.append("</ROW>");
								}
								
								if (tmpDTStr.equals(tmpEDTStr)) {
									break;
								}
							}
						} else {
							if (number(tmpDTStr) >= number(sDate) && number(tmpDTStr) >= number(orgtmpDTStr) && number(tmpSDTStr) <= number(tmpEDTStr1)) {
								returnXML.append("<ROW>");
								returnXML.append("<f_sDate>" + tmpDTStr + " " + tmpSTime + "</f_sDate>");
								returnXML.append("<f_eDate>" + tmpDTStr + " " + tmpETime + "</f_eDate>");
								returnXML.append("</ROW>");
							}
						}
					}
				}
			}
			tmpDTStr = EgovDateUtil.convertDate(EgovDateUtil.addYear(tmpDTStr, 1, "yyyy-MM-dd"), "yyyy-MM-dd", "yyyy-MM-dd", "");
			tmpEDTStr = EgovDateUtil.convertDate(EgovDateUtil.addYear(tmpEDTStr, 1, "yyyy-MM-dd"), "yyyy-MM-dd", "yyyy-MM-dd", "");
			tmpSDTStr = EgovDateUtil.convertDate(EgovDateUtil.addYear(tmpSDTStr, 1, "yyyy-MM-dd"), "yyyy-MM-dd", "yyyy-MM-dd", "");
			
			temp++;
			if (temp > 1000) {
				break;
			}
		}
		returnXML.append("</DATA>");
		
		logger.debug("getYearlyRepDateTimes End");
		return returnXML.toString();
	}
	
	public int number(String inputStr) {
		try {
			return Integer.parseInt(inputStr.replace("-", "").replace(" ", "").replace(":", "").trim());
		} catch (Exception e) {
			e.printStackTrace();
			return 0;
		}
	}
	
	@SuppressWarnings("deprecation")
	public int weekDay(String inputStr) throws Exception {
		int returnValue = 0;
		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
		
		if (format.parse(inputStr).getDay() == 0) {
			returnValue = 1;
		}
		
		if (format.parse(inputStr).getDay() == 1) {
			returnValue = 2;
		}
		
		if (format.parse(inputStr).getDay() == 2) {
			returnValue = 3;
		}
		
		if (format.parse(inputStr).getDay() == 3) {
			returnValue = 4;
		}
		
		if (format.parse(inputStr).getDay() == 4) {
			returnValue = 5;
		}
		
		if (format.parse(inputStr).getDay() == 5) {
			returnValue = 6;
		}
		
		if (format.parse(inputStr).getDay() == 6) {
			returnValue = 7;
		}
		
		return returnValue;
	}
	
	@SuppressWarnings("deprecation")
	public int dayOfWeek(String inputStr) throws Exception {
		int returnValue = 0;
		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd aa h:mm:ss");
		
		
		if (format.parse(inputStr).getDay() == 0) {
			returnValue = 1;
		}
		
		if (format.parse(inputStr).getDay() == 1) {
			returnValue = 2;
		}
		
		if (format.parse(inputStr).getDay() == 2) {
			returnValue = 3;
		}
		
		if (format.parse(inputStr).getDay() == 3) {
			returnValue = 4;
		}
		
		if (format.parse(inputStr).getDay() == 4) {
			returnValue = 5;
		}
		
		if (format.parse(inputStr).getDay() == 5) {
			returnValue = 6;
		}
		
		if (format.parse(inputStr).getDay() == 6) {
			returnValue = 7;
		}
	
		return returnValue;
	}
	
	@SuppressWarnings("deprecation")
	public int datePartLeftShift(String inputStr) throws Exception {
		int returnValue = 0;
		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd aa h:mm:ss");
		
	
		if (format.parse(inputStr).getDay() == 0) {
			returnValue = 7;
		}
		
		if (format.parse(inputStr).getDay() == 1) {
			returnValue = 1;
		}
		
		if (format.parse(inputStr).getDay() == 2) {
			returnValue = 2;
		}
		
		if (format.parse(inputStr).getDay() == 3) {
			returnValue = 3;
		}
		
		if (format.parse(inputStr).getDay() == 4) {
			returnValue = 4;
		}
		
		if (format.parse(inputStr).getDay() == 5) {
			returnValue = 5;
		}
		
		if (format.parse(inputStr).getDay() == 6) {
			returnValue = 6;
		}
	
		return returnValue;
	}
	
	public String getLocalTime(String pDateTime) {
		String strDateTime = "";
		if (pDateTime.equals("")) {
			return strDateTime;
		}
		
		try {
			//TODO userInfo.Offset
			//String pOffset = "+09:00";
			strDateTime = EgovDateUtil.convertDate(addHours(pDateTime, 0, "yyyy-MM-dd HH:mm"), "yyyy-MM-dd HH:mm", "yyyy-MM-dd HH:mm", "");
			strDateTime = EgovDateUtil.convertDate(addMinutes(pDateTime, 0, "yyyy-MM-dd HH:mm"), "yyyy-MM-dd HH:mm", "yyyy-MM-dd HH:mm", "");
	
			if (pDateTime.length() < 19) {
				strDateTime = strDateTime.substring(0, pDateTime.length());
			}

			return strDateTime;
		} catch (Exception e) {
			e.printStackTrace();
			return pDateTime;
		}
	}
	
	public String getDBTime(String pDateTime) {
		String strDateTime = "";
		
		if (pDateTime.equals("")) {
			return strDateTime;
		}
		try {
			String pOffset = "+09:00";
			strDateTime = EgovDateUtil.convertDate(addHours(pDateTime, (Integer.parseInt(pOffset.split(":")[0])*-1)+9, ""), "yyyy-MM-dd HH:mm:ss", "yyyy-MM-dd HH:mm:ss", "");
			strDateTime = EgovDateUtil.convertDate(addMinutes(strDateTime, (Integer.parseInt(pOffset.split(":")[1])*-1), ""), "yyyy-MM-dd HH:mm:ss", "yyyy-MM-dd HH:mm:ss", "");
			
			if (pDateTime.length() < 19) {
				strDateTime = strDateTime.substring(0, pDateTime.length());
			}
			return strDateTime;
		} catch (Exception e) {
			e.printStackTrace();
			return pDateTime;
		}
	}
	
	public static String addHours(String sDate, int hour, String dateFormat) {		
		Calendar cal = Calendar.getInstance();
		
		if(dateFormat.equals("")){
			dateFormat = "yyyy-MM-dd HH:mm:ss";
		}
		
		SimpleDateFormat sdf = new SimpleDateFormat(dateFormat, Locale.getDefault());		
		
		try {
			cal.setTime(sdf.parse(sDate));
		} catch (ParseException e) {
			throw new IllegalArgumentException("Invalid date format: " + sDate);
		}

		if (hour != 0) {
			cal.add(Calendar.HOUR, hour);
		}
		return sdf.format(cal.getTime());
	}
	
	public String addMinutes(String sDate, int minute, String dateFormat) {		
		Calendar cal = Calendar.getInstance();
		
		if(dateFormat.equals("")){
			dateFormat = "yyyy-MM-dd HH:mm:ss";
		}
		
		SimpleDateFormat sdf = new SimpleDateFormat(dateFormat, Locale.getDefault());		
		
		try {
			cal.setTime(sdf.parse(sDate));
		} catch (ParseException e) {
			throw new IllegalArgumentException("Invalid date format: " + sDate);
		}

		if (minute != 0) {
			cal.add(Calendar.MINUTE, minute);
		}
		return sdf.format(cal.getTime());
	}
	
	public String addSeconds(String sDate, int second, String dateFormat) {		
		Calendar cal = Calendar.getInstance();
		
		if(dateFormat.equals("")){
			dateFormat = "yyyy-MM-dd HH:mm:ss";
		}
		
		SimpleDateFormat sdf = new SimpleDateFormat(dateFormat, Locale.getDefault());		
		
		try {
			cal.setTime(sdf.parse(sDate));
		} catch (ParseException e) {
			throw new IllegalArgumentException("Invalid date format: " + sDate);
		}

		if (second != 0) {
			cal.add(Calendar.SECOND, second);
		}
		return sdf.format(cal.getTime());
	}
	
	@SuppressWarnings("deprecation")
	public String convertToUTC(String pDate) throws Exception {
		SimpleDateFormat date = new SimpleDateFormat("yyyy-MM-dd HH:mm");
		String utcDate = (date.parse(pDate).getYear()+1900) + "-" + fedLeft(date.parse(pDate).getMonth()+1) + "-" + fedLeft(date.parse(pDate).getDate()) + "T" + fedLeft(date.parse(pDate).getHours()) + ":" + fedLeft(date.parse(pDate).getMinutes()) + ":01.000Z";

		return utcDate;
	}
	
	public String fedLeft(int pDatePart) throws Exception {
		String datePart = String.valueOf(pDatePart);
		
		if (datePart.length() == 1) {
			datePart = "0" + datePart;
		}
		
		return datePart;
	}
	
	//TODO HH:mm:ss 형식의 현재시간 출력 
	public String getCurrentDate() {
		Calendar aCalendar = Calendar.getInstance();
		String strDate = "";
		
		int hour = aCalendar.get(Calendar.HOUR_OF_DAY);
		int min = aCalendar.get(Calendar.MINUTE);
		int sec = aCalendar.get(Calendar.SECOND);
		
		strDate = hour + ":" + min + ":" + sec;
		return strDate;
	}
	
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
	
	public String getItemList(@CookieValue("loginCookie") String loginCookie,String brdID) throws Exception {
		String childBrd = "";
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		List<ResGetItemListVO> list = getBrdMainList(brdID, userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId());
		
		for(int i=0; i<list.size(); i++) {
			childBrd += list.get(i).getBrd_ID()+"/"+list.get(i).getBrd_Nm()+"/"+list.get(i).getApproveFlag()+",";
		}
		
		return childBrd;
	}
	
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

	public String updateScheduleDateTime(String xmlStr, String companyID, int tenantID, String offset) throws Exception {
		Document xmlDom = commonUtil.convertStringToDocument(xmlStr);
		String num = xmlDom.getElementsByTagName("NUM").item(0).getTextContent();
		String ownerID = xmlDom.getElementsByTagName("OWNERID").item(0).getTextContent();
		String sDate = xmlDom.getElementsByTagName("STARTDATETIME").item(0).getTextContent();
		String eDate = xmlDom.getElementsByTagName("ENDDATETIME").item(0).getTextContent();

		updateScheduleDateTime(Integer.parseInt(num), ownerID, companyID, commonUtil.getDateStringInUTC(sDate, offset, true), commonUtil.getDateStringInUTC(eDate, offset, true), tenantID);
		return xmlStr;
	}
	
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
		startDateTime = EgovDateUtil.convertDate(startDateTime, "yyyy-MM-dd HH:mm:ss", "yyyy-MM-dd HH:mm:ss", "");
		String endDateTime = xmlRes.getElementsByTagName("endDateTime").item(0).getTextContent();
		endDateTime = EgovDateUtil.convertDate(endDateTime, "yyyy-MM-dd HH:mm:ss", "yyyy-MM-dd HH:mm:ss", "");


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
		//String entryName = "";
		
		if (cmd.equals("add")) {
			if (!orgGresFlag.equals("0") && !orgEntryList.equals("")) {
				insertScheduleRepetition(Integer.parseInt(num), ownerID, startDateTime, endDateTime, reWay, reDay, reNum, reYoil, reMonth, reOrd, endFlag, reCount, companyID, tenantID, offset);
				
				entry = orgEntryList.split(">");
				entryNum = entry.length;
				
				for (int i=0; i<entryNum; i++) {
					entryArr = entry[i].split("<");
					//entryName = entryArr[0];
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
	
	public boolean deleteRepetition(String xmlStr, int tenantID) throws Exception {
		String num = "";
		String ownerID = "";
		
	
		Document xmlRes = commonUtil.convertStringToDocument(xmlStr);
		num = xmlRes.getElementsByTagName("PARAMETER").item(0).getChildNodes().item(0).getTextContent().trim();
		ownerID = xmlRes.getElementsByTagName("PARAMETER").item(0).getChildNodes().item(1).getTextContent().trim();
		deleteRepetition(ownerID, Integer.parseInt(num), tenantID);
	
		return true;
	}
	
	public String getRepetition(String xmlStr, int tenantID) throws Exception {
		String num = "";
		String ownerID = "";
		String companyID = "";
		StringBuilder resultXml = new StringBuilder();
		
		Document xmlRes = commonUtil.convertStringToDocument(xmlStr);
		num = xmlRes.getElementsByTagName("NUM").item(0).getTextContent().trim();
		ownerID = xmlRes.getElementsByTagName("OWNERID").item(0).getTextContent().trim();
		companyID = xmlRes.getElementsByTagName("companyID").item(0).getTextContent().trim();
		
		List<ResGetScheduleRepetitionVO> getScheduleRepetition = getScheduleRepetition(Integer.parseInt(num), ownerID, companyID, tenantID);
		
		if (getScheduleRepetition != null) {
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
			
			for (ResGetScheduleRepetitionVO list : getScheduleRepetition) {
				startDateTime = list.getStartDateTime();
				endDateTime = list.getEndDateTime();
				reWay = list.getReWay();
				reNum = list.getReNum();
				reYoil = list.getReYoil();
				reMonth = list.getReMonth();
				reOrd = list.getReOrd();
				endFlag = list.getEndFlag();
				reCount = list.getEndFlag();
			}
			
			freq = reWay.substring(0, 1);
			sel = reWay.substring(reWay.length()-1, reWay.length());
			
			resultXml.append("<recurrence>");
			resultXml.append("<frequency>"+freq+"</frequency>");
			resultXml.append("<selType>"+sel+"</selType>");
			resultXml.append("<endRecurType>"+endFlag+"</endRecurType>");
			resultXml.append("<startDateTime>"+startDateTime+"</startDateTime>");
			resultXml.append("<endDateTime>"+endDateTime+"</endDateTime>");
			
			if (freq.equals("4")) {
				if (sel.equals("0")) {
					resultXml.append("<interval>"+reNum+"</interval>");
				}
			} else if (freq.equals("5")) {
				resultXml.append("<interval>"+reNum+"</interval>");
				resultXml.append("<daysOfWeek>"+reYoil+"</daysOfWeek>");
			} else if (freq.equals("6")) {
				if (sel.equals("0")) {
					resultXml.append("<interval>"+reNum+"</interval>");
					resultXml.append("<daysOfWeek>"+reDay+"</daysOfWeek>");
				} else {
					resultXml.append("<interval>"+reNum+"</interval>");
					resultXml.append("<byPosition>"+reOrd+"</byPosition>");
					resultXml.append("<daysOfWeek>"+reYoil+"</daysOfWeek>");
				}
			} else if (freq.equals("7")) {
				if (sel.equals("0")) {
					resultXml.append("<monthsOfYear>"+reMonth+"</monthsOfYear>");
					resultXml.append("<daysOfMonth>"+reDay+"</daysOfMonth>");
				} else {
					resultXml.append("<monthsOfYear>"+reMonth+"</monthsOfYear>");
					resultXml.append("<byPosition>"+reOrd+"</byPosition>");
					resultXml.append("<daysOfWeek>"+reYoil+"</daysOfWeek>");
				}
			}
			if (endFlag.equals("1")) {
				resultXml.append("<instances>"+reCount+"</instances>");
			}
			resultXml.append("</recurrence>");
			
		}
	
		return resultXml.toString();
	}
	
	public String getACL(String pCompanyID, String pBrdID, String pUserID, String pMode, int tenantID) throws Exception {
		String aclTblBrd = "";
		
		 aclTblBrd = getAclTblBrd(pCompanyID, pBrdID, pUserID, pMode, tenantID);
			
		return aclTblBrd;
	}
	
	public String isoUTFDate(String dateTimeStr, Locale locale) {
        String timeSetStr = "";
        String resultStr = "";

        if (dateTimeStr != null && !dateTimeStr.trim().equals("")){
            if (dateTimeStr.indexOf(" ") != -1){
                if ((dateTimeStr.split(" ")[1].equals("PM") || dateTimeStr.split(" ")[1].equals(egovMessageSource.getMessage("ezResource.t205", locale))) && Integer.parseInt(dateTimeStr.split(" ")[2].split(":")[0]) < 12){
                    timeSetStr = String.valueOf(Integer.parseInt((dateTimeStr.split(" ")[2].split(":")[0]))+ 12);
                    timeSetStr += ":" + dateTimeStr.split(" ")[2].split(":")[1] + ":" + dateTimeStr.split(" ")[2].split(":")[2];
                } else if (dateTimeStr.split(" ")[1].equals("AM") || dateTimeStr.split(" ")[1].equals(egovMessageSource.getMessage("ezResource.t204", locale))) {
                    if (dateTimeStr.split(" ")[2].split(":")[0].trim().length() <= 1){
                        timeSetStr = "0" + dateTimeStr.split(" ")[2].split(":")[0] + ":" + dateTimeStr.split(" ")[2].split(":")[1] + ":" + dateTimeStr.split(" ")[2].split(":")[2];
                    } else if (Integer.parseInt(dateTimeStr.split(" ")[2].split(":")[0]) == 12){
                        timeSetStr = "00" + ":" + dateTimeStr.split(" ")[2].split(":")[1] + ":" + dateTimeStr.split(" ")[2].split(":")[2];
                    } else {
                        timeSetStr = dateTimeStr.split(" ")[2];
                    }
                } else {
                    timeSetStr = dateTimeStr.split(" ")[1];	// 20160909 by kgs: from [2] to [1]
                }
                resultStr = dateTimeStr.split(" ")[0] + "T" + timeSetStr + ".000Z";
            } else {
                resultStr = dateTimeStr + "T00:00:00.000Z";
            }
        } else {
            resultStr = "";
        }
        return resultStr;
    }
	
	public  String convertDate(String strSource, String fromDateFormat, String toDateFormat, String strTimeZone) {
		SimpleDateFormat simpledateformat = null;
		Date date = null;
		String _fromDateFormat = "";
		String _toDateFormat = "";

		if (EgovStringUtil.isNullToString(strSource).trim().equals("")) {
			return "";
		}
		if (EgovStringUtil.isNullToString(fromDateFormat).trim().equals("")) {
			_fromDateFormat = "yyyy-MM-dd HH:mm:ss"; // default값
		} else {
			_fromDateFormat = fromDateFormat;
		}
		if (EgovStringUtil.isNullToString(toDateFormat).trim().equals("")) {
			_toDateFormat = "yyyy-MM-dd aa h:mm:ss"; // default값
		} else {
			_toDateFormat = toDateFormat;
		}
		
		try {
			simpledateformat = new SimpleDateFormat(_fromDateFormat, Locale.getDefault());
			date = simpledateformat.parse(strSource);
			
			if (!EgovStringUtil.isNullToString(strTimeZone).trim().equals("")) {
				simpledateformat.setTimeZone(TimeZone.getTimeZone(strTimeZone));
			}
			simpledateformat = new SimpleDateFormat(_toDateFormat, Locale.getDefault());
		} catch (ParseException exception) {
			
		}
		if (simpledateformat != null && simpledateformat.format(date) != null) {

			return simpledateformat.format(date);
		} else {
			return "";
		}
	}
	
	public boolean delResSch(String xmlStr, int tenantID, String offset) throws Exception {
		Document xmlRes = commonUtil.convertStringToDocument(xmlStr);
		
		String ownerID = xmlRes.getElementsByTagName("OWNERID").item(0).getTextContent();
		String num = xmlRes.getElementsByTagName("NUM").item(0).getTextContent();
		String pNum = xmlRes.getElementsByTagName("PNUM").item(0).getTextContent();
		String companyID = xmlRes.getElementsByTagName("COMPANYID").item(0).getTextContent();
		String writerID = xmlRes.getElementsByTagName("WRITERID").item(0).getTextContent();
		String sDate = commonUtil.getDateStringInUTC(xmlRes.getElementsByTagName("STARTDATE").item(0).getTextContent(), offset, true);
		String eDate = commonUtil.getDateStringInUTC(xmlRes.getElementsByTagName("ENDDATE").item(0).getTextContent(), offset, true);
		String insType = xmlRes.getElementsByTagName("INSTYPE").item(0).getTextContent();
			
		delResSch(ownerID, num, pNum, companyID, writerID, sDate, eDate, Integer.parseInt(insType), tenantID);
		return true;
	}
	
	public String modifyResSch(String xmlStr, int tenantID, String offset) throws Exception {
		Document xmlRes = commonUtil.convertStringToDocument(xmlStr);
		String attachFlag = "";
		
		String title = xmlRes.getElementsByTagName("PARAMETER").item(0).getChildNodes().item(0).getTextContent().trim();
		String location = xmlRes.getElementsByTagName("PARAMETER").item(0).getChildNodes().item(1).getTextContent().trim();
		String timeDisplay = xmlRes.getElementsByTagName("PARAMETER").item(0).getChildNodes().item(2).getTextContent().trim();
		String startDate = xmlRes.getElementsByTagName("PARAMETER").item(0).getChildNodes().item(3).getTextContent().trim();
		String endDate = xmlRes.getElementsByTagName("PARAMETER").item(0).getChildNodes().item(4).getTextContent().trim();
		String allDay = xmlRes.getElementsByTagName("PARAMETER").item(0).getChildNodes().item(5).getTextContent().trim();
		String alertTime = xmlRes.getElementsByTagName("PARAMETER").item(0).getChildNodes().item(6).getTextContent().trim();
		String content = xmlRes.getElementsByTagName("PARAMETER").item(0).getChildNodes().item(7).getTextContent().trim();
		String writerID = xmlRes.getElementsByTagName("PARAMETER").item(0).getChildNodes().item(8).getTextContent().trim();
		String importance = xmlRes.getElementsByTagName("PARAMETER").item(0).getChildNodes().item(9).getTextContent().trim();
		String entryList = xmlRes.getElementsByTagName("PARAMETER").item(0).getChildNodes().item(10).getTextContent().trim();
		String reFlag = xmlRes.getElementsByTagName("PARAMETER").item(0).getChildNodes().item(11).getTextContent().trim();
		String gresFlag = xmlRes.getElementsByTagName("PARAMETER").item(0).getChildNodes().item(12).getTextContent().trim();
		String num = xmlRes.getElementsByTagName("PARAMETER").item(0).getChildNodes().item(13).getTextContent().trim();
		String pNum = xmlRes.getElementsByTagName("PARAMETER").item(0).getChildNodes().item(14).getTextContent().trim();
		String ownerID = xmlRes.getElementsByTagName("PARAMETER").item(0).getChildNodes().item(15).getTextContent().trim();
		String attachFiles = xmlRes.getElementsByTagName("PARAMETER").item(0).getChildNodes().item(16).getTextContent().trim();
		String companyID = xmlRes.getElementsByTagName("PARAMETER").item(0).getChildNodes().item(17).getTextContent().trim();
		String characterID = xmlRes.getElementsByTagName("PARAMETER").item(0).getChildNodes().item(18).getTextContent().trim();
		String typeVal = xmlRes.getElementsByTagName("PARAMETER").item(0).getChildNodes().item(19).getTextContent().trim();
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
	
	public String addResSch(String xmlStr, int tenantID, String offset) throws Exception {
		logger.debug("addResSch Start");
		logger.debug("xmlStr="+xmlStr);
		Document xmlRes = commonUtil.convertStringToDocument(xmlStr);
		String attachFlag = "";
		String scheduleID = "";
		
		String title = xmlRes.getElementsByTagName("PARAMETER").item(0).getChildNodes().item(0).getTextContent().trim();
		String location = xmlRes.getElementsByTagName("PARAMETER").item(0).getChildNodes().item(1).getTextContent().trim();
		String timeDisplay = xmlRes.getElementsByTagName("PARAMETER").item(0).getChildNodes().item(2).getTextContent().trim();
		String startDate = xmlRes.getElementsByTagName("PARAMETER").item(0).getChildNodes().item(3).getTextContent().trim();
		String endDate = xmlRes.getElementsByTagName("PARAMETER").item(0).getChildNodes().item(4).getTextContent().trim();
		String allDay = xmlRes.getElementsByTagName("PARAMETER").item(0).getChildNodes().item(5).getTextContent().trim();
		String alertTime = xmlRes.getElementsByTagName("PARAMETER").item(0).getChildNodes().item(6).getTextContent().trim();
		String content = xmlRes.getElementsByTagName("PARAMETER").item(0).getChildNodes().item(7).getTextContent().trim();
		String writerID = xmlRes.getElementsByTagName("PARAMETER").item(0).getChildNodes().item(8).getTextContent().trim();
		String importance = xmlRes.getElementsByTagName("PARAMETER").item(0).getChildNodes().item(9).getTextContent().trim();
		String entryList = xmlRes.getElementsByTagName("PARAMETER").item(0).getChildNodes().item(10).getTextContent().trim();
		String reFlag = xmlRes.getElementsByTagName("PARAMETER").item(0).getChildNodes().item(11).getTextContent().trim();
		String gresFlag = xmlRes.getElementsByTagName("PARAMETER").item(0).getChildNodes().item(12).getTextContent().trim();
		String num = xmlRes.getElementsByTagName("PARAMETER").item(0).getChildNodes().item(13).getTextContent().trim();
		String pNum = xmlRes.getElementsByTagName("PARAMETER").item(0).getChildNodes().item(14).getTextContent().trim();
		String ownerID = xmlRes.getElementsByTagName("PARAMETER").item(0).getChildNodes().item(15).getTextContent().trim();
		String attachFiles = xmlRes.getElementsByTagName("PARAMETER").item(0).getChildNodes().item(16).getTextContent().trim();
		String companyID = xmlRes.getElementsByTagName("PARAMETER").item(0).getChildNodes().item(17).getTextContent().trim();
		String characterID = xmlRes.getElementsByTagName("PARAMETER").item(0).getChildNodes().item(18).getTextContent().trim();
		String deptNm = xmlRes.getElementsByTagName("PARAMETER").item(0).getChildNodes().item(20).getTextContent().trim();
		String ownerNm = xmlRes.getElementsByTagName("PARAMETER").item(0).getChildNodes().item(21).getTextContent().trim();
		String strApprove = xmlRes.getElementsByTagName("PARAMETER").item(0).getChildNodes().item(22).getTextContent().trim();
			
		if (xmlRes.getElementsByTagName("PARAMETER").item(0).getChildNodes().getLength() > 23) {
			scheduleID = xmlRes.getElementsByTagName("PARAMETER").item(0).getChildNodes().item(23).getTextContent().trim();
		}
			
		if (attachFiles != null && !attachFiles.equals("")) {
			attachFlag = "1";
		} else {
			attachFlag = "0";
		}
			
		//timedisplay = 1
		timeDisplay = "1";
		addResSch(ownerID, pNum, companyID, writerID, title, location, timeDisplay, startDate, endDate, allDay, alertTime, content, importance, reFlag, gresFlag, 
				entryList, characterID, attachFlag, deptNm, ownerNm, strApprove, scheduleID, tenantID, offset);
		String returnStr = "";
		returnStr += "<RTN_DATA>";
        returnStr += "<NUM>" + num + "</NUM>";
        returnStr += "<OWNERID>" + writerID + "</OWNERID>";
        returnStr += "</RTN_DATA>";
        
        logger.debug("returnStr="+returnStr);
        logger.debug("addResSch End");
        return returnStr;
	}
	
	public DataTable makeDupResult() {
		DataTable dtResult = null;
		
		dtResult = new DataTable();
		
		return dtResult;
	}
	
	//반복예약일때
	public boolean getRepResource(String strFrequency, String strSelType, String strEndRecurType, String strStartDateTime, String strEndDateTime, String strInterval,
		String strDaysOfWeek, String strInstances, String strByPosition, String strDaysOfMonth, String strPownerID, String strPnum, String strPcmd, String companyID, List<ResMakeDupResultVO> dtResult, int tenantID, String offset) throws Exception {
		logger.debug("getRepResource Start");
		logger.debug("strStartDateTime="+strStartDateTime);
		logger.debug("strEndDateTime="+strEndDateTime);
		ResRecParamVO recParam = resStruct(strFrequency, strSelType, strEndRecurType, strStartDateTime, strEndDateTime, strInterval, strDaysOfWeek, strInstances, strByPosition, strDaysOfMonth);
			
		List<ResMakeDupResultVO> dt1 = makeRepResource1(recParam);
			
		int recFrequency = strFrequency.equals("") ? 0 : Integer.parseInt(strFrequency);
		int recSelType = strSelType.equals("") ? 0 : Integer.parseInt(strSelType);
		int recEndRecurType = strEndRecurType.equals("") ? 0 : Integer.parseInt(strEndRecurType);
		String recStartDateTime = strStartDateTime.equals("") ? null : strStartDateTime;
		String recEndDateTime = strEndDateTime.equals("") ? null : strEndDateTime;
		int recInterval = strInterval.equals("") ? 0 : Integer.parseInt(strSelType);
		String recDaysOfWeek = strDaysOfWeek.equals("") ? null : strDaysOfWeek;
		int recInstances = strInstances.equals("") ? 0 : Integer.parseInt(strInstances);
		int recByPosition = strByPosition.equals("") ? 0 : Integer.parseInt(strByPosition);
		String recDaysOfMonth = strDaysOfMonth.equals("") ? null : strDaysOfMonth;
		String pOwnerID = strPownerID.equals("") ? null : strPownerID;
		String pNum = strPnum == null ? "0" : strPnum;
		String pCmd = strPcmd.equals("") ? "" : strPcmd;
			
		List<ResGetRepResourceVO> retobj = getRepResource(recFrequency, recSelType, recEndRecurType, EgovDateUtil.convertDate(recStartDateTime, "yyyy-MM-dd HH:mm", "yyyy-MM-dd aa h:mm:ss", ""), EgovDateUtil.convertDate(recEndDateTime, "yyyy-MM-dd HH:mm", "yyyy-MM-dd aa h:mm:ss", ""), recInterval, recDaysOfWeek, recInstances, recByPosition, recDaysOfMonth, pOwnerID, Integer.parseInt(pNum), pCmd, companyID, tenantID, offset);
		
		ResGetRepResourceVO retobj2 = chkDeletedRepResource(pOwnerID, tenantID);
			
		boolean isDup = false;
			
		if (retobj != null) {
		isDup = chkTable(dt1,retobj,null,dtResult, offset); // 일반예약 체크
		}
			
		if (isDup) {
			return isDup;
		}
			
		//String firstStartDateTime = getYearMonthDay(recParam.getRecStartDateTime());
		String firstStartDateTime = getYearMonthDay(EgovDateUtil.convertDate(recParam.getRecStartDateTime(), "yyyy-MM-dd HH:mm", "yyyy-MM-dd aa h:mm:ss", ""));
		logger.debug(firstStartDateTime);
		//String lastStartDateTime = getYearMonthDay(dt1.get(dt1.size()-1).getStartDateTime());
		String lastStartDateTime = getYearMonthDay(EgovDateUtil.convertDate(dt1.get(dt1.size()-1).getStartDateTime(), "yyyy-MM-dd aa h:mm:ss", "yyyy-MM-dd aa h:mm:ss", ""));
		ResRecDurationVO recDuration = new ResRecDurationVO();
		recDuration.setFirstStartDateTime(firstStartDateTime);
		recDuration.setLastStartDateTime(lastStartDateTime);
			
		List<ResGetRepResourceRepeatVO> retobjTable1 = getRepResourceRepeat(pOwnerID, 0, pCmd, companyID, tenantID);
		 for (ResGetRepResourceRepeatVO dr : retobjTable1) {
			 List<ResMakeDupResultVO> dt2 = makeRepResource2(dr, recParam, recDuration, offset);
			 if (dt2 == null || dt2.size() == 0) {
				 continue;
			 }
			 isDup = chkTableRepeat(dt1, dt2, retobjTable1, dtResult, offset);
		 }
		
		logger.debug("isDup="+isDup);
		logger.debug("getRepResource End");
		return isDup;
		}
	//일반예약일때
	public boolean getRepResource(String strStartDateTime, String strEndDateTime, String strPownerID, String strPnum, String strPcmd, String companyID, List<ResMakeDupResultVO> dtResult, int tenantID, String offset) throws Exception {
		logger.debug("getRepResource started");
		logger.debug("===일반예약일때===");
		
		String startDateTime = strStartDateTime.equals("") ? null : strStartDateTime;
		String endDateTime = strEndDateTime.equals("") ? null : strEndDateTime;
		logger.debug("startDateTime="+startDateTime);
		logger.debug("endDateTime="+endDateTime);
		String pOwnerID = strPownerID.equals("") ? null : strPownerID;
		String pNum = strPnum == null ? "0" : strPnum;
		String pCmd = strPcmd.equals("") ? null : strPcmd;
		
		ResRecParamVO recParam = new ResRecParamVO();
		recParam.setRecStartDateTime(startDateTime);
		recParam.setRecEndDateTime(endDateTime);
		
		List<ResMakeDupResultVO> dt1 = makeRepResource0(recParam);
		
		List<ResGetRepResourceVO> retobj = getRepResource(0, 0, 0, EgovDateUtil.convertDate(startDateTime, "yyyy-MM-dd HH:mm", "yyyy-MM-dd aa h:mm:ss", ""), EgovDateUtil.convertDate(endDateTime, "yyyy-MM-dd HH:mm", "yyyy-MM-dd aa h:mm:ss", ""), 0, "", 0, 0, "", pOwnerID, 0, pCmd, companyID, tenantID, offset);
		
		ResGetRepResourceVO retobj2 = chkDeletedRepResource(pOwnerID, tenantID);
		
		boolean isDup = false;
		
		if (retobj != null && retobj.isEmpty() == false) {
			isDup = chkTable(dt1,retobj,null,dtResult, offset); // 일반예약 체크
		}
		
		logger.debug("isDup="+isDup);
		
		if (isDup) {
			return isDup;
		}
		
		logger.debug("getRecStartDateTime="+recParam.getRecStartDateTime());
		String firstStartDateTime = getYearMonthDay(EgovDateUtil.convertDate(recParam.getRecStartDateTime(), "yyyy-MM-dd HH:mm", "yyyy-MM-dd aa h:mm:ss", ""));
		logger.debug("firstStartDateTime="+firstStartDateTime);
		//String lastStartDateTime = getYearMonthDay(dt1.get(dt1.size()-1).getStartDateTime());
		
		String lastStartDateTime = getYearMonthDay(EgovDateUtil.convertDate(dt1.get(dt1.size()-1).getStartDateTime(), "yyyy-MM-dd aa h:mm:ss", "yyyy-MM-dd aa h:mm:ss", ""));
		ResRecDurationVO recDuration = new ResRecDurationVO();
		recDuration.setFirstStartDateTime(firstStartDateTime);
		recDuration.setLastStartDateTime(lastStartDateTime);
		
		List<ResGetRepResourceRepeatVO> retobjTable1 = getRepResourceRepeat(pOwnerID, 0, pCmd, companyID, tenantID);
		for (ResGetRepResourceRepeatVO dr : retobjTable1) {
			List<ResMakeDupResultVO> dt2 = makeRepResource2(dr, recParam, recDuration, offset);
			if (dt2 == null || dt2.size() == 0) {
				continue;
			}
			isDup = chkTableRepeat(dt1, dt2, retobjTable1, dtResult, offset);
			
			if (isDup) {
				break;
			}
		}
		

		logger.debug("getRepResource ended");
			
		return isDup;
	}
	
	@SuppressWarnings("deprecation")
	public boolean chkTable(List<ResMakeDupResultVO> dtS, List<ResGetRepResourceVO> dtT, List<ResGetRepResourceVO> dtTd, List<ResMakeDupResultVO> dtResult, String offset) throws Exception {
		logger.debug("chkTable Start");
		SimpleDateFormat date = new SimpleDateFormat("yyyy-MM-dd aa h:mm:ss");
		ResMakeDupResultVO result = new ResMakeDupResultVO(); 
		
		if (dtT == null) {
			logger.debug("drt == null");
			return false;
		}
			
		boolean isDup = false;
		boolean isDel = false;
		boolean isShowDup = true;
		
		//2016-12-06
		/*dtT에 승인권한이 있는자원에 반복예약할때, 자꾸 널값이 들어와서 주석처리
		String firstStartDateTime = EgovDateUtil.convertDate(dtT.get(0).getStartDate(), "yyyy-MM-dd HH:mm:ss", "yyyy-MM-dd aa h:mm:ss", "");
		String lastEndDateTime = EgovDateUtil.convertDate(dtT.get(dtT.size() - 1).getEndDate(), "yyyy-MM-dd HH:mm:ss", "yyyy-MM-dd aa h:mm:ss", "");*/

		/*String dateTimeDuration = String.valueOf(date.parse(firstStartDateTime).getYear())+"-"+String.valueOf(date.parse(firstStartDateTime).getMonth()+1)+"-"+String.valueOf(date.parse(firstStartDateTime).getDate()) +
			" "+korDayOfWeek(dayOfWeek(firstStartDateTime)) + "부터"+" "+String.valueOf(date.parse(lastEndDateTime).getYear())+"-"+String.valueOf(date.parse(lastEndDateTime).getMonth()+1)+"-"+String.valueOf(date.parse(lastEndDateTime).getDate())+
			" "+korDayOfWeek(dayOfWeek(lastEndDateTime))+"까지"+" "+String.valueOf(date.parse(firstStartDateTime).getHours())+String.valueOf(date.parse(firstStartDateTime).getMinutes())+
			"~"+String.valueOf(date.parse(lastEndDateTime).getHours())+String.valueOf(date.parse(lastEndDateTime).getMinutes())+" "+"동안";*/

		// 일정관리에서 예약한 시간이 필요함
		if (dtS != null || dtS.size() != 0) {
			//result.setStartDateTime(dtS.get(0).getStartDateTime());
			//result.setEndDateTime(dtS.get(dtS.size()-1).getEndDateTime());
		}
			
		// 빠짐없이 반복은 아니라고 봄.
		for (ResMakeDupResultVO drS : dtS) {
			String sStartDate = EgovDateUtil.convertDate(drS.getStartDateTime(), "yyyy-MM-dd aa h:mm:ss", "yyyy-MM-dd aa h:mm:ss", "");
			String sEndDate = EgovDateUtil.convertDate(drS.getEndDateTime(), "yyyy-MM-dd aa h:mm:ss", "yyyy-MM-dd aa h:mm:ss", "");
			logger.debug("sStartDate="+sStartDate);
			logger.debug("sEndDate="+sEndDate);
			for (ResGetRepResourceVO drT : dtT) {
				String tStartDate = EgovDateUtil.convertDate(commonUtil.getDateStringInUTC(drT.getStartDate(), offset, false), "yyyy-MM-dd HH:mm:ss", "yyyy-MM-dd aa h:mm:ss", "");
				String tEndDate = EgovDateUtil.convertDate(commonUtil.getDateStringInUTC(drT.getEndDate(), offset, false), "yyyy-MM-dd HH:mm:ss", "yyyy-MM-dd aa h:mm:ss", "");
				logger.debug("tStartDate="+tStartDate);
				logger.debug("tEndDate="+tEndDate);
				int tAllDay = Integer.parseInt(drT.getAllDay());
					
				isDel = false;
				if (dtTd != null) {
					for (ResGetRepResourceVO drTd : dtTd) {
						if (drTd.getStartDate().equals(drT.getStartDate()) && drTd.getEndDate().equals(drT.getEndDate())) {
							isDel = true;
							break;
						}
					}
				}
				if (isDel) {
					continue;
				}
					
				//
				String compare1 = tAllDay == 0 ? sEndDate : EgovDateUtil.convertDate(EgovDateUtil.addDay(getYearMonthDay(sEndDate), 1, "yyyyMMdd"), "yyyyMMdd", "yyyy-MM-dd aa h:mm:ss", "");
				String compare2 = tStartDate; 

				Date day1 = date.parse(compare1);
				Date day2 = date.parse(compare2);

				String compare3 = tEndDate;
				String compare4 = tAllDay == 0 ? sStartDate : EgovDateUtil.convertDate(getYearMonthDay(sStartDate), "yyyyMMdd", "yyyy-MM-dd aa h:mm:ss", ""); 
					
				Date day3 = date.parse(compare3);
				Date day4 = date.parse(compare4);
				int compare = day1.compareTo(day2);
				int secondCompare = day3.compareTo(day4);
					
				if (!(compare <= 0 || secondCompare <= 0)) {

					isDup = true;
						
					if (isShowDup) {
						//넣는다
						//insertIntodt
					}
					break;
				}
			}
			if (isDup) {
				break;
			}
		}
		logger.debug("chkTable End");
		return isDup;
	}
	
	@SuppressWarnings("deprecation")
	public boolean chkTableRepeat(List<ResMakeDupResultVO> dtS, List<ResMakeDupResultVO> dtT, List<ResGetRepResourceRepeatVO> dtTd, List<ResMakeDupResultVO> dtResult, String offset) throws Exception {
		logger.debug("chkTableRepeat started");

		SimpleDateFormat date = new SimpleDateFormat("yyyy-MM-dd aa h:mm:ss");
		ResMakeDupResultVO result = new ResMakeDupResultVO(); 
		
		if (dtT == null) {
			return false;
		}
		
		boolean isDup = false;
		boolean isDel = false;
		boolean isShowDup = true;
		
		String firstStartDateTime = EgovDateUtil.convertDate(dtT.get(0).getStartDateTime(), "yyyy-MM-dd aa h:mm:ss", "yyyy-MM-dd aa h:mm:ss", "");
		String lastEndDateTime = EgovDateUtil.convertDate(dtT.get(dtT.size() - 1).getEndDateTime(), "yyyy-MM-dd aa h:mm:ss", "yyyy-MM-dd aa h:mm:ss", "");
		/*String dateTimeDuration = String.valueOf(date.parse(firstStartDateTime).getYear())+"-"+String.valueOf(date.parse(firstStartDateTime).getMonth()+1)+"-"+String.valueOf(date.parse(firstStartDateTime).getDate()) +
				" "+korDayOfWeek(dayOfWeek(firstStartDateTime)) + "부터"+" "+String.valueOf(date.parse(lastEndDateTime).getYear())+"-"+String.valueOf(date.parse(lastEndDateTime).getMonth()+1)+"-"+String.valueOf(date.parse(lastEndDateTime).getDate())+
				" "+korDayOfWeek(dayOfWeek(lastEndDateTime))+"까지"+" "+String.valueOf(date.parse(firstStartDateTime).getHours())+String.valueOf(date.parse(firstStartDateTime).getMinutes())+
				"~"+String.valueOf(date.parse(lastEndDateTime).getHours())+String.valueOf(date.parse(lastEndDateTime).getMinutes())+" "+"동안";*/
		
		// 일정관리에서 예약한 시간이 필요함
		if (dtS != null || dtS.size() != 0) {
			//result.setStartDateTime(dtS.get(0).getStartDateTime());
			//result.setEndDateTime(dtS.get(dtS.size()-1).getEndDateTime());
		}
		
		// 빠짐없이 반복은 아니라고 봄.
		for (ResMakeDupResultVO drS : dtS) {
			String sStartDate = EgovDateUtil.convertDate(drS.getStartDateTime(), "yyyy-MM-dd aa h:mm:ss", "yyyy-MM-dd aa h:mm:ss", "");
			String sEndDate = EgovDateUtil.convertDate(drS.getEndDateTime(), "yyyy-MM-dd aa h:mm:ss", "yyyy-MM-dd aa h:mm:ss", "");
			logger.debug("sStartDate="+sStartDate);
			logger.debug("sEndDate="+sEndDate);
			
			for (ResMakeDupResultVO drT : dtT) {
				logger.debug("drtStartDate="+drT.getStartDateTime());
				logger.debug("drtEndDate="+drT.getEndDateTime());
				String tStartDate = EgovDateUtil.convertDate(commonUtil.getDateStringInUTC(drT.getStartDateTime(), offset, false), "yyyy-MM-dd aa h:mm:ss", "yyyy-MM-dd aa h:mm:ss", "");
				String tEndDate = EgovDateUtil.convertDate(commonUtil.getDateStringInUTC(drT.getEndDateTime(), offset, false), "yyyy-MM-dd aa h:mm:ss", "yyyy-MM-dd aa h:mm:ss", "");
				logger.debug("tStartDate="+tStartDate);
				logger.debug("tEndDate="+tEndDate);
				
				int tAllDay = drT.getAllDay();
				
				isDel = false;
				if (dtTd != null) {
					for (ResGetRepResourceRepeatVO drTd : dtTd) {
						if (drTd.getStartDateTime().equals(drT.getStartDateTime()) && drTd.getEndDateTime().equals(drT.getEndDateTime())) {
							isDel = true;
							break;
						}
					}
				}
				if (isDel) {
					continue;
				}
				
				//
				String compare1 = tAllDay == 0 ? sEndDate : EgovDateUtil.addDay(getYearMonthDay(sEndDate), 1, "yyyy-MM-dd aa h:mm:ss");
				String compare2 = tStartDate; 
				
				Date day1 = date.parse(compare1);
				Date day2 = date.parse(compare2);
				
				String compare3 = tEndDate;
				//String compare4 = tAllDay == 0 ? sStartDate : getYearMonthDay(sStartDate);
				String compare4 = tAllDay == 0 ? sStartDate : EgovDateUtil.convertDate(getYearMonthDay(sStartDate), "yyyyMMdd", "yyyy-MM-dd aa h:mm:ss", "");
				
				Date day3 = date.parse(compare3);
				Date day4 = date.parse(compare4);
				int compare = day1.compareTo(day2);
				int secondCompare = day3.compareTo(day4);
				
				if (!(compare <= 0 || secondCompare <= 0)) {
					isDup = true;
					
					if (isShowDup) {
						//넣는다
						//insertIntodt
					}
					break;
				}
			}
			if (isDup) {
				break;
			}
		}
		

		logger.debug("chkTableRepeat ended");
		return isDup;
	}
	
	public List<ResMakeDupResultVO> makeRepResource0(ResRecParamVO recParam) throws Exception {
		List<ResMakeDupResultVO> dtOnce = new ArrayList<ResMakeDupResultVO>();
		
		String startDateTime = recParam.getRecStartDateTime();
		String endDateTime = recParam.getRecEndDateTime();
			
//			dtOnce.get(0).setStartDateTime(startDateTime);
//			dtOnce.get(0).setEndDateTime(endDateTime);
		ResMakeDupResultVO s1 = new ResMakeDupResultVO();
		s1.setStartDateTime(EgovDateUtil.convertDate(startDateTime, "yyyy-MM-dd HH:mm", "yyyy-MM-dd aa h:mm:ss", ""));
		s1.setEndDateTime(EgovDateUtil.convertDate(endDateTime, "yyyy-MM-dd HH:mm", "yyyy-MM-dd aa h:mm:ss", ""));
		dtOnce.add(0, s1);

		/*StringBuilder sb = new StringBuilder();
		for (ResMakeDupResultVO dr : dtOnce) {
			String startDt = dr.getStartDateTime();
			String endDt = dr.getEndDateTime();
				
			sb.append(startDt);
			sb.append(" ");
			sb.append(dayOfWeek(startDt)).substring(0, 3);
			sb.append(" ~ ");
			sb.append(endDt);
			sb.append(" ");
			sb.append(dayOfWeek(endDt)).substring(0, 3);
		}*/
	
		return dtOnce;
	}
	
	public List<ResMakeDupResultVO> makeRepResource1(ResRecParamVO recParam) throws Exception {
		List<ResMakeDupResultVO> dtRec = new ArrayList<ResMakeDupResultVO>();
		switch (recParam.getRecReWay()) {
			case 40:
				dtRec = chkDupReway40(recParam, dtRec, null);
				break;
			case 41:
				dtRec = chkDupReway41(recParam, dtRec, null);
				break;
			case 51:
				dtRec = chkDupReway51(recParam, dtRec, null);
				break;
			case 60:
				dtRec = chkDupReway60(recParam, dtRec, null);
				break;
			case 61:
				dtRec = chkDupReway61(recParam, dtRec, null);
				break;
			case 70:
				dtRec = chkDupReway70(recParam, dtRec, null);
				break;
			case 71:
				dtRec = chkDupReway71(recParam, dtRec, null);
				break;
			default:
				break;
		}

		return dtRec;
	}
	
	public List<ResMakeDupResultVO> makeRepResource2(ResGetRepResourceRepeatVO destDr,ResRecParamVO recParam, ResRecDurationVO recDuration, String offset) throws Exception {
		logger.debug("makeRepResource2 started");

		List<ResMakeDupResultVO> dtDest = new ArrayList<ResMakeDupResultVO>();
		
		logger.debug("getStartDateTime="+destDr.getStartDateTime());
		logger.debug("getEndDateTime="+destDr.getEndDateTime());
		
		//ResRecParamVO destParam = resStruct();
		ResRecParamVO destParam = new ResRecParamVO();
		if (!destDr.getStartDateTime().equals("")) {
			destParam.setRecStartDateTime(EgovDateUtil.convertDate(commonUtil.getDateStringInUTC(destDr.getStartDateTime(), offset, false), "yyyy-MM-dd HH:mm:ss", "yyyy-MM-dd HH:mm", ""));
			logger.debug("UTCStartTime="+commonUtil.getDateStringInUTC(destDr.getStartDateTime(), offset, false));
		}
		if (!destDr.getEndDateTime().equals("")) {
			destParam.setRecEndDateTime(EgovDateUtil.convertDate(commonUtil.getDateStringInUTC(destDr.getEndDateTime(), offset, false), "yyyy-MM-dd HH:mm:ss", "yyyy-MM-dd HH:mm", ""));
			logger.debug("UTCEndTime="+commonUtil.getDateStringInUTC(destDr.getEndDateTime(), offset, false));
		}
		if (!destDr.getReWay().equals("")) {
			destParam.setRecReWay(Integer.parseInt(destDr.getReWay()));
		}
		if (destDr.getReNum() != null && !destDr.getReNum().equals("")) {
			destParam.setRecReNum(Integer.parseInt(destDr.getReNum()));
		}
		if (!destDr.getReDay().equals("")) {
			destParam.setRecReDay(Integer.parseInt(destDr.getReDay()));
		}
		if (!destDr.getReYoil().equals("")) {
			destParam.setRecReYoil(destDr.getReYoil());
		}
		if (!destDr.getReOrd().equals("")) {
			destParam.setRecReOrd(Integer.parseInt(destDr.getReOrd()));
		}
		if (!destDr.getEndFlag().equals("")) {
			destParam.setRecEndFlag(Integer.parseInt(destDr.getEndFlag()));
		}
		if (!destDr.getReCount().equals("")) {
			destParam.setRecReCount(Integer.parseInt(destDr.getReCount()));
		}
		if (!destDr.getAllDay().equals("")) {
			destParam.setRecAllDay(Integer.parseInt(destDr.getAllDay()));
		}
		
		if (destParam.getRecEndFlag() == 0) {
			destParam.setRecReCount(1000);
			destParam.setRecEndFlag(1);
		}
		
		String compare1 = EgovDateUtil.convertDate(recDuration.getFirstStartDateTime(), "yyyyMMdd", "yyyy-MM-dd aa h:mm:ss", "");
		String compare2 = EgovDateUtil.convertDate(getYearMonthDay(EgovDateUtil.convertDate(destParam.getRecStartDateTime(), "yyyyMMdd", "yyyy-MM-dd aa h:mm:ss", "")), "yyyyMMdd", "yyyy-MM-dd aa h:mm:ss", ""); 
		SimpleDateFormat date = new SimpleDateFormat("yyyy-MM-dd aa h:mm:ss");
		Date day1 = date.parse(compare1);
		Date day2 = date.parse(compare2);
		int compare = day1.compareTo(day2);
		
		String interStartDateTime = compare > 0 ? recDuration.getFirstStartDateTime() : getYearMonthDay(EgovDateUtil.convertDate(destParam.getRecStartDateTime(), "yyyy-MM-dd HH:mm:ss", "yyyy-MM-dd aa h:mm:ss", ""));
		String interEndDateTime = recDuration.getLastStartDateTime();
		
		ResObjArrayDestVO objArrayDest = new ResObjArrayDestVO();
		objArrayDest.setInterStartDateTime(interStartDateTime);
		objArrayDest.setInterEndDateTime(interEndDateTime);
		//objArrayDest.setWriterID(dtDest.get(0).getWriterID());
		//objArrayDest.setDeptNm(dtDest.get(0).getDeptNm());
		//objArrayDest.setOwnerNm(dtDest.get(0).getOwnerNm());
		//objArrayDest.setTitle(dtDest.get(0).getTitle());
		//objArrayDest.setWriteDay(dtDest.get(0).getWriteDay());
		
		switch (destParam.getRecReWay()) {
		case 40:
			dtDest = chkDupReway40(destParam, dtDest, objArrayDest);
			break;
		case 41:
			dtDest = chkDupReway41(destParam, dtDest, objArrayDest);
			break;
		case 51:
			dtDest = chkDupReway51(destParam, dtDest, objArrayDest);
			break;
		case 60:
			dtDest = chkDupReway60(destParam, dtDest, objArrayDest);
			break;
		case 61:
			dtDest = chkDupReway61(destParam, dtDest, objArrayDest);
			break;
		case 70:
			dtDest = chkDupReway70(destParam, dtDest, objArrayDest);
			break;
		case 71:
			dtDest = chkDupReway71(destParam, dtDest, objArrayDest);
			break;
		default:
			break;
		}
		

		logger.debug("makeRepResource2 ended");

	
		return dtDest;
	}
	
	public ResRecParamVO resStruct(String strFrequency, String strSelType, String strEndREcurType, String strStartDateTime, String strEndDateTime, String strInterval, String strDaysOfWeek, String strInstances, String strByPosition, String strDaysOfMonth) {
		logger.debug("resStruct started");

		int reWay = -1;
		int endFlag = -1;
		int reCount = -1;
		int reNum = 1;
		String reYoil = "";
		int reDay = -1;
		int reOrd = -10;
		String startDateTime = "";
		String endDateTime = "";
		int allDay = -1;
		
		if (!strFrequency.equals("") && !strSelType.equals("")) {
			reWay = Integer.parseInt(strFrequency) * 10 + Integer.parseInt(strSelType);
		}
		if (!strEndREcurType.equals("")) {
			endFlag = Integer.parseInt(strEndREcurType);
		}
		if (!strInstances.equals("")) {
			reCount = Integer.parseInt(strInstances);
		}
		/*if (!strInterval.equals("")) {
			reNum = Integer.parseInt(strInstances);
		}*/
		if (!strDaysOfWeek.equals("")) {
			reYoil = strDaysOfWeek;
		}
		if (!strDaysOfMonth.equals("")) {
			reDay = Integer.parseInt(strDaysOfMonth);
		}
		if (!strByPosition.equals("")) {
			reOrd = Integer.parseInt(strByPosition);
		}
		if (!strStartDateTime.equals("")) {
			startDateTime = strStartDateTime;
		}
		if (!strEndDateTime.equals("")) {
			endDateTime = strEndDateTime;
		}
		if (Integer.parseInt(strEndREcurType) == 0) {
			reCount = 1000;
			endFlag = 1;
		}
		
		ResRecParamVO result = new ResRecParamVO();
		result.setRecAllDay(allDay);
		result.setRecEndDateTime(endDateTime);
		result.setRecEndFlag(endFlag);
		result.setRecReCount(reCount);
		result.setRecReDay(reDay);
		result.setRecReNum(reNum);
		result.setRecReOrd(reOrd);
		result.setRecReWay(reWay);
		result.setRecReYoil(reYoil);
		result.setRecStartDateTime(startDateTime);
		
		logger.debug("resStruct ended");
		
		return result;
	}
	
	
	@SuppressWarnings("deprecation")
	public List<ResMakeDupResultVO> chkDupReway40 (ResRecParamVO recParam, List<ResMakeDupResultVO> dt, ResObjArrayDestVO objParam) throws Exception {
		int recLoop = 0;
		SimpleDateFormat date = new SimpleDateFormat("yyyy-MM-dd aa h:mm:ss");
		SimpleDateFormat date1 = new SimpleDateFormat("yyyy-MM-dd HH:mm");
		//반복회수 지정
		if (recParam.getRecEndFlag() == 1) {
			while (recLoop < recParam.getRecReCount()) {
				String dsStartDateTime = EgovDateUtil.convertDate(EgovDateUtil.addDay(recParam.getRecStartDateTime(), (recLoop * recParam.getRecReNum() * 1), "yyyy-MM-dd HH:mm"), "yyyy-MM-dd HH:mm", "yyyy-MM-dd aa h:mm:ss", ""); 
				String dsEndDateTime = String.valueOf(date1.parse(recParam.getRecStartDateTime()).getYear()+1900) + String.valueOf(date1.parse(recParam.getRecStartDateTime()).getMonth()+1) + String.valueOf(date1.parse(recParam.getRecStartDateTime()).getDate())+ String.valueOf(date1.parse(recParam.getRecEndDateTime()).getHours()) + String.valueOf(date1.parse(recParam.getRecEndDateTime()).getMinutes()) +String.valueOf(date1.parse(recParam.getRecEndDateTime()).getSeconds());
				dsEndDateTime = EgovDateUtil.convertDate(EgovDateUtil.addDay(dsEndDateTime, recLoop * recParam.getRecReNum() * 1, "yyyyMMddHHmm"), "yyyyMMddHHmm", "yyyy-MM-dd aa h:mm:ss", "");
				
				ResMakeDupResultVO s1 = new ResMakeDupResultVO();
				s1.setStartDateTime(addSeconds(dsStartDateTime, -date.parse(dsStartDateTime).getSeconds(), "yyyy-MM-dd aa h:mm:ss"));
				s1.setEndDateTime(addSeconds(dsEndDateTime, -date.parse(dsEndDateTime).getSeconds(), "yyyy-MM-dd aa h:mm:ss"));
				dt.add(recLoop, s1);
				recLoop ++;
			}
		}
		
		//종료일 지정
		if (recParam.getRecEndFlag() == 2) {
			String compare1 = getYearMonthDay(EgovDateUtil.convertDate(EgovDateUtil.addDay(recParam.getRecStartDateTime(), (recLoop * recParam.getRecReNum() * 1), "yyyy-MM-dd HH:mm"), "yyyy-MM-dd HH:mm", "yyyy-MM-dd aa h:mm:ss", ""));
			String compare2 = getYearMonthDay(recParam.getRecEndDateTime()); 
			
			Date day1 = date.parse(compare1);
			Date day2 = date.parse(compare2);
			int compare = day1.compareTo(day2);
			
			while (compare <= 0) {
				String dsStartDateTime = EgovDateUtil.convertDate(EgovDateUtil.addDay(recParam.getRecStartDateTime(), (recLoop * recParam.getRecReNum() * 1), "yyyy-MM-dd HH:mm"), "yyyy-MM-dd HH:mm", "yyyy-MM-dd aa h:mm:ss", "");
				String dsEndDateTime = String.valueOf(date1.parse(recParam.getRecStartDateTime()).getYear()+1900) + String.valueOf(date1.parse(recParam.getRecStartDateTime()).getMonth()+1) + String.valueOf(date1.parse(recParam.getRecStartDateTime()).getDate())+ String.valueOf(date1.parse(recParam.getRecEndDateTime()).getHours()) + String.valueOf(date1.parse(recParam.getRecEndDateTime()).getMinutes()) +String.valueOf(date1.parse(recParam.getRecEndDateTime()).getSeconds());
				dsEndDateTime = EgovDateUtil.convertDate(EgovDateUtil.addDay(dsEndDateTime, recLoop * recParam.getRecReNum() * 1, "yyyyMMddHHmm"), "yyyyMMddHHmm", "yyyy-MM-dd aa h:mm:ss", "");
				
				ResMakeDupResultVO s1 = new ResMakeDupResultVO();
				s1.setStartDateTime(addSeconds(dsStartDateTime, -date.parse(dsStartDateTime).getSeconds(), "yyyy-MM-dd aa h:mm:ss"));
				s1.setEndDateTime(addSeconds(dsEndDateTime, -date.parse(dsEndDateTime).getSeconds(), "yyyy-MM-dd aa h:mm:ss"));
				dt.add(recLoop, s1);
				recLoop ++;
			}
		}
	
		return dt;
	}
	
	@SuppressWarnings("deprecation")
	public List<ResMakeDupResultVO> chkDupReway41 (ResRecParamVO recParam, List<ResMakeDupResultVO> dt, ResObjArrayDestVO objParam) throws Exception {
		int recLoop = 0;
		int recLoopOffset = 0;
		SimpleDateFormat date = new SimpleDateFormat("yyyy-MM-dd aa h:mm:ss");
		SimpleDateFormat date1 = new SimpleDateFormat("yyyy-MM-dd HH:mm");
		if (recParam.getRecEndFlag() == 1) {
			while (recLoop < recParam.getRecReCount()) {
				int addOffset = 0;
				String temp = EgovDateUtil.convertDate(EgovDateUtil.addDay(recParam.getRecStartDateTime(), (recLoop * recParam.getRecReNum() * 1), "yyyy-MM-dd HH:mm"), "yyyy-MM-dd HH:mm", "yyyy-MM-dd aa h:mm:ss", "");
				
				
				switch (dayOfWeek(temp)) {
				case 1:
					addOffset = 1;
					break;
				case 7:
					addOffset = 2;
					break;
				default:
					addOffset = 0;
					break;
				}
				recLoopOffset += addOffset;
				
				//구하고
				String dsStartDateTime = EgovDateUtil.convertDate(EgovDateUtil.addDay(recParam.getRecStartDateTime(), (recLoop * recLoopOffset), "yyyy-MM-dd HH:mm"), "yyyy-MM-dd HH:mm", "yyyy-MM-dd aa h:mm:ss", "");
				String dsEndDateTime = String.valueOf(date1.parse(recParam.getRecStartDateTime()).getYear()+1900) + String.valueOf(date1.parse(recParam.getRecStartDateTime()).getMonth()+1) + String.valueOf(date1.parse(recParam.getRecStartDateTime()).getDate())+ String.valueOf(date1.parse(recParam.getRecEndDateTime()).getHours()) + String.valueOf(date1.parse(recParam.getRecEndDateTime()).getMinutes()) +String.valueOf(date1.parse(recParam.getRecEndDateTime()).getSeconds());
				dsEndDateTime = EgovDateUtil.convertDate(EgovDateUtil.addDay(dsEndDateTime, recLoop + recLoopOffset, "yyyyMMddHHmm"), "yyyyMMddHHmm", "yyyy-MM-dd aa h:mm:ss", "");
				
				//넣는다
				ResMakeDupResultVO s1 = new ResMakeDupResultVO();
				s1.setStartDateTime(addSeconds(dsStartDateTime, -date.parse(dsStartDateTime).getSeconds(), "yyyy-MM-dd aa h:mm:ss"));
				s1.setEndDateTime(addSeconds(dsEndDateTime, -date.parse(dsEndDateTime).getSeconds(), "yyyy-MM-dd aa h:mm:ss"));
				dt.add(recLoop, s1);
				
				recLoop ++;
			}
		}
		if (recParam.getRecEndFlag() == 2) {
			String compare1 = getYearMonthDay(EgovDateUtil.convertDate(EgovDateUtil.addDay(recParam.getRecStartDateTime(), (recLoop + recLoopOffset), "yyyy-MM-dd HH:mm"), "yyyy-MM-dd HH:mm", "yyyy-MM-dd aa h:mm:ss", ""));
			String compare2 = getYearMonthDay(recParam.getRecEndDateTime()); 
			Date day1 = date.parse(compare1);
			Date day2 = date.parse(compare2);
			int compare = day1.compareTo(day2);
			
			while (compare <= 0) {
				int addOffest = 0;
				String temp = EgovDateUtil.convertDate(EgovDateUtil.addDay(recParam.getRecStartDateTime(), (recLoop + recLoopOffset), "yyyy-MM-dd HH:mm"), "yyyy-MM-dd HH:mm", "yyyy-MM-dd aa h:mm:ss", "");
				
				switch (dayOfWeek(temp)) {
					case 1:
						addOffest = 1;
						break;
					case 7:
						addOffest = 1;
						break;
					default:
						addOffest = 0;
						break;
				}
				// 평일이 아닐 때, 전체일 수는 증가해야 하므로.
				recLoopOffset += addOffest;   
				
				//평일이 아니면 다음
				if (addOffest != 0) {
					continue;
				}
				
				//구하고
				String dsStartDateTime = EgovDateUtil.convertDate(EgovDateUtil.addDay(recParam.getRecStartDateTime(), (recLoop + recLoopOffset), "yyyy-MM-dd HH:mm"), "yyyy-MM-dd HH:mm", "yyyy-MM-dd aa h:mm:ss", "");
				String dsEndDateTime = String.valueOf(date.parse(recParam.getRecStartDateTime()).getYear()) + String.valueOf(date.parse(recParam.getRecStartDateTime()).getMonth()+1) + String.valueOf(date.parse(recParam.getRecStartDateTime()).getDate())+ String.valueOf(date.parse(recParam.getRecEndDateTime()).getHours()) + String.valueOf(date.parse(recParam.getRecEndDateTime()).getMinutes()) +String.valueOf(date.parse(recParam.getRecEndDateTime()).getSeconds());
				dsEndDateTime = EgovDateUtil.convertDate(EgovDateUtil.addDay(dsEndDateTime, recLoop + recLoopOffset, "yyyyMMddHHmm"), "yyyyMMddHHmm", "yyyy-MM-dd aa h:mm:ss", "");
				//넣는다
				ResMakeDupResultVO s1 = new ResMakeDupResultVO();
				s1.setStartDateTime(addSeconds(dsStartDateTime, -date.parse(dsStartDateTime).getSeconds(), "yyyy-MM-dd aa h:mm:ss"));
				s1.setEndDateTime(addSeconds(dsEndDateTime, -date.parse(dsEndDateTime).getSeconds(), "yyyy-MM-dd aa h:mm:ss"));
				dt.add(recLoop, s1);
				
				recLoop ++;
			}
		}
		
		return dt;
	}
	
	@SuppressWarnings("deprecation")
	public List<ResMakeDupResultVO> chkDupReway51 (ResRecParamVO recParam, List<ResMakeDupResultVO> dt, ResObjArrayDestVO objParam) throws Exception {
		logger.debug("chkDupReway51 started");

		int recLoop = 0;
		int recLoopOffset = 0;
		int recMondayOffset = 1-datePartLeftShift(EgovDateUtil.convertDate(recParam.getRecStartDateTime(), "yyyy-MM-dd HH:mm", "yyyy-MM-dd aa h:mm:ss", ""));
		int recMondayOffsetAdd = 0;
		SimpleDateFormat date = new SimpleDateFormat("yyyy-MM-dd aa h:mm:ss");
		SimpleDateFormat date1 = new SimpleDateFormat("yyyy-MM-dd HH:mm");
		
		if (recParam.getRecEndFlag() == 1) {
			while (recLoop < recParam.getRecReCount()) {
				//주에서 월,화,수,목,금,토,일
				while (recMondayOffsetAdd < 7) {
					if (recParam.getRecReYoil().replace("0,", "7,").indexOf(String.valueOf(recMondayOffsetAdd+1)) == -1) {
						recMondayOffsetAdd++;
						continue;
					}
					
					//구하고
					String dsStartDateTime = EgovDateUtil.convertDate(EgovDateUtil.addDay(recParam.getRecStartDateTime(), (recLoop * recParam.getRecReNum() * 7), "yyyy-MM-dd HH:mm"), "yyyy-MM-dd HH:mm", "yyyy-MM-dd aa h:mm:ss", "");
					dsStartDateTime = EgovDateUtil.convertDate(EgovDateUtil.addDay(dsStartDateTime, (recMondayOffset + recMondayOffsetAdd), "yyyy-MM-dd aa h:mm:ss"), "yyyy-MM-dd aa h:mm:ss", "yyyy-MM-dd aa h:mm:ss", "");
					String tempMonth = "";
					String month = "";
					tempMonth = String.valueOf(date1.parse(recParam.getRecStartDateTime()).getMonth()+1);
					if ((date1.parse(recParam.getRecStartDateTime()).getMonth()+1) < 10) {
						month = "0"+tempMonth;
					} else {
						month = tempMonth;
					}
					String tempDay = "";
					String day = "";
					tempDay = String.valueOf(date1.parse(recParam.getRecStartDateTime()).getDate());
					if ((date1.parse(recParam.getRecStartDateTime()).getDate()) < 10) {
						day = "0"+tempDay;
					} else {
						day = tempDay;
					}
					
					String dsEndDateTime = String.valueOf(date1.parse(recParam.getRecStartDateTime()).getYear()+1900) + month + day+ String.valueOf(date1.parse(recParam.getRecEndDateTime()).getHours()) + String.valueOf(date1.parse(recParam.getRecEndDateTime()).getMinutes());
					dsEndDateTime = EgovDateUtil.convertDate(EgovDateUtil.addDay(dsEndDateTime, recLoop * recParam.getRecReNum() * 7, "yyyyMMddHHmm"), "yyyyMMddHHmm", "yyyy-MM-dd aa h:mm:ss", "");
					dsEndDateTime = EgovDateUtil.convertDate(EgovDateUtil.addDay(dsEndDateTime, recMondayOffset + recMondayOffsetAdd, "yyyy-MM-dd aa h:mm:ss"), "yyyy-MM-dd aa h:mm:ss", "yyyy-MM-dd aa h:mm:ss", "");
					
					
					//비교한 다음
					String compare1 = dsStartDateTime;
					String compare2 = EgovDateUtil.convertDate(recParam.getRecStartDateTime(), "yyyy-MM-dd HH:mm", "yyyy-MM-dd aa h:mm:ss", ""); 
					Date day1 = date.parse(compare1);
					Date day2 = date.parse(compare2);
					int compare = day1.compareTo(day2);
					
					if (compare < 0) {
						recMondayOffsetAdd++;
						continue;
					}
					
					ResMakeDupResultVO s1 = new ResMakeDupResultVO();
					s1.setStartDateTime(addSeconds(dsStartDateTime, -date.parse(dsStartDateTime).getSeconds(), "yyyy-MM-dd aa h:mm:ss"));
					s1.setEndDateTime(addSeconds(dsEndDateTime, -date.parse(dsEndDateTime).getSeconds(), "yyyy-MM-dd aa h:mm:ss"));
					dt.add(recLoop, s1);
					
					recMondayOffsetAdd++;
				}
				recMondayOffsetAdd = 0;
				recLoop++;
			}			
		}
		
		//종료일지정
		if (recParam.getRecEndFlag() == 2) {
			logger.debug("endFlag=2");
			////2017-01-24
			//date형식변경
			String dsStartDateTimeLoop = "";
			dsStartDateTimeLoop = "1900-01-01 오전 1:00:00";
			/*logger.debug("dsStartDateTimeLoop="+dsStartDateTimeLoop);
			logger.debug("recEndDateTime="+recParam.getRecEndDateTime());
			String compare1 = getYearMonthDay(dsStartDateTimeLoop);
			compare1 = EgovDateUtil.convertDate(compare1, "yyyyMMdd", "yyyy-MM-dd aa h:mm:ss", "");
			String compare2 = getYearMonthDay(EgovDateUtil.convertDate(recParam.getRecEndDateTime(), "yyyy-MM-dd HH:mm", "yyyy-MM-dd aa h:mm:ss", ""));
			compare2 = EgovDateUtil.convertDate(compare2, "yyyyMMdd", "yyyy-MM-dd aa h:mm:ss", "");
			
			logger.debug("compare1="+compare1);
			logger.debug("compare2="+compare2);
			
			Date day1 = date.parse(compare1);
			Date day2 = date.parse(compare2);
			int compare = day1.compareTo(day2);*/
			
			int compare = 0;
			
			while (compare <= 0) {
				logger.debug("compare="+compare);
				//주에서 월,화,수,목,금,토,일
				logger.debug("recMondayOffsetAdd="+recMondayOffsetAdd);
				while (recMondayOffsetAdd < 7) {
					logger.debug("recMondayOffsetAdd1="+recMondayOffsetAdd);
					if (recParam.getRecReYoil().replace("0,", "7,").indexOf(String.valueOf(recMondayOffsetAdd+1)) == -1) {
						recMondayOffsetAdd++;
						logger.debug("recMondayOffsetAdd2="+recMondayOffsetAdd);
						continue;
					}
					
					logger.debug("reNum="+recParam.getRecReNum());
					logger.debug("recLoop="+recLoop);
					
					// 구하고
					String dsStartDateTime = EgovDateUtil.convertDate(EgovDateUtil.addDay(recParam.getRecStartDateTime(), (recLoop * recParam.getRecReNum() * 7), "yyyy-MM-dd HH:mm"), "yyyy-MM-dd HH:mm", "yyyy-MM-dd aa h:mm:ss", "");
					logger.debug("dsStartDatetime1="+dsStartDateTime);
					dsStartDateTime = EgovDateUtil.convertDate(EgovDateUtil.addDay(dsStartDateTime, (recMondayOffset + recMondayOffsetAdd), "yyyy-MM-dd aa h:mm:ss"), "yyyy-MM-dd aa h:mm:ss", "yyyy-MM-dd aa h:mm:ss", "");
					logger.debug("dsStartDateTime2="+dsStartDateTime);
					
					String tempMonth = "";
					String month = "";
					tempMonth = String.valueOf(date1.parse(recParam.getRecStartDateTime()).getMonth()+1);
					
					if ((date1.parse(recParam.getRecStartDateTime()).getMonth()+1) < 10) {
						month = "0"+tempMonth;
					} else {
						month = tempMonth;
					}
					
					String tempDay = "";
					String day = "";
					tempDay = String.valueOf(date1.parse(recParam.getRecStartDateTime()).getDate());
					
					if ((date1.parse(recParam.getRecStartDateTime()).getDate()) < 10) {
						day = "0"+tempDay;
					} else {
						day = tempDay;
					}
					
					logger.debug("recParam StartDate="+recParam.getRecStartDateTime());
					logger.debug("recParam EndDate="+recParam.getRecEndDateTime());
					String recStartDateTime = EgovDateUtil.convertDate(recParam.getRecStartDateTime(), "yyyy-MM-dd HH:mm", "yyyy-MM-dd aa h:mm:ss", "");
					String recEndDateTime = EgovDateUtil.convertDate(recParam.getRecEndDateTime(), "yyyy-MM-dd HH:mm", "yyyy-MM-dd aa h:mm:ss", "");
					//2017-01-25 
					//데이트형식 yyyy-MM-dd HH:mm:ss 에서 yyyy-MM-dd aa h:mm:ss로 변경
					String dsEndDateTime = String.valueOf(date.parse(recStartDateTime).getYear()+1900) + month + day+ String.valueOf(date.parse(recEndDateTime).getHours()) + String.valueOf(date.parse(recEndDateTime).getMinutes());
					dsEndDateTime = EgovDateUtil.convertDate(EgovDateUtil.addDay(dsEndDateTime, recLoop * recParam.getRecReNum() * 7, "yyyyMMddHHmm"), "yyyyMMddHHmm", "yyyy-MM-dd aa h:mm:ss", "");
					dsEndDateTime = EgovDateUtil.convertDate(EgovDateUtil.addDay(dsEndDateTime, recMondayOffset + recMondayOffsetAdd, "yyyy-MM-dd aa h:mm:ss"), "yyyy-MM-dd aa h:mm:ss", "yyyy-MM-dd aa h:mm:ss", "");
					//compare 값 넣어줌
					dsStartDateTimeLoop = dsStartDateTime;
					logger.debug("dsStartDateTimeLoop="+dsStartDateTimeLoop);
					logger.debug("recEndDateTime="+recParam.getRecEndDateTime());
					String compare1 = getYearMonthDay(dsStartDateTimeLoop);
					compare1 = EgovDateUtil.convertDate(compare1, "yyyyMMdd", "yyyy-MM-dd aa h:mm:ss", "");
					String compare2 = getYearMonthDay(EgovDateUtil.convertDate(recParam.getRecEndDateTime(), "yyyy-MM-dd HH:mm", "yyyy-MM-dd aa h:mm:ss", ""));
					compare2 = EgovDateUtil.convertDate(compare2, "yyyyMMdd", "yyyy-MM-dd aa h:mm:ss", "");
					
					logger.debug("compare1="+compare1);
					logger.debug("compare2="+compare2);
					
					Date day1 = date.parse(compare1);
					Date day2 = date.parse(compare2);
					compare = day1.compareTo(day2);
					//
					
					logger.debug("dsStartDateTimeLoop1="+dsStartDateTimeLoop);
					
					// 비교한다음
					String compare3 = dsStartDateTime;
					
					//String compare4 = recParam.getRecStartDateTime();
					String compare4 = recStartDateTime;
					String compare5 = getYearMonthDay(dsStartDateTime);
					compare5 = EgovDateUtil.convertDate(compare5, "yyyyMMdd", "yyyy-MM-dd aa h:mm:ss", "");
					String compare6 = getYearMonthDay(recEndDateTime);
					compare6 = EgovDateUtil.convertDate(compare6, "yyyyMMdd", "yyyy-MM-dd aa h:mm:ss", "");
					logger.debug("compare3="+compare3);
					logger.debug("compare4="+compare4);
					logger.debug("compare5="+compare5);
					logger.debug("compare6="+compare6);
					Date day3 = date.parse(compare3);
					Date day4 = date.parse(compare4);
					Date day5 = date.parse(compare5);
					Date day6 = date.parse(compare6);
					int secondCompare = day3.compareTo(day4);
					int thirdCompare = day5.compareTo(day6);
					
					logger.debug("recMondayOffsetAdd Start="+recMondayOffsetAdd);
					if (secondCompare < 0 || thirdCompare > 0) {
						recMondayOffsetAdd++;
						logger.debug("recMondayOffsetAdd Ing="+recMondayOffsetAdd);
						continue;
					}
					logger.debug("recMondayOffsetAdd End="+recMondayOffsetAdd);
					
					ResMakeDupResultVO s1 = new ResMakeDupResultVO();
					s1.setStartDateTime(addSeconds(dsStartDateTime, -date.parse(dsStartDateTime).getSeconds(), "yyyy-MM-dd aa h:mm:ss"));
					s1.setEndDateTime(addSeconds(dsEndDateTime, -date.parse(dsEndDateTime).getSeconds(), "yyyy-MM-dd aa h:mm:ss"));
					dt.add(recLoop, s1);
					
					recMondayOffsetAdd++;
				}
				recMondayOffsetAdd = 0;
				recLoop++;
			}
		}

		logger.debug("chkDupReway51 ended");

		return dt;
	}
	
	@SuppressWarnings("deprecation")
	public List<ResMakeDupResultVO> chkDupReway60 (ResRecParamVO recParam, List<ResMakeDupResultVO> dt, ResObjArrayDestVO objParam) throws Exception {
		logger.debug("chkDupReway60 started");

		int recLoop = 0;
		
		SimpleDateFormat date = new SimpleDateFormat("yyyy-MM-dd aa h:mm:ss");
		SimpleDateFormat date1 = new SimpleDateFormat("yyyy-MM-dd HH:mm");
		
		//반복회수지정
		if (recParam.getRecEndFlag() == 1) {
			while (recLoop < recParam.getRecReCount()) {
				//구하고
				String dsStartDateTime = getSomeDay(EgovDateUtil.convertDate(EgovDateUtil.addMonth(getFirstDay(EgovDateUtil.convertDate(recParam.getRecStartDateTime(), "yyyy-MM-dd HH:mm", "yyyy-MM-dd aa h:mm:ss", "")), recLoop * recParam.getRecReNum() * 1, "yyyy-MM-dd aa h:mm:ss"),"yyyy-MM-dd aa h:mm:ss","yyyy-MM-dd aa h:mm:ss",""), recParam.getRecReDay());
				String dsEndDateTime = getYearMonthDay(getSomeDay(EgovDateUtil.convertDate(EgovDateUtil.addMonth(getFirstDay(EgovDateUtil.convertDate(recParam.getRecStartDateTime(), "yyyy-MM-dd HH:mm", "yyyy-MM-dd aa h:mm:ss", "")), recLoop * recParam.getRecReNum() * 1, "yyyy-MM-dd aa h:mm:ss"), "yyyy-MM-dd aa h:mm:ss","yyyy-MM-dd aa h:mm:ss",""),recParam.getRecReDay())) + String.valueOf(date1.parse(recParam.getRecEndDateTime()).getHours()) + String.valueOf(date1.parse(recParam.getRecEndDateTime()).getMinutes()) + String.valueOf(date1.parse(recParam.getRecEndDateTime()).getSeconds());
				dsEndDateTime = EgovDateUtil.convertDate(dsEndDateTime, "yyyyMMddHHmm", "yyyy-MM-dd aa h:mm:ss", "");
				
				//비교한다음
				String compare1 = EgovDateUtil.convertDate(dsStartDateTime, "yyyy-MM-dd aa h:mm:ss", "yyyy-MM-dd aa h:mm:ss", "");
				String compare2 = EgovDateUtil.convertDate(recParam.getRecStartDateTime(), "yyyy-MM-dd HH:mm", "yyyy-MM-dd aa h:mm:ss", ""); 
				Date day1 = date.parse(compare1);
				Date day2 = date.parse(compare2);
				int compare = day1.compareTo(day2);
				
				if (compare < 0) {
					recLoop++;
					recParam.getRecReCount();
					continue;
				}
				//넣는다
				ResMakeDupResultVO s1 = new ResMakeDupResultVO();
				s1.setStartDateTime(addSeconds(dsStartDateTime, -date.parse(dsStartDateTime).getSeconds(), "yyyy-MM-dd aa h:mm:ss"));
				s1.setEndDateTime(addSeconds(dsEndDateTime, -date.parse(dsEndDateTime).getSeconds(), "yyyy-MM-dd aa h:mm:ss"));
				dt.add(recLoop, s1);
				
				recLoop++;
			}
		}
		//종료일지정
		if (recParam.getRecEndFlag() == 2) {
			String dsStartDateTimeLoop = "1900-01-01 오전 1:00:00";
			
			/*String compare1 = getYearMonthDay(dsStartDateTimeLoop);
			compare1 = EgovDateUtil.convertDate(compare1, "yyyyMMdd", "yyyy-MM-dd aa h:mm:ss", "");
			String compare2 = getYearMonthDay(EgovDateUtil.convertDate(recParam.getRecEndDateTime(), "yyyy-MM-dd HH:mm", "yyyy-MM-dd aa h:mm:ss", ""));
			compare2 = EgovDateUtil.convertDate(compare2, "yyyyMMdd", "yyyy-MM-dd aa h:mm:ss", "");
			Date day1 = date.parse(compare1);
			Date day2 = date.parse(compare2);
			int compare = day1.compareTo(day2);*/
			int compare = 0;
			while (compare <= 0) {
				String compare1 = getYearMonthDay(dsStartDateTimeLoop);
				compare1 = EgovDateUtil.convertDate(compare1, "yyyyMMdd", "yyyy-MM-dd aa h:mm:ss", "");
				String compare2 = getYearMonthDay(EgovDateUtil.convertDate(recParam.getRecEndDateTime(), "yyyy-MM-dd HH:mm", "yyyy-MM-dd aa h:mm:ss", ""));
				compare2 = EgovDateUtil.convertDate(compare2, "yyyyMMdd", "yyyy-MM-dd aa h:mm:ss", "");
				Date day1 = date.parse(compare1);
				Date day2 = date.parse(compare2);
				compare = day1.compareTo(day2);
				
				//구하고
				logger.debug("recStartDateTime="+recParam.getRecStartDateTime());
				String dsStartDateTime = getSomeDay(EgovDateUtil.convertDate(EgovDateUtil.addMonth(getFirstDay(EgovDateUtil.convertDate(recParam.getRecStartDateTime(), "yyyy-MM-dd HH:mm", "yyyy-MM-dd aa hh:mm:ss", "")), recLoop * recParam.getRecReNum() * 1, ""),"yyyyMMdd","yyyy-MM-dd aa h:mm:ss",""), recParam.getRecReDay());
				//String dsEndDateTime = getYearMonthDay(getSomeDay(EgovDateUtil.convertDate(EgovDateUtil.addMonth(getFirstDay(EgovDateUtil.convertDate(recParam.getRecStartDateTime(), "yyyy-MM-dd HH:mm", "yyyy-MM-dd aa h:mm:ss", "")), recLoop * recParam.getRecReNum() * 1, "yyyy-MM-dd aa h:mm:ss"), "yyyy-MM-dd HH:mm","yyyy-MM-dd aa h:mm:ss",""),recParam.getRecReDay())) + String.valueOf(date.parse(recParam.getRecEndDateTime()).getHours()) + String.valueOf(date.parse(recParam.getRecEndDateTime()).getMinutes()) + String.valueOf(date.parse(recParam.getRecEndDateTime()).getSeconds());
				logger.debug("dsStartDateTime="+dsStartDateTime);
				
				String dsEndDateTime = getYearMonthDay(getSomeDay(EgovDateUtil.convertDate(EgovDateUtil.addMonth(getFirstDay(EgovDateUtil.convertDate(recParam.getRecStartDateTime(), "yyyy-MM-dd HH:mm", "yyyy-MM-dd aa h:mm:ss", "")), recLoop * recParam.getRecReNum() * 1, "yyyy-MM-dd aa h:mm:ss"), "yyyy-MM-dd aa h:mm:ss","yyyy-MM-dd aa h:mm:ss",""),recParam.getRecReDay())) + String.valueOf(date1.parse(recParam.getRecEndDateTime()).getHours()) + String.valueOf(date1.parse(recParam.getRecEndDateTime()).getMinutes()) + String.valueOf(date1.parse(recParam.getRecEndDateTime()).getSeconds());
				//dsEndDateTime = EgovDateUtil.convertDate(dsEndDateTime, "yyyyMMddHHmm", "yyyy-MM-dd aa h:mm:ss", "");
				dsEndDateTime = EgovDateUtil.convertDate(dsEndDateTime, "yyyyMMdd", "yyyy-MM-dd aa h:mm:ss", "");
				logger.debug("dsEndDateTime="+dsEndDateTime);
				dsStartDateTimeLoop = dsStartDateTime;
				
				//비교한 다음
				/*String compare3 = dsStartDateTime;
				String compare4 = EgovDateUtil.convertDate(recParam.getRecStartDateTime(), "yyyy-MM-dd HH:mm", "yyyy-MM-dd aa h:mm:ss", ""); 
				Date day3 = date.parse(compare3);
				Date day4 = date.parse(compare4);
				int subCompare = day3.compareTo(day4);*/
				
				int subCompare = 0;
				
				if (subCompare < 0) {
					String compare3 = dsStartDateTime;
					String compare4 = EgovDateUtil.convertDate(recParam.getRecStartDateTime(), "yyyy-MM-dd HH:mm", "yyyy-MM-dd aa h:mm:ss", ""); 
					Date day3 = date.parse(compare3);
					Date day4 = date.parse(compare4);
					subCompare = day3.compareTo(day4);
					
					recLoop++;
					continue;
				}
				//넣는다
				ResMakeDupResultVO s1 = new ResMakeDupResultVO();
				s1.setStartDateTime(addSeconds(dsStartDateTime, -date.parse(dsStartDateTime).getSeconds(), "yyyy-MM-dd aa h:mm:ss"));
				s1.setEndDateTime(addSeconds(dsEndDateTime, -date.parse(dsEndDateTime).getSeconds(), "yyyy-MM-dd aa h:mm:ss"));
				dt.add(recLoop, s1);
				
				recLoop++;
			}
		}
		

		logger.debug("chkDupReway60 ended");
	
		return dt;
	}
	
	@SuppressWarnings("deprecation")
	public List<ResMakeDupResultVO> chkDupReway61 (ResRecParamVO recParam, List<ResMakeDupResultVO> dt, ResObjArrayDestVO objParam) throws Exception {
		logger.debug("chkDupReway61 started");

		ResMakeDupResultVO s1 = new ResMakeDupResultVO();
		SimpleDateFormat date = new SimpleDateFormat("yyyy-MM-dd aa h:mm:ss");
		SimpleDateFormat date1 = new SimpleDateFormat("yyyy-MM-dd HH:mm");
		
		if (recParam.getRecReOrd() == -1) {
			dt = chkDupReway61_2(recParam, dt);
			return dt;
		}
		
		int recLoop = 0;
		
		// 시작일의 달 1일
		String recFirstStartDate = getFirstDay(EgovDateUtil.convertDate(recParam.getRecStartDateTime(), "yyyy-MM-dd HH:mm", "yyyy-MM-dd aa h:mm:ss", ""));
		recFirstStartDate = EgovDateUtil.convertDate(recFirstStartDate, "yyyy-MM-dd aa h:mm:ss", "yyyy-MM-dd HH:mm", "");
		int recMondayOffsetAdd = 0;
		// 단 하나의 요일일때 : 주말이나 평일일때
		boolean isOneDay = (recParam.getRecReYoil().indexOf(",") == -1);
		// 단 하나의 요일이므로 미리 구하여 불필요한 반복 없앰
		int recReOneYoil = isOneDay ? Integer.parseInt(recParam.getRecReYoil()) : -1;
		if (recReOneYoil == 0) {
			//일요일
			recReOneYoil = 7;
		}
		//반복회수지정
		if (recParam.getRecEndFlag() == 1) {
			//하나의 요일일때
			if (isOneDay) {
				while (recLoop < recParam.getRecReCount()) {
					//몇월 1일
					String recFirstDate = EgovDateUtil.convertDate(EgovDateUtil.addMonth(recFirstStartDate, recLoop * recParam.getRecReNum() * 1, "yyyy-MM-dd HH:mm"),"yyyy-MM-dd HH:mm","yyyy-MM-dd aa h:mm:ss","");
					
					//몇째 요일의 일
					int recPartDay = (recParam.getRecReOrd()-1) * 7 + recReOneYoil + (1-datePartLeftShift(recFirstDate));
					recPartDay += (recReOneYoil < datePartLeftShift(recFirstDate) ? 7:0);
					
					//구하고
					String dsStartDateTime = getSomeDay(recFirstDate, recPartDay);
					String tempMonth = "";
					String month = "";
					tempMonth = String.valueOf(date1.parse(recParam.getRecStartDateTime()).getMonth()+1);
					if ((date1.parse(recParam.getRecStartDateTime()).getMonth()+1) < 10) {
						month = "0"+tempMonth;
					} else {
						month = tempMonth;
					}
					String tempDay = "";
					String day = "";
					tempDay = String.valueOf(date1.parse(recParam.getRecStartDateTime()).getDate());
					if ((date1.parse(recParam.getRecStartDateTime()).getDate()) < 10) {
						day = "0"+tempDay;
					} else {
						day = tempDay;
					}
					
					String dsEndDateTime = String.valueOf(date1.parse(recParam.getRecStartDateTime()).getYear()+1900) + month + day+ String.valueOf(date1.parse(recParam.getRecEndDateTime()).getHours()) + String.valueOf(date1.parse(recParam.getRecEndDateTime()).getMinutes());
					dsEndDateTime = EgovDateUtil.convertDate(dsEndDateTime, "yyyyMMddHHmm", "yyyy-MM-dd aa h:mm:ss", "");
					//비교한다음
					String compare1 = dsStartDateTime;
					String compare2 = EgovDateUtil.convertDate(recParam.getRecStartDateTime(), "yyyy-MM-dd HH:mm", "yyyy-MM-dd aa h:mm:ss", ""); 
					Date day1 = date.parse(compare1);
					Date day2 = date.parse(compare2);
					int compare = day1.compareTo(day2);
					
					if (isOneDay && compare < 0) {
						recLoop++;
						continue;
					}
					
					//넣는다
					s1.setStartDateTime(addSeconds(dsStartDateTime, -date.parse(dsStartDateTime).getSeconds(), "yyyy-MM-dd aa h:mm:ss"));
					s1.setEndDateTime(addSeconds(dsEndDateTime, -date.parse(dsEndDateTime).getSeconds(), "yyyy-MM-dd aa h:mm:ss"));
					dt.add(recLoop, s1);
					
					recLoop++;
				}
			}
			//주말이나 평일일때
			if (!isOneDay) {
				while (recLoop < recParam.getRecReCount()) {
					//몇월 1일
					String recFirstDate = EgovDateUtil.convertDate(EgovDateUtil.addMonth(recFirstStartDate, recLoop * recParam.getRecReNum() * 1, "yyyy-MM-dd HH:mm"),"yyyy-MM-dd HH:mm","yyyy-MM-dd aa h:mm:ss","");
					
					boolean isWeekend = (recParam.getRecReYoil().indexOf("6,") != -1 || recParam.getRecReYoil().indexOf("0,") != -1);
					int recReOrdOffset = 0;
					//주말이지만 일요일로 시작하면 다음주부터
					if (isWeekend && datePartLeftShift(recFirstDate) == 7)  {
						recReOrdOffset = 1;
					}
					//평일에서 주말로 시작하면 다음주부터
					if (!isWeekend && datePartLeftShift(recFirstDate) > 5) {
						recReOrdOffset = 1;
					}
					//주말이나 평일일때 주에서 월,화,수,목,금,토,일로 반복
					while (recMondayOffsetAdd < 7) {
						if (recParam.getRecReYoil().replace("0,", "7,").indexOf(recMondayOffsetAdd+1) == -1) {
							recMondayOffsetAdd++;
							continue;
						}
						
						//몇째 요일의 일
						int recPartDay = (recParam.getRecReOrd()-1 + recReOrdOffset) * 7 + (recMondayOffsetAdd + 1) + (1 - datePartLeftShift(recFirstDate));
						
						if (recPartDay < 1) {
							recMondayOffsetAdd++;
							continue;
						}
						
						//구하고
						String dsStartDateTime = getSomeDay(recFirstDate, recPartDay);
						String dsEndDateTime = getYearMonthDay(dsStartDateTime) + date.parse(recParam.getRecEndDateTime()).getHours() + date.parse(recParam.getRecEndDateTime()).getMinutes();
						dsEndDateTime = EgovDateUtil.convertDate(dsEndDateTime, "yyyyMMddHHmm", "yyyy-MM-dd aa h:mm:ss", "");
						
						//비교한다음
						String compare1 = dsStartDateTime;
						String compare2 = EgovDateUtil.convertDate(recParam.getRecStartDateTime(), "yyyy-MM-dd HH:mm", "yyyy-MM-dd aa h:mm:ss", ""); 
						Date day1 = date.parse(compare1);
						Date day2 = date.parse(compare2);
						int compare = day1.compareTo(day2);
						
						if (compare < 0) {
							recMondayOffsetAdd++;
							
							//주말이지만 토요일이 시작일 이전이면 일요일도 포함하면 안됨
							if (isWeekend && (datePartLeftShift(dsStartDateTime)) == 6) {
								recMondayOffsetAdd++;
							}
							continue;
						}
						//넣는다
						s1.setStartDateTime(addSeconds(dsStartDateTime, -date.parse(dsStartDateTime).getSeconds(), "yyyy-MM-dd aa h:mm:ss"));
						s1.setEndDateTime(addSeconds(dsEndDateTime, -date.parse(dsEndDateTime).getSeconds(), "yyyy-MM-dd aa h:mm:ss"));
						dt.add(recLoop, s1);
						
						recMondayOffsetAdd++;
					}
					recMondayOffsetAdd = 0;
					recLoop++;
				}
			}
		}
		
		//종료일지정
		if (recParam.getRecEndFlag() == 2) {
			//하나의 요일일때
			if (isOneDay) {
				String dsStartDateTimeLoop = "";
				String compare1 = getYearMonthDay(dsStartDateTimeLoop);
				String compare2 = getYearMonthDay(recParam.getRecEndDateTime());
				Date day1 = date.parse(compare1);
				Date day2 = date.parse(compare2);
				int compare = day1.compareTo(day2);
				while (compare <= 0) {
					String recFirstDate = EgovDateUtil.convertDate(EgovDateUtil.addMonth(recFirstStartDate, recLoop * recParam.getRecReNum() * 1, ""),"yyyy-MM-dd HH:mm","yyyy-MM-dd aa h:mm:ss","");
					
					//몇째 요일의 일
					int recPartDay = (recParam.getRecReOrd()-1) * 7 + recReOneYoil + (1-datePartLeftShift(recFirstDate));
					recPartDay += (recReOneYoil < datePartLeftShift(recFirstDate) ? 7 : 0);
					
					//구하고
					String dsStartDateTime = getSomeDay(recFirstDate, recPartDay);
					String dsEndDateTime = getYearMonthDay(dsStartDateTime) + date.parse(recParam.getRecEndDateTime()).getHours() + date.parse(recParam.getRecEndDateTime()).getMinutes();
					dsEndDateTime = EgovDateUtil.convertDate(dsEndDateTime, "yyyyMMddHHmm", "yyyy-MM-dd aa h:mm:ss", "");
					//while 조건 비교
					dsStartDateTimeLoop = dsStartDateTime;
					//비교한 다음
					String compare3 = dsStartDateTime;
					String compare4 = recParam.getRecStartDateTime(); 
					Date day3 = date.parse(compare3);
					Date day4 = date.parse(compare4);
					int subCompare = day3.compareTo(day4);
					
					if (isOneDay && subCompare < 0) {
						recLoop++;
						continue;
					}
					//넣는다
					s1.setStartDateTime(addSeconds(dsStartDateTime, -date.parse(dsStartDateTime).getSeconds(), "yyyy-MM-dd aa h:mm:ss"));
					s1.setEndDateTime(addSeconds(dsEndDateTime, -date.parse(dsEndDateTime).getSeconds(), "yyyy-MM-dd aa h:mm:ss"));
					dt.add(recLoop, s1);
					
					recLoop++;
				}
			}
			//주말이나 평일일때
			if (!isOneDay) {
				String dsStartDateTimeLoop = "";
				
				String compare1 = getYearMonthDay(dsStartDateTimeLoop);
				String compare2 = getYearMonthDay(recParam.getRecEndDateTime()); 
				Date day1 = date.parse(compare1);
				Date day2 = date.parse(compare2);
				int compare = day1.compareTo(day2);
				while (compare <= 0) {
					String recFirstDate = EgovDateUtil.convertDate(EgovDateUtil.addMonth(recFirstStartDate, recLoop * recParam.getRecReNum() * 1, ""),"yyyy-MM-dd HH:mm","yyyy-MM-dd HH:mm","");
					
					boolean isWeekend = (recParam.getRecReYoil().indexOf("6,") != -1 || recParam.getRecReYoil().indexOf("0,") != -1);
					
					int recReOrdOffset = 0;
					//주말이지만 일요일로 시작하면 다음주부터
					if (isWeekend && datePartLeftShift(recFirstDate) == 7) {
						recReOrdOffset = 1;
					}
					if (!isWeekend && datePartLeftShift(recFirstDate) > 5) {
						recReOrdOffset = 1;
					}
					
					while (recMondayOffsetAdd < 7) {
						if (recParam.getRecReYoil().replace("0,", "7,").indexOf(recMondayOffsetAdd+1) == -1) {
							recMondayOffsetAdd++;
							continue;
						}
						
						//몇째 요일의 일
						int recPartDay = (recParam.getRecReOrd()-1 + recReOrdOffset) * 7 + (recMondayOffsetAdd + 1) + (1 - datePartLeftShift(recFirstDate));
						
						if (recPartDay < 1) {
							recMondayOffsetAdd++;
							continue;
						}
						
						//구하고
						String dsStartDateTime = getSomeDay(recFirstDate, recPartDay);
						String dsEndDateTime = getYearMonthDay(dsStartDateTime) + date.parse(recParam.getRecEndDateTime()).getHours() + date.parse(recParam.getRecEndDateTime()).getMinutes();
						dsEndDateTime = EgovDateUtil.convertDate(dsEndDateTime, "yyyyMMddHHmm", "yyyy-MM-dd aa h:mm:ss", "");
						//while조건비교
						dsStartDateTimeLoop = dsStartDateTime;
						
						//비교한다음
						String compare3 = EgovDateUtil.convertDate(dsStartDateTime, "yyyy-MM-dd HH:mm", "yyyy-MM-dd aa h:mm:ss", "");
						String compare4 = EgovDateUtil.convertDate(recParam.getRecStartDateTime(), "yyyy-MM-dd HH:mm", "yyyy-MM-dd aa h:mm:ss", "");
						Date day3 = date.parse(compare3);
						Date day4 = date.parse(compare4);
						String compare5 = getYearMonthDay(dsStartDateTime);
						String compare6 = getYearMonthDay(recParam.getRecEndDateTime());
						Date day5 = date.parse(compare5);
						Date day6 = date.parse(compare6);
						
						int secondCompare = day3.compareTo(day4);
						int thirdCompare = day5.compareTo(day6);
						
						if (secondCompare < 0 || thirdCompare > 0) {
							recMondayOffsetAdd++;
							//주말이지만 토요일이 시작일 이전이면 일요일도 포함하면 안됨
							if (isWeekend && (secondCompare < 0) && datePartLeftShift(dsStartDateTime) == 6) {
								recMondayOffsetAdd++;
							}
							continue;
						}
						
						//넣는다
						s1.setStartDateTime(addSeconds(dsStartDateTime, -date.parse(dsStartDateTime).getSeconds(), "yyyy-MM-dd aa h:mm:ss"));
						s1.setEndDateTime(addSeconds(dsEndDateTime, -date.parse(dsEndDateTime).getSeconds(), "yyyy-MM-dd aa h:mm:ss"));
						dt.add(recLoop, s1);
						
						recMondayOffsetAdd++;
					}
					recMondayOffsetAdd = 0;
					recLoop++;
				}
			}
		}
		

		logger.debug("chkDupReway61 ended");
		return dt;
	}
	
	@SuppressWarnings("deprecation")
	public List<ResMakeDupResultVO> chkDupReway70 (ResRecParamVO recParam, List<ResMakeDupResultVO> dt, ResObjArrayDestVO objParam) throws Exception {
		logger.debug("chkDupReway70 started");

		//반복예약 반복주기 매년 날짜
		
		int recLoop = 0;
		
		//int recMondayOffset = 1-datePartLeftShift(EgovDateUtil.convertDate(recParam.getRecStartDateTime(), "yyyy-MM-dd HH:mm", "yyyy-MM-dd aa h:mm:ss", ""));
		
		ResMakeDupResultVO s1 = new ResMakeDupResultVO();
		SimpleDateFormat date = new SimpleDateFormat("yyyy-MM-dd aa h:mm:ss");
		SimpleDateFormat date1 = new SimpleDateFormat("yyyy-MM-dd HH:mm");
		//반복회수지정
		if (recParam.getRecEndFlag() == 1) {
			while (recLoop < recParam.getRecReCount()) {
				//구하고
				String dsStartDateTime = getSomeDay(EgovDateUtil.convertDate(EgovDateUtil.addMonth(getFirstDay(EgovDateUtil.convertDate(recParam.getRecStartDateTime(), "yyyy-MM-dd HH:mm", "yyyy-MM-dd aa h:mm:ss", "")), recLoop * 12 * 1, "yyyy-MM-dd aa h:mm:ss"),"yyyy-MM-dd aa h:mm:ss","yyyy-MM-dd aa h:mm:ss",""), recParam.getRecReDay());
				String dsEndDateTime = getYearMonthDay(getSomeDay(EgovDateUtil.convertDate(EgovDateUtil.addMonth(getFirstDay(EgovDateUtil.convertDate(recParam.getRecStartDateTime(), "yyyy-MM-dd HH:mm", "yyyy-MM-dd aa h:mm:ss", "")), recLoop * 12 * 1, "yyyy-MM-dd aa h:mm:ss"), "yyyy-MM-dd aa h:mm:ss","yyyy-MM-dd aa h:mm:ss",""),recParam.getRecReDay())) + String.valueOf(date1.parse(recParam.getRecEndDateTime()).getHours()) + String.valueOf(date1.parse(recParam.getRecEndDateTime()).getMinutes()) + String.valueOf(date1.parse(recParam.getRecEndDateTime()).getSeconds());
				dsEndDateTime = EgovDateUtil.convertDate(dsEndDateTime, "yyyyMMddHHmm", "yyyy-MM-dd aa h:mm:ss", "");
				
				//비교한다음
				String compare1 = EgovDateUtil.convertDate(dsStartDateTime, "yyyy-MM-dd aa h:mm:ss", "yyyy-MM-dd aa h:mm:ss", "");
				String compare2 = EgovDateUtil.convertDate(recParam.getRecStartDateTime(), "yyyy-MM-dd HH:mm", "yyyy-MM-dd aa h:mm:ss", ""); 
				Date day1 = date.parse(compare1);
				Date day2 = date.parse(compare2);
				int compare = day1.compareTo(day2);
				
				if (compare < 0) {
					recLoop++;
					// reCount ++
					recParam.getRecReCount();
					continue;
				}
				//넣는다
				s1.setStartDateTime(addSeconds(dsStartDateTime, -date.parse(dsStartDateTime).getSeconds(), "yyyy-MM-dd aa h:mm:ss"));
				s1.setEndDateTime(addSeconds(dsEndDateTime, -date.parse(dsEndDateTime).getSeconds(), "yyyy-MM-dd aa h:mm:ss"));
				dt.add(recLoop, s1);
				
				recLoop++;
			}
		}
		//종료일지정
		if (recParam.getRecEndFlag() == 2) {
			String dsStartDateTimeLoop = "1900-01-01 오전 1:00:00";
			
			
			int compare = 0;
			while (compare <= 0) {
				//구하고
				String dsStartDateTime = getSomeDay(EgovDateUtil.convertDate(EgovDateUtil.addMonth(getFirstDay(EgovDateUtil.convertDate(recParam.getRecStartDateTime(), "yyyy-MM-dd HH:mm", "yyyy-MM-dd aa h:mm:ss", "")), recLoop * 12 * 1, "yyyy-MM-dd aa h:mm:ss"),"yyyy-MM-dd aa h:mm:ss","yyyy-MM-dd aa h:mm:ss",""), recParam.getRecReDay());
				String dsEndDateTime = getYearMonthDay(getSomeDay(EgovDateUtil.convertDate(EgovDateUtil.addMonth(getFirstDay(EgovDateUtil.convertDate(recParam.getRecStartDateTime(), "yyyy-MM-dd HH:mm", "yyyy-MM-dd aa h:mm:ss", "")), recLoop * 12 * 1, "yyyy-MM-dd aa h:mm:ss"), "yyyy-MM-dd aa h:mm:ss","yyyy-MM-dd aa h:mm:ss",""),recParam.getRecReDay())) + String.valueOf(date1.parse(recParam.getRecEndDateTime()).getHours()) + String.valueOf(date1.parse(recParam.getRecEndDateTime()).getMinutes()) + String.valueOf(date1.parse(recParam.getRecEndDateTime()).getSeconds());
				dsEndDateTime = EgovDateUtil.convertDate(dsEndDateTime, "yyyyMMddHHmm", "yyyy-MM-dd aa h:mm:ss", "");
				dsStartDateTimeLoop = dsStartDateTime;
				
				String compare1 = getYearMonthDay(dsStartDateTimeLoop);
				String compare2 = getYearMonthDay(EgovDateUtil.convertDate(recParam.getRecEndDateTime(), "yyyy-MM-dd HH:mm", "yyyy-MM-dd aa h:mm:ss", "")); 
				Date day1 = date.parse(EgovDateUtil.convertDate(compare1, "yyyyMMdd", "yyyy-MM-dd aa h:mm:ss", ""));
				Date day2 = date.parse(EgovDateUtil.convertDate(compare2, "yyyyMMdd", "yyyy-MM-dd aa h:mm:ss", ""));
				compare = day1.compareTo(day2);
				
				//비교한 다음
				String compare3 = EgovDateUtil.convertDate(dsStartDateTime, "yyyy-MM-dd aa h:mm:ss", "yyyy-MM-dd aa h:mm:ss", "");
				String compare4 = EgovDateUtil.convertDate(recParam.getRecStartDateTime(), "yyyy-MM-dd HH:mm", "yyyy-MM-dd aa h:mm:ss", "");
				
				Date day3 = date.parse(compare3);
				Date day4 = date.parse(compare4);
				int subCompare = day3.compareTo(day4);
				
				if (subCompare < 0) {
					recLoop++;
					
					continue;
				}
				
				//0802
				if (date.parse(dsStartDateTime).getYear()+1900 > date1.parse(recParam.getRecStartDateTime()).getYear()+1900) {
					dsStartDateTime = EgovDateUtil.addYear(dsStartDateTime, -1, "yyyy-MM-dd aa h:mm:ss");
				}
				
				if (date.parse(dsStartDateTime).getYear()+1900 == date1.parse(recParam.getRecStartDateTime()).getYear()+1900) {
					if (date.parse(dsStartDateTime).getMonth()+1 < date1.parse(recParam.getRecStartDateTime()).getMonth()+1) {
						dsStartDateTime = EgovDateUtil.addMonth(dsStartDateTime, 1, "yyyy-MM-dd aa h:mm:ss"); 
					}
				}
				if (date.parse(dsEndDateTime).getYear()+1900 > date1.parse(recParam.getRecEndDateTime()).getYear()+1900) {
					dsEndDateTime = EgovDateUtil.addYear(dsEndDateTime, -1, "yyyy-MM-dd aa h:mm:ss");
				}
				if (date.parse(dsEndDateTime).getYear()+1900 == date1.parse(recParam.getRecEndDateTime()).getYear()+1900) {
					if (date.parse(dsEndDateTime).getMonth()+1 < date1.parse(recParam.getRecEndDateTime()).getMonth()+1) {
						dsEndDateTime = EgovDateUtil.addMonth(dsEndDateTime, 1, "yyyy-MM-dd aa h:mm:ss"); 
					}
				}
				//넣는다
				s1.setStartDateTime(addSeconds(dsStartDateTime, -date.parse(dsStartDateTime).getSeconds(), "yyyy-MM-dd aa h:mm:ss"));
				s1.setEndDateTime(addSeconds(dsEndDateTime, -date.parse(dsEndDateTime).getSeconds(), "yyyy-MM-dd aa h:mm:ss"));
				dt.add(recLoop, s1);
				
				recLoop++;
			}
		}
		
		

		logger.debug("chkDupReway70 ended");
		return dt;
	}
	
	@SuppressWarnings("deprecation")
	public List<ResMakeDupResultVO> chkDupReway71 (ResRecParamVO recParam, List<ResMakeDupResultVO> dt, ResObjArrayDestVO objParam) throws Exception {
		logger.debug("chkDupReway71 started");

		//반복예약 반복주기 매년, 요일
		ResMakeDupResultVO s1 = new ResMakeDupResultVO();
		SimpleDateFormat date = new SimpleDateFormat("yyyy-MM-dd aa h:mm:ss");
		
		if (recParam.getRecReOrd() == -1) {
			dt =  chkDupReway71_2(recParam, dt, objParam);
			return dt;
		}
		
		int recLoop = 0;
		
		// 시작일의 달 1일
		String recFirstStartDate = getFirstDay(EgovDateUtil.convertDate(recParam.getRecStartDateTime(), "yyyy-MM-dd HH:mm", "yyyy-MM-dd aa h:mm:ss", ""));
		
		int recMondayOffsetAdd = 0;
		// 단 하나의 요일일때 : 주말이나 평일일때
		boolean isOneDay = (recParam.getRecReYoil().indexOf(",") == -1);
		// 단 하나의 요일이므로 미리 구하여 불필요한 반복 없앰
		int recReOneYoil = isOneDay ? Integer.parseInt(recParam.getRecReYoil()) : -1;
		if (recReOneYoil == 0) {
			//일요일
			recReOneYoil = 7;
		}
		//반복회수지정
		if (recParam.getRecEndFlag() == 1) {
			//하나의 요일일때
			if (isOneDay) {
				while (recLoop < recParam.getRecReCount()) {
					//몇월 1일
					String recFirstDate = EgovDateUtil.convertDate(EgovDateUtil.addMonth(recFirstStartDate, recLoop * 12 * 1, ""),"yyyy-MM-dd aa h:mm:ss","yyyy-MM-dd aa h:mm:ss","");
					
					//몇째 요일의 일
					int recPartDay = (recParam.getRecReOrd()-1) * 7 + recReOneYoil + (1-datePartLeftShift(recFirstDate));
					recPartDay += (recReOneYoil < datePartLeftShift(recFirstDate) ? 7:0);
					
					//구하고
					String dsStartDateTime = getSomeDay(recFirstDate, recPartDay);
					String dsEndDateTime = getYearMonthDay(dsStartDateTime) + date.parse(recParam.getRecEndDateTime()).getHours() + date.parse(recParam.getRecEndDateTime()).getMinutes() + date.parse(recParam.getRecEndDateTime()).getSeconds(); 
					//비교한다음
					String compare1 = dsStartDateTime;
					String compare2 = recParam.getRecStartDateTime(); 
					Date day1 = date.parse(compare1);
					Date day2 = date.parse(compare2);
					int compare = day1.compareTo(day2);
					if (isOneDay && compare < 0) {
						recLoop++;
						continue;
					}
					
					//넣는다
					s1.setStartDateTime(addSeconds(dsStartDateTime, -date.parse(dsStartDateTime).getSeconds(), "yyyy-MM-dd aa h:mm:ss"));
					s1.setEndDateTime(addSeconds(dsEndDateTime, -date.parse(dsEndDateTime).getSeconds(), "yyyy-MM-dd aa h:mm:ss"));
					dt.add(recLoop, s1);
					
					recLoop++;
				}
			}
			//주말이나 평일일때
			if (!isOneDay) {
				while (recLoop < recParam.getRecReCount()) {
					//몇월 1일
					String recFirstDate = EgovDateUtil.convertDate(EgovDateUtil.addMonth(recFirstStartDate, recLoop * 12 * 1, ""),"yyyy-MM-dd aa h:mm:ss","yyyy-MM-dd aa h:mm:ss","");
					
					boolean isWeekend = (recParam.getRecReYoil().indexOf("6,") != -1 || recParam.getRecReYoil().indexOf("0,") != -1);
					int recReOrdOffset = 0;
					//주말이지만 일요일로 시작하면 다음주부터
					if (isWeekend && datePartLeftShift(recFirstDate) == 7)  {
						recReOrdOffset = 1;
					}
					//평일에서 주말로 시작하면 다음주부터
					if (!isWeekend && datePartLeftShift(recFirstDate) > 5) {
						recReOrdOffset = 1;
					}
					//주말이나 평일일때 주에서 월,화,수,목,금,토,일로 반복
					while (recMondayOffsetAdd < 7) {
						if (recParam.getRecReYoil().replace("0,", "7,").indexOf(recMondayOffsetAdd+1) == -1) {
							recMondayOffsetAdd++;
							continue;
						}
						
						//몇째 요일의 일
						int recPartDay = (recParam.getRecReOrd()-1 + recReOrdOffset) * 7 + (recMondayOffsetAdd + 1) + (1 - datePartLeftShift(recFirstDate));
						
						if (recPartDay < 1) {
							recMondayOffsetAdd++;
							continue;
						}
						
						//구하고
						String dsStartDateTime = getSomeDay(recFirstDate, recPartDay);
						String dsEndDateTime = getYearMonthDay(dsStartDateTime) + date.parse(recParam.getRecEndDateTime()).getHours() + date.parse(recParam.getRecEndDateTime()).getMinutes() + date.parse(recParam.getRecEndDateTime()).getSeconds();
						//비교한다음
						String compare1 = dsStartDateTime;
						String compare2 = recParam.getRecStartDateTime(); 
						Date day1 = date.parse(compare1);
						Date day2 = date.parse(compare2);
						int compare = day1.compareTo(day2);
						
						if (compare < 0) {
							recMondayOffsetAdd++;
							//주말이지만 토요일이 시작일 이전이면 일요일도 포함하면 안됨
							if (isWeekend && (datePartLeftShift(dsStartDateTime)) == 6) {
								recMondayOffsetAdd++;
							}
							continue;
						}
						//넣는다
						s1.setStartDateTime(addSeconds(dsStartDateTime, -date.parse(dsStartDateTime).getSeconds(), "yyyy-MM-dd aa h:mm:ss"));
						s1.setEndDateTime(addSeconds(dsEndDateTime, -date.parse(dsEndDateTime).getSeconds(), "yyyy-MM-dd aa h:mm:ss"));
						dt.add(recLoop, s1);
						
						recMondayOffsetAdd++;
					}
					recMondayOffsetAdd = 0;
					recLoop++;
				}
			}
		}
		
		//종료일지정
		if (recParam.getRecEndFlag() == 2) {
			//하나의 요일일때
			if (isOneDay) {
				String dsStartDateTimeLoop = "";
				String compare1 = getYearMonthDay(dsStartDateTimeLoop);
				String compare2 = getYearMonthDay(recParam.getRecEndDateTime());
				Date day1 = date.parse(compare1);
				Date day2 = date.parse(compare2);
				int compare = day1.compareTo(day2);
				while (compare <= 0) {
					String recFirstDate = EgovDateUtil.convertDate(EgovDateUtil.addMonth(recFirstStartDate, recLoop * 12 * 1, ""),"yyyy-MM-dd aa h:mm:ss","yyyy-MM-dd aa h:mm:ss","");
					
					//몇째 요일의 일
					int recPartDay = (recParam.getRecReOrd()-1) * 7 + recReOneYoil + (1-datePartLeftShift(recFirstDate));
					recPartDay += (recReOneYoil < datePartLeftShift(recFirstDate) ? 7 : 0);
					
					//구하고
					String dsStartDateTime = getSomeDay(recFirstDate, recPartDay);
					String dsEndDateTime = getYearMonthDay(dsStartDateTime) + date.parse(recParam.getRecEndDateTime()).getHours() + date.parse(recParam.getRecEndDateTime()).getMinutes() + date.parse(recParam.getRecEndDateTime()).getSeconds();
					//while 조건 비교
					dsStartDateTimeLoop = dsStartDateTime;
					//비교한 다음
					String compare3 = dsStartDateTime;
					String compare4 = recParam.getRecStartDateTime(); 
					Date day3 = date.parse(compare3);
					Date day4 = date.parse(compare4);
					int subCompare = day3.compareTo(day4);
					
					if (isOneDay && subCompare < 0) {
						recLoop++;
						continue;
					}
					//0802
					if (date.parse(dsStartDateTime).getYear() > date.parse(recParam.getRecStartDateTime()).getYear()) {
						dsStartDateTime = EgovDateUtil.addYear(dsStartDateTime, -1, "yyyy-MM-dd aa h:mm:ss");
					}
					
					if (date.parse(dsStartDateTime).getYear() == date.parse(recParam.getRecStartDateTime()).getYear()) {
						if (date.parse(dsStartDateTime).getMonth()+1 < date.parse(recParam.getRecStartDateTime()).getMonth()+1) {
							dsStartDateTime = EgovDateUtil.addMonth(dsStartDateTime, 1, "yyyy-MM-dd aa h:mm:ss"); 
						}
					}
					if (date.parse(dsEndDateTime).getYear() > date.parse(recParam.getRecEndDateTime()).getYear()) {
						dsEndDateTime = EgovDateUtil.addYear(dsEndDateTime, -1, "yyyy-MM-dd aa h:mm:ss");
					}
					if (date.parse(dsEndDateTime).getYear() == date.parse(recParam.getRecEndDateTime()).getYear()) {
						if (date.parse(dsEndDateTime).getMonth()+1 < date.parse(recParam.getRecEndDateTime()).getMonth()+1) {
							dsEndDateTime = EgovDateUtil.addMonth(dsEndDateTime, 1, "yyyy-MM-dd aa h:mm:ss"); 
						}
					}
					//넣는다
					s1.setStartDateTime(addSeconds(dsStartDateTime, -date.parse(dsStartDateTime).getSeconds(), "yyyy-MM-dd aa h:mm:ss"));
					s1.setEndDateTime(addSeconds(dsEndDateTime, -date.parse(dsEndDateTime).getSeconds(), "yyyy-MM-dd aa h:mm:ss"));
					dt.add(recLoop, s1);
					
					recLoop++;
				}
			}
			//주말이나 평일일때
			if (!isOneDay) {
				String dsStartDateTimeLoop = "";
				
				String compare1 = getYearMonthDay(dsStartDateTimeLoop);
				String compare2 = getYearMonthDay(recParam.getRecEndDateTime()); 
				Date day1 = date.parse(compare1);
				Date day2 = date.parse(compare2);
				int compare = day1.compareTo(day2);
				while (compare <= 0) {
					String recFirstDate = EgovDateUtil.convertDate(EgovDateUtil.addMonth(recFirstStartDate, recLoop * 12 * 1, ""),"yyyy-MM-dd aa h:mm:ss","yyyy-MM-dd aa h:mm:ss","");
					
					boolean isWeekend = (recParam.getRecReYoil().indexOf("6,") != -1 || recParam.getRecReYoil().indexOf("0,") != -1);
					
					int recReOrdOffset = 0;
					//주말이지만 일요일로 시작하면 다음주부터
					if (isWeekend && datePartLeftShift(recFirstDate) == 7) {
						recReOrdOffset = 1;
					}
					if (!isWeekend && datePartLeftShift(recFirstDate) > 5) {
						recReOrdOffset = 1;
					}
					
					while (recMondayOffsetAdd < 7) {
						if (recParam.getRecReYoil().replace("0,", "7,").indexOf(recMondayOffsetAdd+1) == -1) {
							recMondayOffsetAdd++;
							continue;
						}
						
						//몇째 요일의 일
						int recPartDay = (recParam.getRecReOrd()-1 + recReOrdOffset) * 7 + (recMondayOffsetAdd + 1) + (1 - datePartLeftShift(recFirstDate));
						
						if (recPartDay < 1) {
							recMondayOffsetAdd++;
							continue;
						}
						
						//구하고
						String dsStartDateTime = getSomeDay(recFirstDate, recPartDay);
						String dsEndDateTime = getYearMonthDay(dsStartDateTime) + date.parse(recParam.getRecEndDateTime()).getHours() + date.parse(recParam.getRecEndDateTime()).getMinutes() + date.parse(recParam.getRecEndDateTime()).getSeconds();
						//while조건비교
						dsStartDateTimeLoop = dsStartDateTime;
						
						//비교한다음
						String compare3 = dsStartDateTime;
						String compare4 = recParam.getRecStartDateTime();
						Date day3 = date.parse(compare3);
						Date day4 = date.parse(compare4);
						String compare7 = dsStartDateTime;
						String compare8 = recParam.getRecStartDateTime();
						Date day7 = date.parse(compare7);
						Date day8 = date.parse(compare8);
						int secondCompare = day3.compareTo(day4);
						
						int fourCompare = day7.compareTo(day8);
						if (secondCompare < 0) {
							recMondayOffsetAdd++;
							//주말이지만 토요일이 시작일 이전이면 일요일도 포함하면 안됨
							if (isWeekend && (fourCompare < 0) && datePartLeftShift(dsStartDateTime) == 6) {
								recMondayOffsetAdd++;
							}
							continue;
						}
						
						//0802
						if (date.parse(dsStartDateTime).getYear() > date.parse(recParam.getRecStartDateTime()).getYear()) {
							dsStartDateTime = EgovDateUtil.addYear(dsStartDateTime, -1, "yyyy-MM-dd aa h:mm:ss");
						}
						
						if (date.parse(dsStartDateTime).getYear() == date.parse(recParam.getRecStartDateTime()).getYear()) {
							if (date.parse(dsStartDateTime).getMonth()+1 < date.parse(recParam.getRecStartDateTime()).getMonth()+1) {
								dsStartDateTime = EgovDateUtil.addMonth(dsStartDateTime, 1, "yyyy-MM-dd aa h:mm:ss"); 
							}
						}
						if (date.parse(dsEndDateTime).getYear() > date.parse(recParam.getRecEndDateTime()).getYear()) {
							dsEndDateTime = EgovDateUtil.addYear(dsEndDateTime, -1, "yyyy-MM-dd aa h:mm:ss");
						}
						if (date.parse(dsEndDateTime).getYear() == date.parse(recParam.getRecEndDateTime()).getYear()) {
							if (date.parse(dsEndDateTime).getMonth()+1 < date.parse(recParam.getRecEndDateTime()).getMonth()+1) {
								dsEndDateTime = EgovDateUtil.addMonth(dsEndDateTime, 1, "yyyy-MM-dd aa h:mm:ss"); 
							}
						}
						
						//넣는다
						s1.setStartDateTime(addSeconds(dsStartDateTime, -date.parse(dsStartDateTime).getSeconds(), "yyyy-MM-dd aa h:mm:ss"));
						s1.setEndDateTime(addSeconds(dsEndDateTime, -date.parse(dsEndDateTime).getSeconds(), "yyyy-MM-dd aa h:mm:ss"));
						dt.add(recLoop, s1);
						
						recMondayOffsetAdd++;
					}
					recMondayOffsetAdd = 0;
					recLoop++;
				}
			}
		}
		

		logger.debug("chkDupReway71 ended");
		return dt;
	}
	
	@SuppressWarnings("deprecation")
	public List<ResMakeDupResultVO> chkDupReway61_2 (ResRecParamVO recParam, List<ResMakeDupResultVO> dt) throws Exception {
		logger.debug("chkDupReway61_2 started");

		SimpleDateFormat date = new SimpleDateFormat("yyyy-MM-dd aa h:mm:ss");
		SimpleDateFormat date1 = new SimpleDateFormat("yyyy-MM-dd HH:mm");
		
		int recLoop = 0;
		
		// 시작일의 달 1일
		String recFirstStartDate = getFirstDay(EgovDateUtil.convertDate(recParam.getRecStartDateTime(), "yyyy-MM-dd HH:mm", "yyyy-MM-dd aa h:mm:ss", ""));
		
		int recMondayOffsetAdd = 0;
		// 단 하나의 요일일때 : 주말이나 평일일때
		boolean isOneDay = (recParam.getRecReYoil().indexOf(",") == -1);
		// 단 하나의 요일이므로 미리 구하여 불필요한 반복 없앰
		int recReOneYoil = isOneDay ? Integer.parseInt(recParam.getRecReYoil()) : -1;
		if (recReOneYoil == 0) {
			//일요일
			recReOneYoil = 7;
		}
		//반복회수지정
		if (recParam.getRecEndFlag() == 1) {
			//하나의 요일일때
			if (isOneDay) {
				while (recLoop < recParam.getRecReCount()) {
					//몇월 1일
					String recFirstDate = EgovDateUtil.convertDate(EgovDateUtil.addMonth(recFirstStartDate, recLoop * recParam.getRecReNum() * 1, "yyyy-MM-dd aa h:mm:ss"),"yyyy-MM-dd aa h:mm:ss","yyyy-MM-dd aa h:mm:ss","");
					String recFirstDateEndDay = EgovDateUtil.convertDate(EgovDateUtil.addMonth(recFirstStartDate, recLoop * recParam.getRecReNum() * 1, "yyyy-MM-dd aa h:mm:ss"),"yyyy-MM-dd aa h:mm:ss","yyyy-MM-dd aa h:mm:ss","");
					recFirstDateEndDay = EgovDateUtil.convertDate(EgovDateUtil.addMonth(recFirstDateEndDay, 1, "yyyy-MM-dd aa h:mm:ss"),"yyyy-MM-dd aa h:mm:ss","yyyy-MM-dd aa h:mm:ss","");
					recFirstDateEndDay = EgovDateUtil.convertDate(EgovDateUtil.addDay(recFirstDateEndDay, -1, "yyyy-MM-dd aa h:mm:ss"),"yyyy-MM-dd aa h:mm:ss","yyyy-MM-dd aa h:mm:ss","");
					
					//마지막 요일의 일
					int recPartDay = date.parse(recFirstDateEndDay).getDate();
					recPartDay -= datePartLeftShift(recFirstDateEndDay) - recReOneYoil;
					if (datePartLeftShift(recFirstDateEndDay) - (recReOneYoil) < 0) {
						recPartDay -= 7; // 달력의 날이 아니면 7일 뺌
					}
					
					//구하고
					String dsStartDateTime = getSomeDay(recFirstDate, recPartDay);
					String dsEndDateTime = getYearMonthDay(dsStartDateTime) + date1.parse(recParam.getRecEndDateTime()).getHours() + date1.parse(recParam.getRecEndDateTime()).getMinutes();
					dsEndDateTime = EgovDateUtil.convertDate(dsEndDateTime, "yyyyMMddHHmm", "yyyy-MM-dd aa h:mm:ss", "");
					//비교한다음
					String compare1 = dsStartDateTime;
					String compare2 = EgovDateUtil.convertDate(recParam.getRecStartDateTime(), "yyyy-MM-dd HH:mm", "yyyy-MM-dd aa h:mm:ss", ""); 
					Date day1 = date.parse(compare1);
					Date day2 = date.parse(compare2);
					int compare = day1.compareTo(day2);
					if (isOneDay && compare < 0) {
						recLoop++;
						continue;
					}
					
					//넣는다
					ResMakeDupResultVO s1 = new ResMakeDupResultVO();
					s1.setStartDateTime(addSeconds(dsStartDateTime, -date.parse(dsStartDateTime).getSeconds(), "yyyy-MM-dd aa h:mm:ss"));
					s1.setEndDateTime(addSeconds(dsEndDateTime, -date.parse(dsEndDateTime).getSeconds(), "yyyy-MM-dd aa h:mm:ss"));
					dt.add(recLoop, s1);
					
					recLoop++;
				}
			}
			//주말이나 평일일때
			if (!isOneDay) {
				while (recLoop < recParam.getRecReCount()) {
					//몇월 1일
					String recFirstDate = EgovDateUtil.convertDate(EgovDateUtil.addMonth(recFirstStartDate, recLoop * recParam.getRecReNum() * 1, "yyyy-MM-dd aa h:mm:ss"),"yyyy-MM-dd aa h:mm:ss","yyyy-MM-dd aa h:mm:ss","");
					String recFirstDateEndDay = EgovDateUtil.convertDate(EgovDateUtil.addMonth(recFirstStartDate, recLoop * recParam.getRecReNum() * 1, "yyyy-MM-dd aa h:mm:ss"),"yyyy-MM-dd aa h:mm:ss","yyyy-MM-dd aa h:mm:ss","");
					recFirstDateEndDay = EgovDateUtil.convertDate(EgovDateUtil.addMonth(recFirstDateEndDay, 1, "yyyy-MM-dd aa h:mm:ss"),"yyyy-MM-dd aa h:mm:ss","yyyy-MM-dd aa h:mm:ss","");
					recFirstDateEndDay = EgovDateUtil.convertDate(EgovDateUtil.addDay(recFirstDateEndDay, -1, "yyyy-MM-dd aa h:mm:ss"),"yyyy-MM-dd aa h:mm:ss","yyyy-MM-dd aa h:mm:ss","");
					
					int recMonday61_2 = date.parse(recFirstDateEndDay).getDate() + (1 - datePartLeftShift(recFirstDateEndDay));
					
					boolean isWeekend = (recParam.getRecReYoil().indexOf("6,") != -1 || recParam.getRecReYoil().indexOf("0,") != -1);
					
					//주말이지만 평일로 끝나면 이전주부터
					if (isWeekend && datePartLeftShift(recFirstDateEndDay) <= 5) {
						recMonday61_2 -= 7;
					}
					
					//주말이나 평일일때 주에서 월,화,수,목,금,토,일로 반복
					while (recMondayOffsetAdd < 7) {
						if (recParam.getRecReYoil().replace("0,", "7,").indexOf(recMondayOffsetAdd+1) == -1) {
							recMondayOffsetAdd++;
							continue;
						}
						
						//마지막 요일의 일
						int recPartDay = recMonday61_2 + recMondayOffsetAdd;
						
						if (recPartDay < date.parse(recFirstDateEndDay).getDate()) {
							recMondayOffsetAdd++;
							continue;
						}
						
						//구하고
						String dsStartDateTime = getSomeDay(recFirstDate, recPartDay);
						String dsEndDateTime = getYearMonthDay(dsStartDateTime) + date1.parse(recParam.getRecEndDateTime()).getHours() + date1.parse(recParam.getRecEndDateTime()).getMinutes();
						dsEndDateTime = EgovDateUtil.convertDate(dsEndDateTime, "yyyyMMddHHmm", "yyyy-MM-dd aa h:mm:ss", "");
						//비교한다음
						String compare1 = dsStartDateTime;
						String compare2 = EgovDateUtil.convertDate(recParam.getRecStartDateTime(), "yyyy-MM-dd HH:mm", "yyyy-MM-dd aa h:mm:ss", "");
						Date day1 = date.parse(compare1);
						Date day2 = date.parse(compare2);
						int compare = day1.compareTo(day2);
						
						if (compare < 0) {
							recMondayOffsetAdd++;
							//주말이지만 토요일이 시작일 이전이면 일요일도 포함하면 안됨
							if (isWeekend && (datePartLeftShift(dsStartDateTime)) == 6) {
								recMondayOffsetAdd++;
							}
							continue;
						}
						//넣는다
						ResMakeDupResultVO s1 = new ResMakeDupResultVO();
						s1.setStartDateTime(addSeconds(dsStartDateTime, -date.parse(dsStartDateTime).getSeconds(), "yyyy-MM-dd aa h:mm:ss"));
						s1.setEndDateTime(addSeconds(dsEndDateTime, -date.parse(dsEndDateTime).getSeconds(), "yyyy-MM-dd aa h:mm:ss"));
						dt.add(recLoop, s1);
						
						recMondayOffsetAdd++;
					}
					recMondayOffsetAdd = 0;
					recLoop++;
				}
			}
		}
		
		//종료일지정
		if (recParam.getRecEndFlag() == 2) {
			//하나의 요일일때
			if (isOneDay) {
				String dsStartDateTimeLoop = "";
				String compare1 = getYearMonthDay(dsStartDateTimeLoop);
				String compare2 = getYearMonthDay(EgovDateUtil.convertDate(recParam.getRecEndDateTime(), "yyyy-MM-dd aa HH:mm", "yyyy-MM-dd aa h:mm:ss", ""));
				Date day1 = date.parse(compare1);
				Date day2 = date.parse(compare2);
				int compare = day1.compareTo(day2);
				while (compare <= 0) {
					String recFirstDate = EgovDateUtil.convertDate(EgovDateUtil.addMonth(recFirstStartDate, recLoop * recParam.getRecReNum() * 1, "yyyy-MM-dd aa h:mm:ss"),"yyyy-MM-dd aa h:mm:ss","yyyy-MM-dd aa h:mm:ss","");
					String recFirstDateEndDay = EgovDateUtil.convertDate(EgovDateUtil.addMonth(recFirstStartDate, recLoop * recParam.getRecReNum() * 1, "yyyy-MM-dd aa h:mm:ss"),"yyyy-MM-dd aa h:mm:ss","yyyy-MM-dd aa h:mm:ss","");
					recFirstDateEndDay = EgovDateUtil.convertDate(EgovDateUtil.addMonth(recFirstDateEndDay, 1, "yyyy-MM-dd aa h:mm:ss"),"yyyy-MM-dd aa h:mm:ss","yyyy-MM-dd aa h:mm:ss","");
					recFirstDateEndDay = EgovDateUtil.convertDate(EgovDateUtil.addDay(recFirstDateEndDay, -1, "yyyy-MM-dd aa h:mm:ss"),"yyyy-MM-dd aa h:mm:ss","yyyy-MM-dd aa h:mm:ss","");
					
					//마지막 요일의 일
					int recPartDay = date.parse(recFirstDateEndDay).getDate();
					recPartDay -= datePartLeftShift(recFirstDateEndDay) - recReOneYoil;
					if (datePartLeftShift(recFirstDateEndDay) - (recReOneYoil) < 0) {
						//달력의 날이 아니면 7일 뺌
						recPartDay -= 7;
					}
					
					//구하고
					String dsStartDateTime = getSomeDay(recFirstDate, recPartDay);
					String dsEndDateTime = getYearMonthDay(dsStartDateTime) + date1.parse(recParam.getRecEndDateTime()).getHours() + date1.parse(recParam.getRecEndDateTime()).getMinutes();
					dsEndDateTime = EgovDateUtil.convertDate(dsEndDateTime, "yyyyMMddHHmm", "yyyy-MM-dd aa h:mm:ss", "");
					//while 조건 비교
					dsStartDateTimeLoop = dsStartDateTime;
					//비교한 다음
					String compare3 = dsStartDateTime;
					String compare4 = EgovDateUtil.convertDate(recParam.getRecStartDateTime(), "yyyy-MM-dd HH:mm", "yyyy-MM-dd aa h:mm:ss", ""); 
					Date day3 = date.parse(compare3);
					Date day4 = date.parse(compare4);
					int subCompare = day3.compareTo(day4);
					
					if (isOneDay && subCompare < 0) {
						recLoop++;
						continue;
					}
					//넣는다
					ResMakeDupResultVO s1 = new ResMakeDupResultVO();
					s1.setStartDateTime(addSeconds(dsStartDateTime, -date.parse(dsStartDateTime).getSeconds(), "yyyy-MM-dd aa h:mm:ss"));
					s1.setEndDateTime(addSeconds(dsEndDateTime, -date.parse(dsEndDateTime).getSeconds(), "yyyy-MM-dd aa h:mm:ss"));
					dt.add(recLoop, s1);
					
					recLoop++;
				}
			}
			//주말이나 평일일때
			if (!isOneDay) {
				String dsStartDateTimeLoop = "";
				
				String compare1 = getYearMonthDay(dsStartDateTimeLoop);
				String compare2 = getYearMonthDay(EgovDateUtil.convertDate(recParam.getRecEndDateTime(), "yyyy-MM-dd aa HH:mm", "yyyy-MM-dd aa h:mm:ss", ""));
				Date day1 = date.parse(compare1);
				Date day2 = date.parse(compare2);
				int compare = day1.compareTo(day2);
				while (compare <= 0) {
					String recFirstDate = EgovDateUtil.convertDate(EgovDateUtil.addMonth(recFirstStartDate, recLoop * recParam.getRecReNum() * 1, "yyyy-MM-dd aa h:mm:ss"),"yyyy-MM-dd aa h:mm:ss","yyyy-MM-dd aa h:mm:ss","");
					String recFirstDateEndDay = EgovDateUtil.convertDate(EgovDateUtil.addMonth(recFirstStartDate, recLoop * recParam.getRecReNum() * 1, "yyyy-MM-dd aa h:mm:ss"),"yyyy-MM-dd aa h:mm:ss","yyyy-MM-dd aa h:mm:ss","");
					recFirstDateEndDay = EgovDateUtil.convertDate(EgovDateUtil.addMonth(recFirstDateEndDay, 1, "yyyy-MM-dd aa h:mm:ss"),"yyyy-MM-dd aa h:mm:ss","yyyy-MM-dd aa h:mm:ss","");
					recFirstDateEndDay = EgovDateUtil.convertDate(EgovDateUtil.addDay(recFirstDateEndDay, -1, "yyyy-MM-dd aa h:mm:ss"),"yyyy-MM-dd aa h:mm:ss","yyyy-MM-dd aa h:mm:ss","");
					
					int recMonday61_2 = date.parse(recFirstDateEndDay).getDate() + (1 - datePartLeftShift(recFirstDateEndDay));
					boolean isWeekend = (recParam.getRecReYoil().indexOf("6,") != -1 || recParam.getRecReYoil().indexOf("0,") != -1);
					
					//주말이지만 평일로 끝나면 이전주부터
					if (isWeekend && datePartLeftShift(recFirstDateEndDay) <= 5) { // 주말이지만 평일로 끝나면 이전주부터
						recMonday61_2 -= 7;
					}
					
					while (recMondayOffsetAdd < 7) {
						if (recParam.getRecReYoil().replace("0,", "7,").indexOf(recMondayOffsetAdd+1) == -1) {
							recMondayOffsetAdd++;
							continue;
						}
						
						//마지막 요일의 일
						int recPartDay = recMonday61_2 + recMondayOffsetAdd;
						
						if (recPartDay > date.parse(recFirstDateEndDay).getDate()) {
							recMondayOffsetAdd++;
							continue;
						}
						
						//구하고
						String dsStartDateTime = getSomeDay(recFirstDate, recPartDay);
						String dsEndDateTime = getYearMonthDay(dsStartDateTime) + date1.parse(recParam.getRecEndDateTime()).getHours() + date1.parse(recParam.getRecEndDateTime()).getMinutes();
						dsEndDateTime = EgovDateUtil.convertDate(dsEndDateTime, "yyyyMMddHHmm", "yyyy-MM-dd aa h:mm:ss", "");
						//while조건비교
						dsStartDateTimeLoop = dsStartDateTime;
						
						//비교한다음
						String compare3 = dsStartDateTime;
						String compare4 = EgovDateUtil.convertDate(recParam.getRecStartDateTime(), "yyyy-MM-dd HH:mm", "yyyy-MM-dd aa h:mm:ss", "");
						Date day3 = date.parse(compare3);
						Date day4 = date.parse(compare4);
						String compare5 = getYearMonthDay(dsStartDateTime);
						String compare6 = getYearMonthDay(recParam.getRecEndDateTime());
						Date day5 = date.parse(compare5);
						Date day6 = date.parse(compare6);
						
						int secondCompare = day3.compareTo(day4);
						int thirdCompare = day5.compareTo(day6);
						
						if (secondCompare < 0 || thirdCompare > 0) {
							recMondayOffsetAdd++;
							//주말이지만 토요일이 시작일 이전이면 일요일도 포함하면 안됨
							if (isWeekend && (secondCompare < 0) && datePartLeftShift(dsStartDateTime) == 6) {
								recMondayOffsetAdd++;
							}
							continue;
						}
						
						//넣는다
						ResMakeDupResultVO s1 = new ResMakeDupResultVO();
						s1.setStartDateTime(addSeconds(dsStartDateTime, -date.parse(dsStartDateTime).getSeconds(), "yyyy-MM-dd aa h:mm:ss"));
						s1.setEndDateTime(addSeconds(dsEndDateTime, -date.parse(dsEndDateTime).getSeconds(), "yyyy-MM-dd aa h:mm:ss"));
						dt.add(recLoop, s1);
						
						recMondayOffsetAdd++;
					}
					recMondayOffsetAdd = 0;
					recLoop++;
				}
			}
		}
		
		logger.debug("chkDupReway61_2 ended");
		return dt;
	}
	
	@SuppressWarnings("deprecation")
	public List<ResMakeDupResultVO> chkDupReway71_2 (ResRecParamVO recParam, List<ResMakeDupResultVO> dt, ResObjArrayDestVO objParam) throws Exception {
		logger.debug("chkDupReway71_2 started");

		SimpleDateFormat date = new SimpleDateFormat("yyyy-MM-dd aa h:mm:ss");
		SimpleDateFormat date1 = new SimpleDateFormat("yyyy-MM-dd HH:mm");
		
		int recLoop = 0;
		
		// 시작일의 달 1일
		String recFirstStartDate = getFirstDay(EgovDateUtil.convertDate(recParam.getRecStartDateTime(), "yyyy-MM-dd HH:mm", "yyyy-MM-dd aa h:mm:ss", ""));
		recFirstStartDate = EgovDateUtil.convertDate(recFirstStartDate, "yyyy-MM-dd aa h:mm:ss", "yyyy-MM-dd HH:mm", "");
		
		int recMondayOffsetAdd = 0;
		// 단 하나의 요일일때 : 주말이나 평일일때
		boolean isOneDay = (recParam.getRecReYoil().indexOf(",") == -1);
		// 단 하나의 요일이므로 미리 구하여 불필요한 반복 없앰
		int recReOneYoil = isOneDay ? Integer.parseInt(recParam.getRecReYoil()) : -1;
		if (recReOneYoil == 0) {
			//일요일
			recReOneYoil = 7;
		}
		//반복회수지정
		if (recParam.getRecEndFlag() == 1) {
			//하나의 요일일때
			if (isOneDay) {
				while (recLoop < recParam.getRecReCount()) {
					//몇월 1일
					String recFirstDate = EgovDateUtil.convertDate(EgovDateUtil.addMonth(recFirstStartDate, recLoop * recParam.getRecReNum() * 1, "yyyy-MM-dd HH:mm"),"yyyy-MM-dd HH:mm","yyyy-MM-dd aa h:mm:ss","");
					String recFirstDateEndDay = EgovDateUtil.convertDate(EgovDateUtil.addMonth(recFirstStartDate, recLoop * recParam.getRecReNum() * 1, "yyyy-MM-dd HH:mm"),"yyyy-MM-dd HH:mm","yyyy-MM-dd aa h:mm:ss","");
					recFirstDateEndDay = EgovDateUtil.convertDate(EgovDateUtil.addMonth(recFirstDateEndDay, 1, "yyyy-MM-dd aa h:mm:ss"),"yyyy-MM-dd aa h:mm:ss","yyyy-MM-dd aa h:mm:ss","");
					recFirstDateEndDay = EgovDateUtil.convertDate(EgovDateUtil.addDay(recFirstDateEndDay, -1, "yyyy-MM-dd aa h:mm:ss"),"yyyy-MM-dd aa h:mm:ss","yyyy-MM-dd aa h:mm:ss","");
					
					//마지막 요일의 일
					int recPartDay = date.parse(recFirstDateEndDay).getDate();
					recPartDay -= datePartLeftShift(recFirstDateEndDay) - recReOneYoil;
					if (datePartLeftShift(recFirstDateEndDay) - (recReOneYoil) < 0) {
						recPartDay -= 7; // 달력의 날이 아니면 7일 뺌
					}
					
					//구하고
					String dsStartDateTime = getSomeDay(recFirstDate, recPartDay);
					String dsEndDateTime = getYearMonthDay(dsStartDateTime) + date1.parse(recParam.getRecEndDateTime()).getHours() + date1.parse(recParam.getRecEndDateTime()).getMinutes();
					dsEndDateTime = EgovDateUtil.convertDate(dsEndDateTime, "yyyyMMddHHmm", "yyyy-MM-dd aa h:mm:ss", "");
					//비교한다음
					String compare1 = dsStartDateTime;
					String compare2 = EgovDateUtil.convertDate(recParam.getRecStartDateTime(), "yyyy-MM-dd HH:mm", "yyyy-MM-dd aa h:mm:ss", ""); 
					Date day1 = date.parse(compare1);
					Date day2 = date.parse(compare2);
					int compare = day1.compareTo(day2);
					if (isOneDay && compare < 0) {
						recLoop++;
						continue;
					}
					
					//넣는다
					ResMakeDupResultVO s1 = new ResMakeDupResultVO();
					s1.setStartDateTime(addSeconds(dsStartDateTime, -date.parse(dsStartDateTime).getSeconds(), "yyyy-MM-dd aa h:mm:ss"));
					s1.setEndDateTime(addSeconds(dsEndDateTime, -date.parse(dsEndDateTime).getSeconds(), "yyyy-MM-dd aa h:mm:ss"));
					dt.add(recLoop, s1);
					
					recLoop++;
				}
			}
			//주말이나 평일일때
			if (!isOneDay) {
				while (recLoop < recParam.getRecReCount()) {
					//몇월 1일
					String recFirstDate = EgovDateUtil.convertDate(EgovDateUtil.addMonth(recFirstStartDate, recLoop * recParam.getRecReNum() * 1, "yyyy-MM-dd HH:mm"),"yyyy-MM-dd aa h:mm:ss","yyyy-MM-dd aa h:mm:ss","");
					String recFirstDateEndDay = EgovDateUtil.convertDate(EgovDateUtil.addMonth(recFirstStartDate, recLoop * recParam.getRecReNum() * 1, "yyyy-MM-dd aa h:mm:ss"),"yyyy-MM-dd aa h:mm:ss","yyyy-MM-dd aa h:mm:ss","");
					recFirstDateEndDay = EgovDateUtil.convertDate(EgovDateUtil.addMonth(recFirstDateEndDay, 1, "yyyy-MM-dd aa h:mm:ss"),"yyyy-MM-dd aa h:mm:ss","yyyy-MM-dd aa h:mm:ss","");
					recFirstDateEndDay = EgovDateUtil.convertDate(EgovDateUtil.addDay(recFirstDateEndDay, -1, "yyyy-MM-dd aa h:mm:ss"),"yyyy-MM-dd aa h:mm:ss","yyyy-MM-dd aa h:mm:ss","");
					
					int recMonday61_2 = date.parse(recFirstDateEndDay).getDate() + (1 - datePartLeftShift(recFirstDateEndDay));
					
					boolean isWeekend = (recParam.getRecReYoil().indexOf("6,") != -1 || recParam.getRecReYoil().indexOf("0,") != -1);
					
					//주말이지만 평일로 끝나면 이전주부터
					if (isWeekend && datePartLeftShift(recFirstDateEndDay) <= 5) {
						recMonday61_2 -= 7;
					}
					
					//주말이나 평일일때 주에서 월,화,수,목,금,토,일로 반복
					while (recMondayOffsetAdd < 7) {
						if (recParam.getRecReYoil().replace("0,", "7,").indexOf(recMondayOffsetAdd+1) == -1) {
							recMondayOffsetAdd++;
							continue;
						}
						
						//마지막 요일의 일
						int recPartDay = recMonday61_2 + recMondayOffsetAdd;
						
						if (recPartDay < date.parse(recFirstDateEndDay).getDate()) {
							recMondayOffsetAdd++;
							continue;
						}
						
						//구하고
						String dsStartDateTime = getSomeDay(recFirstDate, recPartDay);
						String dsEndDateTime = getYearMonthDay(dsStartDateTime) + date1.parse(recParam.getRecEndDateTime()).getHours() + date1.parse(recParam.getRecEndDateTime()).getMinutes();
						dsEndDateTime = EgovDateUtil.convertDate(dsEndDateTime, "yyyyMMddHHmm", "yyyy-MM-dd aa h:mm:ss", "");
						//비교한다음
						String compare1 = dsStartDateTime;
						String compare2 = EgovDateUtil.convertDate(recParam.getRecStartDateTime(), "yyyy-MM-dd HH:mm", "yyyy-MM-dd aa h:mm:ss", ""); 
						Date day1 = date.parse(compare1);
						Date day2 = date.parse(compare2);
						int compare = day1.compareTo(day2);
						
						if (compare < 0) {
							recMondayOffsetAdd++;
							//주말이지만 토요일이 시작일 이전이면 일요일도 포함하면 안됨
							if (isWeekend && (datePartLeftShift(dsStartDateTime)) == 6) {
								recMondayOffsetAdd++;
							}
							continue;
						}
						//넣는다
						ResMakeDupResultVO s1 = new ResMakeDupResultVO();
						s1.setStartDateTime(addSeconds(dsStartDateTime, -date.parse(dsStartDateTime).getSeconds(), "yyyy-MM-dd aa h:mm:ss"));
						s1.setEndDateTime(addSeconds(dsEndDateTime, -date.parse(dsEndDateTime).getSeconds(), "yyyy-MM-dd aa h:mm:ss"));
						dt.add(recLoop, s1);
						
						recMondayOffsetAdd++;
					}
					recMondayOffsetAdd = 0;
					recLoop++;
				}
			}
		}
		
		//종료일지정
		if (recParam.getRecEndFlag() == 2) {
			//하나의 요일일때
			if (isOneDay) {
				String dsStartDateTimeLoop = "";
				String compare1 = getYearMonthDay(dsStartDateTimeLoop);
				String compare2 = getYearMonthDay(EgovDateUtil.convertDate(recParam.getRecEndDateTime(), "yyyy-MM-dd HH:mm", "yyyy-MM-dd aa h:mm:ss", ""));
				Date day1 = date.parse(compare1);
				Date day2 = date.parse(compare2);
				int compare = day1.compareTo(day2);
				while (compare <= 0) {
					String recFirstDate = EgovDateUtil.convertDate(EgovDateUtil.addMonth(recFirstStartDate, recLoop * recParam.getRecReNum() * 1, "yyyy-MM-dd HH:mm"),"yyyy-MM-dd aa h:mm:ss","yyyy-MM-dd aa h:mm:ss","");
					String recFirstDateEndDay = EgovDateUtil.convertDate(EgovDateUtil.addMonth(recFirstStartDate, recLoop * recParam.getRecReNum() * 1, "yyyy-MM-dd HH:mm"),"yyyy-MM-dd HH:mm","yyyy-MM-dd aa h:mm:ss","");
					recFirstDateEndDay = EgovDateUtil.convertDate(EgovDateUtil.addMonth(recFirstDateEndDay, 1, "yyyy-MM-dd aa h:mm:ss"),"yyyy-MM-dd aa h:mm:ss","yyyy-MM-dd aa h:mm:ss","");
					recFirstDateEndDay = EgovDateUtil.convertDate(EgovDateUtil.addDay(recFirstDateEndDay, -1, "yyyy-MM-dd aa h:mm:ss"),"yyyy-MM-dd aa h:mm:ss","yyyy-MM-dd aa h:mm:ss","");
					
					//마지막 요일의 일
					int recPartDay = date.parse(recFirstDateEndDay).getDate();
					recPartDay -= datePartLeftShift(recFirstDateEndDay) - recReOneYoil;
					if (datePartLeftShift(recFirstDateEndDay) - (recReOneYoil) < 0) {
						//달력의 날이 아니면 7일 뺌
						recPartDay -= 7;
					}
					
					//구하고
					String dsStartDateTime = getSomeDay(recFirstDate, recPartDay);
					String dsEndDateTime = getYearMonthDay(dsStartDateTime) + date1.parse(recParam.getRecEndDateTime()).getHours() + date1.parse(recParam.getRecEndDateTime()).getMinutes();
					dsEndDateTime = EgovDateUtil.convertDate(dsEndDateTime, "yyyyMMddHHmm", "yyyy-MM-dd aa h:mm:ss", "");
					//while 조건 비교
					dsStartDateTimeLoop = dsStartDateTime;
					//비교한 다음
					String compare3 = dsStartDateTime;
					String compare4 = EgovDateUtil.convertDate(recParam.getRecStartDateTime(), "yyyy-MM-dd HH:mm", "yyyy-MM-dd aa h:mm:ss", ""); 
					Date day3 = date.parse(compare3);
					Date day4 = date.parse(compare4);
					int subCompare = day3.compareTo(day4);
					
					if (isOneDay && subCompare < 0) {
						recLoop++;
						continue;
					}
					//넣는다
					ResMakeDupResultVO s1 = new ResMakeDupResultVO();
					s1.setStartDateTime(addSeconds(dsStartDateTime, -date.parse(dsStartDateTime).getSeconds(), "yyyy-MM-dd aa h:mm:ss"));
					s1.setEndDateTime(addSeconds(dsEndDateTime, -date.parse(dsEndDateTime).getSeconds(), "yyyy-MM-dd aa h:mm:ss"));
					dt.add(recLoop, s1);
					
					recLoop++;
				}
			}
			//주말이나 평일일때
			if (!isOneDay) {
				String dsStartDateTimeLoop = "";
				
				String compare1 = getYearMonthDay(dsStartDateTimeLoop);
				String compare2 = getYearMonthDay(EgovDateUtil.convertDate(recParam.getRecEndDateTime(), "yyyy-MM-dd HH:mm", "yyyy-MM-dd aa h:mm:ss", "")); 
				Date day1 = date.parse(compare1);
				Date day2 = date.parse(compare2);
				int compare = day1.compareTo(day2);
				while (compare <= 0) {
					String recFirstDate = EgovDateUtil.convertDate(EgovDateUtil.addMonth(recFirstStartDate, recLoop * recParam.getRecReNum() * 1, "yyyy-MM-dd HH:mm"),"yyyy-MM-dd aa h:mm:ss","yyyy-MM-dd aa h:mm:ss","");
					String recFirstDateEndDay = EgovDateUtil.convertDate(EgovDateUtil.addMonth(recFirstStartDate, recLoop * recParam.getRecReNum() * 1, "yyyy-MM-dd HH:mm"),"yyyy-MM-dd HH:mm","yyyy-MM-dd aa h:mm:ss","");
					recFirstDateEndDay = EgovDateUtil.convertDate(EgovDateUtil.addMonth(recFirstDateEndDay, 1, "yyyy-MM-dd aa h:mm:ss"),"yyyy-MM-dd aa h:mm:ss","yyyy-MM-dd aa h:mm:ss","");
					recFirstDateEndDay = EgovDateUtil.convertDate(EgovDateUtil.addDay(recFirstDateEndDay, -1, "yyyy-MM-dd aa h:mm:ss"),"yyyy-MM-dd aa h:mm:ss","yyyy-MM-dd aa h:mm:ss","");
					
					int recMonday61_2 = date.parse(recFirstDateEndDay).getDate() + (1 - datePartLeftShift(recFirstDateEndDay));
					boolean isWeekend = (recParam.getRecReYoil().indexOf("6,") != -1 || recParam.getRecReYoil().indexOf("0,") != -1);
					
					//주말이지만 평일로 끝나면 이전주부터
					if (isWeekend && datePartLeftShift(recFirstDateEndDay) <= 5) { // 주말이지만 평일로 끝나면 이전주부터
						recMonday61_2 -= 7;
					}
					
					while (recMondayOffsetAdd < 7) {
						if (recParam.getRecReYoil().replace("0,", "7,").indexOf(recMondayOffsetAdd+1) == -1) {
							recMondayOffsetAdd++;
							continue;
						}
						
						//마지막 요일의 일
						int recPartDay = recMonday61_2 + recMondayOffsetAdd;
						
						if (recPartDay > date.parse(recFirstDateEndDay).getDate()) {
							recMondayOffsetAdd++;
							continue;
						}
						
						//구하고
						String dsStartDateTime = getSomeDay(recFirstDate, recPartDay);
						String dsEndDateTime = getYearMonthDay(dsStartDateTime) + date1.parse(recParam.getRecEndDateTime()).getHours() + date1.parse(recParam.getRecEndDateTime()).getMinutes();
						dsEndDateTime = EgovDateUtil.convertDate(dsEndDateTime, "yyyyMMddHHmm", "yyyy-MM-dd aa h:mm:ss", "");
						//while조건비교
						dsStartDateTimeLoop = dsStartDateTime;
						
						//비교한다음
						String compare3 = dsStartDateTime;
						String compare4 = EgovDateUtil.convertDate(recParam.getRecStartDateTime(), "yyyy-MM-dd HH:mm", "yyyy-MM-dd aa h:mm:ss", ""); 
						Date day3 = date.parse(compare3);
						Date day4 = date.parse(compare4);
						String compare5 = getYearMonthDay(dsStartDateTime);
						String compare6 = getYearMonthDay(recParam.getRecEndDateTime());
						Date day5 = date.parse(compare5);
						Date day6 = date.parse(compare6);
						
						int secondCompare = day3.compareTo(day4);
						int thirdCompare = day5.compareTo(day6);
						
						if (secondCompare < 0 || thirdCompare > 0) {
							recMondayOffsetAdd++;
							//주말이지만 토요일이 시작일 이전이면 일요일도 포함하면 안됨
							if (isWeekend && (secondCompare < 0) && datePartLeftShift(dsStartDateTime) == 6) {
								recMondayOffsetAdd++;
							}
							continue;
						}
						
						//넣는다
						ResMakeDupResultVO s1 = new ResMakeDupResultVO();
						s1.setStartDateTime(addSeconds(dsStartDateTime, -date.parse(dsStartDateTime).getSeconds(), "yyyy-MM-dd aa h:mm:ss"));
						s1.setEndDateTime(addSeconds(dsEndDateTime, -date.parse(dsEndDateTime).getSeconds(), "yyyy-MM-dd aa h:mm:ss"));
						dt.add(recLoop, s1);
						
						recMondayOffsetAdd++;
					}
					recMondayOffsetAdd = 0;
					recLoop++;
				}
			}
		}

		logger.debug("chkDupReway71_2 ended");
		return dt;
	}
	
	@SuppressWarnings("deprecation")
	public String getYearMonthDay(String strSource) throws Exception {
		logger.debug("getYearMonthDay started");
		logger.debug("strSource="+strSource);
		
		SimpleDateFormat date = new SimpleDateFormat("yyyy-MM-dd aa h:mm:ss");
		
		int tempMonth = date.parse(strSource).getMonth()+1;
		String month = "";
		
		if (tempMonth < 10) {
			month = "0"+String.valueOf(date.parse(strSource).getMonth()+1);
		} else {
			month = String.valueOf(date.parse(strSource).getMonth()+1);
		}
		
		int tempDay = date.parse(strSource).getDate();
		String day = "";
		
		if (tempDay < 10) {
			day = "0"+String.valueOf(date.parse(strSource).getDate());
		} else {
			day = String.valueOf(date.parse(strSource).getDate());
		}
		String result = String.valueOf(date.parse(strSource).getYear()+1900) + month + day;
		logger.debug("result="+result);
		logger.debug("getYearMonthDay ended");
		return result;
	}
	
	@SuppressWarnings("deprecation")
	public String getSomeDay(String strSource, int day) throws Exception {
		SimpleDateFormat date = new SimpleDateFormat("yyyy-MM-dd aa h:mm:ss");
		return EgovDateUtil.addDay(strSource, -(date.parse(strSource).getDate() - day), "yyyy-MM-dd aa h:mm:ss");
	}
	public String getFirstDay(String strSource) throws Exception {
		
		return getSomeDay(strSource, 1);
	}
	
	public String korDayOfWeek(int dayOfWeek) throws Exception {
		String retStr = "";
		
		switch (dayOfWeek) {
		case 0:
			retStr = "일요일";
			break;
		case 1:
			retStr = "월요일";
			break;
		case 2:
			retStr = "화요일";
			break;				
		case 3:
			retStr = "수요일";
			break;				
		case 4:
			retStr = "목요일";
			break;
		case 5:
			retStr = "금요일";
			break;				
		case 6:
			retStr = "토요일";
			break;				
		default:
			break;
		}
		return retStr;
	}
}

