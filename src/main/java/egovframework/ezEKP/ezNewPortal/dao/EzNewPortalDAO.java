package egovframework.ezEKP.ezNewPortal.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import egovframework.ezEKP.ezNewPortal.vo.MenuAuthorUserVO;
import egovframework.ezEKP.ezNewPortal.vo.DeptViewVO;
import egovframework.ezEKP.ezNewPortal.vo.QuickLinkVO;
import com.google.gson.JsonArray;
import egovframework.ezEKP.ezPMS.vo.TaskMemberVO;
import egovframework.ezEKP.ezNewPortal.vo.PortalTopVO;
import org.springframework.stereotype.Repository;

import egovframework.ezEKP.ezApprovalG.vo.ApprGDocListVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGFormVO;
import egovframework.ezEKP.ezBoard.vo.BoardItemVO;
import egovframework.ezEKP.ezBoard.vo.BoardListVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityCClubUserVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityMyCommunityVO;
import egovframework.ezEKP.ezNewPortal.vo.FavoriteBoardVO;
import egovframework.ezEKP.ezNewPortal.vo.FrameInfoVO;
import egovframework.ezEKP.ezNewPortal.vo.MenuAuthVO;
import egovframework.ezEKP.ezNewPortal.vo.MenuInfoVO;
import egovframework.ezEKP.ezNewPortal.vo.MenuNameVO;
import egovframework.ezEKP.ezNewPortal.vo.PortalBoardTreeVO;
import egovframework.ezEKP.ezNewPortal.vo.PortalLogoVO;
import egovframework.ezEKP.ezNewPortal.vo.PortalUserInfoVO;
import egovframework.ezEKP.ezNewPortal.vo.PortletAuthVO;
import egovframework.ezEKP.ezNewPortal.vo.PortletInfoVO;
import egovframework.ezEKP.ezNewPortal.vo.PortletNameInfoVO;
import egovframework.ezEKP.ezNewPortal.vo.ThemeAuthVO;
import egovframework.ezEKP.ezNewPortal.vo.ThemeInfoVO;
import egovframework.ezEKP.ezNewPortal.vo.UserPortalSettingVO;
import egovframework.ezEKP.ezNewPortal.vo.WeatherVO;
import egovframework.ezEKP.ezOrgan.vo.OrganDeptVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalLightPollVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalSliderImageVO;
import egovframework.ezEKP.ezPoll.vo.PollAnswerVO;
import egovframework.ezEKP.ezPoll.vo.PollQuestionVO;
import egovframework.ezEKP.ezSystem.vo.SystemConfigVO;
import egovframework.ezEKP.ezWebFolder.vo.FileVO;
import org.egovframe.rte.psl.dataaccess.EgovAbstractDAO;

@Repository("EzNewPortalDAO")
public class EzNewPortalDAO extends EgovAbstractDAO {

	// 공지사항 리스트
	@SuppressWarnings("unchecked")
	public List<BoardListVO> getNoticePortletList (Map<String, Object> map) throws Exception {
		return (List<BoardListVO>) list("ezNewPortal.getNoticePortletList", map);
	}
	
	// 설문조사 리스트
	public PersonalLightPollVO getPollPortlet (Map<String, Object> map) throws Exception {
		return (PersonalLightPollVO) select("ezNewPortal.getPollPortlet", map);
	}
	
	// 설문조사 결과 조회
	@SuppressWarnings("unchecked")
	public List<PersonalLightPollVO> getPollPortletResult (Map<String, Object> map) throws Exception {
		return (List<PersonalLightPollVO>) list("ezNewPortal.getPollPortletResult", map);
	}
	
	public String getPortalLogoInfo (Map<String, Object> map) throws Exception {
		return (String) select("ezNewPortal.getPortalLogoInfo", map);
	}
	
	// 현재 사용자 메뉴 순서 존재여부 확인
	public int getUserMenuOrderCnt(Map<String, Object> map) throws Exception {
		return (int) select("ezNewPortal.getUserMenuOrderCnt", map);
	}
	
	// 사용자 메뉴 순서 입력
	public void insertUserMenuOrder(Map<String, Object> map) throws Exception {
		insert("ezNewPortal.insertUserMenuOrder", map);
	}
	
	// 사용자 메뉴 순서 변경
	public void updateUserMenuOrder(Map<String, Object> map) throws Exception {
		update("ezNewPortal.updateUserMenuOrder", map);
	}
	
	// 사용자 메뉴 순서 삭제
	public void deleteUserMenuOrder(Map<String, Object> map) throws Exception {
		delete("ezNewPortal.deleteUserMenuOrder", map);
	}

	// 2024-05-17 김유진 - 퀵링크 권한 체크
	public List<QuickLinkVO> getCheckQuickLinkAcl(Map<String, Object> map) throws Exception {
		return (List<QuickLinkVO>) list("ezNewPortal.getCheckQuickLinkAcl", map);
	}

	// 퀵 링크 불러오기
	public List<?> getQuickLinkList(Map<String, Object> map) throws Exception {
		return (List<?>) list("ezNewPortal.getQuickLinkList", map);
	}
	
	// 퀵 링크 전체 개수 불러오기
	public int getQuickLinkTotalCnt(Map<String, Object> map) throws Exception {
		return (int) select("ezNewPortal.getQuickLinkTotalCnt", map);
	}

	// 사용자 사용가능 프레임 리스트
	@SuppressWarnings("unchecked")
	public List<FrameInfoVO> getUserUsableFrameList(Map<String, Object> map) throws Exception {
		return (List<FrameInfoVO>) list("ezNewPortal.getUserUsableFrameList", map);
	}
	
	// 회사가 선택한 테마에서 사용 가능한 프레임 리스트
	@SuppressWarnings("unchecked")
	public List<FrameInfoVO> getCompUsableFrameList(Map<String, Object> map) throws Exception {
		return (List<FrameInfoVO>) list("ezNewPortal.getCompUsableFrameList", map); 
	}
	
	public void updateUserUsedFrame(Map<String, Object> map) throws Exception {
		update("ezNewPortal.updateUserUsedFrame", map);
	}
	
	public void deleteUserUsedPortlet(Map<String, Object> map) throws Exception {
		delete("ezNewPortal.deleteUserUsedPortlet", map);
	}
	
	public void insertUserUsedPortlet(Map<String, Object> map) throws Exception {
		insert("ezNewPortal.insertUserUsedPortlet", map);
	}

	/**
	 * 유은정
	 */
	//투표할 수 있는 리스트 개수 불러오기
	public int getVotePortletCount (Map<String, Object> map) throws Exception {
		return (int) select("ezNewPortal.getVotePortletCount", map);
	}
	
	//투표 정보 가져오기
	public PollQuestionVO getVotePortletInfo (Map<String, Object> map) throws Exception {
		return (PollQuestionVO) select("ezNewPortal.getVotePortletInfo", map);
	}
	
	//투표 답변 조회
	@SuppressWarnings("unchecked")
	public List<PollAnswerVO> getVotePortletAnswer (Map<String, Object> map) throws Exception {
		return (List<PollAnswerVO>) list("ezNewPortal.getVotePortletAnswer", map);
	}
	
	//포토게시판 정보 가져오기
	@SuppressWarnings("unchecked")
	public List<BoardItemVO> getphotoBoardPortletInfo(Map<String, Object> map) throws Exception {
		return (List<BoardItemVO>) list("ezNewPortal.getPhotoBoardPortletInfo", map);
	}
	
	public int getPhotoBoardPortletTotalCnt(Map<String, Object> map) throws Exception {
		return (int) select("ezNewPortal.getPhotoBoardPortletTotalCnt", map);
	}

	//게시판 권한 체크
	public String getBoardAuthCheck(Map<String, Object> map) throws Exception {
		return (String) select("ezNewPortal.getBoardAuthCheck", map);
	}
	
	//포틀릿 정보 가져오기
	public PortletInfoVO getCompanyPortletInfo(Map<String, Object> map) throws Exception {
		return (PortletInfoVO) select("ezNewPortal.getCompanyPortletInfo", map);
	}
	
	//사용자 포탈 설정 가져오기 (테마, 프레임)
	public UserPortalSettingVO getUserPortalSetting(Map<String, Object> map) throws Exception {
		return (UserPortalSettingVO) select("ezNewPortal.getUserPortalSetting", map);
	}

	//사용자 포탈 설정 없을 때 회사 포탈 설정을 사용자 포탈설정으로 가져오기
	public UserPortalSettingVO getCompPortalSetting(Map<String, Object> map) throws Exception {
		return (UserPortalSettingVO) select("ezNewPortal.getCompPortalSetting", map);
	}
	
	public void deletePortletOrderUser(Map<String, Object> map) throws Exception {
		delete("ezNewPortal.deletePortletOrderUser", map);
	}

	public void insertPortletOrderUser(Map<String, Object> map) throws Exception {
		insert("ezNewPortal.insertPortletOrderUser", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<PortalUserInfoVO> getMonthlyBirthdayEmployees(Map<String, Object> map) throws Exception {
		return (List<PortalUserInfoVO>) list("ezNewPortal.getMonthlyBirthdayEmployees", map);
	}
	
	public PortalUserInfoVO getMonthlyBestEmployee(Map<String, Object> map) throws Exception {
		return (PortalUserInfoVO) select("ezNewPortal.getMonthlyBestEmployee", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ThemeInfoVO> getUserThemeList(Map<String, Object> map) throws Exception {
		return (List<ThemeInfoVO>) list("ezNewPortal.getUserThemeList", map);
	}

	public List<ThemeInfoVO> getCompThemeList(Map<String, Object> map) throws Exception {
		return (List<ThemeInfoVO>) list("ezNewPortal.getCompThemeList", map);
	}

	public MenuInfoVO getUserStartPage(Map<String, Object> map) throws Exception {
		return (MenuInfoVO) select("ezNewPortal.getUserStartPage", map);
	}
	
	public void insertUserStartPage(Map<String, Object> map) throws Exception {
		insert("ezNewPortal.insertUserStartPage", map);
	}
	
	public void updateUserStartPage(Map<String, Object> map) throws Exception {
		update("ezNewPortal.updateUserStartPage", map);
	}
	
	public void deleteUserThemeSetting(Map<String, Object> map) throws Exception {
		delete("ezNewPortal.deleteUserThemeSetting", map);
	}
	
	public void updateUserThemeSetting(Map<String, Object> map) throws Exception {
		update("ezNewPortal.updateUserThemeSetting", map);
	}
	
	public void insertUserThemeSetting(Map<String, Object> map) throws Exception {
		insert("ezNewPortal.insertUserThemeSetting", map);
	}
	
	public int getTenantIdByServerName(Map<String, Object> map) throws Exception {
		return (int) select("ezNewPortal.getTenantIdByServerName", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<Integer> getPortletIdsByMenuId (Map<String, Object> map) throws Exception {
		return (List<Integer>) list("ezNewPortal.getPortletIdsByMenuId", map);
	}
	
	public void deleteMenuUser (Map<String, Object> map) throws Exception {
		delete("ezNewPortal.deleteMenuUser", map);
	}
	
	public void deletePortletUser (Map<String, Object> map) throws Exception {
		delete("ezNewPortal.deletePortletUser", map);
	}
	
	public void updateCompanyDefaultTheme (Map<String, Object> map) throws Exception {
		update("ezNewPortal.updateCompanyDefaultTheme", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<BoardListVO> getBoardPortletInfo (Map<String, Object> map) throws Exception {
		return (List<BoardListVO>) list("ezNewPortal.getBoardPortletInfo", map);
	}
	
	public int getBoardPortletTotalCnt (Map<String, Object> map) throws Exception {
		return (int) select("ezNewPortal.getBoardPortletTotalCnt", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<PortletInfoVO> getThemePortletList(Map<String, Object> map) throws Exception {
		return (List<PortletInfoVO>) list("ezNewPortal.getThemePortletList", map);
	}
	
	public void updateThemePortletUsed(Map<String, Object> map) throws Exception {
		update("ezNewPortal.updateThemePortletUsed", map);
	}

	public void updateThemePortlet(Map<String, Object> map) throws Exception {
		update("ezNewPortal.updateThemePortlet", map);
	}

	public void updatePortletOrderUser(Map<String, Object> map) throws Exception {
		update("ezNewPortal.updatePortletOrderUser", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<PortletInfoVO> getPortletListNotSelected (Map<String, Object> map) throws Exception {
		return (List<PortletInfoVO>) list("ezNewPortal.getPortletListNotSelected", map);
	}
	
	public void updateAllThemePortletOrder (Map<String, Object> map) throws Exception {
		update("ezNewPortal.updateAllThemePortletOrder", map);
	}
	
	//테마별, 포틀릿별 권한관리 추가 개발
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getThemeAuth (Map<String, Object> map) throws Exception {
		return (List<Map<String, Object>>) list("ezNewPortal.getThemeAuth", map);
	}
	
	public void deleteThemeAuth (Map<String, Object> map) throws Exception {
		delete("ezNewPortal.deleteThemeAuth", map);
	}
	
	public void insertThemeAuth (Map<String, Object> map) throws Exception {
		insert("ezNewPortal.insertThemeAuth", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ThemeAuthVO> checkThemeAuthNoList (Map<String, Object> map) throws Exception {
		return (List<ThemeAuthVO>) list("ezNewPortal.checkThemeAuthNoList", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getPortletAuth (Map<String, Object> map) throws Exception {
		return (List<Map<String, Object>>) list("ezNewPortal.getPortletAuth", map);
	}
	
	public void deletePortletAuth (Map<String, Object> map) throws Exception {
		delete("ezNewPortal.deletePortletAuth", map);
	}
	
	public void insertPortletAuth (Map<String, Object> map) throws Exception {
		insert("ezNewPortal.insertPortletAuth", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<String> checkThemeAuthInDept (Map<String, Object> map) throws Exception {
		return (List<String>) list("ezNewPortal.checkThemeAuthInDept", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<PortletAuthVO> getPortletAuthUserList (Map<String, Object> map) throws Exception {
		return (List<PortletAuthVO>) list("ezNewPortal.getPortletAuthUserList", map);
	}
	/**
	 * 이효진
	 */
	@SuppressWarnings("unchecked")
	public List<ApprGDocListVO> getApprovalDoingList(Map<String, Object> map) throws Exception {
		return (List<ApprGDocListVO>) list("ezNewPortal.getApprovalDoingList", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ApprGDocListVO> getApprovalDoingLines(Map<String, Object> map) throws Exception {
		return (List<ApprGDocListVO>) list("ezNewPortal.getApprovalDoingLines", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ApprGDocListVO> getApprovalRejectList(Map<String, Object> map) throws Exception {
		return (List<ApprGDocListVO>) list("ezNewPortal.getApprovalRejectList", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ApprGDocListVO> getApprovalDraftList(Map<String, Object> map) throws Exception {
		return (List<ApprGDocListVO>) list("ezNewPortal.getApprovalDraftList", map);
	}
	
	public int getApprovalDoingListCount(Map<String, Object> map) throws Exception {
		return (int) select("ezNewPortal.getApprovalDoingListCount", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ApprGFormVO> getFavoriteForms(Map<String, Object> map) throws Exception {
		return (List<ApprGFormVO>) list("ezNewPortal.getFavoriteForms", map);
	}
	
	@SuppressWarnings("unchecked")
	public Map<String, Object> getApprovalStatistics(Map<String, Object> map) throws Exception {
		return (Map<String, Object>) select("ezNewPortal.getApprovalStatistics", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<PortletInfoVO> getPortletForUser(Map<String, Object> map) throws Exception {
		return (List<PortletInfoVO>) list("ezNewPortal.getPortletForUser", map);
	}
	
	public int getThemeId(Map<String, Object> map) throws Exception {
		return (int) select("ezNewPortal.getThemeId", map);
	}

	@SuppressWarnings("unchecked")
	public List<ThemeInfoVO> getCompanyThemes(Map<String, Object> map) throws Exception {
		return (List<ThemeInfoVO>) list("ezNewPortal.getCompanyThemes", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<FrameInfoVO> getFrames(Map<String, Object> map) throws Exception {
		return (List<FrameInfoVO>) list("ezNewPortal.getFrames", map);
	}
	
	public ThemeInfoVO getThemeInfo(Map<String, Object> map) throws Exception {
		return (ThemeInfoVO) select("ezNewPortal.getThemeInfo", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<MenuInfoVO> getMenus(Map<String, Object> map) throws Exception {
		return (List<MenuInfoVO>) list("ezNewPortal.getMenus", map);
	}
	
	public MenuInfoVO getMenuInfo(Map<String, Object> map) throws Exception {
		return (MenuInfoVO) select("ezNewPortal.getMenuInfo", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<MenuNameVO> getMenuNames(Map<String, Object> map) throws Exception {
		return (List<MenuNameVO>) list("ezNewPortal.getMenuNames", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<MenuAuthVO> getMenuAuth(Map<String, Object> map) throws Exception {
		return (List<MenuAuthVO>) list("ezNewPortal.getMenuAuth", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<MenuInfoVO> getMenuForUser(Map<String, Object> map) throws Exception {
		return (List<MenuInfoVO>) list("ezNewPortal.getMenuForUser", map);
	}
	
	public int insertMenu(Map<String, Object> map) throws Exception {
		return (int) insert("ezNewPortal.insertMenu", map);
	}
	
	public void insertMenuComp(Map<String, Object> map) throws Exception {
		insert("ezNewPortal.insertMenuComp", map);
	}
	
	public void updateThemeInfo(Map<String, Object> map) throws Exception {
		update("ezNewPortal.updateThemeInfo", map);
	}
	
	public void updateFrameInfo(Map<String, Object> map) throws Exception {
		update("ezNewPortal.updateFrameInfo", map);
	}
	
	public void updateCompanyMenuUsed(Map<String, Object> map) throws Exception {
		update("ezNewPortal.updateCompanyMenuUsed", map);
	}
	
	public void updateCompanyMenuInfo(Map<String, Object> map) throws Exception {
		update("ezNewPortal.updateCompanyMenuInfo", map);
	}
	
	public void updateCompanyMenuNameInfo(Map<String, Object> map) throws Exception {
		update("ezNewPortal.updateCompanyMenuNameInfo", map);
 	}
	
	public void updateMenuPortletUsed(Map<String, Object> map) throws Exception {
		update("ezNewPortal.updateMenuPortletUsed", map);
	}
	
	public void updateMenuAuth(Map<String, Object> map) throws Exception {
		update("ezNewPortal.updateMenuAuth", map);
	}
	
	public void updateMenuOrder(Map<String, Object> map) throws Exception {
		update("ezNewPortal.updateMenuOrder", map);
	}
	
	public void deleteMenu(Map<String, Object> map) throws Exception {
		delete("ezNewPortal.deleteMenu", map);
	}
	
	public void deleteMenuComp(Map<String, Object> map) throws Exception {
		delete("ezNewPortal.deleteMenuComp", map);
	}
	
	public void deleteMenuNames(Map<String, Object> map) throws Exception {
		delete("ezNewPortal.deleteMenuNames", map);
	}
	
	public void deleteMenuAuth(Map<String, Object> map) throws Exception {
		delete("ezNewPortal.deleteMenuAuth", map);
	}
	
	public void deleteThemePortlet(Map<String, Object> map) throws Exception {
		delete("ezNewPortal.deleteThemePortlet", map);
	}
	/** -------------------- */
	@SuppressWarnings("unchecked")
	public List<PortalBoardTreeVO> getBoardTree(Map<String, Object> map) throws Exception {
		return (List<PortalBoardTreeVO>) list("ezNewPortal.getBoardTree", map);
	}
	
	public int insertPortlet(Map<String, Object> map) {
		return (int) insert("ezNewPortal.insertPortlet", map); 
	}
	
	public void insertPortletComp(Map<String, Object> map) {
		insert("ezNewPortal.insertPortletComp", map);
	}
	
	public void updateCompanyPortletNameInfo(Map<String, Object> map) {
		update("ezNewPortal.updateCompanyPortletNameInfo", map);
	}
	
	public void updateCompanyPortletInfo(Map<String, Object> map) {
		update("ezNewPortal.updateCompanyPortletInfo", map);
	}
	
	public void updateCompanyPortletInfo2(Map<String, Object> map) {
		update("ezNewPortal.updateCompanyPortletInfo2", map);
	}
	
	public void deletePortletComp (Map<String, Object> map) {
		delete("ezNewPortal.deletePortletComp", map);
	}
	
	public void deletePortlet (Map<String, Object> map) {
		delete("ezNewPortal.deletePortlet", map);
	}
	
	public void updateCompanyPortletOrder (Map<String, Object> map) {
		update("ezNewPortal.updateCompanyPortletOrder", map);
	}
	
	public void deletePortletName (Map<String, Object> map) {
		delete("ezNewPortal.deletePortletName", map);
	}
	
	//회사 로고 업데이트
	public void updateCompanyLogo (Map<String, Object> map) {
		update ("ezNewPortal.updateCompanyLogo", map);
	}
	
	//회사 로고 url 하나 가져오기
	public String getCompanyLogo (Map<String, Object> map) {
		return (String) select ("ezNewPortal.getCompanyLogo", map);
	}
	
	//회사 로고 리스트 가져오기
	@SuppressWarnings("unchecked")
	public List<PortalLogoVO> getCompanyLogoList (Map<String, Object> map) {
		return (List<PortalLogoVO>) list("ezNewPortal.getCompanyLogoList", map);
	}
	
	public void deleteCompanyLogo(Map<String, Object> map) {
		delete("ezNewPortal.deleteCompanyLogo", map);
	}
	
	public void insertCompanyPortletNameInfo(Map<String, Object> map) {
		insert("ezNewPortal.insertCompanyPortletNameInfo", map);
	}
	
	//default 테마가 바뀔 때 사용
	public void updateThemeDefault (Map<String, Object> map) {
		update("ezNewPortal.updateThemeDefault", map);
	}
	
	public void insertMenuAuth (Map<String, Object> map) {
		insert("ezNewPortal.insertMenuAuth", map);
	}
	
	public void updateUserThemeAndFrameDefault(Map<String, Object> map) {
		update("ezNewPortal.updateUserThemeAndFrameDefault", map);
	}
	
	public void updateUserFrameDefault (Map<String, Object> map) {
		update("ezNewPortal.updateUserFrameDefault", map);
	}
	
	/**
	 * 구해안
	 */
	//즐겨찾기 게시판 포틀릿 리스트(새게시물)
	@SuppressWarnings("unchecked")
	public List<FavoriteBoardVO> getFavNewItemList(Map<String, Object> map) {
		return (List<FavoriteBoardVO>) list("ezNewPortal.getNewItemList", map);
	}
	
	public int getFavNewItemListCnt(Map<String, Object> map) {
		return (int) select("ezNewPortal.getNewItemListCnt", map);
	}
	
	//즐겨찾기 게시판 포틀릿 리스트(일반)
	@SuppressWarnings("unchecked")
	public List<FavoriteBoardVO> getFavItemList(Map<String, Object> map) {
		return (List<FavoriteBoardVO>) list("ezNewPortal.getItemList", map);
	}
	
	//커뮤니티 포틀릿 리스트
	@SuppressWarnings("unchecked")
	public List<CommunityMyCommunityVO> getCommunityList(Map<String, Object> map) {
		return (List<CommunityMyCommunityVO>) list("ezNewPortal.getCommunityList", map);
	}
	
	public int getCommunityListTotalCnt(Map<String, Object> map) {
		return (int) select("ezNewPortal.getCommunityListTotalCnt", map);
	}
	
	//ezNewPortal.getCommunityPermit
	public CommunityCClubUserVO getCommunityPermit(Map<String, Object> map) {
		return (CommunityCClubUserVO) select("ezNewPortal.getCommunityPermit", map);
	}
	
	//관리자-포틀릿관리-포틀릿 리스트
	@SuppressWarnings("unchecked")
	public List<PortletInfoVO> getPortletList(Map<String, Object> map) {
		return (List<PortletInfoVO>) list("ezNewPortal.getPortletList", map);
	}
	
	//관리자-포틀릿관리-포틀릿 리스트
	@SuppressWarnings("unchecked")
	public List<PortletNameInfoVO> getPortletNameList(Map<String, Object> map) {
		return (List<PortletNameInfoVO>) list("ezNewPortal.getPortletNameList", map);
	}
	
	//tenant_config 에서 사용하는 모든 primaryLang 리스트 가져오기
	@SuppressWarnings("unchecked")
	public List<String> getPrimaryLangList() {
		return (List<String>) list("ezNewPortal.getPrimaryLangList");
	}

	@SuppressWarnings("unchecked")
	public List<String> getWeatherKeyList(int size) {
		return (List<String>) list("ezNewPortal.getWeatherKeyList", size);
	}
	
	@SuppressWarnings("unchecked")
	public List<String> getCityCodeList(List<String> primaryLangList) {
		// TODO Auto-generated method stub
		return (List<String>) list("ezNewPortal.getCityCodeList", primaryLangList);
	}

	public void setCurrentWeather(Map<String, Object> map) {
		update("ezNewPortal.setCurrentWeather", map);
	}

	public void setTodayWeather(Map<String, Object> map) {
		update("ezNewPortal.setTodayWeather", map);
	}

	@SuppressWarnings("unchecked")
	public Map<String, Object> getWeather(Map<String, Object> map) {
		return (Map<String, Object>) select("ezNewPortal.getWeather", map);
	}

	@SuppressWarnings("unchecked")
	public List<WeatherVO> getCityList(int primaryLang, String countryCode) {
		HashMap<String, String> map = new HashMap() {{
			put("primaryLang", primaryLang);
			put("countryCode", countryCode);
		}};

		return (List<WeatherVO>) list("ezNewPortal.getCityList", map);
	}

	public String getUserCityCode(Map<String, Object> map) {
		return (String) select("ezNewPortal.getUserCityCode", map);
	}

	public void setUserCityCode(Map<String, Object> map) {
		update("ezNewPortal.setUserCityCode", map);
	}
	
	//권한 체크
	public MenuAuthVO getCheckUserAuth(Map<String, Object> map) {
		return (MenuAuthVO) select("ezNewPortal.getCheckUserAuth", map);
	}
	
	public MenuAuthVO getCheckDeptAuth(Map<String, Object> map) {
		return (MenuAuthVO) select("ezNewPortal.getCheckDeptAuth", map);
	}
	
	public MenuAuthVO getCheckcomAuth(Map<String, Object> map) {
		return (MenuAuthVO) select("ezNewPortal.getCheckcomAuth", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<MenuInfoVO> getAllCompanyMenus(Map<String, Object> map) throws Exception {
		return (List<MenuInfoVO>) list("ezNewPortal.getAllCompanyMenus", map);
	}
	
	public String isUseEzWorkspace(Map<String, Object> map) throws Exception {
		return (String) select("ezNewPortal.isUseEzWorkspace", map);
	}

	@SuppressWarnings("unchecked")
	public List<PersonalSliderImageVO> getSilderImages(Map<String, Object> map) {
		return (List<PersonalSliderImageVO>) list("ezNewPortal.getSilderImages", map);
	}

	public void insertSilderImages(Map<String, Object> map) {
		insert("ezNewPortal.insertSilderImages", map);
	}

	public PersonalSliderImageVO getSilderImagInfo(Map<String, Object> map) {
		return (PersonalSliderImageVO) select("ezNewPortal.getSilderImageInfo", map);
	}

	public int getSlideImageMaxSn(Map<String, Object> map) {
		return (int) select("ezNewPortal.getSlideImageMaxSn", map);
	}

	public void updateSilderImage(Map<String, Object> map) {
		update("ezNewPortal.updateSilderImage", map);
	}

	public void deleteSlideImage(Map<String, Object> map) {
		delete("ezNewPortal.deleteSilderImage", map);
	}

	public void updateSlideOrder(Map<String, Object> map) {
		update("ezNewPortal.updateSlideOrder", map);
	}

	@SuppressWarnings("unchecked")
	public List<OrganDeptVO> getInitCompanyList() {
		return (List<OrganDeptVO>) list("ezNewPortal.getInitCompanyList");
	}

	@SuppressWarnings("unchecked")
	public List<FileVO> getWebFolderFileList(Map<String, Object> map) {
		return (List<FileVO>)list("ezNewPortal.getWebFolderFileList", map);
	}

	@SuppressWarnings("unchecked")
	public int getWebFolderFileListTotalCnt(Map<String, Object> map) {
		return (int) select("ezNewPortal.getWebFolderFileListTotalCnt", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<OrganDeptVO> getInitCompanyListThemeAuth() {
		return (List<OrganDeptVO>) list("ezNewPortal.getInitCompanyListThemeAuth");
	}
	
	@SuppressWarnings("unchecked")
	public List<OrganDeptVO> getInitCompanyListPortletAuth() {
		return (List<OrganDeptVO>) list("ezNewPortal.getInitCompanyListPortletAuth");
	}

	public void addPortalTenantConfig(Map<String, Object> map) {
		insert("ezNewPortal.addPortalTenantConfig", map);
	}

	/**
	 * 조직도에 쓸 부서리스트 가져오기
	 * @param map
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public List<DeptViewVO> getDeptViewVO(Map<String, Object> map){
		return (List<DeptViewVO>) list("ezNewPortal.selectDeptList",map);
	}

	/**
	 * 해당부서의 사원 리스트 가져오기
	 * @param map
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public List<MenuAuthorUserVO> getDeptUserList(Map<String, Object> map){
		return (List<MenuAuthorUserVO>) list("ezNewPortal.selectUserList",map);
	}

	public int getDeptUserListCount(Map<String, Object> map) {
		return (int) select("ezNewPortal.getDeptUserListCount", map);
	}

	@SuppressWarnings("unchecked")
	public List<String> getAllAvailablePortletSize() {
		return (List<String>) list("ezNewPortal.getAllAvailablePortletSize");
	}

	// 사용 설정된 포틀릿 사이즈 리스트
	@SuppressWarnings("unchecked")
	public List<PortletInfoVO> getAvailablePortletSize(Map<String, Object> map) {
		return (List<PortletInfoVO>) list("ezNewPortal.getAvailablePortletSize", map);
	}

	// 회사 포틀릿 사이즈 삭제
	public void clearPortletSize(Map<String, Object> map) {
		delete("ezNewPortal.clearPortletSize", map);
	}

	public void insertPortletSizeCompany(List<Map<String, Object>> list) {
		insert("ezNewPortal.insertPortletSizeCompany", list);
	}

	// 사용자 포틀릿 사이즈 삭제
	public void clearPortletSizeUser(Map<String, Object> map) {
		delete("ezNewPortal.clearPortletSizeUser", map);
	}

	public void insertPortletSizeUser(List<Map<String, Object>> list) {
		insert("ezNewPortal.insertPortletSizeUser", list);
	}

	public void updatePortalTopFrameInfo(PortalTopVO vo)  throws Exception {
		insert("ezNewPortal.insertPortalTopFrameInfo", vo);
	}

	public PortalTopVO getUserMenuDisplayMode(PortalTopVO vo) throws Exception {
		return (PortalTopVO) select("ezNewPortal.getUserMenuDisplayMode", vo);
	}
	
	@SuppressWarnings("unchecked")
	public List<BoardListVO> getNewBoardPortletInfo(Map<String, Object> map) throws Exception {
		return (List<BoardListVO>) list("ezNewPortal.getNewBoardPortletInfo", map);
	}
	
	// 2024-05-17 한태훈 - 포탈 > 포탈 탑 메뉴 위치 설정 기본 데이터 추가 되어있지 않은 회사 목록 가져오는 메소드
	@SuppressWarnings("unchecked")
	public List<OrganDeptVO> getInitCompanyListForTopMenu() {
		return (List<OrganDeptVO>) list("ezNewPortal.getInitCompanyListForTopMenu");
	}

	// 2024-05-17 한태훈 - 포탈 > 포탈 탑 메뉴 위치 회사 설정값 가져오는 메소드
	public PortalTopVO getTopMenuDisplayModeForCompany(PortalTopVO potalTopVO) throws Exception {
		return (PortalTopVO) select("ezNewPortal.getTopMenuDisplayModeForCompany", potalTopVO);
	}
	
	// 2024-05-17 한태훈 - 포탈 > 포탈 탑 메뉴 위치 회사 설정값 수정하는 메소드
	public void updateTopMenuDisplayModeForCompany(PortalTopVO potalTopVO) throws Exception {
		update("ezNewPortal.updateTopMenuDisplayModeForCompany", potalTopVO);
	}
	
	// 2024-05-17 한태훈 > 회사 탑메뉴 설정 위치 기본값 세팅 (기본값 : 0 = 메뉴 위치 상단)
	public void insertTopMenuDisplayModeForCompany(PortalTopVO potalTopVO) throws Exception {
		insert("ezNewPortal.insertTopMenuDisplayModeForCompany", potalTopVO);
	}

	public int getFavItemListCnt(Map<String, Object> map) throws Exception {
		return (int) select("ezNewPortal.getFavItemListCnt", map);
	}
	
	// 2024-07-02 조수빈 - 공람 / 회람 포틀릿 목록 반환
	@SuppressWarnings("unchecked")
	public List<ApprGDocListVO> getApprovalDisplayList(Map<String, Object> map) throws Exception {
		return (List<ApprGDocListVO>) list("ezNewPortal.getApprovalDisplayList", map);
	}

	public SystemConfigVO getSystemConfig(Map<String, Object> map) {
		return (SystemConfigVO) select("ezNewPortal.getSystemConfig", map);
	}
	
	// 2024-08-21 조수빈 - 유저 사용 색상(모드) 조회
	public int getUserColor(PortalTopVO potalTopVO) throws Exception {
		return (null != select("ezNewPortal.getUserColor", potalTopVO)) ? (int) select("ezNewPortal.getUserColor", potalTopVO) : 0;
	}

	// 2024-08-21 조수빈 - 유저 사용 색상(모드) 조회
	public void setUserColorMode(Map<String, Object> map) {
		update("ezNewPortal.setUserColorMode", map);
	}

	public int getResportletId() throws Exception {
		return (int) select("ezNewPortal.getResportletId");
	}
	

	public String getCountryCode(String userID, int tenantID) throws Exception {
		HashMap<String, String> map = new HashMap() {{
			put("userID", userID);
			put("tenantID", tenantID);
		}};

		return (String)select("ezNewPortal.getCountryCode", map);
	}

	public String getUserLocalLang(String userID, int tenantID) throws Exception {
		HashMap<String, String> map = new HashMap() {{
			put("userID", userID);
			put("tenantID", tenantID);
		}};

		return (String)select("ezNewPortal.getUserLocalLang", map);
	}

	public String getFirstCityCode(String countryCode) throws Exception {
		return (String)select("ezNewPortal.getFirstCityCode", countryCode);
	}
}
