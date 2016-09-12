package egovframework.ezEKP.ezPortal.service.impl;

import java.io.File;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezPortal.dao.EzPortalAdminDAO;
import egovframework.ezEKP.ezPortal.service.EzPortalAdminService;
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
		
		for (int i=0; i<result.size(); i++) {
			ezPortalAdminDAO.deleteTopMenuGeneralUID(pUID);
		}
		ezPortalAdminDAO.deleteTblMenuItemsS(pUID);
		ezPortalAdminDAO.deleteTblMenuItems(pUID);
		ezPortalAdminDAO.deleteTblMenuItemsImage(pUID);
		ezPortalAdminDAO.deleteTopMenuItems(pUID);
		ezPortalAdminDAO.deleteSkinItemsUID(pUID);
		return "OK";
	}
	
}
