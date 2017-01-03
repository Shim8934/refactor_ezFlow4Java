package egovframework.ezEKP.ezPersonal.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.ezEKP.ezPersonal.vo.PersonalEmpMonthVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalLightPollVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalNoticeVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalPopupVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalQuickLinkVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalSliderImageVO;
import egovframework.rte.psl.dataaccess.EgovAbstractDAO;

@Repository("EzPersonalAdminDAO")
public class EzPersonalAdminDAO extends EgovAbstractDAO{
	@SuppressWarnings("unchecked")
	public List<PersonalNoticeVO> getNoticeList(Map<String, Object> map) throws Exception {
		return (List<PersonalNoticeVO>) list("EzPersonalAdmin.EZSP_GETNOTICELIST", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<PersonalQuickLinkVO> getQuickLinkList() throws Exception {
		return (List<PersonalQuickLinkVO>) list("EzPersonalAdmin.EZSP_GETQUICKLINKLIST");
	}
	
	@SuppressWarnings("unchecked")
	public List<PersonalQuickLinkVO> getQuickLinkACL(String v_QUICKLINKID) throws Exception {
		return (List<PersonalQuickLinkVO>) list("EzPersonalAdmin.EZSP_GETQUICKLINK_ACL", v_QUICKLINKID);
	}
	
	@SuppressWarnings("unchecked")
	public List<PersonalLightPollVO> getPollList(Map<String, Object> map) throws Exception {
		return (List<PersonalLightPollVO>) list("EzPersonalAdmin.EZSP_GETPOLLLIST", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<PersonalPopupVO> getPopupList(String v_pCompnayID) throws Exception {
		return (List<PersonalPopupVO>) list("EzPersonalAdmin.EZSP_GETPOPUPLIST", v_pCompnayID);
	}
	
	@SuppressWarnings("unchecked")
	public List<PersonalEmpMonthVO> getEmployeeMonth(String v_pCompanyID) {
		return (List<PersonalEmpMonthVO>) list("EzPersonalAdmin.EZSP_GETEMPLOYEEMONTH", v_pCompanyID);
	}
	
	@SuppressWarnings("unchecked")
	public List<PersonalSliderImageVO> getSliderList(Map<String, Object> map) throws Exception {
		return (List<PersonalSliderImageVO>) list("EzPersonalAdmin.EZSP_GETSLIDERLIST", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<PersonalLightPollVO> getPollResult(String v_pItemSeq) throws Exception {
		return (List<PersonalLightPollVO>) list("EzPersonalAdmin.EZSP_GETPOLLRESULT", v_pItemSeq);
	}
	
	public PersonalNoticeVO getNoticeInfo(Map<String, Object> map) throws Exception {
		return (PersonalNoticeVO) select("EzPersonalAdmin.EZSP_GETNOTICEINFO", map);
	}
	
	public PersonalQuickLinkVO getQuickLink(String v_QUICKLINKID) throws Exception {
		return (PersonalQuickLinkVO) select("EzPersonalAdmin.EZSP_GETQUICKLINK", v_QUICKLINKID);
	}
	
	public PersonalLightPollVO getPollInfo(String v_pItemSeq) throws Exception {
		return (PersonalLightPollVO) select("EzPersonalAdmin.EZSP_GETPOLLINFO", v_pItemSeq);
	}
	
	public PersonalPopupVO getPopupInfo(String v_pItemSeq) throws Exception {
		return (PersonalPopupVO) select("EzPersonalAdmin.EZSP_GETPOPUPINFO", v_pItemSeq);
	}

	public int getNoticeCount(Map<String, Object> map) throws Exception {
		select("EzPersonalAdmin.EZSP_GETNOTICECOUNT", map);
		return (int) map.get("v_pCount");
	}
	
	public int getPollCount(Map<String, Object> map) throws Exception {
		select("EzPersonalAdmin.EZSP_GETPOLLCOUNT", map);
		return (int) map.get("v_pCount");
	}
	
	public void insertNotice(Map<String, Object> map) throws Exception {
		insert("EzPersonalAdmin.EZSP_INSERTNOTICE", map);
	}
	
	public void setQuickLinkItem(Map<String, Object> map) throws Exception {
		insert("EzPersonalAdmin.EZSP_SETQUICKLINKITEM", map);
	}
	
	public void setQuickLinkACL(Map<String, Object> map) throws Exception {
		insert("EzPersonalAdmin.EZSP_SETQUICKLINK_ACL", map);
	}
	
	public void insertPopup(Map<String, Object> map) throws Exception {
		insert("EzPersonalAdmin.EZSP_INSERTPOPUP", map);
	}
	
	public void insertPoll(Map<String, Object> map) throws Exception {
		insert("EzPersonalAdmin.EZSP_INSERTPOLL", map);
	}
	
	public void setEmployeeMonth(Map<String, Object> map) throws Exception {
		insert("EzPersonalAdmin.EZSP_SETEMPLOYEEMONTH", map);
	}

	public void setSliderImage(Map<String, Object> map) throws Exception {
		insert("EzPersonalAdmin.EZSP_SETSLIDERIMAGE", map);
	}
	
	public void updateNotice(Map<String, Object> map) throws Exception {
		update("EzPersonalAdmin.EZSP_UPDATENOTICE", map);
	}

	public void updatePopup(Map<String, Object> map) throws Exception {
		update("EzPersonalAdmin.EZSP_UPDATEPOPUP", map);
	}
	
	public void statusChangeSlider(Map<String, Object> map) throws Exception {
		update("EzPersonalAdmin.EZSP_STATUSCHANGESLIDER", map);
	}

	public void deleteNotice(String v_pItemSeq) throws Exception {
		delete("EzPersonalAdmin.EZSP_DELETENOTICE", v_pItemSeq);
	}
	
	public void deletePoll(String v_pItemSeq) throws Exception {
		delete("EzPersonalAdmin.EZSP_DELETEPOLL", v_pItemSeq);
	}

	public void deletePopup(String v_pItemSeq) throws Exception {
		delete("EzPersonalAdmin.EZSP_DELETEPOPUP", v_pItemSeq);
	}

	public void delSliderImage(String v_SLIDERID) throws Exception {
		delete("EzPersonalAdmin.EZSP_DELSLIDERIMAGE", v_SLIDERID);
	}
	
	public void deleteQuickLinkID(String quickLinkID) throws Exception {
		delete("EzPersonalAdmin.deleteQuickLinkID", quickLinkID);
	}
	
	public void delQuickLink(String quickLinkID) throws Exception {
		delete("EzPersonalAdmin.delQuickLink", quickLinkID);
	}
	
	
}
