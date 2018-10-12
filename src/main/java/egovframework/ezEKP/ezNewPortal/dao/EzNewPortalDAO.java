package egovframework.ezEKP.ezNewPortal.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.ezEKP.ezApprovalG.vo.ApprGDocListVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGFormVO;
import egovframework.ezEKP.ezBoard.vo.BoardItemVO;
import egovframework.ezEKP.ezBoard.vo.BoardListVO;
import egovframework.ezEKP.ezNewPortal.vo.FavoriteBoardVO;
import egovframework.ezEKP.ezNewPortal.vo.PortletInfoVO;
import egovframework.ezEKP.ezNewPortal.vo.UserPortalSettingVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalLightPollVO;
import egovframework.ezEKP.ezPoll.vo.PollAnswerVO;
import egovframework.ezEKP.ezPoll.vo.PollQuestionVO;
import egovframework.rte.psl.dataaccess.EgovAbstractDAO;

@Repository("EzNewPortalDAO")
public class EzNewPortalDAO extends EgovAbstractDAO {
	// 공지사항 리스트
	@SuppressWarnings("unchecked")
	public List<BoardListVO> getNoticePortletList (Map<String, Object> map) throws Exception {
		return (List<BoardListVO>) list("ezNewPortal.getNoticePortletList", map);
	}
	
	// 설문조사 리스트
	@SuppressWarnings("unchecked")
	public List<PersonalLightPollVO> getPollPortletList (Map<String, Object> map) throws Exception {
		return (List<PersonalLightPollVO>) list("ezNewPortal.getPollPortletList", map);
	}

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
	
	public Map<String, Object> getApprovalStatistics(Map<String, Object> map) throws Exception {
		return (Map<String, Object>) select("ezNewPortal.getApprovalStatistics", map);
	}
	/** -------------------- */
	
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
}
