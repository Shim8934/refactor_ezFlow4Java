package egovframework.ezEKP.ezNewPortal.service;

import java.util.List;

import egovframework.ezEKP.ezApprovalG.vo.ApprGFormVO;
import egovframework.ezEKP.ezBoard.vo.BoardItemVO;
import egovframework.ezEKP.ezBoard.vo.BoardListVO;
import egovframework.ezEKP.ezNewPortal.vo.FavoriteBoardVO;
import egovframework.ezEKP.ezNewPortal.vo.PortletInfoVO;
import egovframework.ezEKP.ezPoll.vo.PollAnswerVO;
import egovframework.ezEKP.ezPoll.vo.PollQuestionVO;

public interface EzNewPortalService {

	public List<BoardListVO> getNoticePortletList(String companyId, int tenantId, int limit) throws Exception;
	public int getVotePortletCount(String userId, String companyId, String deptPath, int tenantId);
	public PollQuestionVO getVotePortletInfo(String userId, String companyId, String deptPath, int tenantId);
	public List<PollAnswerVO> getVotePortletAnswer(int qstId, int tenantId);
	public List<BoardItemVO> getPhotoBoardPortletInfo(int tenantId, String boardId, int startRow, int photoCount);
	public PortletInfoVO getCompanyPortletInfo(String companyId, int tenantId, int portletId, String portletLang);
	public String getBoardAuthCheck(String boardId, String accessId, int tenantId, String companyId);
	public List<PortletInfoVO> getPortletOrderUser(String portletLang, String userId, int tenantId, String companyId);
	public List<PortletInfoVO> getPortletOrderComp(String portletLang, int tenantId, String companyId);
	
	/**
	 * 이효진
	 */
	
	public List<ApprGFormVO> getFavoriteForms(String userId, String companyId, int tenantId) throws Exception;
	/** -------------------- */
	
	public List<FavoriteBoardVO> getFavNewItemList(String userId, int tenantId, String companyId, String nowDate);
	public List<FavoriteBoardVO> getFavItemList(String boardId, int tenantId, String companyId, int limit);
}
