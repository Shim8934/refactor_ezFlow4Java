package egovframework.ezEKP.ezPortal.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.ezEKP.ezPortal.vo.PortalGetMainMenuHtmlVO;
import egovframework.ezEKP.ezPortal.vo.PortalGetRenderedTopMenuInsertVO;
import egovframework.ezEKP.ezPortal.vo.PortalGetThemeListVO;
import egovframework.ezEKP.ezPortal.vo.PortalMenuItemItemsImageVO;
import egovframework.ezEKP.ezPortal.vo.PortalMenuItemItemsMenuItemsSVO;
import egovframework.ezEKP.ezPortal.vo.PortalMenuItemItemsMenuItemsVO;
import egovframework.ezEKP.ezPortal.vo.PortalTBLPortalPageCategoryVO;
import egovframework.ezEKP.ezPortal.vo.PortalTBLPortalPageGeneralVO;
import egovframework.ezEKP.ezPortal.vo.PortalTBLPortalPageItemsVO;
import egovframework.ezEKP.ezPortal.vo.PortalTBLThemeGeneralVO;
import egovframework.ezEKP.ezPortal.vo.PortalTBLTopMenuGeneralVO;
import egovframework.ezEKP.ezPortal.vo.PortalTBLTopMenuItemsVO;
import egovframework.ezEKP.ezPortal.vo.PortalTBLUserInfoVO;
import egovframework.ezEKP.ezPortal.vo.PortalTopLoadGetParametersVO;
import egovframework.ezEKP.ezPortal.vo.PortalTopSearchTopMenu2VO;
import egovframework.rte.psl.dataaccess.EgovAbstractDAO;

@Repository("EzPortalDAO")
public class EzPortalDAO extends EgovAbstractDAO {
	
	@SuppressWarnings("unchecked")
	public List<PortalTBLTopMenuItemsVO> getTBLTopMenuItems (String strSQL) {
		return (List<PortalTBLTopMenuItemsVO>) list("EzPortalDAO.getTBLTopMenuItems", strSQL);
	}
	
	@SuppressWarnings("unchecked")
	public List<PortalTBLPortalPageItemsVO> getTBLPortalPageItemsT (String strSQL) {
		return (List<PortalTBLPortalPageItemsVO>) list("EzPortalDAO.getTBLPortalPageItemsT", strSQL);
	}
	
	@SuppressWarnings("unchecked")
	public List<PortalTBLPortalPageItemsVO> getTBLPortalPageItemsF (Map<String, Object> map) {
		return (List<PortalTBLPortalPageItemsVO>) list("EzPortalDAO.getTBLPortalPageItemsF", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<PortalTBLPortalPageGeneralVO> searchMyPortalPage2 (Map<String, Object> map) {
		return (List<PortalTBLPortalPageGeneralVO>) list("EzPortalDAO.searchMyPortalPage2", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<PortalTBLTopMenuGeneralVO> topSearchTopMenu3 (Map<String, Object> map) {
		return (List<PortalTBLTopMenuGeneralVO>) list("EzPortalDAO.topSearchTopMenu3", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<PortalTopSearchTopMenu2VO> topSearchTopMenu2 (Map<String, Object> map) {
		return (List<PortalTopSearchTopMenu2VO>) list("EzPortalDAO.topSearchTopMenu2", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<PortalTopLoadGetParametersVO> topLoadGetParameters (Map<String, Object> map) {
		return (List<PortalTopLoadGetParametersVO>) list ("EzPortalDAO.topLoadGetParameters", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<PortalMenuItemItemsMenuItemsVO> getUtilMenuHtml (Map<String, Object> map) {
		return (List<PortalMenuItemItemsMenuItemsVO>) list("EzPortalDAO.getUtilMenuHtml", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<PortalGetMainMenuHtmlVO> getMainMenuHtml (Map<String, Object> map) {
		return (List<PortalGetMainMenuHtmlVO>) list("EzPortalDAO.getMainMenuHtml", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<PortalMenuItemItemsMenuItemsVO> getSubMenuHtml (Map<String, Object> map) {
		return (List<PortalMenuItemItemsMenuItemsVO>) list("EzPortalDAO.getSubMenuHtml", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<PortalMenuItemItemsMenuItemsSVO> getSubMenuHtml2 (Map<String, Object> map) {
		return (List<PortalMenuItemItemsMenuItemsSVO>) list("EzPortalDAO.getSubMenuHtml2", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<PortalGetThemeListVO> getThemeList (Map<String, Object> map) {
		return (List<PortalGetThemeListVO>) list("EzPortalDAO.getThemeList", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<PortalTBLPortalPageCategoryVO> getPortalPageCategory () {
		return (List<PortalTBLPortalPageCategoryVO>) list("EzPortalDAO.getPortalPageCategory"); 
	}
	
	public PortalTBLThemeGeneralVO getThemeInfo (Map<String, Object> map) {
		return (PortalTBLThemeGeneralVO) select("EzPortalDAO.getThemeInfo", map);
	}
	
	public PortalGetRenderedTopMenuInsertVO getRenderedTopMenuInsert (String uID) {
		return (PortalGetRenderedTopMenuInsertVO) select("EzPortalDAO.getRenderedTopMenuInsert", uID);
	}
	
	public PortalGetRenderedTopMenuInsertVO getRenderedPortalPageHtml (Map<String, Object> map) {
		return (PortalGetRenderedTopMenuInsertVO) select("EzPortalDAO.getRenderedPortalPageHtml", map);
	}
	
	public PortalTBLPortalPageGeneralVO getUserInfo5 (Map<String, Object> map) {
		return (PortalTBLPortalPageGeneralVO) select("EzPortalDAO.getUserInfo5", map);
	}
	
	public PortalTBLUserInfoVO topGetUserInfo (Map<String, Object> map) {
		return (PortalTBLUserInfoVO) select("EzPortalDAO.topGetUserInfo", map);
	}
	
	public PortalTBLUserInfoVO topGetUserInfo2 (Map<String, Object> map) {
		return (PortalTBLUserInfoVO) select("EzPortalDAO.topGetUserInfo2", map);
	}
	
	public PortalMenuItemItemsImageVO getImageHtml (Map<String, Object> map) {
		return (PortalMenuItemItemsImageVO) select("EzPortalDAO.getImageHtml", map);
	}
	
	public String getTopMenuConfigItem(Map<String, Object> map) {
		return (String) select("EzPortalDAO.getTopMenuConfigItem", map);
	}
	
	public String getMenuItemConfigItem(Map<String, Object> map) {
		return (String) select("EzPortalDAO.getMenuItemConfigItem", map);
	}
	
	public String checkCacheValue (Map<String, Object> map) {
		return (String) select("EzPortalDAO.checkCacheValue", map);
	}
	
	public String topGetTopParentPageID (Map<String, Object> map) {
		return (String) select("EzPortalDAO.topGetTopParentPageID", map);
	}
	
	public String getTopParentPageID (Map<String, Object> map) {
		return (String) select("EzPortalDAO.getTopParentPageID", map);
	}
	
	public String useStartPageChack (Map<String, Object> map) {
		return (String) select("EzPortalDAO.useStartPageChack", map);
	}
	
	public String useStartPageChack2 (Map<String, Object> map) {
		return (String) select("EzPortalDAO.useStartPageChack2", map);
	}
	
	public String getLogoHtml (Map<String, Object> map) {
		return (String) select("EzPortalDAO.getLogoHtml", map);
	}
	
	public String getPortalConfigItem (Map<String, Object> map) {
		return (String) select("EzPortalDAO.getPortalConfigItem", map);
	}
	
	public String getPortletConfigItem (Map<String, Object> map) {
		return (String) select("EzPortalDAO.getPortletConfigItem", map);
	}
	
	public String getItemLastPageID (Map<String, Object> map) {
		return (String) select("EzPortalDAO.getItemLastPageID", map);
	}
	
	public String portalPageBaseType (Map<String, Object> map) {
		return (String) select("EzPortalDAO.portalPageBaseType", map);
	}
	
	public String newMyPortalPageCreate2 (Map<String, Object> map) {
		return (String) select("EzPortalDAO.newMyPortalPageCreate2", map);
	}
	
	public String getTopUrl (String pUID) {
		return (String) select("EzPortalDAO.getTopUrl", pUID);
	}
	
	public String getMainUrl (String pUID) {
		return (String) select("EzPortalDAO.getMainUrl", pUID);
	}
	
	public int getUserInfo4(Map<String, Object> map) {
		select("EzPortalDAO.getUserInfo4", map);
		return (int) map.get("v_pCount");
	}
	
	public int getMenuItemHtml(Map<String, Object> map) {
		select("EzPortalDAO.getMenuItemHtml", map);
		return (int) map.get("v_pCount");
	}
	
	public int newMyPortalPageCreate(Map<String, Object> map) {
		select("EzPortalDAO.newMyPortalPageCreate", map);
		return (int) map.get("v_pCount");
	}
	
	public int checkEditRight(Map<String, Object> map) {
		return (int) select("EzPortalDAO.checkEditRight", map);
	}
	
	public int checkViewRight(Map<String, Object> map) {
		return (int) select("EzPortalDAO.checkViewRight", map);
	}
	
	public PortalGetRenderedTopMenuInsertVO getRenderedTopMenuInsert (Map<String, Object> map) {
		return (PortalGetRenderedTopMenuInsertVO) select("EzPortalDAO.getRenderedTopMenuInsert", map);
	}
	
	public String getParentUID (String parentTopMenuID) {
		return (String) select("EzPortalDAO.getParentUID", parentTopMenuID);
	}
	
	public String getPortalParentUID (String temp) {
		return (String) select("EzPortalDAO.getPortalParentUID", temp);
	}
	
	public void deleteCacheValue(Map<String, Object> map) {
		delete("EzPortalDAO.deleteCacheValue", map);
	}
	
	public void getUserInfo3(Map<String, Object> map) {
		insert("EzPortalDAO.getUserInfo3", map);
	}
	
	public void updateCacheValue(Map<String, Object> map) {
		insert("EzPortalDAO.updateCacheValue", map);
	}
	
	public void newMyPortalPageCreate3(Map<String, Object> map) {
		update("EzPortalDAO.newMyPortalPageCreate3", map);
	}
	
}

