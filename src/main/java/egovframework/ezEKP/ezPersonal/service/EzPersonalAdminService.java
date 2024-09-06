package egovframework.ezEKP.ezPersonal.service;

import java.util.List;

import org.json.simple.JSONArray;
import org.w3c.dom.Document;

import egovframework.ezEKP.ezPersonal.vo.PersonalEmpMonthVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalLightPollConfigVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalLightPollVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalNoticeVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalPopopConfigVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalPopupUserVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalPopupVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalQuickLinkVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalSliderImageVO;
import egovframework.let.user.login.vo.LoginVO;

public interface EzPersonalAdminService {

	List<PersonalNoticeVO> getNoticeList(String companyID, int totalCount, int pageSize, int pStart, int tenantID) throws Exception;
	
	List<PersonalLightPollVO> getPollList(String companyID, int totalCount, int pageSize, int start, int tenantID) throws Exception;
	
	List<PersonalPopupVO> getPopupList(String companyID, int totalCount, int pageSize, int start, int tenantID) throws Exception;
	
	List<PersonalEmpMonthVO> getEmpMonth(String year, String companyID, int tenantID) throws Exception;
	
	List<PersonalLightPollVO> getPollResult(String itemSeq, int tenantID) throws Exception;
	
	PersonalNoticeVO getNoticeInfo(String itemSeq, int tenantID) throws Exception;
	
	PersonalPopupVO getPopupInfo(String itemSeq, int tenantID) throws Exception;
	
	PersonalLightPollVO getPollInfo(String itemSeq, int tenantID) throws Exception;
	
	String deleteNotice(String itemSeq, int tenantID) throws Exception;
	
	String insertNotice(String companyID, String title, String title2, String content, int tenantID) throws Exception;
	
	String updateNotice(String companyID, String title, String title2, String content, Integer itemSeq, int tenantID) throws Exception;
	
	List<PersonalQuickLinkVO> getQuickLinkList(LoginVO loginVO, String lang, String userLang, String companyID) throws Exception;
	
	PersonalQuickLinkVO getQuickLink(String quickLinkID, int tenantID) throws Exception;
	
	String getQuickLinkACL(String quickLinkID, int tenantID) throws Exception;
	
	String insertPoll(Document doc, String offset, int tenantID) throws Exception;
	
	String deletePoll(String itemSeq, int tenantID) throws Exception;
	
	List<PersonalSliderImageVO> getSlider(String sliderID, LoginVO userInfo) throws Exception;
	
	String statusChangeSlider1(String sliderID, String isUse, String mode, int tenantID) throws Exception;

	String statusChangeSlider2(String aRuleID, String aPriority, String bRuleID, String bPriority, String mode, int tenantID) throws Exception;
	
	int getNoticeCount(String companyID, int tenantID) throws Exception;
	
	int getNoticeCountUser(String companyID, int tenantID) throws Exception;

	int getPollCount(String companyID, int tenantID) throws Exception;

	void saveQuickLink(LoginVO userInfo, Document doc) throws Exception;

	int insertPopup(PersonalPopupVO vo, int tenantID, String offset) throws Exception;

	void updatePopup(PersonalPopupVO vo, int tenantID, String offset) throws Exception;	

	void deletePopup(String itemSeq, int tenantID) throws Exception;

	void setEmpMonth(String type, String userID, String deptID, String term, String companyID, int tenantID, String jobName) throws Exception;

	void setSliderImage(String sliderID, String displayName, String displayName2, String sliderPath, String fileName, String mode, LoginVO userInfo, String url, String isUse) throws Exception;

	void deleteSlider(String sliderID, int tenantID) throws Exception;

	void delQuickLink(String quickLinkID, int tenantID) throws Exception;

	PersonalLightPollConfigVO getLightPollConfig(String userId, int tenantId) throws Exception;

	void setLightPollConfig(String userId, String isPreview, int tenantId) throws Exception;

	PersonalPopopConfigVO getPopupConfig(String userId, int tenantId) throws Exception;

	String setPopupConfig(String userId, String isPreview, int tenantId) throws Exception;

	int getPopupCount(String companyID, int tenantID) throws Exception;

	String setPopupUse(String companyID, int tenantID, String itemSeq, String inUse);

	void updateQuickLinkOrder(JSONArray linkOrderList, int tenantId) throws Exception;

	void updateSliderImageOrder(JSONArray sliderImageList, int tenantId) throws Exception;

	String updatePoll(Document doc, String offset, int tenantID) throws Exception;

	String checkJoinPoll(String userId, int tenantID, String itemSeq) throws Exception;
	
	void updatePopupUser(List<PersonalPopupUserVO> userList, int tenantId, String companyId, int itemSeq) throws Exception;
	
	List<PersonalPopupUserVO> getPopupUserList (int itemSeq, int tenantId, String companyId, String lang) throws Exception;
}