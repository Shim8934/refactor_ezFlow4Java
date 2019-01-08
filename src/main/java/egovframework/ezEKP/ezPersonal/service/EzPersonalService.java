package egovframework.ezEKP.ezPersonal.service;

import java.util.List;

import egovframework.ezEKP.ezOrgan.vo.OrganUserVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalGetEmpOfMonthVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalGetPopUpListUserVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalGetQuickLinkMenuVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalGetWebPartGroupVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalGetWebPartVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalLightPollVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalNoticeVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalSliderImageVO;
import egovframework.let.user.login.vo.LoginVO;

public interface EzPersonalService {
	public List<PersonalSliderImageVO> getSilderList(String companyID, String mode, String sliderID, int tenantID) throws Exception;
	
	public List<PersonalLightPollVO> getPollListUser (String pComapnyID, int pTotal, int pCount, int pStart, int tenantID) throws Exception;
	
	public List<PersonalLightPollVO> getPollResultOrderResult (int pItemSeq, int tenantID) throws Exception;
	
	public List<PersonalLightPollVO> getPollResult (int pItemSeq, int tenantID) throws Exception;
	
	public List<PersonalGetPopUpListUserVO> getPopUpListUser (String pComapnyID, int tenantID) throws Exception;
	
	public List<PersonalGetWebPartGroupVO> getWebPartGroup (String pCompanyID, String pMode, int tenantID) throws Exception;
	
	public List<PersonalGetWebPartVO> getUserWebPart (String pUserID, String pCompanyID, String pACL, int tenantID) throws Exception;
	
	public List<PersonalGetQuickLinkMenuVO> getQuickLinkMenu (String userId, String deptId, String companyId, int tenantID) throws Exception;
	
	public List<PersonalNoticeVO> getNoticeListMain (String companyID, int tenantID) throws Exception;
	
	public List<PersonalNoticeVO> getNoticeListUser (String companyID, int pTotal, int pCount, int pStart, int tenantID) throws Exception;
	
	public PersonalGetEmpOfMonthVO getEmpOfMonth (String pTerm, LoginVO userInfo) throws Exception;
	
	public PersonalLightPollVO getCurrentPoll (String pUserID, String pCompanyID, int tenantID) throws Exception;
	
	public PersonalLightPollVO getPollInfo (int pItemSeq, int tenantID) throws Exception;
	
	public String setApprovalPwd(String userID, String flag, String newPWD, String pwdType, int tenantID, String companyID) throws Exception;

	public String getApprovNotiConfig(String userID, String currentID, int tenantID) throws Exception;

	public String setApprovNotiMail(String userID, String alert, String complete, String bansong, String callBack, String hesong, String saveMailFlag, int tenantID) throws Exception;
	
	public List<OrganUserVO> getBirthUserList(String companyId, int tenantId, int month, String lang) throws Exception;
	
	public int getPollCount (String pComapnyID, int tenantID) throws Exception;
	
	public void insertResult (int pItemSeq, String pUserID, int pResult, int tenantID) throws Exception;
	
	public int checkPassword (String pCN, String pPassword, int tenantID) throws Exception;
	
	public String getShareApprovalList (String userID, String lang, String offset, String companyID, int tenantID) throws Exception;
	
	public String insertShareApproval (String userID, String shareUserID, String shareUserDeptID, String companyID, int tenantID) throws Exception;
	
	public String deleteShareApproval (String userID, String shareUserID, String companyID, int tenantID) throws Exception;
	
	public String getCheckDuplShareUser (String userID, String shareUserID, String companyID, int tenantID) throws Exception;
	
}
