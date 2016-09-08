package egovframework.ezEKP.ezPersonal.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.ezEKP.ezPersonal.vo.PersonalNoticeVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalQuickLinkVO;
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
	
	public PersonalNoticeVO getNoticeInfo(String v_pItemSeq) throws Exception {
		return (PersonalNoticeVO) select("EzPersonalAdmin.EZSP_GETNOTICEINFO", v_pItemSeq);
	}
	
	public PersonalQuickLinkVO getQuickLink(String v_QUICKLINKID) throws Exception {
		return (PersonalQuickLinkVO) select("EzPersonalAdmin.EZSP_GETQUICKLINK", v_QUICKLINKID);
	}

	public Integer getNoticeCount(Map<String, Object> map) throws Exception {
		select("EzPersonalAdmin.EZSP_GETNOTICECOUNT", map);
		return (Integer) map.get("v_pCount");
	}

	public void deleteNotice(String v_pItemSeq) throws Exception {
		delete("EzPersonalAdmin.EZSP_DELETENOTICE", v_pItemSeq);
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

	public void updateNotice(Map<String, Object> map) throws Exception {
		update("EzPersonalAdmin.EZSP_UPDATENOTICE", map);
	}


}
