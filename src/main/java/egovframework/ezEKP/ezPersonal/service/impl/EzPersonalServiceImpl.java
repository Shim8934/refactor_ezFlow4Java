package egovframework.ezEKP.ezPersonal.service.impl;

import java.lang.reflect.Field;
import java.security.PrivateKey;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

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
import egovframework.ezEKP.ezPersonal.vo.PersonalSliderImageVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.sim.service.EgovFileScrty;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service("EzPersonalService")
public class EzPersonalServiceImpl extends EgovAbstractServiceImpl  implements EzPersonalService{
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
	public List<PersonalSliderImageVO> getSilderList(String companyID, String mode, String sliderID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_COMPANYID", companyID);
		map.put("v_MODE", mode);
		map.put("v_SLIDERID", sliderID);
		return ezPersonalDAO.getSilderList(map);
	}

	@Override
	public String setApprovalPwd(String userID, String flag, String newPWD, String pwdType) throws Exception {
		String result = "";
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PUSERID", userID);
		map.put("v_PFLAG", flag);
		map.put("v_PPWD", newPWD);
		map.put("v_PPWDTYPE", pwdType);
		
		try {
			ezPersonalDAO.setApprovalPwd(map);
			
			result = "OK";
		} catch (Exception e) {
			result = "ERROR " + e.getMessage();
		}
		
		return result;
	}

	@Override
	public String getApprovNotiConfig(String userID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PUSERID", userID);
		
		List<PersonalApprovMailVO> approvMailVOList = ezPersonalDAO.getApprovNotiConfig(map);
		
		StringBuffer sb = new StringBuffer();
        sb.append("<DATA>");
        
        for (int i = 0; i < approvMailVOList.size(); i++) {
			sb.append(commonUtil.getQueryResult(approvMailVOList.get(i)));
		}
		sb.append("</DATA>");
		
		return sb.toString();
	}

	@Override
	public String setApprovNotiMail(String userID, String alert, String complete, String bansong, String callBack, String hesong, String saveMailFlag) throws Exception {
		String result = "";
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PUSERID", userID);
		map.put("v_PALERT", alert);
		map.put("v_PCOMPLETE", complete);
		map.put("v_PBANSONG", bansong);
		map.put("v_PCALLBACK", callBack);
		map.put("v_PHESONG", hesong);
		map.put("v_PSAVEMAILFLAG", saveMailFlag);
		
		try {
			ezPersonalDAO.setApprovNotiMail(map);
			
			result = "OK";
		} catch (Exception e) {
			result = e.getMessage();
		}
		
		return result;
	}

	@Override
	public PersonalGetEmpOfMonthVO getEmpOfMonth(String pTerm) throws Exception {
		return ezPersonalDAO.getEmpOfMonth(pTerm);
	}

	@Override
	public int getPollCount(String pComapnyID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pCompanyID", pComapnyID);
		map.put("v_pMode", "U");
		return ezPersonalDAO.getPollCount(map);
	}

	@Override
	public List<PersonalLightPollVO> getPollListUser(String pComapnyID, int pTotal, int pCount, int pStart) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pCompanyID", pComapnyID);
		map.put("v_pTotal", pTotal);
		map.put("v_pCount", pCount);
		map.put("v_pStart", pStart);
		return ezPersonalDAO.getPollListUser(map);
	}
	
	@Override
	public PersonalLightPollVO getCurrentPoll(String pUserID, String pCompanyID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pUserID", pUserID);
		map.put("v_pCompanyID", pCompanyID);
		return ezPersonalDAO.getCurrentPoll(map);
	}

	@Override
	public List<PersonalLightPollVO> getPollResultOrderResult(int pItemSeq) throws Exception {
		return (List<PersonalLightPollVO>) ezPersonalDAO.getPollResultOrderResult(pItemSeq);
	}

	@Override
	public void insertResult(int pItemSeq, String pUserID, int pResult) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pItemSeq", pItemSeq);
		map.put("v_pUserID", pUserID);
		map.put("v_pResult", pResult);
		ezPersonalDAO.insertResult(map);
	}

	@Override
	public PersonalLightPollVO getPollInfo(int pItemSeq) throws Exception {
		return ezPersonalDAO.getPollInfo(pItemSeq);
	}
	
	@Override
	public List<PersonalLightPollVO> getPollResult(int pItemSeq) throws Exception {
		return ezPersonalDAO.getPollResult(pItemSeq);
	}
	
	@Override
	public List<PersonalGetPopUpListUserVO> getPopUpListUser(String pComapnyID) throws Exception {
		return (List<PersonalGetPopUpListUserVO>) ezPersonalDAO.getPopUpListUser(pComapnyID);
	}
	
	@Override
	public List<PersonalGetQuickLinkMenuVO> getQuickLinkMenu(String accessID) throws Exception {
		return ezPersonalDAO.getQuickLinkMenu(accessID);
	}
	
	@Override
	public List<PersonalGetWebPartGroupVO> getWebPartGroup(String pCompanyID, String pMode) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pCompanyID", pCompanyID);
		map.put("v_pMode", pMode);
		return ezPersonalDAO.getWebPartGroup(map);
	}
	
	@Override
	public List<PersonalGetWebPartVO> getUserWebPart(String pUserID, String pCompanyID, String pACL) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pUserID", pUserID);
		map.put("v_pCompanyID", pCompanyID);
		map.put("v_pACL", pACL.replace(",", "','"));
		return ezPersonalDAO.getUserWebPart(map);
	}

	public String getBirthUserList(String companyID, String curMon) throws Exception {
		
		List<OrganUserVO> list = ezOrganDAO.getBirthUserList(companyID); 
		
		String solarValue = "";
		StringBuilder result = new StringBuilder("<DATA>");
		String[] array = new String[1000];
		
		for (OrganUserVO orgranUserInfo : list) {
			solarValue = orgranUserInfo.getBirth();
			
			if (orgranUserInfo.getBirthType().equals("N")) {
				String[] birthArray = solarValue.split("-");
				solarValue = changeSolarCalendar(Integer.parseInt(birthArray[0]), Integer.parseInt(birthArray[1]), Integer.parseInt(birthArray[2]), false);
				
				if (!solarValue.equals("FALSE")) {
					solarValue = solarValue.substring(0, 10);
				}
			}
			
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
		return result.toString();
	}
	
	public String changeSolarCalendar(int pYear, int mon, int day, boolean bDay) {
		Calendar cal = Calendar.getInstance();
		int year = cal.get(Calendar.YEAR);
		int nYoonMonth;
		
		//윤달이 껴있는 경우
		if (monthsInYear(year) > 12) {
			// 해당 년도의 윤월을 계산 (추후 수정)
			nYoonMonth = 0;
			
			if (bDay) {
				mon ++;
			} 
			if (mon > nYoonMonth) {
				mon ++;
			}
		}
		
		if (day > daysInMonth(year, mon)) {
			return "FALSE";
		}
		
		String result = String.valueOf(year) + String.valueOf(mon) + String.valueOf(day);
		return result;
	}
	
	//현재 연대에 있는 지정된 연도의 월 수를 반환(윤년, 평년)
	public int monthsInYear (int year) {
		int months;
		
		if ((year % 4 == 0) && (year % 100 != 0) || (year % 400 != 0)) {
			months = 13;
		}  else { 
			months = 12; 
		} 
		return months;
	}
	
	//해당 년도 및 월에 있는 일 수
	public int daysInMonth (int month, int year) {
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
		return days;
	}
	
	public int checkPassword (String pCN, String pPassword) throws Exception {
    	pPassword = EgovFileScrty.encryptPassword(pPassword, pCN);
    	
		int pResult = 0;

		if (ezPersonalDAO.getPassword(pCN).equals(pPassword)) {
			pResult = 1;
		} else {
			pResult = 0;
		}
		
		return pResult;
	}
	
}
