package egovframework.ezEKP.ezNewPortal.service;

import java.util.List;

import egovframework.ezEKP.ezBoard.vo.BoardItemVO;
import egovframework.ezEKP.ezNewPortal.vo.PortletInfoVO;
import egovframework.ezEKP.ezPoll.vo.PollAnswerVO;
import egovframework.ezEKP.ezPoll.vo.PollQuestionVO;

public interface EzNewPortalService {

	public int getVotePortletCount(String userId, String companyId, String deptPath, int tenantId);
	public PollQuestionVO getVotePortletInfo(String userId, String companyId, String deptPath, int tenantId);
	public List<PollAnswerVO> getVotePortletAnswer(int qstId, int tenantId);
	public List<BoardItemVO> getPhotoBoardPortletInfo(int tenantId, String boardId, int startRow, int photoCount);
	public PortletInfoVO getCompanyPortletInfo(String companyId, int tenantId, int portletId, String portletLang);
	public String getBoardAuthCheck(String boardId, String accessId, int tenantId, String companyId);
	public List<PortletInfoVO> getPortletOrderUser(String portletLang, String userId, int tenantId, String companyId);
	public List<PortletInfoVO> getPortletOrderComp(String portletLang, int tenantId, String companyId);
}
