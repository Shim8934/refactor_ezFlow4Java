package egovframework.ezEKP.ezCommon.service;

import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

import egovframework.ezEKP.ezCommon.vo.ApprovPWDVO;
import egovframework.ezEKP.ezSystem.vo.CountryVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.user.login.vo.TenantServerNameVO;
import egovframework.let.user.login.vo.TenantVO;

public interface EzCommonService {

	public enum Device {
		PC, MOBILE;

		public boolean isMobile() {
			return this == MOBILE;
		}
	}

	public String startHtml2Mht(String strHTML, String realPath, Locale locale) throws Exception;
	
	public String getMHTtoHTML(String type, String itemID, int tenantID, String realPath, HttpServletRequest request, Locale locale, String scheme) throws Exception;
	
	public String loadMHTFile(String path) throws Exception;
	
	public String startMHT2HTML(String filePath, String m_strMHT, String filePath2, String realPath, Locale locale, String domain, String scheme) throws Exception;
	
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
	
	public String getUserConfigInfo(int tenantID, String userID, String propertyName) throws Exception;
	
	public int updateUserConfigInfo(int tenantID, String userID, String propertyName, String propertyValue) throws Exception;
	
	public void insertUserConfigInfo(int tenantID, String userID, String propertyName, String propertyValue) throws Exception;
	
	public void createTblCompanyConfig() throws Exception;
	
	public void createReformFlagColumn() throws Exception;
	
	public String getCompanyConfig(int tenantID, String companyID, String property) throws Exception;

	public void insertCompanyConfig(int tenantId, String companyId, String propertyName, String propertyValue) throws Exception;

	public void updateCompanyConfig(int tenantId, String companyId, String propertyName, String propertyValue) throws Exception;

	public void deleteCompanyConfig(int tenantId, String companyId, String propertyName) throws Exception;
	
	public void setMultiLoginUser(int tenantID, String companyId, String userID, String loginTime, Device deviceType) throws Exception;
	
	public String selectMultiLoginTime(int tenantID, String companyId, String userID, Device deviceType) throws Exception;
	
	public boolean matchMultiLoginTime(int tenantID, String companyId, String userID, String loginTime, Device deviceType) throws Exception;
	
	public void createTblUserMultiLogin() throws Exception;

	public void addMailToJMochaDistribution() throws Exception;
	
	public void addAddJobMasterOrderBy() throws Exception;
	
	public void createTblIPAccessID() throws Exception;
	
	public void createTblIPAccessIP() throws Exception;
	
	public void createJMochaDistributionSub() throws Exception;

	public void addUserMasterManualFlag() throws Exception;
	
	public void addDeptMasterManualFlag() throws Exception;
	
	public void addAddJobMasterManualFlag() throws Exception;
	
	public void createJMochaMailSignatureTemplate() throws Exception;

	public void createJobMasterTable() throws Exception;
	
	public String getUseSession(Map<String, Object> map);

	public void insertUseSession(Map<String, Object> map);
	
	public void addJobMasterJobID() throws Exception;

	public void createWebfolderToken() throws Exception;
	
	public void addJmochaMailGenenalPreviewMailImage() throws Exception;

	public void addUserMasterPasswordUpdateDT() throws Exception;
	
	public void addUserMasterPhotoUpdateDT() throws Exception;

	public void addUserMasterMailBoxQuota() throws Exception;

	public void addPortalThemePortletIsFixed() throws Exception;

	public void addHolidayFlag() throws Exception;
	
	public void addHolidayRepeat() throws Exception;
	
	public void createPortalThemePortlet() throws Exception;
	
	public void insertPortalThemePortletInitdata() throws Exception;
	
	public void addJournalFormDelFlag() throws Exception;
	
	public void createJmochaMailCopyright() throws Exception;
	
	public void createJamesMailDeletedId() throws Exception;

	public void updateTaskUrl() throws Exception;

	public void addPortalPortletUserPortletUsed() throws Exception;

	public void addPortalPortletUserThemeId() throws Exception;
	
	public void addTblPortalThemeUserIsDefault() throws Exception;

	public void updateListOptionData() throws Exception;
	
	public void createBoardLike() throws Exception;
	
	public void addBoardLikeFlag() throws Exception;

	public void addQuickLinkLinkOrder() throws Exception;
	
	public void addComCloseCompanyId() throws Exception;

	public void addWebfolderTotalLimit() throws Exception;
	
	public void addMsgInMailSearch() throws Exception;

	public void addFormVersion() throws Exception;

	public void addMemoExtensionColumns() throws Exception;

	public void addSurveyAlamColums() throws Exception;
	
	public void addAddJobMasterProxy() throws Exception;

	public void createAttitudeAnnual() throws Exception;

	public void createResourcePortlet() throws Exception;

	public void insertSurveyTenantConfig() throws Exception;

	public void addThemeContentLang() throws Exception;

	public void insertPortletInfo() throws Exception;

	public void createThemeAndPortletAuth() throws Exception;

	public void addMenuAndPortletCode() throws Exception;

	public List<CountryVO> getCountryInfo(Map<String, Object> map) throws Exception;

	public void createAccessCountry() throws Exception;
	
	public void addSnMenuAuth() throws Exception;

	public void addBoardManageTypeColumn() throws Exception;

	public void createPersonalPopupUser() throws Exception;

	public boolean getPermissionGroupAccessYN (String groupId, String companyId, int tenantId, String userId, String deptId, boolean applySubDeptYN) throws Exception;
	
	public void addSurveyMailSentFlagColumn() throws Exception;
	
	public List<LoginVO> getPermissionGroupMembers (String groupId, String companyId, int tenantId, boolean applySubDeptYN) throws Exception;
	
	public void addSnThemeAndPortletAuth() throws Exception;

	public void alterChamjoView() throws Exception;

	public void addAddressFurigana() throws Exception;

	public void createOpenGovTable() throws Exception;

	public void addOpenGovFlag() throws Exception;

	public int checkDeptId(String userID, String deptID, String tenantId);

	public void createRsFavoriteTable();
	
	public void insertTblTenantConfig() throws Exception;

	public void createUserDistributionTable();

	public void addThemeAndPorteltAuthInit() throws Exception;
	
	public void createJmochaBigAttachDownloadLimit() throws Exception;
	
	public void insertMailBigSizeAttachLimit() throws Exception;

	public void addIsBeforeDoc() throws Exception;

	public void addBeforeDocUrl() throws Exception;

	public void setCompanyConfigs() throws Exception;
	
	public void createPwPolicyTable() throws Exception;
	
	public void createPwPolicyPatternTable() throws Exception;
	
	public void addAprAttachViewOrder() throws Exception;

	public void createTblShareDocDir() throws Exception;
	
	public void addAprEndAttachViewOrder() throws Exception;
	
	public void addAprTmpAttachViewOrder() throws Exception;
	
	public void alterTblPsApprovNotiMailConf() throws Exception;
	
	public void createTblNoticeBoard() throws Exception;
	
	public void createAprAttachLimit() throws Exception;
	
	public void addDocStateIntoLastLines() throws Exception;

	public void addDocStateIntoLastDeptLines() throws Exception;
	
	public void insertUseExternalMailServerConfig() throws Exception;

	public void insertReBebuOpinionCode() throws Exception;
	
	public void createAdminAccessIpTable() throws Exception;
	
	public void addFormAprOptionColumn() throws Exception;

	public void insertAnnualScheduleTenantConfig();

	public void insertHalfOffAttitudeType();

	public void insertHolidayCheckTenantConfig();

	public void insertAlternateHolidayAttitudeType();

	public void insertBeforeOutComeAttitudeType();	
	
	public void insertMobileAttitudeColumn() throws Exception;

	public void insertDailyWorkAttitudeColumn() throws Exception;
	
	public void createMenuTenantConfig() throws Exception;

	public void addPassAprLineFlag() throws Exception;
	
	public void addFormSihangTypeColumn() throws Exception;
	
	public void insertAutoSendOfferFlag() throws Exception;

	public void insertTabBoardPortlet() throws Exception;
	
	public void createTblTabBoard() throws Exception;
	
	public void addScehdulegroup() throws Exception;

	public void insertApprBigAttachInfo() throws Exception;
	
	public void addScheduleMailNotiConfig() throws Exception;

	public void createTblYearlyDocCount() throws Exception;

	public void insertChartPortletInfo() throws Exception;

	void addTblUserMultiLoginMobileFlagColumn() throws Exception;
	
	public void createMailTemplateSequence() throws Exception;

	public void createJmochaMailboxProgress() throws Exception;
	
	public void addWebfolderUserSubdeptPermittedColumn() throws Exception;
	
	public void addWebfolderUserFolderManagerColumn() throws Exception;
	
	public void createWebfolderFileUserTable();
	
	public void insertApprContainterConfig() throws Exception;
	
	// webfolder
	public List<String> getPermissionGroupIdListOfUser(String userId, String deptId, String companyId, int tenantId) throws Exception;
	
	public void createTblWebfolderApplyHistroy() throws Exception;
	
	public void checkWebfolderEncryptTable() throws Exception;
	
	public void checkWebfolderVersionTable() throws Exception;
	
	void createWebfolderHierarchicalColumns();

	public void addWebfolderLogHistory() throws Exception;
	
	void createWebfolderNoInherit();
	
	public void alterWebfolderApplyHistoryAddColumn() throws Exception;
	
	public void createSerialnumgenGrant() throws Exception;
	
	public void insertApprSatViewerConfig() throws Exception;

	public JSONObject attachWebFolderFile(JSONArray fileListJson, LoginVO userInfo, String param, HttpServletRequest request);

	public void addBoardMailFGColumn() throws Exception;

	public void addCommNoticeUpperNoColumn() throws Exception;
	
	public void alterTblAprReceiptProcessInfoAddColumn() throws Exception;
	
	public void alterTblDocDeliveryAddColumn() throws Exception;
	
    public void addTblAdminReceiptGroupSubExtReceptYnColumn() throws Exception;
    
    public void createTblCar() throws Exception;
    
    public void createTblCarAcl() throws Exception;
    
    public void createTblCarAttach() throws Exception;
    
    public void createTblCarForm() throws Exception;

	public void addViewTaskOldFlag() throws Exception;

	public HashMap<String, String> getTenantConfigList(int tenantID, String... propertyNames) throws Exception;

	public void alterTblAddjobMaster() throws Exception;
	
	public String getPrevPwd(int tenantID, String pCN) throws Exception;
	
	public int setPrevPwd(int tenantID, String pCN, String propertyValue) throws Exception;
	
	public void addCommMailFGColumn() throws Exception;

	public void addSurveySubDeptYNColumn() throws Exception;

	public void createTblScheduleComplete() throws Exception;
	
	public void alterTblConnectionInfo() throws Exception;
	
	public void createTblAdminAccessInfo() throws Exception;
	
	public void createMailOutOfOfficeTemplate() throws Exception;
	
	public void createUserMailTemplate() throws Exception;

	void createTblPermissionChangeInfo() throws Exception;

	public void addSusinScheduleOffsetColumn() throws Exception;
}
