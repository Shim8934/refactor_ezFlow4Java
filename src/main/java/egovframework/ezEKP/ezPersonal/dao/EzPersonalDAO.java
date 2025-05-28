package egovframework.ezEKP.ezPersonal.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.ezEKP.ezPersonal.type.NotiPlatform;
import egovframework.ezEKP.ezPersonal.type.NotiType;
import egovframework.ezEKP.ezPersonal.vo.PersonalApprovMailVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalGetEmpOfMonthVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalGetPopUpListUserVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalGetQuickLinkMenuVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalGetWebPartGroupVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalGetWebPartVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalLightPollVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalNotiDisableItemVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalNoticeVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalShareApprovalVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalSliderImageVO;
import org.egovframe.rte.psl.dataaccess.EgovAbstractDAO;

@Repository("EzPersonalDAO")
public class EzPersonalDAO extends EgovAbstractDAO {
	
	@SuppressWarnings("unchecked")
	public List<PersonalSliderImageVO> getSilderList (Map<String, Object> map) {
		return (List<PersonalSliderImageVO>) list("EzPersonalDAO.getSliderList", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<PersonalApprovMailVO> getApprovNotiConfig(Map<String, Object> map) throws Exception{
		return (List<PersonalApprovMailVO>) list("EzPersonalDAO.getApprovNotiConfig", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<PersonalApprovMailVO> getApprovNotiConfig_S2(Map<String, Object> map) throws Exception{
		return (List<PersonalApprovMailVO>) list("EzPersonalDAO.getApprovNotiConfig_S2", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<PersonalApprovMailVO> getApprovNotiConfig_S3(Map<String, Object> map) throws Exception{
		return (List<PersonalApprovMailVO>) list("EzPersonalDAO.getApprovNotiConfig_S3", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<PersonalApprovMailVO> getApprovNotiConfig_S4(Map<String, Object> map) throws Exception{
		return (List<PersonalApprovMailVO>) list("EzPersonalDAO.getApprovNotiConfig_S4", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<PersonalLightPollVO> getPollListUser(Map<String, Object> map) throws Exception{
		return (List<PersonalLightPollVO>) list("EzPersonalDAO.getPollListUser", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<PersonalLightPollVO> getPollResultOrderResult (Map<String, Object> map) {
		return (List<PersonalLightPollVO>) list("EzPersonalDAO.getPollResultOrderResult", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<PersonalLightPollVO> getPollResult (Map<String, Object> map) {
		return (List<PersonalLightPollVO>) list("EzPersonalDAO.getPollResult", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<PersonalGetPopUpListUserVO> getPopUpListUser (Map<String, Object> map) {
		return (List<PersonalGetPopUpListUserVO>) list("EzPersonalDAO.getPopUpListUser", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<PersonalGetWebPartGroupVO> getWebPartGroup (Map<String, Object> map) {
		return (List<PersonalGetWebPartGroupVO>) list("EzPersonalDAO.getWebPartGroup", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<PersonalGetWebPartVO> getUserWebPart_S2 (Map<String, Object> map) {
		return (List<PersonalGetWebPartVO>) list("EzPersonalDAO.getUserWebPart_S2", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<PersonalGetWebPartVO> getUserWebPart_S3 (Map<String, Object> map) {
		return (List<PersonalGetWebPartVO>) list("EzPersonalDAO.getUserWebPart_S3", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<PersonalGetQuickLinkMenuVO> getQuickLinkMenu (Map<String, Object> map) {
		return (List<PersonalGetQuickLinkMenuVO>) list("EzPersonalDAO.getQuickLinkMenu", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<PersonalNoticeVO> getNoticeListMain (Map<String, Object> map) {
		return (List<PersonalNoticeVO>) list("EzPersonalDAO.getNoticeListMain", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<PersonalNoticeVO> getNoticeListUser (Map<String, Object> map) {
		return (List<PersonalNoticeVO>) list("EzPersonalDAO.getNoticeListUser", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<PersonalShareApprovalVO> getShareApprovalList (Map<String, Object> map) throws Exception {
		return (List<PersonalShareApprovalVO>) list("EzPersonalDAO.getShareApprovalList", map);
	}
	
	public PersonalGetEmpOfMonthVO getEmpOfMonth (Map<String, Object> map) {
		return (PersonalGetEmpOfMonthVO) select("EzPersonalDAO.getEmpOfMonth", map);
	}
	
	public PersonalLightPollVO getCurrentPoll (Map<String, Object> map) {
		return (PersonalLightPollVO) select("EzPersonalDAO.getCurrentPoll", map);
	}
	
	public PersonalLightPollVO getPollInfo (Map<String, Object> map) {
		return (PersonalLightPollVO) select("EzPersonalDAO.getPollInfo", map);
	}
		
    private String getPasswordForLocal (String cn, int tenantID) {
    	Map<String, Object> map = new HashMap<String, Object>();
    	map.put("cn", cn);
    	map.put("tenantID", tenantID);
        return (String) select("EzPersonalDAO.getPassword", map);
    }
    
    public String getApprovNotiConfig_S1 (Map<String, Object> map) {
        return (String) select("EzPersonalDAO.getApprovNotiConfig_S1", map);
    }
    
    public String setApprovalPwd_S (Map<String, Object> map) {
        return (String) select("EzPersonalDAO.setApprovalPwd_S", map);
    }
    
    public String setApprovNotiMail_S (Map<String, Object> map) {
        return (String) select("EzPersonalDAO.setApprovNotiMail_S", map);
    }
    
    public String insertResult_S (Map<String, Object> map) {
        return (String) select("EzPersonalDAO.insertResult_S", map);
    }
    
    public String getUserWebPart_S1 (Map<String, Object> map) {
        return (String) select("EzPersonalDAO.getUserWebPart_S1", map);
    }
    
	public String getPassword (String cn, int tenantID) throws Exception {
		return getPasswordForLocal(cn, tenantID);       
	}
	
	public int getPollCount(Map<String, Object> map) {
		return (int) select("EzPersonalDAO.getPollCount", map);
	}
	
	public int getCheckDuplShareUser(Map<String, Object> map) throws Exception{
		return (int) select("EzPersonalDAO.getCheckDuplShareUser", map);
	}
	
	public void setApprovalPwd(Map<String, Object> map) throws Exception{
		insert("EzPersonalDAO.setApprovalPwd", map);
	}

	public void setApprovNotiMail(Map<String, Object> map) throws Exception{
		insert("EzPersonalDAO.setApprovNotiMail", map);
	}
	
	public void insertResult(Map<String, Object> map) throws Exception{
		insert("EzPersonalDAO.insertResult", map);
	}
	
	public void setApprovalPwd_I(Map<String, Object> map) throws Exception{
		insert("EzPersonalDAO.setApprovalPwd_I", map);
	}
	
	public void setApprovNotiMail_I(Map<String, Object> map) throws Exception{
		insert("EzPersonalDAO.setApprovNotiMail_I", map);
	}
	
	public void insertShareApproval(Map<String, Object> map) throws Exception {
		insert("EzPersonalDAO.insertShareApproval", map);
	}
	
	public void setApprovalPwd_U(Map<String, Object> map) throws Exception{
		update("EzPersonalDAO.setApprovalPwd_U", map);
	}
	
	public void setApprovalPwd_L(Map<String, Object> map) throws Exception{
		update("EzPersonalDAO.setApprovalPwd_L", map);
	}
	
	public void setApprovNotiMail_U(Map<String, Object> map) throws Exception{
		update("EzPersonalDAO.setApprovNotiMail_U", map);
	}
	
	public void deleteShareApproval(Map<String, Object> map) throws Exception {
		delete("EzPersonalDAO.deleteShareApproval", map);
	}

	public boolean getPopupPermitYN(Map<String, Object> map) throws Exception {
		int permit = (int) select("EzPersonalDAO.getpopupPermitYN", map);
		
		if (permit > 0) {
			return true;
		} else {
			permit = (int) select("EzPersonalDAO.getpopupPermitSubDeptYN", map);
			
			if (permit > 0) {
				return true;
			}
		}
		
		return false;
	}
	
	@SuppressWarnings("unchecked")
	public List<String> getPopupUserGroupList(Map<String, Object> map) throws Exception {
		return (List<String>) list("EzPersonalDAO.getPopupUserGroupList", map);
	}

	@SuppressWarnings("unchecked")
	public List<PersonalNotiDisableItemVO> getAllNotiDisableItem(String userId, int tenantId) {
		Map<String, Object> parameter = new HashMap<>();
		parameter.put("userId", userId);
		parameter.put("tenantId", tenantId);

		return (List<PersonalNotiDisableItemVO>) list("EzPersonalDAO.getAllNotiDisableItem", parameter);
	}

	public PersonalNotiDisableItemVO findNotiDisableItem(String userId, NotiType type, NotiPlatform platform, int tenantId) {
		Map<String, Object> parameter = new HashMap<>();
		parameter.put("userId", userId);
		parameter.put("mainType", type.mainType());
		parameter.put("subType", type.subType());
		parameter.put("platform", platform.intValue());
		parameter.put("tenantId", tenantId);

		return (PersonalNotiDisableItemVO) select("EzPersonalDAO.findNotiDisableItem", parameter);
	}

	public void clearNotiDisableItems(String userId, int tenantId) {
		Map<String, Object> parameter = new HashMap<>();
		parameter.put("userId", userId);
		parameter.put("tenantId", tenantId);

		delete("EzPersonalDAO.clearNotiDisableItems", parameter);
	}

	public void insertNotiDisableItems(String userId, int tenantId, List<PersonalNotiDisableItemVO> items) {
		Map<String, Object> parameter = new HashMap<>();
		parameter.put("userId", userId);
		parameter.put("tenantId", tenantId);
		parameter.put("items", items);

		insert("EzPersonalDAO.insertNotiDisableItems", parameter);
	}

}
