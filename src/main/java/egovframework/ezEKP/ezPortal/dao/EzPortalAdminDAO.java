package egovframework.ezEKP.ezPortal.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.ezEKP.ezPortal.vo.PortalDeleteSubPageVO;
import egovframework.ezEKP.ezPortal.vo.PortalLoadLogoItemsVO;
import egovframework.ezEKP.ezPortal.vo.PortalMenuItemItemsImageVO;
import egovframework.ezEKP.ezPortal.vo.PortalPortletGeneralVO;
import egovframework.ezEKP.ezPortal.vo.PortalSearchPortalPage2VO;
import egovframework.ezEKP.ezPortal.vo.PortalSearchPortlet2VO;
import egovframework.ezEKP.ezPortal.vo.PortalTBLBuiltInParametersVO;
import egovframework.ezEKP.ezPortal.vo.PortalTBLPortalPageCategoryVO;
import egovframework.ezEKP.ezPortal.vo.PortalTBLSkinGeneralVO;
import egovframework.ezEKP.ezPortal.vo.PortalTBLTopMenuItemsVO;
import egovframework.ezEKP.ezPortal.vo.PortalUseThemeCheckVO;
import egovframework.rte.psl.dataaccess.EgovAbstractDAO;

@Repository("EzPortaAdminDAO")
public class EzPortalAdminDAO extends EgovAbstractDAO {
	@SuppressWarnings("unchecked")
	public List<String> deleteTopPage (String pageUID) {
		return  (List<String>)list("EzPortalAdminDAO.deleteTopPage", pageUID);
	}
	
	@SuppressWarnings("unchecked")
	public List<String> deletePortalPage (String pUID) {
		return  (List<String>)list("EzPortalAdminDAO.deletePortalPage", pUID);
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
	
	@SuppressWarnings("unchecked")
	public List<String> selectTblPortalPageItemsUID (Map<String, Object> map) {
		return (List<String>)list("EzPortalAdminDAO.selectTblPortalPageItemsUID", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<PortalSearchPortalPage2VO> searchPortalPage2(Map<String, Object> map) {
		return (List<PortalSearchPortalPage2VO>)list("EzPortalDAO.searchPortalPage2", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<PortalTBLPortalPageCategoryVO> getPortletCategory () {
		return (List<PortalTBLPortalPageCategoryVO>) list("EzPortalAdminDAO.getPortletCategory"); 
	}
	
	@SuppressWarnings("unchecked")
	public List<PortalSearchPortlet2VO> searchPortlet2 (Map<String, Object> map) {
		return (List<PortalSearchPortlet2VO>) list("EzPortalAdminDAO.searchPortlet2", map); 
	}
	
	@SuppressWarnings("unchecked")
	public List<PortalTBLBuiltInParametersVO> menuItemEdit () {
		return (List<PortalTBLBuiltInParametersVO>) list("EzPortalAdminDAO.menuItemEdit"); 
	}
	
	@SuppressWarnings("unchecked")
	public List<PortalLoadLogoItemsVO> loadLogoItems (String pPageID) {
		return (List<PortalLoadLogoItemsVO>) list("EzPortalAdminDAO.loadLogoItems", pPageID); 
	}
	
	public PortalUseThemeCheckVO useThemeCheck(String uID) {
		return (PortalUseThemeCheckVO)select("EzPortalAdminDAO.useThemeCheck", uID);
	}
	
	public PortalPortletGeneralVO getPortletProperties (String pUID) {
		return (PortalPortletGeneralVO)select("EzPortalAdminDAO.getPortletProperties", pUID);
	}
	
	public PortalMenuItemItemsImageVO logoEdit (Map<String, Object> map) {
		return (PortalMenuItemItemsImageVO)select("EzPortalAdminDAO.logoEdit", map);
	}
	
	public PortalTBLTopMenuItemsVO loadPositionSettings (Map<String, Object> map) {
		return (PortalTBLTopMenuItemsVO)select("EzPortalAdminDAO.loadPositionSettings", map);
	}
	
	public String getParentPageIDList (String pTemp) {
		return (String)select("EzPortalAdminDAO.getParentPageIDList", pTemp);
	}
	
	public int savePortalPage (String pageID) {
		return (int)select("EzPortalAdminDAO.savePortalPage", pageID);
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
	
	public int savePortalPage7 (String pParentPageID) {
		return (int)select("EzPortalAdminDAO.savePortalPage7", pParentPageID);
	}
	
	public int savePortalPage3 (String pPortletUID) {
		return (int)select("EzPortalAdminDAO.savePortalPage3", pPortletUID);
	}
	
	public int savePortalPage4 (String pPortletPageUID) {
		return (int)select("EzPortalAdminDAO.savePortalPage4", pPortletPageUID);
	}
	
	public int savePortalPage5 (Map<String, Object> map) {
		return (int)select("EzPortalAdminDAO.savePortalPage5", map);
	}
	
	public int savePortalPage6 (Map<String, Object> map) {
		return (int)select("EzPortalAdminDAO.savePortalPage6", map);
	}
	
	public int savePortalPage8 (Map<String, Object> map) {
		return (int)select("EzPortalAdminDAO.savePortalPage8", map);
	}
	
	public int savePortalPage2 (Map<String, Object> map) {
		return (int)select("EzPortalAdminDAO.savePortalPage2", map);
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
	
	public int searchPortalPageCount2 (Map<String, Object> map) {
		return (int)select("EzPortalAdminDAO.searchPortalPageCount2", map);
	}
	
	public int getItemsCount (Map<String, Object> map) {
		select("EzPortalAdminDAO.getItemsCount", map);
		return (int)map.get("v_pCount");
	}
	
	public int searchPortletCount2 (Map<String, Object> map) {
		select("EzPortalAdminDAO.searchPortletCount2", map);
		return (int)map.get("v_pCount");
	}
	
	public void createNewPortlet (Map<String, Object> map) {
		insert("EzPortalAdminDAO.createNewPortlet", map);
	}
	
	public void createNewLogoItem (Map<String, Object> map) {
		insert("EzPortalAdminDAO.createNewLogoItem", map);
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
	
	public void insertTblPortalPageGeneral (Map<String, Object> map) {
		insert("EzPortalAdminDAO.insertTblPortalPageGeneral", map);
	}
	
	public void insertTblPortalPageItems (Map<String, Object> map) {
		insert("EzPortalAdminDAO.insertTblPortalPageItems", map);
	}
	
	public void insertAclItem (Map<String, Object> map) {
		insert("EzPortalAdminDAO.insertAclItem", map);
	}
	
	public void savePortletSubProperty (Map<String, Object> map) {
		insert("EzPortalAdminDAO.savePortletSubProperty", map);
	}
	
	public void savePortletSubProperty2 (Map<String, Object> map) {
		insert("EzPortalAdminDAO.savePortletSubProperty2", map);
	}
	
	public void savePortletSubProperty3 (Map<String, Object> map) {
		insert("EzPortalAdminDAO.savePortletSubProperty3", map);
	}
	
	public void savePortletSubProperty4 (Map<String, Object> map) {
		insert("EzPortalAdminDAO.savePortletSubProperty4", map);
	}
	
	public void savePortletParameters (Map<String, Object> map) {
		insert("EzPortalAdminDAO.savePortletParameters", map);
	}
	
	public void saveMenuItemParameters (Map<String, Object> map) {
		insert("EzPortalAdminDAO.saveMenuItemParameters", map);
	}
	
	public void saveLogoImage (Map<String, Object> map) {
		insert("EzPortalAdminDAO.saveLogoImage", map);
	}
	
	public void updateTopMenuGeneral (Map<String, Object> map) {
		update("EzPortalAdminDAO.updateTopMenuGeneral", map);
	}
	
	public void updatePortalPageGeneral (Map<String, Object> map) {
		update("EzPortalAdminDAO.updatePortalPageGeneral", map);
	}
	
	public void updateTblTopMenuItems (Map<String, Object> map) {
		update("EzPortalAdminDAO.updateTblTopMenuItems", map);
	}
	
	public void updateTblPortalPageItems (Map<String, Object> map) {
		update("EzPortalAdminDAO.updateTblPortalPageItems", map);
	}
	
	public void setUsePage2 (Map<String, Object> map) {
		update("EzPortalAdminDAO.setUsePage2", map);
	}
	
	public void outOfSetUsePage (Map<String, Object> map) {
		update("EzPortalAdminDAO.outOfSetUsePage", map);
	}
	
	public void setDefaultPage (Map<String, Object> map) {
		update("EzPortalAdminDAO.setDefaultPage", map);
	}
	
	public void saveNewPortletProperties (Map<String, Object> map) {
		update("EzPortalAdminDAO.saveNewPortletProperties", map);
	}
	
	public void setThemeInfo (Map<String, Object> map) {
		update("EzPortalAdminDAO.setThemeInfo", map);
	}
	
	public void topSetUsePage2 (Map<String, Object> map) {
		update("EzPortalAdminDAO.topSetUsePage2", map);
	}
	
	public void topOutOfSetUsePage (Map<String, Object> map) {
		update("EzPortalAdminDAO.topOutOfSetUsePage", map);
	}
	
	public void setUseLang (Map<String, Object> map) {
		update("EzPortalAdminDAO.setUseLang", map);
	}
	
	public void savePositionSettings (Map<String, Object> map) {
		update("EzPortalAdminDAO.savePositionSettings", map);
	}
	
	public void deleteTheme (String uID) {
		delete("EzPortalAdminDAO.deleteTheme", uID);
	}
	
	public void deleteTopMenuGeneralUID (String pUID) {
		delete("EzPortalAdminDAO.deleteTopMenuGeneralUID", pUID);
	}
	
	public void deletePortalPageGeneralUID (String pUID) {
		delete("EzPortalAdminDAO.deletePortalPageGeneralUID", pUID);
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
	
	public void deletePortalPageItems (Map<String, Object> map) {
		delete("EzPortalAdminDAO.deletePortalPageItems", map);
	}
	
	public void deleteTopMenuItems3 (Map<String, Object> map) {
		delete("EzPortalAdminDAO.deleteTopMenuItems3", map);
	}
	
	public void deleteAclItem (Map<String, Object> map) {
		delete("EzPortalAdminDAO.deleteAclItem", map);
	}
	
	public void deleteSkinItemsUID (String pUID) {
		delete("EzPortalAdminDAO.deleteSkinItemsUID", pUID);
	}
	
	public void deletePortalPageCache (String pPageID) {
		delete("EzPortalAdminDAO.deletePortalPageCache", pPageID);
	}
	
	public void deletePortalPage2 (String pUID) {
		delete("EzPortalAdminDAO.deletePortalPage2", pUID);
	}
	
	public void deletePortalPage3 (String pUID) {
		delete("EzPortalAdminDAO.deletePortalPage3", pUID);
	}
	
	public void removeParameter (Map<String, Object> map) {
		delete("EzPortalAdminDAO.removeParameter", map);
	}
	
	public void deletePortlet (String pUID) {
		delete("EzPortalAdminDAO.deletePortlet", pUID);
	}
	
	public void saveLogoImage2 (Map<String, Object> map) {
		delete("EzPortalAdminDAO.saveLogoImage2", map);
	}
	
	
	
	
	
}

