package egovframework.ezEKP.ezPersonal.service;

import java.util.List;

import org.w3c.dom.Document;

import egovframework.ezEKP.ezPersonal.vo.PersonalEmpMonthVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalLightPollVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalNoticeVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalPopupVO;
import egovframework.let.user.login.vo.LoginVO;

public interface EzPersonalAdminService {

	List<PersonalNoticeVO> getNoticeList(String companyID, int totalCount, int pageSize, int pStart) throws Exception;
	
	List<PersonalLightPollVO> getPollList(String companyID, int totalCount, int pageSize, int start) throws Exception;
	
	List<PersonalPopupVO> getPopupList(String companyID) throws Exception;
	
	List<PersonalEmpMonthVO> getEmpMonth(String companyID) throws Exception;
	
	List<PersonalLightPollVO> getPollResult(String itemSeq) throws Exception;
	
	PersonalNoticeVO getNoticeInfo(String itemSeq, int tenantID) throws Exception;
	
	PersonalPopupVO getPopupInfo(String itemSeq) throws Exception;
	
	PersonalLightPollVO getPollInfo(String itemSeq) throws Exception;
	
	String deleteNotice(String itemSeq) throws Exception;
	
	String insertNotice(String companyID, String title, String title2, String content) throws Exception;
	
	String updateNotice(String companyID, String title, String title2, String content, Integer itemSeq) throws Exception;
	
	String getQuickLinkList() throws Exception;
	
	String getQuickLink(String quickLinkID) throws Exception;
	
	String getQuickLinkACL(String quickLinkID) throws Exception;
	
	String insertPoll(Document doc) throws Exception;
	
	String deletePoll(String itemSeq) throws Exception;
	
	String getSlider(String sliderID, LoginVO userInfo) throws Exception;
	
	String statusChangeSlider1(String sliderID, String isUse, String mode) throws Exception;

	String statusChangeSlider2(String aRuleID, String aPriority, String bRuleID, String bPriority, String mode) throws Exception;
	
	int getNoticeCount(String companyID) throws Exception;

	int getPollCount(String companyID) throws Exception;

	void saveQuickLink(LoginVO userInfo, Document doc) throws Exception;

	void insertPopup(PersonalPopupVO vo) throws Exception;

	void updatePopup(PersonalPopupVO vo) throws Exception;	

	void deletePopup(String itemSeq) throws Exception;

	void setEmpMonth(String type, String userID, String deptID, String term, int tenantID) throws Exception;

	void setSliderImage(String sliderID, String displayName, String displayName2, String sliderPath, String fileName, String mode, LoginVO userInfo) throws Exception;

	void deleteSlider(String sliderID) throws Exception;

	void delQuickLink(String quickLinkID) throws Exception;

	

	

	

	

}
