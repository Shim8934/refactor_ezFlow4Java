package egovframework.ezEKP.ezLadder.service.impl;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.support.DaoSupport;
import org.springframework.stereotype.Service;

import egovframework.ezEKP.ezLadder.dao.EzLadderDAO;
import egovframework.ezEKP.ezLadder.service.EzLadderService;
import egovframework.ezEKP.ezLadder.vo.LadderBmUserVO;
import egovframework.ezEKP.ezLadder.vo.LadderBmVO;
import egovframework.ezEKP.ezLadder.vo.LadderCommentVO;
import egovframework.ezEKP.ezLadder.vo.LadderLineVO;
import egovframework.ezEKP.ezLadder.vo.LadderVO;
import egovframework.let.utl.fcc.service.CommonUtil;

@Service("EzLadderService")
public class EzLadderServiceImpl implements EzLadderService {
	private static final Logger logger = LoggerFactory.getLogger(EzLadderServiceImpl.class);
	
	@Resource(name="EzLadderDAO")
	private EzLadderDAO ezLadderDAO;
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Override
	public int ladderCount(String userId, String tenantId) throws Exception {
		logger.debug("ladderCount started.");		// 비검색 전체
		Map<String,Object> map = new HashMap<String, Object>();	
		map.put("userId", userId);
		map.put("tenantId", tenantId);
		int totalLadder = ezLadderDAO.getLadderCount(map);
		logger.debug("totalLadder : " + totalLadder);
		logger.debug("ladderCount ended.");
		return totalLadder;
	}
	
	@Override
	public int partLadderCount(String userId, String tenantId) throws Exception {
		logger.debug("partLadderCount started.");	// 비검색 참여자
		Map<String,Object> map = new HashMap<String, Object>();	
		map.put("userId", userId);
		map.put("tenantId", tenantId);
		int totalLadder = ezLadderDAO.getPartLadderCount(map);
		logger.debug("totalLadder : " + totalLadder);
		logger.debug("partLadderCount ended.");
		return totalLadder;
	}
	
	@Override
	public int searchLadderCount(String userId, String tenantId, List<String> allData) throws Exception {
		logger.debug("searchLadderCount started.");	// 검색
		
		Map<String,Object> map = new HashMap<String, Object>();	
		String searchSelect = allData.get(0);
		String searchInput = allData.get(1).trim();
		String mode = allData.get(2);
		
		searchInput = searchInput.replace("%", "\\%").replace("_", "\\_");
		
		map.put("userId", userId);
		map.put("searchSelect", searchSelect);
		map.put("searchInput", searchInput);
		map.put("mode", mode);
		map.put("tenantId", tenantId);
		
		int totalLadder = 0;
		if(mode.equals("part")) {		// 참여버튼 검색
			totalLadder = ezLadderDAO.getPartSLadderCount(map);
			
		} else {						// 전체버튼 검색
			totalLadder = ezLadderDAO.getAllSLadderCount(map);
		}
		logger.debug("totalLadder : " + totalLadder);
		logger.debug("searchLadderCount ended.");
		return totalLadder;
	}
	
	@Override
	public List<LadderVO> getLadderList(String userId, String tenantId, int startPoint, int endPoint) throws Exception {
		logger.debug("getLadderList started.");		// 비검색 전체
		Map<String,Object> map = new HashMap<String, Object>();	
		map.put("userId", userId);
		map.put("tenantId", tenantId);
		map.put("startPoint", startPoint);
		map.put("endPoint", endPoint);
		List<LadderVO> list = ezLadderDAO.getLadderList(map);
		
		logger.debug("getLadderList ended.");
		return list;
	}
	
	@Override
	public List<LadderVO> getPartLadderList(String userId, String tenantId, int startPoint, int endPoint) throws Exception {
		logger.debug("getPartLadderList started.");		// 비검색 참여자
		Map<String,Object> map = new HashMap<String, Object>();	
		map.put("userId", userId);
		map.put("tenantId", tenantId);
		map.put("startPoint", startPoint);
		map.put("endPoint", endPoint);
		List<LadderVO> list = ezLadderDAO.getPartLadderList(map);
		
		logger.debug("getPartLadderList ended.");
		return list;
	}
	
	@Override
	public List<LadderVO> searchLadderList(String userId, String tenantId, List<String> allData, int startPoint, int endPoint) throws Exception {
		logger.debug("searchLadderList started.");		// 검색
	
		Map<String,Object> map = new HashMap<String, Object>();	
		String searchSelect = allData.get(0);
		String searchInput = allData.get(1).trim();
		String mode = allData.get(2);
		
		searchInput = searchInput.replace("%", "\\%").replace("_", "\\_");
		
		map.put("userId", userId);
		map.put("searchSelect", searchSelect);
		map.put("searchInput", searchInput);
		map.put("mode", mode);
		map.put("tenantId", tenantId);
		map.put("startPoint", startPoint);
		map.put("endPoint", endPoint);
		
		
		List<LadderVO> list = null;
		if(mode.equals("part")) {		// 참여버튼 검색
			list = ezLadderDAO.searchPartLadderList(map);
		} else {						// 전체버튼 검색
			list = ezLadderDAO.searchAllLadderList(map);
		}
		logger.debug("searchLadderList ended.");
		return list;
	}

	/** boh */
	@Override
	public void insertLadder(LadderVO lad, LadderLineVO ladLines) throws Exception {
		lad.setWriteDate(commonUtil.getTodayUTCTime(""));
		
		ezLadderDAO.insertLadderSet(lad);
		
		int len = ladLines.getUserIds().length;
		for(int i = 0; i < len; i++) {
			ladLines.setUserId(ladLines.getUserIds()[i]);
			ladLines.setUserName(ladLines.getUserNames()[i]);
			ladLines.setUserName2(ladLines.getUserName2s()[i]);
			ladLines.setItem(ladLines.getItems()[i]);
			ladLines.setLadderOrder(ladLines.getLadderOrders()[i]);
			
			ezLadderDAO.insertLadderLine(ladLines);
		}
	}

	@Override
	public int selectRecentLadderId(LadderVO lad) throws Exception {
		return ezLadderDAO.selectRecentLadderId(lad);
	}

	@Override
	public List<LadderBmVO> selectBMGroup(LadderBmVO bmGroup) throws Exception {
		List<LadderBmVO> bmGroups = ezLadderDAO.selectBMGroup(bmGroup);
		String offset = bmGroup.getOffset();
		
		for(LadderBmVO groupVO : bmGroups) {
			String dateStr = "";
			dateStr = commonUtil.getDateStringInUTC(groupVO.getRegdate(), offset, false);
			groupVO.setRegdate(dateStr);
		}
		
		return bmGroups;
	}

	@Override
	public List<LadderBmUserVO> selectBMUser(LadderBmUserVO bmUser) throws Exception {
		List<LadderBmUserVO> bmUsers = ezLadderDAO.selectBMUser(bmUser);
		
		String lang = commonUtil.getMultiData(bmUser.getLang(), bmUser.getTenant_id());
		if(lang.equals("2")) {
			for(LadderBmUserVO userVO : bmUsers) {
				userVO.setUserName(userVO.getUserName2());
			}
		}
		
		return bmUsers;
	}

	@Override
	public void insertBM(LadderBmVO bmGroup, LadderBmUserVO bmUsers) throws Exception {
		bmGroup.setRegdate(commonUtil.getTodayUTCTime(""));
		
		ezLadderDAO.insertBMGroup(bmGroup);
		
		int len = bmUsers.getUserIds().length;
		for(int i = 0; i < len; i++) {
			bmUsers.setUserId(bmUsers.getUserIds()[i]);
			bmUsers.setUserName(bmUsers.getUserNames()[i]);
			bmUsers.setUserName2(bmUsers.getUserName2s()[i]);
			
			ezLadderDAO.insertBMUser(bmUsers);
		}
	}

	@Override
	public void updateBM(LadderBmVO bmGroup, LadderBmUserVO bmUsers) throws Exception {
		bmGroup.setRegdate(commonUtil.getTodayUTCTime(""));
		
		ezLadderDAO.updateBMGroup(bmGroup);
		
		ezLadderDAO.deleteBMUserAll(bmGroup);
		
		int len = bmUsers.getUserIds().length;
		for(int i = 0; i < len; i++) {
			bmUsers.setUserId(bmUsers.getUserIds()[i]);
			bmUsers.setUserName(bmUsers.getUserNames()[i]);
			bmUsers.setUserName2(bmUsers.getUserName2s()[i]);
			
			ezLadderDAO.insertBMUser(bmUsers);
		}
	}

	@Override
	public void deleteBM(LadderBmVO bmGroup, LadderBmUserVO bmUsers) throws Exception {
		int len = bmUsers.getUserIds().length;
		String lang = commonUtil.getMultiData(bmUsers.getLang(), bmUsers.getTenant_id());
		bmUsers.setLang(lang);
		
		if(len == 0) {
			ezLadderDAO.deleteBMGroup(bmGroup);
			
		} else {
			for(int i = 0; i < len; i++) {
				bmUsers.setUserId(bmUsers.getUserIds()[i]);
				if(lang.equals("")) {
					bmUsers.setUserName(bmUsers.getUserNames()[i]);
				} else {
					bmUsers.setUserName(bmUsers.getUserName2s()[i]);
				}
				
				ezLadderDAO.deleteBMUser(bmUsers);
			}
		}
	}

	@Override
	public List<LadderCommentVO> selectComment(int ladderId) throws Exception {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public void insertComment(LadderCommentVO ladCmt) throws Exception {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void updateComment(LadderCommentVO ladCmt) throws Exception {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void deleteComment(String userId, LadderCommentVO ladCmt)
			throws Exception {
		// TODO Auto-generated method stub
		
	}

	@Override
	public List<LadderVO> selectPreLadderList(String userId) throws Exception {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public LadderLineVO selectPreLadder(String userId, int ladderId)
			throws Exception {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public void changePreLadderList(String userId, String ladderId_1,
			String ladderId_2) throws Exception {
		// TODO Auto-generated method stub
		
	}

	/** hyh */
	
	@Override
	public LadderVO getLadderGame(String tenantId, int ladderId) throws Exception {	// 사다리 한개의 정보
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("ladderId", ladderId);
		map.put("tenantId", tenantId);
		LadderVO vo = ezLadderDAO.ladderContent(map);
		return vo;
	}
	
	@Override
	public List<LadderLineVO> getLadderLineParticipant(String tenantId, int ladderId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		logger.debug("getLadderLineParticipant started.");
		map.put("ladderId", ladderId);
		map.put("tenantId", tenantId);
		List<LadderLineVO> list = ezLadderDAO.ladderGameParticipant(map);
		logger.debug("getLadderLineParticipant ended.");
		return list;
	}

	@Override
	public void deleteLadderList(String userId, String tenantId, List<String> allData) throws Exception {
		logger.debug("deleteLadder started.");			// 사다리 1개 삭제
		
		Map<String,Object> map = new HashMap<String, Object>();	
		String ladderId = allData.get(0);
		String searchSelect = allData.get(1);
		String searchInput = allData.get(2).trim();
		String mode = allData.get(3);
		
		searchInput = searchInput.replace("%", "\\%").replace("_", "\\_");
		
		map.put("userId", userId);
		map.put("searchSelect", searchSelect);
		map.put("searchInput", searchInput);
		map.put("mode", mode);
		map.put("ladderId", ladderId);
		map.put("tenantId", tenantId);
		
		ezLadderDAO.deleteLadderList(map);
		
		logger.debug("deleteLadder ended.");
	}

	@Override
	public void setUserOrder(int LadderId, String userName1, String userName2)
			throws Exception {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void setLadderStart(int LadderId, String userId, String lineArray)
			throws Exception {
		// TODO Auto-generated method stub
		
	}
	
}
