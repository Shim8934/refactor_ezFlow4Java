package egovframework.ezEKP.ezNewPortal.service;

import java.util.List;
import java.util.Map;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

import egovframework.ezEKP.ezApprovalG.vo.ApprGFormVO;
import egovframework.ezEKP.ezBoard.vo.BoardItemVO;
import egovframework.ezEKP.ezBoard.vo.BoardListVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityMyCommunityVO;
import egovframework.ezEKP.ezNewPortal.vo.FavoriteBoardVO;
import egovframework.ezEKP.ezNewPortal.vo.FrameInfoVO;
import egovframework.ezEKP.ezNewPortal.vo.MenuInfoVO;
import egovframework.ezEKP.ezNewPortal.vo.MenuNameVO;
import egovframework.ezEKP.ezNewPortal.vo.PortalUserInfoVO;
import egovframework.ezEKP.ezNewPortal.vo.PortletInfoVO;
import egovframework.ezEKP.ezNewPortal.vo.PortletNameInfoVO;
import egovframework.ezEKP.ezNewPortal.vo.ThemeInfoVO;
import egovframework.ezEKP.ezNewPortal.vo.UserPortalSettingVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalLightPollVO;
import egovframework.ezEKP.ezPoll.vo.PollAnswerVO;
import egovframework.ezEKP.ezPoll.vo.PollQuestionVO;

public interface EzNewPortalService {

	/**
	 * 박종균
	 * */
	public List<BoardListVO> getNoticePortletList(String companyId, int tenantId, int limit) throws Exception;
	public PersonalLightPollVO getPollPortlet(String companyId, int tenantId, String userId) throws Exception;
	public List<PersonalLightPollVO> getPollPortletResult(String companyId, int tenantId, int itemSeq) throws Exception;
	public List<Map<String, Object>> getAssemblePollData(PersonalLightPollVO poll, List<PersonalLightPollVO> pollResult) throws Exception;
	public String getPortalLogoInfo(String companyId, int tenantId, String logoType) throws Exception;
	public List<MenuInfoVO> getUserMenuList(String companyId, int tenantId, String langType, String userId) throws Exception;
	public List<MenuInfoVO> getCompanyMenuList(String companyId, int tenantId, String langType) throws Exception;
	public void updateUserMenuOrder(String companyId, int tenantId, String userId, JSONObject jObj) throws Exception;
	public void deleteUserMenuOrder(String companyId, int tenantId, String userId) throws Exception;
	/**
	 * 유은정
	 */
	public int getVotePortletCount(String userId, String companyId, String deptPath, int tenantId);
	public PollQuestionVO getVotePortletInfo(String userId, String companyId, String deptPath, int tenantId);
	public List<PollAnswerVO> getVotePortletAnswer(int qstId, int tenantId);
	public List<BoardItemVO> getPhotoBoardPortletInfo(int tenantId, String boardId, int startRow, int photoCount);
	public PortletInfoVO getCompanyPortletInfo(String companyId, int tenantId, int portletId, String portletLang);
	public String getBoardAuthCheck(String boardId, String accessId, int tenantId, String companyId);
	public List<PortletInfoVO> getPortletOrderUser(String portletLang, String userId, int tenantId, String companyId);
	public List<PortletInfoVO> getPortletOrderComp(String portletLang, int tenantId, String companyId);
	public UserPortalSettingVO getUserPortalSetting(String userId, String companyId, int tenantId);
	public void updatePortletOrderUser(String userId, String companyId, int tenantId, List<Map<String, Integer>> portletOrder, String portletLang);
	public List<PortalUserInfoVO> getMonthlyBirthdayEmployees(String companyId, int tenantId, int month, int count, int startRow);
	public int getMonthlyBirthdayEmployeesCount(String companyId, int tenantId, int month);
	public PortalUserInfoVO getMonthlyBestEmployee(String yearAndMonth, String companyId, int tenantId);
	public List<ThemeInfoVO> getUserThemeList(String companyId, int tenantId);
	public MenuInfoVO getUserStartPage (String userId, int tenantId, String companyId);
	public void updateUserStartPage(int menuId, String userId, int tenantId, String companyId);
	public void deleteUserThemeSetting(String userId, int tenantId, String companyId);
	public void updateUserThemeSetting(int usedTheme, int usedFrame, String userId, int tenantId, String companyId);
	
	/**
	 * 이효진
	 */
	
	public List<ApprGFormVO> getFavoriteForms(String userId, String companyId, int tenantId) throws Exception;
	/**
	 * 테마목록조회
	 * @param admin true(admin) false(user)
	 */
	public List<ThemeInfoVO> getThemes(boolean admin, String companyId, int tenantId) throws Exception;
	/**
	 * 관리자 테마상세정보조회
	 */
	public ThemeInfoVO getThemeInfo(int themeId, String companyId, int tenantId) throws Exception;
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
	public List<MenuInfoVO> getMenus(String companyId, int tenantId) throws Exception;
	/**
	 * 관리자 메뉴상세정보조회
	 */
	public MenuInfoVO getMenuInfo(int menuId, String companyId, int tenantId) throws Exception;
	/**
	 * 관리자 메뉴상세정보 메뉴이름조회
	 */
	public List<MenuNameVO> getMenuNames(int menuId, String companyId, int tenantId) throws Exception;
	/**
	 * 관리자 메뉴별 권한목록조회
	 */
	public Map<String, Object> getMenuAuth(int menuId, String companyId, int tenantId) throws Exception;
	/**
	 * 관리자 메뉴정보 및 메뉴이름 수정
	 */
	public void updateCompanyMenuInfo(int menuId, JSONObject menuInfo, JSONArray menuNames, String companyId, int tenantId) throws Exception;
	/**
	 * 관리자 메뉴별 권한목록 수정
	 */
	public void updateMenuAuth(JSONObject menuAuths, int menuId, String companyId, int tenantId) throws Exception;
	/**
	 * 관리자 메뉴추가
	 */
	public void insertMenu(JSONObject menuInfo, JSONArray menuNames, JSONObject menuAuths, String companyId, int tenantId) throws Exception;
	
	public Map<String, Object> getApprovalStatistics(String userId, String companyId, int tenantId) throws Exception;
	public Map<String, Object> getApprovalList(String userId, String companyId, int tenantId, String offset, String type) throws Exception;
	/** -------------------- */
	
	/**
	 * 구해안
	 */
	
	public List<FavoriteBoardVO> getFavNewItemList(String userId, int tenantId, String companyId, String nowDate, int limit);
	public List<FavoriteBoardVO> getFavItemList(String boardId, int tenantId, String companyId, int limit);
	public List<CommunityMyCommunityVO> getCommunityList(String lang, String companyId, int tenantId) throws Exception;
	public String getCommunityPermit(String clubNo, String userId, int tenantId);
	/**
	 * 포틀릿목록조회
	 * @param companyId
	 * @param tenantId
	 * @return List<PortletInfoVO>
	 * @throws Exception
	 */
	public List<PortletInfoVO> getPortletList(String companyId, int tenantId);
	public List<PortletNameInfoVO> getPortletNameList(String companyId, int tenantId, int portletId);
}
