package egovframework.ezEKP.ezNewPortal.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.ezEKP.ezBoard.vo.BoardItemVO;
import egovframework.ezEKP.ezNewPortal.vo.PortletInfoVO;
import egovframework.ezEKP.ezBoard.vo.BoardListVO;
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
}
