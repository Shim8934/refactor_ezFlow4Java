package egovframework.ezEKP.ezPortal.service.impl;

import java.io.File;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.UUID;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.w3c.dom.Document;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezPortal.dao.EzPortalAdminDAO;
import egovframework.ezEKP.ezPortal.service.EzPortalAdminService;
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
import egovframework.ezEKP.ezPortal.web.EzPortalController;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service("EzPortalAdminService")
public class EzPortalAdminServiceImpl extends EgovAbstractServiceImpl implements EzPortalAdminService  {
	
	private static final Logger logger = LoggerFactory.getLogger(EzPortalAdminServiceImpl.class);
	
	@Resource(name="EzPortaAdminDAO")
	private EzPortalAdminDAO ezPortalAdminDAO;
	
	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;
	
	@Resource(name="EzCommonService")
	private EzCommonService ezCommonService;
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private Properties globals;

	public String useThemeInfo(String pUID) {
		String pRValue = "";
		
		PortalUseThemeCheckVO result = ezPortalAdminDAO.useThemeCheck(pUID);
		
		int topUserCnt = result.getTopUserCount();
		int mainUserCnt = result.getPortalPage();
		
		if (topUserCnt > 0 && mainUserCnt > 0) {
			pRValue = "BOTH";
		} else if (topUserCnt > 0 && mainUserCnt == 0) {
			pRValue = "TOP";
		} else if (topUserCnt == 0 && mainUserCnt > 0) {
			pRValue = "MAIN";
		} else {
			pRValue = "NO";
		}
		
		return pRValue;
	}

	@Override
	public void deleteTheme(String uID) throws Exception {
		ezPortalAdminDAO.deleteTheme(uID);
	}

	@Override
	public void setThemeInfo(String uID, String disNm1, String disNm2, String disNm3, String disNm4, String imageURL, String topURL,
			String mainURL, String companyID, String creatorID, String creatorNm, int topHeight) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PUID", uID);
		map.put("v_PDISNM1", disNm1);
		map.put("v_PDISNM2", disNm2);
		map.put("v_PDISNM3", disNm3);
		map.put("v_PDISNM4", disNm4);
		map.put("v_PIMAGEURL", imageURL);
		map.put("v_PTOPURL", topURL);
		map.put("v_PMAINURL", mainURL);
		map.put("v_PCOMPANYID", companyID);
		map.put("v_PCREATORID", creatorID);
		map.put("v_PCREATORNM", creatorNm);
		map.put("v_TOPHEIGHT", topHeight);
		ezPortalAdminDAO.setThemeInfo(map);
	}
	
	@Override
	public void topSetUsePage2(String uID, String companyID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pUID", uID);
		map.put("v_pCOMPANYID", companyID);
		ezPortalAdminDAO.topSetUsePage2(map);
	}
	
	@Override
	public void topOutOfSetUsePage(String uID, String companyID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pUID", uID);
		map.put("v_pCOMPANYID", companyID);
		ezPortalAdminDAO.topOutOfSetUsePage(map);
	}
	
	@Override
	public void setUseLang(String uID, String companyID, String langStr) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pUID", uID);
		map.put("v_pCOMPANYID", companyID);
		map.put("v_pLANGSTR", langStr);
		ezPortalAdminDAO.setUseLang(map);
	}
	
	@Override
	public List<PortalTBLSkinGeneralVO> selectSkinGeneral() throws Exception {
		return ezPortalAdminDAO.selectSkinGeneral();
	}

	@Override
	public void portalSaveSkin(String uID, String skinName, String skinBgFlag, String skinBgColor, String skinBgImage, String skinFontColor, String skinFontOverColor) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_UID", uID);
		map.put("v_SKINNAME", skinName);
		map.put("v_SKINBGFLAG", skinBgFlag);
		map.put("v_SKINBGCOLOR", skinBgColor);
		map.put("v_SKINBGIMAGE", skinBgImage);
		map.put("v_SKINFONTCOLOR", skinFontColor);
		map.put("v_SKINFONTOVERCOLOR", skinFontOverColor);
		ezPortalAdminDAO.portalSaveSkin(map);
	}
	
	@Override
	public void setDefaultPage(String pUID, String setFlag, String pGubunFlag, String pCompanyID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PUSERFLAG", setFlag);
		map.put("v_PUID", pUID);
		map.put("v_PCOMPANYID", pCompanyID);
		map.put("v_PGUBUNFLAG", pGubunFlag);
		ezPortalAdminDAO.setDefaultPage(map);
	}
	
	@Override
	public List<PortalTBLPortalPageCategoryVO> getPortletCategory() throws Exception {
		return ezPortalAdminDAO.getPortletCategory();
	}
	
	@Override
	public List<PortalTBLBuiltInParametersVO> menuItemEdit() throws Exception {
		return ezPortalAdminDAO.menuItemEdit();
	}
	
	@Override
	public void savePortletSubProperty(Map<String, Object> map) throws Exception {
		ezPortalAdminDAO.savePortletSubProperty(map);
	}

	@Override
	public void savePortletSubProperty2(Map<String, Object> map) throws Exception {
		ezPortalAdminDAO.savePortletSubProperty2(map);
	}

	@Override
	public void savePortletSubProperty3(Map<String, Object> map) throws Exception {
		ezPortalAdminDAO.savePortletSubProperty3(map);
	}

	@Override
	public void savePortletSubProperty4(Map<String, Object> map) throws Exception {
		ezPortalAdminDAO.savePortletSubProperty4(map);
	}
	
	@Override
	public void removeParameter(int mode, String uID, String paramName) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_MODE", mode);
		map.put("v_UID", uID);
		map.put("v_PARAMNAVE", paramName);
		ezPortalAdminDAO.removeParameter(map);
	}
	
	@Override
	public PortalMenuItemItemsImageVO logoEdit(String uID, String pageID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_UID", uID);
		map.put("v_OWNERPAGEID", pageID);
		return ezPortalAdminDAO.logoEdit(map);
	}
	
	@Override
	public void saveLogoImage(Map<String, Object> map) throws Exception {
		ezPortalAdminDAO.saveLogoImage(map);
	}

	@Override
	public void saveLogoImage2(Map<String, Object> map) throws Exception {
		ezPortalAdminDAO.saveLogoImage2(map);
	}
	
	@Override
	public PortalTBLTopMenuItemsVO loadPositionSettings(Map<String, Object> map) throws Exception {
		return ezPortalAdminDAO.loadPositionSettings(map);
	}
	
	@Override
	public List<PortalMenuItemItemsMenuItemsVO> loadMenuItems(String pUID, String pPageID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pPARENTUID", pUID);
		map.put("v_pOWNERPAGEID", pPageID);
		return ezPortalAdminDAO.loadMenuItems(map);
	}
	
	@Override
	public List<PortalGetPortletParametersVO> getMenuItemParameters(String pUID) throws Exception {
		return ezPortalAdminDAO.getMenuItemParameters(pUID);
	}
	
	@Override
	public void removeMenuItem(String uID, String parentUID, String pageID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_UID", uID);
		map.put("v_PARENTUID", parentUID);
		map.put("v_OWNERPAGEID", pageID);
		ezPortalAdminDAO.removeMenuItem(map);
	}
	
	@Override
	public void updateMenuItemSetOrder(int columnPos, String uID, String ownerPageID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("columnPos", columnPos);
		map.put("uID", uID);
		map.put("ownerPageID", ownerPageID);
		ezPortalAdminDAO.updateMenuItemSetOrder(map);
	}
	
	@Override
	public List<PortalMenuItemItemsMenuItemsSVO> loadSubMenuItems (String pParentUID, String pPageID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PPARENTMENUID", pParentUID);
		map.put("v_POWNERPAGEID", pPageID);
		return ezPortalAdminDAO.loadSubMenuItems(map);
	}
	
	@Override
	public void removeSubMenuItem(String uID, String parentUID, String pageID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_UID", pageID);
		map.put("v_PARENTUID", uID);
		map.put("v_OWNERPAGEID", parentUID);
		ezPortalAdminDAO.removeSubMenuItem(map);
	}
	
	@Override
	public PortalPortletGeneralVO getPortletProperties(String pUID) throws Exception {
		return ezPortalAdminDAO.getPortletProperties(pUID);
	}
	
	

	public String getUniqueFileName (String dirPath, String fileName) throws Exception {
		int indexOfDot = fileName.lastIndexOf(".");
		String strName = fileName.substring(0, indexOfDot);
		String strExt = fileName.substring(++indexOfDot);
		
		boolean bExist = true;
		int fileCount = 0;
		
		File file = new File(dirPath + fileName); 
		while (bExist) {
			if (file.exists()) {
				fileCount++;
				fileName = strName + "(" + fileCount + ")." + strExt;
			} else {
				bExist = false;
			}
		}
		
		return fileName;
	}
	
	public String deleteTopPage (String pUID) throws Exception {
		List<String> result = ezPortalAdminDAO.deleteTopPage(pUID);
		if (result != null) {
			for (int i=0; i<result.size(); i++) {
				ezPortalAdminDAO.deleteTopMenuGeneralUID(result.get(i));
				deleteTopPage(result.get(i));
			}
		}
		
		ezPortalAdminDAO.deleteTblMenuItemsS(pUID);
		ezPortalAdminDAO.deleteTblMenuItems(pUID);
		ezPortalAdminDAO.deleteTblMenuItemsImage(pUID);
		ezPortalAdminDAO.deleteTopMenuItems(pUID);
		ezPortalAdminDAO.deleteTopMenuGeneralUID(pUID);
		ezPortalAdminDAO.deleteSkinItemsUID(pUID);
		return "OK";
	}
	
	public String saveTopMenu (String pPageID, String pParentPageID, String pUserID, String pUserName, String pXML, String pCompanyID) throws Exception {
		int i=0, j=0;
		Document xmlDom = commonUtil.convertStringToDocument(pXML);
		logger.debug("saveTopMenuXML="+pXML);
		String displayName = "";
		String displayName2 = "";
		String width = "0";
		String height = "0";
		String rowLength = "0";
		String columnLength = "0";
		String rowSplit = "";
		String columnSplit = "";
		String menuItemType = "";
		String menuItemUID = "";
		String menuItemPageUID = "";
		String menuItemDisplayName = "";
		String menuItemWidth = "";
		String menuItemHeight = "";
		String menuItemCanRemove = "";
		String menuItemCanResize = "";
		String menuItemCanReplace = "";
		String menuItemRootPageID = "";
		int previousRowPos = 0;
		int rowPos = 0;
		int depth = 0;
		int interval = 100000;
		String strUIDList = "";
		String[] arr;
		String pArrParam = "";
		
		int result = ezPortalAdminDAO.saveTopMenu(pPageID);
		logger.debug("saveTopMenu="+String.valueOf(result));
		String pThemeUID = "";

		if (result > 0) {
			width = xmlDom.getElementsByTagName("WIDTH").item(0).getTextContent().trim();
			height = xmlDom.getElementsByTagName("HEIGHT").item(0).getTextContent().trim();
			columnLength = String.valueOf(xmlDom.getElementsByTagName("CELL").getLength());
			displayName = xmlDom.getElementsByTagName("DISPLAYNAME").item(0).getTextContent().trim();
			displayName2 = xmlDom.getElementsByTagName("DISPLAYNAME2").item(0).getTextContent().trim();
			pThemeUID = xmlDom.getElementsByTagName("THEMEINFO").item(0).getTextContent().trim();
			
			for (i=0; i<xmlDom.getElementsByTagName("CELL").getLength(); i++) {
				columnSplit += xmlDom.getElementsByTagName("CELL").item(i).getChildNodes().item(0).getTextContent() + ";";
			}
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("displayName", displayName);
			map.put("displayName2", displayName2);
			map.put("width", width);
			map.put("height", height);
			map.put("rowLength", rowLength);
			map.put("columnLength", columnLength);
			map.put("rowSplit", rowSplit);
			map.put("columnSplit", columnSplit);
			map.put("pThemeUID", pThemeUID);
			map.put("pPageID", pPageID);
			ezPortalAdminDAO.updateTopMenuGeneral(map);
			
			for (i=0; i<xmlDom.getElementsByTagName("CELL").getLength(); i++) {
				previousRowPos = 0;
				for (j=0; j<xmlDom.getElementsByTagName("ROW").getLength(); j++) {
					menuItemType = xmlDom.getElementsByTagName("TYPE").item(j).getTextContent().trim();
					menuItemUID = xmlDom.getElementsByTagName("UID").item(j).getTextContent().trim();
					menuItemPageUID = xmlDom.getElementsByTagName("PAGEUID").item(j).getTextContent().trim();
					menuItemDisplayName = xmlDom.getElementsByTagName("DISPLAYNAME").item(j).getTextContent().trim();
					menuItemWidth = "0";
					menuItemHeight = xmlDom.getElementsByTagName("HEIGHT").item(j).getTextContent().trim();
					menuItemCanRemove = xmlDom.getElementsByTagName("CANREMOVE").item(j).getTextContent().trim();
					menuItemCanResize = xmlDom.getElementsByTagName("CANRESIZE").item(j).getTextContent().trim();
					menuItemCanReplace = xmlDom.getElementsByTagName("CANREPLACE").item(j).getTextContent().trim();
					menuItemRootPageID = xmlDom.getElementsByTagName("ROOTPAGEID").item(j).getTextContent().trim();
					
					if (pPageID.toLowerCase().trim().equals(menuItemPageUID.toLowerCase().trim()) || menuItemType.equals("1")) {
						if (menuItemType.equals("1")) {
							depth = ezPortalAdminDAO.saveTopMenu2(menuItemUID);
						} else {
							depth = ezPortalAdminDAO.saveTopMenu2(menuItemPageUID);
						}
						
						for (int k=0; k<depth; k++) {
							interval /= 10;
						}
						rowPos = previousRowPos + interval * (j+1);
						interval = 100000;
						Map<String, Object> map1 = new HashMap<String, Object>();
						map1.put("v_pUID", menuItemUID);
						map1.put("v_pPAGEUID", pPageID);
						map1.put("v_pPARENTPAGEUID", pParentPageID);
						result = ezPortalAdminDAO.saveTopMenu3(map1);
						logger.debug("saveTopMenu3="+String.valueOf(result));
						if (result > 0) {
							Map<String, Object> map2 = new HashMap<String, Object>();
							map2.put("menuItemType", menuItemType);
							map2.put("displayName", menuItemDisplayName);
							map2.put("width", menuItemWidth);
							map2.put("height", menuItemHeight);
							map2.put("rowPos", rowPos);
							map2.put("columnPos", i + 1);
							map2.put("canRemove", menuItemCanRemove);
							map2.put("canResize", menuItemCanResize);
							map2.put("canReplace", menuItemCanReplace);
							map2.put("uID", menuItemUID);
							map2.put("pageUID", pPageID);
							map2.put("parentPageUID", pParentPageID);
							ezPortalAdminDAO.updateTblTopMenuItems(map2);
						} else {
							Map<String, Object> map2 = new HashMap<String, Object>();
							map2.put("uID", menuItemUID);
							map2.put("pageUID", pPageID);
							map2.put("parentPageID", pParentPageID);
							map2.put("ownerPageID", menuItemRootPageID);
							map2.put("menuItemType", menuItemType);
							map2.put("displayName", menuItemDisplayName);
							map2.put("width", menuItemWidth);
							map2.put("height", menuItemHeight);
							map2.put("rowPos", rowPos);
							map2.put("columnPos", i + 1);
							map2.put("canRemove", menuItemCanRemove);
							map2.put("canResize", menuItemCanResize);
							map2.put("canReplace", menuItemCanResize);
							ezPortalAdminDAO.insertTblTopMenuItems(map2);
						}
						strUIDList += "'" + menuItemUID + "',";
					} else {
						Map<String, Object> map1 = new HashMap<String, Object>();
						map1.put("v_pUID", menuItemUID);
						map1.put("v_pPAGEUID", menuItemPageUID);
						map1.put("v_pCOLUMNPOS", i + 1);
						previousRowPos = ezPortalAdminDAO.saveTopMenu4(map1);
						logger.debug("saveTopMenu4="+String.valueOf(previousRowPos));
					}
				}
			}
			
			if (strUIDList == null || strUIDList.equals("")) {
				strUIDList = "''";
			} else {
				strUIDList = strUIDList.substring(0, strUIDList.length()-1);
			}
			arr = strUIDList.split(",");
			pArrParam = "";
			
			for (i =0; i<arr.length; i++) {
				if (i == 0) {
					pArrParam += ": v_" + String.valueOf(i);
				} else {
					pArrParam += ", : v_" + String.valueOf(i);
				}
			}
			
			Map<String, Object> map3 = new HashMap<String, Object>();
			map3.put("pArrParam", pArrParam);
			map3.put("pageUID", pPageID);
			map3.put("parentPageUID", pParentPageID);
			List<String> uID = ezPortalAdminDAO.selectTblTopMenuITemsUID(map3);
			
			for (i=0; i<uID.size(); i++) {
				deleteSubPage(uID.get(i));
				ezPortalAdminDAO.deleteTopMenuGeneralUID(uID.get(i));
			}
			Map<String, Object> map4 = new HashMap<String, Object>();
			map.put("strUIDList", strUIDList);
			map.put("pageUID", pPageID);
			map.put("parentPageUID", pParentPageID);
			ezPortalAdminDAO.deleteTopMenuItems2(map4);
		} else {
			width = xmlDom.getElementsByTagName("WIDTH").item(0).getTextContent().trim();
			height = xmlDom.getElementsByTagName("HEIGHT").item(0).getTextContent().trim();
			columnLength = String.valueOf(xmlDom.getElementsByTagName("CELL").getLength());
			displayName = xmlDom.getElementsByTagName("DISPLAYNAME").item(0).getTextContent().trim();
			displayName2 = xmlDom.getElementsByTagName("DISPLAYNAME2").item(0).getTextContent().trim(); 
			pThemeUID = xmlDom.getElementsByTagName("THEMEINFO").item(0).getTextContent().trim();
			
			if (pParentPageID.toLowerCase().equals("top")) {
				depth = 1;
			} else {
				depth = ezPortalAdminDAO.saveTopMenu5(pParentPageID) + 1;
				logger.debug("saveTopMenu5="+String.valueOf(depth));
			}
			
			for (i=0; i<xmlDom.getElementsByTagName("CELL").getLength(); i++) {
				columnSplit += xmlDom.getElementsByTagName("CELL").item(i).getChildNodes().item(0).getTextContent() + ";";
			}
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("uID", pPageID);
			map.put("parentUID", pParentPageID);
			map.put("depth", depth);
			map.put("displayName", displayName);
			map.put("displayName2", displayName2);
			map.put("creatorID", pUserID);
			map.put("creatorName", pUserName);
			map.put("width", width);
			map.put("height", height);
			map.put("rowLength", rowLength);
			map.put("columnLength", columnLength);
			map.put("rowSplit", rowSplit);
			map.put("columnSplit", columnSplit);
			map.put("companyID", pCompanyID);
			map.put("themeUID", pThemeUID);
			ezPortalAdminDAO.insertTblTopMenuGeneral(map);

			for (i=0; i<xmlDom.getElementsByTagName("CELL").getLength(); i++) {
				for (j=0; j<xmlDom.getElementsByTagName("ROW").getLength(); j++) {
					menuItemType = xmlDom.getElementsByTagName("TYPE").item(j).getTextContent().trim();
					menuItemUID = xmlDom.getElementsByTagName("UID").item(j).getTextContent().trim();
					menuItemPageUID = xmlDom.getElementsByTagName("PAGEUID").item(j).getTextContent().trim();
					menuItemDisplayName = xmlDom.getElementsByTagName("DISPLAYNAME").item(j).getTextContent().trim();
					menuItemWidth = "0";
					menuItemHeight = xmlDom.getElementsByTagName("HEIGHT").item(j).getTextContent().trim();
					menuItemCanRemove = xmlDom.getElementsByTagName("CANREMOVE").item(j).getTextContent().trim();
					menuItemCanResize = xmlDom.getElementsByTagName("CANRESIZE").item(j).getTextContent().trim();
					menuItemCanReplace = xmlDom.getElementsByTagName("CANREPLACE").item(j).getTextContent().trim();
					menuItemRootPageID = xmlDom.getElementsByTagName("ROOTPAGEID").item(j).getTextContent().trim();

					if (pPageID.toLowerCase().trim().equals(menuItemPageUID.toLowerCase().trim()) || menuItemType.equals("1")) {
						for (int k=0; k<depth; k++) {
							interval /= 10;
						}
						rowPos = previousRowPos + interval * (j+1);
						interval = 100000;
						Map<String, Object> map2 = new HashMap<String, Object>();
						map2.put("uID", menuItemUID);
						map2.put("pageUID", pPageID);
						map2.put("parentPageID", pParentPageID);
						map2.put("ownerPageID", menuItemRootPageID);
						map2.put("menuItemType", menuItemType);
						map2.put("displayName", menuItemDisplayName);
						map2.put("width", menuItemWidth);
						map2.put("height", menuItemHeight);
						map2.put("rowPos", rowPos);
						map2.put("columnPos", i + 1);
						map2.put("canRemove", menuItemCanRemove);
						map2.put("canResize", menuItemCanResize);
						map2.put("canReplace", menuItemCanReplace);
						ezPortalAdminDAO.insertTblTopMenuItems(map2);
					} else {
						Map<String, Object> map3 = new HashMap<String, Object>();
						map3.put("v_pUID", menuItemUID);
						map3.put("v_pPAGEUID", menuItemPageUID);
						map3.put("v_pCOLUMNPOS", i + 1);
						previousRowPos = ezPortalAdminDAO.saveTopMenu6(map3);
						logger.debug("saveTopMenu6="+String.valueOf(previousRowPos));
					}
				}
			}
		}
		
		return "OK";
	}
	
	public void deleteSubPage (String pUID) {
		List<PortalDeleteSubPageVO> list = ezPortalAdminDAO.topDeleteSubPage(pUID);
		for (int i=0; i<list.size(); i++) {
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("pUID", list.get(i).getuID());
			map.put("pageUID", list.get(i).getPageUID());
			ezPortalAdminDAO.deleteTopMenuItems3(map);
			ezPortalAdminDAO.deleteTopMenuGeneralUID(pUID);
		}
	}
	
	public int searchPortalPageCount (String pDisplayName, String pGubunFlag, String pCompanyID) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_DISPLAYNAME", pDisplayName);
		map.put("v_GUBUNFLAG", pGubunFlag);
		map.put("v_ARRPARAM", pGubunFlag);
		map.put("v_COMPANYID", pCompanyID);
		int recordCnt = ezPortalAdminDAO.searchPortalPageCount2(map);
		return recordCnt;
	}
	
	public String searchPortalPage (String pDisplayName, String pUseFlag, String pGubunFlag, int pStartRow, int pEndRow, String pAccessIDList, String pCompanyID) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_ENDROW", pEndRow);
		map.put("v_DISPLAYNAME", pDisplayName);
		map.put("v_USERFLAG", pUseFlag);
		map.put("v_GUBUNFLAG", pGubunFlag);
		map.put("v_ARRPARAM", pGubunFlag);
		map.put("v_COMPANYID", pCompanyID);
		List<PortalSearchPortalPage2VO> list = ezPortalAdminDAO.searchPortalPage2(map);
		
		StringBuilder sb = new StringBuilder();
		sb.append("<DATA>");
		for (int i=0; i<list.size(); i++) {
			if (i >= pStartRow -1) {
				sb.append("<ROW>");
                sb.append("<UID>" + list.get(i).getuID_() + "</UID>");
                sb.append("<DISPLAYNAME>" + list.get(i).getDisplayName() + "</DISPLAYNAME>");
                sb.append("<DISPLAYNAME2>" + list.get(i).getDisplayName2() + "</DISPLAYNAME2>");
                sb.append("<DEPTH>" + list.get(i).getDepth() + "</DEPTH>");
                sb.append("<CREATEDATE>" + list.get(i).getCreateDate() + "</CREATEDATE>");
                sb.append("<GUBUNFLAG>" + list.get(i).getGubunFlag() + "</GUBUNFLAG>");
                sb.append("<USEFLAG>" + list.get(i).getUseFlag() + "</USEFLAG>");
                sb.append("<GUBUNNAME>" + list.get(i).getGubunName() + "</GUBUNNAME>");
                sb.append("<DEFAULTPAGE>" + list.get(i).getDefaultPage() + "</DEFAULTPAGE>");
                sb.append("<THEMENM>" + list.get(i).getThemeNm() + "</THEMENM>");
                sb.append("<THEMENM2>" + list.get(i).getThemeNm2() + "</THEMENM2>");
                sb.append("<THEMENM3>" + list.get(i).getThemeNm3() + "</THEMENM3>");
                sb.append("<THEMENM4>" + list.get(i).getThemeNm4() + "</THEMENM4>");
                sb.append("</ROW>");
			}
		}
		sb.append("</DATA>");
		return sb.toString();
	}
	
	public String deletePortalPage (String pUID) {
		List<String> list = ezPortalAdminDAO.deletePortalPage(pUID);
		
		for (int i=0; i<list.size(); i++) {
			ezPortalAdminDAO.deletePortalPage2(list.get(i));
			deletePortalPage(list.get(i));
		}
		ezPortalAdminDAO.deletePortalPage3(pUID);
		return "OK";
	}
	
	public String savePortalPage (String pCallingPageID, String pPageID, String pParentPageID, String pXML, String pComapnyID, String pType) {
		int i=0;
		int j=0;

		Document xmlDom = commonUtil.convertStringToDocument(pXML);
		String displayName = "";
		String displayName2 = "";
		String width = "0";
		String height = "0";
		String rowLength = "0";
		String columnLength = "0";
		String rowSplit = "";
		String columnSplit = "";
		String portletType = "";
		String portletUID = "";
		String portletPageUID = "";
		String portletDisplayName = "";
		String portletWidth = "";
		String portletHeight = "";
		String portletCanRemove = "";
		String portletCanResize = "";
		String portletCanReplace = "";
		String portletOwnerPageUID = "";
		String portletPrevPageID = "";
		String gubunFlag = "";
		String pUserID = "";
		String pUserName = "";
		int previousRowPos = 0;
		int rowPos = 0;
		int depth = 0;
		int interval = 100000;
		String strUIDList = "";
		String[] arr;
		String pArrParam = "";
		String temp = "";
		String pThemeUID = "";
		String pTableViewOption = "";
		
		int result = ezPortalAdminDAO.savePortalPage(pPageID);
		
		if (pType.equals("MYPORTAL")) {
			width = xmlDom.getElementsByTagName("WIDTH").item(0).getTextContent().trim();
			height = xmlDom.getElementsByTagName("HEIGHT").item(0).getTextContent().trim();
			columnLength = String.valueOf(xmlDom.getElementsByTagName("CELL").getLength());
			displayName = xmlDom.getElementsByTagName("DISPLAYNAME").item(0).getTextContent().trim();
			displayName2 = xmlDom.getElementsByTagName("DISPLAYNAME2").item(0).getTextContent().trim();
			gubunFlag = xmlDom.getElementsByTagName("GUBUNFLAG").item(0).getTextContent().trim();
			pUserID = xmlDom.getElementsByTagName("USERID").item(0).getTextContent().trim();
			pUserName = xmlDom.getElementsByTagName("USERNAME").item(0).getTextContent().trim();
			pThemeUID = xmlDom.getElementsByTagName("THEMEINFO").item(0).getTextContent().trim();
			pTableViewOption = xmlDom.getElementsByTagName("TABLEVIEWOPTION").item(0).getTextContent().trim();
			
			if (pParentPageID.toLowerCase().equals("top")) {
				depth = 1;
			} else {
				result = ezPortalAdminDAO.savePortalPage7(pParentPageID);
				depth = result + 1;
			}
			
			for (i=0; i<xmlDom.getElementsByTagName("CELL").getLength(); i++) {
				columnSplit += xmlDom.getElementsByTagName("CELL").item(i).getChildNodes().item(0).getTextContent().trim() + ";";
			}
			
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("uID", pPageID);
			map.put("parentUID", pParentPageID);
			map.put("depth", depth);
			map.put("displayName", displayName);
			map.put("displayName2", displayName2);
			map.put("creatorID", pUserID);
			map.put("creatorName", pUserName);
			map.put("width", width);
			map.put("height", height);
			map.put("rowLength", rowLength);
			map.put("columnLength", columnLength);
			map.put("rowSplit", rowSplit);
			map.put("columnSplit", columnSplit);
			map.put("gubunFlag", gubunFlag);
			map.put("companyID", pComapnyID);
			map.put("themeUID", pThemeUID);
			map.put("tableViewOption", pTableViewOption);

			ezPortalAdminDAO.insertTblPortalPageGeneral(map);
			
			for (i=0; i<xmlDom.getElementsByTagName("CELL").getLength(); i++) {
				for (j=0; j<xmlDom.getElementsByTagName("ROW").getLength(); j++) {
					portletType = xmlDom.getElementsByTagName("TYPE").item(j).getTextContent().trim();
					portletUID = xmlDom.getElementsByTagName("UID").item(j).getTextContent().trim();
					portletPageUID = xmlDom.getElementsByTagName("PAGEUID").item(j).getTextContent().trim();
					portletDisplayName = xmlDom.getElementsByTagName("DISPLAYNAME").item(j).getTextContent().trim();
					
					PortalPortletGeneralVO widthDom2 =  ezPortalAdminDAO.getPortletProperties(portletUID);
					portletWidth = String.valueOf(widthDom2.getWidth());
					
					portletHeight = xmlDom.getElementsByTagName("HEIGHT").item(j).getTextContent().trim();
					portletCanRemove = xmlDom.getElementsByTagName("CANREMOVE").item(j).getTextContent().trim();
					portletCanResize = xmlDom.getElementsByTagName("CANRESIZE").item(j).getTextContent().trim();
					portletCanReplace = xmlDom.getElementsByTagName("CANREPLACE").item(j).getTextContent().trim();
					portletOwnerPageUID = xmlDom.getElementsByTagName("OWNERPAGEUID").item(j).getTextContent().trim();
					
					if (pPageID.toLowerCase().trim().equals(portletPageUID.toLowerCase().trim()) || portletType.equals("1")) {
						for (int k=0; k<depth; k++) {
							interval /= 10;
						}
						rowPos = previousRowPos + interval * (j + 1);
						interval = 100000;
						
						if (getItemsCount(pParentPageID, portletUID, portletOwnerPageUID) == 0) {
							Map<String, Object> map2 = new HashMap<String, Object>();
							map2.put("uID", portletUID);
							map2.put("pageUID", pPageID);
							map2.put("parentPageID", pParentPageID);
							map2.put("ownerPageID", portletOwnerPageUID);
							map2.put("portletType", portletType);
							map2.put("displayName", portletDisplayName);
							map2.put("width", portletWidth);
							map2.put("height", portletHeight);
							map2.put("rowPos", rowPos);
							map2.put("columnPos", String.valueOf(i + 1));
							map2.put("canRemove", portletCanRemove);
							map2.put("canResize", portletCanResize);
							map2.put("canReplace", portletCanReplace);

							ezPortalAdminDAO.insertTblPortalPageItems(map2);
						}
					} else {
						Map<String, Object> map2 = new HashMap<String, Object>();
						map2.put("v_pPORTLET_UID", portletUID);
						map2.put("v_pPORTLET_PAGEUID", portletPageUID);
						map2.put("v_pPCOLUMNPOS", String.valueOf(i+1));
						previousRowPos = ezPortalAdminDAO.savePortalPage8(map2);
					}
					
					
				}
			}
		} else {
			if (result > 0) {
				width = xmlDom.getElementsByTagName("WIDTH").item(0).getTextContent().trim();
				height = xmlDom.getElementsByTagName("HEIGHT").item(0).getTextContent().trim();
				columnLength = String.valueOf(xmlDom.getElementsByTagName("CELL").getLength());
				displayName = xmlDom.getElementsByTagName("DISPLAYNAME").item(0).getTextContent().trim();
				displayName2 = xmlDom.getElementsByTagName("DISPLAYNAME2").item(0).getTextContent().trim();
				gubunFlag = xmlDom.getElementsByTagName("GUBUNFLAG").item(0).getTextContent().trim();
				pUserID = xmlDom.getElementsByTagName("USERID").item(0).getTextContent().trim();
				pUserName = xmlDom.getElementsByTagName("USERNAME").item(0).getTextContent().trim();
				pThemeUID = xmlDom.getElementsByTagName("THEMEINFO").item(0).getTextContent().trim();
				pTableViewOption = xmlDom.getElementsByTagName("TABLEVIEWOPTION").item(0).getTextContent().trim();
				
				for (i=0; i<xmlDom.getElementsByTagName("CELL").getLength(); i++) {
					columnSplit += xmlDom.getElementsByTagName("CELL").item(i).getChildNodes().item(0).getTextContent().trim() + ";";
				}
				
				Map<String, Object> map = new HashMap<String, Object>();
				map.put("displayName", displayName);
				map.put("displayName2", displayName2);
				map.put("width", width);
				map.put("height", height);
				map.put("rowLength", rowLength);
				map.put("columnLength", columnLength);
				map.put("rowSplit", rowSplit);
				map.put("columnSplit", columnSplit);
				map.put("gubunFlag", gubunFlag);
				map.put("pThemeUID", pThemeUID);
				map.put("tableViewOption", pTableViewOption);
				map.put("pPageID", pPageID);
				ezPortalAdminDAO.updatePortalPageGeneral(map);
				
				for (i=0; i<xmlDom.getElementsByTagName("CELL").getLength(); i++) {
					previousRowPos = 0;
					for (j=0; j<xmlDom.getElementsByTagName("ROW").getLength(); j++) {
						portletType = xmlDom.getElementsByTagName("TYPE").item(j).getTextContent().trim();
						portletUID = xmlDom.getElementsByTagName("UID").item(j).getTextContent().trim();
						portletPageUID = xmlDom.getElementsByTagName("PAGEUID").item(j).getTextContent().trim();
						portletDisplayName = xmlDom.getElementsByTagName("DISPLAYNAME").item(j).getTextContent().trim();
						
						PortalPortletGeneralVO widthDom =  ezPortalAdminDAO.getPortletProperties(portletUID);
						portletWidth = String.valueOf(widthDom.getWidth());
						
						portletHeight = xmlDom.getElementsByTagName("HEIGHT").item(j).getTextContent().trim();
						portletCanRemove = xmlDom.getElementsByTagName("CANREMOVE").item(j).getTextContent().trim();
						portletCanResize = xmlDom.getElementsByTagName("CANRESIZE").item(j).getTextContent().trim();
						portletCanReplace = xmlDom.getElementsByTagName("CANREPLACE").item(j).getTextContent().trim();
						portletOwnerPageUID = xmlDom.getElementsByTagName("OWNERPAGEUID").item(j).getTextContent().trim();
						portletPrevPageID = xmlDom.getElementsByTagName("PREVPAGEID").item(j).getTextContent().trim();
						
						if (portletPrevPageID != null && !portletPrevPageID.equals("")) {
							Map<String, Object> map2 = new HashMap<String, Object>();
							map2.put("v_pPORTLET_PREVPAGEID", portletPrevPageID);
							map2.put("v_pCOLUMNPOS", String.valueOf(i+1));
							ezPortalAdminDAO.savePortalPage2(map2);
						}
						
						if (pPageID.toLowerCase().trim().equals(portletPageUID.toLowerCase().trim()) || portletType.equals("1")) {
							if (portletType.equals("1")) {
								depth = ezPortalAdminDAO.savePortalPage3(portletUID);
							} else {
								depth = ezPortalAdminDAO.savePortalPage4(portletPageUID);
							}
							
							for (int k=0; k<depth; k++) {
								interval /= 10;
							}
							rowPos = previousRowPos + interval * (j+1);
							interval = 100000;
							
							Map<String, Object> map3 = new HashMap<String, Object>();
							map3.put("v_pPORTLET_UID", portletUID);
							map3.put("v_pPPAGEID", pPageID);
							map3.put("v_pPPARENTPAGEID", pParentPageID);
							map3.put("v_pPORTLET_OWNERPAGEUID", portletOwnerPageUID);
							result = ezPortalAdminDAO.savePortalPage5(map3);
							
							if (result > 0) {
								Map<String, Object> map4 = new HashMap<String, Object>();
								map4.put("portletType", portletType);
								map4.put("displayName", portletDisplayName);
								map4.put("width", portletWidth);
								map4.put("height", portletHeight);
								map4.put("rowPos", rowPos);
								map4.put("columnPos", String.valueOf(i+1));
								map4.put("canRemove", portletCanRemove);
								map4.put("canResize", portletCanResize);
								map4.put("canReplace", portletCanReplace);
								map4.put("uID", portletUID);
								map4.put("pageUID", pPageID);
								map4.put("parentPageUID", pParentPageID);
								map4.put("ownerPageUID", portletOwnerPageUID);
								ezPortalAdminDAO.updateTblPortalPageItems(map4);
							} else {
								if (getItemsCount(pParentPageID, portletUID, portletOwnerPageUID) == 0) {
									Map<String, Object> map5 = new HashMap<String, Object>();
									map5.put("uID", portletUID);
									map5.put("pageUID", pPageID);
									map5.put("parentPageID", pParentPageID);
									map5.put("ownerPageID", portletOwnerPageUID);
									map5.put("portletType", portletType);
									map5.put("displayName", portletDisplayName);
									map5.put("width", portletWidth);
									map5.put("height", portletHeight);
									map5.put("rowPos", rowPos);
									map5.put("columnPos", String.valueOf(i+1));
									map5.put("canRemove", portletCanRemove);
									map5.put("canResize", portletCanResize);
									map5.put("canReplace", portletCanReplace);

									ezPortalAdminDAO.insertTblPortalPageItems(map5);
								}
							}
							strUIDList += "'" + portletUID + "',";
							
						} else {
							Map<String, Object> map6 = new HashMap<String, Object>();
							map6.put("v_pPORTLET_UID", portletUID);
							map6.put("v_PPORTLET_PAGEUID", portletPageUID);
							map6.put("v_pPCOLUMNPOS", String.valueOf(i+1));
							previousRowPos = ezPortalAdminDAO.savePortalPage6(map);
						}
					} 
				}
				
				if (strUIDList.equals("")) {
					strUIDList = "'',";
				}
				strUIDList = strUIDList.substring(0, strUIDList.length()-1);
				arr = strUIDList.split(",");
				pArrParam = "";
				for (i = 0; i<arr.length; i++) {
					if (i==0) {
						pArrParam += ": v_" + String.valueOf(i);
					} else {
						pArrParam += ", : v_" + String.valueOf(i);
					}
				}
				
				Map<String, Object> map7 = new HashMap<String, Object>();
				map7.put("pArrParam", pArrParam);
				map7.put("pageUID", pPageID);
				map7.put("parentPageUID", pParentPageID);
				List<String> resultXML = ezPortalAdminDAO.selectTblPortalPageItemsUID(map7);
				for (i=0; i<arr.length; i++) {
					temp = "v_" + String.valueOf(i);
				}
				
				for (i=0; i<resultXML.size(); i++) {
					deleteSubPage(resultXML.get(i));
					ezPortalAdminDAO.deletePortalPageGeneralUID(resultXML.get(i));
				}
				
				Map<String, Object> map8 = new HashMap<String, Object>();
				map8.put("strUIDList", strUIDList);
				map8.put("pageUID", pPageID);
				map8.put("parentPageUID", pParentPageID);
				map8.put("callingPageID", pCallingPageID);
				ezPortalAdminDAO.deletePortalPageItems(map8);
				ezPortalAdminDAO.deletePortalPageCache(pPageID);
			} else {
				width = xmlDom.getElementsByTagName("WIDTH").item(0).getTextContent().trim();
				height = xmlDom.getElementsByTagName("HEIGHT").item(0).getTextContent().trim();
				columnLength = String.valueOf(xmlDom.getElementsByTagName("CELL").getLength());
				displayName = xmlDom.getElementsByTagName("DISPLAYNAME").item(0).getTextContent().trim();
				displayName2 = xmlDom.getElementsByTagName("DISPLAYNAME2").item(0).getTextContent().trim();
				gubunFlag = xmlDom.getElementsByTagName("GUBUNFLAG").item(0).getTextContent().trim();
				pUserID = xmlDom.getElementsByTagName("USERID").item(0).getTextContent().trim();
				pUserName = xmlDom.getElementsByTagName("USERNAME").item(0).getTextContent().trim();
				pThemeUID = xmlDom.getElementsByTagName("THEMEINFO").item(0).getTextContent().trim();
				pTableViewOption = xmlDom.getElementsByTagName("TABLEVIEWOPTION").item(0).getTextContent().trim();
				
				if (pParentPageID.toLowerCase().equals("top")) {
					depth = 1;
				} else {
					depth = ezPortalAdminDAO.savePortalPage7(pParentPageID) + 1;
				}
				
				for (i=0; i<xmlDom.getElementsByTagName("CELL").getLength(); i++) {
					columnSplit += xmlDom.getElementsByTagName("CELL").item(i).getChildNodes().item(0).getTextContent().trim() + ";";
				}
				//
				Map<String, Object> map9 = new HashMap<String, Object>();
				map9.put("uID", pPageID);
				map9.put("parentUID", pParentPageID);
				map9.put("depth", depth);
				map9.put("displayName", displayName);
				map9.put("displayName2", displayName2);
				map9.put("creatorID", pUserID);
				map9.put("creatorName", pUserName);
				map9.put("width", width);
				map9.put("height", height);
				map9.put("rowLength", rowLength);
				map9.put("columnLength", columnLength);
				map9.put("rowSplit", rowSplit);
				map9.put("columnSplit", columnSplit);
				map9.put("gubunFlag", gubunFlag);
				map9.put("companyID", pComapnyID);
				map9.put("themeUID", pThemeUID);
				map9.put("tableViewOption", pTableViewOption);

				ezPortalAdminDAO.insertTblPortalPageGeneral(map9);
				
				for (i=0; i<xmlDom.getElementsByTagName("CELL").getLength(); i++) {
					for (j=0; j<xmlDom.getElementsByTagName("ROW").getLength(); j++) {
						portletType = xmlDom.getElementsByTagName("TYPE").item(j).getTextContent().trim();
						portletUID = xmlDom.getElementsByTagName("UID").item(j).getTextContent().trim();
						portletPageUID = xmlDom.getElementsByTagName("PAGEUID").item(j).getTextContent().trim();
						portletDisplayName = xmlDom.getElementsByTagName("DISPLAYNAME").item(j).getTextContent().trim();
						
						PortalPortletGeneralVO widthDom2 =  ezPortalAdminDAO.getPortletProperties(portletUID);
						portletWidth = String.valueOf(widthDom2.getWidth());
						
						portletHeight = xmlDom.getElementsByTagName("HEIGHT").item(j).getTextContent().trim();
						portletCanRemove = xmlDom.getElementsByTagName("CANREMOVE").item(j).getTextContent().trim();
						portletCanResize = xmlDom.getElementsByTagName("CANRESIZE").item(j).getTextContent().trim();
						portletCanReplace = xmlDom.getElementsByTagName("CANREPLACE").item(j).getTextContent().trim();
						portletOwnerPageUID = xmlDom.getElementsByTagName("OWNERPAGEUID").item(j).getTextContent().trim();

						if (pPageID.toLowerCase().trim().equals(portletPageUID.toLowerCase().trim()) || portletType.equals("1")) {
							for (int k=0; k<depth; k++) {
								interval /= 10;
							}
							rowPos = previousRowPos + interval * (j + 1);
							interval = 100000;

							if (getItemsCount(pParentPageID, portletUID, portletOwnerPageUID) == 0) {
								Map<String, Object> map2 = new HashMap<String, Object>();
								map2.put("uID", portletUID);
								map2.put("pageUID", pPageID);
								map2.put("parentPageID", pParentPageID);
								map2.put("ownerPageID", portletOwnerPageUID);
								map2.put("portletType", portletType);
								map2.put("displayName", portletDisplayName);
								map2.put("width", portletWidth);
								map2.put("height", portletHeight);
								map2.put("rowPos", rowPos);
								map2.put("columnPos", String.valueOf(i + 1));
								map2.put("canRemove", portletCanRemove);
								map2.put("canResize", portletCanResize);
								map2.put("canReplace", portletCanReplace);
								ezPortalAdminDAO.insertTblPortalPageItems(map2);
							}
						} else {
							Map<String, Object> map2 = new HashMap<String, Object>();
							map2.put("v_pPORTLET_UID", portletUID);
							map2.put("v_pPORTLET_PAGEUID", portletPageUID);
							map2.put("v_pPCOLUMNPOS", String.valueOf(i+1));
							previousRowPos = ezPortalAdminDAO.savePortalPage8(map2);
						}
						
						
					}
				}
				//
			}
		}
		
		return "OK";
	}
	
	public int getItemsCount (String pParentPageID, String portletUID, String portletOwnerPageUID) {
		String pParentPageIDList = getParentPageIDList(pParentPageID);
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_PORTLET_UID", portletUID);
		map.put("v_PORTLET_OWNERPAGEUID", portletOwnerPageUID);
		map.put("v_STRQUERY", pParentPageIDList);

		int result = ezPortalAdminDAO.getItemsCount(map);
		return result;
	}
	
	public String getParentPageIDList (String pPortalPageID) {
		String temp = pPortalPageID;
		String parentPageID = "";
		String parentPageIDList = "'" + pPortalPageID + "',";
		int count = 0;
		
		while (count < 10) {
			parentPageID = ezPortalAdminDAO.getParentPageIDList(temp);

			if (parentPageID == null || parentPageID.toLowerCase().trim().equals("top") || parentPageID.toLowerCase().trim().equals("")) {
				break;
			}
			
			parentPageIDList += "'" + parentPageID + "',";
			temp = parentPageID;
			count++;
		}
		parentPageIDList = parentPageIDList.substring(0, parentPageIDList.length()-1);
		return parentPageIDList;
	}
	
	public String setUsePage (String pUID, String pGubunFlag, String pCompanyID) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pUSERFLAG", "Y");
		map.put("v_pUID", pUID);
		map.put("v_pCOMPANYID", pCompanyID);
		map.put("v_pGUBUNFLAG", pGubunFlag);
		ezPortalAdminDAO.setUsePage2(map);
		return "OK";
	}
	
	public String outOfSetUsePage (String pUID, String pGubunFlag, String pCompanyID) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pUSERFLAG", "");
		map.put("v_pUID", pUID);
		map.put("v_pCOMPANYID", pCompanyID);
		map.put("v_pGUBUNFLAG", pGubunFlag);
		ezPortalAdminDAO.outOfSetUsePage(map);
		return "OK";
	}
	
	public String insertAclItem(String pXML) {
		Document xmlDom = commonUtil.convertStringToDocument(pXML);

		String uID = xmlDom.getElementsByTagName("UID").item(0).getTextContent();
		String accessID = xmlDom.getElementsByTagName("ACCESSID").item(0).getTextContent();
		String accessName = xmlDom.getElementsByTagName("ACCESSNAME").item(0).getTextContent();
		String editRight = xmlDom.getElementsByTagName("EDIT_RIGHT").item(0).getTextContent();
		String viewRight = xmlDom.getElementsByTagName("VIEW_RIGHT").item(0).getTextContent();
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_UID", uID);
		map.put("v_ACCESSID", accessID);
		map.put("v_ACCESSNAME", accessName);
		map.put("v_EDIT_RIGHT", Integer.parseInt(editRight));
		map.put("v_VIEW_RIGHT", Integer.parseInt(viewRight));
		ezPortalAdminDAO.insertAclItem(map);
		return "OK";
	}
	
	public String deleteAclItem(String pXML) {
		Document xmlDom = commonUtil.convertStringToDocument(pXML);
		String uID = xmlDom.getElementsByTagName("UID").item(0).getTextContent();
		String accessID = xmlDom.getElementsByTagName("ACCESSID").item(0).getTextContent();
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_UID", uID);
		map.put("v_ACCESSID", accessID);
		ezPortalAdminDAO.deleteAclItem(map);
		return "OK";
	}
	
	public int searchPortletCount (String pDisplayName, String pGubunFlag, String pPageGubunFlag, String pCompanyID) {
		Map<String, Object> map = new HashMap<String, Object>();
		if (pGubunFlag != null && !pGubunFlag.equals("")) {
			map.put("v_pGUBUNFLAG", Integer.parseInt(pGubunFlag));
		} else {
			map.put("v_pGUBUNFLAG", 100);
			map.put("v_pPAGEGUBUNFLAG", pPageGubunFlag);
			map.put("v_pDISPLAYNAME", pDisplayName);
			map.put("v_pCOMPANYID", pCompanyID);
		}
		
		int recordCnt = ezPortalAdminDAO.searchPortletCount2(map);
		return recordCnt;
	}
	
	public String searchPortlet (String pDisplayName, String pGubunFlag, String pPageGubunFlag, int pStartRow, int pEndRow, String pAccessIDList, String pCompanyID) {
		Map<String, Object> map = new HashMap<String, Object>();
		if (pGubunFlag != null && !pGubunFlag.equals("")) {
			map.put("v_pGUBUNFLAG", Integer.parseInt(pGubunFlag));
		} else {
			map.put("v_pGUBUNFLAG", 100);
			map.put("v_pPAGEGUBUNFLAG", pPageGubunFlag);
			map.put("v_pDISPLAYNAME", pDisplayName);
			map.put("v_pCOMPANYID", pCompanyID);
			map.put("v_pSTARTROW", pStartRow);
			map.put("v_pENDROW", pEndRow);
		}
		
		List<PortalSearchPortlet2VO> list = ezPortalAdminDAO.searchPortlet2(map);
		String result = "<DATA>";
		for (int i=0; i<list.size(); i++) {
			result += "<ROW>";
			result += "<UID_>" + list.get(i).getuID_() + "</UID_>";
			result += "<DISPLAYNAME>" + list.get(i).getDisplayName() + "</DISPLAYNAME>";
			result += "<DISPLAYNAME2>" + list.get(i).getDisplayName2() + "</DISPLAYNAME2>";
			if (list.get(i).getPortlet_Type() == 1)
				result += "<TYPE>t4075</TYPE>";
			if (list.get(i).getPortlet_Type() == 2)
				result += "<TYPE>t4076</TYPE>";
			if (list.get(i).getPortlet_Type() == 3)
				result += "<TYPE>t4077</TYPE>";
			if (list.get(i).getPortlet_Type() == 4)
				result += "<TYPE>t4078</TYPE>";
			
			result += "<URL>" + list.get(i).getUrl() + "</URL>";
			result += "<HEIGHT>" + list.get(i).getHeight() + "</HEIGHT>";
			result += "</ROW>";
		}
		result += "</DATA>";
		
		return result;
	}
	
	public String createNewPortlet (String pCompanyID) {
		String newUID = UUID.randomUUID().toString();
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pNEWID", newUID);
		map.put("v_pCOMPANYID", pCompanyID);
		ezPortalAdminDAO.createNewPortlet(map);
		return newUID;
	}
	
	public String createNewLogoItem (String pParentUID, String pPageID) {
		String newUID = UUID.randomUUID().toString();
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PUID", newUID);
		map.put("v_PPAGEID", pPageID);
		map.put("v_PSKINNUM", 1);
		map.put("v_PDISPLAYNAME", "로고아이템");
		map.put("v_PDISPLAYNAME2", "LogoItem");
		ezPortalAdminDAO.createNewLogoItem(map);
		return newUID;
	}
	
	public String createNewSubMenuItem (String pParentUID, String pPageID) {
		String newUID = UUID.randomUUID().toString();
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_NEWUID", newUID);
		map.put("v_PARENTUID", pParentUID);
		map.put("v_PAGEID", pPageID);
		map.put("v_DISPLAYNAME", "서브메뉴아이템");
		map.put("v_DISPLAYNAME2", "SubMenuItem");
		ezPortalAdminDAO.createNewSubMenuItem(map);
		return newUID;
	}
	
	public String savePortletProperties (String pXML) {
		Document xmlDom = commonUtil.convertStringToDocument(pXML);
		
		String uID = xmlDom.getElementsByTagName("UID").item(0).getTextContent();
		String displayName = xmlDom.getElementsByTagName("DISPLAYNAME").item(0).getTextContent();
		String displayName2 = xmlDom.getElementsByTagName("DISPLAYNAME2").item(0).getTextContent();
		String portletType = xmlDom.getElementsByTagName("PORTLETTYPE").item(0).getTextContent();
		String url = xmlDom.getElementsByTagName("URL").item(0).getTextContent();
		String maxUrl = xmlDom.getElementsByTagName("MAXURL").item(0).getTextContent();
		String showTitlebar = xmlDom.getElementsByTagName("SHOWTITLEBAR").item(0).getTextContent();
		String userType = xmlDom.getElementsByTagName("USERTYPE").item(0).getTextContent();
		String width = xmlDom.getElementsByTagName("WIDTH").item(0).getTextContent();
		String height = xmlDom.getElementsByTagName("HEIGHT").item(0).getTextContent();
		String gubunFlag = xmlDom.getElementsByTagName("GUBUNFLAG").item(0).getTextContent();
		String frameType = xmlDom.getElementsByTagName("FRAMETYPE").item(0).getTextContent();
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pDISPLAYNAME", displayName);
		map.put("v_pDISPLAYNAME2", displayName2);
		if (portletType == null || portletType.equals("")) {
			portletType = "0";
		}
		map.put("v_pPORTLET_TYPE", Integer.parseInt(portletType));
		map.put("v_pURL", url);
		map.put("v_pMAXURL", maxUrl);
		map.put("v_pSHOWTITLEBAR", showTitlebar);
		map.put("v_pUSERTYPE", userType);
		map.put("v_pWIDTH", Integer.parseInt(width));
		if (height == null || height.equals("")) {
			height = "0";
		}
		map.put("v_pHEIGHT", Integer.parseInt(height));
		map.put("v_pGUBUNFLAG", gubunFlag);
		map.put("v_pUID", uID);
		map.put("v_pFRAMETYPE", frameType);
		ezPortalAdminDAO.saveNewPortletProperties(map);
		
		return "OK";
	}
	
	public String savePortletParameters (String pXML) {
		Document xmlDom = commonUtil.convertStringToDocument(pXML);
		
		String uID = xmlDom.getElementsByTagName("UID").item(0).getTextContent();
		String paramName = xmlDom.getElementsByTagName("PARAMNAME").item(0).getTextContent();
		String paramValue = xmlDom.getElementsByTagName("PARAMVALUE").item(0).getTextContent();
		String paramType = xmlDom.getElementsByTagName("PARAMTYPE").item(0).getTextContent();
		
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_pUID", uID);
		map.put("v_pPARAMNAME", paramName);
		map.put("v_pPARAMVALUE", paramValue);
		if (paramType == null || paramType.equals("")) {
			paramType = "0";
		}
		map.put("v_pPARAMTYPE", Integer.parseInt(paramType));
		ezPortalAdminDAO.savePortletParameters(map);
		
		return "OK";
	}
	
	public String saveMenuItemParameters (String pXML) {
		Document xmlDom = commonUtil.convertStringToDocument(pXML);
		
		String uID = xmlDom.getElementsByTagName("UID").item(0).getTextContent();
		String paramName = xmlDom.getElementsByTagName("PARAMNAME").item(0).getTextContent();
		String paramValue = xmlDom.getElementsByTagName("PARAMVALUE").item(0).getTextContent();
		String paramType = xmlDom.getElementsByTagName("PARAMTYPE").item(0).getTextContent();
		
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_UID", uID);
		map.put("v_PARAMNAME", paramName);
		map.put("v_PARAMVALUE", paramValue);
		if (paramType == null || paramType.equals("")) {
			paramType = "0";
		}
		map.put("v_PARAMTYPE", Integer.parseInt(paramType));
		ezPortalAdminDAO.saveMenuItemParameters(map);
		
		return "OK";
	}
	
	public String deletePortlet (String pUID) {
		ezPortalAdminDAO.deletePortlet(pUID);
		return "OK";
	}
	
	public String loadLogoItems (String pPageID) throws Exception {
		String rValue = "";
		
		List<PortalLoadLogoItemsVO> list = ezPortalAdminDAO.loadLogoItems(pPageID);
		
		rValue = "<DATA>";
		for (int i=0; i<list.size(); i++) {
			rValue += commonUtil.getQueryResult(list.get(i));
		}
		rValue += "</DATA>";
		
		return rValue;
	}
	
	public String savePositionSettings (String pXML, String pPageID) {
		Document xmlDom = commonUtil.convertStringToDocument(pXML);
		String uID = xmlDom.getElementsByTagName("UID_").item(0).getTextContent().trim();
		String align = xmlDom.getElementsByTagName("ALIGN").item(0).getTextContent().trim();
		String vAlign = xmlDom.getElementsByTagName("VALIGN").item(0).getTextContent().trim();
		String leftMargin = xmlDom.getElementsByTagName("PADDINGLEFT").item(0).getTextContent().trim();
		String rightMargin = xmlDom.getElementsByTagName("PADDINGRIGHT").item(0).getTextContent().trim();
		String topMargin = xmlDom.getElementsByTagName("PADDINGTOP").item(0).getTextContent().trim();
		String bottomMargin = xmlDom.getElementsByTagName("PADDINGBOTTOM").item(0).getTextContent().trim();
		
		if (leftMargin == null || leftMargin.equals("")) {
			leftMargin = "0";
		}
		if (rightMargin == null || rightMargin.equals("")) {
			rightMargin = "0";
		}
		if (topMargin == null || topMargin.equals("")) {
			topMargin = "0";
		}
		if (bottomMargin == null || bottomMargin.equals("")) {
			bottomMargin = "0";
		}
		
		if (align.equals("0")) {
			align = "left";
		}
		if (align.equals("1")) {
			align = "center";
		}
		if (align.equals("2")) {
			align = "right";
		}
		
		if (vAlign.equals("0")) {
			vAlign = "top";
		}
		if (vAlign.equals("1")) {
			vAlign = "middle";
		}
		if (vAlign.equals("2")) {
			vAlign = "bottom";
		}
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pALIGN", align);
		map.put("v_pVALIGN", vAlign);
		
		if (leftMargin == null || leftMargin.equals("")) {
			leftMargin = "0";
		}
		map.put("v_pLEFTMARGIN", Integer.parseInt(leftMargin));
		
		if (rightMargin == null || rightMargin.equals("")) {
			rightMargin = "0";
		}
		map.put("v_pRIGHTMARGIN", Integer.parseInt(rightMargin));
		
		if (topMargin == null || topMargin.equals("")) {
			topMargin = "0";
		}
		map.put("v_pTOPMARGIN", Integer.parseInt(topMargin));
		
		if (bottomMargin == null || bottomMargin.equals("")) {
			bottomMargin = "0";
		}
		map.put("v_pBOTTOMMARGIN", Integer.parseInt(bottomMargin));
		map.put("v_pUID", uID);
		map.put("v_pPAGEID", pPageID);
		
		ezPortalAdminDAO.savePositionSettings(map);
		
		return "OK";
	}
	
	public String createNewMenuItem (String pParentUID, String pPageID) {
		String newUID = UUID.randomUUID().toString();
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PUID", newUID);
		map.put("v_PPARENTUID", pParentUID);
		map.put("v_POWNERPAGEID", pPageID);
		map.put("v_PDISPLAYNAME", "메뉴아이템");
		map.put("v_PDISPLAYNAME2", "MenuItem");
		ezPortalAdminDAO.createNewMenuItem(map);
		
		if (pParentUID.equals("203")) {
			Map<String, Object> map1 = new HashMap<String, Object>();
			map1.put("v_PUID", UUID.randomUUID().toString());
			map1.put("v_PPARENTUID", "204");
			map1.put("v_PPARENTMENUID", newUID);
			map1.put("v_POWNERPAGEID", pPageID);
			ezPortalAdminDAO.createNewMenuItem2(map1);
		}
		
		return newUID;
	}
	
	public String loadMenuItemConfig (String pUID, String pPageID, String pSkinNum) throws Exception {
		String strXML = "";
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PUID", pUID);
		map.put("v_PPAGEID", pPageID);
		
		PortalMenuItemItemsMenuItemsVO result = ezPortalAdminDAO.loadMenuItemConfig(map);
		String resultStr = commonUtil.getQueryResult(result);
		String imageUID = result.getImageUId();
		
		if (imageUID != null && !imageUID.trim().equals("")) {
			Map<String, Object> map1 = new HashMap<String, Object>();
			map1.put("v_PUID", imageUID);
			map1.put("v_PPAGEID", pPageID);
			if (pSkinNum == null || pSkinNum.equals("")) {
				pSkinNum = "0";
			}
			map1.put("v_PSKINNUM", Integer.parseInt(pSkinNum));
			PortalMenuItemItemsImageVO result1 =ezPortalAdminDAO.loadMenuItemConfig2(map1);
			
			String result1Str = commonUtil.getQueryResult(result1);
			Document xmlDom2 = commonUtil.convertStringToDocument(result1Str);
			
			if (xmlDom2.getElementsByTagName("ROW").getLength() > 0) {
				strXML = "<DATA>" + resultStr + "<IMAGEDATA>" + result1Str + "</IMAGEDATA></DATA>";
			} else {
				strXML = "<DATA>" + resultStr + "<IMAGEDATA></IMAGEDATA></DATA>";
			}
		} else {
			strXML = "<DATA>" + resultStr + "<IMAGEDATA></IMAGEDATA></DATA>";
		}
		return strXML;
	}
	
	public String saveMenuItemConfig (String pXML, String pPageID, String pCompanyID) {
		Document xmlDom = commonUtil.convertStringToDocument(pXML);
		String uID = xmlDom.getElementsByTagName("UID").item(0).getTextContent();
		String imgUID = xmlDom.getElementsByTagName("IMGUID").item(0).getTextContent();
		String displayName = xmlDom.getElementsByTagName("DISPLAYNAME").item(0).getTextContent();
		String displayName2 = xmlDom.getElementsByTagName("DISPLAYNAME2").item(0).getTextContent();
		String normalImage = xmlDom.getElementsByTagName("NORMALIMAGE").item(0).getTextContent();
		String overImage = xmlDom.getElementsByTagName("OVERIMAGE").item(0).getTextContent();
		String imageWidth = xmlDom.getElementsByTagName("IMAGEWIDTH").item(0).getTextContent();
		String imageHeight = xmlDom.getElementsByTagName("IMAGEHEIGHT").item(0).getTextContent();
		String linkURL = xmlDom.getElementsByTagName("LINKURL").item(0).getTextContent();
		String linkLocation = xmlDom.getElementsByTagName("LINKLOCATION").item(0).getTextContent();
		String windowOption = xmlDom.getElementsByTagName("WINDOWOPTION").item(0).getTextContent();
		String skin = xmlDom.getElementsByTagName("SKIN").item(0).getTextContent();
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PPUID", uID);
		map.put("v_PIMGUID", imgUID);
		map.put("v_PPAGEID", pPageID);
		map.put("v_PDISPLAYNAME", displayName);
		map.put("v_PDISPLAYNAME2", displayName2);
		map.put("v_PNORMALIMAGE", normalImage);
		map.put("v_POVERIMAGE", overImage);
		
		if (skin == null || skin.equals("")) {
			skin = "0";
		}
		map.put("v_PSKINNUM", Integer.parseInt(skin));
		
		if (imageWidth == null || imageWidth.equals("")) {
			imageWidth = "0";
		}
		map.put("v_PIMAGEWIDTH", Integer.parseInt(imageWidth));
		
		if (imageHeight == null || imageHeight.equals("")) {
			imageHeight = "0";
		}
		map.put("v_PIMAGEHEIGHT", Integer.parseInt(imageHeight));
		map.put("v_PLINKURL", linkURL);
		map.put("v_PLINKLOCATION", linkLocation);
		map.put("v_PWINDOWOPTION", windowOption);
		map.put("v_PNEWUID", UUID.randomUUID().toString());
		map.put("v_PIMAGETYPE", "2");
		map.put("v_EMPTYIMGID", "");
		map.put("v_PCOMPANYID", pCompanyID);
		
		ezPortalAdminDAO.saveMenuItemConfig(map);
		
		return "OK";
	}
	
	public String loadSubMenuItemConfig (String pUID, String pPageID) throws Exception {
		String strXML = "";
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_UID", pUID);
		map.put("v_PAGEID", pPageID);
		
		PortalMenuItemItemsMenuItemsSVO result = ezPortalAdminDAO.loadSubMenuItemConfig(map);
		String resultStr = commonUtil.getQueryResult(result);
		String imageUID = result.getImageUId();
		
		if (imageUID != null && !imageUID.equals("")) {
			Map<String, Object> map1 = new HashMap<String, Object>();
			map1.put("v_UID", imageUID);
			map1.put("v_PAGEID", pPageID);
			PortalMenuItemItemsImageVO result1 =ezPortalAdminDAO.loadSubMenuItemConfig2(map1);
			
			String result1Str = commonUtil.getQueryResult(result1);
			strXML = "<DATA>" + resultStr + "<IMAGEDATA>" + result1Str + "</IMAGEDATA></DATA>";
		} else {
			strXML = "<DATA>" + resultStr + "<IMAGEDATA></IMAGEDATA></DATA>";
		}
		return strXML;
	}
	
	public String saveSubMenuItemConfig (String pXML, String pPageID) {
		Document xmlDom = commonUtil.convertStringToDocument(pXML);
		String uID = xmlDom.getElementsByTagName("UID").item(0).getTextContent();
		String imgUID = xmlDom.getElementsByTagName("IMGUID").item(0).getTextContent();
		String displayName = xmlDom.getElementsByTagName("DISPLAYNAME").item(0).getTextContent();
		String displayName2 = xmlDom.getElementsByTagName("DISPLAYNAME2").item(0).getTextContent();
		String normalImage = xmlDom.getElementsByTagName("NORMALIMAGE").item(0).getTextContent();
		String overImage = xmlDom.getElementsByTagName("OVERIMAGE").item(0).getTextContent();
		String imageWidth = xmlDom.getElementsByTagName("IMAGEWIDTH").item(0).getTextContent();
		String imageHeight = xmlDom.getElementsByTagName("IMAGEHEIGHT").item(0).getTextContent();
		String linkURL = xmlDom.getElementsByTagName("LINKURL").item(0).getTextContent();
		String linkLocation = xmlDom.getElementsByTagName("LINKLOCATION").item(0).getTextContent();
		String windowOption = xmlDom.getElementsByTagName("WINDOWOPTION").item(0).getTextContent();
		String skin = xmlDom.getElementsByTagName("SKIN").item(0).getTextContent();
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_P_SUB_UID", uID);
		map.put("v_P_SUB_PAGEID", pPageID);
		map.put("v_PUID", imgUID);
		map.put("v_PDISPLAYNAME", displayName);
		map.put("v_PDISPLAYNAME2", displayName2);
		map.put("v_PNORMALIMAGEPATH", normalImage);
		map.put("v_POVERIMAGEPATH", overImage);
		
		if (imageWidth == null || imageWidth.equals("")) {
			imageWidth = "0";
		}
		map.put("v_PIMAGEWIDTH", Integer.parseInt(imageWidth));
		
		if (imageHeight == null || imageHeight.equals("")) {
			imageHeight = "0";
		}
		map.put("v_PPIMAGEHEIGHT", Integer.parseInt(imageHeight));
		map.put("v_PLINKURL", linkURL);
		map.put("v_PLINKLOCATION", linkLocation);
		map.put("v_PWINDOWOPTION", windowOption);
		
		if (skin == null || skin.equals("")) {
			skin = "0";
		}
		map.put("v_PSKINNUM", Integer.parseInt(skin));
		map.put("v_PNEWID", UUID.randomUUID().toString());
		map.put("v_IMAGETYPE", "2");
		map.put("v_EMPTYPUID", "");
		
		ezPortalAdminDAO.saveSubMenuItemConfig(map);
		
		return "OK";
	}
	
	public String saveDelPortletInfo (String pUserID, String pUserName, String pXML) {
		Document xmlDom = commonUtil.convertStringToDocument(pXML);
		for (int i=0; i<xmlDom.getElementsByTagName("UID").getLength(); i++) {
			String pUID = xmlDom.getElementsByTagName("UID").item(i).getTextContent();
			String pPageUID = xmlDom.getElementsByTagName("PAGEUID").item(i).getTextContent();
			String pOwnerPageUID = xmlDom.getElementsByTagName("OWNERPAGEUID").item(i).getTextContent();
			String pUserPageUID = xmlDom.getElementsByTagName("USERPAGEUID").item(i).getTextContent();
			String pChangeFlag = xmlDom.getElementsByTagName("CHANGEFLAG").item(i).getTextContent();
			
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("v_pUID", pUID);
			map.put("v_pPAGEUID", pPageUID);
			map.put("v_pOWNERPAGEUID", pOwnerPageUID);
			map.put("v_pCREATORID", pUserID);
			map.put("v_pUSERNAME", pUserName);
			map.put("v_pCHANGEFLAG", pChangeFlag);
			map.put("v_pUSERPAGEUID", pUserPageUID);
			ezPortalAdminDAO.saveDelPortletInfo(map);
		}
		return "OK";
	}
	
}


