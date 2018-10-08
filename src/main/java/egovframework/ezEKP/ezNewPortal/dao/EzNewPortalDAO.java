package egovframework.ezEKP.ezNewPortal.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.ezEKP.ezBoard.vo.BoardItemVO;
import egovframework.ezEKP.ezBoard.vo.BoardListVO;
import egovframework.ezEKP.ezPoll.vo.PollAnswerVO;
import egovframework.ezEKP.ezPoll.vo.PollQuestionVO;
import egovframework.rte.psl.dataaccess.EgovAbstractDAO;

@Repository("EzNewPortalDAO")
public class EzNewPortalDAO extends EgovAbstractDAO {
	
	@SuppressWarnings("unchecked")
	public List<BoardListVO> getNoticePortletList (Map<String, Object> map) throws Exception {
		return (List<BoardListVO>) list("ezNewPortal.getNoticePortletList", map);
	}

	public int getVotePortletCount (Map<String, Object> map) {
		return (int) select("ezNewPortal.getVotePortletCount", map);
	}
	
	public PollQuestionVO getVotePortletInfo (Map<String, Object> map) {
		return (PollQuestionVO) select("ezNewPortal.getVotePortletInfo", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<PollAnswerVO> getVotePortletAnswer (Map<String, Object> map) {
		return (List<PollAnswerVO>) list("ezNewPortal.getVotePortletAnswer", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<BoardItemVO> getphotoBoardPortletInfo(Map<String, Object> map) {
		return (List<BoardItemVO>) list("ezNewPortal.getPhotoBoardPortletInfo", map);
	}

	public String getBoardAuthCheck(Map<String, Object> map) {
		return (String) select("ezNewPortal.getBoardAuthCheck", map);
	}
}
