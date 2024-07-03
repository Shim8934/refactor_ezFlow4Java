package egovframework.ezEKP.ezCommon.service;

import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

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
	
	void createTblSession() throws Exception;

	public String saveUserLocalInfo (String pUserID, LoginVO userInfo) throws Exception;
	
	public String selectUserGetLang(String userID, int tenantID) throws Exception;
	
	public String selectUserGetTimeZone(String userID, int tenantID) throws Exception;
	
	public String getTenantConfig(String property, int tenantID) throws Exception;
	
	public Map<String, Object> getTenantConfigs(int tenantID) throws Exception;
	
	public List<TenantVO> getTenantList() throws Exception;
	
	public List<TenantServerNameVO> getTenantServerNameList() throws Exception;
	
	public ApprovPWDVO getApprovPWD(LoginVO userInfo) throws Exception;
	
	/* 더 이상 사용되지 않는 코드로 보여 보안 취약점 조치를 위해 제거함
	public void responseAttach(String pPhysicalFilePath, String pFileName, boolean pAttachment, HttpServletRequest request, HttpServletResponse response) throws Exception;
	*/
	
	public void insertTblUserLocalInfo(String userID, String timeZone, String lang, int tenantID) throws Exception;

	public int getTenantIdByDomainName(String domainName) throws Exception;
	
	public String getUserConfigInfo(int tenantID, String userID, String propertyName) throws Exception;
	
	public boolean checkHasUserConfigProperty(int tenantID, String userID, String propertyName) throws Exception;

	public int updateUserConfigInfo(int tenantID, String userID, String propertyName, String propertyValue) throws Exception;
	
	public void insertUserConfigInfo(int tenantID, String userID, String propertyName, String propertyValue) throws Exception;

	public void deleteUserConfigInfo(int tenantID, String userID, String propertyName) throws Exception;
	
	public void createTblCompanyConfig() throws Exception;
	
	public String getCompanyConfig(int tenantID, String companyID, String property) throws Exception;

	public void insertCompanyConfig(int tenantId, String companyId, String propertyName, String propertyValue) throws Exception;

	public void updateCompanyConfig(int tenantId, String companyId, String propertyName, String propertyValue) throws Exception;

	public void deleteCompanyConfig(int tenantId, String companyId, String propertyName) throws Exception;
	
	public void setMultiLoginUser(int tenantID, String companyId, String userID, String loginTime, Device deviceType) throws Exception;
	
	public String selectMultiLoginTime(int tenantID, String companyId, String userID, Device deviceType) throws Exception;
	
	public boolean matchMultiLoginTime(int tenantID, String companyId, String userID, String loginTime, Device deviceType) throws Exception;
	
	public void createTblUserMultiLogin() throws Exception;

	public void createTblIPAccessID() throws Exception;
	
	public void createTblIPAccessIP() throws Exception;
	
	public void createJMochaDistributionSub() throws Exception;

	public void createJMochaMailSignatureTemplate() throws Exception;

	public void createJobMasterTable() throws Exception;
	
	public String getUseSession(Map<String, Object> map);

	public void insertUseSession(Map<String, Object> map);
	
	public void createWebfolderToken() throws Exception;
	
	public void createPortalThemePortlet() throws Exception;
	
	public void insertPortalThemePortletInitdata() throws Exception;
	
	public void createJmochaMailCopyright() throws Exception;
	
	public void createJamesMailDeletedId() throws Exception;

	public void updateTaskUrl() throws Exception;

	public void updateListOptionData() throws Exception;
	
	public void createBoardLike() throws Exception;
	
	public void addWebfolderTotalLimit() throws Exception;
	
	public void addMemoExtensionColumns() throws Exception;

	public void createAttitudeAnnual() throws Exception;

	public void createResourcePortlet() throws Exception;

	public void insertSurveyTenantConfig() throws Exception;

	public void insertPortletInfo() throws Exception;

	public void createThemeAndPortletAuth() throws Exception;

	public void addMenuAndPortletCode() throws Exception;

	public List<CountryVO> getCountryInfo(Map<String, Object> map) throws Exception;

	public void createAccessCountry() throws Exception;
	
	public void createPersonalPopupUser() throws Exception;

	public boolean getPermissionGroupAccessYN (String groupId, String companyId, int tenantId, String userId, String deptId, boolean applySubDeptYN) throws Exception;
	
	public List<LoginVO> getPermissionGroupMembers (String groupId, String companyId, int tenantId, boolean applySubDeptYN) throws Exception;
	
	public void alterChamjoView() throws Exception;

	public void addAddressFurigana() throws Exception;

	public void createOpenGovTable() throws Exception;

	public int checkDeptId(String userID, String deptID, String tenantId);

	public void createRsFavoriteTable();
	
	public void insertTblTenantConfig() throws Exception;

	public void createUserDistributionTable();

	public void alterTableAddColumns() throws Exception;

	public void addThemeAndPorteltAuthInit() throws Exception;
	
	public void createJmochaBigAttachDownloadLimit() throws Exception;
	
	public void insertMailBigSizeAttachLimit() throws Exception;

	public void setCompanyConfigs() throws Exception;
	
	public void createPwPolicyTable() throws Exception;
	
	public void createPwPolicyPatternTable() throws Exception;
	
	public void createTblShareDocDir() throws Exception;
	
	public void createTblNoticeBoard() throws Exception;
	
	public void createAprAttachLimit() throws Exception;
	
	public void insertUseExternalMailServerConfig() throws Exception;

	public void insertReBebuOpinionCode() throws Exception;
	
	public void createAdminAccessIpTable() throws Exception;
	
	public void insertAnnualScheduleTenantConfig();

	public void insertHalfOffAttitudeType();

	public void insertHolidayCheckTenantConfig();

	public void insertAlternateHolidayAttitudeType();

	public void insertBeforeOutComeAttitudeType();	
	
	public void insertMobileAttitudeColumn() throws Exception;

	public void createMenuTenantConfig() throws Exception;

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
	
	public void createWebfolderFileUserTable();
	
	public void insertApprContainterConfig() throws Exception;
	
	// webfolder
	public List<String> getPermissionGroupIdListOfUser(String userId, String deptId, String companyId, int tenantId) throws Exception;
	
	public void createTblWebfolderApplyHistroy() throws Exception;
	
	public void checkWebfolderEncryptTable() throws Exception;
	
	public void checkWebfolderVersionTable() throws Exception;
	
	public void addWebfolderLogHistory() throws Exception;
	
	void createWebfolderNoInherit();
	
	public void createSerialnumgenGrant() throws Exception;
	
	public void insertApprSatViewerConfig() throws Exception;

	public JSONObject attachWebFolderFile(JSONArray fileListJson, LoginVO userInfo, String param, HttpServletRequest request);

    public void createTblCar() throws Exception;
    
    public void createTblCarAcl() throws Exception;
    
    public void createTblCarAttach() throws Exception;
    
    public void createTblCarForm() throws Exception;

	public void addViewTaskOldFlag() throws Exception;

	public HashMap<String, String> getTenantConfigList(int tenantID, String... propertyNames) throws Exception;

	public String getPrevPwd(int tenantID, String pCN) throws Exception;
	
	public int setPrevPwd(int tenantID, String pCN, String propertyValue) throws Exception;
	
	public void createTblScheduleComplete() throws Exception;
	
	public void alterTblConnectionInfo() throws Exception;
	
	public void createTblAdminAccessInfo() throws Exception;
	
	public void createMailOutOfOfficeTemplate() throws Exception;
	
	public void createUserMailTemplate() throws Exception;
	
	void createTblPermissionChangeInfo() throws Exception;
	
	public void insertReceiptHistoryListoption() throws Exception;
	
	public void alterTblDevMaster() throws Exception;

	String createExcelByList (String fileName, String dirPath, String sheetName, List<List<Object>> data) throws Exception;
	
	public void createTblAprpreview() throws Exception;
	
	void createTblDisableNotiItem();

	public void createTblSerialNoRollback() throws Exception;

	public void insertHWPSecurityConfig() throws Exception;

	/* 2023-06-26 민지수 - 완료문서 추가의견타입 추가 */
	public void insertOpinionGB() throws Exception;

	public void addAttitudeFormFormHtml2Column() throws Exception;

	public void createTblUserChangeInfo() throws Exception;
	
	// 2023-10-05 전인하 - 권한 코드 변경으로 인하여 기존 데이터를 변경하는 메소드
	public void updateWebFolderAndApprovalCheckPermissionCode() throws Exception;

	public void createTblBoardReplyReact() throws Exception;
	
	/* 2023-09-25 민지수 - 게시판 > 공지게시물 > 기간설정 컬럼 추가 */
	public void addTblBoardItemNoti() throws Exception;

	/* 2023-09-25 민지수 - 게시판 > 임시보관함 > 공지게시물 > 기간설정 컬럼 추가 */
	public void addTblBoardItemTempNoti() throws Exception;
	
	public void insertPrvwConfig() throws Exception;

	public void insertPermissionBasisDeptYN_Config() throws Exception;
	
	void createTblDbLog();

	// 2023-11-22 조소정 - 포탈 > 기본 탑메뉴 중국어 버전 추가
	public void insertPortalMenuChinese() throws Exception;

	// 2023-11-22 조소정 - 포탈 > 기본 포틀릿명 중국어 버전 추가
	public void insertPortletNameChinese() throws Exception;

	// 2023-11-27 조소정 - 게시판그룹 일본어 버전 생성 위해 LangTertiary 테넌트 컨피그 추가	
	public void insertTenantConfigLangTertiary() throws Exception;

	// 2023-11-27 조소정 - 게시판그룹 중국어 버전 생성 위해 LangQuaternary 테넌트 컨피그 추가
	public void insertTenantConfigLangQuaternary() throws Exception;
	
	public void insertLoadTimeForApprAllConfig() throws Exception;

	public void createTblDeptChangeInfo() throws Exception;

	public void insertSurveyPostingMaxPeriodConfig() throws Exception;

	public void alterFileNameForWebfolderHistory() throws Exception;

	/** 2023-06-26 한태훈 - 통합 PC 저장 이력 남기는 테이블(차후 다른 목적으로도 쓰일 수 있음) 추가 */
	public void createTblTotalHistory() throws Exception;

	public void insertdelAttachByOthersConfing() throws Exception;

	public void insertUseHideHeaderArea() throws Exception;

	// 2024-05-28 이유정 - 자원관리 > 자원반복예약 허용 설정을 위한 RepeatFlag 컬럼 추가
	public void alterRepeatFlagForResourceInfo() throws Exception;

	/* 2024-05-28 김유진 - 포탈 메뉴,포틀릿,테마,빠른링크 > 하위부서 허용여부 컬럼 추가, 빠른링크 > 유저타입 컬럼 추가 */
	public void alterSubPermittedForMenuAuth() throws Exception;

	public void alterSubPermittedForPortletAuth() throws Exception;

	public void alterSubPermittedForThemeAuth() throws Exception;

	public void alterSubPermittedForQuicklinkAcl() throws Exception;

	public void insertApprNonElecRecTypeConfing() throws Exception;
	
	public void createTables() throws Exception;

    public void insertRecordHeaderClassTitle() throws Exception;

	public void insertUseReceiptDeptFileAttach() throws Exception;

	public void insertDocBinderListOption() throws Exception;

	public void insertEndDateOptionConfig() throws Exception;

	/* 2024-06-24 양지혜 - 전자결재 > 지정반송 사용여부 컨피그 */
	public void insertReturnByDesignationUsedConfig() throws Exception;

	public void alterDocAttachNameCol() throws Exception;

	public void insertNonUseDocAttachYN() throws Exception;

	public void insertReadingRecordHeader() throws Exception;

    void insertPortalPortletSizeTables();

	void insertTblPortalTopUser();
	
	// 2024-03-28 한태훈 > 통합알림 테이블 생성하는 메소드
	public void createTblRealTimeNotification() throws Exception;

	// 2024-03-28 한태훈 > 알림 보관기간 테넌트 컨피그 추가 메소드
	public void addNotiStoragePeriodConfig() throws Exception;
	
	// 2024-03-28 한태훈 > 통합알림 polling 방식 이용시 알림 데이터 새로고침 주기 설정
	public void addNotiPollingIntervalConfig() throws Exception;

	void insertFixPortlet();

	public void insertTblPortalTopCompany() throws Exception;

	public void insertPortalTopCompanyInitdata() throws Exception;

    void addQuickLinkCompanyID() throws Exception;

	public void alterUserThemePagination() throws Exception;

	public void alterThemeInformation() throws Exception;
	
	public void alterCompanyMenuIconUrl() throws Exception;

    public void alterTblScheduleForShowtop() throws Exception;
	
	public void addUserDeptHideFlag() throws Exception;

	public void insertGongRamListOption() throws Exception;
	
	/* 2023-10-20 한태훈 - 일정관리 > 미리알림 테이블 추가 */
	public void createTblScheduleReminderScheduler() throws Exception;
	
	/* 2023-10-20 한태훈 - 일정관리 > 미리알림 시간 컬럼 추가 */
	public void addReminderTimeAtTblScheduleConfig() throws Exception;
	
	/* 2023-10-20 한태훈 - 일정관리 > 미리알림 테넌트 컨피그 추가 */
	public void insertReminderTenantConfig() throws Exception;

	// 2024-06-28 이유정 - 캐비넷 > 캐비넷공유 > 공유자 저장여부 컬럼 추가
	public void alterSaveFlagForCbShare() throws Exception;
}
