package egovframework.ezEKP.ezLadder.service.impl;

import java.security.SecureRandom;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;

import javax.annotation.Resource;
import javax.mail.internet.InternetAddress;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezEmail.service.EzEmailService;
import egovframework.ezEKP.ezLadder.dao.EzLadderDAO;
import egovframework.ezEKP.ezLadder.service.EzLadderService;
import egovframework.ezEKP.ezLadder.vo.LadderBmUserVO;
import egovframework.ezEKP.ezLadder.vo.LadderBmVO;
import egovframework.ezEKP.ezLadder.vo.LadderCommentVO;
import egovframework.ezEKP.ezLadder.vo.LadderLineVO;
import egovframework.ezEKP.ezLadder.vo.LadderOrderVO;
import egovframework.ezEKP.ezLadder.vo.LadderVO;
import egovframework.ezEKP.ezOrgan.dao.EzOrganDAO;
import egovframework.ezEKP.ezOrgan.service.EzOrganAdminService;
import egovframework.ezEKP.ezOrgan.vo.OrganUserVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.fcc.service.EgovDateUtil;

@Service("EzLadderService")
public class EzLadderServiceImpl implements EzLadderService {
	private static final Logger logger = LoggerFactory.getLogger(EzLadderServiceImpl.class);
	
	@Resource(name="EzLadderDAO")
	private EzLadderDAO ezLadderDAO;
	
	@Resource(name = "EzOrganDAO")
	private EzOrganDAO ezOrganDAO;
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private EzEmailService ezEmailService;
	
	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;
	
	@Autowired
	private EzOrganAdminService ezOrganAdminService;
	
	@Override
	public int ladderCount(LadderVO vo, String mode) throws Exception {
		logger.debug("ladderCount started.");		// 비검색 전체
		Map<String,Object> map = new HashMap<String, Object>();	
		map.put("userId", vo.getUserId());
		map.put("tenantId", vo.getTenant_id());
		map.put("mode", mode);
		map.put("companyID", vo.getCompanyID());
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
		map.put("companyID", vo.getCompanyID());
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
		String searchInput = allData.get(1);
		String mode = allData.get(2);
	
		searchInput = searchInput.replace("\\","\\\\");
		searchInput = searchInput.replace("%", "\\%");
		searchInput = searchInput.replace("_", "\\_");
		
		
		map.put("userId", vo.getUserId());
		map.put("searchSelect", searchSelect);
		map.put("searchInput", searchInput);
		map.put("mode", mode);
		map.put("tenantId", vo.getTenant_id());
		map.put("companyID", vo.getCompanyID());
		
		int totalLadder = 0;
		if (mode.equals("part")) {		// 참여버튼 검색
			totalLadder = ezLadderDAO.getPartSLadderCount(map);
		} else {						// 전체버튼 검색
			totalLadder = ezLadderDAO.getAllSLadderCount(map);
		}
		
		logger.debug("totalLadder : " + totalLadder);
		logger.debug("searchLadderCount ended.");
		return totalLadder;
	}
	
	@Override
	public List<LadderVO> getLadderList(LadderVO vo, int startPoint, int endPoint, String mode, String sort, String sortFlag) throws Exception {
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
		map.put("sort", sort);
		map.put("sortFlag", sortFlag);
		map.put("companyID", vo.getCompanyID());
	
		if (mode.equals("pre")) {
			List<LadderVO> ladList = ezLadderDAO.selectPreList(map);
			return ladList;
		}
		
		List<LadderVO> list = ezLadderDAO.getLadderList(map);
		
		// 생성된 지 24시간 여부
		String nowDate = commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime(""),vo.getOffset(), false);
		nowDate = EgovDateUtil.addDay(nowDate, -1, "yyyy-MM-dd HH:mm:ss");
		
		for (LadderVO userVO:list) {
			if (userVO.getWriteDate().toString().compareTo(nowDate) > 0) {
				userVO.setNewFlag(1);
			} else {
				userVO.setNewFlag(0);
			}
		}

		if (lang.equals("2")) {
			for (LadderVO userVO : list) {
				userVO.setWriterName(userVO.getWriterName2());
			}
		}
		
		logger.debug("getLadderList ended.");
		return list;
	}
	
	@Override
	public List<LadderVO> getPartLadderList(LadderVO vo, int startPoint, int endPoint, String sort, String sortFlag) throws Exception {
		logger.debug("getPartLadderList started.");		// 비검색 참여자
		String lang = commonUtil.getMultiData(vo.getLang(), vo.getTenant_id());
		
		Map<String,Object> map = new HashMap<String, Object>();	
		map.put("userId", vo.getUserId());
		map.put("tenantId", vo.getTenant_id());
		map.put("startPoint", startPoint);
		map.put("endPoint", endPoint);
		map.put("offset", commonUtil.getMinuteUTC(vo.getOffset()));
		map.put("lang", lang);
		map.put("sort", sort);
		map.put("sortFlag", sortFlag);
		map.put("companyID", vo.getCompanyID());
		List<LadderVO> list = ezLadderDAO.getPartLadderList(map);
		
		// 생성된 지 24시간 여부
		String nowDate = commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime(""),vo.getOffset(), false);
		nowDate = EgovDateUtil.addDay(nowDate, -1, "yyyy-MM-dd HH:mm:ss");
		
		for (LadderVO userVO:list) {
			if (userVO.getWriteDate().toString().compareTo(nowDate) > 0) {
				userVO.setNewFlag(1);
			} else {
				userVO.setNewFlag(0);
			}
		}
		
		if (lang.equals("2")) {
			for (LadderVO userVO : list) {
				userVO.setWriterName(userVO.getWriterName2());
			}
		}
		logger.debug("getPartLadderList ended.");
		return list;
	}
	
	@Override
	public List<LadderVO> searchLadderList(LadderVO vo, List<String> allData, int startPoint, int endPoint, String sort, String sortFlag) throws Exception {
		logger.debug("searchLadderList started.");		// 검색
		String lang = commonUtil.getMultiData(vo.getLang(), vo.getTenant_id());
		Map<String,Object> map = new HashMap<String, Object>();	
		String searchSelect = allData.get(0);
		String searchInput = allData.get(1);
		String mode = allData.get(2);
		
		searchInput = searchInput.replace("\\","\\\\");
		searchInput = searchInput.replace("%", "\\%");
		searchInput = searchInput.replace("_", "\\_");
		
	
		map.put("userId", vo.getUserId());
		map.put("searchSelect", searchSelect);
		map.put("searchInput", searchInput);
		map.put("mode", mode);
		map.put("tenantId", vo.getTenant_id());
		map.put("startPoint", startPoint);
		map.put("endPoint", endPoint);
		map.put("offset", commonUtil.getMinuteUTC(vo.getOffset()));
		map.put("lang", lang);
		map.put("sort", sort);
		map.put("sortFlag", sortFlag);
		map.put("companyID", vo.getCompanyID());
		
		List<LadderVO> list = null;
		if (mode.equals("part")) {		// 참여버튼 검색
			list = ezLadderDAO.searchPartLadderList(map);
		} else if(mode.equals("pre")) {	// 이전 사다리 검색
			list = ezLadderDAO.searchPreLadderList(map);
		} else {						// 전체버튼 검색
			list = ezLadderDAO.searchAllLadderList(map);
		}
		
		// 생성된 지 24시간 여부
		if (!mode.equals("pre")) {
			String nowDate = commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime(""),vo.getOffset(), false);
			nowDate = EgovDateUtil.addDay(nowDate, -1, "yyyy-MM-dd HH:mm:ss");
			
			for (LadderVO userVO:list) {
				if (userVO.getWriteDate().toString().compareTo(nowDate) > 0) {
					userVO.setNewFlag(1);
				} else {
					userVO.setNewFlag(0);
				}
			}
		}
		
		if (lang.equals("2")) {
			for (LadderVO userVO : list) {
				userVO.setWriterName(userVO.getWriterName2());
			}
		}
		logger.debug("searchLadderList ended.");
		return list;
	}

	@Override
	public List<LadderLineVO> selectSearchUser(String [] searchUserName, LadderVO ladVO)  throws Exception {
		String primaryLang = commonUtil.getMultiData(ladVO.getLang(), ladVO.getTenant_id());
		
		List<LadderLineVO> resultUser = new ArrayList<>();
		Map<String, Object> dataMap = new HashMap<>();
		
		for (String name : searchUserName) {
			if (name != null && !name.equals("")) {
				dataMap.put("name", name);
				dataMap.put("tenant_id", ladVO.getTenant_id());
				dataMap.put("lang", primaryLang);
				dataMap.put("companyID", ladVO.getCompanyID());
				
				List<LadderLineVO> user = ezLadderDAO.selectSearchUser(dataMap);
				
				if (user.size() == 0 || user == null) {
					LadderLineVO noUser = new LadderLineVO(); 
					noUser.setUserName(name);
					noUser.setUserName2(name);
					resultUser.add(noUser);
				} else {
					for (LadderLineVO line : user) {
						if (primaryLang.equals("2")) {
							String tempUserName = line.getUserName();
							line.setUserName(line.getUserName2());
							line.setUserName2(tempUserName);
						}
						resultUser.add(line);
					}
				}
				
				dataMap.clear();
			}
		}
		
		return resultUser;
	}
	
	@Override
	public int insertLadder(LadderVO lad, LadderLineVO ladLines, String logCookie) throws Exception {
		ezLadderDAO.insertLadderSet(lad);
		
		int len = ladLines.getUserIds().length;
		for(int i = 0; i < len; i++) {
			ladLines.setUserId(ladLines.getUserIds()[i]);
			ladLines.setUserName(ladLines.getUserNames()[i]);
			ladLines.setUserName2(ladLines.getUserName2s()[i]);
			ladLines.setDescription(ladLines.getDescriptions()[i]);
			ladLines.setDescription2(ladLines.getDescriptions2()[i]);
			ladLines.setItem(ladLines.getItems()[i]);
			ladLines.setLadderOrder(i);
			
			ezLadderDAO.insertLadderLine(ladLines);
		}
		
		int ladderId = ezLadderDAO.selectRecentLadderId(lad);
		lad.setLadderId(ladderId);
		
		sendLadderMail(lad, ladLines, logCookie, len);
		
		return ladderId;
	}
	
	@Override
	public int selectRecentLadderId(LadderVO lad) throws Exception {
		return ezLadderDAO.selectRecentLadderId(lad);
	}

	@Override
	public List<LadderBmVO> selectBMGroup(LadderBmVO bmGroup) throws Exception {
		List<LadderBmVO> bmGroups = ezLadderDAO.selectBMGroup(bmGroup);
		String offset = bmGroup.getOffset();
		
		String lang = commonUtil.getMultiData(bmGroup.getLang(), bmGroup.getTenant_id());
		for(LadderBmVO groupVO : bmGroups) {
			String dateStr = "";
			dateStr = commonUtil.getDateStringInUTC(groupVO.getRegdate(), offset, false);
			groupVO.setRegdate(dateStr);
			if(lang.equals("2")) {
				groupVO.setUserName(groupVO.getUserName2());
			}
		}
		
		return bmGroups;
	}

	@Override
	public List<LadderBmUserVO> selectBMUser(LadderBmUserVO bmUser) throws Exception {
		logger.debug("selectBMUser started");
		
		List<LadderBmUserVO> bmUsers = ezLadderDAO.selectBMUser(bmUser);
		
		String lang = commonUtil.getMultiData(bmUser.getLang(), bmUser.getTenant_id());
		// 회사 이름
		for(LadderBmUserVO userVO : bmUsers) {
			if(userVO.getUserId().length()>=15){
				if(userVO.getUserId().substring(0,15).equals("anonyAttendant_")){
					userVO.setCompany("");
				}
			}
		}
		if(lang.equals("2")) {
			for(LadderBmUserVO userVO : bmUsers) {
				userVO.setUserName(userVO.getUserName2());
			}
		}
		
		logger.debug("selectBMUser ended");
		return bmUsers;
	}

	@Override
	public void insertBM(LadderBmVO bmGroup, LadderBmUserVO bmUsers) throws Exception {
		bmGroup.setRegdate(commonUtil.getTodayUTCTime(""));
		
		ezLadderDAO.insertBMGroup(bmGroup);
		
		int len = bmUsers.getUserIds().length;
		String companyID = bmGroup.getCompanyID();
		for(int i = 0; i < len; i++) {
			bmUsers.setUserId(bmUsers.getUserIds()[i]);
			bmUsers.setUserName(bmUsers.getUserNames()[i]);
			bmUsers.setUserName2(bmUsers.getUserName2s()[i]);
			bmUsers.setDescription(bmUsers.getDescriptions()[i]);
			bmUsers.setDescription2(bmUsers.getDescriptions2()[i]);
			bmUsers.setCompanyID(companyID);
			if(bmUsers.getUserId().length()>=15){
				if(bmUsers.getUserId().substring(0,15).equals("anonyAttendant_")){
					bmUsers.setCompany("");
					bmUsers.setDescription("");
					bmUsers.setDescription2("");
				}
			}
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
			bmUsers.setDescription(bmUsers.getDescriptions()[i]);
			bmUsers.setDescription2(bmUsers.getDescriptions2()[i]);
			if(bmUsers.getUserId().length()>=15){
				if(bmUsers.getUserId().substring(0,15).equals("anonyAttendant_")){
					bmUsers.setDescription("");
					bmUsers.setDescription2("");
				}
			}
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
	public List<LadderCommentVO> selectComments(LadderCommentVO cmtVO) throws Exception {
		List<LadderCommentVO> comments = ezLadderDAO.selectComments(cmtVO);
		
		String lang = commonUtil.getMultiData(cmtVO.getLang(), cmtVO.getTenant_id());
		for(LadderCommentVO cmt : comments) {
			String datdStr = commonUtil.getDateStringInUTC(cmt.getWriteDate(), cmtVO.getOffset(), false);
			cmt.setWriteDate(datdStr);
			
			if(lang.equals("2")) {
				cmt.setUserName(cmt.getUserName2());
			}
		}
		
		return comments;
	}
	
	@Override
	public LadderCommentVO selectComment(LadderCommentVO cmtVO) throws Exception {
		LadderCommentVO retCmtVO = ezLadderDAO.selectComment(cmtVO);
		
		String dataStr = commonUtil.getDateStringInUTC(retCmtVO.getWriteDate(), cmtVO.getOffset(), false);
		retCmtVO.setWriteDate(dataStr);
		
		String lang = commonUtil.getMultiData(cmtVO.getLang(), cmtVO.getTenant_id());
		if(lang.equals("2")) {
			retCmtVO.setUserName(retCmtVO.getUserName2());
		}
		
		return retCmtVO;
	}

	@Override
	public void insertComment(LadderCommentVO cmtVO) throws Exception {
		ezLadderDAO.insertComment(cmtVO);
	}

	@Override
	public void updateComment(LadderCommentVO cmtVO) throws Exception {
		ezLadderDAO.updateComment(cmtVO);
	}

	@Override
	public void deleteComment(LadderCommentVO cmtVO) throws Exception {
		ezLadderDAO.deleteComment(cmtVO);
	}

	@Override
	public void changePreLadderList(LadderOrderVO ladOrders) throws Exception {
		int len = 0;
		Map<String, String> orders = new HashMap<String, String>();
		
		List<String> ladId1 = new ArrayList<String>(Arrays.asList(ladOrders.getLadderIds()));
		List<String> ladId2 = new ArrayList<String>(Arrays.asList(ladOrders.getChangeLadderIds()));
		
		List<LadderOrderVO> oldLadOrder = ezLadderDAO.selectChangePreList(ladOrders);
		len = oldLadOrder.size();
		for(LadderOrderVO oldVO : oldLadOrder) {
			orders.put(String.valueOf(oldVO.getChangeLadderId()), String.valueOf(oldVO.getLadderId()));
		}
		
		len = ladId1.size();
		String [] chids = new String [2]; // changeid 
		String [] tmpids = new String [2]; // ladderid (originid)
		for(int i = 0; i < len; i++) {
			chids[0] = ladId1.get(i); 
			chids[1] = ladId2.get(i);
			
			for(int j = 0; j < chids.length; j++) { 
				if(!orders.containsKey(chids[j])) { // key: changeladderid, value: ladderid
					orders.put(chids[j], "");
					tmpids[j] = chids[j];
				} else {
					tmpids[j] = orders.get(chids[j]); 
				}
			}
			
			orders.replace(chids[0], tmpids[1]);
			orders.replace(chids[1], tmpids[0]);
		}
		
		ezLadderDAO.deleteChangePreList(ladOrders);
		
		for(String key : orders.keySet()) {
			if(!key.equals(orders.get(key))) {
				ladOrders.setLadderId(Integer.parseInt(orders.get(key)));
				ladOrders.setChangeLadderId(Integer.parseInt(key));
				ezLadderDAO.insertChangePreList(ladOrders);
			}
		}
	}

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
		
		if (lang.equals("2")) {
			vo.setWriterName(vo.getWriterName2());
			vo.setDeptName(vo.getDeptName2());
		}
		
		logger.debug("getLadderGame ended.");
		return vo;
	}
	
	@Override
	public List<LadderLineVO> getLadderLineParticipant(LadderVO ladVO, String mode, String back) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		logger.debug("getLadderLineParticipant started.");
		String lang = commonUtil.getMultiData(ladVO.getLang(), ladVO.getTenant_id());
		map.put("ladderId", ladVO.getLadderId());
		map.put("tenantId", ladVO.getTenant_id());
		map.put("lang", lang);
		List<LadderLineVO> list = ezLadderDAO.ladderGameParticipant(map);
		
		// 퇴사자 처리
		if(mode.equals("pre") && !back.equals("back")) {
			List<String> allUser = ezLadderDAO.getTblUserMaster(map);
			for(int i=0; i<list.size(); i++) {	
				String temp = list.get(i).getUserId();
				if(temp.length()>14 ) {
					if(!temp.substring(0, 14).equals("anonyAttendant")) {	// 익명 참여자가 아니고
						if(!allUser.contains(temp)){	// 퇴직자(임시퇴직 포함) 일 경우
							list.remove(i--);
						}
					}
				} else {
					if(!allUser.contains(temp)){	// 퇴직자(임시퇴직 포함)일 경우
						list.remove(i--);
					}
				}
			}
		}
		
		if(lang.equals("2")) {
			for(LadderLineVO userVO : list) {
				userVO.setUserName(userVO.getUserName2());
				userVO.setResultUserName(userVO.getResultUserName2());
			}
		}
		
		logger.debug("getLadderLineParticipant ended.");
		return list;
	}

	@Override
	public void deleteLadderList(LadderVO ladVO) throws Exception {
		logger.debug("deleteLadder started.");			// 사다리 1개 삭제
		String deleteDate = commonUtil.getTodayUTCTime("");	// deleteDate UCT 타임 설정
	
		Map<String,Object> map = new HashMap<String, Object>();	
		map.put("userId", ladVO.getUserId());
		map.put("ladderId", ladVO.getLadderId());
		map.put("tenantId", ladVO.getTenant_id());
		map.put("deleteDate", deleteDate);
		map.put("companyID", ladVO.getCompanyID());
		
		ezLadderDAO.deleteLadderList(map);
		
		logger.debug("deleteLadder ended.");
	}

	@Override
	public void setUserOrder(LadderVO ladVO, String firstUser, String secondUser, int firstUserOrder, int secondUserOrder,
			String firstItem, String secondItem) throws Exception {
		logger.debug("setUserOrder started.");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("LadderId", ladVO.getLadderId());
		map.put("tenant_id", ladVO.getTenant_id());
		
		map.put("origUser", firstUser);
		map.put("origOrder", firstUserOrder);
		map.put("changeOrder", secondUserOrder);
		map.put("changeItem", secondItem);
		ezLadderDAO.setUserOrder(map);
		
		map.put("origUser", secondUser);
		map.put("origOrder", secondUserOrder);
		map.put("changeOrder", firstUserOrder);
		map.put("changeItem", firstItem);
		ezLadderDAO.setUserOrder(map);
		logger.debug("setUserOrder started.");
	}

	@Override
	public void setLadderStart(LadderVO ladVO, int size) throws Exception {
		logger.debug("setLadderStart started.");	// lang 추가 해줘야 됨
		// lineCnt를 이용해 lineArray를 구함
		int height = 40;
		int lineCnt = ladVO.getLineCnt();
		int[] lineArray = new int[lineCnt];
		int[] lineMap = new int[size*height];
		lineArray = getLineArray(size, lineCnt);
		lineMap= getLine(size, lineArray);
		String line="";
		for(int i =0; i<lineMap.length; i++) {
			line += Integer.toString(lineMap[i]);
		}
		String langs = commonUtil.getMultiData(ladVO.getLang(), ladVO.getTenant_id());
		String startDate = commonUtil.getTodayUTCTime("");	// startDate UCT 타임 설정
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("ladderId", ladVO.getLadderId());
		map.put("tenantId", ladVO.getTenant_id());
		map.put("startDate", startDate);
		map.put("lineArray", line);
		map.put("lang", langs);
		ezLadderDAO.updateLadderStart(map);		// startDate, lineArray 업데이트
		
		
		List<LadderLineVO> list = ezLadderDAO.ladderGameParticipant(map);	// 사다리 라인 배열
		if(langs.equals("2")) {
			for(LadderLineVO userVO : list) {
				userVO.setUserName(userVO.getUserName2());
				userVO.setResultUserName(userVO.getResultUserName2());
			}
		}
		
		int cnt = 0;
		int[][] generateLine = new int[height][size];		// 지도 생성
		for (int i = 0; i < height; i++) {
			for (int j = 0; j < size; j++) {
				generateLine[i][j] = lineMap[cnt];
				cnt++;
			}
		}

		int[] load = new int[size];							// 방문 결과 배열에 넣기
		for (int i = 0; i < size; i++) {
			int a = visitLadder(generateLine, i);
			load[a] = i; 
		}
	
		for (int i = 0; i < size; i++) {
			Map<String, Object> m = new HashMap<String, Object>();
			m.put("ladderId", ladVO.getLadderId());
			m.put("tenant_id", ladVO.getTenant_id());
			m.put("ladderOrder", i);
			m.put("resultUserId", list.get(load[i]).getUserId());
			m.put("resultUserName", list.get(load[i]).getUserName());
			m.put("resultUserName2", list.get(load[i]).getUserName2());
			ezLadderDAO.updateLadderResult(m);
		}
		
		logger.debug("setLadderStart ended.");
	}
	
	/**
	 * 사다리 그려줄 선 고르기
	 */
	public int[] getLineArray(int size, int lineCnt) {
		// height를 일단 10으로 통일함. 추후 height를 사용자 수(size)에 따라 유동적으로 줄지는 논의 필요
		int height=40;
		logger.debug("getLineArray started.");
		logger.debug("size : " + size);
		logger.debug("lineCnt : " + lineCnt);
		Random random = new SecureRandom();
		int[] choice = new int[lineCnt];// 선택된 선 번호
	
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
		}
		logger.debug("getLineArray ended.");
		return choice;
	}

	/**
	 * 사다리 방향성 넣어주기
	 */
	public int[] getLine(int size, int[] lineArray) {
		logger.debug("getLine started.");
		// height를 일단 10으로 통일함. 추후 height를 사용자 수(size)에 따라 유동적으로 줄지는 논의 필요
		int height = 40;

		int[] line = new int[size * height];
		for (int i = 0; i < lineArray.length; i++) {
			int temp = lineArray[i];
			temp = (temp / (size - 1)) * size + temp % (size - 1);
			line[temp] = 1;
			line[temp + 1] = 2;
		}
		logger.debug("getLine ended.");
		return line;
	}
	
	/**
	 * 방문한 사다리 넣기
	 */
	public int visitLadder(int[][] ladder, int start) {
		int dest = -1;
		int cursorX = start;
		int cursorY = 0;
		if (start < ladder[0].length) {
			while (cursorY < ladder.length) {
				if (ladder[cursorY][cursorX] == 1) {	// 1 우회전
					cursorX++;
				} else if (ladder[cursorY][cursorX] == 2) {	// 2 좌회전
					cursorX--;
				}
				cursorY++;
			}
			dest = cursorX;
		}
		return dest;
	}
	
	/**
	 * 사다리 참여 메일 보내기
	 */
	public void sendLadderMail(LadderVO lad, LadderLineVO ladLines, String logCookie, int len) throws Exception {

		LoginVO userInfo = commonUtil.userInfo(logCookie);	
	
		int cnt = 0;
		String[] receiverID = new String[len];
		String[] receiverName = new String[len];
		for(int i=0; i<len; i++) {
			boolean jungBock = false;
			if(ladLines.getUserIds()[i].length()>=15) {		// 익명참여자의 아이디가 anoyAttendant로 시작해서 구분해주기 위해
				if(!ladLines.getUserIds()[i].substring(0,15).equals("anonyAttendant_")){
					for(int checkCnt = 0; checkCnt<cnt; checkCnt++) {
						if(receiverID[checkCnt].equals(ladLines.getUserIds()[i])){
							jungBock = true;
							break;
						}
					}
					if(jungBock == true) {
						continue;
					}
					receiverID[cnt] = ladLines.getUserIds()[i];
					receiverName[cnt] = ladLines.getUserNames()[i];
					cnt++;
				}
			} else { // 참여자
				for(int checkCnt = 0; checkCnt<cnt; checkCnt++) { 
					if(receiverID[checkCnt].equals(ladLines.getUserIds()[i])){
						jungBock = true;
						break;
					}
				}
				if(jungBock == true) {
					continue;
				}
				receiverID[cnt] = ladLines.getUserIds()[i];
				receiverName[cnt] = ladLines.getUserNames()[i];
				cnt++;
			}
		}

		String subject = egovMessageSource.getMessage("ezLadder.t096", userInfo.getLocale());	// 메일제목
		StringBuilder bodyContent = new StringBuilder("");	// 메일 링크
		bodyContent.append(" " + egovMessageSource.getMessage("ezLadder.t003", userInfo.getLocale()) + " : " + "<span style=\"color:blue;cursor:pointer;\"><a id='ladder_a' href='/ezLadder/getLadderGame.do?ladderId=" + lad.getLadderId() + "'>" + commonUtil.cleanValue(lad.getTitle()) + "</a></span></br>");
		bodyContent.append(" " + egovMessageSource.getMessage("ezLadder.t004", userInfo.getLocale()) + " : " + userInfo.getDisplayName());
				
		String content = commonUtil.createNotiMailContent(bodyContent.toString(), userInfo.getTenantId(), userInfo.getLocale());
		
		// 참여자에게 메일 발송
		InternetAddress from = new InternetAddress();
		from.setPersonal(userInfo.getDisplayName(), "UTF-8");
		from.setAddress(userInfo.getEmail());
		InternetAddress[] toArr = new InternetAddress[cnt];
		
		for (int i=0; i<cnt; i++) {
			OrganUserVO AccessUserInfo = ezOrganAdminService.getUserInfo(receiverID[i].trim(), userInfo.getPrimary(), userInfo.getTenantId());
						
			InternetAddress to = new InternetAddress();
			to.setPersonal(receiverName[i].trim(), "UTF-8");
			to.setAddress(AccessUserInfo.getMail());
			toArr[i] = to;
		}
		ezEmailService.sendMail(logCookie, from, toArr, null, null, subject, content, false);
	}
}
