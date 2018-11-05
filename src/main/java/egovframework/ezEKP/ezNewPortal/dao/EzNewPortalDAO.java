package egovframework.ezEKP.ezNewPortal.dao;

import java.util.List;
import java.util.Map;

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
import egovframework.ezEKP.ezNewPortal.vo.PortalUserInfoVO;
import egovframework.ezEKP.ezNewPortal.vo.PortletInfoVO;
import egovframework.ezEKP.ezNewPortal.vo.PortletNameInfoVO;
import egovframework.ezEKP.ezNewPortal.vo.ThemeInfoVO;
import egovframework.ezEKP.ezNewPortal.vo.UserPortalSettingVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalLightPollVO;
import egovframework.ezEKP.ezPoll.vo.PollAnswerVO;
import egovframework.ezEKP.ezPoll.vo.PollQuestionVO;
import egovframework.rte.psl.dataaccess.EgovAbstractDAO;

@Repository("EzNewPortalDAO")
public class EzNewPortalDAO extends EgovAbstractDAO {
	
	/* 박종균 시작 */
	
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
	
	@SuppressWarnings("unchecked")
	public List<MenuInfoVO> getUserMenuList(Map<String, Object> map) throws Exception {
		return (List<MenuInfoVO>) list("ezNewPortal.getUserMenuList", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<MenuInfoVO> getCompanyMenuList(Map<String, Object> map) throws Exception {
		return (List<MenuInfoVO>) list("ezNewPortal.getCompanyMenuList", map);
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
	
	// 퀵 링크 불러오기
	public List<?> getQuickLinkList(Map<String, Object> map) throws Exception {
		return (List<?>) list("ezNewPortal.getQuickLinkList", map);
	}
	
	// 퀵 링크 전체 개수 불러오기
	public int getQuickLinkTotalCnt(Map<String, Object> map) throws Exception {
		return (int) select("ezNewPortal.getQuickLinkTotalCnt", map);
	}

	// 사용자가 볼수 있는 회사 포틀릿
	@SuppressWarnings("unchecked")
	public List<PortletInfoVO> getPortletOrderCompForUser(Map<String, Object> map) throws Exception {
		return (List<PortletInfoVO>) list("ezNewPortal.getPortletOrderCompForUser", map);
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
	
	/* 박종균 끝 */
	
	/**
	 * 유은정
	 */
	//투표할 수 있는 리스트 개수 불러오기
	public int getVotePortletCount (Map<String, Object> map) {
		return (int) select("ezNewPortal.getVotePortletCount", map);
	}
	
	//투표 정보 가져오기
	public PollQuestionVO getVotePortletInfo (Map<String, Object> map) {
		return (PollQuestionVO) select("ezNewPortal.getVotePortletInfo", map);
	}
	
	//투표 답변 조회
	@SuppressWarnings("unchecked")
	public List<PollAnswerVO> getVotePortletAnswer (Map<String, Object> map) {
		return (List<PollAnswerVO>) list("ezNewPortal.getVotePortletAnswer", map);
	}
	
	//포토게시판 정보 가져오기
	@SuppressWarnings("unchecked")
	public List<BoardItemVO> getphotoBoardPortletInfo(Map<String, Object> map) {
		return (List<BoardItemVO>) list("ezNewPortal.getPhotoBoardPortletInfo", map);
	}

	//게시판 권한 체크
	public String getBoardAuthCheck(Map<String, Object> map) {
		return (String) select("ezNewPortal.getBoardAuthCheck", map);
	}
	
	//사용자 포틀릿 순서 가져오기
	@SuppressWarnings("unchecked")
	public List<PortletInfoVO> getPortletOrderUser(Map<String, Object> map) {
		return (List<PortletInfoVO>) list("ezNewPortal.getPortletOrderUser", map);
	}
	
	//회사 포틀릿 순서 가져오기
	@SuppressWarnings("unchecked")
	public List<PortletInfoVO> getPortletOrderComp(Map<String, Object> map) {
		return (List<PortletInfoVO>) list("ezNewPortal.getPortletOrderComp", map);
	}

	//포틀릿 정보 가져오기
	public PortletInfoVO getCompanyPortletInfo(Map<String, Object> map) {
		return (PortletInfoVO) select("ezNewPortal.getCompanyPortletInfo", map);
	}
	
	//사용자 포탈 설정 가져오기 (테마, 프레임)
	public UserPortalSettingVO getUserPortalSetting(Map<String, Object> map) {
		return (UserPortalSettingVO) select("ezNewPortal.getUserPortalSetting", map);
	}

	//사용자 포탈 설정 없을 때 회사 포탈 설정을 사용자 포탈설정으로 가져오기
	public UserPortalSettingVO getCompPortalSetting(Map<String, Object> map) {
		return (UserPortalSettingVO) select("ezNewPortal.getCompPortalSetting", map);
	}
	
	public void deletePortletOrderUser(Map<String, Object> map) {
		delete("ezNewPortal.deletePortletOrderUser", map);
	}

	public void insertPortletOrderUser(Map<String, Object> map) {
		insert("ezNewPortal.insertPortletOrderUser", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<PortalUserInfoVO> getMonthlyBirthdayEmployees(Map<String, Object> map) {
		return (List<PortalUserInfoVO>) list("ezNewPortal.getMonthlyBirthdayEmployees", map);
	}
	
	public PortalUserInfoVO getMonthlyBestEmployee(Map<String, Object> map) {
		return (PortalUserInfoVO) select("ezNewPortal.getMonthlyBestEmployee", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ThemeInfoVO> getUserThemeList(Map<String, Object> map) {
		return (List<ThemeInfoVO>) list("ezNewPortal.getUserThemeList", map);
	}
	
	public MenuInfoVO getUserStartPage(Map<String, Object> map) {
		return (MenuInfoVO) select("ezNewPortal.getUserStartPage", map);
	}
	
	public void insertUserStartPage(Map<String, Object> map) {
		insert("ezNewPortal.insertUserStartPage", map);
	}
	
	public void updateUserStartPage(Map<String, Object> map) {
		update("ezNewPortal.updateUserStartPage", map);
	}
	
	public void deleteUserThemeSetting(Map<String, Object> map) {
		delete("ezNewPortal.deleteUserThemeSetting", map);
	}
	
	public void updateUserThemeSetting(Map<String, Object> map) {
		update("ezNewPortal.updateUserThemeSetting", map);
	}
	
	public void insertUserThemeSetting(Map<String, Object> map) {
		insert("ezNewPortal.insertUserThemeSetting", map);
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
	
	@SuppressWarnings("unchecked")
	public List<ApprGFormVO> getFavoriteForms(Map<String, Object> map) throws Exception {
		return (List<ApprGFormVO>) list("ezNewPortal.getFavoriteForms", map);
	}
	
	@SuppressWarnings("unchecked")
	public Map<String, Object> getApprovalStatistics(Map<String, Object> map) throws Exception {
		return (Map<String, Object>) select("ezNewPortal.getApprovalStatistics", map);
	}
	
	//여기서부터 관리잔데 걍 다만들고 dao옮기자
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
		insert("ezNewPortal.updateCompanyPortletNameInfo", map);
	}
	
	public void updateCompanyPortletInfo(Map<String, Object> map) {
		update("ezNewPortal.updateCompanyPortletInfo", map);
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
	/**
	 * 구해안
	 */
	//즐겨찾기 게시판 포틀릿 리스트(새게시물)
	@SuppressWarnings("unchecked")
	public List<FavoriteBoardVO> getFavNewItemList(Map<String, Object> map) {
		return (List<FavoriteBoardVO>) list("ezNewPortal.getNewItemList", map);
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
}
