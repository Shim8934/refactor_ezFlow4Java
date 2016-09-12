package egovframework.ezEKP.ezPortal.service;

import java.util.Map;

public interface EzPortalAdminService {
	public String useThemeInfo(String pUID) throws Exception;
	
	public String getUniqueFileName (String dirPath, String fileName) throws Exception;
	
	public String deleteTopPage (String pUID) throws Exception;
	
	public void deleteTheme (String uID) throws Exception;
	
	public void setThemeInfo (String uID, String disNm1, String disNm2, String disNm3, String disNm4, String imageURL, String topURL, String mainURL, String companyID, String creatorID, String creatorNm, int topHeight) throws Exception;
	
	public void topSetUsePage2 (String uID, String companyID) throws Exception;
	
	public void outOfSetUsePage (String uID, String companyID) throws Exception;
	
	public void setUseLang (String uID, String companyID, String langStr) throws Exception;
}
