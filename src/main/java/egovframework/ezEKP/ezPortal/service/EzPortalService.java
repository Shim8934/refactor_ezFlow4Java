package egovframework.ezEKP.ezPortal.service;

import java.util.List;
import java.util.Map;

import egovframework.ezEKP.ezPortal.vo.PortalGetMainMenuHtmlVO;
import egovframework.ezEKP.ezPortal.vo.PortalGetPortletParametersVO;
import egovframework.ezEKP.ezPortal.vo.PortalGetRenderedTopMenuInsertVO;
import egovframework.ezEKP.ezPortal.vo.PortalGetThemeListVO;
import egovframework.ezEKP.ezPortal.vo.PortalMenuItemItemsImageVO;
import egovframework.ezEKP.ezPortal.vo.PortalMenuItemItemsMenuItemsSVO;
import egovframework.ezEKP.ezPortal.vo.PortalMenuItemItemsMenuItemsVO;
import egovframework.ezEKP.ezPortal.vo.PortalPortletGeneralVO;
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

	public List<PortalTBLPortalPageGeneralVO> searchMyPortalPage2 (String pAccessIDList, String pGubunFlag, String pStrRight, String pCompanyID) throws Exception;
	
	public List<PortalTBLTopMenuGeneralVO> topSearchTopMenu3 (int endRow, String displayName, String useFlag, String companyID, String lang) throws Exception;
	
	public List<PortalTopSearchTopMenu2VO> topSearchTopMenu2 (int endRow, String displayName, String useFlag, String companyID) throws Exception;
	
	public List<PortalTopLoadGetParametersVO> topLoadGetParameters (String pUID) throws Exception;
	
	public List<PortalTopLoadGetParametersVO> loadGetParameters (String pPortletID) throws Exception;
	
	public List<PortalMenuItemItemsMenuItemsVO> getUtilMenuHtml (String pParentUID, String pOwnerPageID) throws Exception;
	
	public List<PortalGetMainMenuHtmlVO> getMainMenuHtml (String pParentUID, String pOwnerPageID, int pSkinNum) throws Exception;
	
	public List<PortalMenuItemItemsMenuItemsVO> getSubMenuHtml (String pOwnerPageID, String pParentUID) throws Exception;
	
	public List<PortalMenuItemItemsMenuItemsSVO> getSubMenuHtml2 (String pParentUID) throws Exception;
	
	public List<PortalGetThemeListVO> getThemeList (String pCompanyID) throws Exception;
	
	public List<PortalTBLPortalPageCategoryVO> getPortalPageCategory() throws Exception;
	
	public List<PortalGetPortletParametersVO> getPortletParametres (String pUID) throws Exception;
	
	public List<PortalTBLPortalPageGeneralVO> getUserInfo5 (int pCount, String useFlag, String companyID, String parentUID, String userID, String gubunFlag) throws Exception;
	
	public PortalGetRenderedTopMenuInsertVO getRenderedTopMenuInsert (String uID) throws Exception;
	
	public PortalGetRenderedTopMenuInsertVO getRenderedPortalPageHtml (String pPortalPageID) throws Exception;
	
	public PortalTBLUserInfoVO topGetUserInfo (String pUserID) throws Exception;
	
	public PortalTBLUserInfoVO topGetUserInfo2 (String pUserID, String pLang) throws Exception;
	
	public PortalTBLThemeGeneralVO getThemeInfo (String pUID, String pGubun) throws Exception;
	
	public PortalMenuItemItemsImageVO getImageHtml (String pUID, String pParentUID, int pSkinNum) throws Exception;
	
	public PortalUrlPortletVO urlPortlet (String uID, String creatorID) throws Exception;
	
	public PortalPortletGeneralVO getPorletProperties (String pUID) throws Exception;
	
	public PortalTBLPortletURLVO getTBLPortletURL (String pUID) throws Exception;
	
	public PortalTBLPortletHtmlPageVO getTBLPortletHtmlPage (String pUID) throws Exception;
	
	public PortalTBLPortletImageVO getTBLPortletImage (String pUID) throws Exception;
	
	public PortalTBLPortletBoardVO getTBLPortletBoard (String pUID) throws Exception;
	
	public String getTopMenuConfigItem (String itemName, String uID) throws Exception;
	
	public String getMenuItemConfigItem (String itemName, String uID) throws Exception;
	
	public String getAccessList(LoginVO userInfo) throws Exception;
	
	public String getDefaultTopMenu() throws Exception;
	
	public String checkCacheValue (String portalPageID, String accessIDList) throws Exception;
	
	public String topGetTopParentPageID (String uID) throws Exception;
	
	public String getTopParentPageID (String pTemp) throws Exception;
	
	public String getParentUID (String parentTopMenuID) throws Exception;
	
	public String getPortalParentUID (String temp) throws Exception;
	
	public String getRenderedTopMenuHTML (String topMenuID, String accessIDList, String mode, String skinNum, LoginVO userInfo, String theme) throws Exception;
	
	public String getUserInfo(String pUserID, String pUserName, String parentUID, String pGubunFlag, String pMode, LoginVO userInfo, String pCompanyID) throws Exception;
	
	public String searchMyPortalPage (String pGubunFlag, String pMode, LoginVO userInfo, String pCompanyID) throws Exception;
	
	public String searchTopMenu (String pDisplayName, String pUseFlag, int pStartRow, int pEndRow, String pAccessIDList, String langStr, String pCompanyID) throws Exception;
	
	public String searchTopMenu (String pDisplayName, String pUseFlag, int pStartRow, int pEndRow, String pAccessIDList, String pCompanyID) throws Exception;
	
	public String getUserInfo (String pUserID, String langStr) throws Exception;
	
	public String getThemeInfoStr (String pThemeUID, String pGubun) throws Exception;
	
	public String useStartPageChack (String pUserID, String pCompanyID) throws Exception;
	
	public String useStartPageChack2 (String pUserID, String pCompanyID, String pParentUID) throws Exception;
	
	public String getLogoHtml (String pOwnerPageID, String pAccessID) throws Exception;
	
	public String getPortalConfigItem (String pItemName, String pPageID) throws Exception;
	
	public String getPortletConfigItem (String pItemName, String pPortletID) throws Exception;
	
	public String getDefaultPortalPage() throws Exception;
	
	public String getItemLastPageID (String temp) throws Exception;
	
	public String getRenderedPortalPageHTML (String pPortalPageID, String pAccessIDList, String pMode, LoginVO userInfo, String pTheme, String pTableViewOption) throws Exception;
	
	public String portalPageBaseType (String uID, String pCompanyID) throws Exception;
	
	public String getThemeInfo(String pCompanyID, LoginVO userInfo) throws Exception;
	
	public String newMyPortalPageCreate2 (String pUserFlag, String pUserID, String pCompanyID) throws Exception;
	
	public String newMyPortalPageCreate (String pParentPageID, String pUserID, String pGubunFlag, String pCompanyID, String pPageID) throws Exception;
	
	public String getMainUrl (String pUID) throws Exception;
	
	public String getTopUrl (String pUID) throws Exception;
	
	public String getPorletPropertiesStr(String pUID) throws Exception;
	
	public String getPortletSubProperties (String pUID, String pType) throws Exception;
	
	public String getPortletParameters (String pUID) throws Exception;
	
	public String checkViewRight (String uID, String accessIDList) throws Exception;
	
	public String topLoadGetParameters (String pURL, String pMenuItemID, LoginVO userInfo) throws Exception;
	
	public String loadGetParameters (String pURL, String pPortletID, LoginVO userInfo) throws Exception;
	
	public String loadGetParametersXML (String pURL, String pXML, LoginVO userInfo) throws Exception;
	
	public String getBoardProperty (String pBoardID, String lang) throws Exception;
	
	public String addBestTable (LoginVO userInfo) throws Exception;
	
	public String selectTBLPortalACL (String pResult, String pAccessID) throws Exception;
	
	public String ezAclCheck (String pCN, String pCompanyID, String pCompanyNm) throws Exception;
	
	public String ezCkAdminACL (String pOwnerPageID) throws Exception;
	
	public int getUserInfo4 (String companyID, String creatorID, String gubunFlag, String useFlag) throws Exception;
	
	public int getMenuItemHtml (String uID) throws Exception;
	
	public int checkEditRight (String uID, String accessIDList) throws Exception;
	
	public int newMyPortalPageCreate (String pParentPageID, String pPageID, String pUserID, String pGubunFlag, String pNewPageID, int pDepth, String pCompanyID, String pAccessID, String pAccessName, int pViewRight, int pEditRight, String pMode) throws Exception;
	
	public int daysInMonth (int month, int year) throws Exception;
	
	public void deleteCacheValue (String uID, String accessListID) throws Exception;
	
	public void getUserInfo3 (String parentUID, String userFlag, String userID, String gubunFlag, String newPageID, String userName, String accessID, String accessName, int viewRight, int editRight, int depth, String companyID) throws Exception;
	
	public void updateCacheValue (String portalPageID, String accessIDList, String renderedHtml) throws Exception;
	
	public void newMyPortalPageCreate3 (String pUseFlag, String pUID, String pCompanyID, String pUserID) throws Exception;
	
	public void deleteTBLPortalACL (String pResult, String pAccessID) throws Exception;
	
	public void insertTBLPortalACL (String pResult, String pAccessID) throws Exception;
	
	public void updateTBLPortalACL (String pResult, String pAccessID) throws Exception;
	
}
