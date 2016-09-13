package egovframework.ezEKP.ezPortal.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.ezEKP.ezPortal.vo.PortalDeleteSubPageVO;
import egovframework.ezEKP.ezPortal.vo.PortalTBLSkinGeneralVO;
import egovframework.ezEKP.ezPortal.vo.PortalUseThemeCheckVO;
import egovframework.rte.psl.dataaccess.EgovAbstractDAO;

@Repository("EzPortaAdminDAO")
public class EzPortalAdminDAO extends EgovAbstractDAO {
	@SuppressWarnings("unchecked")
	public List<String> deleteTopPage (String pageUID) {
		return  (List<String>)list("EzPortalAdminDAO.deleteTopPage", pageUID);
	}
	
	@SuppressWarnings("unchecked")
	public List<PortalDeleteSubPageVO> topDeleteSubPage (String pageUID) {
		return  (List<PortalDeleteSubPageVO>)list("EzPortalAdminDAO.topDeleteSubPage", pageUID);
	}
	
	@SuppressWarnings("unchecked")
	public List<PortalTBLSkinGeneralVO> selectSkinGeneral() {
		return (List<PortalTBLSkinGeneralVO>)list("EzPortalAdminDAO.selectSkinGeneral");
	}
	
	@SuppressWarnings("unchecked")
	public List<String> selectTblTopMenuITemsUID (Map<String, Object> map) {
		return (List<String>)list("EzPortalAdminDAO.selectTblTopMenuItemsUID", map);
	}
	
	public PortalUseThemeCheckVO useThemeCheck(String uID) {
		return (PortalUseThemeCheckVO)select("EzPortalAdminDAO.useThemeCheck", uID);
	}
	
	public int saveTopMenu (String uID) {
		return (int)select("EzPortalAdminDAO.saveTopMenu", uID);
	}
	
	public int saveTopMenu2 (String pUID) {
		return (int)select("EzPortalAdminDAO.saveTopMenu2", pUID);
	}
	
	public int saveTopMenu5 (String pUID) {
		return (int)select("EzPortalAdminDAO.saveTopMenu5", pUID);
	}
	
	public int saveTopMenu3 (Map<String, Object> map) {
		return (int)select("EzPortalAdminDAO.saveTopMenu3", map);
	}
	
	public int saveTopMenu4 (Map<String, Object> map) {
		return (int)select("EzPortalAdminDAO.saveTopMenu4", map);
	}
	
	public int saveTopMenu6 (Map<String, Object> map) {
		return (int)select("EzPortalAdminDAO.saveTopMenu6", map);
	}
	
	public void portalSaveSkin (Map<String, Object> map) {
		insert("EzPortalAdminDAO.portalSaveSkin", map);
	}
	
	public void insertTblTopMenuItems (Map<String, Object> map) {
		insert("EzPortalAdminDAO.insertTblTopMenuItems", map);
	}
	
	public void insertTblTopMenuGeneral (Map<String, Object> map) {
		insert("EzPortalAdminDAO.insertTblTopMenuGeneral", map);
	}
	
	public void updateTopMenuGeneral (Map<String, Object> map) {
		update("EzPortalAdminDAO.updateTopMenuGeneral", map);
	}
	
	public void updateTblTopMenuItems (Map<String, Object> map) {
		update("EzPortalAdminDAO.updateTblTopMenuItems", map);
	}
	
	public void deleteTheme (String uID) {
		delete("EzPortalAdminDAO.deleteTheme", uID);
	}
	
	public void deleteTopMenuGeneralUID (String pUID) {
		delete("EzPortalAdminDAO.deleteTopMenuGeneralUID", pUID);
	}
	
	public void deleteTblMenuItemsS (String pUID) {
		delete("EzPortalAdminDAO.deleteTblMenuItemsS", pUID);
	}
	
	public void deleteTblMenuItems (String pUID) {
		delete("EzPortalAdminDAO.deleteTblMenuItems", pUID);
	}
	
	public void deleteTblMenuItemsImage (String pUID) {
		delete("EzPortalAdminDAO.deleteTblMenuItemsImage", pUID);
	}
	
	public void deleteTopMenuItems (String pUID) {
		delete("EzPortalAdminDAO.deleteTopMenuItems", pUID);
	}
	
	public void deleteTopMenuItems2 (Map<String, Object> map) {
		delete("EzPortalAdminDAO.deleteTopMenuItems2", map);
	}
	
	public void deleteTopMenuItems3 (Map<String, Object> map) {
		delete("EzPortalAdminDAO.deleteTopMenuItems3", map);
	}
	
	public void deleteSkinItemsUID (String pUID) {
		delete("EzPortalAdminDAO.deleteSkinItemsUID", pUID);
	}
	
	public void setThemeInfo (Map<String, Object> map) {
		update("EzPortalAdminDAO.setThemeInfo", map);
	}
	
	public void topSetUsePage2 (Map<String, Object> map) {
		update("EzPortalAdminDAO.topSetUsePage2", map);
	}
	
	public void outOfSetUsePage (Map<String, Object> map) {
		update("EzPortalAdminDAO.outOfSetUsePage", map);
	}
	
	public void setUseLang (Map<String, Object> map) {
		update("EzPortalAdminDAO.setUseLang", map);
	}
	
	
}

