package egovframework.ezEKP.ezPortal.service;

import java.util.List;
import java.util.Locale;
import java.util.Map;

import egovframework.ezEKP.ezPortal.vo.PortalFirstMainListVO;
import egovframework.ezEKP.ezPortal.vo.PortalGetMainMenuHtmlVO;
import egovframework.ezEKP.ezPortal.vo.PortalGetPortletParametersVO;
import egovframework.ezEKP.ezPortal.vo.PortalGetRenderedTopMenuInsertVO;
import egovframework.ezEKP.ezPortal.vo.PortalGetThemeListVO;
import egovframework.ezEKP.ezPortal.vo.PortalImagePortletVO;
import egovframework.ezEKP.ezPortal.vo.PortalMenuItemItemsImageVO;
import egovframework.ezEKP.ezPortal.vo.PortalMenuItemItemsMenuItemsSVO;
import egovframework.ezEKP.ezPortal.vo.PortalMenuItemItemsMenuItemsVO;
import egovframework.ezEKP.ezPortal.vo.PortalMyPortalListVO;
import egovframework.ezEKP.ezPortal.vo.PortalNewMyPortalPageListVO;
import egovframework.ezEKP.ezPortal.vo.PortalPortletGeneralVO;
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
import egovframework.let.user.login.vo.LoginVO;


public interface EzPortalService {
	public List<PortalTBLTopMenuItemsVO> getTBLTopMenuItems (String strSQL) throws Exception;
	
	public List<PortalTBLPortalPageItemsVO> getTBLPortalPageItemsT (String strSQL) throws Exception;
	
	public List<PortalTBLPortalPageItemsVO> getTBLPortalPageItemsF (String strSQL, String pUserID, String pTopParentPageID) throws Exception;

	public List<PortalTBLPortalPageGeneralVO> searchMyPortalPage2 (String pAccessIDList, String pGubunFlag, String pStrRight, String pCompanyID, int tenantID) throws Exception;
	
	public List<PortalTBLTopMenuGeneralVO> topSearchTopMenu3 (int endRow, String displayName, String useFlag, String companyID, String lang, int tenantID) throws Exception;
	
	public List<PortalTopSearchTopMenu2VO> topSearchTopMenu2 (int endRow, String displayName, String useFlag, String companyID, int tenantID) throws Exception;
	
	public List<PortalTopLoadGetParametersVO> topLoadGetParameters (String pUID, int tenantID) throws Exception;
	
	public List<PortalTopLoadGetParametersVO> loadGetParameters (String pPortletID, int tenantID) throws Exception;
	
	public List<PortalMenuItemItemsMenuItemsVO> getUtilMenuHtml (String pParentUID, String pOwnerPageID, int tenantID) throws Exception;
	
	public List<PortalGetMainMenuHtmlVO> getMainMenuHtml (String pParentUID, String pOwnerPageID, int pSkinNum, int tenantID) throws Exception;
	
	public List<PortalMenuItemItemsMenuItemsVO> getSubMenuHtml (String pOwnerPageID, String pParentUID, int tenantID) throws Exception;
	
	public List<PortalMenuItemItemsMenuItemsSVO> getSubMenuHtml2 (String pParentUID, int tenantID) throws Exception;
	
	public List<PortalGetThemeListVO> getThemeList (String pCompanyID, int tenantID) throws Exception;
	
	public List<PortalTBLPortalPageCategoryVO> getPortalPageCategory(int tenantID) throws Exception;
	
	public List<PortalGetPortletParametersVO> getPortletParametres (String pUID, int tenantID) throws Exception;
	
	public List<PortalTBLPortalPageGeneralVO> getUserInfo5 (int pCount, String useFlag, String companyID, String parentUID, String userID, String gubunFlag, int tenantID) throws Exception;
	
	public List<PortalMyPortalListVO> myPortalList (String pGubunFlag, String pAccessIDList, String pCompanyID, int tenantID) throws Exception;
	
	public List<PortalNewMyPortalPageListVO> newMyPortalList (String pUserID, String pGubunFlag, int tenantID, String companyID) throws Exception;
	
	public List<PortalFirstMainListVO> firstMainList (String pUseTopMenuID, String deptPath, int tenantID) throws Exception;
	
	public List<PortalTBLPortalACLVO> getAclItems (String pUID, int tenantID) throws Exception;
	
	public PortalGetRenderedTopMenuInsertVO getRenderedTopMenuInsert (String uID, int tenantID, String companyID) throws Exception;
	
	public PortalGetRenderedTopMenuInsertVO getRenderedPortalPageHtml (String pPortalPageID, int tenantID, String companyID) throws Exception;
	
	public PortalTBLUserInfoVO topGetUserInfo (String pUserID, int tenantID) throws Exception;
	
	public PortalTBLUserInfoVO topGetUserInfo2 (String pUserID, String pLang, int tenantID) throws Exception;
	
	public PortalTBLThemeGeneralVO getThemeInfo (String pUID, String pGubun, int tenantID, String companyID) throws Exception;
	
	public PortalMenuItemItemsImageVO getImageHtml (String pUID, String pParentUID, int pSkinNum, int tenantID) throws Exception;
	
	public PortalUrlPortletVO urlPortlet (String uID, String creatorID, int tenantID) throws Exception;
	
	public PortalPortletGeneralVO getPorletProperties (String pUID, int tenantID, String companyID) throws Exception;
	
	public PortalTBLPortletURLVO getTBLPortletURL (String pUID, int tenantID) throws Exception;
	
	public PortalTBLPortletHtmlPageVO getTBLPortletHtmlPage (String pUID, int tenantID) throws Exception;
	
	public PortalTBLPortletImageVO getTBLPortletImage (String pUID, int tenantID) throws Exception;
	
	public PortalTBLPortletBoardVO getTBLPortletBoard (String pUID, int tenantID) throws Exception;
	
	public PortalImagePortletVO imagePortlet (String pUID, int tenantID, String companyID) throws Exception;
	
	public PortalTBLPortletBoardVO boardPortlet (Map<String, Object> map) throws Exception;
	
	public String getLogoHtml (String pOwnerPageID, String pAccessID, int tenantID) throws Exception;
	
	public String getTopMenuConfigItem (String itemName, String uID, int tenantID) throws Exception;
	
	public String getMenuItemConfigItem (String itemName, String uID, int tenantID) throws Exception;
	
	public String getAccessList(LoginVO userInfo) throws Exception;
	
	public String getDefaultTopMenu() throws Exception;
	
	public String checkCacheValue (String portalPageID, String accessIDList, int tenantID) throws Exception;
	
	public String topGetTopParentPageID (String uID, int tenantID, String companyID) throws Exception;
	
	public String getTopParentPageID (String pTemp, int tenantID, String companyID) throws Exception;
	
	public String getParentUID (String parentTopMenuID, int tenantID, String companyID) throws Exception;
	
	public String getPortalParentUID (String temp, int tenantID, String companyID) throws Exception;
	
	public String getRenderedTopMenuHTML (String topMenuID, String accessIDList, String mode, String skinNum, LoginVO userInfo, String theme, int tenantID) throws Exception;
	
	public String getUserInfo(String pUserID, String pUserName, String parentUID, String pGubunFlag, String pMode, LoginVO userInfo, String pCompanyID, Locale locale, int tenantID) throws Exception;
	
	public String searchMyPortalPage (String pGubunFlag, String pMode, LoginVO userInfo, String pCompanyID) throws Exception;
	
	public String searchTopMenu (String pDisplayName, String pUseFlag, int pStartRow, int pEndRow, String pAccessIDList, String langStr, String pCompanyID, int tenantID) throws Exception;
	
	public String searchTopMenu (String pDisplayName, String pUseFlag, int pStartRow, int pEndRow, String pAccessIDList, String pCompanyID, int tenantID) throws Exception;
	
	public String getUserInfo (String pUserID, String langStr, int tenantID) throws Exception;
	
	public String getThemeInfoStr (String pThemeUID, String pGubun, int tenantID, String companyID) throws Exception;
	
	public String useStartPageChack (String pUserID, String pCompanyID, int tenantID) throws Exception;
	
	public String useStartPageChack2 (String pUserID, String pCompanyID, String pParentUID, int tenantID) throws Exception;
	
	public String getPortalConfigItem (String pItemName, String pPageID, int tenantID) throws Exception;
	
	public String getPortletConfigItem (String pItemName, String pPortletID, int tenantID, String companyID) throws Exception;
	
	public String getDefaultPortalPage() throws Exception;
	
	public String getItemLastPageID (String temp, int tenantID) throws Exception;
	
	public String getRenderedPortalPageHTML (String pPortalPageID, String pAccessIDList, String pMode, LoginVO userInfo, String pTheme, String pTableViewOption, int tenantID) throws Exception;
	
	public String portalPageBaseType (String uID, String pCompanyID, int tenantID) throws Exception;
	
	public String newMyPortalPageCreate2 (String pUserFlag, String pUserID, String pCompanyID, int tenantID) throws Exception;
	
	public String newMyPortalPageCreate (String pParentPageID, String pUserID, String pGubunFlag, String pCompanyID, String pPageID, int tenantID) throws Exception;
	
	public String getMainUrl (String pUID, int tenantID, String companyID) throws Exception;
	
	public String getTopUrl (String pUID, int tenantID, String companyID) throws Exception;
	
	public String getPorletPropertiesStr(String pUID, int tenantID, String companyID) throws Exception;
	
	public String getPortletSubProperties (String pUID, String pType, int tenantID) throws Exception;
	
	public String getPortletParameters (String pUID, int tenantID) throws Exception;
	
	public String checkViewRight (String uID, String accessIDList, int tenantID) throws Exception;
	
	public String checkEditRight (String uID, String accessIDList, int tenantID) throws Exception;
	
	public String topLoadGetParameters (String pURL, String pMenuItemID, LoginVO userInfo) throws Exception;
	
	public String loadGetParameters (String pURL, String pPortletID, LoginVO userInfo) throws Exception;
	
	public String loadGetParametersXML (String pURL, String pXML, LoginVO userInfo) throws Exception;
	
	public String getBoardProperty (String pBoardID, String lang, int tenantID) throws Exception;
	
	public String addBestTable (LoginVO userInfo) throws Exception;
	
	public String selectTBLPortalACL (String pResult, String pAccessID, int tenantID) throws Exception;
	
	public String ezAclCheck (String pCN, String pCompanyID, String pCompanyNm, int tenantID) throws Exception;
	
	public String ezCkAdminACL (String pOwnerPageID, String userLang) throws Exception;
	
	public String searchMyPortal (String pDisplayName, String pGubunFlag, int pStartRow, int pEndRow, String pCompanyID, int tenantID) throws Exception;
	
	public String useTopMenuID2 (String pCompanyID, String pUseFlag, String pLang, String pUserThemeUID, int tenantID) throws Exception;
	
	public String useTopMenuID( String pCompanyID, String pUseFlag, String pUserThemeUID, int tenantID) throws Exception;
	
	public String searchStartPage( String pHomeUID, String pParentUID, String pImageUID, String pUserID, String pCompanyID, String pLinkURL, int tenantID) throws Exception;
	
	public String setUseMyStartPage (String pUID, String pOldUID, String pUserID, String pCompanyID, String langStr, int tenantID) throws Exception;
	
	public String setUseMyPortalPage (String pUID, String pUserID, String pCompanyID, String pGubunFlag, int tenantID) throws Exception;
	
	public String getThemeInfoPortal(String pCompanyID, LoginVO userInfo, String pSelectThemeUID) throws Exception;
	
	public String searchPortalPage (String pDisplayName, String pUseFlag, String pGubunFlag, int pStartRow, int pEndRow, String pAccessIDList, int tenantID) throws Exception;
	
	public String searchPortletCheckRight (String pDisplayName, String pGubunFlag, String pPageGubunFlag, String pMode, int pStartRow, int pEndRow, LoginVO userInfo, String pCompanyID, int tenantID) throws Exception;
	
	public String searchMenuItem (String pDisplayName, int pStartRow, int pEndRow, String pAccessIDList, int tenantID) throws Exception;
	
	public String htmlPortlet (String uID, int tenantID) throws Exception;
	
	public String ezCkAdminACL(String pCN, String pPageID, String pACL, String userLang, int tenantID);
	
	public int getUserInfo4 (String companyID, String creatorID, String gubunFlag, String useFlag, int tenantID) throws Exception;
	
	public int getMenuItemHtml (String uID, int tenantID) throws Exception;
	
	public int newMyPortalPageCreate (String pParentPageID, String pPageID, String pUserID, String pGubunFlag, String pNewPageID, int pDepth, String pCompanyID, String pAccessID, String pAccessName, int pViewRight, int pEditRight, String pMode, int tenantID) throws Exception;
	
	public int daysInMonth (int month, int year) throws Exception;
	
	public int searchMyPortalPageCount (String pGubunFlag, String pAccessIDList, String pCompanyID, int tenantID) throws Exception;
	
	public void deleteCacheValue (String uID, String accessListID, int tenantID) throws Exception;
	
	public void getUserInfo3 (String parentUID, String userFlag, String userID, String gubunFlag, String newPageID, String userName, String accessID, String accessName, int viewRight, int editRight, int depth, String companyID, int tenantID) throws Exception;
	
	public void updateCacheValue (String portalPageID, String accessIDList, String renderedHtml, int tenantID) throws Exception;
	
	public void newMyPortalPageCreate3 (String pUseFlag, String pUID, String pCompanyID, String pUserID, int tenantID) throws Exception;
	
	public void deleteTBLPortalACL (String pResult, String pAccessID, int tenantID) throws Exception;
	
	public void insertTBLPortalACL (String pResult, String pAccessID, int tenantID) throws Exception;
	
	public void updateTBLPortalACL (String pResult, String pAccessID, int tenantID) throws Exception;
	
}
