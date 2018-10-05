package egovframework.ezEKP.ezNewPortal.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import egovframework.ezEKP.ezBoard.vo.BoardItemVO;
import egovframework.ezEKP.ezNewPortal.dao.EzNewPortalDAO;
import egovframework.ezEKP.ezNewPortal.service.EzNewPortalService;
import egovframework.ezEKP.ezNewPortal.vo.PortletInfoVO;
import egovframework.ezEKP.ezPoll.vo.PollAnswerVO;
import egovframework.ezEKP.ezPoll.vo.PollQuestionVO;

@Service("EzNewPortalService")
public class EzNewPortalServiceImpl implements EzNewPortalService {
	@Resource(name = "EzNewPortalDAO")
	private EzNewPortalDAO ezNewPortalDAO;
	
	@Override
	public int getVotePortletCount(String userId, String companyId, String deptPath, int tenantId) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userId", userId);
		map.put("companyId", companyId);
		map.put("deptPath", deptPath);
		map.put("tenantId", tenantId);
		
		return ezNewPortalDAO.getVotePortletCount(map);
	}

	@Override
	public PollQuestionVO getVotePortletInfo(String userId, String companyId, String deptPath, int tenantId) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userId", userId);
		map.put("companyId", companyId);
		map.put("deptPath", deptPath);
		map.put("tenantId", tenantId);
		
		return ezNewPortalDAO.getVotePortletInfo(map);
	}

	@Override
	public List<PollAnswerVO> getVotePortletAnswer(int qstId, int tenantId) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("qstId", qstId);
		map.put("tenantId", tenantId);
		
		return ezNewPortalDAO.getVotePortletAnswer(map);
	}

	@Override
	public List<BoardItemVO> getPhotoBoardPortletInfo(int tenantId, String boardId, int startRow, int photoCount) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("tenantId", tenantId);
		map.put("boardId", boardId);
		map.put("startRow", startRow);
		map.put("photoCount", photoCount);
		
		return ezNewPortalDAO.getphotoBoardPortletInfo(map);
	}

	@Override
	public PortletInfoVO getCompanyPortletInfo(String companyId, int tenantId, int portletId) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		map.put("portletId", portletId);
		
		return null;
	}

	@Override
	public String getBoardAuthCheck(String boardId, String accessId, int tenantId, String companyId) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		map.put("boardId", boardId);
		map.put("accessId", accessId);
		
		return ezNewPortalDAO.getBoardAuthCheck(map);
	}

}
