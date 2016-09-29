package egovframework.ezEKP.ezPortal.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.ezEKP.ezPortal.vo.PortalFirstMainListVO;
import egovframework.ezEKP.ezPortal.vo.PortalGetMainMenuHtmlVO;
import egovframework.ezEKP.ezPortal.vo.PortalGetPortletParametersVO;
import egovframework.ezEKP.ezPortal.vo.PortalGetRenderedTopMenuInsertVO;
import egovframework.ezEKP.ezPortal.vo.PortalGetThemeListVO;
import egovframework.ezEKP.ezPortal.vo.PortalMenuItemItemsImageVO;
import egovframework.ezEKP.ezPortal.vo.PortalMenuItemItemsMenuItemsSVO;
import egovframework.ezEKP.ezPortal.vo.PortalMenuItemItemsMenuItemsVO;
import egovframework.ezEKP.ezPortal.vo.PortalPortletGeneralVO;
import egovframework.ezEKP.ezPortal.vo.PortalSearchMenuItemVO;
import egovframework.ezEKP.ezPortal.vo.PortalSearchMyPortalPage3VO;
import egovframework.ezEKP.ezPortal.vo.PortalSearchPortalPageVO;
import egovframework.ezEKP.ezPortal.vo.PortalTBLPortalACLVO;
import egovframework.ezEKP.ezPortal.vo.PortalTBLPortalPageCategoryVO;
import egovframework.ezEKP.ezPortal.vo.PortalTBLPortalPageGeneralVO;
import egovframework.ezEKP.ezPortal.vo.PortalTBLPortalPageItemsVO;
import egovframework.ezEKP.ezPortal.vo.PortalTBLPortletBoardVO;
import egovframework.ezEKP.ezPortal.vo.PortalTBLPortletHtmlPageVO;
import egovframework.ezEKP.ezPortal.vo.PortalTBLPortletImageVO;
import egovframework.ezEKP.ezPortal.vo.PortalTBLPortletURLVO;
import egovframework.ezEKP.ezPortal.vo.PortalTBLThemeGeneralVO;
import egovframework.ezEKP.ezPortal.vo.PortalTBLTopMenuGeneralVO;
import egovframework.ezEKP.ezPortal.vo.PortalTBLTopMenuItemsVO;
import egovframework.ezEKP.ezPortal.vo.PortalTBLUserInfoVO;
import egovframework.ezEKP.ezPortal.vo.PortalTopLoadGetParametersVO;
import egovframework.ezEKP.ezPortal.vo.PortalTopSearchTopMenu2VO;
import egovframework.ezEKP.ezPortal.vo.PortalUrlPortletVO;
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
	public List<PortalTopLoadGetParametersVO> loadGetParameters (Map<String, Object> map) {
		return (List<PortalTopLoadGetParametersVO>) list ("EzPortalDAO.loadGetParameters", map);
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
	
	@SuppressWarnings("unchecked")
	public List<PortalGetPortletParametersVO> getPortletParametres (String uID) {
		return (List<PortalGetPortletParametersVO>) list("EzPortalDAO.getPortletPrameters", uID);
	}
	
	@SuppressWarnings("unchecked")
	public List<PortalTBLPortalPageGeneralVO> getUserInfo5 (Map<String, Object> map) {
		return (List<PortalTBLPortalPageGeneralVO>) list("EzPortalDAO.getUserInfo5", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<PortalTBLPortalPageGeneralVO> myPortalList (Map<String, Object> map) {
		return (List<PortalTBLPortalPageGeneralVO>) list("EzPortalDAO.myPortalList", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<PortalTBLPortalPageGeneralVO> newMyPortalList (Map<String, Object> map) {
		return (List<PortalTBLPortalPageGeneralVO>) list("EzPortalDAO.newMyPortalList", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<PortalSearchMyPortalPage3VO> searchMyPortalPage3 (Map<String, Object> map) {
		return (List<PortalSearchMyPortalPage3VO>) list("EzPortalDAO.searchMyPortalPage3", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<PortalMenuItemItemsMenuItemsVO> useTopMenuID2 (Map<String, Object> map) {
		return (List<PortalMenuItemItemsMenuItemsVO>) list("EzPortalDAO.useTopMenuID2", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<PortalMenuItemItemsMenuItemsVO> useTopMenuID (Map<String, Object> map) {
		return (List<PortalMenuItemItemsMenuItemsVO>) list("EzPortalDAO.useTopMenuID", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<PortalFirstMainListVO> firstMainList (Map<String, Object> map) {
		return (List<PortalFirstMainListVO>) list("EzPortalDAO.firstMainList", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<String> selectUseFlag (Map<String, Object> map) {
		return (List<String>) list("EzPortalDAO.selectUseFlag", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<PortalSearchPortalPageVO> searchPortalPage (Map<String, Object> map) {
		return (List<PortalSearchPortalPageVO>) list("EzPortalDAO.searchPortalPage", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<PortalPortletGeneralVO> searchPortletCheckRight2 (Map<String, Object> map) {
		return (List<PortalPortletGeneralVO>) list("EzPortalDAO.searchPortletCheckRight2", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<PortalTBLPortalACLVO> getAclItems (String pUID) {
		return (List<PortalTBLPortalACLVO>) list("EzPortalDAO.getAclItems", pUID);
	}
	
	@SuppressWarnings("unchecked")
	public List<PortalSearchMenuItemVO> searchMenuItem (Map<String, Object> map) {
		return (List<PortalSearchMenuItemVO>) list("EzPortalDAO.searchMenuItem", map);
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
	
	public PortalTBLUserInfoVO topGetUserInfo (Map<String, Object> map) {
		return (PortalTBLUserInfoVO) select("EzPortalDAO.topGetUserInfo", map);
	}
	
	public PortalTBLUserInfoVO topGetUserInfo2 (Map<String, Object> map) {
		return (PortalTBLUserInfoVO) select("EzPortalDAO.topGetUserInfo2", map);
	}
	
	public PortalMenuItemItemsImageVO getImageHtml (Map<String, Object> map) {
		return (PortalMenuItemItemsImageVO) select("EzPortalDAO.getImageHtml", map);
	}
	
	public PortalUrlPortletVO urlPortlet (Map<String, Object> map) {
		return (PortalUrlPortletVO) select("EzPortalDAO.urlPortlet", map);
	}
	
	public PortalPortletGeneralVO getPorletProperties (Map<String, Object> map) {
		return (PortalPortletGeneralVO) select("EzPortalDAO.getPorletProperties", map);
	}
	
	public PortalTBLPortletURLVO getTBLPortletURL (String pUID) {
		return (PortalTBLPortletURLVO) select("EzPortalDAO.getTBLPortletURL", pUID);
	}
	
	public PortalTBLPortletHtmlPageVO getTBLPortletHtmlPage (String pUID) {
		return (PortalTBLPortletHtmlPageVO) select("EzPortalDAO.getTBLPortletHtmlPage", pUID);
	}
	
	public PortalTBLPortletImageVO getTBLPortleImage (String pUID) {
		return (PortalTBLPortletImageVO) select("EzPortalDAO.getTBLPortleImage", pUID);
	}
	
	public PortalTBLPortletBoardVO getTBLPortletBoard (String pUID) {
		return (PortalTBLPortletBoardVO) select("EzPortalDAO.getTBLPortletBoard", pUID);
	}
	
	public PortalGetRenderedTopMenuInsertVO getRenderedTopMenuInsert (Map<String, Object> map) {
		return (PortalGetRenderedTopMenuInsertVO) select("EzPortalDAO.getRenderedTopMenuInsert", map);
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
	
	public String checkViewRight(Map<String, Object> map) {
		return (String) select("EzPortalDAO.checkViewRight", map);
	}
	
	public String checkEditRight(Map<String, Object> map) {
		return (String) select("EzPortalDAO.checkEditRight", map);
	}
	
	public String getParentUID (String parentTopMenuID) {
		return (String) select("EzPortalDAO.getParentUID", parentTopMenuID);
	}
	
	public String getPortalParentUID (String temp) {
		return (String) select("EzPortalDAO.getPortalParentUID", temp);
	}
	
	public String ezCkAdminACL (Map<String, Object> map) {
		return (String) select("EzPortalDAO.ezCkAdminACL", map);
	}
	
	public String ezAclCheck (Map<String, Object> map) {
		return (String) select("EzPortalDAO.ezAclCheck", map);
	}
	
	public String selectTBLPortalACL (Map<String, Object> map) {
		return (String) select("EzPortalDAO.selectTBLPortalACL", map);
	}
	
	public String searchStartPage2 (Map<String, Object> map) {
		return (String) select("EzPortalDAO.searchStartPage2", map);
	}
	
	public int getMenuItemHtml(Map<String, Object> map) {
		select("EzPortalDAO.getMenuItemHtml", map);
		return (int) map.get("v_pCount");
	}
	
	public int newMyPortalPageCreate(Map<String, Object> map) {
		select("EzPortalDAO.newMyPortalPageCreate", map);
		return (int) map.get("v_pCount");
	}
	
	public int getUserInfo4(Map<String, Object> map) {
		select("EzPortalDAO.getUserInfo4", map);
		return (int) map.get("v_pCount");
	}
	
	public int searchMyPortalPageCount(Map<String, Object> map) {
		select("EzPortalDAO.searchMyPortalPageCount", map);
		return (int) map.get("v_pCount");
	}
	
	public void deleteCacheValue(Map<String, Object> map) {
		delete("EzPortalDAO.deleteCacheValue", map);
	}
	
	public void deleteTBLPortalACL(Map<String, Object> map) {
		delete("EzPortalDAO.deleteTBLPortalACL", map);
	}
	
	public void getUserInfo3(Map<String, Object> map) {
		insert("EzPortalDAO.getUserInfo3", map);
	}
	
	public void updateCacheValue(Map<String, Object> map) {
		insert("EzPortalDAO.updateCacheValue", map);
	}
	
	public void insertTBLPortalACL(Map<String, Object> map) {
		insert("EzPortalDAO.insertTBLPortalACL", map);
	}
	
	public void searchStartPage(Map<String, Object> map) {
		insert("EzPortalDAO.searchStartPage", map);
	}
	
	public void setUseMyStartPage2(Map<String, Object> map) {
		insert("EzPortalDAO.setUseMyStartPage2", map);
	}
	
	public void newMyPortalPageCreate3(Map<String, Object> map) {
		update("EzPortalDAO.newMyPortalPageCreate3", map);
	}
	
	public void setUseMyPortalPage(Map<String, Object> map) {
		update("EzPortalDAO.setUseMyPortalPage", map);
	}
	
	public void updateTBLPortalACL(Map<String, Object> map) {
		update("EzPortalDAO.updateTBLPortalACL", map);
	}
	
	public void updateUseFlag(Map<String, Object> map) {
		update("EzPortalDAO.updateUseFlag", map);
	}
	
	public void updateUseFlagDefault(Map<String, Object> map) {
		update("EzPortalDAO.updateUseFlagDefault", map);
	}
	
	
}

