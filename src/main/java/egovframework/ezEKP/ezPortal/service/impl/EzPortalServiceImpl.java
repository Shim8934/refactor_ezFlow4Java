package egovframework.ezEKP.ezPortal.service.impl;


import java.io.File;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Properties;
import java.util.TimeZone;
import java.util.UUID;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
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
import egovframework.ezEKP.ezPortal.vo.PortalImagePortletVO;
import egovframework.ezEKP.ezPortal.vo.PortalMenuItemItemsImageVO;
import egovframework.ezEKP.ezPortal.vo.PortalMenuItemItemsMenuItemsSVO;
import egovframework.ezEKP.ezPortal.vo.PortalMenuItemItemsMenuItemsVO;
import egovframework.ezEKP.ezPortal.vo.PortalMyPortalListVO;
import egovframework.ezEKP.ezPortal.vo.PortalNewMyPortalPageListVO;
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
import egovframework.ezEKP.ezPortal.vo.PortalUseTopMenuID2VO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service("EzPortalService")
public class EzPortalServiceImpl extends EgovAbstractServiceImpl implements EzPortalService {
	
	private static final Logger logger = LoggerFactory.getLogger(EzPortalServiceImpl.class);
	
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
	
	@Autowired
	private Properties config;
	
	@Override
	public String getTopMenuConfigItem(String itemName, String uID, int tenantID) throws Exception{
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pITEMNAME", itemName);
		map.put("v_pUID", uID);
		map.put("tenantID", tenantID);
		
		return ezPortalDAO.getTopMenuConfigItem(map);
	}

	@Override
	public void deleteCacheValue(String uID, String accessListID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pUID", uID);
		map.put("v_pACCESSLISTID", accessListID);
		map.put("tenantID", tenantID);
		
		if (uID.equals("all")) {
			ezPortalDAO.deleteCacheValueAll(map);
		} else {
			ezPortalDAO.deleteCacheValue(map);
		}
		
		//ezPortalDAO.deleteCacheValue(map);
	}
	
	@Override
	public String checkCacheValue(String portalPageID, String accessIDList, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PORTALPAGEID", portalPageID);
		map.put("v_ACCESSIDLIST", accessIDList);
		map.put("tenantID", tenantID);
		return ezPortalDAO.checkCacheValue(map);
	}
	
	
	@Override
	public String topGetTopParentPageID(String uID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		String temp = uID;
		String parentTopMenuID = "";
		int count = 0;
		while (count < 10) {
			map.put("v_pUID", temp);
			map.put("tenantID", tenantID);
			parentTopMenuID = ezPortalDAO.topGetTopParentPageID(map);
			
			if (parentTopMenuID != null && parentTopMenuID.toLowerCase().trim().equals("top")) {
				break;
			}
			temp = parentTopMenuID;
			count ++;
		}
		return temp;
	}
	
	@Override
	public PortalGetRenderedTopMenuInsertVO getRenderedTopMenuInsert(String uID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pUID", uID);
		map.put("tenantID", tenantID);
		return ezPortalDAO.getRenderedTopMenuInsert(map);
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
			String accessID, String accessName, int viewRight, int editRight, int depth, String companyID, int tenantID) throws Exception {
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
		map.put("tenantID", tenantID);
		
		SimpleDateFormat date = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		date.setTimeZone(TimeZone.getTimeZone("GMT"));
		String nowDate = date.format(new Date());
		map.put("nowDate", nowDate);
		
		String temp = ezPortalDAO.getUserInfo3_S(map);
		
		if (temp != null && temp.equals("1")) {
			ezPortalDAO.getUserInfo3_I1(map);
			ezPortalDAO.getUserInfo3_I2(map);
		}
		
		//ezPortalDAO.getUserInfo3(map);
	}
	
	@Override
	public int getUserInfo4(String companyID, String creatorID, String gubunFlag, String useFlag, int tenantID) throws Exception {
		logger.debug("getUserInfo4 started");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pCOMPANYID", companyID);
		map.put("v_pCREATORID", creatorID);
		map.put("v_pGUBUNFLAG", gubunFlag);
		map.put("v_pUSEFLAG", useFlag);
		map.put("tenantID", tenantID);
		
		logger.debug("companyID="+companyID);
		logger.debug("creatorID="+creatorID);
		logger.debug("gubunFlag="+gubunFlag);
		logger.debug("useFlag="+useFlag);
		logger.debug("tenantID="+tenantID);
		logger.debug("result="+ezPortalDAO.getUserInfo4(map));
		logger.debug("getUserInfo4 ended");
		
		return ezPortalDAO.getUserInfo4(map);
	}
	
	@Override
	public List<PortalTBLPortalPageGeneralVO> getUserInfo5(int pCount, String useFlag, String companyID, String parentUID, String userID, String gubunFlag, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pCOUNT", pCount);
		map.put("v_pUSEFLAG", useFlag);
		map.put("v_pCOMPANYID", companyID);
		map.put("v_pPARENTUID", parentUID);
		map.put("v_pUSERID", userID);
		map.put("v_pGUBUNFLAG", gubunFlag);
		map.put("tenantID", tenantID);
		return ezPortalDAO.getUserInfo5(map);
				
	}
	
	@Override
	public String checkEditRight(String uID, String accessIDList, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_UID", uID);
		map.put("v_ACCESSIDLIST", accessIDList);
		map.put("tenantID", tenantID);
		return ezPortalDAO.checkEditRight(map);
	}
	

	@Override
	public List<PortalTBLPortalPageGeneralVO> searchMyPortalPage2( String pAccessIDList, String pGubunFlag, String pStrRight, String pCompanyID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pACCESSIDLIST", pAccessIDList);
		map.put("v_pGUBUNFLAG", pGubunFlag);
		map.put("v_pSTRRIGHT", pStrRight);
		map.put("v_pCOMPANYID", pCompanyID);
		map.put("tenantID", tenantID);
		return ezPortalDAO.searchMyPortalPage2(map);
	}
	
	@Override
	public String checkViewRight(String uID, String accessIDList, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_UID", uID);
		map.put("v_ACCESSIDLIST", accessIDList);
		map.put("tenantID", tenantID);
		return ezPortalDAO.checkViewRight(map);
	}
	
	@Override
	public List<PortalTBLTopMenuGeneralVO> topSearchTopMenu3(int endRow, String displayName, String useFlag, String companyID, String lang, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pENDROW", endRow);
		map.put("v_pDISPLAYNAME", displayName);
		map.put("v_pUSEFLAG", useFlag);
		map.put("v_pCOMPANYID", companyID);
		map.put("v_pLANG", lang);
		map.put("tenantID", tenantID);
		return ezPortalDAO.topSearchTopMenu3(map);
	}
	
	@Override
	public PortalTBLUserInfoVO topGetUserInfo2(String pUserID, String pLang, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pUSERID", pUserID);
		map.put("v_pLANG", pLang);
		map.put("tenantID", tenantID);
		return ezPortalDAO.topGetUserInfo2(map);
	}
	
	@Override
	public PortalTBLUserInfoVO topGetUserInfo(String pUserID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pUSERID", pUserID);
		map.put("tenantID", tenantID);
		return ezPortalDAO.topGetUserInfo(map);
	}
	
	@Override
	public List<PortalTopSearchTopMenu2VO> topSearchTopMenu2(int endRow, String displayName, String useFlag, String companyID, int tenantID) throws Exception {
		logger.debug("topSearchTopMenu2 started");
		
		logger.debug("endRow="+endRow);
		logger.debug("displayName="+displayName);
		logger.debug("useFlag="+useFlag);
		logger.debug("companyID="+companyID);
		logger.debug("tenantID="+tenantID);
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pENDROW", endRow);
		map.put("v_pDISPLAYNAME", displayName);
		map.put("v_pUSEFLAG", useFlag);
		map.put("v_pCOMPANYID", companyID);
		map.put("tenantID", tenantID);
		
		logger.debug("result="+ezPortalDAO.topSearchTopMenu2(map));
		logger.debug("topSearchTopMenu2 ended");
		return ezPortalDAO.topSearchTopMenu2(map);
	}
	
	@Override
	public PortalTBLThemeGeneralVO getThemeInfo(String pUID, String pGubun, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PUID", pUID);
		map.put("v_PGUBUN", pGubun);
		map.put("tenantID", tenantID); 
		return ezPortalDAO.getThemeInfo(map);
	}
	
	@Override
	public String useStartPageChack(String pUserID, String pCompanyID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pUSERID", pUserID);
		map.put("v_pCOMPANYID", pCompanyID);
		map.put("tenantID", tenantID); 
		
		int count = ezPortalDAO.useStartPageChack_S1(map);
		
		if (count == 0) {
			return "NO";
		} else {
			return ezPortalDAO.useStartPageChack(map);
		}
	}
	
	@Override
	public String useStartPageChack2(String pUserID, String pCompanyID, String pParentUID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pUSERID", pUserID);
		map.put("v_pCOMPANYID", pCompanyID);
		map.put("v_pPARENTUID", pParentUID);
		map.put("tenantID", tenantID);
		
		int count = ezPortalDAO.useStartPageChack2_S(map);
		
		if (count == 0) {
			return "NO";
		} else {
			return ezPortalDAO.useStartPageChack2(map);
		}
	}

	@Override
	public int getMenuItemHtml(String uID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pUID", uID);
		map.put("tenantID", tenantID);
		return ezPortalDAO.getMenuItemHtml(map);
	}
	
	@Override
	public String getMenuItemConfigItem(String itemName, String uID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pITEMNAME", itemName); 
		map.put("v_pUID", uID);
		map.put("tenantID", tenantID);
		return ezPortalDAO.getMenuItemConfigItem(map);
	}
	
	@Override
	public String getLogoHtml(String pOwnerPageID, String pAccessID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pOWNERPAGEID", pOwnerPageID); 
		map.put("v_pACCESSID", pAccessID);
		map.put("tenantID", tenantID);  
		return ezPortalDAO.getLogoHtml(map);
	}
	
	@Override
	public PortalMenuItemItemsImageVO getImageHtml(String pUID, String pParentUID, int pSkinNum, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pUID", pUID); 
		map.put("v_pPARENTUID", pParentUID);
		map.put("v_pSKINNUM", pSkinNum);
		map.put("tenantID", tenantID);  
		return ezPortalDAO.getImageHtml(map);
	}
	
	@Override
	public List<PortalTopLoadGetParametersVO> topLoadGetParameters(String pUID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pUID", pUID);
		map.put("tenantID", tenantID);  
		return ezPortalDAO.topLoadGetParameters(map);
	}
	
	@Override
	public List<PortalMenuItemItemsMenuItemsVO> getUtilMenuHtml(String pParentUID, String pOwnerPageID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pPARENTUID", pParentUID); 
		map.put("v_pOWNERPAGEID", pOwnerPageID);
		map.put("tenantID", tenantID);
		return ezPortalDAO.getUtilMenuHtml(map);
	}
	
	@Override
	public List<PortalGetMainMenuHtmlVO> getMainMenuHtml(String pParentUID, String pOwnerPageID, int pSkinNum, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pPARENTUID", pParentUID); 
		map.put("v_pOWNERPAGEID", pOwnerPageID);
		map.put("v_pSKINNUM", pSkinNum);
		map.put("tenantID", tenantID);
		return ezPortalDAO.getMainMenuHtml(map);
	}

	@Override
	public List<PortalMenuItemItemsMenuItemsVO> getSubMenuHtml(String pOwnerPageID, String pParentUID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pOWNERPAGEID", pOwnerPageID); 
		map.put("v_pPARENTUID", pParentUID);
		map.put("tenantID", tenantID);
		return ezPortalDAO.getSubMenuHtml(map);
	}

	@Override
	public List<PortalMenuItemItemsMenuItemsSVO> getSubMenuHtml2( String pParentUID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pPARENTUID", pParentUID);
		map.put("tenantID", tenantID);
		return ezPortalDAO.getSubMenuHtml2(map);
	}
	
	@Override
	public String getPortalConfigItem(String pItemName, String pPageID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pPITEMNAME", pItemName);
		map.put("v_pPAGEID", pPageID);
		map.put("tenantID", tenantID);
		return ezPortalDAO.getPortalConfigItem(map);
	}
	
	@Override
	public PortalGetRenderedTopMenuInsertVO getRenderedPortalPageHtml( String pPortalPageID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pPORTALPAGEID", pPortalPageID);
		map.put("tenantID", tenantID);
		return ezPortalDAO.getRenderedPortalPageHtml(map);
	}
	
	@Override
	public String getTopParentPageID(String pTemp, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pTEMP", pTemp);
		map.put("tenantID", tenantID);
		return ezPortalDAO.getTopParentPageID(map);
	}
	
	@Override
	public String getPortletConfigItem(String pItemName, String pPortletID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pPITEMNAME", pItemName);
		map.put("v_pPORTLETID", pPortletID);
		map.put("tenantID", tenantID);
		return ezPortalDAO.getPortletConfigItem(map);
	}
	
	@Override
	public String getItemLastPageID(String temp, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pTEMP", temp);
		map.put("tenantID", tenantID);
		return ezPortalDAO.getItemLastPageID(map);
	}
	
	@Override
	public void updateCacheValue(String portalPageID, String accessIDList, String renderedHtml, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PORTALPAGEID", portalPageID);
		map.put("v_ACCESSIDLIST", portalPageID);
		map.put("v_RENDEREDHTML", renderedHtml.replace("'", "''"));
		map.put("tenantID", tenantID);
		
		ezPortalDAO.updateCacheValue_D(map);
		ezPortalDAO.updateCacheValue(map);
	}
	
	@Override
	public String portalPageBaseType(String uID, String pCompanyID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pUID", uID);
		map.put("v_pCOMPANYID", pCompanyID);
		map.put("tenantID", tenantID);
		return ezPortalDAO.portalPageBaseType(map);
	}
	
	@Override
	public List<PortalGetThemeListVO> getThemeList(String pCompanyID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PCOMPANYID", pCompanyID);
		map.put("tenantID", tenantID);
		return ezPortalDAO.getThemeList(map);
	}
	
	@Override
	public List<PortalTBLPortalPageCategoryVO> getPortalPageCategory() throws Exception {
		return ezPortalDAO.getPortalPageCategory();
	}
	
	@Override
	public int newMyPortalPageCreate(String pParentPageID, String pPageID, String pUserID, String pGubunFlag, String pNewPageID, int pDepth,
			String pCompanyID, String pAccessID, String pAccessName, int pViewRight, int pEditRight, String pMode, int tenantID) throws Exception {
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
		map.put("tenantID", tenantID);
		SimpleDateFormat date = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		date.setTimeZone(TimeZone.getTimeZone("GMT"));
		String nowDate = date.format(new Date());
		map.put("nowDate", nowDate);
		
		String temp = ezPortalDAO.newMyPortalPageCreate_S(map);
		
		if (temp != null && temp.equals("1")) {
			if (pMode != null && pMode.equals("empty")) {
				ezPortalDAO.newMyPortalPageCreate_I1(map);
				ezPortalDAO.newMyPortalPageCreate_I2(map);
			} else {
				ezPortalDAO.newMyPortalPageCreate_I3(map);
				ezPortalDAO.newMyPortalPageCreate_I4(map);
			}
		} else {
			temp = "0";
		}
		
		//return Integer.parseInt(ezPortalDAO.newMyPortalPageCreate_S(map));
		return Integer.parseInt(temp);
	}
	
	@Override
	public String newMyPortalPageCreate2(String pUserFlag, String pUserID, String pCompanyID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pUSERFLAG", pUserFlag);
		map.put("v_pUSERID", pUserID);
		map.put("v_pCOMPANYID", pCompanyID);
		map.put("tenantID", tenantID);
		
		String temp = ezPortalDAO.newMyPortalPageCreate2_S(map);
		String result = "";
		
		if (temp != null && temp.equals("1")) {
			result = ezPortalDAO.newMyPortalPageCreate2(map); 
		}
		
		return result;
	}
	
	@Override
	public void newMyPortalPageCreate3(String pUseFlag, String pUID, String pCompanyID, String pUserID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pUSEFLAG", pUseFlag);
		map.put("v_pUID", pUID);
		map.put("v_pCOMPANYID", pCompanyID);
		map.put("v_pUSERID", pUserID);
		map.put("tenantID", tenantID);
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
	public PortalUrlPortletVO urlPortlet(String uID, String creatorID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_UID", uID);
		map.put("v_CREATORID", creatorID);
		map.put("tenantID", tenantID);
		return ezPortalDAO.urlPortlet(map);
	}
	
	@Override
	public PortalPortletGeneralVO getPorletProperties(String pUID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pUID", pUID);
		map.put("tenantID", tenantID);
		
		String temp = ezPortalDAO.getPorletProperties_S(map);
		
		if (temp != null && temp.equals("1")) {
			return ezPortalDAO.getPorletProperties(map);
		} else {
			PortalPortletGeneralVO portletGeneral = new PortalPortletGeneralVO();
			portletGeneral.setWidth(0);
			return portletGeneral;
		}
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
		return ezPortalDAO.getTBLPortletImage(pUID);
	}

	@Override
	public PortalTBLPortletBoardVO getTBLPortletBoard(String pUID) throws Exception {
		return ezPortalDAO.getTBLPortletBoard(pUID);
	}
	
	@Override
	public List<PortalGetPortletParametersVO> getPortletParametres(String pUID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pUID", pUID);
		map.put("tenantID", tenantID);
		return ezPortalDAO.getPortletParametres(map);
	}
	
	@Override
	public List<PortalTopLoadGetParametersVO> loadGetParameters(String pPortletID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pPortletID", pPortletID);
		map.put("tenantID", tenantID);
		return ezPortalDAO.loadGetParameters(map);
	}
	
	@Override
	public String selectTBLPortalACL(String pResult, String pAccessID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("pResult", pResult);
		map.put("pAccessID", pAccessID);
		map.put("tenantID", tenantID);
		return ezPortalDAO.selectTBLPortalACL(map);
	}

	@Override
	public void deleteTBLPortalACL(String pResult, String pAccessID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("pResult", pResult);
		map.put("pAccessID", pAccessID);
		map.put("tenantID", tenantID);
		ezPortalDAO.deleteTBLPortalACL(map);
	}

	@Override
	public void insertTBLPortalACL(String pResult, String pAccessID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("pResult", pResult);
		map.put("pAccessID", pAccessID);
		map.put("tenantID", tenantID);
		ezPortalDAO.insertTBLPortalACL(map);
	}

	@Override
	public void updateTBLPortalACL(String pResult, String pAccessID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("pResult", pResult);
		map.put("pAccessID", pAccessID);
		map.put("tenantID", tenantID);
		ezPortalDAO.updateTBLPortalACL(map);
	}
	
	@Override
	public String ezCkAdminACL(String pOwnerPageID, String userLang) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pOWNERPAGEID", pOwnerPageID);
		map.put("v_pLANG", userLang);
		return ezPortalDAO.ezCkAdminACL(map);
	}
	
	@Override
	public List<PortalNewMyPortalPageListVO> newMyPortalList(String pUserID, String pGubunFlag, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pDISPLAYNAME", pUserID);
		map.put("v_pGUBUNFLAG", pGubunFlag);
		map.put("tenantID", tenantID);
		return ezPortalDAO.newMyPortalList(map);
	}
	
	@Override
	public List<PortalFirstMainListVO> firstMainList(String pUseTopMenuID, String deptPath, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PUSETOPMENUID", pUseTopMenuID);
		map.put("v_DEPTPATH", deptPath);
		map.put("tenantID", tenantID);
		return ezPortalDAO.firstMainList(map);
	}
	
	@Override
	public List<PortalTBLPortalACLVO> getAclItems(String pUID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_UID", pUID);
		map.put("tenantID", tenantID);
		return ezPortalDAO.getAclItems(map);
	}
	
	@Override
	public String htmlPortlet(String uID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_UID", uID);
		map.put("tenantID", tenantID);
		return ezPortalDAO.htmlPortlet(map);
	}
	
	@Override
	public PortalImagePortletVO imagePortlet(String pUID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_UID", pUID);
		map.put("tenantID", tenantID);
		return ezPortalDAO.imagePortlet(map);
	}
	
	@Override
	public PortalTBLPortletBoardVO boardPortlet(Map<String, Object> map) throws Exception {
		return ezPortalDAO.boardPortlet(map);
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
	
	public String getRenderedTopMenuHTML (String topMenuID, String accessIDList, String mode, String skinNum, LoginVO userInfo, String theme, int tenantID) throws Exception {
		if (mode.equals("view")) {
			String cacheValue = checkCacheValue(topMenuID, getAccessList(userInfo), userInfo.getTenantId());
			if (cacheValue != null && !cacheValue.equals("")) {
				return cacheValue;
			}
		}
		
		if (skinNum != null && !skinNum.equals("")) {
			userInfo.setSkinNum(skinNum);
		}
		
		if (theme != null && !theme.equals("")) {
			userInfo.setTheme(theme);
		}
		
		StringBuilder sb = new StringBuilder();
		
		String pageWidth = "";
		String pageHeight = "";
		String pageColumnLength = "";
		String pageColumnSplit = "";
		String rootParentUID = topGetTopParentPageID(topMenuID, tenantID); // 최상위 페이지 ID
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
		
		PortalGetRenderedTopMenuInsertVO result = getRenderedTopMenuInsert(topMenuID, tenantID);
		
		if (result == null) {
			return defaultValue;
		}
		
		pageWidth = getTopMenuConfigItem("WIDTH",rootParentUID, tenantID);
		pageHeight = getTopMenuConfigItem("HEIGHT",rootParentUID, tenantID);
		pageColumnLength = getTopMenuConfigItem("COLUMNLENGTH",rootParentUID, tenantID);
		pageColumnSplit = getTopMenuConfigItem("COLUMNSPLIT",rootParentUID, tenantID);
		
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
			 updateCacheValue(topMenuID, getAccessList(userInfo), strPage, userInfo.getTenantId());
		 }
		
		 return strPage;
		
	}
	
	public String getRenderedTopMenuColumn (String pTopMenuID, String pAccessIDList, int pColumnIndex, String pMode, LoginVO userInfo) throws Exception {
		StringBuilder sb = new StringBuilder();
		String strSQL = "";
		String parentTopMenuID = pTopMenuID; // 자신의 상위페이지 ID
		
		int count = 0;
		
		strSQL = "SELECT * FROM EZPORTAL.TBL_TOPMENU_ITEMS  WHERE PageUID = '" + pTopMenuID + "' AND ColumnPos = " + pColumnIndex + " AND TENANT_ID = " + userInfo.getTenantId();
		
		while (count < 10) {
			
			parentTopMenuID = getParentUID(parentTopMenuID);
			
			if (parentTopMenuID.toLowerCase().trim().equals("top")) {
				break;
			}
			String param = String.valueOf(count);
			strSQL += " UNION ALL SELECT * FROM EZPORTAL.TBL_TOPMENU_ITEMS  WHERE PageUID = '" + param + "' AND ColumnPos = " + parentTopMenuID + " AND TENANT_ID = " + userInfo.getTenantId();
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
					sb.append("<TD id=subtd" + String.valueOf(pColumnIndex*100+i+1) + " style='WIDTH: 100%' align=middle uid='" + menuItemUID + "' pageuid='" + menuItemPageUID + "' canremove='" + menuItemCanRemove + "' canresize='" + menuItemCanResize + "' canreplace='" + menuItemCanReplace + "'>" + getRenderedTopMenuHTMLInsert(pTopMenuID, menuItemUID, "", "edit", userInfo, userInfo.getTenantId()) + "</TD>\n");
				}
                sb.append("</TR>\n");
			} else {  // 보기모드 : HTML로 렌더링
				sb.append(getRenderedTopMenuHTMLInsert(pTopMenuID, menuItemUID, "", "view", userInfo, userInfo.getTenantId()));
			}
		}
		String strPage = sb.toString();
		
		return strPage;
	
	}
	
	public String getRenderedTopMenuColumnInsert (String pCallingMenuID, String pTopMenuID , String pAccessIDList, int pColumnIndex, String pMode, LoginVO userInfo) throws Exception  {
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
					sb.append("<TD id=subtd" + UUID.randomUUID().toString().substring(0, 4) + " style='WIDTH: 100%' align=middle uid='" + menuItemUID + "' pageuid='" + menuItemPageUID + "' canremove='" + menuItemCanRemove + "' canresize='" + menuItemCanResize + "' canreplace='" + menuItemCanReplace + "'>" + getRenderedTopMenuHTMLInsert(pTopMenuID, menuItemUID, "", "edit", userInfo, userInfo.getTenantId()) + "</TD>\n");
				}
                sb.append("</TR>\n");
			} else { 
				if (menuItemMenuItemType.equals("0")) {
					sb.append(getMenuItemHTML(pCallingMenuID, menuItemUID, userInfo));
				} else {
					sb.append(getRenderedTopMenuHTMLInsert(pCallingMenuID, menuItemUID, "", "view", userInfo, userInfo.getTenantId()));
				}
			}
		}
		String strPage = sb.toString();
		
		return strPage;
		
	}
	
	public String getRenderedTopMenuHTMLInsert (String pCallingMenuID, String pTopMenuID, String pAccessIDList, String pMode, LoginVO userInfo, int tenantID) throws Exception {
		StringBuilder sb = new StringBuilder();
		
		String rootParentUID = topGetTopParentPageID(pTopMenuID, tenantID);
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
		
		PortalGetRenderedTopMenuInsertVO result = getRenderedTopMenuInsert(pTopMenuID, tenantID);
		
		if (result == null) {
			return defaultValue;
		}
		
		String pageWidth = getTopMenuConfigItem("WIDTH",rootParentUID, tenantID);
		String pageHeight = getTopMenuConfigItem("HEIGHT",rootParentUID, tenantID);
		String pageColumnLength = getTopMenuConfigItem("COLUMNLENGTH",rootParentUID, tenantID);
		String pageColumnSplit = getTopMenuConfigItem("COLUMNSPLIT",rootParentUID, tenantID);
		
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
			
	
	}
		
	public boolean checkEditRightBln (String pUID, String pAccessIDList, int tenantID) throws Exception {
		for (int i=0; i<pAccessIDList.split(",").length; i++) {
			String right = checkEditRight(pUID, pAccessIDList.split(",")[i].trim(), tenantID);
			if (right != null && right.equals("2")) {
				return true;
			}
			if (right != null && right.equals("1")) {
				return false;
			}
		}
		return false;
	}
	
	public boolean checkViewRightBln (String pUID, String pAccessIDList, int tenantID) throws Exception {
		for (int i=0; i<pAccessIDList.split("\\,").length; i++) {
			String right = checkViewRight(pUID, pAccessIDList.split("\\,")[i].trim(), tenantID);

			if (right != null && right.equals("2")) {
				return true;
			}
			if (right != null && right.equals("1")) {
				return false;
			}
		}
		return false;
	}
	
	public String getUserInfo(String pUserID, String pUserName, String parentUID, String pGubunFlag, String pMode, LoginVO userInfo, String pCompanyID, Locale locale, int tenantID) throws Exception {
		logger.debug("getUserInfo Start");
		if (pMode != null && pMode.equals("edit")) {
			if (checkEditRightBln(parentUID, getAccessList(userInfo), userInfo.getTenantId()) == true) {
				String newPageID = UUID.randomUUID().toString();
				getUserInfo3(parentUID, "Y", pUserID, pGubunFlag, newPageID, pUserName, egovMessageSource.getMessage("ezPortal.t990038", locale), egovMessageSource.getMessage("ezPortal.t990037", locale), 2, 2, 2, pCompanyID, userInfo.getTenantId());
			}
		}
		
		int resultNumber = getUserInfo4(pCompanyID.trim(), pUserID.trim(), pGubunFlag.trim(), "Y", tenantID);
		logger.debug("resultNumber="+resultNumber);
		logger.debug("pCompanyID="+pCompanyID);
		logger.debug("pUserID="+pUserID);
		logger.debug("pGubunFlag="+pGubunFlag);
		
		logger.debug("parentUID="+parentUID);
		List<PortalTBLPortalPageGeneralVO> resultXML = getUserInfo5(resultNumber, "Y", pCompanyID, parentUID, pUserID, pGubunFlag, userInfo.getTenantId());
		
		String result = "";
		result = "<DATA>";
		for (int i=0; i<resultXML.size(); i++) {
			result += commonUtil.getQueryResult(resultXML.get(i));
		}
		result += "</DATA>";
		logger.debug("result="+result);
		logger.debug("getUserInfo End");
		return result;
	}
	
	public String searchMyPortalPage (String pGubunFlag, String pMode, LoginVO userInfo, String pCompanyID) throws Exception {
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
			result = searchMyPortalPage2(pAccessIDList.split(",")[i].trim(), pGubunFlag, strRight, pCompanyID, userInfo.getTenantId());
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
				if (checkViewRightBln(result.get(i).getuID().trim(), pAccessIDList,userInfo.getTenantId()) == true) {
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
				if (checkEditRightBln(result.get(i).getuID().trim(), pAccessIDList, userInfo.getTenantId()) == true) {
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
	}
	
	public String searchTopMenu (String pDisplayName, String pUseFlag, int pStartRow, int pEndRow, String pAccessIDList, String langStr, String pCompanyID, int tenantID) throws Exception {
		List<PortalTBLTopMenuGeneralVO> resultList = topSearchTopMenu3(pEndRow, pDisplayName, pUseFlag, pCompanyID, langStr, tenantID);
		
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
	}
	
	public String searchTopMenu (String pDisplayName, String pUseFlag, int pStartRow, int pEndRow, String pAccessIDList, String pCompanyID, int tenantID) throws Exception {
		List<PortalTopSearchTopMenu2VO> resultList = topSearchTopMenu2(pEndRow, pDisplayName, pUseFlag, pCompanyID, tenantID);
		
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
	
	}
	
	public String getUserInfo (String pUserID, String langStr, int tenantID) throws Exception {
		PortalTBLUserInfoVO result = topGetUserInfo2(pUserID, langStr, tenantID);
		String resultXML = "<DATA>"+commonUtil.getQueryResult(result)+"</DATA>";

		if (resultXML.equals("<DATA></DATA>")) {
			resultXML = getUserInfo(pUserID, tenantID);
		}
		return resultXML;	
	}
		
	public String getUserInfo (String pUserID, int tenantID) throws Exception {
		PortalTBLUserInfoVO result = topGetUserInfo(pUserID, tenantID);
			
		String resultXML = "<DATA>"+commonUtil.getQueryResult(result)+"</DATA>";
		return resultXML;	
	}
	
	public String getThemeInfoStr (String pThemeUID, String pGubun, int tenantID) throws Exception {
		PortalTBLThemeGeneralVO result = getThemeInfo(pThemeUID, pGubun, tenantID); 
		return "<DATA>"+commonUtil.getQueryResult(result)+"</DATA>";
	}
	
	public String getMenuItemHTML (String pCallingMenuID, String pUID, LoginVO userInfo) throws Exception {
		String strHTML = "<iframe width=100% height=100% border=0 src='" + getMenuItemConfigItem("URL",pUID, userInfo.getTenantId()) + "' frameborder=0 scrolling=no></iframe>";
		
		int result = getMenuItemHtml(pUID, userInfo.getTenantId());
		
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
	}
	
	public String getLogoHTML (String pCallingMenuID, String pContentsUID, LoginVO userInfo) throws Exception {
		String pUID = "";
		String pAccessIDList = getAccessList(userInfo);
		
		for (int i=0; i<pAccessIDList.split(",").length; i++) {
			pUID = getLogoHtml(pCallingMenuID, pAccessIDList.split(",")[i].trim(), userInfo.getTenantId());
			
			if (pUID != null) {
				break;
			}
		}
		return getImageHTML(pCallingMenuID, pUID, false, pContentsUID, userInfo);
	}
	
	public String getImageHTML (String pCallingMenuID, String pUID, boolean pIncludeTD, String pContentsUID, LoginVO userInfo) {
		try {
			String pSkinNum = "";
			String strHTML = "";
			if (pContentsUID.equals("203")) {
				pSkinNum = userInfo.getSkinNum();
			} else {
				pSkinNum = "1";
			}
			
			StringBuilder sb = new StringBuilder();
			PortalMenuItemItemsImageVO result = getImageHtml(pUID, pCallingMenuID, Integer.parseInt(pSkinNum), userInfo.getTenantId());

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
					if (imageLinkURL != null && !imageLinkURL.trim().equals("")) {
						sb.append(" style='cursor:pointer'");
						sb.append(" onclick='OpenWindow(event, \"" + imageLinkURL + topLoadGetParameters(imageLinkURL, pUID, userInfo) + "\"");
						sb.append(", \"" + imageLinkLocation + "\"");
						sb.append(", \"" + imageWindowOption + "\")'");
					
					}
					if (imageImageWidth != 0 && userInfo.getTheme().equals("BASIC")) sb.append(" width='" + imageImageWidth + "'");
                    if (imageImageHeight != 0 && userInfo.getTheme().equals("BASIC")) sb.append(" height='" + imageImageHeight + "'");
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
	
	public String topLoadGetParameters (String pURL, String pMenuItemID, LoginVO userInfo) throws Exception {
		List<PortalTopLoadGetParametersVO> result = topLoadGetParameters(pMenuItemID, userInfo.getTenantId());
		
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
	}
	
	public String loadGetParameters (String pURL, String pPortletID, LoginVO userInfo) throws Exception {
		List<PortalTopLoadGetParametersVO> result = loadGetParameters(pPortletID, userInfo.getTenantId());
		
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
	
	public String getUtilMenuHTML (String pCallingMenuID, String pUID, LoginVO userInfo) throws Exception {
		logger.debug("getUtilMenuHTML started");

		List<PortalMenuItemItemsMenuItemsVO> result = getUtilMenuHtml(pUID, pCallingMenuID, userInfo.getTenantId());
		StringBuilder sb = new StringBuilder();
		sb.append("<article class='utmenu'>\n");
		sb.append("<ul>\n");
		
		String lastLogout = "";
		logger.debug("resultSize="+result.size());
		for (int i=0; i<result.size(); i++) {
			logger.debug("uID="+result.get(i).getuID());
			logger.debug("accessID="+getAccessList(userInfo));
			if (checkViewRightBln(result.get(i).getuID(), getAccessList(userInfo), userInfo.getTenantId()) == false) {
				continue;
			}
			logger.debug("getUtilMenuHtml="+result.get(i));
			String menuitemDisplayName = result.get(i).getDisplayName();
			String menuitemImageUID = result.get(i).getImageUId();
			String menuitemLinkURL = result.get(i).getLinkURL();
			String menuitemLinkLocation = result.get(i).getLinkLocation();
			if (menuitemLinkLocation == null) {
				menuitemLinkLocation = "";
			} else {
				menuitemLinkLocation = result.get(i).getLinkLocation().trim();
			}
				
			logger.debug("menuitemLinkLocation="+menuitemLinkLocation);
			String menuitemWindowOption = result.get(i).getWindowOption();
			logger.debug("menuitemWindowOption="+menuitemWindowOption);
			
			if (menuitemWindowOption == null) {
				menuitemWindowOption = "";
			} else {
				menuitemWindowOption = result.get(i).getWindowOption().trim();
			}
			
			if (i == result.size() - 1) {
				lastLogout = "class='btn_logout'";
			}
			
			if (menuitemImageUID != null && !menuitemImageUID.equals("")) {
				sb.append(getUtilImageHTML(menuitemDisplayName, pCallingMenuID, menuitemImageUID, lastLogout, pUID, userInfo) + "\n");
			} else {
				if (menuitemLinkURL != null && !menuitemLinkURL.equals("")) {
					if (i == result.size() - 1) {
						sb.append("<li " + lastLogout + "><span style='cursor:pointer' onclick='top.location.href = \"" + menuitemLinkURL + "\"'>" + menuitemDisplayName +"</span></li>\n");
					} else {
						sb.append("<li " + lastLogout + "><span style='cursor:pointer' onclick='OpenWindow(event, \"" + menuitemLinkURL + topLoadGetParameters(menuitemLinkURL, result.get(i).getuID(), userInfo) + "\"");
						sb.append(", \"" + menuitemLinkLocation + "\"");
                        //sb.append(", \"" + menuitemWindowOption.trim() + "\")'>" + menuitemDisplayName + "</span></li>\n");
						sb.append(", \"" + menuitemWindowOption + "\")'>" + menuitemDisplayName + "</span></li>\n");
					}
                      
				} else {
					sb.append("<li " + lastLogout + ">" + menuitemDisplayName + "</li>\n");
				}
			}
		}
		sb.append("</ul></article>\n");
		logger.debug("sb="+sb.toString());
		logger.debug("getUtilMenuHTML ended");
		
		return sb.toString();
	}
	
	public String getMainMenuHTML (String pCallingMenuID, String pUID, LoginVO userInfo) throws Exception {
		List<PortalGetMainMenuHtmlVO> result = getMainMenuHtml(pUID, pCallingMenuID, Integer.parseInt(userInfo.getSkinNum()), userInfo.getTenantId());
		
		StringBuilder sb = new StringBuilder();
        if (userInfo.getTheme().equals("BASIC")) {
        	sb.append("</header>\n");
        }
		sb.append("<nav>\n");
        sb.append("<ul class='topmenu'>");
        
        for (int i=0; i<result.size(); i++) {
			if (!checkViewRightBln(result.get(i).getuID(), getAccessList(userInfo), userInfo.getTenantId())) {
				continue;
			}
			
			String menuitemUID = result.get(i).getuID();
			String menuitemDisplayName = result.get(i).getDisplayName();
			String menuitemImageUID = result.get(i).getImageUId();
			String menuitemLinkURL = result.get(i).getLinkURL();
			String menuitemLinkLocation = result.get(i).getLinkLocation();
			String menuitemWindowOption = result.get(i).getWindowOption();
			String menuitemNormalImagePath = result.get(i).getNormalImagePath();

			if (menuitemImageUID != null && !menuitemImageUID.trim().equals("") && menuitemNormalImagePath != null && !menuitemNormalImagePath.trim().equals("")) {
				sb.append("<li>" + getImageHTML(pCallingMenuID, menuitemImageUID, false, menuitemUID, userInfo) + "</li>");
			} else {
				sb.append("<li ");
				
				if (menuitemLinkURL != null && !menuitemLinkURL.trim().equals("")) {
                    sb.append(" onclick='OpenWindow(event, \"" + menuitemLinkURL + topLoadGetParameters(menuitemLinkURL, result.get(i).getuID(), userInfo) + "\"");
					sb.append(", \"" + menuitemLinkLocation + "\"");
					sb.append(", \"" + menuitemWindowOption.trim() + "\")'");
				}
				
				sb.append(">" + menuitemDisplayName + "</li>");
			}
        }
        
        sb.append("</ul></nav>");
		return sb.toString();
	
	}
	
	public String getSubMenuHTML (String pCallingMenuID, String pUID, LoginVO userInfo) throws Exception {
		List<PortalMenuItemItemsMenuItemsVO> result = getSubMenuHtml(pCallingMenuID, pUID, userInfo.getTenantId());
		
		StringBuilder sb = new StringBuilder();
		sb.append(" <div class=\"topSubMenu\">");
		
		for (int i=0; i<result.size(); i++) {
			String leftMargin = result.get(i).getLeftMargin();
			List<PortalMenuItemItemsMenuItemsSVO> result2 = getSubMenuHtml2(result.get(i).getParentMenuID(), userInfo.getTenantId());
			
			if (result2.size() == 0) {
				 sb.append("<ul id=\"menu" + result.get(i).getParentMenuID() + "\" id=\"menu01_sub\" style=\"DISPLAY:none;top:0px;left:" + leftMargin + "px\"></ul>");
				continue;
			}
			String parentMenuID = result2.get(0).getParentMenuID();
			sb.append("<ul id=\"menu_" + parentMenuID + "\" id=\"menu01_sub\" style=\"DISPLAY:none;top:0px;left:" + leftMargin + "px\" onmouseover=\"submenuover()\" onmouseout=\"submenuout()\"><li class=\"left\">");
			for (int j=0; j<result2.size(); j++) {
				if (!checkViewRightBln(result2.get(j).getuID(), getAccessList(userInfo), userInfo.getTenantId())) {
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
	
	}
	
	public String getSearchHTML (String pCallingMenuID, String pUID) {
		try {
			  StringBuilder searchHTML = new StringBuilder();
              searchHTML.append("<div class='top_search'>\n");
              searchHTML.append("<input id='input_search' class='input_text' type='text' onfocus=\"this.className='input_text focus'; \" onblur='input_Onblur(this)' onkeyup='Key_event(event);' onmousedown='keyword_Clear(this);' />");
              searchHTML.append("<input type='image' src='/images/kr/cm/top_search_btn.gif' alt='' class=\"topsearch_btn\" onclick=\"Emp_Search()\">");
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
             searchHTML.append("<input type='image' src='/images/kr/cm/top_search_btn.gif' alt=''  class='topsearch_btn ' onclick=\"Emp_Search()\">");
             searchHTML.append("</div>");
			return searchHTML.toString();
		} catch (Exception e) {
			e.printStackTrace();
			return "";
		}
	}
	
	public String getUtilImageHTML (String menuItemDisplayName, String pCallingMenuID, String pUID, String logoutclass, String pContentsUID, LoginVO userInfo) throws Exception {
		String pSkinNum = "";
		String strHTML = "";
		if (pContentsUID.equals("203")) {
			pSkinNum = userInfo.getSkinNum();
		} else {
			pSkinNum = "1";
		}
		
		StringBuilder sb = new StringBuilder();
		
		PortalMenuItemItemsImageVO result = getImageHtml(pUID, pCallingMenuID, Integer.parseInt(pSkinNum), userInfo.getTenantId());

		if (result != null) {
            String imageNormalImagePath = result.getNormalImagePath();
            String imageOverImagePath = result.getOverImagePath();
            int imageImageWidth = result.getImageWidth();
            int imageImageHeight = result.getImageHeight();
            String imageLinkURL = result.getLinkURL();
            String imageLinkLocation = result.getLinkLocation();
            String imageWindowOption = result.getWindowOption();
            
            if (imageNormalImagePath != null && !imageNormalImagePath.equals("")) {
            	sb.append("<li><img src='" + imageNormalImagePath + "'");
                if (imageOverImagePath != null && !imageOverImagePath.equals("")) {
                	sb.append(" id=\"" + imageNormalImagePath.substring(imageNormalImagePath.lastIndexOf("/") + 1).split("\\.")[0] + "\" onmouseover=\"img_onMouseOver('" + imageOverImagePath + "', this);\" onmouseout=\"img_onMouseOut(this);\"");
                }
                if (!imageLinkURL.equals("")) {
                    sb.append(" style='cursor:pointer'");
                    sb.append(" onclick='OpenWindow(event, \"" + imageLinkURL + topLoadGetParameters(imageLinkURL, pUID, userInfo) + "\"");
                    sb.append(", \"" + imageLinkLocation + "\"");
                    sb.append(", \"" + imageWindowOption + "\")'");
                }
                if (imageImageWidth != 0 && userInfo.getTheme().equals("BASIC")) {
                	sb.append(" width='" + imageImageWidth + "'");
                }
                if (imageImageHeight != 0 && userInfo.getTheme().equals("BASIC")) {
                	sb.append(" height='" + imageImageHeight + "'");
                }
                sb.append("></li>\n");
                strHTML = sb.toString();

                sb.delete(0, sb.length());
                sb.append(strHTML);
            }
		}
		
		return sb.toString();
		
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
	
	public String getRenderedPortalPageHTML (String pPortalPageID, String pAccessIDList, String pMode, LoginVO userInfo, String pTheme, String pTableViewOption, int tenantID) throws Exception {
		if (pTheme != null && !pTheme.trim().equals("")) {
			userInfo.setTheme(pTheme);
		}
		
		if (pTableViewOption != null && !pTableViewOption.trim().equals("")) {
			userInfo.setTableViewOption(pTableViewOption);
		}
		
		if (pMode.equals("view")) {
			if (!checkViewRightBln(pPortalPageID, getAccessList(userInfo), userInfo.getTenantId())) {
				return "<table width=100% height=100% border=0><tr><td align=center>페이지를 볼 권한이 없습니다.</td></tr></table>";
			}
			String cacheValue = checkCacheValue(pPortalPageID, getAccessList(userInfo), userInfo.getTenantId());

			if (cacheValue != null && !cacheValue.trim().equals("")) {
				return cacheValue;
			}
		}
	
		StringBuilder sb = new StringBuilder();
        String pageWidth, pageHeight, pageColumnLength, pageColumnSplit;

        String RootParentUID = getTopParentPageIDStr(pPortalPageID, tenantID);

        String boarderValue = "0";
        int i= 0;
        if (pPortalPageID.equals(RootParentUID)) {
        	userInfo.setRootPage(true);
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

        PortalGetRenderedTopMenuInsertVO result = getRenderedPortalPageHtml(pPortalPageID, userInfo.getTenantId());

        if (result == null) {
        	return defaultValue;
        }
        
        pageWidth = getPortalConfigItem("Width",RootParentUID, userInfo.getTenantId());
        pageHeight = getPortalConfigItem("Height",RootParentUID, userInfo.getTenantId());
        pageColumnLength = getPortalConfigItem("ColumnLength",RootParentUID, userInfo.getTenantId());
        pageColumnSplit = getPortalConfigItem("ColumnSplit",RootParentUID, userInfo.getTenantId());

        if (pMode.equals("edit")) {
        	sb.append("<table id='main_table' border=" + boarderValue + " cellpadding=0 cellspacing=0 ");
            if (!("-1").equals(pageWidth) && !("0").equals(pageWidth) && !("").equals(pageWidth) && pageWidth.toLowerCase().equals("null")) sb.append("width=" + pageWidth + "px ");
            else sb.append("width=100% ");
            if (!("-1").equals(pageHeight) && !("0").equals(pageHeight) && !("").equals(pageHeight) && pageHeight.toLowerCase().equals("null")) sb.append("height=" + pageHeight + "px ");
            else sb.append("height=100% ");
            sb.append("style='table-layout:fixed;'>\n");
            sb.append("<tr id='main_row'>\n");
        } else {
        	if (userInfo.getTheme().equals("BASIC")) {
        		sb.append("<div id='Center'>");
        	}
        }
        	for (i=0; i<Integer.parseInt(pageColumnLength); i++) {
        		if (pMode.equals("edit")) {
        			String columnWidth = "*";
        			if (i == Integer.parseInt(pageColumnLength) - 1) {
        				sb.append("<TD id=td0 vAlign=top");
        				if (pageColumnSplit != null && !pageColumnSplit.equals("")) {
        					if (pageColumnSplit.split("\\;")[i] != null && !pageColumnSplit.split("\\;")[i].equals("") && !pageColumnSplit.split("\\;")[i].equals("*")) {
        						columnWidth = pageColumnSplit.split("\\;")[i] + "px";
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
                    }
                    sb.append(getRenderedPortalPageColumn(pPortalPageID, pAccessIDList, i + 1, pMode, userInfo));
                    sb.append("</tbody>\n</table>\n</td>\n");
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
        		updateCacheValue(pPortalPageID, getAccessList(userInfo), sb.toString(), userInfo.getTenantId());
        	}
			
		return sb.toString();
	}
	
	public String getRenderedPortalPageHTMLInsert (String pCallingPageID , String pPortalPageID, String pAccessIDList, String pMode, LoginVO userInfo) throws Exception {
		StringBuilder sb = new StringBuilder();
       
        String pageWidth, pageHeight, pageColumnLength,	pageColumnSplit;
        String RootParentUID = getTopParentPageIDStr(pPortalPageID, userInfo.getTenantId());
        String boarderValue = "0";
        int i= 0;
        if (pPortalPageID.equals(RootParentUID)) {
        	//bRootPage = true;
        	userInfo.setRootPage(true);
        }
        if (pMode.equals("edit")) {
        	boarderValue = "1";
        }
        
        StringBuilder dsb = new StringBuilder();
        dsb.append("<table id='main_table_"+ UUID.randomUUID().toString().substring(0, 4)  +"' border=" + boarderValue + " cellpadding=0 cellspacing=0 width=100% height=100% style='table-layout:fixed;boarder-collapse:collapse'>\n");
        dsb.append("<tr id='main_row'>\n");
        dsb.append("<td id='td"+ UUID.randomUUID().toString().substring(0, 4) +"' valign=top onclick='selectcell(event)'><table border=0 cellpadding=0 cellspacing=0 width=100% valign=top>\n");
        dsb.append("<TBODY>");
        if (pMode.equals("edit")) {
        	dsb.append("<TR style='WIDTH: 100%; HEIGHT: 10px' onclick='selectcellTitle(event)'><td align=center>*</td></TR>");
        }
        dsb.append("</TBODY></table></td>");
        dsb.append("</tr></table>");
        String defaultValue = dsb.toString();
        
        PortalGetRenderedTopMenuInsertVO result = getRenderedPortalPageHtml(pPortalPageID, userInfo.getTenantId());
        
        if (result == null) {
        	return defaultValue;
        }
        
        pageWidth = getPortalConfigItem("Width",RootParentUID, userInfo.getTenantId());
        pageHeight = getPortalConfigItem("Height",RootParentUID, userInfo.getTenantId());
        pageColumnLength = getPortalConfigItem("ColumnLength",RootParentUID, userInfo.getTenantId());
        pageColumnSplit = getPortalConfigItem("ColumnSplit",RootParentUID, userInfo.getTenantId());
        
        if (pMode.equals("edit")) {
        	sb.append("<table id='main_table_"+ UUID.randomUUID().toString().substring(0, 4) +"' border=" + boarderValue + " cellpadding=0 cellspacing=0 ");
            if (!("-1").equals(pageWidth) && !("0").equals(pageWidth) && !("").equals(pageWidth) && pageWidth.toLowerCase().equals("null")) sb.append("width=" + pageWidth + "px ");
            else sb.append("width=100% ");
            if (!("-1").equals(pageHeight) && !("0").equals(pageHeight) && !("").equals(pageHeight) && pageHeight.toLowerCase().equals("null")) sb.append("height=" + pageHeight + "px ");
            else sb.append("height=100% ");
            sb.append("style='table-layout:fixed;'>\n");
            sb.append("<tr id='main_row'>\n");
        }
        
        for (i=0; i<Integer.parseInt(pageColumnLength); i++) {
        	if (pMode.equals("edit")) {
        		String columnWidth = "*";
        		if (i == Integer.parseInt(pageColumnLength) - 1) {
        			if (i ==0) {
        				sb.append("<TD id=td0"+UUID.randomUUID().toString().substring(0, 4) +"' vAlign=top>\n");
        			} else {
        				sb.append("<TD id=td0"+UUID.randomUUID().toString().substring(0, 4) +"' valign=top");
        				if (pageColumnSplit != null && !pageColumnSplit.equals("")) {
            				if (pageColumnSplit.split(";")[i] != null && !pageColumnSplit.split(";")[i].equals("") && !pageColumnSplit.split(";")[i].equals("*")) {
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
        		} else {
        			sb.append("<td id='td" + UUID.randomUUID().toString().substring(0, 4) + "' valign=top");
        			if (pageColumnSplit != null && !pageColumnSplit.equals("")) {
        				if (pageColumnSplit.split(";")[i] != null && !pageColumnSplit.split(";")[i].equals("") && !pageColumnSplit.split(";")[i].equals("*")) {
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
        		if (userInfo.getTableViewOption().equals("D")) {
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
		return sb.toString();
	
	}
	
	public String getTopParentPageIDStr (String pPortalPageID, int tenantID) throws Exception {
		String temp = pPortalPageID;
		String parentPortalPageID = "";
		String previousPageID = pPortalPageID;
		int count = 0;
		while (count < 10) {
			parentPortalPageID = getTopParentPageID(temp, tenantID);
			
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
	}
	
	public String getRenderedPortalPageColumn (String pPortalPageID, String pAccessIDList, int pColumnIndex, String pMode, LoginVO userInfo) throws Exception {
		List<PortalTBLPortalPageItemsVO> result = new ArrayList<PortalTBLPortalPageItemsVO>();
		StringBuilder sb = new StringBuilder();
		String strSQL = "";
        
        String parentPortalPageID = pPortalPageID;
        int count = 0;

        strSQL = "SELECT * FROM EZPORTAL.TBL_PORTALPAGE_ITEMS  WHERE PAGEUID = '"+pPortalPageID+"' AND COLUMNPOS = " + pColumnIndex +" AND TENANT_ID = " + userInfo.getTenantId();
        
        while (count < 10) {
        	parentPortalPageID = getPortalParentUID(parentPortalPageID);

        	if (parentPortalPageID != null && parentPortalPageID.toLowerCase().trim().equals("top")) {
        		break;
        	}
        	//String param = String.valueOf(count);
        	String param = parentPortalPageID;
        	strSQL += " UNION ALL SELECT * FROM EZPORTAL.TBL_PORTALPAGE_ITEMS  WHERE PAGEUID = '" + param + "' AND COLUMNPOS = " + pColumnIndex +" AND TENANT_ID = " + userInfo.getTenantId();
        	count ++;
        }
        
        if (userInfo.isRootPage() == true) {
        	result = getTBLPortalPageItemsT(strSQL);
        } else {
        	result = getTBLPortalPageItemsF(strSQL, userInfo.getId(), getTopParentPageIDStr(pPortalPageID, userInfo.getTenantId()));

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
        			if (checkViewRightBln(portletUID, getAccessList(userInfo), userInfo.getTenantId()) == true) {
        				sb.append("<TD id=subtd" + String.valueOf(pColumnIndex * 100 + i + 1) + " style='WIDTH: 100%; HEIGHT:" + portletHeight + "' align=middle uid='" + portletUID + "' pageuid='" + portletPageUID + "' ownerpageuid='" + portletOwnerPageUID + "' mandatory='" + portletMandatory + "' canremove='" + portletCanRemove + "' canresize='" + portletCanResize + "' canreplace='" + portletCanReplace + "'><B>" + portletDisplayName + "</B></TD>\n");
        			}
        		} else {
        			sb.append("<TD id=subtd" + String.valueOf(pColumnIndex * 100 + i + 1) + " style='WIDTH: 100%; HEIGHT:" + portletHeight + "' align=middle uid='" + portletUID + "' pageuid='" + portletPageUID + "' ownerpageuid='" + portletOwnerPageUID + "' canremove='" + portletCanRemove + "' canresize='" + portletCanResize + "' canreplace='" + portletCanReplace + "'>" + getRenderedPortalPageHTMLInsert(pPortalPageID, portletUID, "", "edit", userInfo) + "</TD>\n");
        		}
        		sb.append("</TR>\n");
        	} else {
        		if (userInfo.getTableViewOption().equals("D")) {
        			if (i == 0) {
        				sb.append("<div class='section1_bg'><section class='section1'>\n");
        			} else {
        				if (userInfo.getTheme() != null && !userInfo.getTheme().equals("BASIC") && loadFlag) {
        					sb.append("<div id='Center'>");
                            loadFlag = false;
        				}
        				
        				sb.append("<section class='section" + (i + 1) + "'>\n");
        			}
        			if (portletType == 0) {
        				if (checkViewRightBln(portletUID, getAccessList(userInfo), userInfo.getTenantId()) == true) {
        					portletMoveURL = getPortletConfigItem("URL",portletUID, userInfo.getTenantId());
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
        					if (checkViewRightBln(portletUID, getAccessList(userInfo), userInfo.getTenantId()) == true) {
        						portletMoveURL = getPortletConfigItem("URL",portletUID, userInfo.getTenantId());
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
        				if (userInfo.getTableViewOption().equals("T") && loadFlag) {
        					sb.append("<div id='Center' style=' margin-top: 15px; '>");
                            sb.append("<table border='0' cellpadding='0' cellspacing='0' width='100%'>");
                            sb.append("<tbody>");
        				}
        				
        				sb.append("<TR>");
        				
        				if (portletType == 0) {
        					if (checkViewRightBln(portletUID, getAccessList(userInfo), userInfo.getTenantId()) == true) {
        						portletMoveURL = getPortletConfigItem("URL",portletUID, userInfo.getTenantId());
        						sb.append("<TD id=subtd" + String.valueOf(pColumnIndex * 100 + i + 1) + " style='WIDTH: 100%; HEIGHT:" + portletHeight + " align=middle valign=top uid='" + portletUID + "' canremove='" + portletCanRemove + "' canresize='" + portletCanResize + "' canreplace='" + portletCanReplace + "' style='padding-left:" + portletPaddingLeft + ";padding-right:" + portletPaddingRight + ";padding-top:" + portletPaddingTop + ";padding-bottom:" + portletPaddingBottom + "'><iframe width=100% height=100% border=0 src='" + portletMoveURL + loadGetParameters(portletMoveURL, portletUID, userInfo) + "' frameborder=0 scrolling=no></iframe></TD>\n");
        					}
        				} else {
        					sb.append(getRenderedPortalPageHTMLInsert(pPortalPageID, portletUID, "", "view", userInfo));
        				}
        				sb.append("</TR>\n");
        				
        				if (userInfo.getTableViewOption().equals("T") && loadFlag) {
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
	
	}
	
	public String getRenderedPortalPageColumnInsert (String pPortalPageID, String pCallingPageID, String pAccessIDList, int pColumnIndex, String pMode, LoginVO userInfo) throws Exception {
		List<PortalTBLPortalPageItemsVO> result = new ArrayList<PortalTBLPortalPageItemsVO>();
		StringBuilder sb = new StringBuilder();
		String strSQL = "";
        String parentPortalPageID = pCallingPageID;
        int count = 0;
        
        strSQL = "SELECT * FROM ezPortal.TBL_PortalPage_Items  WHERE PageUID = '"+pPortalPageID+"' AND ColumnPos = " + pColumnIndex + " AND OwnerPageUID = '" + getItemLastPageID(pPortalPageID, userInfo.getTenantId()) + "'" ;
        
        while (count < 10) {
        	parentPortalPageID = getPortalParentUID(parentPortalPageID);

        	String param = parentPortalPageID;
        	strSQL += " UNION ALL SELECT * FROM ezPortal.TBL_PortalPage_Items  WHERE PageUID = '" + pPortalPageID + "' AND ColumnPos = " + pColumnIndex + " AND OwnerPageUID = '" + param +"'";
        	count ++;
        }
        
        if (userInfo.isRootPage() == true) {
        	result = getTBLPortalPageItemsT(strSQL);
        } else {
        	result = getTBLPortalPageItemsF(strSQL, userInfo.getId(), getTopParentPageID(pPortalPageID, userInfo.getTenantId()));
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
            			if (checkViewRightBln(portletUID, getAccessList(userInfo), userInfo.getTenantId()) == true) {
            				sb.append("<TD id=subtd" + UUID.randomUUID().toString().substring(0, 4) + " style='WIDTH: 100%; HEIGHT:" + portletHeight + "' align=middle uid='" + portletUID + "' pageuid='" + portletPageUID + "' ownerpageuid='" + portletOwnerPageUID + "' mandatory='" + portletMandatory + "' canremove='" + portletCanRemove + "' canresize='" + portletCanResize + "' canreplace='" + portletCanReplace + "'><B>" + portletDisplayName + "</B></TD>\n");
        			}
        		} else {
        			sb.append("<TD id=subtd" + UUID.randomUUID().toString().substring(0, 4) + " style='WIDTH: 100%; HEIGHT:" + portletHeight + "' align=middle uid='" + portletUID + "' pageuid='" + portletPageUID + "' ownerpageuid='" + portletOwnerPageUID + "' canremove='" + portletCanRemove + "' canresize='" + portletCanResize + "' canreplace='" + portletCanReplace + "'>" + getRenderedPortalPageHTMLInsert(pPortalPageID, portletUID, "", "edit", userInfo) + "</TD>\n");
        		}
        		sb.append("</TR>\n");
        	} else {
        		if (userInfo.getTableViewOption().equals("D")) {
        			if (portletType == 0) {
        				if (checkViewRightBln(portletUID, getAccessList(userInfo), userInfo.getTenantId()) == true) {
        					portletMoveURL = getPortletConfigItem("URL",portletUID, userInfo.getTenantId());
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
        				if (checkViewRightBln(portletUID, getAccessList(userInfo), userInfo.getTenantId()) == true) {
        					portletMoveURL = getPortletConfigItem("URL",portletUID, userInfo.getTenantId());
        					
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
	
	}
	
	public String getThemeInfoPortal(String pCompanyID, LoginVO userInfo, String pSelectThemeUID) throws Exception {
		List<PortalGetThemeListVO> list = getThemeList(pCompanyID, userInfo.getTenantId());
		
		StringBuilder pThemeSelectObject = new StringBuilder();
		for (int i=0; i<list.size(); i++) {
			if (pSelectThemeUID != null && pSelectThemeUID.equals(list.get(i).getuID())) {
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
		
	}
	
	public String newMyPortalPageCreate (String pParentPageID, String pUserID, String pGubunFlag, String pCompanyID, String pPageID, int tenantID) throws Exception {
		String newPageID = UUID.randomUUID().toString();
		int recordCnt = 0;
		
		if (pPageID.length() == 0) {
			recordCnt = newMyPortalPageCreate(pParentPageID, pPageID, pUserID, pGubunFlag, newPageID, 2, pCompanyID, "everyone", "최상위회사", 2, 2, "empty", tenantID);
		} else {
			recordCnt = newMyPortalPageCreate(pParentPageID, pPageID, pUserID, pGubunFlag, newPageID, 2, pCompanyID, "everyone", "최상위회사", 2, 2, "full", tenantID);
		}
		
		if (recordCnt != 0) {
			String baseMyPortalPageUID = newMyPortalPageCreate2("Y", pUserID, pCompanyID, tenantID);
			
			newMyPortalPageCreate3("Y", baseMyPortalPageUID, pCompanyID, pUserID, tenantID);
			return "OK";
		} else {
			return "OK";
		}
	}
	
	public String getPorletPropertiesStr(String pUID, int tenantID) throws Exception {
		PortalPortletGeneralVO result = getPorletProperties(pUID, tenantID);
		String resultXML = "<DATA>"+commonUtil.getQueryResult(result)+"</DATA>";
		return resultXML;
		
	}
	
	public String getPortletSubProperties (String pUID, String pType) throws Exception {
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
	}
	
	public String getPortletParameters (String pUID, int tenantID) throws Exception {
		List<PortalGetPortletParametersVO> result = getPortletParametres(pUID, tenantID);
		String resultXML = "";
		resultXML = "<DATA>";
		for (int i=0; i<result.size(); i++) {
			resultXML += commonUtil.getQueryResult(result.get(i));
		}
		resultXML += "</DATA>";
		return resultXML;
	}
	
	public String getBoardProperty (String pBoardID, String lang, int tenantID) throws Exception {
		String boardInfo = "";
		
		BoardPropertyVO result = ezBoardService.getBoardProperty(pBoardID, tenantID);
		if (result.getBoardName() != null && !result.getBoardName().equals("")) {
			if (lang.equals("1")) {
				boardInfo = result.getBoardName() + ":" + result.getGuBun();
			} else {
				boardInfo = result.getBoardName2().equals("") ? result.getBoardName() : result.getBoardName2() + ":" + result.getGuBun();
			}
		}
		return boardInfo;
	}
	
	public String addBestTable (LoginVO userInfo) throws Exception {
		logger.debug("addBestTable started");

StringBuilder strData = new StringBuilder();
		
		boolean firstFlag = true;
		int val = 0;
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_USERINFO_LANG", commonUtil.getMultiData(userInfo.getLang()));
		map.put("tenantID", userInfo.getTenantId());
		
		List<CommunityMyCommunityVO> list = ezCommunityDAO.mainPageGet5(map);
		
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
						//bannerSrc = "/ezCommon/downloadAttach.do?filePath=" + "/files/upload_community/logo/"+list.get(i).getC_Logo_Thumbnail();
						bannerSrc = "/ezCommon/downloadAttach.do?filePath=" + commonUtil.getUploadPath("upload_community.LOGO", userInfo.getTenantId())+commonUtil.separator+list.get(i).getC_Logo_Thumbnail();
					}
					logger.debug("bannerSrc="+bannerSrc);
					
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
				strData.append("<p>" + egovMessageSource.getMessage("main.t00026", userInfo.getLocale()) + "</p></div>");
				break;
			}
			readTF = true;
		}
		if (!readTF) {
			if (list == null) {
				strData.append("<div class='nodata_portlet '>");
				strData.append("<p><img src='/images/kr/main/nodata_white.gif' width='107' height='70'></p>");
				strData.append("<p>" + egovMessageSource.getMessage("main.t00026", userInfo.getLocale()) + "</p></div>");
			}
		}
		
		return strData.toString();
	}
	
	public String memberChk (String cNo, LoginVO userInfo) throws Exception {
		String ret = "1";
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put(cNo, userInfo.getId());
		map.put("tenantID", userInfo.getTenantId());
		CommunityCClubUserVO result = ezCommunityDAO.getCateDetailViewGet4(map);
		if (result != null) {
			ret = "1";
		} else {
			ret = "0";
		}

		logger.debug("addBestTable ended");
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
	
	public String ezAclCheck (String pCN, String pCompanyID, String pCompanyNm, int tenantID) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pCOMPANYID", pCompanyID);
		map.put("v_pCN", pCN);
		map.put("tenantID", tenantID);
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
	
	public List<PortalMyPortalListVO> myPortalList (String pGubunFlag, String pAccessIDList, String pCompanyID, int tenantID) throws Exception {
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
		map.put("tenantID", tenantID);
		List<PortalMyPortalListVO> list = ezPortalDAO.myPortalList(map);
		
		return list;
	}
	
	public int searchMyPortalPageCount (String pGubunFlag, String pAccessIDList, String pCompanyID, int tenantID) throws Exception {
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
		map.put("tenantID", tenantID);
		int count = ezPortalDAO.searchMyPortalPageCount(map);
		
		return count;
	}
	
	public String searchMyPortal (String pDisplayName, String pGubunFlag, int pStartRow, int pEndRow, String pCompanyID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pCOMPANYID", pCompanyID);
		map.put("v_pENDROW", pEndRow);
		map.put("v_pDISPLAYNAME", pDisplayName);
		map.put("v_pGUBUNFLAG", pGubunFlag);
		map.put("tenantID", tenantID);
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
	
	public String useTopMenuID2( String pCompanyID, String pUseFlag, String pLang, String pUserThemeUID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pCOMPANYID", pCompanyID);
		map.put("v_pUSEFLAG", pUseFlag);
		map.put("v_pLANG", pLang);
		map.put("v_pUSERTHEMEUID", pUserThemeUID);
		map.put("tenantID", tenantID);
		List<PortalUseTopMenuID2VO> list = ezPortalDAO.useTopMenuID2(map);
		
		String useTopMenuIDXml = "";
		useTopMenuIDXml += "<DATA>";
		for (PortalUseTopMenuID2VO result : list) {
			useTopMenuIDXml += commonUtil.getQueryResult(result);
		}
		useTopMenuIDXml += "</DATA>";
		
		logger.debug("useTopMenuIDXml="+useTopMenuIDXml);
		return useTopMenuIDXml;
	}
	
	public String useTopMenuID( String pCompanyID, String pUseFlag, String pUserThemeUID, int tenantID) throws Exception {
		logger.debug("useTopMenuID started");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pCOMPANYID", pCompanyID);
		map.put("v_pUSEFLAG", pUseFlag);
		map.put("v_pUSERTHEMEUID", pUserThemeUID);
		map.put("tenantID", tenantID);
		
		logger.debug("pUserThemeUID="+pUserThemeUID);
		List<PortalUseTopMenuID2VO> list = ezPortalDAO.useTopMenuID(map);
		
		String useTopMenuIDXml = "";
		useTopMenuIDXml += "<DATA>";
		for (PortalUseTopMenuID2VO result : list) {
			useTopMenuIDXml += commonUtil.getQueryResult(result);
		}
		useTopMenuIDXml += "</DATA>";
		logger.debug("useTopMenuID ended");
		
		return useTopMenuIDXml;
	
	}
	
	
	public String searchStartPage( String pHomeUID, String pParentUID, String pImageUID, String pUserID, String pCompanyID, String pLinkURL, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pPARENTUID", pParentUID);
		map.put("v_pUSERID", pUserID);
		map.put("v_pCOMPANYID", pCompanyID);
		map.put("v_pHOMEUID", pHomeUID);
		map.put("v_pIMAGEUID", pImageUID);
		map.put("v_pLINKURL", pLinkURL);
		map.put("tenantID", tenantID);
		
		String temp1 = ezPortalDAO.searchStartPage_S(map);
		
		if (temp1 != null && temp1.equals("1")) {
			ezPortalDAO.searchStartPage(map);
		}
		
		Map<String, Object> map1 = new HashMap<String, Object>();
		map1.put("v_pPARENTUID", pParentUID);
		map1.put("v_pUSERID", pUserID);
		map1.put("v_pCOMPANYID", pCompanyID);
		map1.put("tenantID", tenantID);
		
		String temp = ezPortalDAO.searchStartPage2_S(map1);
		String result = "";
		if (temp != null && temp.equals("1")) {
			result = ezPortalDAO.searchStartPage2(map1);
		}
		
		return result;
	}
	
	public String setUseMyStartPage (String pUID, String pOldUID, String pUserID, String pCompanyID, String langStr, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pOLDUID", pOldUID);
		map.put("v_pUSERID", pUserID);
		map.put("v_pCOMPANYID", pCompanyID);
		map.put("v_pLANGSTR", langStr);
		map.put("v_pUID", pUID);
		map.put("tenantID", tenantID);
		
		ezPortalDAO.setUseMyStartPage2_D(map);
		ezPortalDAO.setUseMyStartPage2(map);
		return "OK";
	}
	
	public String setUseMyPortalPage (String pUID, String pUserID, String pCompanyID, String pGubunFlag, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pUID", pUID);
		map.put("v_pUSERID", pUserID);
		map.put("v_pCOMPANYID", pCompanyID);
		map.put("v_pGUBUNFLAG", pGubunFlag);
		map.put("v_pUSEFLAG", "Y");
		map.put("tenantID", tenantID);
		ezPortalDAO.setUseMyPortalPage(map);
		ezPortalDAO.setUseMyPortalPage_U(map);
		return "OK";
	}
	
	public String searchPortalPage (String pDisplayName, String pUseFlag, String pGubunFlag, int pStartRow, int pEndRow, String pAccessIDList, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_ENDROW", pEndRow);
		map.put("v_DISPLAYNAME", pDisplayName);
		map.put("v_USERFLAG", pUseFlag);
		map.put("v_GUBUNFLAG", pGubunFlag);
		map.put("v_ARRPARAM", pGubunFlag);
		map.put("tenantID", tenantID);
		List<PortalSearchPortalPageVO> list = ezPortalDAO.searchPortalPage(map); 

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
	
	public String searchPortletCheckRight (String pDisplayName, String pGubunFlag, String pPageGubunFlag, String pMode, int pStartRow, int pEndRow, LoginVO userInfo, String pCompanyID, int tenantID) throws Exception {
		String retXML = "";
		
		Map<String, Object> map = new HashMap<String, Object>();
		if (pGubunFlag != null && !pGubunFlag.equals("")) {
			map.put("v_pGUBUNFLAG", Integer.parseInt(pGubunFlag));
		} else {
			map.put("v_pGUBUNFLAG", 100);
		}
		map.put("v_pPAGEGUBUNFLAG", pPageGubunFlag);
		map.put("v_pDISPLAYNAME", makeSearchField(pDisplayName));
		map.put("v_pENDROW", pEndRow);
		map.put("v_pCOMPANYID", pCompanyID);
		map.put("tenantID", tenantID);
		
		List<PortalPortletGeneralVO> list = ezPortalDAO.searchPortletCheckRight2(map);

		retXML += "<DATA>";
		for (int i=0; i<list.size(); i++) {
			if (i >= pStartRow -1) {
				if (pMode.equals("view")) {
					if (checkViewRightBln(list.get(i).getuID_(), getAccessList(userInfo), userInfo.getTenantId()) == true) {
						retXML += "<ROW>";
                        retXML += "<UID_>" + list.get(i).getuID_().trim() + "</UID_>";
                        retXML += "<DISPLAYNAME>" + list.get(i).getDisplayName().trim() + "</DISPLAYNAME>";
                        retXML += "<DISPLAYNAME2>" + list.get(i).getDisplayName2().trim() + "</DISPLAYNAME2>";
                        if (list.get(i).getPortlet_Type() == 1) {
                        	retXML += "<TYPE>URL 포틀릿</TYPE>";
                        }
                        if (list.get(i).getPortlet_Type() == 2) {
                        	retXML += "<TYPE>HTML 포틀릿</TYPE>";
                        }
                        if (list.get(i).getPortlet_Type() == 3) {
                        	retXML += "<TYPE>이미지 포틀릿</TYPE>";
                        }
                        if (list.get(i).getPortlet_Type() == 4) {
                        	retXML += "<TYPE>게시판 포틀릿</TYPE>";
                        }

                        retXML += "<URL>" + list.get(i).getUrl() + "</URL>";
                        retXML += "<HEIGHT>" + list.get(i).getHeight() + "</HEIGHT>";
                        retXML += "</ROW>";
					}
				} else if (pMode.equals("edit")) {
					if (checkEditRightBln(list.get(i).getuID_(), getAccessList(userInfo), userInfo.getTenantId()) == true) {
						retXML += "<ROW>";
                        retXML += "<UID_>" + list.get(i).getuID_().trim() + "</UID_>";
                        retXML += "<DISPLAYNAME>" + list.get(i).getDisplayName().trim() + "</DISPLAYNAME>";
                        retXML += "<DISPLAYNAME2>" + list.get(i).getDisplayName2().trim() + "</DISPLAYNAME2>";
                        if (list.get(i).getPortlet_Type() == 1) {
                        	retXML += "<TYPE>URL 포틀릿</TYPE>";
                        }
                        if (list.get(i).getPortlet_Type() == 2) {
                        	retXML += "<TYPE>HTML 포틀릿</TYPE>";
                        }
                        if (list.get(i).getPortlet_Type() == 3) {
                        	retXML += "<TYPE>이미지 포틀릿</TYPE>";
                        }
                        if (list.get(i).getPortlet_Type() == 4) {
                        	retXML += "<TYPE>게시판 포틀릿</TYPE>";
                        }

                        retXML += "<URL>" + list.get(i).getUrl() + "</URL>";
                        retXML += "<HEIGHT>" + list.get(i).getHeight() + "</HEIGHT>";
                        retXML += "</ROW>";
					}
				}
			}
		}
		retXML += "</DATA>";

		return retXML;
	}
	
	public String makeSearchField(String orgStr) {
		return orgStr.replace("'", "''").replace("\0", "").replace("[", "[[]").replace("%", "[%]").replace("_", "[_]");
	}
	
	public String searchMenuItem (String pDisplayName, int pStartRow, int pEndRow, String pAccessIDList, int tenantID) throws Exception {
		String retXML = "";
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pENDROW", pEndRow);
		map.put("v_pDISPLAYNAME", pDisplayName);
		map.put("tenantID", tenantID);
		List<PortalSearchMenuItemVO> list = ezPortalDAO.searchMenuItem(map);
		
		String strXML = "<DATA>";
		for (int i=0; i<list.size(); i++) {
			strXML += commonUtil.getQueryResult(list.get(i));
		}
		strXML += "</DATA>";
		
		Document xmlDom = commonUtil.convertStringToDocument(strXML);
		
		retXML = "<DATA>";
		for (int i=0; i<xmlDom.getElementsByTagName("UID_").getLength(); i++) {
			if (i >= pStartRow - 1) {
				retXML += "<ROW>";
				retXML += "<UID_>" + xmlDom.getElementsByTagName("UID_").item(i).getTextContent().trim() + "</UID_>";
				retXML += "<DISPLAYNAME>" + xmlDom.getElementsByTagName("DISPLAYNAME").item(i).getTextContent().trim() + "</DISPLAYNAME>";
				retXML += "</ROW>";
			}
		}
		retXML += "</DATA>";
		return retXML;
	}
	
	public String ezCkAdminACL(String pCN, String pPageID, String pACL, String userLang, int tenantID) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pOWNERPAGEID", pPageID);
		map.put("v_pLANG", userLang);
		map.put("tenantID", tenantID);
		
		String result = ezPortalDAO.ezCkAdminACL(map);
		
		if (result == null || result.equals("")) {
			result = " ";
		}
		
		Map<String, Object> map1 = new HashMap<String, Object>();
		map1.put("v_pACL", pACL);
		map1.put("v_pRESULT", result);
		map1.put("v_pACCESSID", pCN);
		map1.put("tenantID", tenantID);
		
		if (pACL != null && pACL.equals("3")) {
			String temp = ezPortalDAO.ezCkAdminACL2_S1(map1);
			
			if (temp != null && temp.equals("1")) {
				ezPortalDAO.ezCkAdminACL2_D1(map1);
			}
			
		} else {
			String temp = ezPortalDAO.ezCkAdminACL2_S2(map1);
			
			if (temp != null && temp.equals("1")) {
				ezPortalDAO.ezCkAdminACL2_I1(map1);
			} else {
				ezPortalDAO.ezCkAdminACL2_U1(map1);
			}
		}
		
		return "OK";
	}
	
}



