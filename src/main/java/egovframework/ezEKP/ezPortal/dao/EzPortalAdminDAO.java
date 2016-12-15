package egovframework.ezEKP.ezPortal.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.ezEKP.ezPortal.vo.PortalDeleteSubPageVO;
import egovframework.ezEKP.ezPortal.vo.PortalGetPortletParametersVO;
import egovframework.ezEKP.ezPortal.vo.PortalLoadLogoItemsVO;
import egovframework.ezEKP.ezPortal.vo.PortalMenuItemItemsImageVO;
import egovframework.ezEKP.ezPortal.vo.PortalMenuItemItemsMenuItemsSVO;
import egovframework.ezEKP.ezPortal.vo.PortalMenuItemItemsMenuItemsVO;
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
	public List<String> deleteTopPage (Map<String, Object> map) {
		return  (List<String>)list("EzPortalAdminDAO.deleteTopPage", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<String> deletePortalPage (Map<String, Object> map) {
		return  (List<String>)list("EzPortalAdminDAO.deletePortalPage", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<PortalDeleteSubPageVO> topDeleteSubPage (Map<String, Object> map) {
		return  (List<PortalDeleteSubPageVO>)list("EzPortalAdminDAO.topDeleteSubPage", map);
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
		return (List<PortalSearchPortalPage2VO>)list("EzPortalAdminDAO.searchPortalPage2", map);
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
	public List<PortalTBLBuiltInParametersVO> subMenuItemEdit1 () {
		return (List<PortalTBLBuiltInParametersVO>) list("EzPortalAdminDAO.subMenuItemEdit1"); 
	}
	
	@SuppressWarnings("unchecked")
	public List<PortalLoadLogoItemsVO> loadLogoItems (Map<String, Object> map) {
		return (List<PortalLoadLogoItemsVO>) list("EzPortalAdminDAO.loadLogoItems", map); 
	}
	
	@SuppressWarnings("unchecked")
	public List<PortalMenuItemItemsMenuItemsVO> loadMenuItems (Map<String, Object> map) {
		return (List<PortalMenuItemItemsMenuItemsVO>) list("EzPortalAdminDAO.loadMenuItems", map); 
	}
	
	@SuppressWarnings("unchecked")
	public List<PortalMenuItemItemsMenuItemsSVO> loadSubMenuItems (Map<String, Object> map) {
		return (List<PortalMenuItemItemsMenuItemsSVO>) list("EzPortalAdminDAO.loadSubMenuItems", map); 
	}
	
	@SuppressWarnings("unchecked")
	public List<PortalGetPortletParametersVO> getMenuItemParameters (Map<String, Object> map) {
		return (List<PortalGetPortletParametersVO>) list("EzPortalAdminDAO.getMenuItemParameters", map); 
	}
	
	@SuppressWarnings("unchecked")
	public List<PortalTBLTopMenuItemsVO> loadPositionSettings (Map<String, Object> map) {
		return (List<PortalTBLTopMenuItemsVO>)list("EzPortalAdminDAO.loadPositionSettings", map);
	}
	
	public PortalUseThemeCheckVO useThemeCheck(Map<String, Object> map) {
		return (PortalUseThemeCheckVO)select("EzPortalAdminDAO.useThemeCheck", map);
	}
	
	public PortalPortletGeneralVO getPortletProperties_S2 (String pUID) {
		return (PortalPortletGeneralVO)select("EzPortalAdminDAO.getPortletProperties_S2", pUID);
	}
	
	public PortalMenuItemItemsImageVO logoEdit (Map<String, Object> map) {
		return (PortalMenuItemItemsImageVO)select("EzPortalAdminDAO.logoEdit", map);
	}
	
	public PortalMenuItemItemsMenuItemsVO loadMenuItemConfig (Map<String, Object> map) {
		return (PortalMenuItemItemsMenuItemsVO)select("EzPortalAdminDAO.loadMenuItemConfig", map);
	}
	
	public PortalMenuItemItemsImageVO loadMenuItemConfig2 (Map<String, Object> map) {
		return (PortalMenuItemItemsImageVO)select("EzPortalAdminDAO.loadMenuItemConfig2", map);
	}
	
	public PortalMenuItemItemsMenuItemsSVO loadSubMenuItemConfig (Map<String, Object> map) {
		return (PortalMenuItemItemsMenuItemsSVO)select("EzPortalAdminDAO.loadSubMenuItemConfig", map);
	}
	
	public PortalMenuItemItemsImageVO loadSubMenuItemConfig2 (Map<String, Object> map) {
		return (PortalMenuItemItemsImageVO)select("EzPortalAdminDAO.loadSubMenuItemConfig2", map);
	}
	
	public String getParentPageIDList (Map<String, Object> map) {
		return (String)select("EzPortalAdminDAO.getParentPageIDList", map);
	}
	
	public String savePortletSubProperty_S (Map<String, Object> map) {
		return (String)select("EzPortalAdminDAO.savePortletSubProperty_S", map);
	}
	
	public String savePortletSubProperty4_S (Map<String, Object> map) {
		return (String)select("EzPortalAdminDAO.savePortletSubProperty4_S", map);
	}
	
	public String removeMenuItem_S (Map<String, Object> map) {
		return (String)select("EzPortalAdminDAO.removeMenuItem_S", map);
	}
	
	public String removeSubMenuItem_S (Map<String, Object> map) {
		return (String)select("EzPortalAdminDAO.removeSubMenuItem_S", map);
	}
	
	public String getPortletProperties_S1 (String pUID) {
		return (String)select("EzPortalAdminDAO.getPortletProperties_S1", pUID);
	}
	
	public int savePortalPage (Map<String, Object> map) {
		return (int)select("EzPortalAdminDAO.savePortalPage", map);
	}

	public int saveTopMenu (Map<String, Object> map) {
		return (int)select("EzPortalAdminDAO.saveTopMenu", map);
	}
	
	public int saveTopMenu2 (Map<String, Object> map) {
		return (int)select("EzPortalAdminDAO.saveTopMenu2", map);
	}
	
	public int saveTopMenu5 (Map<String, Object> map) {
		return (int)select("EzPortalAdminDAO.saveTopMenu5", map);
	}
	
	public int savePortalPage7 (Map<String, Object> map) {
		return (int)select("EzPortalAdminDAO.savePortalPage7", map);
	}
	
	public int savePortalPage3 (Map<String, Object> map) {
		select("EzPortalAdminDAO.savePortalPage3", map);
		return (int)map.get("v_pCount");
	}
	
	public int savePortalPage4 (Map<String, Object> map) {
		return (int)select("EzPortalAdminDAO.savePortalPage4", map);
	}
	
	public int savePortalPage5 (Map<String, Object> map) {
		return (int)select("EzPortalAdminDAO.savePortalPage5", map);
	}
	
	public int savePortalPage6 (Map<String, Object> map) {
		return (int)select("EzPortalAdminDAO.savePortalPage6", map);
	}
	
	public int savePortalPage8 (Map<String, Object> map) {
		select("EzPortalAdminDAO.savePortalPage8", map);
		return (int)map.get("v_pCount");
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
		return (int)select("EzPortalAdminDAO.getItemsCount", map);
	}
	
	public int searchPortletCount2 (Map<String, Object> map) {
		return (int)select("EzPortalAdminDAO.searchPortletCount2", map);
	}
	
	public int saveMenuItemConfig_S1 (Map<String, Object> map) {
		return (int)select("EzPortalAdminDAO.saveMenuItemConfig_S1", map);
	}
	
	public void createNewPortlet (Map<String, Object> map) {
		insert("EzPortalAdminDAO.createNewPortlet", map);
	}
	
	public void createNewSubMenuItem (Map<String, Object> map) {
		insert("EzPortalAdminDAO.createNewSubMenuItem", map);
	}
	
	public void createNewLogoItem (Map<String, Object> map) {
		insert("EzPortalAdminDAO.createNewLogoItem", map);
	}
	
	public void createNewLogoItem_I (Map<String, Object> map) {
		insert("EzPortalAdminDAO.createNewLogoItem_I", map);
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
	
	public void saveLogoImage_I (Map<String, Object> map) {
		insert("EzPortalAdminDAO.saveLogoImage_I", map);
	}
	
	public void createNewMenuItem (Map<String, Object> map) {
		insert("EzPortalAdminDAO.createNewMenuItem", map);
	}
	
	public void createNewMenuItem2 (Map<String, Object> map) {
		insert("EzPortalAdminDAO.createNewMenuItem2", map);
	}
	
	public void saveDelPortletInfo (Map<String, Object> map) {
		insert("EzPortalAdminDAO.saveDelPortletInfo", map);
	}
	
	public void saveMenuItemConfig_I1 (Map<String, Object> map) {
		insert("EzPortalAdminDAO.saveMenuItemConfig_I1", map);
	}
	
	public void saveSubMenuItemConfig_I1 (Map<String, Object> map) {
		insert("EzPortalAdminDAO.saveSubMenuItemConfig_I1", map);
	}
	
	public void saveMenuItemConfig_U1 (Map<String, Object> map) {
		update("EzPortalAdminDAO.saveMenuItemConfig_U1", map);
	}
	
	public void saveMenuItemConfig_U2 (Map<String, Object> map) {
		update("EzPortalAdminDAO.saveMenuItemConfig_U2", map);
	}
	
	public void saveMenuItemConfig_U3 (Map<String, Object> map) {
		update("EzPortalAdminDAO.saveMenuItemConfig_U3", map);
	}
	
	public void saveMenuItemConfig_U4 (Map<String, Object> map) {
		update("EzPortalAdminDAO.saveMenuItemConfig_U4", map);
	}
	
	public void saveMenuItemConfig_U5 (Map<String, Object> map) {
		update("EzPortalAdminDAO.saveMenuItemConfig_U5", map);
	}
	
	public void saveMenuItemConfig_U6 (Map<String, Object> map) {
		update("EzPortalAdminDAO.saveMenuItemConfig_U6", map);
	}
	
	public void saveMenuItemConfig_U7 (Map<String, Object> map) {
		update("EzPortalAdminDAO.saveMenuItemConfig_U7", map);
	}
	
	public void saveMenuItemConfig_U8 (Map<String, Object> map) {
		update("EzPortalAdminDAO.saveMenuItemConfig_U8", map);
	}
	
	public void saveMenuItemConfig_U9 (Map<String, Object> map) {
		update("EzPortalAdminDAO.saveMenuItemConfig_U9", map);
	}
	
	public void saveMenuItemConfig_U10 (Map<String, Object> map) {
		update("EzPortalAdminDAO.saveMenuItemConfig_U10", map);
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
	
	public void updateMenuItemSetOrder (Map<String, Object> map) {
		update("EzPortalAdminDAO.updateMenuItemSetOrder", map);
	}
	
	public void saveSubMenuItemConfig_U1 (Map<String, Object> map) {
		update("EzPortalAdminDAO.saveSubMenuItemConfig_U1", map);
	}
	
	public void saveSubMenuItemConfig_U2 (Map<String, Object> map) {
		update("EzPortalAdminDAO.saveSubMenuItemConfig_U2", map);
	}
	
	public void saveSubMenuItemConfig_U3 (Map<String, Object> map) {
		update("EzPortalAdminDAO.saveSubMenuItemConfig_U3", map);
	}
	
	public void saveSubMenuItemConfig_U4 (Map<String, Object> map) {
		update("EzPortalAdminDAO.saveSubMenuItemConfig_U4", map);
	}
	
	public void deleteTheme (Map<String, Object> map) {
		delete("EzPortalAdminDAO.deleteTheme", map);
	}
	
	public void deleteTopMenuGeneralUID (Map<String, Object> map) {
		delete("EzPortalAdminDAO.deleteTopMenuGeneralUID", map);
	}
	
	public void deletePortalPageGeneralUID (Map<String, Object> map) {
		delete("EzPortalAdminDAO.deletePortalPageGeneralUID", map);
	}
	
	public void deleteTblMenuItemsS (Map<String, Object> map) {
		delete("EzPortalAdminDAO.deleteTblMenuItemsS", map);
	}
	
	public void deleteTblMenuItems (Map<String, Object> map) {
		delete("EzPortalAdminDAO.deleteTblMenuItems", map);
	}
	
	public void deleteTblMenuItemsImage (Map<String, Object> map) {
		delete("EzPortalAdminDAO.deleteTblMenuItemsImage", map);
	}
	
	public void deleteTopMenuItems (Map<String, Object> map) {
		delete("EzPortalAdminDAO.deleteTopMenuItems", map);
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
	
	public void deleteSkinItemsUID (Map<String, Object> map) {
		delete("EzPortalAdminDAO.deleteSkinItemsUID", map);
	}
	
	public void deletePortalPageCache (Map<String, Object> map) {
		delete("EzPortalAdminDAO.deletePortalPageCache", map);
	}
	
	public void deletePortalPage2 (Map<String, Object> map) {
		delete("EzPortalAdminDAO.deletePortalPage2", map);
	}
	
	public void deletePortalPage3 (Map<String, Object> map) {
		delete("EzPortalAdminDAO.deletePortalPage3", map);
	}
	
	public void deletePortalPage3_D1 (Map<String, Object> map) {
		delete("EzPortalAdminDAO.deletePortalPage3_D1", map);
	}
	
	public void deletePortalPage3_D2 (Map<String, Object> map) {
		delete("EzPortalAdminDAO.deletePortalPage3_D2", map);
	}
	
	public void deletePortalPage3_D3 (Map<String, Object> map) {
		delete("EzPortalAdminDAO.deletePortalPage3_D3", map);
	}
	
	public void deletePortalPage3_D4 (Map<String, Object> map) {
		delete("EzPortalAdminDAO.deletePortalPage3_D4", map);
	}
	
	public void removeParameter (Map<String, Object> map) {
		delete("EzPortalAdminDAO.removeParameter", map);
	}
	
	public void deletePortlet (Map<String, Object> map) {
		delete("EzPortalAdminDAO.deletePortlet", map);
	}
	
	public void deletePortlet_D1 (Map<String, Object> map) {
		delete("EzPortalAdminDAO.deletePortlet_D1", map);
	}
	
	public void deletePortlet_D2 (Map<String, Object> map) {
		delete("EzPortalAdminDAO.deletePortlet_D2", map);
	}
	
	public void deletePortlet_D3 (Map<String, Object> map) {
		delete("EzPortalAdminDAO.deletePortlet_D3", map);
	}
	
	public void deletePortlet_D4 (Map<String, Object> map) {
		delete("EzPortalAdminDAO.deletePortlet_D4", map);
	}
	
	public void deletePortlet_D5 (Map<String, Object> map) {
		delete("EzPortalAdminDAO.deletePortlet_D5", map);
	}
	
	public void deletePortlet_D6 (Map<String, Object> map) {
		delete("EzPortalAdminDAO.deletePortlet_D6", map);
	}
	
	public void deletePortlet_D7 (Map<String, Object> map) {
		delete("EzPortalAdminDAO.deletePortlet_D7", map);
	}
	
	public void saveLogoImage2 (Map<String, Object> map) {
		delete("EzPortalAdminDAO.saveLogoImage2", map);
	}
	
	public void saveLogoImage2_D1 (Map<String, Object> map) {
		delete("EzPortalAdminDAO.saveLogoImage2_D1", map);
	}
	
	public void saveLogoImage2_D2 (Map<String, Object> map) {
		delete("EzPortalAdminDAO.saveLogoImage2_D2", map);
	}
	
	public void removeSubMenuItem_D1 (Map<String, Object> map) {
		delete("EzPortalAdminDAO.removeSubMenuItem_D1", map);
	}
	
	public void removeSubMenuItem_D2 (Map<String, Object> map) {
		delete("EzPortalAdminDAO.removeSubMenuItem_D2", map);
	}
	
	public void removeSubMenuItem_D3 (Map<String, Object> map) {
		delete("EzPortalAdminDAO.removeSubMenuItem_D3", map);
	}
	
	public void savePortletSubProperty3_D (Map<String, Object> map) {
		delete("EzPortalAdminDAO.savePortletSubProperty3_D", map);
	}
	
	public void savePortletSubProperty_D (Map<String, Object> map) {
		delete("EzPortalAdminDAO.savePortletSubProperty_D", map);
	}
	
	public void savePortletSubProperty4_D (Map<String, Object> map) {
		delete("EzPortalAdminDAO.savePortletSubProperty4_D", map);
	}
	
	public void removeParameter_D (Map<String, Object> map) {
		delete("EzPortalAdminDAO.removeParameter_D", map);
	}
	
	public void saveLogoImage_D1 (Map<String, Object> map) {
		delete("EzPortalAdminDAO.saveLogoImage_D1", map);
	}
	
	public void saveLogoImage_D2 (Map<String, Object> map) {
		delete("EzPortalAdminDAO.saveLogoImage_D2", map);
	}
	
	public void saveMenuItemConfig_D1 (Map<String, Object> map) {
		delete("EzPortalAdminDAO.saveMenuItemConfig_D1", map);
	}
	
	public void removeMenuItem_D1 (Map<String, Object> map) {
		delete("EzPortalAdminDAO.removeMenuItem_D1", map);
	}
	
	public void removeMenuItem_D2 (Map<String, Object> map) {
		delete("EzPortalAdminDAO.removeMenuItem_D2", map);
	}
	
	public void removeMenuItem_D3 (Map<String, Object> map) {
		delete("EzPortalAdminDAO.removeMenuItem_D3", map);
	}
	
}

