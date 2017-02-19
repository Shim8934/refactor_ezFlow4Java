package egovframework.ezEKP.ezPortal.service;

import java.util.List;
import java.util.Map;

import egovframework.ezEKP.ezPortal.vo.PortalGetPortletParametersVO;
import egovframework.ezEKP.ezPortal.vo.PortalMenuItemItemsImageVO;
import egovframework.ezEKP.ezPortal.vo.PortalMenuItemItemsMenuItemsSVO;
import egovframework.ezEKP.ezPortal.vo.PortalMenuItemItemsMenuItemsVO;
import egovframework.ezEKP.ezPortal.vo.PortalPortletGeneralVO;
import egovframework.ezEKP.ezPortal.vo.PortalTBLBuiltInParametersVO;
import egovframework.ezEKP.ezPortal.vo.PortalTBLPortalPageCategoryVO;
import egovframework.ezEKP.ezPortal.vo.PortalTBLSkinGeneralVO;
import egovframework.ezEKP.ezPortal.vo.PortalTBLTopMenuItemsVO;

public interface EzPortalAdminService {
	public List<PortalTBLSkinGeneralVO> selectSkinGeneral(int tenantID) throws Exception;
	
	public List<PortalTBLPortalPageCategoryVO> getPortletCategory(int tenantID) throws Exception;
	
	public List<PortalTBLBuiltInParametersVO> menuItemEdit (int tenantID) throws Exception;
	
	public List<PortalTBLBuiltInParametersVO> subMenuItemEdit1 (int tenantID) throws Exception;
	
	public List<PortalMenuItemItemsMenuItemsVO> loadMenuItems (String pUID, String pPageID, int tenantID) throws Exception;
	
	public List<PortalMenuItemItemsMenuItemsSVO> loadSubMenuItems (String pParentUID, String pPageID, int tenantID) throws Exception;
	
	public List<PortalGetPortletParametersVO> getMenuItemParameters (String pUID, int tenantID) throws Exception;
	
	public List<PortalTBLTopMenuItemsVO> loadPositionSettings (Map<String, Object> map) throws Exception;
	
	public PortalMenuItemItemsImageVO logoEdit (String uID, String pageID, int tenantID) throws Exception;
	
	public PortalPortletGeneralVO getPortletProperties (String pUID, int tenantID) throws Exception;
	
	public String useThemeInfo(String pUID, int tenantID) throws Exception;
	
	public String getUniqueFileName (String dirPath, String fileName) throws Exception;
	
	public String deleteTopPage (String pUID, int tenantID) throws Exception;
	
	public String saveTopMenu (String pPageID, String pParentPageID, String pUserID, String pUserName, String pXML, String pCompanyID, int tenantID) throws Exception;
	
	public String searchPortalPage (String pDisplayName, String pUseFlag, String pGubunFlag, int pStartRow, int pEndRow, String pAccessIDList, String pCompanyID, int tenantID) throws Exception;
	
	public String deletePortalPage (String pUID, int tenantID) throws Exception;
	
	public String savePortalPage (String pCallingPageID, String pPageID, String pParentPageID, String pXML, String pComapnyID, String pType, int tenantID) throws Exception;
	
	public String setUsePage (String pUID, String pGubunFlag, String pCompanyID, int tenantID) throws Exception;
	
	public String outOfSetUsePage (String pUID, String pGubunFlag, String pCompanyID, int tenantID) throws Exception;
	
	public String insertAclItem(String pXML, int tenantID) throws Exception;
	
	public String deleteAclItem(String pXML, int tenantID) throws Exception;
	
	public String searchPortlet (String pDisplayName, String pGubunFlag, String pPageGubunFlag, int pStartRow, int pEndRow, String pAccessIDList, String pCompanyID, int tenantID) throws Exception;
	
	public String createNewPortlet (String pCompanyID, int tenantID) throws Exception;
	
	public String savePortletProperties (String pXML, int tenantID) throws Exception;
	
	public String savePortletParameters (String pXML, int tenantID) throws Exception;
	
	public String saveMenuItemParameters (String pXML, int tenantID) throws Exception;
	
	public String deletePortlet (String pUID, int tenantID) throws Exception;
	
	public String loadLogoItems (String pPageID, int tenantID) throws Exception;
	
	public String createNewLogoItem (String pParentUID, String pPageID, int tenantID) throws Exception;
	
	public String savePositionSettings (String pXML, String pPageID, int tenantID) throws Exception;
	
	public String createNewMenuItem (String pParentUID, String pPageID, int tenantID) throws Exception;
	
	public String loadMenuItemConfig (String pUID, String pPageID, String pSkinNum, int tenantID) throws Exception;
	
	public String saveMenuItemConfig (String pXML, String pPageID, String pCompanyID, int tenantID) throws Exception;
	
	public String loadSubMenuItemConfig (String pUID, String pPageID, int tenantID) throws Exception;
	
	public String createNewSubMenuItem (String pParentUID, String pPageID, int tenantID) throws Exception;
	
	public String saveSubMenuItemConfig (String pXML, String pPageID, int tenantID) throws Exception;
	
	public String saveDelPortletInfo (String pUserID, String pUserName, String pXML, int tenantID) throws Exception;
	
	public int searchPortalPageCount (String pDisplayName, String pGubunFlag, String pCompanyID, int tenantID) throws Exception;
	
	public int searchPortletCount (String pDisplayName, String pGubunFlag, String pPageGubunFlag, String pCompanyID, int tenantID) throws Exception;
	
	public void deleteTheme (String uID, int tenantID) throws Exception;
	
	public void setThemeInfo (String uID, String disNm1, String disNm2, String disNm3, String disNm4, String imageURL, String topURL, String mainURL, String companyID, String creatorID, String creatorNm, int topHeight, int tenantID) throws Exception;
	
	public void topSetUsePage2 (String uID, String companyID, int tenantID) throws Exception;
	
	public void topOutOfSetUsePage (String uID, String companyID, int tenantID) throws Exception;
	
	public void setUseLang (String uID, String companyID, String langStr, int tenantID) throws Exception;
	
	public void portalSaveSkin (String uID, String skinName, String skinBgFlag, String skinBgColor, String skinBgImage, String skinFontColor, String skinFontOverColor, int tenantID) throws Exception;
	
	public void setDefaultPage (String pUID, String setFlag, String pGubunFlag, String pCompanyID, int tenantID) throws Exception;
	
	public void savePortletSubProperty (String oldUserType, String uID, String creatorID, String userType, String userID, String url, int tenantID) throws Exception;
	
	public void savePortletSubProperty2 (Map<String, Object> map) throws Exception;
	
	public void savePortletSubProperty3 (Map<String, Object> map) throws Exception;
	
	public void savePortletSubProperty4 (String oldUserType, String uID, String oldCreatorID, String boardID, String userType, String userID, String itemCount, String itemFields, int tenantID) throws Exception;
	
	public void removeParameter (int mode, String uID, String paramName, int tenantID) throws Exception;
	
	public void saveLogoImage (Map<String, Object> map) throws Exception;
	
	public void saveLogoImage2 (Map<String, Object> map) throws Exception;
	
	public void removeMenuItem (String uID, String parentUID, String pageID, int tenantID) throws Exception;
	
	public void updateMenuItemSetOrder (int columnPos, String uID, String ownerPageID, int tenantID) throws Exception;
	
	public void updateSubMenuItemSetOrder (int columnPos, String uID, String ownerPageID, int tenantID) throws Exception;
	
	public void removeSubMenuItem (String uID, String parentUID, String pageID, int tenantID) throws Exception;
	
}
