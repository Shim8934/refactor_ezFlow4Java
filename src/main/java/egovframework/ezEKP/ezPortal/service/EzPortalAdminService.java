package egovframework.ezEKP.ezPortal.service;

import java.util.List;
import java.util.Map;

import egovframework.ezEKP.ezPortal.vo.PortalTBLSkinGeneralVO;

public interface EzPortalAdminService {
	public List<PortalTBLSkinGeneralVO> selectSkinGeneral() throws Exception;
	
	public String useThemeInfo(String pUID) throws Exception;
	
	public String getUniqueFileName (String dirPath, String fileName) throws Exception;
	
	public String deleteTopPage (String pUID) throws Exception;
	
	public String saveTopMenu (String pPageID, String pParentPageID, String pUserID, String pUserName, String pXML, String pCompanyID) throws Exception;
	
	public String searchPortalPage (String pDisplayName, String pUseFlag, String pGubunFlag, int pStartRow, int pEndRow, String pAccessIDList, String pCompanyID) throws Exception;
	
	public String deletePortalPage (String pUID) throws Exception;
	
	public String savePortalPage (String pCallingPageID, String pPageID, String pParentPageID, String pXML, String pComapnyID, String pType) throws Exception;
	
	public String setUsePage (String pUID, String pGubunFlag, String pCompanyID) throws Exception;
	
	public String outOfSetUsePage (String pUID, String pGubunFlag, String pCompanyID) throws Exception;
	
	public String insertAclItem(String pXML) throws Exception;
	
	public String deleteAclItem(String pXML) throws Exception;
	
	public int searchPortalPageCount (String pDisplayName, String pGubunFlag, String pCompanyID) throws Exception;
	
	public void deleteTheme (String uID) throws Exception;
	
	public void setThemeInfo (String uID, String disNm1, String disNm2, String disNm3, String disNm4, String imageURL, String topURL, String mainURL, String companyID, String creatorID, String creatorNm, int topHeight) throws Exception;
	
	public void topSetUsePage2 (String uID, String companyID) throws Exception;
	
	public void topOutOfSetUsePage (String uID, String companyID) throws Exception;
	
	public void setUseLang (String uID, String companyID, String langStr) throws Exception;
	
	public void portalSaveSkin (String uID, String skinName, String skinBgFlag, String skinBgColor, String skinBgImage, String skinFontColor, String skinFontOverColor) throws Exception;
	
	public void setDefaultPage (String pUID, String setFlag, String pGubunFlag, String pCompanyID) throws Exception;
}
