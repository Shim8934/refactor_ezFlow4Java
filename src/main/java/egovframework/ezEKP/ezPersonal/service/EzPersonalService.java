package egovframework.ezEKP.ezPersonal.service;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.ui.Model;

import egovframework.ezEKP.ezOrgan.vo.OrganUserVO;
import egovframework.ezEKP.ezPersonal.type.NotiPlatform;
import egovframework.ezEKP.ezPersonal.type.NotiType;
import egovframework.ezEKP.ezPersonal.vo.PersonalGetEmpOfMonthVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalGetPopUpListUserVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalGetQuickLinkMenuVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalGetWebPartGroupVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalGetWebPartVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalLightPollVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalNotiDisableItemVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalNotiPreferencesVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalNoticeVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalSliderImageVO;
import egovframework.let.user.login.vo.LoginVO;

public interface EzPersonalService {
	public List<PersonalSliderImageVO> getSilderList(String companyID, String mode, String sliderID, int tenantID) throws Exception;
	
	public List<PersonalLightPollVO> getPollListUser (String pComapnyID, int pTotal, int pCount, int pStart, int tenantID) throws Exception;
	
	public List<PersonalLightPollVO> getPollResultOrderResult (int pItemSeq, int tenantID) throws Exception;
	
	public List<PersonalLightPollVO> getPollResult (int pItemSeq, int tenantID) throws Exception;
	
	public List<PersonalGetPopUpListUserVO> getPopUpListUser (String pComapnyID, int tenantID, String Offset) throws Exception;
	
	public List<PersonalGetWebPartGroupVO> getWebPartGroup (String pCompanyID, String pMode, int tenantID) throws Exception;
	
	public List<PersonalGetWebPartVO> getUserWebPart (String pUserID, String pCompanyID, String pACL, int tenantID) throws Exception;
	
	public List<PersonalGetQuickLinkMenuVO> getQuickLinkMenu (String accessID, int tenantID) throws Exception;
	
	public List<PersonalNoticeVO> getNoticeListMain (String companyID, int tenantID) throws Exception;
	
	public List<PersonalNoticeVO> getNoticeListUser (String companyID, int pTotal, int pCount, int pStart, int tenantID) throws Exception;
	
	public PersonalGetEmpOfMonthVO getEmpOfMonth (String pTerm, LoginVO userInfo) throws Exception;
	
	public PersonalLightPollVO getCurrentPoll (String pUserID, String pCompanyID, int tenantID, String offset) throws Exception;
	
	public PersonalLightPollVO getPollInfo (int pItemSeq, int tenantID) throws Exception;
	
	public String setApprovalPwd(String userID, String flag, String newPWD, String pwdType, int tenantID, String companyID) throws Exception;

	/** @deprecated 알림환경설정 도입에 의해 사용되지 않음 */
	@Deprecated
	public String getApprovNotiConfig(String userID, String currentID, int tenantID) throws Exception;

	public String setApprovNotiMail(String userID, String alert, String complete, String bansong, String callBack, String hesong, String saveMailFlag, int tenantID, String linePass) throws Exception;
	
	public List<OrganUserVO> getBirthUserList(String companyId, int tenantId, int month, String lang) throws Exception;
	
	public int getPollCount (String pComapnyID, int tenantID) throws Exception;
	
	public void insertResult (int pItemSeq, String pUserID, int pResult, int tenantID) throws Exception;
	
	public int checkPassword (String pCN, String pPassword, int tenantID, String companyID, String npPassword, boolean useCkhPrevPwd) throws Exception;
	
	public String getShareApprovalList (String userID, String lang, String offset, String companyID, int tenantID) throws Exception;
	
	public String insertShareApproval (String userID, String shareUserID, String shareUserDeptID, String companyID, int tenantID) throws Exception;
	
	public String deleteShareApproval (String userID, String shareUserID, String companyID, int tenantID) throws Exception;
	
	public String getCheckDuplShareUser (String userID, String shareUserID, String companyID, int tenantID) throws Exception;

	List<PersonalGetPopUpListUserVO> getPopUpListUserWithAuth(String pComapnyID, int tenantID, String offset, String userId, String deptId) throws Exception;

	public Object saveBujaeUser(String loginCookie, LoginVO userInfo, HttpServletRequest request, HttpServletResponse response, Model model) throws Exception;

	List<PersonalNotiDisableItemVO> getAllNotiDisableItem(String userId, int tenantId);

	List<Integer> getAllPlatformFromNotiDisableItem(String userId, NotiType type, int tenantId);

	boolean hasNotiDiableItem(String userId, NotiType type, NotiPlatform platform, int tenantId);

	void setNotiDisableItems(String userId, int tenantId, List<PersonalNotiDisableItemVO> items);

	PersonalNotiPreferencesVO getNotiPreferences(String userId, int tenantId);

	void setNotiPreferences(String userId, int tenantId, PersonalNotiPreferencesVO vo) throws Exception;

	boolean canReceiveNotification(String userId, int tenantId);

}
