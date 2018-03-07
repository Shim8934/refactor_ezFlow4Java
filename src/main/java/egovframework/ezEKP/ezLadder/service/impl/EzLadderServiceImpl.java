package egovframework.ezEKP.ezLadder.service.impl;

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
	public List<LadderVO> getLadderList(String userId) throws Exception {
		logger.debug("getLadderList started.");
		Map<String,Object> map = new HashMap<String, Object>();	
		map.put("userId", userId);
		List<LadderVO> list = ezLadderDAO.getLadderList(map);
		
		logger.debug("getLadderList ended.");
		return list;
	}
	
	@Override
	public List<LadderVO> getPartLadderList(String userId) throws Exception {
		logger.debug("getPartLadderList started.");
		Map<String,Object> map = new HashMap<String, Object>();	
		map.put("userId", userId);
		List<LadderVO> list = ezLadderDAO.getPartLadderList(map);
		
		logger.debug("getPartLadderList ended.");
		return list;
	}
	
	@Override
	public List<LadderVO> searchLadderList(String userId, List<String> allData) throws Exception {
		logger.debug("searchLadderList started.");
	
		Map<String,Object> map = new HashMap<String, Object>();	
		String searchSelect = allData.get(0).substring(1);
		String searchInput = allData.get(1).trim();
		String mode = allData.get(2).substring(0,allData.get(2).length()-1);
		
		searchInput = searchInput.replace("%", "\\%").replace("_", "\\_");
		
		map.put("userId", userId);
		map.put("searchSelect", searchSelect);
		map.put("searchInput", searchInput);
		map.put("mode", mode);
		
		
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
	public void insertLadder(LadderVO lad, List<LadderLineVO> ladLineList)
			throws Exception {
		// TODO Auto-generated method stub
		
		ezLadderDAO.insertLadderSet(lad);
		
		for(LadderLineVO ladLine : ladLineList) {
			ezLadderDAO.insertLadderLine(ladLine);
		}
	}

	@Override
	public List<LadderBmVO> selectBMGroup(String userId) throws Exception {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public List<LadderBmUserVO> selectBMUser(String userId, int ladderBMId)
			throws Exception {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public void insertBMGroup(LadderBmVO bmGroup, LadderBmUserVO bmUser)
			throws Exception {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void updateBMGroup(LadderBmVO bmGroup, LadderBmUserVO bmUser)
			throws Exception {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void deleteBMGroup(String userId, int ladderBMId) throws Exception {
		// TODO Auto-generated method stub
		
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
	public LadderVO getLadderGame(String userId, int ladderId) throws Exception {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public List<LadderVO> deleteLadderList(String userId, List<String> allData) throws Exception {
		logger.debug("deleteLadder started.");
		
		Map<String,Object> map = new HashMap<String, Object>();	
		String ladderId = allData.get(0).substring(1);
		String searchSelect = allData.get(1);
		String searchInput = allData.get(2).trim();
		String mode = allData.get(3).substring(0,allData.get(3).length()-1);
		
		searchInput = searchInput.replace("%", "\\%").replace("_", "\\_");
		
		map.put("userId", userId);
		map.put("searchSelect", searchSelect);
		map.put("searchInput", searchInput);
		map.put("mode", mode);
		map.put("ladderId", ladderId);
		
		// mode가 참여인지, 일부인지에 따라
		ezLadderDAO.deleteLadderList(map);
		
		List<LadderVO> list = null;
		if(mode.equals("part")) {		// 참여버튼 검색
			if(searchSelect.equals("none")) {
				list = ezLadderDAO.getPartLadderList(map);		// 검색이 아닐 때
			} else {
				list = ezLadderDAO.searchPartLadderList(map);	// 검색시
			}
		} else {						// 전체버튼 검색
			if(searchSelect.equals("none")) {
				list = ezLadderDAO.getLadderList(map);			// 검색이 아닐 때
			} else {
				list = ezLadderDAO.searchAllLadderList(map);	// 검색시
			}
		}
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
