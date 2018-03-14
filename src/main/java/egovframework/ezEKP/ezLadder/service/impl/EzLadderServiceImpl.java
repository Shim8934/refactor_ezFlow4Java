package egovframework.ezEKP.ezLadder.service.impl;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.dao.support.DaoSupport;
import org.springframework.stereotype.Service;

import egovframework.ezEKP.ezLadder.dao.EzLadderDAO;
import egovframework.ezEKP.ezLadder.service.EzLadderService;
import egovframework.ezEKP.ezLadder.vo.LadderBmUserVO;
import egovframework.ezEKP.ezLadder.vo.LadderBmVO;
import egovframework.ezEKP.ezLadder.vo.LadderCommentVO;
import egovframework.ezEKP.ezLadder.vo.LadderLineVO;
import egovframework.ezEKP.ezLadder.vo.LadderVO;

@Service("EzLadderService")
public class EzLadderServiceImpl implements EzLadderService {
	private static final Logger logger = LoggerFactory.getLogger(EzLadderServiceImpl.class);
	
	@Resource(name="EzLadderDAO")
	private EzLadderDAO ezLadderDAO;
	
	@Override
	public List<LadderVO> getLadderList(String userId, String tenantId) throws Exception {
		logger.debug("getLadderList started.");
		Map<String,Object> map = new HashMap<String, Object>();	
		map.put("userId", userId);
		map.put("tenantId", tenantId);
		
		List<LadderVO> list = ezLadderDAO.getLadderList(map);
		
		logger.debug("getLadderList ended.");
		return list;
	}
	
	@Override
	public List<LadderVO> getPartLadderList(String userId, String tenantId) throws Exception {
		logger.debug("getPartLadderList started.");
		Map<String,Object> map = new HashMap<String, Object>();	
		map.put("userId", userId);
		map.put("tenantId", tenantId);
		List<LadderVO> list = ezLadderDAO.getPartLadderList(map);
		
		logger.debug("getPartLadderList ended.");
		return list;
	}
	
	@Override
	public List<LadderVO> searchLadderList(String userId, String tenantId, List<String> allData) throws Exception {
		logger.debug("searchLadderList started.");
	
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
	public void insertLadder(LadderVO lad, List<LadderLineVO> ladLineList) throws Exception {
		ezLadderDAO.insertLadderSet(lad);
		
		for(LadderLineVO ladLine : ladLineList) {
			ezLadderDAO.insertLadderLine(ladLine);
		}
	}

	@Override
	public int selectRecentLadderId(String writerId) throws Exception {
		return ezLadderDAO.selectRecentLadderId(writerId);
	}

	@Override
	public List<LadderBmVO> selectBMGroup(String userId, int tenant_id) throws Exception {
		LadderBmVO bmGroup = new LadderBmVO();
		
		bmGroup.setUserId(userId);
		bmGroup.setTenant_id(tenant_id);
		
		return ezLadderDAO.selectBMGroup(bmGroup);
	}

	@Override
	public List<LadderBmUserVO> selectBMUser(int tenant_id, int ladderBMId) throws Exception {
		LadderBmVO bmGroup = new LadderBmVO();
		
		bmGroup.setLadderBmId(ladderBMId);
		bmGroup.setTenant_id(tenant_id);
		
		return ezLadderDAO.selectBMUser(bmGroup);
	}

	@Override
	public void insertBM(LadderBmVO bmGroup, List<LadderBmUserVO> bmUsers) throws Exception {
		ezLadderDAO.insertBMGroup(bmGroup);
		
		for(LadderBmUserVO bmuser : bmUsers) {
			ezLadderDAO.insertBMUser(bmuser);
		}
	}

	@Override
	public void updateBM(LadderBmVO bmGroup, List<LadderBmUserVO> bmUser) throws Exception {
		ezLadderDAO.updateBMGroup(bmGroup);
		
		ezLadderDAO.deleteBMUserAll(bmGroup);
		
		int len = bmUser.size();
		for(int i = 0; i < len; i++) {
			ezLadderDAO.insertBMUser(bmUser.get(i));
		}
	}

	@Override
	public void deleteBM(LadderBmVO bmGroup, List<LadderBmUserVO> bmUser) throws Exception {
		int len = bmUser.size();
		if(len == 0) { // 즐겨찾기 그룹 삭제
			ezLadderDAO.deleteBMGroup(bmGroup);
		} else {
			for(int i = 0; i < len; i++) { // 특정 즐겨찾기의 멤버 삭제
				ezLadderDAO.deleteBMUser(bmUser.get(i));
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
	public LadderVO getLadderGame(String tenantId, int ladderId) throws Exception {
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
	public List<LadderVO> deleteLadderList(String userId, String tenantId, List<String> allData) throws Exception {
		logger.debug("deleteLadder started.");
		
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
		
		// mode가 참여인지, 일부인지에 따라
		ezLadderDAO.deleteLadderList(map);
		
		List<LadderVO> list = null;
//		if(mode.equals("part")) {		// 참여버튼 검색
//			if(searchSelect.equals("none")) {
//				list = ezLadderDAO.getPartLadderList(map);		// 검색이 아닐 때
//			} else {
//				list = ezLadderDAO.searchPartLadderList(map);	// 검색시
//			}
//		} else {						// 전체버튼 검색
//			if(searchSelect.equals("none")) {
//				list = ezLadderDAO.getLadderList(map);			// 검색이 아닐 때
//			} else {
//				list = ezLadderDAO.searchAllLadderList(map);	// 검색시
//			}
//		}
		logger.debug("deleteLadder ended.");
		return list;
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
