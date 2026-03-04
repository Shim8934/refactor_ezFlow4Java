package egovframework.ezEKP.ezNewPortal.service;

import java.util.List;
import java.util.Map;
import java.util.Optional;

import egovframework.ezEKP.ezNewPortal.vo.PortalUserSwitchVO;
import egovframework.ezEKP.ezNewPortal.vo.ConnectPortletDTO;
import egovframework.ezEKP.ezNewPortal.vo.DeptViewVO;
import egovframework.ezEKP.ezNewPortal.vo.MenuAuthorUserVO;
import egovframework.ezEKP.ezNewPortal.vo.PortalTopVO;
import egovframework.ezEKP.ezNewPortal.vo.PortalTopVO.TopFrameType;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

import egovframework.ezEKP.ezApprovalG.vo.ApprGFormVO;
import egovframework.ezEKP.ezApprovalG.vo.PortletAprInfoVO;
import egovframework.ezEKP.ezBoard.vo.BoardItemVO;
import egovframework.ezEKP.ezBoard.vo.BoardListVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityMyCommunityVO;
import egovframework.ezEKP.ezNewPortal.vo.FavoriteBoardVO;
import egovframework.ezEKP.ezNewPortal.vo.FrameInfoVO;
import egovframework.ezEKP.ezNewPortal.vo.MenuInfoVO;
import egovframework.ezEKP.ezNewPortal.vo.MenuNameVO;
import egovframework.ezEKP.ezNewPortal.vo.PortalBoardTreeVO;
import egovframework.ezEKP.ezNewPortal.vo.PortalLogoVO;
import egovframework.ezEKP.ezNewPortal.vo.PortalUserInfoVO;
import egovframework.ezEKP.ezNewPortal.vo.PortletInfoVO;
import egovframework.ezEKP.ezNewPortal.vo.PortletNameInfoVO;
import egovframework.ezEKP.ezNewPortal.vo.ThemeInfoVO;
import egovframework.ezEKP.ezNewPortal.vo.UserPortalSettingVO;
import egovframework.ezEKP.ezNewPortal.vo.WeatherVO;
import egovframework.ezEKP.ezOrgan.vo.OrganGroupVO;
import egovframework.ezEKP.ezOrgan.vo.OrganJobVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalLightPollVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalSliderImageVO;
import egovframework.ezEKP.ezPoll.vo.PollAnswerVO;
import egovframework.ezEKP.ezPoll.vo.PollQuestionVO;
import egovframework.ezEKP.ezSystem.vo.SystemConfigVO;
import egovframework.ezEKP.ezWebFolder.vo.FileVO;
import egovframework.let.user.login.vo.LoginVO;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public interface EzNewPortalService {

	/**
	 * 박종균
	 * */
	public List<BoardListVO> getNoticePortletList(String companyId, int tenantId, String offset, String lang, int currentPage, int listCntSize, int portletId) throws Exception;
	public PersonalLightPollVO getPollPortlet(String companyId, int tenantId, String userId, String offset) throws Exception;
	public List<PersonalLightPollVO> getPollPortletResult(String companyId, int tenantId, int itemSeq) throws Exception;
	public List<Map<String, Object>> getAssemblePollData(PersonalLightPollVO poll, List<PersonalLightPollVO> pollResult) throws Exception;
	public String getPortalLogoInfo(String companyId, int tenantId, String logoType) throws Exception;
	public List<MenuInfoVO> getUserMenuList(String companyId, int tenantId, String langType, String userId, String deptId, String type) throws Exception;
	public void updateUserMenuOrder(String companyId, int tenantId, String userId, JSONObject jObj) throws Exception;
	public void deleteUserMenuOrder(String companyId, int tenantId, String userId) throws Exception;
	public Map<String, Object> getQuickLinkList(String companyId, int tenantId, int page, int limit, String userId, String deptId) throws Exception;
	public int getQuickLinkTotalPageCnt(String companyId, int tenantId, int limit, String userId, String deptId) throws Exception;
//	public List<?> getUserPortletList(String portletLang, String userId, int tenantId, String companyId, String deptId) throws Exception;
	public List<PortletInfoVO> getUserPortletList(int themeId, String portletLang, String userId, int tenantId, String companyId, String deptId, boolean config) throws Exception;
	public List<?> getUserFrameListAndSelectedFrame(String companyId, int tenantId, String userId) throws Exception;
	public void updateUserUsedFrame(String userId, int tenantId, String companyId, JSONObject jObj) throws Exception;
	public void updateUserUsedPortlet(String userId, int tenantId, String companyId, JSONObject jObj) throws Exception;
	public boolean getCheckAuth(int menuId, String userId, String deptId, String companyId, int tenantId) throws Exception;
	public List<MenuInfoVO> getAllCompanyMenus(String companyId, int tenantId, String companyLang) throws Exception;
	public String isUseEzWorkspace(String companyId, int tenantId, String userId, String deptId, String type) throws Exception;
	/**
	 * 유은정
	 */
	public int getVotePortletCount(String userId, String companyId, String deptPath, int tenantId, String userType, String deptId) throws Exception;
	public PollQuestionVO getVotePortletInfo(String userId, String companyId, String deptPath, int tenantId, String userType) throws Exception;
	public List<PollAnswerVO> getVotePortletAnswer(int qstId, int tenantId) throws Exception;
	public List<BoardItemVO> getPhotoBoardPortletInfo(int tenantId, String boardId, int startRow, int photoCount, String offset) throws Exception;
	public int getPhotoBoardPortletTotalCnt(int tenantId, String boardId, String offset) throws Exception;
	public PortletInfoVO getCompanyPortletInfo(String companyId, int tenantId, int portletId, String portletLang) throws Exception;
	public String getBoardAuthCheck(String boardId, String accessId, int tenantId, String companyId) throws Exception;
	public UserPortalSettingVO getUserPortalSetting(String userId, String companyId, int tenantId, String deptPath, String portletLang) throws Exception;
	public void updatePortletOrderUser(String userId, String companyId, int tenantId, JSONArray portletOrder, String portletLang, int themeId) throws Exception;
	public List<PortalUserInfoVO> getMonthlyBirthdayEmployees(String companyId, int tenantId, int month, int count, int startRow, String lang) throws Exception;
	public int getMonthlyBirthdayEmployeesCount(String companyId, int tenantId, int month) throws Exception;
	public PortalUserInfoVO getMonthlyBestEmployee(String yearAndMonth, String companyId, int tenantId, String lang) throws Exception;
	public List<ThemeInfoVO> getUserThemeList(String companyId, int tenantId, String userId, String deptPath, String lang) throws Exception;
	public MenuInfoVO getUserStartPage (String userId, int tenantId, String companyId) throws Exception;
	public void updateUserStartPage(int menuId, String userId, int tenantId, String companyId) throws Exception;
	public void deleteUserThemeSetting(String userId, int tenantId, String companyId) throws Exception;
	public void updateUserThemeSetting(int usedTheme, int usedFrame, String userId, int tenantId, String companyId) throws Exception;
	public List<BoardListVO> getBoardPortletInfo (String userId, int tenantId, String boardId, int itemCount, String companyId, String offset, boolean isQnANormal, String useVersion) throws Exception;
	public List<BoardListVO> getBoardPortletInfo (String userId, int tenantId, String boardId, int itemCount, String companyId, String offset, boolean isQnANormal, int startRow, String useVersion) throws Exception;
	public int getBoardPortletTotalCnt(String userId, int tenantId, String boardId, String companyId, String offset, boolean isQnANormal, String useVersion) throws Exception;
	//관리자부분
	public List<PortalBoardTreeVO> getBoardTree(String parentBoardId, String companyId, int tenantId) throws Exception;
	public void insertPortlet(JSONObject portletInfo, JSONArray portletNames,  String companyId, int tenantId) throws Exception;
	public void updateCompanyPortletInfo(JSONObject portletInfo, JSONArray portletNames,  String companyId, int tenantId) throws Exception;
	public void updateCompanyPortletOrder(JSONArray portletList, int tenantId, String companyId) throws Exception ;
	public void deletePortlet(int portletId, int menuId, String companyId, int tenantId) throws Exception;
	public void updateCompanyLogo(String companyId, int tenantId, String logoType, String logoUrl) throws Exception;
	public List<PortalLogoVO> getCompanyLogoList(String companyId, int tenantId) throws Exception;
	public int getTnenantIdByServerName(String serverName) throws Exception;
	public void updateCompanyDefaultTheme(int themeId, String companyId, int tenantId) throws Exception;
	public void deleteCompanyLogo(String companyId, int tenantId, String logoType) throws Exception;
	public List<PortletInfoVO> getThemePortletList(int themeId, int tenantId, String companyId, String lang) throws Exception;
	public void updateThemePortletUsed(int themeId, int tenantId, String companyId, JSONArray themePortletList) throws Exception;
	//2019.06.18 테이별, 포틀릿별 권한 관리 설정
	public Map<String, Object> getThemeAuth(String companyId, int tenantId, int themeId, String lang) throws Exception;
	public void updateThemeAuth(JSONArray themeAuths, int menuId, String companyId, int tenantId) throws Exception;
	public boolean checkThemeAuthNoList(String companyId, int tenantId, String userId, String deptPath, int themeId, String lang) throws Exception;
	public Map<String, Object> getPortletAuth(String companyId, int tenantId, int portletId, String lang) throws Exception;
	public void updatePortletAuth(JSONArray portletAuths, int menuId, String companyId, int tenantId) throws Exception;
	/**
	 * 이효진
	 */
	
	public List<ApprGFormVO> getFavoriteForms(String userId, String companyId, int tenantId, String deptId) throws Exception;
	/**
	 * 테마목록조회
	 * @param admin true(admin) false(user)
	 * @param lang 
	 */
	public List<ThemeInfoVO> getThemes(boolean admin, String companyId, int tenantId, String userId, String deptPath, String lang) throws Exception;
	/**
	 * 유저의 테마Id 조회 -> 테마별 포틀릿 추가되면서 테마Id가 필요한 경우가 생김
	 */
	public int getThemeId(String userId, String companyId, int tenantId) throws Exception;
	/**
	 * 관리자 테마상세정보조회
	 * @param lang 
	 */
	public ThemeInfoVO getThemeInfo(int themeId, String companyId, int tenantId, String lang) throws Exception;
	/**
	 * 관리자 테마별 프레임목록 및 정보 조회 
	 */
	public List<FrameInfoVO> getFrames(int themeId, String companyId, int tenantId) throws Exception;
	/**
	 * 관리자 테마정보수정(프레임 포함)
	 */
	public void updateThemeInfo(JSONObject themeInfo, JSONArray frameInfos, String companyId, int tenantId) throws Exception;
	/**
	 * 관리자 회사별 메뉴목록조회
	 */
	public List<MenuInfoVO> getMenus(String companyId, int tenantId, String menuLang, String type) throws Exception;
	/**
	 * 관리자 메뉴상세정보조회
	 */
	public MenuInfoVO getMenuInfo(int menuId, String companyId, int tenantId, String menuLang) throws Exception;
	/**
	 * 관리자 메뉴상세정보 메뉴이름조회
	 */
	public List<MenuNameVO> getMenuNames(int menuId, String usePrimaryLangOnly, String primaryLang, String companyId, int tenantId, String useJapanese, String useChinese, String useVietnamese, String useIndonesian) throws Exception;
	/**
	 * 관리자 메뉴별 권한목록조회
	 * @param lang 
	 */
	public Map<String, Object> getMenuAuth(int menuId, String companyId, int tenantId, String lang) throws Exception;
	/**
	 * 관리자 메뉴정보 및 메뉴이름 수정
	 */
	public void updateCompanyMenuInfo(int menuId, JSONObject menuInfo, JSONArray menuNames, String companyId, int tenantId) throws Exception;
	/**
	 * 관리자 메뉴별 권한목록 수정
	 */
	public void updateMenuAuth(JSONArray menuAuths, int menuId, String companyId, int tenantId) throws Exception;
	/**
	 * 관리자 메뉴추가
	 */
	public void insertMenu(JSONObject menuInfo, JSONArray menuNames, JSONArray menuAuths, String companyId, int tenantId) throws Exception;
	/**
	 * 관리자 메뉴삭제
	 */
	public void deleteMenu(int menuId, String companyId, int tenantId) throws Exception;
	/**
	 * 관리자 메뉴 순서변경
	 */
	public void udpateMenuOrder(JSONArray menus, String companyId, int tenantId) throws Exception;
	
	public Map<String, Object> getApprovalStatistics(String userId, String companyId, int tenantId) throws Exception;
	public JSONObject getApprovalList(String userId, String companyId, int tenantId, String offset, String type, String approvalFlag, String lang, String primary) throws Exception;
	/** -------------------- */
	
	/**
	 * 구해안
	 */
	
	public List<FavoriteBoardVO> getFavNewItemList(String userId, int tenantId, String companyId, String nowDate, int limit, String offset);
	public List<FavoriteBoardVO> getFavNewItemList(String userId, int tenantId, String companyId, String nowDate, int startRow, int limit, String offset);
	public int getFavNewItemListCnt(String userId, int tenantId, String companyId, String nowDate, String offset);
	public List<FavoriteBoardVO> getFavItemList(String boardId, int tenantId, String companyId, int limit, String offset) throws Exception;
	public List<FavoriteBoardVO> getFavItemList(String boardId, int tenantId, String companyId, int startRow, int limit, String offset) throws Exception;
	public int getFavItemListCnt(String boardId, int tenantId, String companyId, String offset) throws Exception;
	public List<CommunityMyCommunityVO> getCommunityList(String lang, int startRow, int listSize, String companyId, int tenantId) throws Exception;
	public int getCommunityListTotalCnt(String companyId, int tenantId) throws Exception;
	public String getCommunityPermit(String clubNo, String userId, int tenantId);
	/**
	 * 포틀릿목록조회
	 * @param companyId
	 * @param tenantId
	 * @return List<PortletInfoVO>
	 * @throws Exception
	 */
	public List<PortletInfoVO> getPortletList(String companyId, int tenantId, int menuLang, String type) throws Exception;
	// 2024-07-10 조수빈 - 다국어 사용 여부 판단 로직 추가 위해 수정함. 
	public List<PortletNameInfoVO> getPortletNameList(String companyId, int tenantId, int portletId) throws Exception;
	public void setWeather() throws Exception;
	public Map<String, Object> getWeather(String cityCode, int primary, String countryCode);
	public List<WeatherVO> getCityList(int primaryLang, String countryCode);
	public String getUserCityCode(String id, int tenantId) throws Exception;
	public void setUserCityCode(String id, int tenantId, String cityCode, String countryCode);
	
	/**
	 * 김보미
	 * @param companyId
	 * @param tenantId
	 * @return
	 */
	//관리자 슬라이드 이미지 포틀릿의 슬라이드 이미지 목록 가져오기
	public List<PersonalSliderImageVO> getSilderImages(String companyId, int tenantId) throws Exception;
	//관리자 슬라이드 이미지 포틀릿의 슬라이드 이미지 상세정보 가져오기
	public PersonalSliderImageVO getSlideImageInfo(int tenantId, String companyId, String slideId) throws Exception;
	//관리자 슬라이드 이미지 포틀릿의 슬라이드 이미지 등록
	public void insertSlideImage(String companyId, int tenantId, String imageUrl, String slideImagePath, String fileName, String userId) throws Exception;
	//관리자 슬라이드 이미지 포틀릿의 슬라이드 이미지 수정
	public void updateSlideImage(String companyId, int tenantId, String imageUrl, String imagePath, String imageName, String userId, String slideId) throws Exception;
	//관리자 슬라이드 이미지 포틀릿의 슬라이드 이미지 삭제
	public void deleteSlideImage(int tenantId, String companyId, String slideId) throws Exception;
	//관리자 슬라이드 이미지 포틀릿의 슬라이드 이미지 순서변경
	public void updateSlideOrder(JSONArray slideList, String companyId,	int tenantId) throws Exception;

	public int getApprovalDoingListCount(String userId, String companyId, int tenantId, String offset, String approvalFlag, String lang) throws Exception;
	
	/* 직위, 직책, 권한그룹 불러오는 부분 (xml로 받지 않도록)*/
	public List<OrganJobVO> getTitleList(String type, int tenantId, String companyId) throws Exception;
	public List<OrganGroupVO> getGroupList(int tenantId, String companyId) throws Exception;
	public List<FileVO> getWebFolderFileList(String folderId, int tenantId, int startRow, int folderListCount) throws Exception;
	
	public int getWebFolderFileListTotalCnt(String folderId, int tenantId) throws Exception;

	public void addPortalTenantConfig(int tenantId, String propertyName, String propertyValue, String description, String configName, String configType) throws Exception;
	public String getUniqueFileName (String dirPath, String fileName) throws Exception;

	List<PortalUserSwitchVO> getArrayUserJob(String lang, String userId, int tenantId) throws Exception;
	void switchAllUserInfo(HttpServletRequest request, HttpServletResponse response, String loginCookie, String companyId, String deptId, String jobId, String jobType) throws Exception;

	/**
	 * 조직도에 쓸 부서 리스트 가져오기
	 * @param userId
	 * @param tenantId
	 * @return
	 * @throws Exception
	 */
	public List<DeptViewVO> getDeptViewList (String userId, String companyId, int tenantId, String lang) throws Exception;

	/**
	 * 해당부서의 사원리스트
	 * @param tenantId
	 * @return
	 * @throws Exception
	 */
	public List<MenuAuthorUserVO> getDeptUserList (int tenantId, String key, String value, String companyId, String lang, String curPage) throws Exception;

	/**
	 * 해당부서의 사원수
	 * @param tenantId
	 * @return
	 * @throws Exception
	 */
	public int getDeptUserListCount (int tenantId, String key, String value,String companyId, String lang) throws Exception;

	List<String> getAllAvailablePortletSize();

	Map<Integer, List<String>> getAvailablePortletSize(int themeId, String companyId, int tenantId);

	void updateThemePortletSize(int themeId, int tenantId, String companyId, JSONArray sizeList);

	void insertPortalTopFrameInfo(String userID, String companyID, int tenantID, TopFrameType type) throws Exception;

	Optional<TopFrameType> getPortalTopFrameInfo(String userID, String companyID, int tenantID) throws Exception;
	
    public List<BoardListVO> getNewBoardPortletInfo(LoginVO userInfo, String userType, int startRow, int itemCount) throws Exception;
    // 2024-05-17 한태훈 - 포탈 > 포탈 탑 메뉴 위치 회사 설정값 가져오는 메소드
	public Optional<TopFrameType> getTopMenuDisplayModeForCompany(String companyId, int tenantId) throws Exception;
	// 2024-05-17 한태훈 - 포탈 > 포탈 탑 메뉴 위치 회사 설정값 수정하는 메소드
	public void updateTopMenuDisplayModeForCompany(int type, String companyId, int tenantId) throws Exception;
	
	public SystemConfigVO getSystemConfig(int portletId, String companyId, int tenantId) throws Exception;
	
	public JSONObject getConnectPortletData(ConnectPortletDTO connectPortletDto) throws Exception;
	
	// 2024-08-21 조수빈 - 유저 사용 색상(모드) 조회
	public int getUserColor(String userId, String companyId, int tenantId) throws Exception;

	// 2024-08-21 조수빈 - 유저 사용 색상(모드) 저장
	public void setUserColorMode(String userId, int tenantId, String companyId, int useColor);
	
	public JSONArray getPortalApprovalList(PortletAprInfoVO portletAprInfoVO) throws Exception;

	public int getResportletId() throws Exception;

	public String getCountryCode(String userID, int tenantID) throws Exception;

	public String getUserLocalLang(String userID, int tenantID) throws Exception;

	public String getFirstCityCode(String countryCode) throws Exception;

	/**
	 * 포탈 > 포틀릿 접근, 리스트보기 권한 체크
	 * @param boardId 	게시글 아이디
	 * @param deptPath 	권한 경로 : everyone,top,Top, + 해당 사용자의 상위부서들 + 자기 부서
	 * @param tenantId 	테넌트아이디
	 * @param companyId 회사아이디
	 * @param deptId 	부서아이디
	 * @param userId 	사용자 아이디
	 * @param rollInfo	
	 * @return	Map = (access : boolean), (listViewFg : boolean)
	 * @throws Exception
	 */
	public Map<String, Object> boardAuthCheck(String boardId, String deptPath, int tenantId, String companyId, String deptId, String userId, String rollInfo) throws Exception;
}
