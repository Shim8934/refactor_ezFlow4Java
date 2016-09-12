package egovframework.ezEKP.ezPortal.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.ezEKP.ezPortal.vo.PortalUseThemeCheckVO;
import egovframework.rte.psl.dataaccess.EgovAbstractDAO;

@Repository("EzPortaAdminDAO")
public class EzPortalAdminDAO extends EgovAbstractDAO {
	@SuppressWarnings("unchecked")
	public List<String> deleteTopPage (String pageUID) {
		return  (List<String>)list("EzPortalAdminDAO.deleteTopPage", pageUID);
	}
	
	public PortalUseThemeCheckVO useThemeCheck(String uID) {
		return (PortalUseThemeCheckVO)select("EzPortalAdminDAO.useThemeCheck", uID);
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

