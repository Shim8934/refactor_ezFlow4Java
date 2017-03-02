package egovframework.ezEKP.ezCommon.service;

import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import egovframework.ezEKP.ezCommon.vo.ApprovPWDVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.user.login.vo.TenantServerNameVO;
import egovframework.let.user.login.vo.TenantVO;

public interface EzCommonService {

	public String startHtml2Mht(String strHTML, String realPath, Locale locale) throws Exception;
	
	public String getMHTtoHTML(String type, String itemID, int tenantID, String realPath, HttpServletRequest request, Locale locale) throws Exception;
	
	public String loadMHTFile(String path) throws Exception;
	
	public String startMHT2HTML(String filePath, String m_strMHT, String filePath2, String realPath, Locale locale, String domain) throws Exception;
	
	public String saveUserLocalInfo (String pUserID, LoginVO userInfo) throws Exception;
	
	public String selectUserGetLang(String userID, int tenantID) throws Exception;
	
	public String selectUserGetTimeZone(String userID, int tenantID) throws Exception;
	
	public String getTenantConfig(String property, int tenantID) throws Exception;
	
	public Map<String, Object> getTenantConfigs(int tenantID) throws Exception;
	
	public List<TenantVO> getTenantList() throws Exception;
	
	public List<TenantServerNameVO> getTenantServerNameList() throws Exception;
	
	public ApprovPWDVO getApprovPWD(LoginVO userInfo) throws Exception;
	
	public void responseAttach(String pPhysicalFilePath, String pFileName, boolean pAttachment, HttpServletRequest request, HttpServletResponse response) throws Exception;
	
	public void insertTblUserLocalInfo(String userID, String timeZone, String lang, int tenantID) throws Exception;

	public int getTenantIdByDomainName(String domainName) throws Exception;
}
