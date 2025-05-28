package egovframework.ezEKP.ezPersonal.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.ezEKP.ezPersonal.vo.PersonalEmpMonthVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalLightPollConfigVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalLightPollVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalNoticeVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalPopopConfigVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalPopupUserVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalPopupVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalQuickLinkVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalSliderImageVO;
import org.egovframe.rte.psl.dataaccess.EgovAbstractDAO;

@Repository("EzPersonalAdminDAO")
public class EzPersonalAdminDAO extends EgovAbstractDAO {
	@SuppressWarnings("unchecked")
	public List<PersonalNoticeVO> getNoticeList(Map<String, Object> map) throws Exception {
		return (List<PersonalNoticeVO>) list("EzPersonalAdmin.EZSP_GETNOTICELIST", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<PersonalQuickLinkVO> getQuickLinkList(Map<String, Object> map) throws Exception {
		return (List<PersonalQuickLinkVO>) list("EzPersonalAdmin.EZSP_GETQUICKLINKLIST", map);
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
	
	@SuppressWarnings("unchecked")
	public List<PersonalSliderImageVO> delSliderImage_S(Map<String, Object> map) throws Exception {
		return (List<PersonalSliderImageVO>) list("EzPersonalAdmin.EZSP_DELSLIDERIMAGE_S", map);
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
	
	public int insertPopup(Map<String, Object> map) throws Exception {
		return (int) insert("EzPersonalAdmin.EZSP_INSERTPOPUP", map);
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
	
	public void delSliderImage_U(Map<String, Object> map) throws Exception {
		update("EzPersonalAdmin.EZSP_DELSLIDERIMAGE_U", map);
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

	public void delSliderImage() throws Exception {
		update("EzPersonalAdmin.EZSP_DELSLIDERIMAGE");
	}
	
	public void delSliderImage_D(Map<String, Object> map) throws Exception {
		delete("EzPersonalAdmin.EZSP_DELSLIDERIMAGE_D", map);
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
	
	public PersonalLightPollConfigVO getLightPollConfig(Map<String, Object> map) throws Exception {
		return (PersonalLightPollConfigVO) select("EzPersonalAdmin.EZSP_getLightPollConfig", map);
	}
	
	public void insertLightPollConfig(Map<String, Object> map) throws Exception {
		insert("EzPersonalAdmin.EZSP_insertLightPollConfig", map);
	}
	
	public void setLightPollConfig(Map<String, Object> map) throws Exception {
		update("EzPersonalAdmin.EZSP_setLightPollConfig", map);
	}
	
	public PersonalPopopConfigVO getPopupConfig(Map<String, Object> map) throws Exception {
		return (PersonalPopopConfigVO) select("EzPersonalAdmin.EZSP_getPopupConfig", map);
	}
	
	public void insertPopupConfig(Map<String, Object> map) throws Exception {
		insert("EzPersonalAdmin.EZSP_insertPopupConfig", map);
	}
	
	public void setPopupConfig(Map<String, Object> map) throws Exception {
		update("EzPersonalAdmin.EZSP_setPopupConfig", map);
	}
	
	public int getPopupCount(Map<String, Object> map) throws Exception {
		return (int) select("EzPersonalAdmin.EZSP_GETPOPUPCOUNT", map);
	}
	
	public void setPopupUse(Map<String, Object> map) throws Exception {
		update("EzPersonalAdmin.EZSP_SETPOPUPUSE", map);
	}

	public void updateQuickLinkOrder(Map<String, Object> map) {
		update("EzPersonalAdmin.EZSP_SETQUICKLINKITEM_ORDER", map);
	}

	public int getQuickLinkMaxOrder(Map<String, Object> map) {
		return (int)select("EzPersonalAdmin.EZSP_GETQUICKLINKMAXORDER", map);
	}
	

	public void updateSliderImageOrder(Map<String, Object> map) {
		update("EzPersonalAdmin.EZSP_SETSLIDERIMAGEITEM_ORDER", map);
	}

	public void updatePoll_U1(Map<String, Object> map) {
		update("EzPersonalAdmin.EZSP_UPDATEPOLL_U1", map);
	}
	
	public void updatePoll_U2(Map<String, Object> map) {
		update("EzPersonalAdmin.EZSP_UPDATEPOLL_U2", map);
	}

	public void updatePoll_Result(Map<String, Object> map) {
		delete("EzPersonalAdmin.EZSP_UPDATE_RESULT", map);
	}

	public int checkJoinPoll(Map<String, Object> map) {
		return (int) select("EzPersonalAdmin.EZSP_CheckJoinPoll", map);
	}
	
	public void updatePopupUser(Map<String, Object> map) throws Exception {
		update("EzPersonalAdmin.updatePopupUser", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<PersonalPopupUserVO> getPopupUserList (Map<String, Object> map) throws Exception {
		return (List<PersonalPopupUserVO>) list("EzPersonalAdmin.getPopupUserList", map);
	}
	
	public void deletePopupUser(Map<String, Object> map) throws Exception {
		delete("EzPersonalAdmin.deletePopupUser", map);
	}
}
