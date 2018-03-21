package egovframework.ezEKP.ezLadder.service.impl;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;

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
	public int ladderCount(LadderVO vo, String mode) throws Exception {
		logger.debug("ladderCount started.");		// 비검색 전체
		Map<String,Object> map = new HashMap<String, Object>();	
		map.put("userId", vo.getUserId());
		map.put("tenantId", vo.getTenant_id());
		map.put("mode", mode);
		int totalLadder = ezLadderDAO.getLadderCount(map);
		logger.debug("totalLadder : " + totalLadder);
		logger.debug("ladderCount ended.");
		return totalLadder;
	}
	
	@Override
	public int partLadderCount(LadderVO vo) throws Exception {
		logger.debug("partLadderCount started.");	// 비검색 참여자
		Map<String,Object> map = new HashMap<String, Object>();	
		map.put("userId", vo.getUserId());
		map.put("tenantId", vo.getTenant_id());
		int totalLadder = ezLadderDAO.getPartLadderCount(map);
		logger.debug("totalLadder : " + totalLadder);
		logger.debug("partLadderCount ended.");
		return totalLadder;
	}
	
	@Override
	public int searchLadderCount(LadderVO vo, List<String> allData) throws Exception {
		logger.debug("searchLadderCount started.");	// 검색
		
		Map<String,Object> map = new HashMap<String, Object>();	
		String searchSelect = allData.get(0);
		String searchInput = allData.get(1).trim();
		String mode = allData.get(2);
		
		searchInput = searchInput.replace("%", "\\%").replace("_", "\\_");
		
		map.put("userId", vo.getUserId());
		map.put("searchSelect", searchSelect);
		map.put("searchInput", searchInput);
		map.put("mode", mode);
		map.put("tenantId", vo.getTenant_id());
		
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
	public List<LadderVO> getLadderList(LadderVO vo, int startPoint, int endPoint, String mode) throws Exception {
		logger.debug("getLadderList started.");		// 비검색 전체
		String lang = commonUtil.getMultiData(vo.getLang(), vo.getTenant_id());
		
		Map<String,Object> map = new HashMap<String, Object>();	
		map.put("userId", vo.getUserId());
		map.put("tenantId", vo.getTenant_id());
		map.put("startPoint", startPoint);
		map.put("endPoint", endPoint);
		map.put("mode", mode);
		map.put("offset", commonUtil.getMinuteUTC(vo.getOffset()));
		map.put("lang", lang);
	
		List<LadderVO> list = ezLadderDAO.getLadderList(map);
		
		logger.debug("getLadderList ended.");
		return list;
	}
	
	@Override
	public List<LadderVO> getPartLadderList(LadderVO vo, int startPoint, int endPoint) throws Exception {
		logger.debug("getPartLadderList started.");		// 비검색 참여자
		String lang = commonUtil.getMultiData(vo.getLang(), vo.getTenant_id());
		
		Map<String,Object> map = new HashMap<String, Object>();	
		map.put("userId", vo.getUserId());
		map.put("tenantId", vo.getTenant_id());
		map.put("startPoint", startPoint);
		map.put("endPoint", endPoint);
		map.put("offset", commonUtil.getMinuteUTC(vo.getOffset()));
		map.put("lang", lang);
		List<LadderVO> list = ezLadderDAO.getPartLadderList(map);
		
		logger.debug("getPartLadderList ended.");
		return list;
	}
	
	@Override
	public List<LadderVO> searchLadderList(LadderVO vo, List<String> allData, int startPoint, int endPoint) throws Exception {
		logger.debug("searchLadderList started.");		// 검색
		String lang = commonUtil.getMultiData(vo.getLang(), vo.getTenant_id());
		Map<String,Object> map = new HashMap<String, Object>();	
		String searchSelect = allData.get(0);
		String searchInput = allData.get(1).trim();
		String mode = allData.get(2);
		
		searchInput = searchInput.replace("%", "\\%").replace("_", "\\_");
	
		map.put("userId", vo.getUserId());
		map.put("searchSelect", searchSelect);
		map.put("searchInput", searchInput);
		map.put("mode", mode);
		map.put("tenantId", vo.getTenant_id());
		map.put("startPoint", startPoint);
		map.put("endPoint", endPoint);
		map.put("offset", commonUtil.getMinuteUTC(vo.getOffset()));
		map.put("lang", lang);
		
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
	public List<LadderCommentVO> selectComment(LadderCommentVO cmtVO) throws Exception {
		List<LadderCommentVO> comments = ezLadderDAO.selectComment(cmtVO);
		
		String lang = commonUtil.getMultiData(cmtVO.getLang(), cmtVO.getTenant_id());
		for(LadderCommentVO cmt : comments) {
			String datdStr = "";
			datdStr = commonUtil.getDateStringInUTC(cmt.getWriteDate(), cmtVO.getOffset(), false);
			cmt.setWriteDate(datdStr);
			if(lang.equals("2")) {
				cmt.setUserName(cmt.getUserName2());
			}
		}
		
		return comments;
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
	public LadderVO getLadderGame(LadderVO ladVO) throws Exception {	// 사다리 한개의 정보
		logger.debug("getLadderGame started.");
		String lang = commonUtil.getMultiData(ladVO.getLang(), ladVO.getTenant_id());
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("ladderId", ladVO.getLadderId());
		map.put("tenantId", ladVO.getTenant_id());
		map.put("offset", commonUtil.getMinuteUTC(ladVO.getOffset()));
		map.put("lang", lang);
		LadderVO vo = ezLadderDAO.ladderContent(map);
		logger.debug("getLadderGame ended.");
		return vo;
	}
	
	@Override
	public List<LadderLineVO> getLadderLineParticipant(LadderVO ladVO) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		logger.debug("getLadderLineParticipant started.");
		String lang = commonUtil.getMultiData(ladVO.getLang(), ladVO.getTenant_id());
		map.put("ladderId", ladVO.getLadderId());
		map.put("tenantId", ladVO.getTenant_id());
		map.put("lang", lang);
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
		String deleteDate = commonUtil.getTodayUTCTime("");	// startDate UCT 타임 설정
		System.out.println(deleteDate);
		searchInput = searchInput.replace("%", "\\%").replace("_", "\\_");
		
		map.put("userId", userId);
		map.put("searchSelect", searchSelect);
		map.put("searchInput", searchInput);
		map.put("mode", mode);
		map.put("ladderId", ladderId);
		map.put("tenantId", tenantId);
		map.put("deleteDate", deleteDate);
		ezLadderDAO.deleteLadderList(map);
		
		logger.debug("deleteLadder ended.");
	}

	@Override
	public void setUserOrder(int LadderId, String userName1, String userName2)
			throws Exception {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void setLadderStart(int ladderId, String tenantId, int size, int lineCnt) throws Exception {
		logger.debug("setLadderStart started.");	
		String startDate = commonUtil.getTodayUTCTime("");	// startDate UCT 타임 설정
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("ladderId", ladderId);
		map.put("tenantId", tenantId);
		map.put("startDate", startDate);
		
		// lineCnt를 이용해 lineArray를 구함
		int[] lineArray = new int[lineCnt];
		lineArray = getLineArray(size, lineCnt);
		String line = getLine(size, lineArray);
		
		map.put("lineArray", line);
		
		ezLadderDAO.updateLadderStart(map);		// startDate, lineArray 업데이트
		System.out.println(startDate);
		System.out.println(ladderId);
		System.out.println(tenantId);
		System.out.println(line);
		logger.debug("setLadderStart ended.");
	}

	@Override
	public int[] getLineArray(int size, int lineCnt) {
		// height를 일단 10으로 통일함. 추후 height를 사용자 수(size)에 따라 유동적으로 줄지는 논의 필요
		int height=10;
		logger.debug("getLineArray started.");
		logger.debug("size : " + size);
		logger.debug("lineCnt : " + lineCnt);
		Random random = new Random();
		int[] choice = new int[lineCnt];// 선택된 선 번호
		int jungbockCnt = 0;// 중복 카운트
		lineCnt = 0;

		while (true) {
			int temp = random.nextInt(size * height - height);// 하나 고르기
			boolean pass = true;// 유효성 체크

			for (int i = 0; i <= lineCnt; i++) {
				if (temp == choice[i]) {// 중복된 선이라면 false
					pass = false;
					break;
				} else if (Math.abs(temp - choice[i]) == 1) {// 옆 사다리라면,
					if (Math.abs((temp % (size - 1)) - (choice[i] % (size - 1))) == 1) {// 높이가 같다면 false
						pass = false;
						break;
					}
				}
			}
			if (pass == true) {// 옳은 값이면 넣어주기
				choice[lineCnt++] = temp;
			}

			if (lineCnt == choice.length) {// 선 갯수를 만족한다면 break
				break;
			}

			jungbockCnt++;// 만들 수 없는 사다리 배제
			if (jungbockCnt >= 10000) {
				jungbockCnt = 0;
				lineCnt = 0;
				for (int i = 0; i < choice.length; i++) {
					choice[i] = 0;
				}
			}
		}
		logger.debug("getLineArray ended.");
		return choice;
	}

	@Override
	public String getLine(int size, int[] lineArray) {
		logger.debug("getLine started.");
		// height를 일단 10으로 통일함. 추후 height를 사용자 수(size)에 따라 유동적으로 줄지는 논의 필요
		int height = 10;
		String lineArr="";
		int[] line = new int[size * height];
		for (int i = 0; i < lineArray.length; i++) {
			int temp = lineArray[i];
			temp = (temp / (size - 1)) * size + temp % (size - 1);
			line[temp] = 1;
			line[temp + 1] = 2;
		}
		
		for(int i =0; i<line.length; i++) {
			lineArr += Integer.toString(line[i]);
		}
		logger.debug("getLine ended.");
		return lineArr;
	}
}
