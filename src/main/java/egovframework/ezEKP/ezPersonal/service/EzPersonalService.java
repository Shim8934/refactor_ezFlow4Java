package egovframework.ezEKP.ezPersonal.service;

import java.util.List;

import egovframework.ezEKP.ezPersonal.vo.PersonalGetCurrentPollVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalGetEmpOfMonthVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalGetPollListUserVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalGetSliderListVO;

public interface EzPersonalService {
	public List<PersonalGetSliderListVO> getSilderList(String companyID, String mode, String sliderID) throws Exception;
	
	public List<PersonalGetPollListUserVO> getPollListUser (String pComapnyID, int pTotal, int pCount, int pStart) throws Exception;
	
	public PersonalGetEmpOfMonthVO getEmpOfMonth (String pTerm) throws Exception;
	
	public PersonalGetCurrentPollVO getCurrentPoll (String pUserID, String pCompanyID) throws Exception;

	public String setApprovalPwd(String userID, String flag, String newPWD, String pwdType) throws Exception;

	public String getApprovNotiConfig(String userID) throws Exception;

	public String setApprovNotiMail(String userID, String alert, String complete, String bansong, String callBack, String hesong, String saveMailFlag) throws Exception;
	
	public int getPollCount (String pComapnyID) throws Exception;
}
