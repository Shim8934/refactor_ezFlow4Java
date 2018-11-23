package egovframework.ezEKP.ezPersonal.service.impl;

import java.lang.reflect.Field;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.TimeZone;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ibm.icu.util.ChineseCalendar;

import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezOrgan.dao.EzOrganDAO;
import egovframework.ezEKP.ezOrgan.vo.OrganUserVO;
import egovframework.ezEKP.ezPersonal.dao.EzPersonalDAO;
import egovframework.ezEKP.ezPersonal.service.EzPersonalService;
import egovframework.ezEKP.ezPersonal.vo.PersonalApprovMailVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalGetEmpOfMonthVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalGetPopUpListUserVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalGetQuickLinkMenuVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalGetWebPartGroupVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalGetWebPartVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalLightPollVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalNoticeVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalShareApprovalVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalSliderImageVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.sim.service.EgovFileScrty;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

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
		
		if (temp != null && temp.equals("1")) {
			// SAVEMAILFLAG는 메일 발신자 ID 값에서 가져올 것.
			approvMailVOList = ezPersonalDAO.getApprovNotiConfig_S2(map);
		} else {
			approvMailVOList = ezPersonalDAO.getApprovNotiConfig_S3(map);
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
	public String setApprovNotiMail(String userID, String alert, String complete, String bansong, String callBack, String hesong, String saveMailFlag, int tenantID) throws Exception {
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
		String nowDate = commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime(""), offset, false); 

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

		logger.debug("getPopUpListUser ended");
		return (List<PersonalGetPopUpListUserVO>) ezPersonalDAO.getPopUpListUser(map);
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

	public String getBirthUserList(String companyID, String curMon, int tenantID) throws Exception {
		logger.debug("getBirthUserList started");

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_COMPANYID", companyID);
		map.put("v_TENANT_ID", tenantID);
		
		List<OrganUserVO> list = ezOrganDAO.getBirthUserList(map); 
		
		String solarValue = "";
		StringBuilder result = new StringBuilder("<DATA>");
		
		List<OrganUserVO> tempList = new ArrayList<OrganUserVO>();
		
		//음력->양력으로 변환한 리스트
		for (OrganUserVO orgranUserInfo : list) {
			solarValue = orgranUserInfo.getBirth();
			if (orgranUserInfo.getBirthType().equals("N")) {
				String[] birthArray = solarValue.split("-");
				solarValue = changeSolarCalendar(Integer.parseInt(birthArray[0]), Integer.parseInt(birthArray[1]), Integer.parseInt(birthArray[2]), false);
				
				if (!solarValue.equals("FALSE")) {
					solarValue = solarValue.substring(0, 10);
				}
				
				orgranUserInfo.setBirth(solarValue);
			}
			
			tempList.add(orgranUserInfo);
		}	
		
		//오름차순으로 정렬!
		Collections.sort(tempList, new Comparator<OrganUserVO>() {
			@Override
			public int compare(OrganUserVO o1, OrganUserVO o2) {
				return o1.getBirth().split("-")[2].compareTo(o2.getBirth().split("-")[2]);
			}
		});
		
		for (OrganUserVO orgranUserInfo : tempList) {	
			solarValue = orgranUserInfo.getBirth();
			
			if (!solarValue.equals("FALSE")) {
				if (curMon.equals(solarValue.substring(5, 7))) {
					result.append("<ROW>");
					
					for (Field field : orgranUserInfo.getClass().getDeclaredFields()) {
						field.setAccessible(true);
						String data = String.valueOf(field.get(orgranUserInfo));
						
						if(data == null || data.equals(null) || data.equals("null")){
							data = "";
						}
						
						if (field.getName().toUpperCase().equals("BIRTH")) {
							result.append("<" + field.getName().toUpperCase() + ">");
							result.append(solarValue.substring(5, 10));
							
							result.append("</" + field.getName().toUpperCase() + ">");
							result.append("<BIRTHDAY>");
							result.append(solarValue.substring(8, 10));
							result.append("</BIRTHDAY>");
						} else {
							result.append("<" + field.getName().toUpperCase() + ">");
							result.append(commonUtil.cleanValue(data));
							result.append("</" + field.getName().toUpperCase() + ">");
						}
					}
					
					result.append("</ROW>");
				}
			}
		}
		
		result.append("</DATA>");

		logger.debug("getBirthUserList ended");
		return result.toString();
	}
	
	public String changeSolarCalendar(int pYear, int mon, int day, boolean bDay) {
		logger.debug("changeSolarCalendar started");

		Calendar cal = Calendar.getInstance();
		int year = cal.get(Calendar.YEAR);
		logger.debug("pYear="+pYear + ",mon="+mon+",day="+day+",bDay="+bDay);
		
		//int nYoonMonth;
		//윤달이 껴있는 경우
		/*if (monthsInYear(year) > 12) {
			// 해당 년도의 윤월을 계산 (추후 수정)
			nYoonMonth = 0;
			
			if (bDay) {
				mon ++;
			} 
			if (mon > nYoonMonth) {
				mon ++;
			}
		}*/
		
		if (day > daysInMonth(mon, year)) {
			if (pYear % 4 != 0 && mon != 2) {
				return "FALSE";
			}
		}
		
		//음력->양력으로 변환
		String month = ((mon < 10) ? "0"+String.valueOf(mon) : String.valueOf(mon));
		String days = ((day < 10) ? "0"+String.valueOf(day) : String.valueOf(day));
		ChineseCalendar cc = new ChineseCalendar();
		cc.set(ChineseCalendar.EXTENDED_YEAR, year+2637);
		cc.set(ChineseCalendar.MONTH, Integer.parseInt(month)-1);
		cc.set(ChineseCalendar.DAY_OF_MONTH, Integer.parseInt(days));
		
		cal.setTimeInMillis(cc.getTimeInMillis());
		
		int y = cal.get(Calendar.YEAR); 
		int m = cal.get(Calendar.MONTH)+1; 
		int d = cal.get(Calendar.DAY_OF_MONTH); 
		
		StringBuffer ret = new StringBuffer();
		
		if( y < 1000 ) 
			ret.append( "0" ) ; 
		else if( y < 100 ) 
			ret.append( "00" ) ; 
		else if( y < 10 ) 
			ret.append( "000" ) ; 
		ret.append( y + "-") ; 
		
		if( m < 10 ) {
			ret.append( "0" ) ; 
		}
		
		ret.append( m + "-") ; 
		
		if( d < 10 ) {
			ret.append( "0" ) ; 
		}
		
		ret.append( d ) ; 
		
		logger.debug("sbresult="+ret.toString());
		logger.debug("changeSolarCalendar ended");
	    return ret.toString();
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
	
	public int checkPassword (String pCN, String pPassword, int tenantID) throws Exception {
		logger.debug("checkPassword started");

		pPassword = EgovFileScrty.encryptPassword(pPassword, pCN);
		
		int pResult = 0;
		
		if (ezPersonalDAO.getPassword(pCN, tenantID).equals(pPassword)) {
			pResult = 1;
		} else {
			pResult = 0;
		}

		logger.debug("checkPassword ended");
		return pResult;
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
		map.put("shareUserID", shareUserID.split(",")); //'id1', 'id2'형태로?? 아니면 배열해서 iterate
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
}
