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

	public int checkDeptId(String userID, String deptID, String tenantId, String jobID);

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
	
	void createTblFidoSession() throws Exception;
	
	public void createMailTemplateSequence() throws Exception;

	public void createJmochaMailboxProgress() throws Exception;

	void addMailboxProgressStateColumns();

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
	
	/* 2023-12-05 홍승비 - 전자결재 > 전자결재 서명 데이터 재맵핑 시점 컨피그 추가 */
	public void insertApprSignRemapApplyTime() throws Exception;
	
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

	public void addColumnsRetireTblCompareWithUserTbl() throws Exception;

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
	
	public void alterBoardExtentionAttrByteSize() throws Exception;

	// 2024-08-21 유길상 닷넷 통합알림 컨피그
	public void insertDotNetTotalNotificationConfig() throws Exception;
	
	public void updateInProcessJpCodeName3() throws Exception;

	public void createTblDistributeinfo() throws Exception;
	
	public void createExecutiveTable() throws Exception;
 
	public void createServeyResultviewPermTbl() throws Exception;

	/* 2024-07-17 기민혁 - 전자결재 > 양식함 순서 컬럼 추가 */
	public void addTblFormContainerSN() throws Exception;
	
	public void insertInitMobileTheme() throws Exception;
	
	public void alterMenuOpenType() throws Exception;
	
	public void createSystemConfig() throws Exception;
	
	public void createConnectionMenu() throws Exception;
	
	public void insertStandardSystemConfigData() throws Exception;
	
	public void createEmergencyNotiTable() throws Exception;
	
	// 2024-08-08 조수빈 - 모바일 우측 panel의 기본 toggle menu 데이터 추가
	public void insertMobileToggleMenus() throws Exception;
	
	// 2024-08-20 조수빈 - 포탈 설정 > 모드 설정 컬럼 추가
	public void alterUseColor() throws Exception;
	
	// 2024-09-02 조수빈 - 테마 변경에 따른 테마 데이터 update
	public void updateThemeData() throws Exception;
	
	void createRsScheduleDeptIdColumn() throws Exception;

	/* 2023-03-30 이가은 - 게시판 > 게시물 댓글 정보 테이블에 답글 작성/수정기능 컬럼 추가 */
	public void alterTblBoardOneLineChildReply() throws Exception;

	// 2023-11-07 전인하 - 댓글 이모티콘 관련 컬럼 추가
	public void insertBoardReplyCommentEmoticon() throws Exception;
		
	public void createTblBoardDisLike() throws Exception;
	
	public void addBoardDisLikeFlag() throws Exception;
	

	public void createBoardKeywordTable() throws Exception;
	
	// 2024-08-07 유길상 - 자원관리 즐겨찾기 카테고리 테이블 추가
	public void createResourceFavoriteTables() throws Exception;

	// 2024-10-23 정지은 - 게시판 > 글 작성 시 파일첨부 가능여부 설정
	public void addBoardAttachmentFlag() throws Exception;
	
	void addTblBoardInfoPublicFlag();
	
	/* 2024-10-21 한태훈 - 게시판 > 전체게시물 리스트 헤더 추가 */
	public void insertAllBoardListOption() throws Exception;
	/* 2024-10-17 한태훈 - 게시판 > 전체게시물 게시판정보 추가 */
	public void insertAllBoardInfo() throws Exception;

	public void addSurveyTotalNotiSentFlag() throws Exception;

    // 2024-11-14 김승연 메일 열람 차단 테이블 추가
    public void createJmochaMailBlocked() throws Exception;
	
	public void insertModuleEditor() throws Exception;
	
	public void insertServername() throws Exception;
	
	public void insertScrapTenantConfig() throws Exception;
	
	public void insertScrapTableHeader() throws Exception;
	
	public void createTblBoardScrap() throws Exception;
	
	public void createTblUserScrapCont() throws Exception;
	
	public void createTblUserScrapContList() throws Exception;

	// 2024-12-12 김혜림 회사별 메일박스 용량 테이블 추가
	public void createJmochaCompanyQuota() throws Exception;
	
	// 2024-10-23 전인하 - 게시판 > 댓글 첨부 테이블 추가
	public void createTblBoardCommentAttachments() throws Exception;
    
	public void alterAddThumbnailForTPI() throws Exception;
	
	public void alterThumbnailExtForTPI() throws Exception;
	
	public void alterAttachmentsForCBoard() throws Exception;
	
	// 2024-11-26 한태훈 - 시스템 컨피그 > 삭제 차단 컬럼 추가
	public void addIsDeleteBlockToSytemConfig() throws Exception;

	// 2024-10-30 황인경 - 커뮤니티 > 방명록 > 댓글 테이블 추가
	public void addTblCommunityClubguestOnelinereply() throws Exception;

	/* 2024-09-11 이유정 - 게시판 > 최근게시물 리스트헤더 추가 */
	public void insertBoardItemListOptionAN() throws Exception;

	/* 2024-09-11 이유정 - 게시판 > 최근게시물 게시판정보 추가 */
	public void insertRecentBoardInfo() throws Exception;

	// 2024-10-22 정지은 - 게시판 > 게시물의 최근 게시물 포함 여부 설정(게시판 설정)
	public void addBoardAllNewBoardFlag() throws Exception;
	// 2024-10-22 정지은 - 게시판 > 게시물의 최근 게시물 일자 설정
	public void addBoardAllNewBoardListDate() throws Exception;

    public void createTblAprAutoSaveConfig() throws Exception;
	
	public void alterBodyHTMLToConnData() throws Exception;

    // 2024-12-04 기민혁 - 전자결재 > 최근서식 사용여부 테넌트 컨피그 추가
    public void insertResendFormYN() throws Exception;
    
    // 2024-12-05 기민혁 - 전자결재 > 본문수정 시 본문버전 변경 기능 사용여부 테넌트 컨피그 추가
    public void insertEditVertionYN() throws Exception;

    // 2024-12-10 기민혁 - 전자결재 > 수정버전,수정모드 컬럼 추가
    public void alterEditVersionHistory() throws Exception;

    // 2024-12-10 기민혁 - 수정버전 리스트 해더 생성
    public void insertEditVersionListOption() throws Exception;

	// 2024-11-26 기민혁 - 전자결재 > 개인수신함 사용여부 테넌트 컨피그 추가
	public void insertPersonalHideSusinYN() throws Exception;

	// 2024-11-28 기민혁 - 개인 수신함 리스트 해더 추가
	public void insertPersonalSusinListOption() throws Exception;

	/* 2024-07-05 양지혜 - 전자결재 > 상위부서문서함 사용여부 컬럼 추가 */
	public void alterUseUpperDeptBox() throws Exception;

	/* 2025-03-10 유지아 - 톡알림 테이블 tenantId추가 */
	public void alterTalkNotiTenant() throws Exception;

	public void alterServerNameMain() throws Exception;

	// 2024-12-27 이가은 - 공람완료문서 삭제 히스토리 테이블 생성
	public void createGongramDeleteHistory() throws Exception;

	public void addBoardWriterFlagAndWriterNameType() throws Exception;

	public void createTblScheduleGather() throws Exception;

	public void addMemberDeptIdScheduleGroupMember() throws Exception;
	
	public void addMemberDeptIdScheduleGatherMember() throws Exception;
	
	public void createTblBoardStarRating() throws Exception;
	
	// 2025-01-15 조수빈 - 식단 테이블 생성
	public void createMealPlanTable() throws Exception;
	
	// 2025-02-05 조수빈 - 식단 사용 여부 컨피그
	public void insertMealPlanTenantConfig() throws Exception;

	void createTblStatMenu();

	public void insertUseSaasYN() throws Exception;

	public void inserExtLargeFilesever() throws Exception;
	
	public void createJournalListLang() throws Exception;
	
	public void insertJournalListLang() throws Exception;

	public String getMobileLang(String nextUserID, int tenantID) throws Exception;
	
	// 2025-03-21 권기혁 - 일정관리환경설정 기본 화면 사용 여부 컬럼 추가
	public void alterScheduleDefaultViewCheck()throws Exception;

	// 2025-04-21 조수빈 - 기본 일정(개인, 부서, 회사)별 사용자 설정 값 저장 테이블 추가
	public void createUserScheduleTypeConfigTable() throws Exception;

	// 2024-12-05 한태훈 - 게시판 > 게시판 버전관리 테이블 추가
	public void createTblBoardModifyHistory() throws Exception;

	/* 2024-07-22 양지혜 - 관리자 > 전자결재 > 발송현황 메뉴 표출여부 */
	public void insertUseSendOutState() throws Exception;
    
	public String getMoveItemURL(String type, String gubun, String boardId, String itemId) throws Exception;

	// 2025-06-16 이혜림 - 게시판 > 본문 크기 컬럼 추가
	public void addBoardContentSize() throws Exception;

	// 2024-09-12 황인경 - 모바일 메뉴 권한 별도 생성으로 인한 포틀릿 데이터 변경
	public void updateMobilePortletMenuId() throws Exception;
	
	// 2024-08-27 유길상 - 자원관리 > 자원등록 > 최대 예약 가능 기간 컬럼 추가
	public void alterTblRsBrdResMaxDate() throws Exception;
	
	// 2024-08-27 유길상 - 자원관리 > 자원등록 > 정원 컬럼 추가
	public void alterTblRsBrdResMaxUserCnt() throws Exception;
	
	// 2025-07-07 이유정 - 일정관리 > 임원일정 조회 가능 범위 설정 컨피그 추가
	public void insertExecutiveScheduleConfig() throws Exception;

    // 2025-07-10 이유정 - 커뮤니티 > 회원등급 추가 (회원테이블 등급컬럼 추가)
	public void alterTblClubUserGradeColumn() throws Exception;

	// 2025-07-10 이유정 - 커뮤니티 > 회원등급 추가 (커뮤니티테이블 최초가입시 등급, 회원목록 조회등급 컬럼 추가)
	public void alterTblClubJoinGradeColumn() throws Exception;

	// 2025-07-10 이유정 - 커뮤니티 > 회원등급 테이블 추가
	public void createTblCommunityGradeTable() throws Exception;

	// 2025-07-10 이유정 - 커뮤니티 > 기존 데이터 회원등급에 맞춰 세팅
	public void settingCommunityGradeData() throws Exception;

	// 2025-07-15 이유정 - 커뮤니티 > 운영자권한 컬럼 추가
	public void alterTblClubUserAdminAuthColumn() throws Exception;

	//2025-02-13 김대현 - 메일 > 메일 미리보기 기능 추가
	public void addMailPreviewConfig() throws Exception;

	// 2025-07-23 이유정 - 커뮤니티 > 회원탈퇴일자 컬럼 추가
	public void alterTblClubUserWithdrawDateColumn() throws Exception;

	public void alterTblUsermasterForTeams() throws Exception;

	public void createAuthTokenTable() throws Exception;

	public void createUserPresenceTable() throws Exception;

	// 2025-08-05 이유정 - 게시판 > 게시글 주소복사 컬럼 추가
	public void alterTblBoardInfoUrlCopyFlag() throws Exception;

	// 2025-07-10 이혜림 - 게시판 > 게시판 리스트 타입 컬럼 추가
	public void addBoardUsrListShowType() throws Exception;

	public void addBoardListShowType() throws Exception;
	
	public void updateGuestAccessibleUris() throws Exception;
}
