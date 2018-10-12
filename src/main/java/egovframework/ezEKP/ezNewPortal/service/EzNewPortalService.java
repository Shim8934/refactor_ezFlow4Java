package egovframework.ezEKP.ezNewPortal.service;

import java.util.List;
import java.util.Map;

import egovframework.ezEKP.ezApprovalG.vo.ApprGFormVO;
import egovframework.ezEKP.ezBoard.vo.BoardItemVO;
import egovframework.ezEKP.ezBoard.vo.BoardListVO;
import egovframework.ezEKP.ezNewPortal.vo.FavoriteBoardVO;
import egovframework.ezEKP.ezNewPortal.vo.PortletInfoVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalLightPollVO;
import egovframework.ezEKP.ezNewPortal.vo.UserPortalSettingVO;
import egovframework.ezEKP.ezPoll.vo.PollAnswerVO;
import egovframework.ezEKP.ezPoll.vo.PollQuestionVO;

public interface EzNewPortalService {

	/**
	 * 박종균
	 * */
	public List<BoardListVO> getNoticePortletList(String companyId, int tenantId, int limit) throws Exception;
	public List<PersonalLightPollVO> getPollPortletList(String companyId, int tenantId) throws Exception;
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
	/**
	 * 이효진
	 */
	
	public List<ApprGFormVO> getFavoriteForms(String userId, String companyId, int tenantId) throws Exception;
	public Map<String, Object> getApprovalStatistics(String userId, String companyId, int tenantId) throws Exception;
	/** -------------------- */
	
	public List<FavoriteBoardVO> getFavNewItemList(String userId, int tenantId, String companyId, String nowDate, int limit);
	public List<FavoriteBoardVO> getFavItemList(String boardId, int tenantId, String companyId, int limit);
}
