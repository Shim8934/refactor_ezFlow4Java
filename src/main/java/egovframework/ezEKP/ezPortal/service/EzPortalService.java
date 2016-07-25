package egovframework.ezEKP.ezPortal.service;

import java.util.List;

import egovframework.ezEKP.ezPortal.vo.PortalGetMainMenuHtmlVO;
import egovframework.ezEKP.ezPortal.vo.PortalGetRenderedTopMenuInsertVO;
import egovframework.ezEKP.ezPortal.vo.PortalMenuItemItemsImageVO;
import egovframework.ezEKP.ezPortal.vo.PortalMenuItemItemsMenuItemsSVO;
import egovframework.ezEKP.ezPortal.vo.PortalMenuItemItemsMenuItemsVO;
import egovframework.ezEKP.ezPortal.vo.PortalTBLPortalPageGeneralVO;
import egovframework.ezEKP.ezPortal.vo.PortalTBLThemeGeneralVO;
import egovframework.ezEKP.ezPortal.vo.PortalTBLTopMenuGeneralVO;
import egovframework.ezEKP.ezPortal.vo.PortalTBLTopMenuItemsVO;
import egovframework.ezEKP.ezPortal.vo.PortalTBLUserInfoVO;
import egovframework.ezEKP.ezPortal.vo.PortalTopLoadGetParametersVO;
import egovframework.ezEKP.ezPortal.vo.PortalTopSearchTopMenu2VO;
import egovframework.let.user.login.vo.LoginVO;


public interface EzPortalService {
	//List<ScheGetHolidayVO> getTholiday (String companyID, String userCompany) throws Exception;
	public List<PortalTBLTopMenuItemsVO> getTBLTopMenuItems (String strSQL) throws Exception;

	public List<PortalTBLPortalPageGeneralVO> searchMyPortalPage2 (String pAccessIDList, String pGubunFlag, String pStrRight, String pCompanyID) throws Exception;
	
	public List<PortalTBLTopMenuGeneralVO> topSearchTopMenu3 (int endRow, String displayName, String useFlag, String companyID, String lang) throws Exception;
	
	public List<PortalTopSearchTopMenu2VO> topSearchTopMenu2 (int endRow, String displayName, String useFlag, String companyID) throws Exception;
	
	public List<PortalTopLoadGetParametersVO> topLoadGetParameters (String pUID) throws Exception;
	
	public List<PortalMenuItemItemsMenuItemsVO> getUtilMenuHtml (String pParentUID, String pOwnerPageID) throws Exception;
	
	public List<PortalGetMainMenuHtmlVO> getMainMenuHtml (String pParentUID, String pOwnerPageID, int pSkinNum) throws Exception;
	
	public List<PortalMenuItemItemsMenuItemsVO> getSubMenuHtml (String pOwnerPageID, String pParentUID) throws Exception;
	
	public List<PortalMenuItemItemsMenuItemsSVO> getSubMenuHtml2 (String pParentUID) throws Exception;
	
	public PortalGetRenderedTopMenuInsertVO getRenderedTopMenuInsert (String uID) throws Exception;
	
	public PortalTBLPortalPageGeneralVO getUserInfo5 (int pCount, String useFlag, String companyID, String parentUID, String userID, String gubunFlag) throws Exception;
	
	public PortalTBLUserInfoVO topGetUserInfo (String pUserID) throws Exception;
	
	public PortalTBLUserInfoVO topGetUserInfo2 (String pUserID, String pLang) throws Exception;
	
	public PortalTBLThemeGeneralVO getThemeInfo (String pUID, String pGubun) throws Exception;
	
	public PortalMenuItemItemsImageVO getImageHtml (String pUID, String pParentUID, int pSkinNum) throws Exception;
	
	public String getTopMenuConfigItem (String itemName, String uID) throws Exception;
	
	public String getMenuItemConfigItem (String itemName, String uID) throws Exception;
	
	public String getAccessList(LoginVO userInfo) throws Exception;
	
	public String getDefaultTopMenu() throws Exception;
	
	public String checkCacheValue (String portalPageID, String accessIDList) throws Exception;
	
	public String topGetTopParentPageID (String uID) throws Exception;
	
	public String getParentUID (String parentTopMenuID) throws Exception;
	
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
	
	public int getUserInfo4 (String companyID, String creatorID, String gubunFlag, String useFlag) throws Exception;
	
	public int getMenuItemHtml (String uID) throws Exception;
	
	public int checkEditRight (String uID, String accessIDList) throws Exception;
	
	public int checkViewRight (String uID, String accessIDList) throws Exception;
	
	public void deleteCacheValue (String uID, String accessListID) throws Exception;
	
	public void getUserInfo3 (String parentUID, String userFlag, String userID, String gubunFlag, String newPageID, String userName, String accessID, String accessName, int viewRight, int editRight, int depth, String companyID) throws Exception;
	
	
}
