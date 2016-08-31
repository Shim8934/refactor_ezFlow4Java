package egovframework.ezEKP.ezPortal.service.impl;


import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Properties;
import java.util.UUID;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.w3c.dom.Document;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezBoard.service.EzBoardService;
import egovframework.ezEKP.ezBoard.vo.BoardPropertyVO;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezCommunity.dao.EzCommunityDAO;
import egovframework.ezEKP.ezCommunity.vo.CommunityCClubUserVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityMyCommunityVO;
import egovframework.ezEKP.ezPortal.dao.EzPortalDAO;
import egovframework.ezEKP.ezPortal.service.EzPortalService;
import egovframework.ezEKP.ezPortal.vo.PortalFirstMainListVO;
import egovframework.ezEKP.ezPortal.vo.PortalGetMainMenuHtmlVO;
import egovframework.ezEKP.ezPortal.vo.PortalGetPortletParametersVO;
import egovframework.ezEKP.ezPortal.vo.PortalGetRenderedTopMenuInsertVO;
import egovframework.ezEKP.ezPortal.vo.PortalGetThemeListVO;
import egovframework.ezEKP.ezPortal.vo.PortalMenuItemItemsImageVO;
import egovframework.ezEKP.ezPortal.vo.PortalMenuItemItemsMenuItemsSVO;
import egovframework.ezEKP.ezPortal.vo.PortalMenuItemItemsMenuItemsVO;
import egovframework.ezEKP.ezPortal.vo.PortalPortletGeneralVO;
import egovframework.ezEKP.ezPortal.vo.PortalSearchMyPortalPage3VO;
import egovframework.ezEKP.ezPortal.vo.PortalSearchPortalPageVO;
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
import egovframework.let.utl.fcc.service.CommonUtil;

@Service("EzPortalService")
public class EzPortalServiceImpl implements EzPortalService {
	@Resource(name="EzPortalDAO")
	private EzPortalDAO ezPortalDAO;
	
	@Resource(name="EzCommunityDAO")
	private EzCommunityDAO ezCommunityDAO;
	
	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;
	
	@Resource(name="EzCommonService")
	private EzCommonService ezCommonService;
	
	@Resource(name = "EzBoardService")
	private EzBoardService ezBoardService;
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private Properties globals;
	
	private boolean bRootPage = false;
	private String gTheme = "BASIC";
	private String gSkinNum = "1";
	private String gTableViewOption = "D";
	private String pSelectThemeUID = "";

	@Override
	public String getTopMenuConfigItem(String itemName, String uID) throws Exception{
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pITEMNAME", itemName);
		map.put("v_pUID", uID);
	
		return ezPortalDAO.getTopMenuConfigItem(map);
	}

	@Override
	public void deleteCacheValue(String uID, String accessListID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pUID", uID);
		map.put("v_pACCESSLISTID", accessListID);
		ezPortalDAO.deleteCacheValue(map);
	}
	
	@Override
	public String checkCacheValue(String portalPageID, String accessIDList) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PORTALPAGEID", portalPageID);
		map.put("v_ACCESSIDLIST", accessIDList);
		return ezPortalDAO.checkCacheValue(map);
	}
	
	
	@Override
	public String topGetTopParentPageID(String uID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		try {
			String temp = uID;
			String parentTopMenuID = "";
			int count = 0;
			while (count < 10) {
				map.put("v_pUID", temp);
				parentTopMenuID = ezPortalDAO.topGetTopParentPageID(map);
				
				if (parentTopMenuID != null && parentTopMenuID.toLowerCase().trim().equals("top")) {
					break;
				}
				temp = parentTopMenuID;
				count ++;
			}
			return temp;
		} catch (Exception e) {
			e.printStackTrace();
			return "";
		}
	}
	
	@Override
	public PortalGetRenderedTopMenuInsertVO getRenderedTopMenuInsert(String uID) throws Exception {
		
		return ezPortalDAO.getRenderedTopMenuInsert(uID);
	}

	@Override
	public List<PortalTBLTopMenuItemsVO> getTBLTopMenuItems(String strSQL) throws Exception {
		
		return ezPortalDAO.getTBLTopMenuItems(strSQL);
	}
	
	@Override
	public List<PortalTBLPortalPageItemsVO> getTBLPortalPageItemsT(String strSQL) throws Exception {

		return ezPortalDAO.getTBLPortalPageItemsT(strSQL);
	}

	@Override
	public List<PortalTBLPortalPageItemsVO> getTBLPortalPageItemsF( String strSQL, String pUserID, String pTopParentPageID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("strSQL", strSQL);
		map.put("pUserID", pUserID);
		map.put("pTopParentPageID", pTopParentPageID);
		return ezPortalDAO.getTBLPortalPageItemsF(map);
	}

	@Override
	public String getParentUID(String parentTopMenuID) throws Exception {
		return ezPortalDAO.getParentUID(parentTopMenuID);
	}
	
	@Override
	public String getPortalParentUID(String temp) throws Exception {
		return ezPortalDAO.getPortalParentUID(temp);
	}

	@Override
	public void getUserInfo3(String parentUID, String userFlag, String userID, String gubunFlag, String newPageID, String userName,
			String accessID, String accessName, int viewRight, int editRight, int depth, String companyID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pPARENTUID", parentUID);
		map.put("v_pUSERFLAG", userFlag);
		map.put("v_pUSERID", userID);
		map.put("v_pGUBUNFLAG", gubunFlag);
		map.put("v_pNEWPAGEID", newPageID);
		map.put("v_pUSERNAME", userName);
		map.put("v_pACCESSID", accessID);
		map.put("v_pACCESSNAME", accessName);
		map.put("v_pVIEW_RIGHT", viewRight);
		map.put("v_pEDIT_RIGHT", editRight);
		map.put("v_pDEPTH", depth);
		map.put("v_pCOMPANYID", companyID);
		ezPortalDAO.getUserInfo3(map);
	}
	
	@Override
	public int getUserInfo4(String companyID, String creatorID, String gubunFlag, String useFlag) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pCOMPANYID", companyID);
		map.put("v_pCREATORID", creatorID);
		map.put("v_pGUBUNFLAG", gubunFlag);
		map.put("v_pUSEFLAG", useFlag);
		return ezPortalDAO.getUserInfo4(map);
	}
	
	@Override
	public List<PortalTBLPortalPageGeneralVO> getUserInfo5(int pCount, String useFlag, String companyID, String parentUID, String userID, String gubunFlag) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pCOUNT", pCount);
		map.put("v_pUSEFLAG", useFlag);
		map.put("v_pCOMPANYID", companyID);
		map.put("v_pPARENTUID", parentUID);
		map.put("v_pUSERID", userID);
		map.put("v_pGUBUNFLAG", gubunFlag);
		return ezPortalDAO.getUserInfo5(map);
				
	}
	
	@Override
	public int checkEditRight(String uID, String accessIDList) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_UID", uID);
		map.put("v_ACCESSIDLIST", accessIDList);
		return ezPortalDAO.checkEditRight(map);
	}
	

	@Override
	public List<PortalTBLPortalPageGeneralVO> searchMyPortalPage2( String pAccessIDList, String pGubunFlag, String pStrRight, String pCompanyID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pACCESSIDLIST", pAccessIDList);
		map.put("v_pGUBUNFLAG", pGubunFlag);
		map.put("v_pSTRRIGHT", pStrRight);
		map.put("v_pCOMPANYID", pCompanyID);
		return ezPortalDAO.searchMyPortalPage2(map);
	}
	
	@Override
	public String checkViewRight(String uID, String accessIDList) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_UID", uID);
		map.put("v_ACCESSIDLIST", accessIDList);
		return ezPortalDAO.checkViewRight(map);
	}
	
	@Override
	public List<PortalTBLTopMenuGeneralVO> topSearchTopMenu3(int endRow, String displayName, String useFlag, String companyID, String lang) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pENDROW", endRow);
		map.put("v_pDISPLAYNAME", displayName);
		map.put("v_pUSEFLAG", useFlag);
		map.put("v_pCOMPANYID", companyID);
		map.put("v_pLANG", lang);
		return ezPortalDAO.topSearchTopMenu3(map);
	}
	
	@Override
	public PortalTBLUserInfoVO topGetUserInfo2(String pUserID, String pLang) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pUSERID", pUserID);
		map.put("v_pLANG", pLang);
		return ezPortalDAO.topGetUserInfo2(map);
	}
	
	@Override
	public PortalTBLUserInfoVO topGetUserInfo(String pUserID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pUSERID", pUserID);
		return ezPortalDAO.topGetUserInfo(map);
	}
	
	@Override
	public List<PortalTopSearchTopMenu2VO> topSearchTopMenu2(int endRow, String displayName, String useFlag, String companyID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pENDROW", endRow);
		map.put("v_pDISPLAYNAME", displayName);
		map.put("v_pUSEFLAG", useFlag);
		map.put("v_pCOMPANYID", companyID);
		return ezPortalDAO.topSearchTopMenu2(map);
	}
	
	@Override
	public PortalTBLThemeGeneralVO getThemeInfo(String pUID, String pGubun) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PUID", pUID);
		map.put("v_PGUBUN", pGubun); 
		return ezPortalDAO.getThemeInfo(map);
	}
	
	@Override
	public String useStartPageChack(String pUserID, String pCompanyID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pUSERID", pUserID);
		map.put("v_pCOMPANYID", pCompanyID); 
		return ezPortalDAO.useStartPageChack(map);
	}
	
	@Override
	public String useStartPageChack2(String pUserID, String pCompanyID, String pParentUID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pUSERID", pUserID);
		map.put("v_pCOMPANYID", pCompanyID);
		map.put("v_pPARENTUID", pParentUID);
		return ezPortalDAO.useStartPageChack2(map);
	}

	@Override
	public int getMenuItemHtml(String uID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pUID", uID); 
		return ezPortalDAO.getMenuItemHtml(map);
	}
	
	@Override
	public String getMenuItemConfigItem(String itemName, String uID)throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pITEMNAME", itemName); 
		map.put("v_pUID", uID); 
		return ezPortalDAO.getMenuItemConfigItem(map);
	}
	
	@Override
	public String getLogoHtml(String pOwnerPageID, String pAccessID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pOWNERPAGEID", pOwnerPageID); 
		map.put("v_pACCESSID", pAccessID);  
		return ezPortalDAO.getLogoHtml(map);
	}
	
	@Override
	public PortalMenuItemItemsImageVO getImageHtml(String pUID, String pParentUID, int pSkinNum) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pUID", pUID); 
		map.put("v_pPARENTUID", pParentUID);
		map.put("v_pSKINNUM", pSkinNum);  
		return ezPortalDAO.getImageHtml(map);
	}
	
	@Override
	public List<PortalTopLoadGetParametersVO> topLoadGetParameters(String pUID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pUID", pUID);  
		return ezPortalDAO.topLoadGetParameters(map);
	}
	
	@Override
	public List<PortalMenuItemItemsMenuItemsVO> getUtilMenuHtml(String pParentUID, String pOwnerPageID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pPARENTUID", pParentUID); 
		map.put("v_pOWNERPAGEID", pOwnerPageID);
		return ezPortalDAO.getUtilMenuHtml(map);
	}
	
	@Override
	public List<PortalGetMainMenuHtmlVO> getMainMenuHtml(String pParentUID, String pOwnerPageID, int pSkinNum) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pPARENTUID", pParentUID); 
		map.put("v_pOWNERPAGEID", pOwnerPageID);
		map.put("v_pSKINNUM", pSkinNum);
		return ezPortalDAO.getMainMenuHtml(map);
	}

	@Override
	public List<PortalMenuItemItemsMenuItemsVO> getSubMenuHtml(String pOwnerPageID, String pParentUID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pOWNERPAGEID", pOwnerPageID); 
		map.put("v_pPARENTUID", pParentUID);
		return ezPortalDAO.getSubMenuHtml(map);
	}

	@Override
	public List<PortalMenuItemItemsMenuItemsSVO> getSubMenuHtml2( String pParentUID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pPARENTUID", pParentUID);
		return ezPortalDAO.getSubMenuHtml2(map);
	}
	
	@Override
	public String getPortalConfigItem(String pItemName, String pPageID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pPITEMNAME", pItemName);
		map.put("v_pPAGEID", pPageID);
		return ezPortalDAO.getPortalConfigItem(map);
	}
	
	@Override
	public PortalGetRenderedTopMenuInsertVO getRenderedPortalPageHtml( String pPortalPageID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pPORTALPAGEID", pPortalPageID);
		return ezPortalDAO.getRenderedPortalPageHtml(map);
	}
	
	@Override
	public String getTopParentPageID(String pTemp) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pTEMP", pTemp);
		return ezPortalDAO.getTopParentPageID(map);
	}
	
	@Override
	public String getPortletConfigItem(String pItemName, String pPortletID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pPITEMNAME", pItemName);
		map.put("v_pPORTLETID", pPortletID);
		return ezPortalDAO.getPortletConfigItem(map);
	}
	
	@Override
	public String getItemLastPageID(String temp) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pTEMP", temp);
		return ezPortalDAO.getItemLastPageID(map);
	}
	
	@Override
	public void updateCacheValue(String portalPageID, String accessIDList, String renderedHtml) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PORTALPAGEID", portalPageID);
		map.put("v_ACCESSIDLIST", portalPageID);
		map.put("v_RENDEREDHTML", renderedHtml.replace("'", "''"));
		ezPortalDAO.updateCacheValue(map);
	}
	
	@Override
	public String portalPageBaseType(String uID, String pCompanyID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pUID", uID);
		map.put("v_pCOMPANYID", pCompanyID);
		return ezPortalDAO.portalPageBaseType(map);
	}
	
	@Override
	public List<PortalGetThemeListVO> getThemeList(String pCompanyID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PCOMPANYID", pCompanyID);
		return ezPortalDAO.getThemeList(map);
	}
	
	@Override
	public List<PortalTBLPortalPageCategoryVO> getPortalPageCategory() throws Exception {
		return ezPortalDAO.getPortalPageCategory();
	}
	
	@Override
	public int newMyPortalPageCreate(String pParentPageID, String pPageID, String pUserID, String pGubunFlag, String pNewPageID, int pDepth,
			String pCompanyID, String pAccessID, String pAccessName, int pViewRight, int pEditRight, String pMode) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pPARENTPAGEID", pParentPageID);
		map.put("v_pPAGEID", pPageID);
		map.put("v_pUSERID", pUserID);
		map.put("v_pGUBUNFLAG", pGubunFlag);
		map.put("v_pNEWPAGEID", pNewPageID);
		map.put("v_pDEPTH", pDepth);
		map.put("v_pCOMPANYID", pCompanyID);
		map.put("v_pACCESSID", pAccessID);
		map.put("v_pACCESSNAME", pAccessName);
		map.put("v_pVIEW_RIGHT", pViewRight);
		map.put("v_pEDIT_RIGHT", pEditRight);
		map.put("v_pMODE", pMode);
		return ezPortalDAO.newMyPortalPageCreate(map);
	}
	
	@Override
	public String newMyPortalPageCreate2(String pUserFlag, String pUserID, String pCompanyID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pUSERFLAG", pUserFlag);
		map.put("v_pUSERID", pUserID);
		map.put("v_pCOMPANYID", pCompanyID);
		return ezPortalDAO.newMyPortalPageCreate2(map);
	}
	
	@Override
	public void newMyPortalPageCreate3(String pUseFlag, String pUID, String pCompanyID, String pUserID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pUSEFLAG", pUseFlag);
		map.put("v_pUID", pUID);
		map.put("v_pCOMPANYID", pCompanyID);
		map.put("v_pUSERID", pUserID);
		ezPortalDAO.newMyPortalPageCreate3(map);
	}
	
	@Override
	public String getMainUrl(String pUID) throws Exception {
		return ezPortalDAO.getMainUrl(pUID);
	}

	@Override
	public String getTopUrl(String pUID) throws Exception {
		return ezPortalDAO.getTopUrl(pUID);
	}
	
	@Override
	public PortalUrlPortletVO urlPortlet(String uID, String creatorID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_UID", uID);
		map.put("v_CREATORID", creatorID);
		return ezPortalDAO.urlPortlet(map);
	}
	
	@Override
	public PortalPortletGeneralVO getPorletProperties(String pUID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pUID", pUID);
		return ezPortalDAO.getPorletProperties(map);
	}
	
	@Override
	public PortalTBLPortletURLVO getTBLPortletURL(String pUID) throws Exception {
		return ezPortalDAO.getTBLPortletURL(pUID);
	}

	@Override
	public PortalTBLPortletHtmlPageVO getTBLPortletHtmlPage(String pUID) throws Exception {
		return ezPortalDAO.getTBLPortletHtmlPage(pUID);
	}

	@Override
	public PortalTBLPortletImageVO getTBLPortletImage(String pUID) throws Exception {
		return ezPortalDAO.getTBLPortleImage(pUID);
	}

	@Override
	public PortalTBLPortletBoardVO getTBLPortletBoard(String pUID) throws Exception {
		return ezPortalDAO.getTBLPortletBoard(pUID);
	}
	
	@Override
	public List<PortalGetPortletParametersVO> getPortletParametres(String pUID) throws Exception {
		return ezPortalDAO.getPortletParametres(pUID);
	}
	
	@Override
	public List<PortalTopLoadGetParametersVO> loadGetParameters(String pPortletID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pPortletID", pPortletID);
		return ezPortalDAO.loadGetParameters(map);
	}
	
	@Override
	public String selectTBLPortalACL(String pResult, String pAccessID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("pResult", pResult);
		map.put("pAccessID", pAccessID);
		return ezPortalDAO.selectTBLPortalACL(map);
	}

	@Override
	public void deleteTBLPortalACL(String pResult, String pAccessID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("pResult", pResult);
		map.put("pAccessID", pAccessID);
		ezPortalDAO.deleteTBLPortalACL(map);
	}

	@Override
	public void insertTBLPortalACL(String pResult, String pAccessID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("pResult", pResult);
		map.put("pAccessID", pAccessID);
		ezPortalDAO.insertTBLPortalACL(map);
	}

	@Override
	public void updateTBLPortalACL(String pResult, String pAccessID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("pResult", pResult);
		map.put("pAccessID", pAccessID);
		ezPortalDAO.updateTBLPortalACL(map);
	}
	
	@Override
	public String ezCkAdminACL(String pOwnerPageID) throws Exception {
		return ezPortalDAO.ezCkAdminACL(pOwnerPageID);
	}
	
	@Override
	public List<PortalTBLPortalPageGeneralVO> newMyPortalList(String pUserID, String pGubunFlag) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pDISPLAYNAME", pUserID);
		map.put("v_pGUBUNFLAG", pGubunFlag);
		return ezPortalDAO.newMyPortalList(map);
	}
	
	@Override
	public List<PortalFirstMainListVO> firstMainList(String pUseTopMenuID, String deptPath) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PUSETOPMENUID", pUseTopMenuID);
		map.put("v_DEPTPATH", deptPath);
		return ezPortalDAO.firstMainList(map);
	}

	public String getAccessList(LoginVO userInfo) {
		try {
			String pDeptPathCode = userInfo.getDeptPathCode();
			String ret = "";
			String pIDUser = "";
			String pIDTop = "";
			String pIDCompany = "";
			String pIDDept = "";
			//부서가 있으면 부서를 먼저 체크하도록 배열 변경
			if (pDeptPathCode.split(",").length == 4) {
				pIDUser = pDeptPathCode.split("\\,")[0].trim();
				pIDTop = pDeptPathCode.split("\\,")[1].trim();
				pIDCompany = pDeptPathCode.split("\\,")[2].trim();
				pIDDept = pDeptPathCode.split("\\,")[3].trim();
				pDeptPathCode = pIDUser + "," + pIDTop + "," + pIDDept + "," + pIDCompany;
			}
			
			if (pDeptPathCode.toLowerCase().indexOf(",everyone") == -1) {
				ret = pDeptPathCode + ",everyone";
			} else {
				ret = pDeptPathCode;
			}
			return ret;
		} catch (Exception e) {
			e.printStackTrace();
			return ",";
		}
	}
	
	public String getDefaultTopMenu() {
		try {
			StringBuilder sb = new StringBuilder();
			 sb.append("<table id='main_table' border=1 cellpadding=0 cellspacing=0 width=100% height=200px style='table-layout:fixed;boarder-collapse:collapse'>\n");
             sb.append("<tr id='main_row'>\n");
             sb.append("<td id='td0' valign=top onclick='selectcell(event)'><table border=1 cellpadding=0 cellspacing=0 width=100% valign=top>\n");
             sb.append("<TBODY>");
             sb.append("<TR style='WIDTH: 100%; HEIGHT: 10px' onclick='selectcellTitle(event)'><td align=center>*</td></TR>");
             sb.append("</TBODY></table></td>");
             sb.append("</tr></table>");
			
             String strPage = sb.toString();
             
			return strPage;
		} catch (Exception e) {
			e.printStackTrace();
			return "";
		}
	}
	
	public String getRenderedTopMenuHTML (String topMenuID, String accessIDList, String mode, String skinNum, LoginVO userInfo, String theme) {
		try {
			if (mode.equals("view")) {
				String cacheValue = checkCacheValue(topMenuID, getAccessList(userInfo));
				if (cacheValue != null && !cacheValue.equals("")) {
					return cacheValue;
				}
			}
			
			if (!skinNum.equals("")) {
				this.gSkinNum = skinNum;
			}
			
			if (!theme.equals("")) {
				this.gTheme = theme;
			}
			
			StringBuilder sb = new StringBuilder();
			
			String pageWidth = "";
			String pageHeight = "";
			String pageColumnLength = "";
			String pageColumnSplit = "";
			String rootParentUID = topGetTopParentPageID(topMenuID); // 최상위 페이지 ID
			String boarderValue = "0";
			int i = 0;
			
			StringBuilder dsb = new StringBuilder();
			if (mode.equals("edit")) {
				boarderValue = "1";
				  dsb.append("<table id='main_table' border=" + boarderValue + " cellpadding=0 cellspacing=0 width=100% height=100% style='table-layout:fixed;boarder-collapse:collapse'>\n");
                  dsb.append("<tr id='main_row'>\n");
                  dsb.append("<td id='td0' valign=top onclick='selectcell(event)'><table border=" + boarderValue + " cellpadding=0 cellspacing=0 width=100% valign=top>\n");
                  dsb.append("<TBODY>");
                  dsb.append("<TR style='WIDTH: 100%; HEIGHT: 10px' onclick='selectcellTitle(event)'><td align=center>*</td></TR>");
                  dsb.append("</TBODY></table></td>");
                  dsb.append("</tr></table>");
			}
			String defaultValue = dsb.toString();
			
			PortalGetRenderedTopMenuInsertVO result = getRenderedTopMenuInsert(topMenuID);
			
			if (result == null) {
				return defaultValue;
			}
			
			pageWidth = getTopMenuConfigItem("WIDTH",rootParentUID);
			pageHeight = getTopMenuConfigItem("HEIGHT",rootParentUID);
			pageColumnLength = getTopMenuConfigItem("COLUMNLENGTH",rootParentUID);
			pageColumnSplit = getTopMenuConfigItem("COLUMNSPLIT",rootParentUID);
			
			if (mode.equals("edit")) {
				sb.append("<table id='main_table' border=" + boarderValue + " cellpadding=0 cellspacing=0 ");
                if (!pageWidth.equals("-1") && !pageWidth.equals("0") &&  !pageWidth.toLowerCase().equals("")) {
                	sb.append("width=" + pageWidth + "px ");
                } else {
                	sb.append("width=100% ");
                }
                if (!pageHeight.equals("-1") && !pageHeight.equals("0") &&  !pageHeight.toLowerCase().equals("")) {
                	sb.append("height=" + pageHeight + "px ");
                } else {
                	sb.append("height=100% ");
                }
                sb.append("style='table-layout:fixed;'>\n");
                sb.append("<tr id='main_row'>\n");
			}
			
			for (int j=0; j<Integer.parseInt(pageColumnLength); j++) {
				if (mode.equals("edit")) {
					String columnWidth = "*";
					if (j == Integer.parseInt(pageColumnLength) - 1) {
						sb.append("<TD id=td0 vAlign=top>\n");
					} else {
						sb.append("<td id='td" + String.valueOf((i + 1)) + "' valign=top");
						if (!pageColumnSplit.equals("")) {
							if (!pageColumnSplit.split(";")[j].equals("") && pageColumnSplit.split(";")[j].equals("*")) {
								columnWidth = pageColumnSplit.split(";")[j] + "px";
								sb.append(" style='width:" + columnWidth + "'>\n");
							}
						} else {
							sb.append(">\n");
						}
					}
					sb.append("<table border=" + boarderValue + " cellpadding=0 cellspacing=0 width=100% valign=top>\n");
                    sb.append("<TBODY>\n");
                    sb.append("<TR style='WIDTH: 100%; HEIGHT: 10px' onclick='selectcellTitle(event)'><td align=center>" + columnWidth + "</td></TR>\n");
                    sb.append(getRenderedTopMenuColumn(topMenuID, accessIDList, i + 1, mode, userInfo));   // 각 컬럼의 메뉴를 랜더링
                    sb.append("</tbody>\n</table>\n</td>\n");
					} else {
						sb.append("<div id= 'top'>\n");
						sb.append("<header>\n");
						sb.append(getRenderedTopMenuColumn(topMenuID, accessIDList, i + 1, mode, userInfo));   // 각 컬럼의 메뉴를 랜더링
						if(theme != "BASIC") {
	                	  sb.append("</header>\n");
						}
					}
				}
			 if (mode.equals("edit")) {
				 sb.append("</tr>\n</table>\n");
			 } else {
				 sb.append("</div>\n"); 
             }
             
			 String strPage = sb.toString();
			 sb = null;
			 if (mode.equals("view")) {
				 updateCacheValue(topMenuID, getAccessList(userInfo), strPage);
			 }
			 return strPage;
		} catch (Exception e) {
			e.printStackTrace();
			return "";
		}
	}
	
	public String getRenderedTopMenuColumn (String pTopMenuID, String pAccessIDList, int pColumnIndex, String pMode, LoginVO userInfo) {
		try {
			
			StringBuilder sb = new StringBuilder();
			String strSQL = "";
			String parentTopMenuID = pTopMenuID; // 자신의 상위페이지 ID
			
			int count = 0;
			
			strSQL = "SELECT * FROM ezPortal.TBL_TopMenu_Items  WHERE PageUID = '" + pTopMenuID + "' AND ColumnPos = " + pColumnIndex;
			
			while (count < 10) {
				
				parentTopMenuID = getParentUID(parentTopMenuID);
				
				if (parentTopMenuID.toLowerCase().trim().equals("top")) {
					break;
				}
				String param = String.valueOf(count);
				strSQL += " UNION ALL SELECT * FROM ezPortal.TBL_TopMenu_Items  WHERE PageUID = '" + param + "' AND ColumnPos = " + parentTopMenuID;
				count ++;
			}

			List<PortalTBLTopMenuItemsVO> result = getTBLTopMenuItems(strSQL);
			
			if (result == null) {
				return "";
			}
			
			for (int i=0; i<result.size(); i++) {
				String menuItemMenuItemType = result.get(i).getMenuItemType();
				String menuItemUID = result.get(i).getuID();
				String menuItemPageUID = result.get(i).getPageUID();
				String menuItemDisplayName = result.get(i).getDisplayName();
				String menuItemHeight = result.get(i).getHeight();
				String menuItemCanRemove = result.get(i).getCanRemove();
				String menuItemCanResize = result.get(i).getCanResize();
				String menuItemCanReplace = result.get(i).getCanReplace();
				
				if (pMode.equals("edit")) {
					if (!menuItemHeight.toLowerCase().equals(""))	{
						sb.append("<TR style='WIDTH: 100%; HEIGHT: " + menuItemHeight + "px'>\n");
					} else  {
						sb.append("<TR style='WIDTH: 100%; HEIGHT: 100px'>\n");
					}
					if (menuItemMenuItemType.equals("0")) {
						sb.append("<TD id=subtd" + String.valueOf(pColumnIndex*100+i+1) + " style='WIDTH: 100%' align=middle uid='" + menuItemUID + "' pageuid='" + menuItemPageUID + "' canremove='" + menuItemCanRemove + "' canresize='" + menuItemCanResize + "' canreplace='" + menuItemCanReplace + "'><B>" + menuItemDisplayName + "</B></TD>\n");
					} else {
						sb.append("<TD id=subtd" + String.valueOf(pColumnIndex*100+i+1) + " style='WIDTH: 100%' align=middle uid='" + menuItemUID + "' pageuid='" + menuItemPageUID + "' canremove='" + menuItemCanRemove + "' canresize='" + menuItemCanResize + "' canreplace='" + menuItemCanReplace + "'>" + getRenderedTopMenuHTMLInsert(pTopMenuID, menuItemUID, "", "edit", userInfo) + "</TD>\n");
					}
                    sb.append("</TR>\n");
				} else {  // 보기모드 : HTML로 렌더링
					sb.append(getRenderedTopMenuHTMLInsert(pTopMenuID, menuItemUID, "", "view", userInfo));
				}
			}
			String strPage = sb.toString();
			
			return strPage;
		} catch (Exception e) {
			e.printStackTrace();
			return "";
		}
	}
	
	public String getRenderedTopMenuColumnInsert (String pCallingMenuID, String pTopMenuID , String pAccessIDList, int pColumnIndex, String pMode, LoginVO userInfo) {
		try {
			
			StringBuilder sb = new StringBuilder();
			String strSQL = "";
			String parentTopMenuID = pTopMenuID; // 자신의 상위페이지 ID
			
			int count = 0;
			
			strSQL = "SELECT * FROM ezPortal.TBL_TopMenu_Items  WHERE PageUID = '" + pTopMenuID + "' AND ColumnPos = " + pColumnIndex;
			
			while (count < 10) {
				parentTopMenuID = ezPortalDAO.getParentUID(parentTopMenuID);
				
				if (parentTopMenuID.toLowerCase().trim().equals("top")) {
					break;
				}
				String param = String.valueOf(count);
				strSQL += " UNION ALL SELECT * FROM ezPortal.TBL_TopMenu_Items  WHERE PageUID = '" + param + "' AND ColumnPos = " + parentTopMenuID;
				count ++;
			}

			List<PortalTBLTopMenuItemsVO> result = getTBLTopMenuItems(strSQL);
			
			if (result == null) {
				return "";
			}
			
			for (int i=0; i<result.size(); i++) {
				String menuItemMenuItemType = result.get(i).getMenuItemType();
				String menuItemUID = result.get(i).getuID();
				String menuItemPageUID = result.get(i).getPageUID();
				String menuItemDisplayName = result.get(i).getDisplayName();
				String menuItemHeight = result.get(i).getHeight();
				String menuItemCanRemove = result.get(i).getCanRemove();
				String menuItemCanResize = result.get(i).getCanResize();
				String menuItemCanReplace = result.get(i).getCanReplace();
				
				if (pMode.equals("edit")) {
					if (!menuItemHeight.toLowerCase().equals(""))	{
						sb.append("<TR style='WIDTH: 100%; HEIGHT: " + menuItemHeight + "px'>\n");
					} else  {
						sb.append("<TR style='WIDTH: 100%; HEIGHT: 100px'>\n");
					}
					if (menuItemMenuItemType.equals("0")) {
						sb.append("<TD id=subtd" + UUID.randomUUID().toString().substring(0, 4) + " style='WIDTH: 100%' align=middle uid='" + menuItemUID + "' pageuid='" + menuItemPageUID + "' canremove='" + menuItemCanRemove + "' canresize='" + menuItemCanResize + "' canreplace='" + menuItemCanReplace + "'><B>" + menuItemDisplayName + "</B></TD>\n");
					} else {
						sb.append("<TD id=subtd" + UUID.randomUUID().toString().substring(0, 4) + " style='WIDTH: 100%' align=middle uid='" + menuItemUID + "' pageuid='" + menuItemPageUID + "' canremove='" + menuItemCanRemove + "' canresize='" + menuItemCanResize + "' canreplace='" + menuItemCanReplace + "'>" + getRenderedTopMenuHTMLInsert(pTopMenuID, menuItemUID, "", "edit", userInfo) + "</TD>\n");
					}
                    sb.append("</TR>\n");
				} else { 
					if (menuItemMenuItemType.equals("0")) {
						sb.append(getMenuItemHTML(pCallingMenuID, menuItemUID, userInfo));
					} else {
						sb.append(getRenderedTopMenuHTMLInsert(pCallingMenuID, menuItemUID, "", "view", userInfo));
					}
				}
			}
			String strPage = sb.toString();
			
			return strPage;
		} catch (Exception e) {
			e.printStackTrace();
			return "";
		}
	}
	
	public String getRenderedTopMenuHTMLInsert (String pCallingMenuID, String pTopMenuID, String pAccessIDList, String pMode, LoginVO userInfo) {
		try {
			StringBuilder sb = new StringBuilder();
			
			String rootParentUID = topGetTopParentPageID(pTopMenuID);
			String boarderValue = "0";
			
			if (pMode.equals("edit")) {
				boarderValue = "1";
			}
			
			StringBuilder dsb = new StringBuilder();
			if (pMode.equals("edit")) {
				dsb.append("<table id='main_table_" + UUID.randomUUID().toString().substring(0, 4) + "' border=" + boarderValue + " cellpadding=0 cellspacing=0 width=100% height=100% style='table-layout:fixed;boarder-collapse:collapse'>\n");
                dsb.append("<tr id='main_row'>\n");
                dsb.append("<td id='td" + UUID.randomUUID().toString().substring(0, 4) + "' valign=top onclick='selectcell(event)'><table border=0 cellpadding=0 cellspacing=0 width=100% valign=top>\n");
                dsb.append("<TBODY>");
                dsb.append("<TR style='WIDTH: 100%; HEIGHT: 10px' onclick='selectcellTitle(event)'><td align=center>*</td></TR>");
                dsb.append("</TBODY></table></td>");
                dsb.append("</tr></table>");
			}
			
			String defaultValue = dsb.toString();
			dsb = null;
			
			PortalGetRenderedTopMenuInsertVO result = getRenderedTopMenuInsert(pTopMenuID);
			
			if (result == null) {
				return defaultValue;
			}
			
			String pageWidth = getTopMenuConfigItem("WIDTH",rootParentUID);
			String pageHeight = getTopMenuConfigItem("HEIGHT",rootParentUID);
			String pageColumnLength = getTopMenuConfigItem("COLUMNLENGTH",rootParentUID);
			String pageColumnSplit = getTopMenuConfigItem("COLUMNSPLIT",rootParentUID);
			
			if (pMode.equals("edit")) {
				sb.append("<table id='main_table_" + UUID.randomUUID().toString().substring(0, 4) + "' border=" + boarderValue + " cellpadding=0 cellspacing=0 ");
				if (!pageWidth.equals("0") && !pageWidth.equals("-1") && !pageWidth.equals("")) {
					sb.append("width=" + pageWidth + "px ");
				} else {
					sb.append("width=100% ");
				}
				if (!pageHeight.equals("0") && !pageHeight.equals("-1") && !pageHeight.equals("")) {
					sb.append("height=" + pageHeight + "px ");
				} else {
					sb.append("height=100% ");
				}
				sb.append("style='table-layout:fixed;'>\n");
                sb.append("<tr id='main_row'>\n");
			}
			
			for (int i=0; i<Integer.parseInt(pageColumnLength); i++) {
				if (pMode.equals("edit")) {
					String columnWidth = "*";
					if (i == Integer.parseInt(pageColumnLength) - 1) {
						sb.append("<TD id='td0" + UUID.randomUUID().toString().substring(0, 4) + "' vAlign=top>\n");
					} else {
						sb.append("<td id='td" + UUID.randomUUID().toString().substring(0, 4) + "' valign=top");
						if (!pageColumnSplit.equals("")) {
							if (!pageColumnSplit.split(";")[i].equals("") && !pageColumnSplit.split(";")[i].equals("*")) {
								columnWidth = pageColumnSplit.split(";")[i] + "px";
								sb.append(" style='width:" + columnWidth + "'>\n");
							}
						} else {
							sb.append(">\n");
						}
					}
					sb.append("<table border=" + boarderValue + " cellpadding=0 cellspacing=0 width=100% valign=top>\n");
                    sb.append("<TBODY>\n");
                    if (pMode == "edit") {
                    	sb.append("<TR style='WIDTH: 100%; HEIGHT: 10px' onclick='selectcellTitle(event)'><td align=center>" + columnWidth + "</td></TR>\n");
                    }
                    sb.append(getRenderedTopMenuColumnInsert(pCallingMenuID, pTopMenuID, pAccessIDList, i + 1, pMode, userInfo));
                    sb.append("</tbody>\n</table>\n</td>\n");
				} else {
					sb.append(getRenderedTopMenuColumnInsert(pCallingMenuID, pTopMenuID, pAccessIDList, i + 1, pMode, userInfo));
					}
				}
				if (pMode.equals("edit")) {
					sb.append("</tr>\n</table>\n");
				}
				String strPage = sb.toString();
				sb = null;
				
				return strPage;
			
		} catch (Exception e) {
			e.printStackTrace();
			return "";
		}
	}
		
	public boolean checkEditRightBln (String pUID, String pAccessIDList) {
		try {
			for (int i=0; i<pAccessIDList.split(",").length; i++) {
				int right = checkEditRight(pUID, pAccessIDList.split(",")[i].trim());
				if (right == 2) {
					return true;
				}
				if (right == 1) {
					return false;
				}
			}
			return false;
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}
	}
	
	public boolean checkViewRightBln (String pUID, String pAccessIDList) {
		try {
			for (int i=0; i<pAccessIDList.split("\\,").length; i++) {
				String right = checkViewRight(pUID, pAccessIDList.split("\\,")[i].trim());

				if (right != null && right.equals("2")) {
					return true;
				}
				if (right != null && right.equals("1")) {
					return false;
				}
			}
			return false;
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}
	}
	
	public String getUserInfo(String pUserID, String pUserName, String parentUID, String pGubunFlag, String pMode, LoginVO userInfo, String pCompanyID) {
		try {
			if (("edit").equals(pMode)) {
				if (checkEditRightBln(parentUID, getAccessList(userInfo)) == true) {
					String newPageID = UUID.randomUUID().toString();
					getUserInfo3(parentUID, "Y", pUserID, pGubunFlag, newPageID, pUserName, "everyone", "최상위회사", 2, 2, 2, pCompanyID);
				}
			}
			
			int resultNumber = getUserInfo4(pCompanyID, pUserID, pGubunFlag, "Y");
			
			List<PortalTBLPortalPageGeneralVO> resultXML = getUserInfo5(resultNumber, "Y", pCompanyID, parentUID, pUserID, pGubunFlag);
			
			String result = "";
			result = "<DATA>";
			for (int i=0; i<resultXML.size(); i++) {
				result += commonUtil.getQueryResult(resultXML.get(i));
			}
			result += "</DATA>";
			return result;
		} catch (Exception e) {
			e.printStackTrace();
			return "<DATA/>";
		}
	}
	
	public String searchMyPortalPage (String pGubunFlag, String pMode, LoginVO userInfo, String pCompanyID) {
		try {
			List<PortalTBLPortalPageGeneralVO> result = new ArrayList<PortalTBLPortalPageGeneralVO>();
			String strRight = "";
			if (pMode.equals("view")) {
				strRight = "B.View_Right=2";
			} else {
				strRight = "B.Edit_Right=2";
			}
			
			boolean bExist = false;
			String pAccessIDList = getAccessList(userInfo);
			
			for (int i=0; i<pAccessIDList.split(",").length; i++) {
				result = searchMyPortalPage2(pAccessIDList.split(",")[i].trim(), pGubunFlag, strRight, pCompanyID);
				if (result.size() > 0) {
					bExist = true;
				}
				
				if (bExist == true) {
					break;
				}
			}
			
			StringBuilder sb = new StringBuilder();
			sb.append("<DATA>");
			for (int i=0; i<result.size(); i++) {
				if (pMode.equals("view")) {
					if (checkViewRightBln(result.get(i).getuID().trim(), pAccessIDList) == true) {
						sb.append("<ROW>");
						sb.append("<UID_>" + result.get(i).getuID() + "</UID_>");
                        sb.append("<DISPLAYNAME>" + result.get(i).getDisplayName() + "</DISPLAYNAME>");
                        sb.append("<DEPTH>" + result.get(i).getDepth() + "</DEPTH>");
                        sb.append("<CREATEDATE>" + result.get(i).getCreateDate() + "</CREATEDATE>");
                        sb.append("<GUBUNFLAG>" + result.get(i).getGubunFlag() + "</GUBUNFLAG>");
                        sb.append("<USEFLAG>" + result.get(i).getUseFlag() + "</USEFLAG>");
                        sb.append("<DEFAULTPAGE>" + result.get(i).getDefaultPage() + "</DEFAULTPAGE>");
                        sb.append("<THEMEUID>" + result.get(i).getThemeUID() + "</THEMEUID>");
                        sb.append("</ROW>");
					}
				} else {
					if (checkEditRightBln(result.get(i).getuID().trim(), pAccessIDList) == true) {
						sb.append("<ROW>");
						sb.append("<UID_>" + result.get(i).getuID() + "</UID_>");
                        sb.append("<DISPLAYNAME>" + result.get(i).getDisplayName() + "</DISPLAYNAME>");
                        sb.append("<DEPTH>" + result.get(i).getDepth() + "</DEPTH>");
                        sb.append("<CREATEDATE>" + result.get(i).getCreateDate() + "</CREATEDATE>");
                        sb.append("<GUBUNFLAG>" + result.get(i).getGubunFlag() + "</GUBUNFLAG>");
                        sb.append("<USEFLAG>" + result.get(i).getUseFlag() + "</USEFLAG>");
                        sb.append("<DEFAULTPAGE>" + result.get(i).getDefaultPage() + "</DEFAULTPAGE>");
                        sb.append("<THEMEUID>" + result.get(i).getThemeUID() + "</THEMEUID>");
                        sb.append("</ROW>");
					}
				}
			}
			sb.append("</DATA>");
			
			return sb.toString();
		} catch (Exception e) {
			e.printStackTrace();
			return "<DATA/>";
		}
	}
	
	public String searchTopMenu (String pDisplayName, String pUseFlag, int pStartRow, int pEndRow, String pAccessIDList, String langStr, String pCompanyID) {
		try {
			List<PortalTBLTopMenuGeneralVO> resultList = topSearchTopMenu3(pEndRow, pDisplayName, pUseFlag, pCompanyID, langStr);
			
			StringBuilder sb = new StringBuilder();
			sb.append("<DATA>");
			
			for (int i=0; i<resultList.size(); i++) {
				if (i >= pStartRow - 1) {
					sb.append("<ROW>");
					sb.append("<UID_>" + resultList.get(i).getuID() + "</UID_>");
					sb.append("<DISPLAYNAME>" + resultList.get(i).getDisplayName() + "</DISPLAYNAME>");
                    sb.append("<DISPLAYNAME2>" + resultList.get(i).getDisplayName2() + "</DISPLAYNAME2>");
					sb.append("<USEFLAG>" + resultList.get(i).getUseFlag() + "</USEFLAG>");
					sb.append("<LANG>" + resultList.get(i).getLang() + "</LANG>");
                    sb.append("<THEMEUID>" + resultList.get(i).getThemeUID() + "</THEMEUID>");
					sb.append("</ROW>");
				}
			}
			sb.append("</DATA>");
			return sb.toString();
		} catch (Exception e) {
			e.printStackTrace();
			return "<DATA/>";
		}
	}
	
	public String searchTopMenu (String pDisplayName, String pUseFlag, int pStartRow, int pEndRow, String pAccessIDList, String pCompanyID) {
		try {
			List<PortalTopSearchTopMenu2VO> resultList = topSearchTopMenu2(pEndRow, pDisplayName, pUseFlag, pCompanyID);
			
			StringBuilder sb = new StringBuilder();
			sb.append("<DATA>");
			
			for (int i=0; i<resultList.size(); i++) {
				if (i >= pStartRow - 1) {
					sb.append("<ROW>");
					sb.append("<UID_>" + resultList.get(i).getuID() + "</UID_>");
					sb.append("<DISPLAYNAME>" + resultList.get(i).getDisplayName() + "</DISPLAYNAME>");
                    sb.append("<DISPLAYNAME2>" + resultList.get(i).getDisplayName2() + "</DISPLAYNAME2>");
					sb.append("<USEFLAG>" + resultList.get(i).getUseFlag() + "</USEFLAG>");
					sb.append("<LANG>" + resultList.get(i).getLang() + "</LANG>");
					sb.append("<THEMENM>" + resultList.get(i).getThemeNm() + "</THEMENM>");
					sb.append("<THEMENM2>" + resultList.get(i).getThemeNm2() + "</THEMENM2>");
					sb.append("<THEMENM3>" + resultList.get(i).getThemeNm3() + "</THEMENM3>");
					sb.append("<THEMENM4>" + resultList.get(i).getThemeNm4() + "</THEMENM4>");
					sb.append("</ROW>");
				}
			}
			sb.append("</DATA>");
			return sb.toString();
		} catch (Exception e) {
			e.printStackTrace();
			return "<DATA/>";
		}
	}
	
	public String getUserInfo (String pUserID, String langStr) {
		try {
			PortalTBLUserInfoVO result = topGetUserInfo2(pUserID, langStr);

			String resultXML = "<DATA>"+commonUtil.getQueryResult(result)+"</DATA>";

			if (resultXML.equals("<DATA></DATA>")) {
				resultXML = getUserInfo(pUserID);
			}
			return resultXML;	
		} catch (Exception e) {
			e.printStackTrace();
			return "<DATA/>";
		}
	}
		
	public String getUserInfo (String pUserID) {
		try {
			PortalTBLUserInfoVO result = topGetUserInfo(pUserID);
				
			String resultXML = "<DATA>"+commonUtil.getQueryResult(result)+"</DATA>";
				
			return resultXML;	
		} catch (Exception e) {
			e.printStackTrace();
			return "<DATA/>";
		}
	}
	
	public String getThemeInfoStr (String pThemeUID, String pGubun) {
		try {
			PortalTBLThemeGeneralVO result = getThemeInfo(pThemeUID, pGubun); 
			return commonUtil.getQueryResult(result);
		} catch (Exception e) {
			e.printStackTrace();
			return "ERROR";
		}
	}
	
	public String getMenuItemHTML (String pCallingMenuID, String pUID, LoginVO userInfo) throws Exception {
		try {
			String strHTML = "<iframe width=100% height=100% border=0 src='" + getMenuItemConfigItem("URL",pUID) + "' frameborder=0 scrolling=no></iframe>";
			
			int result = getMenuItemHtml(pUID);
			
			switch (result) {
			case 1:
				 strHTML = "<div class='logo'>";
				 strHTML += getLogoHTML(pCallingMenuID, pUID, userInfo);
                 strHTML += "</div>";
				break;
			case 2:
				strHTML = getUtilMenuHTML(pCallingMenuID, pUID, userInfo);
				break;
			case 3:
				strHTML = getMainMenuHTML(pCallingMenuID, pUID, userInfo);
				break;
			case 4:
				strHTML = getSubMenuHTML(pCallingMenuID, pUID, userInfo);
				break;
			case 5:
				strHTML = getSearchHTML(pCallingMenuID, pUID);
				break;
			case 7:
				strHTML = getUserInfoHTML(pCallingMenuID, pUID);
				break;
			default:
				break;
			}
			
			return strHTML;
		} catch (Exception e) {
			e.printStackTrace();
			return "<iframe width=100% height=100% border=0 src='" + getMenuItemConfigItem("URL",pUID) + "' frameborder=0 scrolling=no></iframe>";
		}
	}
	
	public String getLogoHTML (String pCallingMenuID, String pContentsUID, LoginVO userInfo) {
		try {
			String pUID = "";
			String pAccessIDList = getAccessList(userInfo);
			
			for (int i=0; i<pAccessIDList.split(",").length; i++) {
				pUID = getLogoHtml(pCallingMenuID, pAccessIDList.split(",")[i].trim());
				
				if (pUID != null) {
					break;
				}
			}
			return getImageHTML(pCallingMenuID, pUID, false, pContentsUID, userInfo);
		} catch (Exception e) {
			e.printStackTrace();
			return "";
		}
	}
	
	public String getImageHTML (String pCallingMenuID, String pUID, boolean pIncludeTD, String pContentsUID, LoginVO userInfo) {
		try {
			String pSkinNum = "";
			String strHTML = "";
			if (pContentsUID.equals("203")) {
				pSkinNum = this.gSkinNum;
			} else {
				pSkinNum = "1";
			}
			
			StringBuilder sb = new StringBuilder();
			PortalMenuItemItemsImageVO result = getImageHtml(pUID, pCallingMenuID, Integer.parseInt(pSkinNum));

			if (result != null) {
				String imageNormalImagePath = result.getNormalImagePath();
				String imageOverImagePath = result.getOverImagePath();
				int imageImageWidth = result.getImageWidth();
				int imageImageHeight = result.getImageHeight();
				String imageLinkURL = result.getLinkURL();
				String imageLinkLocation = result.getLinkLocation();
				String imageWindowOption = result.getWindowOption();
				
				if (imageNormalImagePath != null) {
					sb.append("<img src='" + imageNormalImagePath + "'");
					if (imageOverImagePath != null) {
						sb.append(" id=\"" + imageNormalImagePath.substring(imageNormalImagePath.lastIndexOf("/") + 1).split("\\.")[0] + "\" onmouseover=\"img_onMouseOver('" + imageOverImagePath + "', this);\" onmouseout=\"img_onMouseOut(this);\"" + " name=\'" + pContentsUID + "'");
					}
					if (imageLinkURL != null && !imageLinkURL.equals("")) {
						sb.append(" style='cursor:pointer'");
						sb.append(" onclick='OpenWindow(event, \"" + imageLinkURL + topLoadGetParameters(imageLinkURL, pUID, userInfo) + "\"");
						sb.append(", \"" + imageLinkLocation + "\"");
						sb.append(", \"" + imageWindowOption + "\")'");
					
					}
					if (imageImageWidth != 0 && "BASIC".equals(gTheme)) sb.append(" width='" + imageImageWidth + "'");
                    if (imageImageHeight != 0 && "BASIC".equals(gTheme)) sb.append(" height='" + imageImageHeight + "'");
					sb.append(">");
					strHTML = sb.toString();
					sb.delete(0, sb.length());
					
					if (pIncludeTD) {
						if (imageImageWidth != 0) {
							sb.append("<td width=\"" + imageImageWidth + "\">" + strHTML + "</td>");
						} else {
							sb.append("<td>" + strHTML + "</td>");
						}
					} else {
						sb.append(strHTML);
					}
				}
				
			}

			return sb.toString();

		} catch (Exception e) {
			e.printStackTrace();
			return "";
		}
	}
	
	public String topLoadGetParameters (String pURL, String pMenuItemID, LoginVO userInfo) {
		try {
			List<PortalTopLoadGetParametersVO> result = topLoadGetParameters(pMenuItemID);
			
			String userInfoXML = "<DATA>"+commonUtil.getQueryResult(userInfo)+"</DATA>";
			Document xmlDomUserInfo = commonUtil.convertStringToDocument(userInfoXML);
			String strParam = "";
			
			for (int i=0; i<result.size(); i++) {
				if (pURL.indexOf("?") == -1) {
					if (strParam == null || strParam.equals("")) {
						strParam += "?";
					} else {
						strParam += "&";
					}
				} else {
					strParam += "&";
				}
				
				if (result.get(i).getParamType() == 0) {
					strParam += result.get(i).getParamName() + "=" + result.get(i).getParamValue();
				} else {
					strParam += result.get(i).getParamName() + "=" + xmlDomUserInfo.getElementsByTagName(result.get(i).getParamInfo());
				}
				
			}
			return strParam;
		} catch (Exception e) {
			e.printStackTrace();
			return "";
		}
	}
	
	public String loadGetParameters (String pURL, String pPortletID, LoginVO userInfo) {
		try {
			List<PortalTopLoadGetParametersVO> result = loadGetParameters(pPortletID);
			
			String userInfoXML = "<DATA>"+commonUtil.getQueryResult(userInfo)+"</DATA>";
			Document xmlDomUserInfo = commonUtil.convertStringToDocument(userInfoXML);
			String strParam = "";
			
			for (int i=0; i<result.size(); i++) {
				if (pURL.indexOf("?") == -1) {
					if (strParam == null || strParam.equals("")) {
						strParam += "?";
					} else {
						strParam += "&";
					}
				} else {
					strParam += "&";
				}
				
				if (result.get(i).getParamType() == 0) {
					strParam += result.get(i).getParamName() + "=" + result.get(i).getParamValue();
				} else {
					strParam += result.get(i).getParamName() + "=" + xmlDomUserInfo.getElementsByTagName(result.get(i).getParamInfo());
				}
				
			}
			return strParam;
		} catch (Exception e) {
			e.printStackTrace();
			return "";
		}
	}
	
	public String loadGetParametersXML (String pURL, String pXML, LoginVO userInfo) {
		try {
			
			String userInfoXML = "<DATA>"+commonUtil.getQueryResult(userInfo)+"</DATA>";
			Document xmlDomUserInfo = commonUtil.convertStringToDocument(userInfoXML);
			String strParam = "";
			
			Document xmlDom = commonUtil.convertStringToDocument(pXML);
			
			for (int i=0; i<xmlDom.getElementsByTagName("PARAMNAME").getLength(); i++) {
				if (pURL.indexOf("?") == -1) {
					if (strParam == null || strParam.equals("")) {
						strParam += "?";
					} else {
						strParam += "&";
					}
				} else {
					strParam += "&";
				}
				
				if (xmlDom.getElementsByTagName("PARAMTYPE").item(i).getTextContent().equals("0")) {
					strParam += xmlDom.getElementsByTagName("PARAMNAME").item(i).getTextContent() + "=" + xmlDom.getElementsByTagName("PARAMVALUE").item(i).getTextContent();
				} else {
					strParam += xmlDom.getElementsByTagName("PARAMNAME").item(i).getTextContent() + "=" + xmlDomUserInfo.getElementsByTagName(xmlDom.getElementsByTagName("PARAMINFO").item(i).getTextContent()).item(0).getTextContent();
				}
				
			}
			return strParam;
		} catch (Exception e) {
			e.printStackTrace();
			return "";
		}
	}
	
	public String getUtilMenuHTML (String pCallingMenuID, String pUID, LoginVO userInfo) {
		try {
			List<PortalMenuItemItemsMenuItemsVO> result = getUtilMenuHtml(pUID, pCallingMenuID);
			
			StringBuilder sb = new StringBuilder();
			sb.append("<article class='utmenu'>\n");
			sb.append("<ul>\n");
			
			String lastLogout = "";

			for (int i=0; i<result.size(); i++) {
				if (checkViewRightBln(result.get(i).getuID(), getAccessList(userInfo)) == false) {
					continue;
				}
				
				String menuitemDisplayName = result.get(i).getDisplayName();
				String menuitemImageUID = result.get(i).getImageUId();
				String menuitemLinkURL = result.get(i).getLinkURL();
				String menuitemLinkLocation = result.get(i).getLinkLocation();
				String menuitemWindowOption = result.get(i).getWindowOption();
				
				if (i == result.size() - 1) {
					lastLogout = "class='btn_logout'";
				}
				
				if (menuitemImageUID != null && !menuitemImageUID.trim().equals("")) {
					sb.append(getUtilImageHTML(menuitemDisplayName, pCallingMenuID, menuitemImageUID, lastLogout, pUID, userInfo) + "\n");
				} else {
					if (menuitemLinkURL != null && !menuitemLinkURL.trim().equals("")) {
						if (i == result.size() - 1) {
							sb.append("<li " + lastLogout + "><span style='cursor:pointer' onclick='top.location.href = \"" + menuitemLinkURL + "\"'>" + menuitemDisplayName +"</span></li>\n");
						} else {
							sb.append("<li " + lastLogout + "><span style='cursor:pointer' onclick='OpenWindow(event, \"" + menuitemLinkURL + topLoadGetParameters(menuitemLinkURL, result.get(i).getuID(), userInfo) + "\"");
							sb.append(", \"" + menuitemLinkLocation + "\"");
	                        sb.append(", \"" + menuitemWindowOption.trim() + "\")'>" + menuitemDisplayName + "</span></li>\n");
						}
                          
					} else {
						sb.append("<li " + lastLogout + ">" + menuitemDisplayName + "</li>\n");
					}
				}
			}
			sb.append("</ul></article>\n");
			return sb.toString();
		} catch (Exception e) {
			e.printStackTrace();
			return "";
		}
	}
	
	public String getMainMenuHTML (String pCallingMenuID, String pUID, LoginVO userInfo) {
		try {
			List<PortalGetMainMenuHtmlVO> result = getMainMenuHtml(pUID, pCallingMenuID, Integer.parseInt(gSkinNum));
			

			StringBuilder sb = new StringBuilder();
            if (gTheme.equals("BASIC")) {
            	sb.append("</header>\n");
            }
			sb.append("<nav>\n");
            sb.append("<ul class='topmenu'>");
            
            for (int i=0; i<result.size(); i++) {
				if (!checkViewRightBln(result.get(i).getuID(), getAccessList(userInfo))) {
					continue;
				}
				
				String menuitemUID = result.get(i).getuID();
				String menuitemDisplayName = result.get(i).getDisplayName();
				String menuitemImageUID = result.get(i).getImageUId();
				String menuitemLinkURL = result.get(i).getLinkURL();
				String menuitemLinkLocation = result.get(i).getLinkLocation();
				String menuitemWindowOption = result.get(i).getWindowOption();
				String menuitemNormalImagePath = result.get(i).getNormalImagePath();

				if (!menuitemImageUID.trim().equals("") && !menuitemNormalImagePath.trim().equals("")) {
					sb.append("<li>" + getImageHTML(pCallingMenuID, menuitemImageUID, false, menuitemUID, userInfo) + "</li>");
				} else {
					sb.append("<li ");
					
					if (!menuitemLinkURL.trim().equals("")) {
                        sb.append(" onclick='OpenWindow(event, \"" + menuitemLinkURL + topLoadGetParameters(menuitemLinkURL, result.get(i).getuID(), userInfo) + "\"");
						sb.append(", \"" + menuitemLinkLocation + "\"");
						sb.append(", \"" + menuitemWindowOption.trim() + "\")'");
					}
					
					sb.append(">" + menuitemDisplayName + "</li>");
				}
            }
            
            sb.append("</ul></nav>");
			return sb.toString();
		} catch (Exception e) {
			e.printStackTrace();
			return "";
		}
	}
	
	public String getSubMenuHTML (String pCallingMenuID, String pUID, LoginVO userInfo) {
		try {
			List<PortalMenuItemItemsMenuItemsVO> result = getSubMenuHtml(pCallingMenuID, pUID);
			
			StringBuilder sb = new StringBuilder();
			sb.append(" <div class=\"topSubMenu\">");
			
			for (int i=0; i<result.size(); i++) {
				String leftMargin = result.get(i).getLeftMargin();
				List<PortalMenuItemItemsMenuItemsSVO> result2 = getSubMenuHtml2(result.get(i).getParentMenuID());
				
				if (result2.size() == 0) {
					 sb.append("<ul id=\"menu" + result.get(i).getParentMenuID() + "\" id=\"menu01_sub\" style=\"DISPLAY:none;top:0px;left:" + leftMargin + "px\"></ul>");
					continue;
				}
				String parentMenuID = result2.get(0).getParentMenuID();
				sb.append("<ul id=\"menu_" + parentMenuID + "\" id=\"menu01_sub\" style=\"DISPLAY:none;top:0px;left:" + leftMargin + "px\" onmouseover=\"submenuover()\" onmouseout=\"submenuout()\"><li class=\"left\">");
				for (int j=0; j<result2.size(); j++) {
					if (!checkViewRightBln(result2.get(j).getuID(), getAccessList(userInfo))) {
						continue;
					}
					String menuitemDisplayName = result2.get(j).getDisplayName();
					String menuitemImageUID = result2.get(j).getImageUId();
					String menuitemLinkURL = result2.get(j).getLinkURL();
					String menuitemLinkLocation = result2.get(j).getLinkLocation();
					String menuitemWindowOption = result2.get(j).getWindowOption();
					
					if (menuitemImageUID != null && !menuitemImageUID.trim().equals("")) {
						sb.append("<li class=\"subtd\">" + getImageHTML(pCallingMenuID, menuitemImageUID, false, pUID, userInfo) + "</li>\n");
					} else {
						sb.append("<li onclick=\"javascript:submenuclick('" + result2.get(j).getuID() + "');OpenWindow(event, '" + menuitemLinkURL + topLoadGetParameters(menuitemLinkURL, result2.get(j).getuID(), userInfo) + "', '" + menuitemLinkLocation + "', '" + menuitemWindowOption + "')\">" + menuitemDisplayName + "</li>\n");
					}
				}
				sb.append("<li class=\"right\"></ul>");
			}
			sb.append("</div>\n");
			return sb.toString();
		} catch (Exception e) {
			e.printStackTrace();
			return "";
		}
	}
	
	public String getSearchHTML (String pCallingMenuID, String pUID) {
		try {
			  StringBuilder searchHTML = new StringBuilder();
              searchHTML.append("<div class='top_search'>\n");
              searchHTML.append("<input id='input_search' class='input_text' type='text' onfocus=\"this.className='input_text focus'; \" onblur='input_Onblur(this)' onkeyup='Key_event(event);' onmousedown='keyword_Clear(this);' />");
              searchHTML.append("<input type='image' src='/images/kr/cm/top_search_btn.gif' alt='' class='topsearch_btn' onclick='Emp_Search()'>");
              searchHTML.append("</div>");
			return searchHTML.toString();
		} catch (Exception e) {
			e.printStackTrace();
			return "";
		}
	}
	
	public String getUserInfoHTML (String pCallingMenuID, String pUID) {
		try {
			 StringBuilder searchHTML = new StringBuilder();
             searchHTML.append("<div class='top_search'>\n");
             searchHTML.append("<input id='input_search' class='input_text' type='text'  onfocus=\"this.className='input_text focus'; \" onblur='input_Onblur(this)' onkeyup='Key_event(event);' onmousedown='keyword_Clear(this);'/>");
             searchHTML.append("<input type='image' src='/images/kr/cm/top_search_btn.gif' alt=''  class='topsearch_btn ' onclick='Emp_Search()'>");
             searchHTML.append("</div>");
			return searchHTML.toString();
		} catch (Exception e) {
			e.printStackTrace();
			return "";
		}
	}
	
	public String getUtilImageHTML (String menuItemDisplayName, String pCallingMenuID, String pUID, String logoutclass, String pContentsUID, LoginVO userInfo) {
		try {
			String pSkinNum = "";
			String strHTML = "";
			if (pContentsUID.equals("203")) {
				pSkinNum = this.gSkinNum;
			} else {
				pSkinNum = "1";
			}
			
			StringBuilder sb = new StringBuilder();
			
			PortalMenuItemItemsImageVO result = getImageHtml(pUID, pCallingMenuID, Integer.parseInt(pSkinNum));

			if (result != null) {
                String imageNormalImagePath = result.getNormalImagePath();
                String imageOverImagePath = result.getOverImagePath();
                int imageImageWidth = result.getImageWidth();
                int imageImageHeight = result.getImageHeight();
                String imageLinkURL = result.getLinkURL();
                String imageLinkLocation = result.getLinkLocation();
                String imageWindowOption = result.getWindowOption();
                
                if (imageNormalImagePath != null) {
                	sb.append("<li><img src='" + imageNormalImagePath + "'");
                    if (imageOverImagePath != "") {
                    	sb.append(" id=\"" + imageNormalImagePath.substring(imageNormalImagePath.lastIndexOf("/") + 1).split("\\.")[0] + "\" onmouseover=\"img_onMouseOver('" + imageOverImagePath + "', this);\" onmouseout=\"img_onMouseOut(this);\"");
                    }
                    if (!imageLinkURL.equals("")) {
                        sb.append(" style='cursor:pointer'");
                        sb.append(" onclick='OpenWindow(event, \"" + imageLinkURL + topLoadGetParameters(imageLinkURL, pUID, userInfo) + "\"");
                        sb.append(", \"" + imageLinkLocation + "\"");
                        sb.append(", \"" + imageWindowOption + "\")'");
                    }
                    if (imageImageWidth != 0 && gTheme.equals("BASIC")) {
                    	sb.append(" width='" + imageImageWidth + "'");
                    }
                    if (imageImageHeight != 0 && gTheme.equals("BASIC")) {
                    	sb.append(" height='" + imageImageHeight + "'");
                    }
                    sb.append("></li>\n");
                    strHTML = sb.toString();

                    sb.delete(0, sb.length());
                    sb.append(strHTML);
                }
			}
			
			return sb.toString();
		} catch (Exception e) {
			e.printStackTrace();
			return "";
		}
	}
	
	public String getDefaultPortalPage() {
		try {
			StringBuilder sb = new StringBuilder();
            sb.append("<table id='main_table' border=1 cellpadding=0 cellspacing=0 width=100% height=500px style='table-layout:fixed;boarder-collapse:collapse'>\n");
            sb.append("<tr id='main_row'>\n");
            sb.append("<td id='td0' valign=top onclick='selectcell(event)'><table border=1 cellpadding=0 cellspacing=0 width=100% valign=top>\n");
            sb.append("<TBODY>");
            sb.append("<TR style='WIDTH: 100%; HEIGHT: 10px' onclick='selectcellTitle(event)'><td align=center>*</td></TR>");
            sb.append("</TBODY></table></td>");
            sb.append("</tr></table>");

            String strPage = sb.toString();
			return strPage;
		} catch (Exception e) {
			e.printStackTrace();
			return "";
		}
	}
	
	public String getRenderedPortalPageHTML (String pPortalPageID, String pAccessIDList, String pMode, LoginVO userInfo, String pTheme, String pTableViewOption) {
		try {
			if (pTheme != null && !pTheme.trim().equals("")) {
				this.gTheme = pTheme;
			}
			
			if (pTableViewOption != null && !pTableViewOption.trim().equals("")) {
				this.gTableViewOption = pTableViewOption;
			}
			
			if (pMode.equals("view")) {
				if (!checkViewRightBln(pPortalPageID, getAccessList(userInfo))) {
					return "<table width=100% height=100% border=0><tr><td align=center>페이지를 볼 권한이 없습니다.</td></tr></table>";
				}
				String cacheValue = checkCacheValue(pPortalPageID, getAccessList(userInfo));

				if (cacheValue != null && !cacheValue.trim().equals("")) {
					return cacheValue;
				}
			}
		
			StringBuilder sb = new StringBuilder();
            String pageWidth, pageHeight, pageColumnLength, pageColumnSplit;

            String RootParentUID = getTopParentPageIDStr(pPortalPageID);

            String boarderValue = "0";
            int i= 0;
            if (pPortalPageID.equals(RootParentUID)) {
            	bRootPage = true;

            }
            if (pMode.equals("edit")) {
            	boarderValue = "1";
            }

            StringBuilder dsb = new StringBuilder();
            dsb.append("<table id='main_table' border=" + boarderValue + " cellpadding=0 cellspacing=0 width=100% height=100% style='table-layout:fixed;boarder-collapse:collapse'>\n");
            dsb.append("<tr id='main_row'>\n");
            dsb.append("<td id='td0' valign=top onclick='selectcell(event)'><table border=" + boarderValue + " cellpadding=0 cellspacing=0 width=100% valign=top>\n");
            dsb.append("<TBODY>");
            if (pMode.equals("edit")) {
            	dsb.append("<TR style='WIDTH: 100%; HEIGHT: 10px' onclick='selectcellTitle(event)'><td align=center>*</td></TR>");
            }
            dsb.append("</TBODY></table></td>");
            dsb.append("</tr></table>");
            
            String defaultValue = dsb.toString();

            PortalGetRenderedTopMenuInsertVO result = getRenderedPortalPageHtml(pPortalPageID);

            if (result == null) {
            	return defaultValue;
            }
            
            pageWidth = getPortalConfigItem("Width",RootParentUID);
            pageHeight = getPortalConfigItem("Height",RootParentUID);
            pageColumnLength = getPortalConfigItem("ColumnLength",RootParentUID);
            pageColumnSplit = getPortalConfigItem("ColumnSplit",RootParentUID);

            if (pMode.equals("edit")) {
            	sb.append("<table id='main_table' border=" + boarderValue + " cellpadding=0 cellspacing=0 ");
                if (!("-1").equals(pageWidth) && !("0").equals(pageWidth) && !("").equals(pageWidth) && pageWidth.toLowerCase().equals("null")) sb.append("width=" + pageWidth + "px ");
                else sb.append("width=100% ");
                if (!("-1").equals(pageHeight) && !("0").equals(pageHeight) && !("").equals(pageHeight) && pageHeight.toLowerCase().equals("null")) sb.append("height=" + pageHeight + "px ");
                else sb.append("height=100% ");
                sb.append("style='table-layout:fixed;'>\n");
                sb.append("<tr id='main_row'>\n");
            } else {
            	if (gTheme.equals("BASIC")) {
            		sb.append("<div id='Center'>");
            	}
            }
            	for (i=0; i<Integer.parseInt(pageColumnLength); i++) {
            		if (pMode.equals("edit")) {
            			String columnWidth = "*";
            			if (i == Integer.parseInt(pageColumnLength) - 1) {
            				sb.append("<TD id=td0 vAlign=top");
            				if (!pageColumnSplit.equals("")) {
            					if (!pageColumnSplit.split(";")[i].equals("") && !pageColumnSplit.split(";")[i].equals("*")) {
            						columnWidth = pageColumnSplit.split(";")[i] + "px";
            						if (columnWidth.equals("9999px")) {
            							sb.append(">\n");
            						} else {
            							sb.append(" style='width:" + columnWidth + "'>\n");
            						}
            					} else {
            						sb.append(">\n");
            					}
            				} else {
            					sb.append(">\n");
            				}
            			} else {
            				sb.append("<td id='td" + String.valueOf(i + 1) + "' valign=top");
            				if (!pageColumnSplit.equals("")) {
            					if (!pageColumnSplit.split(";")[i].equals("") && !pageColumnSplit.split(";")[i].equals("*")) {
            						columnWidth = pageColumnSplit.split(";")[i] + "px";
            						if (columnWidth.equals("9999px")) {
            							sb.append(">\n");
            						} else {
            							sb.append(" style='width:" + columnWidth + "'>\n");
            						}
            					}
            				} else {
            					sb.append(">\n");
            				}
            			} 
            			sb.append("<table border=" + boarderValue + " cellpadding=0 cellspacing=0 width=100% valign=top>\n");
                        sb.append("<TBODY>\n");
                        if (columnWidth.equals("9999px")) {
                        	columnWidth = "*";
                        }
                        if (pMode.equals("edit")) {
                        	sb.append("<TR style='WIDTH: 100%; HEIGHT: 10px' onclick='selectcellTitle(event)'><td align=center>" + columnWidth + "</td></TR>\n");
                        	sb.append(getRenderedPortalPageColumn(pPortalPageID, pAccessIDList, i + 1, pMode, userInfo));
                            sb.append("</tbody>\n</table>\n</td>\n");
                        }
            		} else {
            			sb.append(getRenderedPortalPageColumn(pPortalPageID, pAccessIDList, i + 1, pMode, userInfo));
            		}
            	}
            	
            	if (pMode.equals("edit")) {
            		sb.append("</tr>\n</table>\n");
            	} else {
            		sb.append("</div>");
            	}
            	if (pMode.equals("view")) {
            		updateCacheValue(pPortalPageID, getAccessList(userInfo), sb.toString());
            	}

			return sb.toString();
		} catch (Exception e) {
			e.printStackTrace();
			return "";
		}
	}
	
	public String getRenderedPortalPageHTMLInsert (String pCallingPageID , String pPortalPageID, String pAccessIDList, String pMode, LoginVO userInfo) {
		try {
			StringBuilder sb = new StringBuilder();
           
            String pageWidth, pageHeight, pageColumnLength,	pageColumnSplit;
            String RootParentUID = getTopParentPageIDStr(pPortalPageID);
            String boarderValue = "0";
            int i= 0;
            if (pPortalPageID.equals(RootParentUID)) {
            	bRootPage = true;
            }
            if (pMode.equals("edit")) {
            	boarderValue = "1";
            }
            
            StringBuilder dsb = new StringBuilder();
            dsb.append("<table id='main_table_"+ UUID.randomUUID().toString().substring(0, 4)  +"' border=" + boarderValue + " cellpadding=0 cellspacing=0 width=100% height=100% style='table-layout:fixed;boarder-collapse:collapse'>\n");
            dsb.append("<tr id='main_row'>\n");
            dsb.append("<td id='td"+ UUID.randomUUID().toString().substring(0, 4) +"' valign=top onclick='selectcell(event)'><table border=0 cellpadding=0 cellspacing=0 width=100% valign=top>\n");
            dsb.append("<TBODY>");
            if (pMode.equals("edit")) dsb.append("<TR style='WIDTH: 100%; HEIGHT: 10px' onclick='selectcellTitle(event)'><td align=center>*</td></TR>");
            dsb.append("</TBODY></table></td>");
            dsb.append("</tr></table>");
            String defaultValue = dsb.toString();
            
            PortalGetRenderedTopMenuInsertVO result = getRenderedPortalPageHtml(pPortalPageID);
            
            if (result == null) {
            	return defaultValue;
            }
            
            pageWidth = getPortalConfigItem("Width",RootParentUID);
            pageHeight = getPortalConfigItem("Height",RootParentUID);
            pageColumnLength = getPortalConfigItem("ColumnLength",RootParentUID);
            pageColumnSplit = getPortalConfigItem("ColumnSplit",RootParentUID);
            
            if (pMode.equals("edit")) {
            	sb.append("<table id='main_table_"+ UUID.randomUUID().toString().substring(0, 4) +"' border=" + boarderValue + " cellpadding=0 cellspacing=0 ");
                if (!("-1").equals(pageWidth) && !("0").equals(pageWidth) && !("").equals(pageWidth) && pageWidth.toLowerCase().equals("null")) sb.append("width=" + pageWidth + "px ");
                else sb.append("width=100% ");
                if (!("-1").equals(pageHeight) && !("0").equals(pageHeight) && !("").equals(pageHeight) && pageHeight.toLowerCase().equals("null")) sb.append("height=" + pageHeight + "px ");
                else sb.append("height=100% ");
                sb.append("style='table-layout:fixed;'>\n");
                sb.append("<tr id='main_row'>\n");
            } else {
            	for (i=0; i<Integer.parseInt(pageColumnLength); i++) {
            		if (pMode.equals("edit")) {
            			String columnWidth = "*";
            			if (i == Integer.parseInt(pageColumnLength) - 1) {
            				if (i ==0) {
            					sb.append("<TD id=td0"+UUID.randomUUID().toString().substring(0, 4) +"' vAlign=top>\n");
            				} else {
            					sb.append("<TD id=td0"+UUID.randomUUID().toString().substring(0, 4) +"' valign=top");
            				}
            				
            				if (!pageColumnSplit.equals("")) {
            					if (!pageColumnSplit.split(";")[i].equals("") && !pageColumnSplit.split(";")[i].equals("*")) {
            						columnWidth = pageColumnSplit.split(";")[i] + "px";
            						if (columnWidth.equals("9999px")) {
            							sb.append(">\n");
            						} else {
            							sb.append(" style='width:" + columnWidth + "'>\n");
            						}
            					} 
            				} else {
            					sb.append(">\n");
            				}
            			} else {
            				sb.append("<td id='td" + UUID.randomUUID().toString().substring(0, 4) + "' valign=top");
            				if (!pageColumnSplit.equals("")) {
            					if (!pageColumnSplit.split(";")[i].equals("") && !pageColumnSplit.split(";")[i].equals("*")) {
            						columnWidth = pageColumnSplit.split(";")[i] + "px";
            						if (columnWidth.equals("9999px")) {
            							sb.append(">\n");
            						} else {
            							sb.append(" style='width:" + columnWidth + "'>\n");
            						}
            					}
            				} else {
            					sb.append(">\n");
            				}
            			} 
            			sb.append("<table border=" + boarderValue + " cellpadding=0 cellspacing=0 width=100% valign=top>\n");
                        sb.append("<TBODY>\n");
                        if (columnWidth.equals("9999px")) {
                        	columnWidth = "*";
                        }
                        if (pMode.equals("edit")) {
                        	sb.append("<TR style='WIDTH: 100%; HEIGHT: 10px' onclick='selectcellTitle(event)'><td align=center>" + columnWidth + "</td></TR>\n");
                        	sb.append(getRenderedPortalPageColumnInsert(pPortalPageID, pCallingPageID, pAccessIDList, i + 1, pMode, userInfo));
                            sb.append("</tbody>\n</table>\n</td>\n");
                        }
            		} else {
            			if (gTableViewOption.equals("D")) {
            				sb.append(getRenderedPortalPageColumnInsert(pPortalPageID, pCallingPageID, pAccessIDList, i + 1, pMode, userInfo));
            			} else {
            				String columnWidth = "*";
                			if (i == Integer.parseInt(pageColumnLength) - 1) {
               					sb.append("<TD id=td0"+UUID.randomUUID().toString().substring(0, 4) +"' vAlign=top style='padding-left:20px;'>\n");
                			} else {
                				sb.append("<TD id=td0"+UUID.randomUUID().toString().substring(0, 4) +"' valign=top");
                				if (!pageColumnSplit.equals("")) {
                					if (!pageColumnSplit.split(";")[i].equals("") && !pageColumnSplit.split(";")[i].equals("*")) {
                						columnWidth = pageColumnSplit.split(";")[i] + "px";
                						if (columnWidth.equals("9999px")) {
                							columnWidth = "100%";
                							if (i == 0) {
                								sb.append(" style='width:" + columnWidth + ";padding-right:20px;padding-left:5px;'>\n");
                							} else {
                								sb.append(" style='width:" + columnWidth + "'>\n");
                							}
                						} 
                					} 
                				} else {
                					sb.append(">\n");
                				}
                			}
                			if (pMode == "edit") sb.append(columnWidth);
                            sb.append(getRenderedPortalPageColumnInsert(pPortalPageID, pCallingPageID, pAccessIDList, i + 1, pMode, userInfo));
                            sb.append("</td>\n");
            			}
            		}
            	}
            	if (pMode.equals("edit")) {
    				sb.append("</tr>\n</table>\n");
    			}
            }
            
			return sb.toString();
		} catch (Exception e) {
			e.printStackTrace();
			return "";
		}
	}
	
	public String getTopParentPageIDStr (String pPortalPageID) {
		try {
			String temp = pPortalPageID;
			String parentPortalPageID = "";
			String previousPageID = pPortalPageID;
			int count = 0;
			while (count < 10) {
				parentPortalPageID = getTopParentPageID(temp);
				
				if (parentPortalPageID != null && parentPortalPageID.toLowerCase().trim().equals("top")) {
					break;
				}
				if (parentPortalPageID == null || parentPortalPageID.trim().equals("")) {
					temp = previousPageID;
					break;
				} else {
					previousPageID = temp;
					temp = parentPortalPageID;
				}
				count++;
			}
			return temp;
		} catch (Exception e) {
			e.printStackTrace();
			return "";
		}
	}
	
	public String getRenderedPortalPageColumn (String pPortalPageID, String pAccessIDList, int pColumnIndex, String pMode, LoginVO userInfo) {
		try {
			List<PortalTBLPortalPageItemsVO> result = new ArrayList<PortalTBLPortalPageItemsVO>();
			StringBuilder sb = new StringBuilder();
			String strSQL = "";
            
            String parentPortalPageID = pPortalPageID;
            int count = 0;

            strSQL = "SELECT * FROM ezPortal.TBL_PortalPage_Items  WHERE PageUID = '"+pPortalPageID+"' AND ColumnPos = " + pColumnIndex;
            
            while (count < 10) {
            	parentPortalPageID = getPortalParentUID(parentPortalPageID);

            	if (parentPortalPageID != null && parentPortalPageID.toLowerCase().trim().equals("top")) {
            		break;
            	}
            	//String param = String.valueOf(count);
            	String param = parentPortalPageID;
            	strSQL += " UNION ALL SELECT * FROM ezPortal.TBL_PortalPage_Items  WHERE PageUID = '" + param + "' AND ColumnPos = " + pColumnIndex;
            	count ++;
            }
            
            if (bRootPage == true) {
            	result = getTBLPortalPageItemsT(strSQL);
            } else {
            	result = getTBLPortalPageItemsF(strSQL, userInfo.getId(), getTopParentPageIDStr(pPortalPageID));

            }

            if (result == null) {
            	return "";
            }
            
            boolean loadFlag = true;
            
            for (int i=0; i<result.size(); i++) {
            	int portletType = result.get(i).getPortletType();
            	String portletUID = result.get(i).getuID();
            	String portletPageUID = result.get(i).getPageUID();
            	String portletDisplayName = result.get(i).getDisplayName();
            	int portletWidth = result.get(i).getWidth();
            	int portletHeight = result.get(i).getHeight();
            	int portletCanRemove = result.get(i).getCanRemove();
            	int portletCanResize = result.get(i).getCanResize();
            	int portletCanReplace = result.get(i).getCanRemove();
            	int portletPaddingLeft = result.get(i).getLeftMargin();
            	int portletPaddingRight = result.get(i).getRightMargin();
            	int portletPaddingTop = result.get(i).getTopMargin();
            	int portletPaddingBottom = result.get(i).getBottomMargin();
            	String portletOwnerPageUID = result.get(i).getOwnerPageUID();
            	String portletMandatory = result.get(i).getMandatory();
            	String portletMoveURL = "";
            	
            	if (pMode.equals("edit")) {
            		if (portletHeight != 0) {
            			sb.append("<TR style='WIDTH: 100%; HEIGHT: " + portletHeight + "px'>\n");
            		} else {
            			sb.append("<TR style='WIDTH: 100%; HEIGHT: 100px'>\n");
            		}
      		
            		if (portletType == 0) {
            			if (checkViewRightBln(portletUID, getAccessList(userInfo)) == true) {
            				sb.append("<TD id=subtd" + String.valueOf(pColumnIndex * 100 + i + 1) + " style='WIDTH: 100%; HEIGHT:" + portletHeight + "' align=middle uid='" + portletUID + "' pageuid='" + portletPageUID + "' ownerpageuid='" + portletOwnerPageUID + "' mandatory='" + portletMandatory + "' canremove='" + portletCanRemove + "' canresize='" + portletCanResize + "' canreplace='" + portletCanReplace + "'><B>" + portletDisplayName + "</B></TD>\n");
            			}
            		} else {
            			sb.append("<TD id=subtd" + String.valueOf(pColumnIndex * 100 + i + 1) + " style='WIDTH: 100%; HEIGHT:" + portletHeight + "' align=middle uid='" + portletUID + "' pageuid='" + portletPageUID + "' ownerpageuid='" + portletOwnerPageUID + "' canremove='" + portletCanRemove + "' canresize='" + portletCanResize + "' canreplace='" + portletCanReplace + "'>" + getRenderedPortalPageHTMLInsert(pPortalPageID, portletUID, "", "edit", userInfo) + "</TD>\n");
            		}
            		sb.append("</TR>\n");
            	} else {
            		if (gTableViewOption.equals("D")) {
            			if (i == 0) {
            				sb.append("<div class='section1_bg'><section class='section1'>\n");
            			} else {
            				if (!gTheme.equals("BASIC") && loadFlag) {
            					sb.append("<div id='Center'>");
                                loadFlag = false;
            				}
            				
            				sb.append("<section class='section" + (i + 1) + "'>\n");
            			}
            			if (portletType == 0) {
            				if (checkViewRightBln(portletUID, getAccessList(userInfo)) == true) {
            					portletMoveURL = getPortletConfigItem("URL",portletUID);
            					sb.append("<iframe width='" + portletWidth + "' height=" + portletHeight + " border=0 src='" + portletMoveURL + loadGetParameters(portletMoveURL, portletUID, userInfo) + "' frameborder=0 scrolling=no></iframe>\n");
            				}
            			} else {
            				sb.append(getRenderedPortalPageHTMLInsert(pPortalPageID, portletUID, "", "view", userInfo) + "\n");
            			}
            			if (i == 0) {
            				sb.append("</section></div>\n");
            			} else {
            				sb.append("</section>\n");
            			}
            		} else {
            			if (i == 0) {
            				sb.append("<div class='section1_bg'><section class='section1'>\n");
            				if (portletType == 0) {
            					if (checkViewRightBln(portletUID, getAccessList(userInfo)) == true) {
            						portletMoveURL = getPortletConfigItem("URL",portletUID);
            						sb.append("<iframe width='" + portletWidth + "' height=" + portletHeight + " border=0 src='" + portletMoveURL + loadGetParameters(portletMoveURL, portletUID, userInfo) + "' frameborder=0 scrolling=no></iframe>\n");
            					}
            				} else {
            					sb.append(getRenderedPortalPageHTMLInsert(pPortalPageID, portletUID, "", "view", userInfo) + "\n");
            				}
            				if (i == 0) {
            					sb.append("</section></div>\n");
            				} else {
            					sb.append("</section>\n");
            				}
            			} else {
            				if (gTableViewOption.equals("T") && loadFlag) {
            					sb.append("<div id='Center' style=' margin-top: 15px; '>");
                                sb.append("<table border='0' cellpadding='0' cellspacing='0' width='100%'>");
                                sb.append("<tbody>");
            				}
            				
            				sb.append("<TR>");
            				
            				if (portletType == 0) {
            					if (checkViewRightBln(portletUID, getAccessList(userInfo)) == true) {
            						portletMoveURL = getPortletConfigItem("URL",portletUID);
            						sb.append("<TD id=subtd" + String.valueOf(pColumnIndex * 100 + i + 1) + " style='WIDTH: 100%; HEIGHT:" + portletHeight + " align=middle valign=top uid='" + portletUID + "' canremove='" + portletCanRemove + "' canresize='" + portletCanResize + "' canreplace='" + portletCanReplace + "' style='padding-left:" + portletPaddingLeft + ";padding-right:" + portletPaddingRight + ";padding-top:" + portletPaddingTop + ";padding-bottom:" + portletPaddingBottom + "'><iframe width=100% height=100% border=0 src='" + portletMoveURL + loadGetParameters(portletMoveURL, portletUID, userInfo) + "' frameborder=0 scrolling=no></iframe></TD>\n");
            					}
            				} else {
            					sb.append(getRenderedPortalPageHTMLInsert(pPortalPageID, portletUID, "", "view", userInfo));
            				}
            				sb.append("</TR>\n");
            				
            				if (gTableViewOption.equals("T") && loadFlag) {
            					 sb.append("</tbody>");
                                 sb.append("</table>");
                                 sb.append("</div>\n");
                                 loadFlag = false;
            				}
            			}
            		}
            	}
            }
            
			return sb.toString();
		} catch (Exception e) {
			e.printStackTrace();
			return "";
		}
	}
	
	public String getRenderedPortalPageColumnInsert (String pPortalPageID, String pCallingPageID, String pAccessIDList, int pColumnIndex, String pMode, LoginVO userInfo) {
		try {
			List<PortalTBLPortalPageItemsVO> result = new ArrayList<PortalTBLPortalPageItemsVO>();
			StringBuilder sb = new StringBuilder();
			String strSQL = "";
            String parentPortalPageID = pCallingPageID;
            int count = 0;
            
            strSQL = "SELECT * FROM ezPortal.TBL_PortalPage_Items  WHERE PageUID = '"+pPortalPageID+"' AND ColumnPos = " + pColumnIndex + " AND OwnerPageUID = '" + getItemLastPageID(pPortalPageID) + "'" ;
            
            while (count < 10) {
            	parentPortalPageID = getPortalParentUID(parentPortalPageID);

            	String param = parentPortalPageID;
            	strSQL += " UNION ALL SELECT * FROM ezPortal.TBL_PortalPage_Items  WHERE PageUID = '" + pPortalPageID + "' AND ColumnPos = " + pColumnIndex + " AND OwnerPageUID = '" + param +"'";
            	count ++;
            }
            
            if (bRootPage == true) {
            	result = getTBLPortalPageItemsT(strSQL);
            } else {
            	result = getTBLPortalPageItemsF(strSQL, userInfo.getId(), getTopParentPageID(pPortalPageID));
            }
            
            if (result == null) {
            	return "";
            }
            
            for (int i=0; i<result.size(); i++) {
            	int portletType = result.get(i).getPortletType();
            	String portletUID = result.get(i).getuID();
            	String portletPageUID = result.get(i).getPageUID();
            	String portletDisplayName = result.get(i).getDisplayName();
            	int portletWidth = result.get(i).getWidth();
            	int portletHeight = result.get(i).getHeight();
            	int portletCanRemove = result.get(i).getCanRemove();
            	int portletCanResize = result.get(i).getCanResize();
            	int portletCanReplace = result.get(i).getCanRemove();
            	int portletPaddingLeft = result.get(i).getLeftMargin();
            	int portletPaddingRight = result.get(i).getRightMargin();
            	int portletPaddingTop = result.get(i).getTopMargin();
            	int portletPaddingBottom = result.get(i).getBottomMargin();
            	String portletOwnerPageUID = result.get(i).getOwnerPageUID();
            	String portletMandatory = result.get(i).getMandatory();
            	String portletMoveURL = "";

            	if (pMode.equals("edit")) {
            		if (portletHeight != 0) {
            			sb.append("<TR style='WIDTH: 100%; HEIGHT: " + portletHeight + "px'>\n");
            		} else {
            			sb.append("<TR style='WIDTH: 100%; HEIGHT: 100px'>\n");
            		}
  
            		if (portletType == 0) {
            			if (checkViewRightBln(portletUID, getAccessList(userInfo)) == true) {
            				sb.append("<TD id=subtd" + UUID.randomUUID().toString().substring(0, 4) + " style='WIDTH: 100%; HEIGHT:" + portletHeight + "' align=middle uid='" + portletUID + "' pageuid='" + portletPageUID + "' ownerpageuid='" + portletOwnerPageUID + "' mandatory='" + portletMandatory + "' canremove='" + portletCanRemove + "' canresize='" + portletCanResize + "' canreplace='" + portletCanReplace + "'><B>" + portletDisplayName + "</B></TD>\n");
            			}
            		} else {
            			sb.append("<TD id=subtd" + UUID.randomUUID().toString().substring(0, 4) + " style='WIDTH: 100%; HEIGHT:" + portletHeight + "' align=middle uid='" + portletUID + "' pageuid='" + portletPageUID + "' ownerpageuid='" + portletOwnerPageUID + "' canremove='" + portletCanRemove + "' canresize='" + portletCanResize + "' canreplace='" + portletCanReplace + "'>" + getRenderedPortalPageHTMLInsert(pPortalPageID, portletUID, "", "edit", userInfo) + "</TD>\n");
            		}
            		sb.append("</TR>\n");
            	} else {
            		if (gTableViewOption.equals("D")) {
            			if (portletType == 0) {
            				if (checkViewRightBln(portletUID, getAccessList(userInfo)) == true) {
            					portletMoveURL = getPortletConfigItem("URL",portletUID);
            					if (portletWidth == 9999) {
            						String portletWidthStr = "100%"; 
            						sb.append("<iframe width='" + portletWidthStr + "' height=" + portletHeight + " border=0 src='" + portletMoveURL + loadGetParameters(portletMoveURL, portletUID, userInfo) + "' frameborder=0 scrolling=no></iframe>\n");
            					} else {
            						sb.append("<iframe width='" + portletWidth + "' height=" + portletHeight + " border=0 src='" + portletMoveURL + loadGetParameters(portletMoveURL, portletUID, userInfo) + "' frameborder=0 scrolling=no></iframe>\n");
            					}
            				}
            			} else {
            				sb.append(getRenderedPortalPageHTMLInsert(pPortalPageID, portletUID, "", "view", userInfo) + "\n");

            			}
            		} else {
            			if (portletType == 0) {
            				if (checkViewRightBln(portletUID, getAccessList(userInfo)) == true) {
            					portletMoveURL = getPortletConfigItem("URL",portletUID);
            					
            					if (portletWidth == 9999) {
            						String portletWidthStr = "100%"; 
            						sb.append("<iframe width='" + portletWidthStr + "' height=" + portletHeight + " border=0 src='" + portletMoveURL + loadGetParameters(portletMoveURL, portletUID, userInfo) + "' frameborder=0 scrolling=no></iframe>\n");
            					} else {
            						sb.append("<iframe width='" + portletWidth + "' height=" + portletHeight + " border=0 src='" + portletMoveURL + loadGetParameters(portletMoveURL, portletUID, userInfo) + "' frameborder=0 scrolling=no></iframe>\n");
            					}
            					
            					sb.append("<TD id=subtd" + String.valueOf(pColumnIndex * 100 + i + 1) + " style='WIDTH: 100%; HEIGHT:" + portletHeight + " align=middle valign=top uid='" + portletUID + "' canremove='" + portletCanRemove + "' canresize='" + portletCanResize + "' canreplace='" + portletCanReplace + "' style='padding-left:" + portletPaddingLeft + ";padding-right:" + portletPaddingRight + ";padding-top:" + portletPaddingTop + ";padding-bottom:" + portletPaddingBottom + "'><iframe width=100% height=100% border=0 src='" + portletMoveURL + loadGetParameters(portletMoveURL, portletUID, userInfo) + "' frameborder=0 scrolling=no></iframe></TD>\n");
            					}
            				} else {
            					sb.append(getRenderedPortalPageHTMLInsert(pPortalPageID, portletUID, "", "view", userInfo));
            				}
            			}
            		}
            	}
            
			return sb.toString();
		} catch (Exception e) {
			e.printStackTrace();
			return "";
		}
	}
	
	public String getThemeInfoPortal(String pCompanyID, LoginVO userInfo, String pSelectThemeUID) {
		try {
			List<PortalGetThemeListVO> list = getThemeList(pCompanyID);
			
			StringBuilder pThemeSelectObject = new StringBuilder();
			for (int i=0; i<list.size(); i++) {
				if (pSelectThemeUID.equals(list.get(i).getuID())) {
					switch (Integer.parseInt(userInfo.getLang())) {
					case 1:
						pThemeSelectObject.append("<option value='" + list.get(i).getuID() + "' selected>" + list.get(i).getDisplayName() + "</option>");
						break;
					case 2:
						pThemeSelectObject.append("<option value='" + list.get(i).getuID() + "' selected>" + list.get(i).getDisplayName2() + "</option>");
						break;
					case 3:
						pThemeSelectObject.append("<option value='" + list.get(i).getuID() + "' selected>" + list.get(i).getDisplayName3() + "</option>");
						break;
					case 4:
						pThemeSelectObject.append("<option value='" + list.get(i).getuID() + "' selected>" + list.get(i).getDisplayName4() + "</option>");
						break;
					default:
						break;
					}
					
				} else {
					switch (Integer.parseInt(userInfo.getLang())) {
					case 1:
						pThemeSelectObject.append("<option value='" + list.get(i).getuID() + "'>" + list.get(i).getDisplayName() + "</option>");
						break;
					case 2:
						pThemeSelectObject.append("<option value='" + list.get(i).getuID() + "'>" + list.get(i).getDisplayName2() + "</option>");
						break;
					case 3:
						pThemeSelectObject.append("<option value='" + list.get(i).getuID() + "'>" + list.get(i).getDisplayName3() + "</option>");
						break;
					case 4:
						pThemeSelectObject.append("<option value='" + list.get(i).getuID() + "'>" + list.get(i).getDisplayName4() + "</option>");
						break;
					default:
						break;
					}
					
				}
			}
			
			return pThemeSelectObject.toString();
		} catch (Exception e) {
			e.printStackTrace();
			return "ERROR";
		}
	}
	
	public String newMyPortalPageCreate (String pParentPageID, String pUserID, String pGubunFlag, String pCompanyID, String pPageID) {
		try {
			String newPageID = UUID.randomUUID().toString();
			int recordCnt = 0;
			
			if (pPageID.length() == 0) {
				recordCnt = newMyPortalPageCreate(pParentPageID, pPageID, pUserID, pGubunFlag, newPageID, 2, pCompanyID, "everyone", "최상위회사", 2, 2, "empty");
			} else {
				recordCnt = newMyPortalPageCreate(pParentPageID, pPageID, pUserID, pGubunFlag, newPageID, 2, pCompanyID, "everyone", "최상위회사", 2, 2, "full");
			}
			
			if (recordCnt != 0) {
				String baseMyPortalPageUID = newMyPortalPageCreate2("Y", pUserID, pCompanyID);
				
				newMyPortalPageCreate3("Y", baseMyPortalPageUID, pCompanyID, pUserID);
				return "OK";
			} else {
				return "OK";
			}
		} catch (Exception e) {
			e.printStackTrace();
			return "ERROR";
		}
	}
	
	public String getPorletPropertiesStr(String pUID) {
		try {
			PortalPortletGeneralVO result = getPorletProperties(pUID);
			String resultXML = "<DATA>"+commonUtil.getQueryResult(result)+"</DATA>";
			return resultXML;
		} catch (Exception e) {
			e.printStackTrace();
			return "<DATA/>";
		}
	}
	
	public String getPortletSubProperties (String pUID, String pType) {
		try {
			String resultXML = "";
			if (pType.equals("1")) {
				PortalTBLPortletURLVO result = getTBLPortletURL(pUID);
				resultXML = "<DATA>"+commonUtil.getQueryResult(result)+"</DATA>";
			} else if (pType.equals("2")) {
				PortalTBLPortletHtmlPageVO result = getTBLPortletHtmlPage(pUID);
				resultXML = "<DATA>"+commonUtil.getQueryResult(result)+"</DATA>";
			} else if (pType.equals("3")) {
				PortalTBLPortletImageVO result = getTBLPortletImage(pUID);
				resultXML = "<DATA>"+commonUtil.getQueryResult(result)+"</DATA>";
			} else if (pType.equals("4")) {
				PortalTBLPortletBoardVO result = getTBLPortletBoard(pUID);
				resultXML = "<DATA>"+commonUtil.getQueryResult(result)+"</DATA>";
			}
			return resultXML;
		} catch (Exception e) {
			e.printStackTrace();
			return "<DATA/>";
		}
	}
	
	public String getPortletParameters (String pUID) {
		try {
			List<PortalGetPortletParametersVO> result = getPortletParametres(pUID);
			String resultXML = "";
			resultXML = "<DATA>";
			for (int i=0; i<result.size(); i++) {
				resultXML += commonUtil.getQueryResult(result.get(i));
			}
			resultXML += "</DATA>";
			return resultXML;
		} catch (Exception e) {
			e.printStackTrace();
			return "";
		}
	}
	
	public String getBoardProperty (String pBoardID, String lang) {
		String boardInfo = "";
		try {
			BoardPropertyVO result = ezBoardService.getBoardProperty(pBoardID);
			if (result.getBoardName() != null && !result.getBoardName().equals("")) {
				if (lang.equals("1")) {
					boardInfo = result.getBoardName() + ":" + result.getGuBun();
				} else {
					boardInfo = result.getBoardName2().equals("") ? result.getBoardName() : result.getBoardName2() + ":" + result.getGuBun();
				}
			}
			return boardInfo;
		} catch (Exception e) {
			return "";
		}
	}
	
	public String addBestTable (LoginVO userInfo) throws Exception {
		StringBuilder strData = new StringBuilder();
		
		boolean firstFlag = true;
		int val = 0;
		
		List<CommunityMyCommunityVO> list = ezCommunityDAO.mainPageGet5(commonUtil.getMultiData(userInfo.getLang()));
		
		boolean readTF = false;
		
		for (int i=0; i<list.size(); i++) {
			if (list != null) {
				if (val == 3) {
					return "";
				}
				if (firstFlag) {
					strData.append("<dl class='listtype_photo'>");
					strData.append("<dt class='tit' style='cursor:pointer'");
					if (list.get(i).getC_ClubGubun().equals("3")) {
						strData.append("onclick=\"go_best('" + list.get(i).getC_ClubNo() + "','" + memberChk(list.get(i).getC_ClubNo(), userInfo) + "')\">");
					} else {
						strData.append("onclick=\"go_best('" + list.get(i).getC_ClubNo() + "','" + "0" + "')\">");
					}
					strData.append("<strong>");
					if (userInfo.getLang().equals("1")) {
						strData.append(list.get(i).getC_ClubName());
					} else {
						strData.append(list.get(i).getC_ClubName2());
					}
					strData.append("</strong></dt>");
					strData.append("<dd class='photo'>");
					
					String bannerSrc = "";
					if (list.get(i).getC_Logo_Thumbnail().trim().indexOf("default_logo_type") > -1) {
						bannerSrc = "/images/ezCommunity/logo/" + list.get(i).getC_Logo_Thumbnail().trim();
					} else {
						bannerSrc = "/ezCommon/downloadAttach.do?filePath=" + "/files/upload_community/logo/"+list.get(i).getC_Logo_Thumbnail();
					}
					
					
					strData.append("<img src='" + bannerSrc + "' width='86' height='61' alt=''>");
					strData.append("<span class='iconbest'></span>");
					strData.append("</dd'>");
					strData.append("<dd  class='txt'>");
					strData.append(list.get(i).getC_ClubDesc());
					strData.append("</dd>");
					strData.append("</dl>");
					 
                    firstFlag = false;
                    
				} else {
					strData.append("<dl class='listtype_dttxt'>");
                    strData.append("<dt style='cursor:pointer'");
                    if (("3").equals(list.get(i).getGubun())) {
                    	strData.append("onclick=\"go_best('" + list.get(i).getC_ClubNo() + "','" + memberChk(list.get(i).getC_ClubNo(), userInfo) + "')\">");
                    } else {
                    	strData.append("onclick=\"go_best('" + list.get(i).getC_ClubNo() + "','" + "0" + "')\">");
                    }
                    
                    strData.append("<strong>");
					if (userInfo.getLang().equals("1")) {
						strData.append(list.get(i).getC_ClubName());
					} else {
						strData.append(list.get(i).getC_ClubName2());
					}
					strData.append("</strong></dt>");
					strData.append("<dd>");
					strData.append(list.get(i).getC_ClubDesc());
					strData.append("</dd>");
					strData.append("</dl>");
                    
				}
				val++;
			} else {
				strData.append("<div class='nodata_portlet '>");
				strData.append("<p><img src='/images/kr/main/nodata_white.gif' width='107' height='70'></p>");
				strData.append("<p>" + egovMessageSource.getMessage("ezHome.t00026", new Locale(globals.getProperty("Globals.language"))) + "</p></div>");
				break;
			}
			readTF = true;
		}
		if (!readTF) {
			if (list == null) {
				strData.append("<div class='nodata_portlet '>");
				strData.append("<p><img src='/images/kr/main/nodata_white.gif' width='107' height='70'></p>");
				strData.append("<p>" + egovMessageSource.getMessage("ezHome.t00026", new Locale(globals.getProperty("Globals.language"))) + "</p></div>");
			}
		}
		
		return strData.toString();
	}
	
	public String memberChk (String cNo, LoginVO userInfo) throws Exception {
		String ret = "1";
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put(cNo, userInfo.getId());
		CommunityCClubUserVO result = ezCommunityDAO.getCateDetailViewGet4(map);
		if (result != null) {
			ret = "1";
		} else {
			ret = "0";
		}
		
		return ret;
	}
	
	public int daysInMonth (int month, int year) {
		int days;
		
		if (year % 4 == 0 && month == 2) {
			days = 29;
		} else if (month == 2) {
			days = 28;
		} else if (month == 4 || month == 6 || month == 9 || month == 11) { 
			days = 30; 
		} else if (month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12) { 
			days = 31; 
		} else { 
			days = 0; 
		} 
		return days; 
	}
	
	public String ezAclCheck (String pCN, String pCompanyID, String pCompanyNm) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pCOMPANYID", pCompanyID);
		map.put("v_pCN", pCN);
		String result = ezPortalDAO.ezAclCheck(map);
		
		String cnACL = result;
		String totalAdmin = "0";
		String companyAdmin = "0";
		
		if (cnACL != null && !cnACL.equals("")) {
			if (cnACL.indexOf("c=1") > -1) {
				totalAdmin = "1";
			}
			if (cnACL.indexOf("k=1") > -1) {
				companyAdmin = "1";
			}
		}
		
		String aclResult = "";
		
		if (totalAdmin.equals("1")) {
			aclResult = "1";
		} else {
			if (companyAdmin.equals("1")) {
				aclResult = "2";
			} else {
				aclResult = "3";
			}
		}
		return aclResult;
	}
	
	public List<PortalTBLPortalPageGeneralVO> myPortalList (String pGubunFlag, String pAccessIDList, String pCompanyID) throws Exception {
		String[] pAccessID = pAccessIDList.split("\\,");
		String pIDUser = pAccessID[0].trim();
		String pIDDept = "";
		
		if (pAccessID.length == 4) {
			pIDDept = pAccessID[3].trim();
		} else {
			pIDDept = "";
		}
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pCOMPANYID", pCompanyID);
		map.put("v_pGUBUNFLAG", pGubunFlag);
		map.put("v_pIDUSER", pIDUser);
		map.put("v_pIDDEPT", pIDDept);
		map.put("v_pIDCOMPANY", pCompanyID);
		List<PortalTBLPortalPageGeneralVO> list = ezPortalDAO.myPortalList(map);
		
		return list;
	}
	
	public int searchMyPortalPageCount (String pGubunFlag, String pAccessIDList, String pCompanyID) throws Exception {
		String[] pAccessID = pAccessIDList.split("\\,");
		String pIDUser = pAccessID[0].trim();
		String pIDDept = "";
		
		if (pAccessID.length == 4) {
			pIDDept = pAccessID[3].trim();
		} else {
			pIDDept = "";
		}
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pCOMPANYID", pCompanyID);
		map.put("v_pGUBUNFLAG", pGubunFlag);
		map.put("v_pIDUSER", pIDUser);
		map.put("v_pIDDEPT", pIDDept);
		int count = ezPortalDAO.searchMyPortalPageCount(map);
		
		return count;
	}
	
	public String searchMyPortal (String pDisplayName, String pGubunFlag, int pStartRow, int pEndRow, String pCompanyID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pCOMPANYID", pCompanyID);
		map.put("v_pENDROW", pEndRow);
		map.put("v_pDISPLAYNAME", pDisplayName);
		map.put("v_pGUBUNFLAG", pGubunFlag);
		List<PortalSearchMyPortalPage3VO> list = ezPortalDAO.searchMyPortalPage3(map);
		
		StringBuilder sb = new StringBuilder();
		sb.append("<DATA>");
		for (int i=0; i<list.size(); i++) {
			if (i >= pStartRow - 1) {
				sb.append("<ROW>");
                sb.append("<UID_>" + list.get(i).getuID_() + "</UID_>");
                sb.append("<DISPLAYNAME>" +  list.get(i).getDisplayName() + "</DISPLAYNAME>");
                sb.append("<DISPLAYNAME2>" + list.get(i).getDisplayName2() + "</DISPLAYNAME2>");
                sb.append("<DEPTH>" + list.get(i).getDepth() + "</DEPTH>");
                if (list.get(i).getUseFlag() != null && !list.get(i).getUseFlag().trim().equals("")) {
                	sb.append("<USEFLAG>" + list.get(i).getUseFlag().trim() + "</USEFLAG>");
                } else {
                	sb.append("<USEFLAG>" + list.get(i).getUseFlag()+ "</USEFLAG>");
                }
                sb.append("<IMAGEURL>" + list.get(i).getImageUrl() + "</IMAGEURL>");      
                sb.append("</ROW>");
			}
		}
		sb.append("</DATA>");
		return sb.toString();
	}
	
	public String useTopMenuID2( String pCompanyID, String pUseFlag, String pLang, String pUserThemeUID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pCOMPANYID", pCompanyID);
		map.put("v_pUSEFLAG", pUseFlag);
		map.put("v_pLANG", pLang);
		map.put("v_pUSERTHEMEUID", pUserThemeUID);
		List<PortalMenuItemItemsMenuItemsVO> list = ezPortalDAO.useTopMenuID2(map);
		
		String useTopMenuIDXml = "";
		useTopMenuIDXml += "<DATA>";
		for (PortalMenuItemItemsMenuItemsVO result : list) {
			useTopMenuIDXml += commonUtil.getQueryResult(result);
		}
		useTopMenuIDXml += "</DATA>";
		return useTopMenuIDXml;
	}
	
	public String useTopMenuID( String pCompanyID, String pUseFlag, String pUserThemeUID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pCOMPANYID", pCompanyID);
		map.put("v_pUSEFLAG", pUseFlag);
		map.put("v_pUSERTHEMEUID", pUserThemeUID);
		List<PortalMenuItemItemsMenuItemsVO> list = ezPortalDAO.useTopMenuID(map);
		
		String useTopMenuIDXml = "";
		useTopMenuIDXml += "<DATA>";
		for (PortalMenuItemItemsMenuItemsVO result : list) {
			useTopMenuIDXml += commonUtil.getQueryResult(result);
		}
		useTopMenuIDXml += "</DATA>";
		return useTopMenuIDXml;
	}
	
	
	public String searchStartPage( String pHomeUID, String pParentUID, String pImageUID, String pUserID, String pCompanyID, String pLinkURL) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pPARENTUID", pParentUID);
		map.put("v_pUSERID", pUserID);
		map.put("v_pCOMPANYID", pCompanyID);
		map.put("v_pHOMEUID", pHomeUID);
		map.put("v_pIMAGEUID", pImageUID);
		map.put("v_pLINKURL", pLinkURL);
		ezPortalDAO.searchStartPage(map);
		
		Map<String, Object> map1 = new HashMap<String, Object>();
		map1.put("v_pPARENTUID", pParentUID);
		map1.put("v_pUSERID", pUserID);
		map1.put("v_pCOMPANYID", pCompanyID);
		
		return ezPortalDAO.searchStartPage2(map1);
	}
	
	public String setUseMyStartPage (String pUID, String pOldUID, String pUserID, String pCompanyID, String langStr) throws Exception {
		try {
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("v_pOLDUID", pOldUID);
			map.put("v_pUSERID", pUserID);
			map.put("v_pCOMPANYID", pCompanyID);
			map.put("v_pLANGSTR", langStr);
			map.put("v_pUID", pUID);
			
			ezPortalDAO.setUseMyStartPage2(map);
			return "OK";
		} catch (Exception e) {
			return "";
		}
	}
	
	public String setUseMyPortalPage (String pUID, String pUserID, String pCompanyID, String pGubunFlag) throws Exception {
		try {
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("v_pUID", pUID);
			map.put("v_pUSERID", pUserID);
			map.put("v_pCOMPANYID", pCompanyID);
			map.put("v_pGUBUNFLAG", pGubunFlag);
			map.put("v_pUSEFLAG", "Y");
			/*map.put("pDisplayName", pUserID);
			map.put("pCompanyID", pCompanyID);
			map.put("pGubunFlag", pGubunFlag);*/
			
			List<String> list = ezPortalDAO.selectUseFlag(map);
			
			String[] arrays = list.toArray(new String[list.size()]);
			
			
/*			for (int i=0; i<arrays.length; i++) {
System.out.println("pUID:"+pUID);
				if (arrays[i].equals(pUID)) {
					Map<String, Object> map1 = new HashMap<String, Object>();
					map1.put("pUID", pUID);
					map1.put("pUserID", pUserID);
					map1.put("pCompanyID", pCompanyID);
					map1.put("pGubunFlag", pGubunFlag);
					map1.put("useFlag", "Y");
					ezPortalDAO.updateUseFlag(map1);
				} else {
					Map<String, Object> map2 = new HashMap<String, Object>();
					map2.put("pUID", pUID);
					map2.put("pUserID", pUserID);
					map2.put("pCompanyID", pCompanyID);
					map2.put("pGubunFlag", pGubunFlag);
					map2.put("useFlag", "");
					ezPortalDAO.updateUseFlagDefault(map2);
				}
			}*/
		/*	Map<String, Object> map1 = new HashMap<String, Object>();
			map1.put("pUID", pUID);
			map1.put("pUserID", pUserID);
			map1.put("pCompanyID", pCompanyID);
			map1.put("pGubunFlag", pGubunFlag);
			map1.put("useFlag", "Y");
			ezPortalDAO.updateUseFlag(map1);
			
			Map<String, Object> map2 = new HashMap<String, Object>();
			map2.put("pUID", pUID);
			map2.put("pUserID", pUserID);
			map2.put("pCompanyID", pCompanyID);
			map2.put("pGubunFlag", pGubunFlag);
			map2.put("useFlag", "");
			ezPortalDAO.updateUseFlagDefault(map2);*/
			
			
			
			
			ezPortalDAO.setUseMyPortalPage(map);
			return "OK";
		} catch (Exception e) {
			e.printStackTrace();
			return "";
		}
	}
	
	public String searchPortalPage (String pDisplayName, String pUseFlag, String pGubunFlag, int pStartRow, int pEndRow, String pAccessIDList) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_ENDROW", pEndRow);
		map.put("v_DISPLAYNAME", pDisplayName);
		map.put("v_USERFLAG", pUseFlag);
		map.put("v_GUBUNFLAG", pGubunFlag);
		map.put("v_ARRPARAM", pGubunFlag);
		List<PortalSearchPortalPageVO> list = ezPortalDAO.searchPortalPage(map); 
System.out.println("listSize:"+list.size());
		StringBuilder sb = new StringBuilder();
		sb.append("<DATA>");
		for (int i=0; i<list.size(); i++) {
			if (i >= pStartRow - 1) {
				sb.append("<ROW>");
                sb.append("<UID>" + list.get(i).getuID() + "</UID>");
                sb.append("<DISPLAYNAME>" + list.get(i).getDisplayName() + "</DISPLAYNAME>");
                sb.append("<DEPTH>" + list.get(i).getDepth() + "</DEPTH>");
                sb.append("<CREATEDATE>" + list.get(i).getCreateDate() + "</CREATEDATE>");
                sb.append("<GUBUNFLAG>" + list.get(i).getGubunFlag() + "</GUBUNFLAG>");
                sb.append("<USEFLAG>" + list.get(i).getUseFlag() + "</USEFLAG>");
                sb.append("</ROW>");
			}
		}
		
		sb.append("</DATA>");
		
		return sb.toString();
	}
	
}

