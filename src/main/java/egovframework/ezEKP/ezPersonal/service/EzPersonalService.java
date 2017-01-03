package egovframework.ezEKP.ezPersonal.service;

import java.util.List;

import egovframework.ezEKP.ezPersonal.vo.PersonalGetEmpOfMonthVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalGetPopUpListUserVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalGetQuickLinkMenuVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalGetWebPartGroupVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalGetWebPartVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalLightPollVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalSliderImageVO;

public interface EzPersonalService {
	public List<PersonalSliderImageVO> getSilderList(String companyID, String mode, String sliderID) throws Exception;
	
	public List<PersonalLightPollVO> getPollListUser (String pComapnyID, int pTotal, int pCount, int pStart, int tenantID) throws Exception;
	
	public List<PersonalLightPollVO> getPollResultOrderResult (int pItemSeq, int tenantID) throws Exception;
	
	public List<PersonalLightPollVO> getPollResult (int pItemSeq, int tenantID) throws Exception;
	
	public List<PersonalGetPopUpListUserVO> getPopUpListUser (String pComapnyID, int tenantID) throws Exception;
	
	public List<PersonalGetWebPartGroupVO> getWebPartGroup (String pCompanyID, String pMode) throws Exception;
	
	public List<PersonalGetWebPartVO> getUserWebPart (String pUserID, String pCompanyID, String pACL) throws Exception;
	
	public List<PersonalGetQuickLinkMenuVO> getQuickLinkMenu (String accessID, int tenantID) throws Exception;
	
	public PersonalGetEmpOfMonthVO getEmpOfMonth (String pTerm, int tenantID) throws Exception;
	
	public PersonalLightPollVO getCurrentPoll (String pUserID, String pCompanyID, int tenantID) throws Exception;
	
	public PersonalLightPollVO getPollInfo (int pItemSeq, int tenantID) throws Exception;
	
	public String setApprovalPwd(String userID, String flag, String newPWD, String pwdType, int tenantID) throws Exception;

	public String getApprovNotiConfig(String userID, int tenantID) throws Exception;

	public String setApprovNotiMail(String userID, String alert, String complete, String bansong, String callBack, String hesong, String saveMailFlag, int tenantID) throws Exception;
	
	public String getBirthUserList(String companyID, String curMon) throws Exception;
	
	public int getPollCount (String pComapnyID, int tenantID) throws Exception;
	
	public void insertResult (int pItemSeq, String pUserID, int pResult, int tenantID) throws Exception;
	
	public int checkPassword (String pCN, String pPassword, int tenantID) throws Exception;
}
