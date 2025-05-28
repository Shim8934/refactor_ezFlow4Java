package egovframework.ezEKP.ezPersonal.service.impl;

import java.text.SimpleDateFormat;
import java.time.OffsetDateTime;
import java.time.OffsetTime;
import java.time.ZoneOffset;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.StringUtils;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;
import org.w3c.dom.Document;

import com.ibm.icu.util.ChineseCalendar;

import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezOrgan.dao.EzOrganDAO;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.ezEKP.ezOrgan.vo.OrganUserVO;
import egovframework.ezEKP.ezPersonal.dao.EzPersonalDAO;
import egovframework.ezEKP.ezPersonal.service.EzPersonalService;
import egovframework.ezEKP.ezPersonal.type.NotiPlatform;
import egovframework.ezEKP.ezPersonal.type.NotiType;
import egovframework.ezEKP.ezPersonal.vo.PersonalApprovMailVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalGetEmpOfMonthVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalGetPopUpListUserVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalGetQuickLinkMenuVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalGetWebPartGroupVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalGetWebPartVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalLightPollVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalNotiDisableItemVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalNotiPreferencesVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalNoticeVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalShareApprovalVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalSliderImageVO;
import egovframework.ezEKP.ezSchedule.service.EzScheduleService;
import egovframework.ezEKP.ezSchedule.vo.ScheGetHolidayVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.fcc.service.KoreanLunarCalendar;
import egovframework.let.utl.sim.service.EgovFileScrty;
import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service("EzPersonalService")
public class EzPersonalServiceImpl extends EgovAbstractServiceImpl  implements EzPersonalService{
	
	private static final Logger logger = LoggerFactory.getLogger(EzPersonalServiceImpl.class);
	
	@Resource(name = "crypto") 
	private EgovFileScrty egovFileScrty;
	
	@Resource(name="EzPersonalDAO")
	private EzPersonalDAO ezPersonalDAO;
	
	@Resource(name="EzOrganDAO")
	private EzOrganDAO ezOrganDAO;
	
	@Resource(name="EzCommonService")
	private EzCommonService ezCommonService;
	
	@Resource(name="EzOrganService")
	private EzOrganService ezOrganService;

	@Autowired
	private EzScheduleService ezScheduleService;

	@Autowired
	private CommonUtil commonUtil;
	
	@Override
	public List<PersonalSliderImageVO> getSilderList(String companyID, String mode, String sliderID, int tenantID) throws Exception {
		logger.debug("getSilderList started");

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_COMPANYID", companyID);
		map.put("v_MODE", mode);
		map.put("v_SLIDERID", sliderID);
		map.put("tenantID", tenantID);

		logger.debug("getSilderList ended");
		return ezPersonalDAO.getSilderList(map);
	}

	@Override
	public String setApprovalPwd(String userID, String flag, String newPWD, String pwdType, int tenantID, String companyID) throws Exception {
		logger.debug("setApprovalPwd started");

		String result = "";
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_PUSERID", userID);
		map.put("v_PFLAG", flag);
		map.put("v_PPWD", newPWD);
		
		//결재암호 사용안할 시 무조건 로그인 암호로 저장됨
		if (flag.equals("N")) {
			map.put("v_PPWDTYPE", "L");
		} else {
			map.put("v_PPWDTYPE", pwdType);
		}
		
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);
		
		try {
			String temp = ezPersonalDAO.setApprovalPwd_S(map);
			
			if (temp != null && temp.equals("1")) {
				/**
				 * 1. 로그인 암호를 사용할 경우 -> pwdType, FLAG 업데이트
				 * 2. 결재 암호를 사용할 경우 xml에서 분기
				 * 2-1. v_PFLAG == Y -> FLAG, PWD, PWDTYPE 업데이트
				 * 2-2. v_PFLAG == N -> FLAG만 업데이트
				 * */
				if (pwdType.equalsIgnoreCase("L")) {
					ezPersonalDAO.setApprovalPwd_L(map);
				} else {
					ezPersonalDAO.setApprovalPwd_U(map);
				}
			} else {
				ezPersonalDAO.setApprovalPwd_I(map);
			}
			
			result = "OK";
		} catch (Exception e) {
			result = "ERROR " + e.getMessage();
		}

		logger.debug("setApprovalPwd ended");
		return result;
	}

	@Override
	public String getApprovNotiConfig(String userID, String currentID, int tenantID) throws Exception {
		logger.debug("getApprovNotiConfig started");		
		/**
		 * 보낸 편지함에 결재관련 메일이 등록되는 것을 막기 위해선
		 * 메일을 받는 사람의 SAVEMAILFLAG가 아닌 메일을 보내는 사람(현재 유저)의 SAVEMAILFLAG 값이 필요.
		 * userID : 메일 수신자
		 * userInfo.getID() : 메일 발신자
		 * */
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_PUSERID", userID);
		map.put("tenantID", tenantID);
		map.put("currentID", currentID);
		
		String temp = ezPersonalDAO.getApprovNotiConfig_S1(map);
		
		List<PersonalApprovMailVO> approvMailVOList = new ArrayList<PersonalApprovMailVO>();
		
		String useMailApprNoti = ezCommonService.getTenantConfig("useMailApprNoti", tenantID);
		if(useMailApprNoti == null || useMailApprNoti.equals("")) {
			useMailApprNoti = "YES";
		}
		
		if (useMailApprNoti.equalsIgnoreCase("NO")){
			approvMailVOList = ezPersonalDAO.getApprovNotiConfig_S4(map);
		} else {
			if (temp != null && temp.equals("1")) {
			// SAVEMAILFLAG는 메일 발신자 ID 값에서 가져올 것.
				approvMailVOList = ezPersonalDAO.getApprovNotiConfig_S2(map);
			} else {
				approvMailVOList = ezPersonalDAO.getApprovNotiConfig_S3(map);
			}
		}
		
		StringBuffer sb = new StringBuffer();
        sb.append("<DATA>");
        
        for (int i = 0; i < approvMailVOList.size(); i++) {
			sb.append(commonUtil.getQueryResult(approvMailVOList.get(i)));
		}
        
		sb.append("</DATA>");
		
		logger.debug("sb="+sb.toString());
		logger.debug("getApprovNotiConfig ended");
		return sb.toString();
	}

	@Override
	public String setApprovNotiMail(String userID, String alert, String complete, String bansong, String callBack, String hesong, String saveMailFlag, int tenantID, String linePass) throws Exception {
		logger.debug("setApprovNotiMail started");

		String result = "";
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_PUSERID", userID);
		map.put("v_PALERT", alert);
		map.put("v_PCOMPLETE", complete);
		map.put("v_PBANSONG", bansong);
		map.put("v_PCALLBACK", callBack);
		map.put("v_PHESONG", hesong);
		map.put("v_PSAVEMAILFLAG", saveMailFlag);
		map.put("tenantID", tenantID);
		map.put("linePass", linePass);
		
		try {
			String temp = ezPersonalDAO.setApprovNotiMail_S(map);
			
			if (temp != null && temp.equals("1")) {
				ezPersonalDAO.setApprovNotiMail_I(map);
			} else {
				ezPersonalDAO.setApprovNotiMail_U(map);
			}
			
			result = "OK";
		} catch (Exception e) {
			result = e.getMessage();
		}

		logger.debug("setApprovNotiMail ended");
		return result;
	}

	@Override
	public PersonalGetEmpOfMonthVO getEmpOfMonth(String pTerm, LoginVO userInfo) throws Exception {
		logger.debug("getEmpOfMonth started");

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_PTERM", pTerm);
		map.put("companyID", userInfo.getCompanyID());
		map.put("tenantID", userInfo.getTenantId());

		logger.debug("getEmpOfMonth ended");
		return ezPersonalDAO.getEmpOfMonth(map);
	}

	@Override
	public int getPollCount(String pComapnyID, int tenantID) throws Exception {
		logger.debug("getPollCount started");

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_pCompanyID", pComapnyID);
		map.put("v_pMode", "A");
		map.put("tenantID", tenantID);

		logger.debug("getPollCount ended");
		return ezPersonalDAO.getPollCount(map);
	}

	@Override
	public List<PersonalLightPollVO> getPollListUser(String pComapnyID, int pTotal, int pCount, int pStart, int tenantID) throws Exception {
		logger.debug("getPollListUser started");

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_pCompanyID", pComapnyID);
		map.put("v_pTotal", pTotal);
		map.put("v_pCount", pCount);
		map.put("v_pStart", pStart);
		map.put("tenantID", tenantID);

		logger.debug("getPollListUser ended");
		return ezPersonalDAO.getPollListUser(map);
	}
	
	@Override
	public PersonalLightPollVO getCurrentPoll(String pUserID, String pCompanyID, int tenantID, String offset) throws Exception {
		logger.debug("getCurrentPoll started");

		Map<String, Object> map = new HashMap<String, Object>();

		/* 2023-01-17 전인하 - 빠른설문 > DB에 들어가는 값이 UTC 시간으로 변경됨에 따라 비교조건도 UTC 시간으로 수정 */
		String nowDate = commonUtil.getTodayUTCTime("");
		//String nowDate = commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime(""), offset, false);

		map.put("v_pUserID", pUserID);
		map.put("v_pCompanyID", pCompanyID);
		map.put("tenantID", tenantID);
		map.put("nowDate", nowDate);

		logger.debug("getCurrentPoll ended");
		return ezPersonalDAO.getCurrentPoll(map);
	}

	@Override
	public List<PersonalLightPollVO> getPollResultOrderResult(int pItemSeq, int tenantID) throws Exception {
		logger.debug("getPollResultOrderResult started");

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_pItemSeq", pItemSeq);
		map.put("tenantID", tenantID);

		logger.debug("getPollResultOrderResult ended");
		return (List<PersonalLightPollVO>) ezPersonalDAO.getPollResultOrderResult(map);
	}

	@Override
	public void insertResult(int pItemSeq, String pUserID, int pResult, int tenantID) throws Exception {
		logger.debug("insertResult started");

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_pItemSeq", pItemSeq);
		map.put("v_pUserID", pUserID);
		map.put("v_pResult", pResult);
		map.put("tenantID", tenantID);
		
		String temp = ezPersonalDAO.insertResult_S(map);
		
		if (temp != null && temp.equals("1")) {
			ezPersonalDAO.insertResult(map);
		}

		logger.debug("insertResult ended");
	}

	@Override
	public PersonalLightPollVO getPollInfo(int pItemSeq, int tenantID) throws Exception {
		logger.debug("getPollInfo started");

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_pItemSeq", pItemSeq);
		map.put("tenantID", tenantID);

		logger.debug("getPollInfo ended");
		return ezPersonalDAO.getPollInfo(map);
	}
	
	@Override
	public List<PersonalLightPollVO> getPollResult(int pItemSeq, int tenantID) throws Exception {
		logger.debug("getPollResult started");

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_pItemSeq", pItemSeq);
		map.put("tenantID", tenantID);

		logger.debug("getPollResult ended");
		return ezPersonalDAO.getPollResult(map);
	}
	
	@Override
	public List<PersonalGetPopUpListUserVO> getPopUpListUser(String pComapnyID, int tenantID, String offset) throws Exception {
		logger.debug("getPopUpListUser started");

		Map<String, Object> map = new HashMap<String, Object>();

		//String nowDate = commonUtil.getTodayUTCTime("yyyy-MM-dd HH:mm:ss");
		// 2018-11-23 황윤호 offset 적용 
		String nowDate = commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime(""), offset, false);

		map.put("v_pCompanyID", pComapnyID);
		map.put("nowDate", nowDate);
		map.put("tenantID", tenantID);
		
		List<PersonalGetPopUpListUserVO> popupList = ezPersonalDAO.getPopUpListUser(map);
		
		logger.debug("getPopUpListUser ended");
		return popupList;
	}
	
	@Override
	public List<PersonalGetPopUpListUserVO> getPopUpListUserWithAuth(String pComapnyID, int tenantID, String offset, String userId, String deptId) throws Exception {
		logger.debug("getPopUpListUser started");
		logger.debug("[params] companyId=" + pComapnyID + ", tenantId=" + tenantID + ", userId = " + userId + ", deptId = " + deptId);
		Map<String, Object> map = new HashMap<String, Object>();

		//String nowDate = commonUtil.getTodayUTCTime("yyyy-MM-dd HH:mm:ss");
		// 2018-11-23 황윤호 offset 적용 
		String nowDate = commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime(""), offset, false);

		map.put("v_pCompanyID", pComapnyID);
		map.put("nowDate", nowDate);
		map.put("tenantID", tenantID);
		
		List<PersonalGetPopUpListUserVO> popupList = ezPersonalDAO.getPopUpListUser(map);
		List<PersonalGetPopUpListUserVO> popupListWithAuth = new ArrayList<PersonalGetPopUpListUserVO>();
		
		if (popupList != null) {
			for (PersonalGetPopUpListUserVO popup : popupList) {
				map.put("companyId", pComapnyID);
				map.put("tenantId", tenantID);
				map.put("userId", userId);
				map.put("itemSeq", popup.getItemSeq());
				map.put("deptId", deptId);
				
				boolean popupYN = ezPersonalDAO.getPopupPermitYN(map);
				
				logger.debug("[popupAuth] popupSeq = " + popup.getItemSeq() + ", popupYN = " + popupYN);
				
				if (popupYN) {
					popupListWithAuth.add(popup);
				} else {
					// popupYN이 false일 때 권한 그룹리스트 가져와서 체크
					List<String> groupList = ezPersonalDAO.getPopupUserGroupList(map);
					
					if (groupList != null) {
						for (String groupId : groupList) {
							boolean groupPermissionYN = ezCommonService.getPermissionGroupAccessYN(groupId, pComapnyID, tenantID, userId, deptId, true);
							
							if (groupPermissionYN) {
								popupListWithAuth.add(popup);
								break;
							}
						}
					}
				}
			}
		}
		
		logger.debug("getPopUpListUser ended");
		return popupListWithAuth;
	}
	
	@Override
	public List<PersonalGetQuickLinkMenuVO> getQuickLinkMenu(String accessID, int tenantID) throws Exception {
		logger.debug("getQuickLinkMenu started");

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_ACCESSID", accessID);
		map.put("tenantID", tenantID);

		logger.debug("getQuickLinkMenu ended");
		return ezPersonalDAO.getQuickLinkMenu(map);
	}
	
	@Override
	public List<PersonalGetWebPartGroupVO> getWebPartGroup(String pCompanyID, String pMode, int tenantID) throws Exception {
		logger.debug("getWebPartGroup started");

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_pCompanyID", pCompanyID);
		map.put("v_pMode", pMode);
		map.put("tenantID", tenantID);

		logger.debug("getWebPartGroup ended");
		return ezPersonalDAO.getWebPartGroup(map);
	}
	
	@Override
	public List<PersonalGetWebPartVO> getUserWebPart(String pUserID, String pCompanyID, String pACL, int tenantID) throws Exception {
		logger.debug("getUserWebPart started");

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_pUserID", pUserID);
		map.put("v_pCompanyID", pCompanyID);
		map.put("v_pACL", pACL.replace(",", "','"));
		map.put("tenantID", tenantID);
		
		String temp = ezPersonalDAO.getUserWebPart_S1(map);
		
		if (temp != null && temp.equals("1")) {
			logger.debug("getUserWebPart ended");
			return ezPersonalDAO.getUserWebPart_S2(map);
		} else {
			logger.debug("getUserWebPart ended");
			return ezPersonalDAO.getUserWebPart_S3(map);
		}
	}
	
	@Override
	public List<PersonalNoticeVO> getNoticeListMain(String companyID, int tenantID) throws Exception {
		logger.debug("getNoticeListMain started");

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_pCompanyID", companyID);
		map.put("tenantID", tenantID);

		logger.debug("getNoticeListMain ended");
		return ezPersonalDAO.getNoticeListMain(map);
	}
	
	@Override
	public List<PersonalNoticeVO> getNoticeListUser(String companyID,int pTotal, int pCount, int pStart, int tenantID) throws Exception {
		logger.debug("getNoticeListUser started");

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_pCompanyID", companyID);
		map.put("v_pTotal", pTotal);
		map.put("v_pCount", pCount);
		map.put("v_pStart", pStart);
		map.put("tenantID", tenantID);

		logger.debug("getNoticeListUser ended");
		return ezPersonalDAO.getNoticeListUser(map);
	}

	@Override
	public List<OrganUserVO> getBirthUserList(String companyId, int tenantId, int month, String lang) throws Exception {
		logger.debug("getBirthUserList started.");
		
		String monthStr = "";
		
		if (month < 10) {
			monthStr = "0" + month;
		} else {
			monthStr = String.valueOf(month);
		}
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("month", monthStr);
		map.put("tenantId", tenantId);
		map.put("companyId", companyId);
		map.put("lang", commonUtil.getMultiData(lang, tenantId));
		
		List<OrganUserVO> tempList = ezOrganDAO.getBirthUserList(map);
		List<OrganUserVO> birthdayList = new ArrayList<OrganUserVO>();
		
		for (OrganUserVO vo : tempList) {
			String birthType = vo.getBirthType();
			
			if (birthType.equals("Y")) {
				birthdayList.add(vo);
			} else {
				String toSolarDate = convertLunarToSolar(vo.getBirth(), month);
				
				if (!toSolarDate.equals("")) {
					vo.setBirth(toSolarDate);
					birthdayList.add(vo);
				}
			}
		}
		
		Collections.sort(birthdayList, new Comparator<OrganUserVO>() {
			@Override
			public int compare(OrganUserVO o1, OrganUserVO o2) {
				return o1.getBirth().split("-")[2].compareTo(o2.getBirth().split("-")[2]);
			}
		});
		
		logger.debug("getBirthUserList ended.");
		
		return birthdayList;
	}
	
	public String convertLunarToSolar (String birthday, int compMonth) {
		logger.debug("convertLunarToSolar started.");
		
		String result = "";
		ChineseCalendar cc = new ChineseCalendar();
		Calendar cal = Calendar.getInstance();
		
		cc.set(ChineseCalendar.EXTENDED_YEAR, Integer.parseInt(birthday.substring(0, 4)) + 2637);
		
		String monthStr = birthday.substring(5,7);
		int month = 0;
		
		if (monthStr.indexOf("0") == 0) { //1월~9월까지는 앞에 0이 붙기때문에 제거해야함.
			monthStr = monthStr.substring(1);
		}
		
		month = Integer.parseInt(monthStr);
		
		cc.set(ChineseCalendar.MONTH, month - 1);
		cc.set(ChineseCalendar.DAY_OF_MONTH, Integer.parseInt(birthday.substring(8)));

		cal.setTimeInMillis(cc.getTimeInMillis());

		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		result = sdf.format(cal.getTime());
		
		String monthComp = String.valueOf(compMonth);
		
		String chineseMonth = result.substring(5, 7);
		
		if (chineseMonth.indexOf("0") == 0) {
			chineseMonth = chineseMonth.substring(1);
		}
		
		if (!chineseMonth.equals(monthComp)) {
			result = "";
		}
		
		logger.debug("convertLunarToSolar ended.");
		
		return result;
	}
	
	//현재 연대에 있는 지정된 연도의 월 수를 반환(윤년, 평년)
	public int monthsInYear (int year) {
		logger.debug("monthsInYear started");

		int months;
		
		if ((year % 4 == 0) && (year % 100 != 0) || (year % 400 != 0)) {
			months = 13;
		}  else { 
			months = 12; 
		} 

		logger.debug("monthsInYear ended");
		return months;
	}
	
	//해당 년도 및 월에 있는 일 수
	public int daysInMonth (int month, int year) {
		logger.debug("daysInMonth started");

		int days;
		
		if (year % 4 == 0 && month == 2) {
			days = 29;
		} else if (month == 2) {
			days = 28;
		} else if (month == 4 || month == 6 || month == 9 || month == 11) { 
			days = 30; 
		} else if (month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12) { 
			days = 31; 
		} else { 
			days = 0; 
		} 

		logger.debug("daysInMonth ended");
		return days;
	}
	
	/** 비밀번호 검증 : 현비번 comparing with db현비번 */
	@Override
	public boolean checkPassword (String pCN, String decryptPassword, int tenantID) throws Exception {
		String encryptedOldPassword = EgovFileScrty.encryptPassword(decryptPassword, pCN);
		String currentPassword = ezPersonalDAO.getPassword(pCN, tenantID);
		boolean result = encryptedOldPassword.equals(currentPassword);
		if (!result) {
			logger.debug("checkPassword error - not crrect. : decryptPassword={}, currentPassword={}", decryptPassword, currentPassword);
		}
		return result;
	}
	
	@Override
	public String getShareApprovalList (String userID, String lang, String offset, String companyID, int tenantID) throws Exception {
		logger.debug("getShareApprovalList started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userID", userID);
		map.put("offset", offset);
		map.put("tenantID", tenantID);
		map.put("lang", commonUtil.getMultiData(lang, tenantID));
		map.put("companyID", companyID);
		List<PersonalShareApprovalVO> shareApprovalList = ezPersonalDAO.getShareApprovalList(map);
		
		StringBuffer sb = new StringBuffer();
        sb.append("<DATA>");
        
        for (int i = 0; i < shareApprovalList.size(); i++) {
			sb.append(commonUtil.getQueryResult(shareApprovalList.get(i)));
		}
        
		sb.append("</DATA>");
		logger.debug("getShareApprovalList ended");
		return sb.toString();
	}
	
	@Override
	public String insertShareApproval (String userID, String shareUserID, String shareUserDeptID, String companyID, int tenantID) throws Exception {
		logger.debug("insertShareApproval started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userID", userID);
		map.put("shareUserID", shareUserID);
		map.put("shareUserDeptID", shareUserDeptID);
		map.put("tenantID", tenantID);
		map.put("shareDate", commonUtil.getTodayUTCTime(""));
		map.put("companyID", companyID);
		
		ezPersonalDAO.insertShareApproval(map);
		
		logger.debug("insertShareApproval ended");
		return "OK";
	}
	
	@Override
	public String deleteShareApproval (String userID, String shareUserID, String companyID, int tenantID) throws Exception {
		logger.debug("deleteShareApproval started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userID", userID);
		map.put("shareUserID", shareUserID.split(","));
		map.put("tenantID", tenantID);
		map.put("companyID", companyID);
		
		ezPersonalDAO.deleteShareApproval(map);
		
		logger.debug("deleteShareApproval ended");
		return "OK";
	}
	
	@Override
	public String getCheckDuplShareUser (String userID, String shareUserID, String companyID, int tenantID) throws Exception {
		logger.debug("getCheckDuplShareUser started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userID", userID);
		map.put("shareUserID", shareUserID);
		map.put("tenantID", tenantID);
		map.put("companyID", companyID);
		
		String rtnValue = "";
		int result = ezPersonalDAO.getCheckDuplShareUser(map);
		
		if (result == 0) {
			rtnValue = "Ok";
		} else {
			rtnValue = "Dupl";
		}
		
		logger.debug("getCheckDuplShareUser ended.");
		return rtnValue;
	}
	
	public Object saveBujaeUser(String loginCookie, LoginVO userInfo, HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		logger.debug("saveBujaeUser started");

		JSONArray ja = new JSONArray();
		JSONParser parser = new JSONParser();
		
		userInfo = commonUtil.userInfo(loginCookie);

		logger.debug("user: " + userInfo.getId() + " / comp:" + userInfo.getCompanyID() + " / dept:" + userInfo.getDeptID());
		
		String result = "";

		// 전자결재만 존재하면 아래와 같이 "user"로 하드코딩이 가능하나, 다른 모듈 존재 시 수정 필요함
		String pClass = "user";
		String strFormArray = request.getParameter("formArray");
		
		ja = (JSONArray)parser.parse(strFormArray);
		
		for(int i=0; i<ja.size(); i++) {
			JSONObject jo = new JSONObject();
			if(i == 0) {
				jo = (JSONObject)ja.get(i);
				result = ezOrganService.updateProperty(userInfo.getId(), "extensionAttribute5", jo.get("proxy").toString(), pClass, userInfo.getTenantId());

				logger.debug("updateProperty proxy:" + jo.get("proxy").toString());
			} else {
				jo = (JSONObject)ja.get(i);
				result = ezOrganService.updateAddJobProxy(userInfo.getId(), jo.get("proxy").toString(), userInfo.getTenantId(), jo.get("deptId").toString(), jo.get("jobId").toString());

				logger.debug("updateAddJobProxy proxy:" + jo.get("proxy").toString() + " / deptId:" + jo.get("deptId").toString() + " / jobId:" + jo.get("jobId").toString());
			}
		}
		
		logger.debug("saveBujaeUser ended");
		return result;
	}

	@Override
	public List<PersonalNotiDisableItemVO> getAllNotiDisableItem(String userId, int tenantId) {
		logger.debug("getAllNotiDisableItems started. userId={}, tenantId={}", userId, tenantId);
		List<PersonalNotiDisableItemVO> result = ezPersonalDAO.getAllNotiDisableItem(userId, tenantId);
		logger.debug("getAllNotiDisableItems ended. result={}", result);
		return result;
	}

	@Override
	public List<Integer> getAllPlatformFromNotiDisableItem(String userId, NotiType type, int tenantId) {
		logger.debug("getAllPlatformFromNotiDisableItem started. userId={}, type={} tenantId={}", userId, type, tenantId);
		List<Integer> result = ezPersonalDAO.getAllNotiDisableItem(userId, tenantId).stream()
				.filter(it -> it.getMainType() == type.mainType() && it.getSubType() == type.subType())
				.map(PersonalNotiDisableItemVO::getPlatform).collect(Collectors.toList());
		logger.debug("getAllPlatformFromNotiDisableItem ended. result={}", result);
		return result;
	}

	@Override
	public boolean hasNotiDiableItem(String userId, NotiType type, NotiPlatform platform, int tenantId) {
		logger.debug("hasNotiDiableItem started. userId={}, type={}, platform={}, tenantId={}", userId, type, platform, tenantId);
		boolean exists = ezPersonalDAO.findNotiDisableItem(userId, type, platform, tenantId) != null;
		logger.debug("hasNotiDiableItem ended. result={}", exists);
		return exists;
	}

	@Override
	public void setNotiDisableItems(String userId, int tenantId, List<PersonalNotiDisableItemVO> items) throws Exception {
		logger.debug("setNotiDisabledItems started. userId={}, tenantId={}, items={}", userId, tenantId, items);
		ezPersonalDAO.clearNotiDisableItems(userId, tenantId);
		
		if (!items.isEmpty()) {
			ezPersonalDAO.insertNotiDisableItems(userId, tenantId, items);
		}
		
		logger.debug("setNotiDisabledItems ended.");
	}

	@Override
	public PersonalNotiPreferencesVO getNotiPreferences(String userId, int tenantId) {
		try {
			String value = ezCommonService.getUserConfigInfo(tenantId, userId, "notiPreferences");
			return PersonalNotiPreferencesVO.byConfigValue(value);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			return new PersonalNotiPreferencesVO();
		}
	}

	@Override
	public void setNotiPreferences(String userId, int tenantId, PersonalNotiPreferencesVO vo) throws Exception {
		logger.debug("setNotiPreferences started. userId={}, tenantId={}, vo={}", userId, tenantId, vo);

		if (vo.isFixedTimeReceive() && vo.getStartTime() >= vo.getEndTime()) {
			throw new IllegalArgumentException("startTime must not be greater than or equal to the endTime.");
		}

		if (ezCommonService.getUserConfigInfo(tenantId, userId, "notiPreferences").isEmpty()) {
			ezCommonService.insertUserConfigInfo(tenantId, userId, "notiPreferences", vo.toConfigValue());
		} else {
			ezCommonService.updateUserConfigInfo(tenantId, userId, "notiPreferences", vo.toConfigValue());
		}

		logger.debug("setNotiPreferences ended.");
	}

	@Override
	public boolean canReceiveNotification(String userId, int tenantId) {
		logger.debug("canReceiveNotification started. userId={}, tenantId={}", userId, tenantId);

		try {
			PersonalNotiPreferencesVO preferencesVO = getNotiPreferences(userId, tenantId);

			if (preferencesVO.isNotReceive()) {
				logger.debug("always not receive");
				return false;
			}

			if (preferencesVO.canReceiveHoliday() && preferencesVO.isAlwaysReceive()) {
				logger.debug("always receive");
				return true;
			}

			String timeZone = ezCommonService.selectUserGetTimeZone(userId, tenantId);
			int offsetMinute = Integer.parseInt(commonUtil.getMinuteUTC(timeZone));
			ZoneOffset offset = ZoneOffset.ofTotalSeconds(offsetMinute * 60);

			if (preferencesVO.isFixedTimeReceive()) {
				OffsetTime currentTime = OffsetTime.now(offset);
				OffsetTime receiveStartTime = OffsetTime.of(preferencesVO.getStartTime() / 100, preferencesVO.getStartTime() % 100, 0, 0, offset);
				OffsetTime receiveEndTime = OffsetTime.of(preferencesVO.getEndTime() / 100, preferencesVO.getEndTime() % 100, 0, 0, offset);//59, 999_999_999, offset);

				logger.debug("fixed time receive");
				logger.debug("current: {}, start: {}, end: {}", currentTime, receiveStartTime, receiveEndTime);

				if (currentTime.isBefore(receiveStartTime)) {
					logger.debug("can't receive before start time");
					return false;
				}

				if (currentTime.isAfter(receiveEndTime)) {
					logger.debug("can't receive after end time");
					return false;
				}
			} else {
				logger.debug("always receive");
			}

			if (preferencesVO.canReceiveHoliday()) {
				return true;
			}

			// 공휴일 체크
			logger.debug("check holiday");
			String companyId = ezOrganDAO.getCompanyId(userId, tenantId);
			// 사용하는 것만 필터링
			// all(휴일모두), rest(휴무일만)
			List<ScheGetHolidayVO> holidays = ezScheduleService.getTholiday("VIEW", companyId, tenantId, "all").stream().filter(holiday -> holiday.getIsUse() == 1).collect(Collectors.toList());

			OffsetDateTime currentDate = OffsetDateTime.now(offset);
			int year = currentDate.getYear(), month = currentDate.getMonthValue(), day = currentDate.getDayOfMonth();

			// 음력처리
			KoreanLunarCalendar lunarCalendar = KoreanLunarCalendar.newInstance();
			lunarCalendar.setSolarDate(year, month, day);

			for (ScheGetHolidayVO holiday : holidays) {
				int yyyymmdd = Integer.parseInt(holiday.getHolidayDate().substring(0, 10).replace("-", ""));
				int holidayYear = yyyymmdd / 10000, holidayMonth = yyyymmdd % 10000 / 100, holidayDay = yyyymmdd % 100;

				if (holiday.getIsSolar() == 1) {
					if (holidayYear == year && holidayMonth == month && holidayDay == day) {
						logger.debug("can't receive solar holiday: {}", holiday.getHolidayName());
						return false;
					}
				} else {
					if (holidayYear == lunarCalendar.getLunarYear() && holidayMonth == lunarCalendar.getLunarMonth() && holidayDay == lunarCalendar.getLunarDay()) {
						logger.debug("can't receive lunar holiday: {}", holiday.getHolidayName());
						return false;
					}
				}
			}

			return true;
		} catch (Exception ex) {
			logger.error(ex.getMessage(), ex);
			return false;
		} finally {
			logger.debug("canReceiveNotification ended.");
		}
	}

}
