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
	
	// 사용자 메뉴 순서 변경
	public void updateUserMenuOrder(Map<String, Object> map) throws Exception {
		update("ezNewPortal.updateUserMenuOrder", map);
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
	
	public void updatePortletOrderUser(Map<String, Object> map) {
		update("ezNewPortal.updatePortletOrderUser", map);
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
	public List<MenuAuthVO> getMenuAuth(Map<String, Object> map) throws Exception {
		return (List<MenuAuthVO>) list("ezNewPortal.getMenuAuth", map);
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
	/** -------------------- */
	
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
