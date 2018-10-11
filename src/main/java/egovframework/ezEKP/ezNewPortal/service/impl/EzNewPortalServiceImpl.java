package egovframework.ezEKP.ezNewPortal.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import egovframework.ezEKP.ezApprovalG.vo.ApprGFormVO;
import egovframework.ezEKP.ezBoard.vo.BoardItemVO;
import egovframework.ezEKP.ezBoard.vo.BoardListVO;
import egovframework.ezEKP.ezNewPortal.dao.EzNewPortalDAO;
import egovframework.ezEKP.ezNewPortal.service.EzNewPortalService;
import egovframework.ezEKP.ezNewPortal.vo.PortletInfoVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalLightPollVO;
import egovframework.ezEKP.ezNewPortal.vo.UserPortalSettingVO;
import egovframework.ezEKP.ezPoll.vo.PollAnswerVO;
import egovframework.ezEKP.ezPoll.vo.PollQuestionVO;

@Service("EzNewPortalService")
public class EzNewPortalServiceImpl implements EzNewPortalService {
	private static final Logger LOGGER = LoggerFactory.getLogger(EzNewPortalServiceImpl.class);
	
	@Resource(name = "EzNewPortalDAO")
	private EzNewPortalDAO ezNewPortalDAO;
	
	public List<BoardListVO> getNoticePortletList(String companyId, int tenantId, int limit) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		map.put("limit", limit);
		map.put("portletId", 2); // 공지사항 포틀릿 ID 는 2
		
		return ezNewPortalDAO.getNoticePortletList(map);
	}
	
	public List<PersonalLightPollVO> getPollPortletList(String companyId, int tenantId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		
		return ezNewPortalDAO.getPollPortletList(map);
	}
	
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
	public PortletInfoVO getCompanyPortletInfo(String companyId, int tenantId, int portletId, String portletLang) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		map.put("portletId", portletId);
		map.put("portletLang", portletLang);
		
		return ezNewPortalDAO.getCompanyPortletInfo(map);
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

	@Override
	public List<PortletInfoVO> getPortletOrderUser(String portletLang, String userId, int tenantId, String companyId) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("portletLang", portletLang);
		map.put("userId", userId);
		map.put("tenantId", tenantId);
		map.put("companyId", companyId);
		
		return ezNewPortalDAO.getPortletOrderUser(map);
	}

	@Override
	public List<PortletInfoVO> getPortletOrderComp(String portletLang, int tenantId, String companyId) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("portletLang", portletLang);
		map.put("tenantId", tenantId);
		map.put("companyId", companyId);
		
		return ezNewPortalDAO.getPortletOrderComp(map);
	}
	

	@SuppressWarnings("null")
	@Override
	public UserPortalSettingVO getUserPortalSetting(String userId, String companyId, int tenantId) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userId", userId);
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		
		UserPortalSettingVO userPortalSetting = ezNewPortalDAO.getUserPortalSetting(map);
		
		if (userPortalSetting == null) {
			userPortalSetting = ezNewPortalDAO.getCompPortalSetting(map);
			
			if (userPortalSetting == null) {
				userPortalSetting.setUsedFrame(1);
				userPortalSetting.setUsedTheme(1);
			}
		}
		
		return userPortalSetting;
	}
	
	/**
	 * 이효진
	 */
	@Override
	public List<ApprGFormVO> getFavoriteForms(String userId, String companyId, int tenantId) throws Exception {
		LOGGER.debug("getFavoriteForms started.");
		LOGGER.debug("userId = " + userId + " || companyId = " + companyId + " || tenantId = " + tenantId);		
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userId", userId);
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		
		List<ApprGFormVO> list = ezNewPortalDAO.getFavoriteForms(map);
		
		LOGGER.debug("getFavoriteForms ended.");
		
		return list;
	}
	/** -------------------- */

}
