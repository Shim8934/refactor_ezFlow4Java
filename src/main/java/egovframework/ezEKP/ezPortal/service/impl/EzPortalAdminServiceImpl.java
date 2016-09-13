package egovframework.ezEKP.ezPortal.service.impl;

import java.io.File;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.w3c.dom.Document;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezPortal.dao.EzPortalAdminDAO;
import egovframework.ezEKP.ezPortal.service.EzPortalAdminService;
import egovframework.ezEKP.ezPortal.vo.PortalDeleteSubPageVO;
import egovframework.ezEKP.ezPortal.vo.PortalTBLSkinGeneralVO;
import egovframework.ezEKP.ezPortal.vo.PortalUseThemeCheckVO;
import egovframework.let.utl.fcc.service.CommonUtil;

@Service("EzPortalAdminService")
public class EzPortalAdminServiceImpl implements EzPortalAdminService  {
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
	public void outOfSetUsePage(String uID, String companyID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pUID", uID);
		map.put("v_pCOMPANYID", companyID);
		ezPortalAdminDAO.outOfSetUsePage(map);
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
		String strSQL = "";
		int i=0, j=0;
		Document xmlDom = commonUtil.convertStringToDocument(pXML);
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
		String temp = "";
System.out.println("pPageID:"+pPageID);
		int result = ezPortalAdminDAO.saveTopMenu(pPageID);
		
		String pSQL = "";
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
						ezPortalAdminDAO.saveTopMenu4(map1);
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
System.out.println("11111");
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
			}
			
			for (i=0; i<xmlDom.getElementsByTagName("CELL").getLength(); i++) {
				columnSplit += xmlDom.getElementsByTagName("CELL").item(i).getChildNodes().item(0).getTextContent() + ";";
			}
System.out.println("22222");
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
System.out.println("pXML:"+pXML);
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
System.out.println("pPageID1:"+pPageID);
System.out.println("menuItemPageUID1:"+menuItemPageUID);
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
	
}
