package egovframework.ezEKP.ezNewPortal.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import egovframework.ezEKP.ezApprovalG.vo.ApprGDocListVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGFormVO;
import egovframework.ezEKP.ezBoard.vo.BoardItemVO;
import egovframework.ezEKP.ezBoard.vo.BoardListVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityCClubUserVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityMyCommunityVO;
import egovframework.ezEKP.ezNewPortal.dao.EzNewPortalDAO;
import egovframework.ezEKP.ezNewPortal.service.EzNewPortalService;
import egovframework.ezEKP.ezNewPortal.vo.FavoriteBoardVO;
import egovframework.ezEKP.ezNewPortal.vo.PortletInfoVO;
import egovframework.ezEKP.ezNewPortal.vo.UserPortalSettingVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalLightPollVO;
import egovframework.ezEKP.ezPoll.vo.PollAnswerVO;
import egovframework.ezEKP.ezPoll.vo.PollQuestionVO;
import egovframework.let.utl.fcc.service.CommonUtil;

@Service("EzNewPortalService")
public class EzNewPortalServiceImpl implements EzNewPortalService {
	private static final Logger LOGGER = LoggerFactory.getLogger(EzNewPortalServiceImpl.class);
	
	@Resource(name = "EzNewPortalDAO")
	private EzNewPortalDAO ezNewPortalDAO;
	
	@Autowired
	private CommonUtil commonUtil;
	
	public List<BoardListVO> getNoticePortletList(String companyId, int tenantId, int limit) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		map.put("limit", limit);
		map.put("portletId", 2); // 공지사항 포틀릿 ID 는 2
		
		return ezNewPortalDAO.getNoticePortletList(map);
	}
	@Override
	public PersonalLightPollVO getPollPortlet(String companyId, int tenantId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		
		return ezNewPortalDAO.getPollPortlet(map);
	}
	
	@Override
	public int getVotePortletCount(String userId, String companyId, String deptPath, int tenantId) {
		LOGGER.debug("[Serivce] getVotePortletCount Started");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userId", userId);
		map.put("companyId", companyId);
		map.put("deptPath", deptPath);
		map.put("tenantId", tenantId);
		
		LOGGER.debug("[Serivce] getVotePortletCount Ended");
		return ezNewPortalDAO.getVotePortletCount(map);
	}

	@Override
	public PollQuestionVO getVotePortletInfo(String userId, String companyId, String deptPath, int tenantId) {
		LOGGER.debug("[Serivce] getVotePortletInfo Started");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userId", userId);
		map.put("companyId", companyId);
		map.put("deptPath", deptPath);
		map.put("tenantId", tenantId);
		
		LOGGER.debug("[Serivce] getVotePortletInfo Ended");
		return ezNewPortalDAO.getVotePortletInfo(map);
	}

	@Override
	public List<PollAnswerVO> getVotePortletAnswer(int qstId, int tenantId) {
		LOGGER.debug("[Serivce] getVotePortletAnswer Started");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("qstId", qstId);
		map.put("tenantId", tenantId);

		LOGGER.debug("[Serivce] getVotePortletAnswer Ended");
		return ezNewPortalDAO.getVotePortletAnswer(map);
	}

	@Override
	public List<BoardItemVO> getPhotoBoardPortletInfo(int tenantId, String boardId, int startRow, int photoCount) {
		LOGGER.debug("[Serivce] getPhotoBoardPortletInfo Started");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("tenantId", tenantId);
		map.put("boardId", boardId);
		map.put("startRow", startRow);
		map.put("photoCount", photoCount);

		LOGGER.debug("[Serivce] getPhotoBoardPortletInfo Ended");
		return ezNewPortalDAO.getphotoBoardPortletInfo(map);
	}

	@Override
	public PortletInfoVO getCompanyPortletInfo(String companyId, int tenantId, int portletId, String portletLang) {
		LOGGER.debug("[Serivce] getCompanyPortletInfo Started");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		map.put("portletId", portletId);
		map.put("portletLang", portletLang);

		LOGGER.debug("[Serivce] getCompanyPortletInfo Ended");
		return ezNewPortalDAO.getCompanyPortletInfo(map);
	}

	@Override
	public String getBoardAuthCheck(String boardId, String accessId, int tenantId, String companyId) {
		LOGGER.debug("[Serivce] getBoardAuthCheck Started");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		map.put("boardId", boardId);
		map.put("accessId", accessId);

		LOGGER.debug("[Serivce] getBoardAuthCheck Ended");
		return ezNewPortalDAO.getBoardAuthCheck(map);
	}

	@Override
	public List<PortletInfoVO> getPortletOrderUser(String portletLang, String userId, int tenantId, String companyId) {
		LOGGER.debug("[Serivce] getPortletOrderUser Started");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("portletLang", portletLang);
		map.put("userId", userId);
		map.put("tenantId", tenantId);
		map.put("companyId", companyId);

		LOGGER.debug("[Serivce] getPortletOrderUser Ended");
		return ezNewPortalDAO.getPortletOrderUser(map);
	}

	@Override
	public List<PortletInfoVO> getPortletOrderComp(String portletLang, int tenantId, String companyId) {
		LOGGER.debug("[Serivce] getPortletOrderComp Started");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("portletLang", portletLang);
		map.put("tenantId", tenantId);
		map.put("companyId", companyId);
		
		List<PortletInfoVO> portletOrderComp = ezNewPortalDAO.getPortletOrderComp(map);
		
		if (portletOrderComp == null || portletOrderComp.size() == 0) {
			map.put("order", "default");
			portletOrderComp = ezNewPortalDAO.getPortletOrderComp(map);
		}

		LOGGER.debug("[Serivce] getPortletOrderComp Ended");
		return portletOrderComp;
	}
	

	@SuppressWarnings("null")
	@Override
	public UserPortalSettingVO getUserPortalSetting(String userId, String companyId, int tenantId) {
		LOGGER.debug("[Serivce] getUserPortalSetting Started");
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

		LOGGER.debug("[Serivce] getUserPortalSetting Ended");
		return userPortalSetting;
	}
	
	@Override
	public void updatePortletOrderUser(String userId, String companyId, int tenantId,
			List<Map<String, Integer>> portletOrder, String portletLang) {
		LOGGER.debug("updatePortletOrderUser started.");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userId", userId);
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		map.put("portletLang", portletLang);

		int portletOrderCount = portletOrder.size();
		
		//portletOrder를 사용자가 설정한 정보가 있는지 확인
		List<PortletInfoVO> userPortletOrder = ezNewPortalDAO.getPortletOrderUser(map);

		if (userPortletOrder == null || userPortletOrder.isEmpty()) {//없으면 insert
			for (int i = 0; i < portletOrderCount; i++) {
				map.put("portletOrder", portletOrder.get(i).get("portletOrder"));
				map.put("portletId", portletOrder.get(i).get("portletId"));
				ezNewPortalDAO.insertPortletOrderUser(map);
			}
			
		} else {//있으면 update
			for (int i = 0; i < portletOrderCount; i++) {
				map.put("portletOrder", portletOrder.get(i).get("portletOrder"));
				map.put("portletId", portletOrder.get(i).get("portletId"));
				ezNewPortalDAO.updatePortletOrderUser(map);
			}
		}
		
		LOGGER.debug("updatePortletOrderUser ended.");
	}
	
	/**
	 * 이효진
	 */
	@Override
	public Map<String, Object> getApprovalList(String userId, String companyId, int tenantId, String type) throws Exception {
		LOGGER.debug("getApprovalList started.");
		LOGGER.debug("userId = " + userId + " || companyId = " + companyId + " || tenantId = " + tenantId + " || type = " + type);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userId", userId);
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		
		List<ApprGDocListVO> list = null;
		Map<String, Object> result = new HashMap<String, Object>();
		
		switch (type) {
		case "doing":
			list = ezNewPortalDAO.getApprovalDoingList(map);
			result.put("list", list);
			//첫문서 결재라인 조회
			
			break;
		case "reject":
			list = ezNewPortalDAO.getApprovalRejectList(map);
			result.put("list", list);
			
			break;
		case "draft":
			list = ezNewPortalDAO.getApprovalDraftList(map);
			result.put("list", list);
			
			break;

		default:
			break;
		}
		
		LOGGER.debug("getApprovalList ended.");
		
		return result;
	}
	
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
	
	@Override
	public Map<String, Object> getApprovalStatistics(String userId, String companyId, int tenantId) throws Exception {
		LOGGER.debug("getApprovalStatistics started.");
		LOGGER.debug("userId = " + userId + " || companyId = " + companyId + " || tenantId = " + tenantId);		
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userId", userId);
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		
		Map<String, Object> result = ezNewPortalDAO.getApprovalStatistics(map);
		
		LOGGER.debug("getApprovalStatistics ended.");
		
		return result;
	}
	/** -------------------- */

	@Override
	public List<FavoriteBoardVO> getFavNewItemList(String userId, int tenantId, String companyId, String nowDate, int limit) {
		LOGGER.debug("getFavNewItemList started.");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userId", userId);
		map.put("tenantId", tenantId);
		map.put("companyId", companyId);
		map.put("nowDate", nowDate);
		map.put("limit", limit);
		
		return ezNewPortalDAO.getFavNewItemList(map);
	}
	
	@Override
	public List<FavoriteBoardVO> getFavItemList(String boardId, int tenantId, String companyId, int limit) {
		LOGGER.debug("getFavItemList started.");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("boardId", boardId);
		map.put("tenantId", tenantId);
		map.put("companyId", companyId);
		map.put("limit", limit);
		
		return ezNewPortalDAO.getFavItemList(map);
	}
	
	@Override
	public List<CommunityMyCommunityVO> getCommunityList(String lang, String companyId, int tenantId) throws Exception {
		LOGGER.debug("getCommunityList started.");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_LANG", commonUtil.getMultiData(lang, tenantId));
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		
		return ezNewPortalDAO.getCommunityList(map);
	}
	
	@Override
	public String getMemberChk(String cNo, String userId, int tenantId) {
		LOGGER.debug("memberChk started");

		String ret = "1";
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userId", userId);
		map.put("clubNo", cNo);
		map.put("tenantID", tenantId);
		
		CommunityCClubUserVO result = ezNewPortalDAO.getCommunityPermit(map);
		
		if (result != null) {
			ret = "1";
		} else {
			ret = "0";
		}

		LOGGER.debug("memberChk ended");
		return ret;
	}
}
