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
	public List<PersonalQuickLinkVO> getQuickLinkACL(Map<String, Object> map) throws Exception {
		return (List<PersonalQuickLinkVO>) list("EzPersonalAdmin.EZSP_GETQUICKLINK_ACL", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<PersonalLightPollVO> getPollList(Map<String, Object> map) throws Exception {
		return (List<PersonalLightPollVO>) list("EzPersonalAdmin.EZSP_GETPOLLLIST", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<PersonalPopupVO> getPopupList(Map<String, Object> map) throws Exception {
		return (List<PersonalPopupVO>) list("EzPersonalAdmin.EZSP_GETPOPUPLIST", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<PersonalEmpMonthVO> getEmployeeMonth(Map<String, Object> map) {
		return (List<PersonalEmpMonthVO>) list("EzPersonalAdmin.EZSP_GETEMPLOYEEMONTH", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<PersonalSliderImageVO> getSliderList(Map<String, Object> map) throws Exception {
		return (List<PersonalSliderImageVO>) list("EzPersonalAdmin.EZSP_GETSLIDERLIST", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<PersonalLightPollVO> getPollResult(Map<String, Object> map) throws Exception {
		return (List<PersonalLightPollVO>) list("EzPersonalAdmin.EZSP_GETPOLLRESULT", map);
	}
	
	public PersonalNoticeVO getNoticeInfo(Map<String, Object> map) throws Exception {
		return (PersonalNoticeVO) select("EzPersonalAdmin.EZSP_GETNOTICEINFO", map);
	}
	
	public PersonalQuickLinkVO getQuickLink(Map<String, Object> map) throws Exception {
		return (PersonalQuickLinkVO) select("EzPersonalAdmin.EZSP_GETQUICKLINK", map);
	}
	
	public PersonalLightPollVO getPollInfo(Map<String, Object> map) throws Exception {
		return (PersonalLightPollVO) select("EzPersonalAdmin.EZSP_GETPOLLINFO", map);
	}
	
	public PersonalPopupVO getPopupInfo(Map<String, Object> map) throws Exception {
		return (PersonalPopupVO) select("EzPersonalAdmin.EZSP_GETPOPUPINFO", map);
	}

	public int getNoticeCount(Map<String, Object> map) throws Exception {
		return (int)select("EzPersonalAdmin.EZSP_GETNOTICECOUNT", map);
	}
	
	public int getPollCount(Map<String, Object> map) throws Exception {
		return (int) select("EzPersonalAdmin.EZSP_GETPOLLCOUNT", map);
	}
	
	public int setSliderImage_S(Map<String, Object> map) throws Exception {
		return (int) select("EzPersonalAdmin.EZSP_SETSLIDERIMAGE_S", map);
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
	
	public void setQuickLinkItem_I(Map<String, Object> map) throws Exception {
		insert("EzPersonalAdmin.EZSP_SETQUICKLINKITEM_I", map);
	}
	
	public void setQuickLink_I(Map<String, Object> map) throws Exception {
		insert("EzPersonalAdmin.EZSP_SETQUICKLINK_ACL_I", map);
	}
	
	public void insertPoll_I1(Map<String, Object> map) throws Exception {
		insert("EzPersonalAdmin.EZSP_INSERTPOLL_I1", map);
	}
	
	public void insertPoll_I2(Map<String, Object> map) throws Exception {
		insert("EzPersonalAdmin.EZSP_INSERTPOLL_I2", map);
	}
	
	public void setEmployeeMonth_I(Map<String, Object> map) throws Exception {
		insert("EzPersonalAdmin.EZSP_SETEMPLOYEEMONTH_I", map);
	}
	
	public void setSliderImage_I(Map<String, Object> map) throws Exception {
		insert("EzPersonalAdmin.EZSP_SETSLIDERIMAGE_I", map);
	}
	
	public void setSliderImage_U(Map<String, Object> map) throws Exception {
		update("EzPersonalAdmin.EZSP_SETSLIDERIMAGE_U", map);
	}
	
	public void setQuickLinkItem_U(Map<String, Object> map) throws Exception {
		update("EzPersonalAdmin.EZSP_SETQUICKLINKITEM_U", map);
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
	
	public void insertPoll_U1(Map<String, Object> map) throws Exception {
		update("EzPersonalAdmin.EZSP_INSERTPOLL_U1", map);
	}
	
	public void insertPoll_U2(Map<String, Object> map) throws Exception {
		update("EzPersonalAdmin.EZSP_INSERTPOLL_U2", map);
	}

	public void deleteNotice(Map<String, Object> map) throws Exception {
		delete("EzPersonalAdmin.EZSP_DELETENOTICE", map);
	}
	
	public void deletePoll(Map<String, Object> map) throws Exception {
		delete("EzPersonalAdmin.EZSP_DELETEPOLL", map);
	}
	
	public void deletePoll_D(Map<String, Object> map) throws Exception {
		delete("EzPersonalAdmin.EZSP_DELETEPOLL_D", map);
	}

	public void deletePopup(Map<String, Object> map) throws Exception {
		delete("EzPersonalAdmin.EZSP_DELETEPOPUP", map);
	}

	public void delSliderImage(String v_SLIDERID) throws Exception {
		delete("EzPersonalAdmin.EZSP_DELSLIDERIMAGE", v_SLIDERID);
	}
	
	public void deleteQuickLinkID(Map<String, Object> map) throws Exception {
		delete("EzPersonalAdmin.deleteQuickLinkID", map);
	}
	
	public void delQuickLink(Map<String, Object> map) throws Exception {
		delete("EzPersonalAdmin.delQuickLink", map);
	}
	
	public void delQuickLink_D(Map<String, Object> map) throws Exception {
		delete("EzPersonalAdmin.delQuickLink_D", map);
	}
	
	public void setQuickLink_D(Map<String, Object> map) throws Exception {
		delete("EzPersonalAdmin.EZSP_SETQUICKLINK_ACL_D", map);
	}
	
	public void setEmployeeMonth_D(Map<String, Object> map) throws Exception {
		delete("EzPersonalAdmin.EZSP_SETEMPLOYEEMONTH_D", map);
	}
	
}
