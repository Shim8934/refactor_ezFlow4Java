package egovframework.ezEKP.ezNewPortal.service;

import java.util.List;

import egovframework.ezEKP.ezPoll.vo.PollAnswerVO;
import egovframework.ezEKP.ezPoll.vo.PollQuestionVO;

public interface EzNewPortalService {

	public int getVotePortletCount(String userId, String companyId, String deptPath, int tenantId);
	public PollQuestionVO getVotePortletInfo(String userId, String companyId, String deptPath, int tenantId);
	public List<PollAnswerVO> getVotePortletAnswer(int qstId, int tenantId);
}
