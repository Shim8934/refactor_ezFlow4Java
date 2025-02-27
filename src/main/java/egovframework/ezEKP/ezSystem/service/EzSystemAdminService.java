package egovframework.ezEKP.ezSystem.service;

import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import org.w3c.dom.Document;

import egovframework.ezEKP.ezSystem.vo.AccessIdVO;
import egovframework.ezEKP.ezSystem.vo.ConnectionInfoVO;
import egovframework.ezEKP.ezSystem.vo.DeptChangeInfoVO;
import egovframework.ezEKP.ezSystem.vo.IPBandVO;
import egovframework.ezEKP.ezSystem.vo.ModuleSizeVO;
import egovframework.ezEKP.ezSystem.vo.PermissionInfoVO;
import egovframework.ezEKP.ezSystem.vo.SysParamVO;
import egovframework.ezEKP.ezSystem.vo.SystemConfigTypeVO;
import egovframework.ezEKP.ezSystem.vo.SystemConfigVO;
import egovframework.ezEKP.ezSystem.vo.UserChangeInfoVO;
import egovframework.let.main.vo.MainVO;
import egovframework.let.user.login.vo.LoginVO;

public interface EzSystemAdminService {
	public List<SysParamVO> getSysParam(int tenantID) throws Exception;
	public void updateSysParam(int tenantId, List<Map<String, String>> list, Locale locale, String companyID) throws Exception;
	public List<ConnectionInfoVO> getLoginHist(int tenantID, String offset, int startPage, int maxItemPerPage, 
			String keyword, String keycode, String keycodeForStatus, String lang, String startDate, String endDate, String companyId) throws Exception;
	public List<ConnectionInfoVO> getLoginHistNotAdmin(int tenantID, String offset, int startPage, int maxItemPerPage, 
			String keyword, String keycode, String keycodeForStatus, String lang, String startDate, String endDate, String companyId, String userId) throws Exception;
	public int getLoginHistCount(int tenantID, String offset, String keyword, String keycode, String keycodeForStatus,
			String lang, String startDate, String endDate, String companyId) throws Exception;
	public int getLoginHistCountNotAdmin(int tenantID, String offset, String keyword, String keycode, String keycodeForStatus,
			String lang, String startDate, String endDate, String companyId, String userId) throws Exception;
	public ArrayList<String> getServerInfo(String ip, String curServer, String serverName, ArrayList<String> getServerList) throws Exception;
	public String getSysMonitorInfo(String ip, String serverName, String address, boolean chkServer) throws Exception;
	public void deleteLoginHist(int keepLogPeriod, int tenantID) throws Exception;
	public void updateSystemIPAllow(String allowResult, int tenantID) throws Exception;
	public List<IPBandVO> getAllIPBand(int tenantID) throws Exception;
	public void insertIPBand(int tenantID, String ipAddress, String access, String explanation) throws Exception;
	public IPBandVO getSystemIPBand(String ipNo) throws Exception;
	public void updateIPBand(String ipNo, String ipAddress, String access, String explanation) throws Exception;
	public void deleteIPBand(String ipNo) throws Exception;
	public List<AccessIdVO> getAllAccessList(String primaryLang, int tenantID, String companyID) throws Exception;
	public List<AccessIdVO> getAllAccessListDept(String primaryLang, int tenantID, String companyID) throws Exception;
	public List<String> getAllAccessListCom (int tenantID) throws Exception;
	public void deleteAccessId(String accessNo) throws Exception;
	public void insertAccessId(int tenantID, String cn) throws Exception;
	public ModuleSizeVO getModuleUsage(List<String> moduleNames, String realPath, LoginVO userInfo) throws Exception;
	public void deleteWebfolderLog (int keepLogPeriod, int tenantID) throws Exception;
	public void setMultiLoginType(String multiLoginType, int tenantID, String companyID, String editType) throws Exception;
	public void updateNewPortalMenuByPackageType(String newPackageType, int tenantID, String companyID) throws Exception;
	public String getAccessCountryList(int tenantId) throws Exception;
	public void setAccessCountry(int tenantId, String countryCode) throws Exception;
	public void updateSystemAdminIPAllow(String allowResult, int tenantID) throws Exception;
	public List<IPBandVO> getAdminAccessIPBand(int tenantID) throws Exception;
	public void insertAdminIPBand(int tenantID, String ipAddress, String access, String explanation) throws Exception;
	public IPBandVO getSystemAdminIPBand(String ipNo) throws Exception;
	public void updateAdminIPBand(String ipNo, String ipAddress, String access, String explanation) throws Exception;

	public int isExistSystemAdminIPBand(String ipNo) throws Exception;
	public String isExistSystemAccess(String deleteList, String type, String useIPAccess, int tenantID) throws Exception;
	public void deleteAdminIPBand(String ipNo) throws Exception;
	public Map<String, Object> getPwPolicy(int tenantId, String companyId) throws Exception;
	public void updateCompanyConfigParam(int tenantID, List<Map<String, String>> list, String companyID) throws Exception;
	public int updatePwPolicy(int tenantId, String companyId, Map<String, String> patternTypeMap, List<Map<String, Object>> PwPolicyPatternList) throws Exception;
	List<MainVO> getAdminAccessHist(int tenantID, String offset, int startPage, int maxItemPerPage,
			String keyword, String keycode, String keycodeForRoll, String lang, String startDate, String endDate, String companyId) throws Exception;
	int getAdminAccessHistCount(int tenantID, String offset, String keyword, String keycode, String keycodeForRoll,
			String lang, String startDate, String endDate, String companyId) throws Exception;

	List<PermissionInfoVO> getPermissionChHist(int tenantID, String offset, int startPage, int maxItemPerPage,	String keyword, String keycode, String keycodeForRoll, String lang, String startDate, String endDate, String companyId, boolean isMasterAdmin) throws Exception;

	int getPermissionChHistCount(int tenantID, String offset, String keyword, String keycode, String keycodeForRoll, String lang, String startDate, String endDate, String companyId, boolean isMasterAdmin) throws Exception;

    public List<String> getFileExtension(int tenantId) throws Exception;

	public String updateFileExtension(int tenantId, ArrayList<String> updateFileExtension) throws Exception;
	
	public void insertUserChangeHist(UserChangeInfoVO userChangeInfoVO , LoginVO userInfo) throws Exception;	
	List<UserChangeInfoVO> getUserChHistList(int tenantID, String offset, int startPage, int maxItemPerPage, String keyword, String keycode, String keycodeForType, String lang, String startDate, String endDate, String companyId, boolean isMasterAdmin) throws Exception;
	public int getUserChHistListCount(int tenantID, String offset, String keyword, String keycode, String keycodeForType, String lang, String startDate, String endDate, String companyId, boolean isMasterAdmin) throws Exception;

	List<DeptChangeInfoVO> getDeptChHistList(int tenantID, String offset, int startPage, int maxItemPerPage, String keyword, String keycode, String keycodeForType, String lang, String startDate, String endDate, String companyId, boolean isMasterAdmin) throws Exception;
	public int getDeptChHistListCount(int tenantID, String offset, String keyword, String keycode, String keycodeForType, String lang, String startDate, String endDate, String companyId, boolean isMasterAdmin) throws Exception;
	public void insertDeptChangeHist(DeptChangeInfoVO deptChangeInfoVO, LoginVO userInfo) throws Exception;
	public List<ConnectionInfoVO> getConnectorList(int tenantID, String offset, int startPage, int maxItemPerPage,
			String keycode, String keyword, String lang, String startDate, String endDate, String companyId) throws Exception;
	public int getConnectorListCount(int tenantID, String offset, String keycode, String keyword, String lang, String startDate, String endDate, String companyId) throws Exception;
	public void resetThemeAllUser () throws Exception;
	public void resetPortletAllUser () throws Exception;
	
	public int getSystemConfigListCount(String searchValue, String type, String companyID, int tenantID) throws Exception;
	public int getSystemConfigListCountPopup(String searchValue, String typeCode, String companyID, int tenantID) throws Exception;
	public List<SystemConfigVO> getSystemConfigList(String searchValue, String type, String offset, int startRow, int endRow, String companyID, int tenantID) throws Exception;
	public List<SystemConfigVO> getSystemConfigListPopup(String searchValue, String type, String offset, int startRow, int pageCount, String companyID, int tenantID) throws Exception;
	public SystemConfigVO getSystemConfig(String CODE, String offset, String companyID, int tenantID) throws Exception;
	public void deletesyStemConfig(String sCode, String companyID, int tenantID) throws Exception;
	public String insertStemConfig(Document doc, String WRITERID, String WRITERNAME, int tenantID) throws Exception;
	public String updateStemConfig(Document doc, String WRITERID, String WRITERNAME, int tenantID) throws Exception;
	public int getSystemConfigTypeListCount(String searchValue, String companyID, int tenantId) throws Exception;
	public String getSystemConfigTypeList(String searchValue, String offset, int startRow, int pageSize, String searchMode, String primaryLang, String companyID, int tenantId) throws Exception;
	public void deleteSystemConfigType(String typeCode, String companyID, int tenantId) throws Exception;
	List<SystemConfigTypeVO> getSystemConfigTypeListNotXml(String searchValue, String offset, int startRow,	int pageSize, String searchMode, String companyID, int tenantId) throws Exception;
	public String checkDuplicateCode(String code, int tenantId, String companyID) throws Exception;
	public SystemConfigTypeVO getSystemConfigType(String typeCode, String offset, String companyID, int tenantId) throws Exception;
	public String checkDuplicateTypeCode(String typeCode, int tenantId, String companyID) throws Exception;
	public void insertSystemConfigType(String typeCode, String typeName, String typeName2, String description, String writerId, String writerName, String writerName2, int tenantId, String companyId) throws Exception;
	public void updateSystemConfigType(String typeCode, String typeName, String typeName2, String description, String writerId, String writerName, String writerName2, int tenantId, String companyId) throws Exception;
	public void disableDeleteSystemConfig(String sCode, String companyID, int tenantId) throws Exception;

	List<IPBandVO> getFidoAuthenticList(int tenantID, String companyId) throws Exception;
	int getFidoAuthenticInfo(int tenantID, String companyId, String ipAddress) throws Exception;
	IPBandVO getSystemFidoIPBand(String ipNo) throws Exception;
	void insertFidoIPBand(int tenantID, String companyId, String ipAddress, String access, String explanation) throws Exception;
	void updateFidoIPBand(String ipNo, String ipAddress, String access, String explanation) throws Exception;
	void deleteFidoIPBand(String ipNo) throws Exception;
	public String insertDefaultPwPolicy(int tenantID, String companyID) throws Exception; // 암호 정책 설정 추가
}
