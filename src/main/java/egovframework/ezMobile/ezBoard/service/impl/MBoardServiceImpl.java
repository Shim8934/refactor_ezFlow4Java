package egovframework.ezMobile.ezBoard.service.impl;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Properties;
import java.util.Set;
import java.util.StringJoiner;

import javax.annotation.Resource;

import egovframework.ezEKP.ezBoard.vo.BoardPropertyVO;
import egovframework.let.utl.fcc.service.EzFAL;
import org.apache.commons.io.FileUtils;
import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.json.simple.JSONObject;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.interceptor.TransactionAspectSupport;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezBoard.service.EzBoardAdminService;
import egovframework.ezEKP.ezBoard.service.EzBoardService;
import egovframework.ezEKP.ezBoard.vo.BoardVO;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.ezMobile.ezBoard.dao.MBoardDAO;
import egovframework.ezMobile.ezBoard.service.MBoardService;
import egovframework.ezMobile.ezBoard.vo.MBoardAttachVO;
import egovframework.ezMobile.ezBoard.vo.MBoardFavoriteVO;
import egovframework.ezMobile.ezBoard.vo.MBoardInfoVO;
import egovframework.ezMobile.ezBoard.vo.MBoardItemVO;
import egovframework.ezMobile.ezBoard.vo.MBoardListHeaderVO;
import egovframework.ezMobile.ezBoard.vo.MBoardListVO;
import egovframework.ezMobile.ezBoard.vo.MBoardNewListVO;
import egovframework.ezMobile.ezBoard.vo.MBoardTreeVO;
import egovframework.ezMobile.ezOption.service.MOptionService;
import egovframework.ezMobile.ezOption.vo.MCommonVO;
import egovframework.ezMobile.ezOption.vo.MOptionVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.fcc.service.EgovDateUtil;

@Service("MBoardService")
public class MBoardServiceImpl extends EgovAbstractServiceImpl implements MBoardService {
	private static final Logger logger = LoggerFactory.getLogger(MBoardServiceImpl.class);
	
	final public int mobileListSize = 20;
	final public String newBoardID = "{FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF}";
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Resource(name = "MBoardDAO")
	private MBoardDAO mBoardDAO;
	
	@Resource(name = "EzBoardAdminService")
	private EzBoardAdminService ezBoardAdminService;
	
	@Resource(name = "EzBoardService")
	private EzBoardService ezBoardService;
	
	@Resource(name = "EzOrganService")
	private EzOrganService ezOrganService;
	
	@Resource(name = "EzCommonService")
	private EzCommonService ezCommonService;
	
	@Resource(name = "MOptionService")
	private MOptionService mOptionService;
	
	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;
	
	@Override
	public List<MBoardListHeaderVO> getListHeader(MBoardInfoVO mBoardInfoVO, String lang, int tenantID) throws Exception {
		logger.debug("getListHeader started.");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("boardID", mBoardInfoVO.getBoardID());
		map.put("listType", mBoardInfoVO.getBoardType());
		map.put("lang", lang);
		map.put("tenantID", tenantID);
		
		//모바일은 확장컬럼미사용으로 개발
		List<MBoardListHeaderVO> list = mBoardDAO.getListHeader(map);
		
		logger.debug("getListHeader ended.");
		
		return list;
	}
	
	/* 2020-04-13 홍승비 - QNA게시판 대응하도록 수정 */
	@Override
	public List<MBoardItemVO> getBoardItemList(MBoardInfoVO mBoardInfoVO, MCommonVO info, String lastDate,String userID,String add, String pSearchText, String parentWriteDate, String upperitemidtree) throws Exception {
		logger.debug("getBoardItemList started.");
		
		String boardID = mBoardInfoVO.getBoardID();
		String gubun = mBoardInfoVO.getGuBun();
		int page = mBoardInfoVO.getPage() != 0 ? mBoardInfoVO.getPage() : 1; 
		
		String offset = info.getOffSet();
		int tenantID = info.getTenantId();
		
		List<MBoardItemVO> mBoardNoticeItemList = getNoticePostItemList(boardID, userID, gubun, page, tenantID, offset);
		
		//임시로 10으로 지정
		int listSize = 50;
		int boardCount = 0;
		List<MBoardItemVO> mBoardItemList;
		
		if (gubun != null && gubun.equals("5")) { // qna게시판
			boardCount = getQNABoardItemListCount(boardID, mBoardInfoVO, userID, gubun, tenantID, pSearchText);
			mBoardItemList = getQNABoardItemList(boardID, mBoardInfoVO, userID, gubun, listSize, boardCount, lastDate,tenantID, offset, pSearchText, parentWriteDate, upperitemidtree);
		} else {
			boardCount = getBoardItemListCount(boardID, userID, gubun, tenantID,pSearchText, mBoardInfoVO.getVersionManage());
			mBoardItemList = getBoardItemList(boardID, userID, gubun, listSize, boardCount, lastDate,tenantID, offset, pSearchText, parentWriteDate, upperitemidtree, mBoardInfoVO.getVersionManage());
		}
		
		//게시물 writeDate와 현재시간을 비교해서 게시한지 하루 이전의 게시물은 newItemFlag Y로 set
		String nowDate = commonUtil.getTodayUTCTime("");
	    nowDate = EgovDateUtil.addDay(nowDate, -1, "yyyy-MM-dd HH:mm:ss");
		for (MBoardItemVO vo : mBoardItemList) {
			if (vo.getWriteDate().toString().compareTo(nowDate) > 0) {
				vo.setNewItemFlag("Y");
			} else {
				vo.setNewItemFlag("N");
			}
		}
		//NoticeItemList가  거꾸로  mBoardItemList 에 add 되므로 추가
		Collections.reverse(mBoardNoticeItemList);
		
		//스크롤 페이징할 때 공지사항 추가 안되게 add를 받아옴
		if ((add == null || add.equals("")) && (pSearchText == null || pSearchText.equals(""))) {
			for (MBoardItemVO vo : mBoardNoticeItemList) {
				mBoardItemList.add(0, vo);
			}
		}
		
		logger.debug("getBoardItemList ended.");
		
		return mBoardItemList;
	}


	// 현재 주석처리되어 미사용
	@Override
	public List<MBoardNewListVO> getNewBoarditemList(MBoardInfoVO mBoardInfoVO, MCommonVO info, String userID,String pSearchText, String parentWriteDate, String upperitemidtree) throws Exception {
		logger.debug("getNewBoarditemList started");
		
		String boardID = mBoardInfoVO.getBoardID();
		String gubun = mBoardInfoVO.getGuBun();
		int page = mBoardInfoVO.getPage() != 0 ? mBoardInfoVO.getPage() : 1; 
		
		String offset = info.getOffSet();
		int tenantID = info.getTenantId();
		
		/** 공지사항 카운트 및 리스트 */
		Integer noticeCount = 0;
		if (((gubun == null || !gubun.equals("2") || !gubun.equals("3")) ? "1" : gubun).equals("1")) {
			noticeCount = getNoticePostItemListCount(boardID, userID, gubun, tenantID);
		}
		
		/** 전체 리스트 카운트 및 리스트 */
		int startRow = ((mobileListSize * (page - 1)) - noticeCount) + 1;
        int endRow = (mobileListSize * page) - noticeCount;
		
        int boardCount = getBoardItemListCount(boardID, userID, gubun, tenantID,pSearchText, mBoardInfoVO.getVersionManage());
        
        List<MBoardNewListVO> mBoardItemList = getNewBoardItemList(boardID, userID, gubun, startRow, endRow, boardCount, tenantID, offset, pSearchText, parentWriteDate, upperitemidtree);
        
        logger.debug("getNewBoarditemList ended");
		return mBoardItemList;
	}
	
	/* 2019-06-12 홍승비 - 게시판 권한 체크 시 사내겸직의 상위부서까지 전부 체크하도록 수정 */
	@Override
	public MBoardInfoVO getBoardInfo(MBoardInfoVO mBoardInfoVO, String rollInfo, String deptPathCode, MCommonVO info) throws Exception {
		logger.debug("getBoardInfo started");
		
		mBoardInfoVO.setSs_board_maxRows(mobileListSize);
		mBoardInfoVO.setSs_searchBoard_maxRows(mobileListSize);

		String guBun = mBoardInfoVO.getGuBun();
		String boardID = mBoardInfoVO.getBoardID();
		String boardGroupID = mBoardInfoVO.getBoardGroupID();
		
	    String deptPath = deptPathCode;
		StringBuilder deptPathOrgan = new StringBuilder();
		List<String> addJobDeptList = new ArrayList<String>();
		
		/* 2019-09-25 홍승비 - 개인ID 이후, 부서ID 이전 위치에 직위+직책ID (사내겸직 직위 포함) 추가 */
		String userJJID = ezBoardService.getUserJJID(info.getUserId(), info.getCompanyId(), info.getTenantId());
		
		for (int ch = 0; ch < deptPath.split(",").length; ch++) {
			if (ch == 0) { // 0 : userID
				deptPathOrgan.append(deptPath.split(",")[ch].trim());
				deptPathOrgan.append(",").append(userJJID);
			} else {
				deptPathOrgan.append(",").append(deptPath.split(",")[deptPath.split(",").length - (ch)].trim());
			}
		}
		
		// 권한 AccessID 체크 시 'everyone' 제거 (사용하지 않는 ID)
		String userDeptPath = deptPathOrgan.toString();
		addJobDeptList.add(userDeptPath);
		
		/* 2019-05-29 홍승비 - 현재 소속 회사의 사내겸직이 존재하면 사내겸직부서ID와 그 상위부서ID까지 권한체크에 포함하도록 수정 */
		List<String> addJobList = getPDOAddJobDeptID(info.getUserId(), info.getCompanyId(), info.getTenantId());
		StringJoiner addJobStr = new StringJoiner(",");
		addJobStr.add(info.getDeptId());
		if (addJobList != null && addJobList.size() > 0) {
			for (int i = 0; i < addJobList.size(); i++) {
				addJobStr.add(addJobList.get(i));
				// 각 사내겸직부서ID에 대해 상위부서 ~ 회사ID를 전부 가져오는 루프 (Top까지 전부 가져오도록 한다.)
				String upperDept = getUpperDeptID(addJobList.get(i), info.getTenantId());
				
				if (upperDept != null && !upperDept.equals("")) {
					
					boolean loopContinue = true;
					StringJoiner upperDeptStr = new StringJoiner(",");
					upperDeptStr.add(upperDept);
					
					while (loopContinue) {
						String upperDeptLoop = getUpperDeptID(upperDept, info.getTenantId());
						// 각 사내겸직의 최상위에 도달하면 루프 종료
						if (upperDeptLoop != null && !upperDeptLoop.equals("")) {
							upperDeptStr.add(upperDeptLoop);
							upperDept = upperDeptLoop;
						} else {
							loopContinue = false;
						}
					}
					addJobDeptList.add(addJobList.get(i) + "," + upperDeptStr.toString());
				}
			}
		}
		
		/* 2019-06-12 홍승비 - 게시판그룹의 관리자권한 체크를 위한 쿼리 파라미터 추가(게시판그룹의 관리자권한과 하위게시판의 관리자권한 혼용 방지) */
		boolean isBoardGroup = false;
		MBoardInfoVO orgBoardProp = getBoardProperty(boardID, info.getPrimary(), info.getTenantId(), info.getUserId());
		if (orgBoardProp != null) {
			if (orgBoardProp.getBoardGroupID() != null && !orgBoardProp.getBoardGroupID().equals("")) { // 하위게시판
				isBoardGroup = false;
			} else { // 게시판그룹
				isBoardGroup = true;
			}
		}
		
		List<MBoardInfoVO> boardACLListDept = new ArrayList<MBoardInfoVO>();
		List<MBoardInfoVO> boardACLListJJ = new ArrayList<MBoardInfoVO>();
		Set<String> userJJIDSet = new HashSet<String>(Arrays.asList(userJJID.split(",")));
		
		boolean isUserHasACL = false;
		String tempDeptList = addJobStr.toString();
		int addJobDeptListSize = addJobDeptList.size();
		for (int jl = 0; jl < addJobDeptListSize; jl++) {
			// 개인 권한이 존재하지 않는 경우에만 부서 경로에 대해 권한체크 루프
			if (isUserHasACL == false) {
				int addJobDeptListPathSize = addJobDeptList.get(jl).split(",").length;
				for (int i = 0; i < addJobDeptListPathSize; i++) {
					int isEqualDept = 0;
					for (int j = 0; j < tempDeptList.split(",").length; j++) {
						if(addJobDeptList.get(jl).split(",")[i].trim().equalsIgnoreCase(tempDeptList.split(",")[j])) {
							isEqualDept = 1;
							break;
						} else {
							isEqualDept = 0;
						}
					}
					
					int isDept = isDeptChk(addJobDeptList.get(jl).split(",")[i].trim(), info.getTenantId());
					
					/* 2019-09-25 홍승비 - 동일한 ACCESSID에 대해 리스트로 리턴된 권한을 '허용'권한 기준으로 취합 */
					// 개인 - 직위/직책 - 부서/회사 순으로 우선순위가 적용되고, 각 루프에서 가장 우선순위가 높은 권한을 찾으면 다음 루프로 빠져나감
					MBoardInfoVO boardInfoTempNew = new MBoardInfoVO();
					List<MBoardInfoVO> boardInfoTempList = getACLListNew(boardID, addJobDeptList.get(jl).split(",")[i].trim(), info.getTenantId(), isDept, isEqualDept);
					if (boardInfoTempList != null && boardInfoTempList.size() > 0) {
						boardInfoTempNew = sumBoardACL(boardInfoTempList, boardInfoTempNew);
					}
					
					/* 2019-09-25 홍승비 - 권한그룹을 포함하여 게시판그룹 관리자권한 체크 */
					// 권한그룹 적용 시 개인권한이 다수 존재 가능하므로, 권한을 리스트로 가져온 뒤 '허용(OK)'기준으로 취합한다.
					String boardGroupAdmin_FG_New = "";
					List<String> boardGroupAdmin_FG_List = ezBoardService.checkIfBoardGroupAdminNew(boardID, addJobDeptList.get(jl).split(",")[i].trim(), info.getTenantId(), isDept, isEqualDept, isBoardGroup);
					if (boardGroupAdmin_FG_List != null && boardGroupAdmin_FG_List.size() > 0) { // 권한이 없으면 공백값을 유지 > 다음 루프 진행
						if (boardGroupAdmin_FG_List.contains("OK")) { // 동일한 우선순위의 권한에 대해서, OK가 하나라도 존재한다면 OK로 판정
							boardGroupAdmin_FG_New = "OK";
						} else {
							boardGroupAdmin_FG_New = "NO";
						}
					}
					
					// 사원 개인에 대해 권한이 존재한다면 바로 빠져나오고 해당 권한 그대로 사용함 (최우선순위 권한)
					if (boardInfoTempList != null && boardInfoTempList.size() > 0) {
						boardInfoTempNew.setBoardGroupAdmin_FG(boardGroupAdmin_FG_New);
						
						if (addJobDeptList.get(jl).split(",")[i].trim().equals(info.getUserId())) {
							mBoardInfoVO.setAccessID(boardInfoTempNew.getAccessID());
							mBoardInfoVO.setAccessLevel(boardInfoTempNew.getAccessLevel());
							mBoardInfoVO.setAccess_(boardInfoTempNew.getAccess_());
							mBoardInfoVO.setBoardGroupAdmin_FG(boardInfoTempNew.getBoardGroupAdmin_FG());
							mBoardInfoVO.setBoardAdmin_FG(boardInfoTempNew.getBoardAdmin_FG());
							mBoardInfoVO.setListView_FG(boardInfoTempNew.getListView_FG());
							mBoardInfoVO.setRead_FG(boardInfoTempNew.getRead_FG());
							mBoardInfoVO.setWrite_FG(boardInfoTempNew.getWrite_FG());
							mBoardInfoVO.setReply_FG(boardInfoTempNew.getReply_FG());
							mBoardInfoVO.setDelete_FG(boardInfoTempNew.getDelete_FG());
							mBoardInfoVO.setInherit_FG(boardInfoTempNew.getInherit_FG());
							mBoardInfoVO.setBoardGroupACL(boardInfoTempNew.getBoardGroupACL());
							isUserHasACL = true;
							break;
						}
						else if (userJJIDSet.contains(addJobDeptList.get(jl).split(",")[i].trim())) { // 직위, 직책 권한
							boardACLListJJ.add(boardInfoTempNew);
							isUserHasACL = false;
							// 직위, 직책은 게시판그룹의 관리자권한 레코드를 전부 찾을때까지 break 하지 않는다.
						}
						else { // 부서, 회사의 권한
							boardACLListDept.add(boardInfoTempNew);
							isUserHasACL = false;
							break;
						}
					}
					else if (!boardGroupAdmin_FG_New.equals("")) { // 하위게시판에는 권한이 없고, 게시판그룹에 관리자권한이 존재하는 경우
						MBoardInfoVO boardGroupAdminFG = new MBoardInfoVO();
						if (boardGroupAdmin_FG_New.equals("OK")) {
							boardGroupAdminFG.setBoardGroupAdmin_FG("OK");
							boardGroupAdminFG.setAccess_("1");
							
							// 게시판그룹의 관리자 권한이 '허용'인 경우에만 추가하도록 한다.
							if (addJobDeptList.get(jl).split(",")[i].trim().equals(info.getUserId())) { // 개인의 게시판그룹 관리자 권한
								// 개인에 대하여 게시판그룹의 관리자 권한이 존재하므로, 루프를 벗어난다.
								mBoardInfoVO.setBoardGroupAdmin_FG(boardGroupAdmin_FG_New);
								isUserHasACL = true;
								break; // 게시판그룹의 관리자 권한이 '허용'인 경우에만 루프를 break시킨다.
							}
							else if (userJJIDSet.contains(addJobDeptList.get(jl).split(",")[i].trim())) { // 직위, 직책의 게시판그룹 관리자  권한
								boardGroupAdminFG.setAccessID(addJobDeptList.get(jl).split(",")[i]);
								boardACLListJJ.add(boardGroupAdminFG);
							}
							else { // 부서, 회사의 게시판그룹 관리자  권한
								boardGroupAdminFG.setAccessID(addJobDeptList.get(jl).split(",")[i]);
								boardACLListDept.add(boardGroupAdminFG);
								break;
							}
						} else {
							boardGroupAdminFG.setBoardGroupAdmin_FG("NO");
						}
					}
				}
			}
		}
		
		if (isUserHasACL == false) { // 개인 권한이 존재하지 않는 경우에만 권한 취합
			if (boardACLListJJ.size() > 0) { // 직위, 직책권한 부여
				mBoardInfoVO = sumBoardACL(boardACLListJJ, mBoardInfoVO);
			} else if (boardACLListDept.size() > 0) { // 직위, 직책권한이 없다면 부서권한 부여
				mBoardInfoVO = sumBoardACL(boardACLListDept, mBoardInfoVO);
			} else { // 개인, 직위, 직책, 부서 모두 없는 경우 비회원 권한(전체공개) 체크
				String useBoardGuestPermit = ezCommonService.getTenantConfig("useBoardGuestPermit", info.getTenantId());
				if ("YES".equals(useBoardGuestPermit) && ezBoardService.checkGuestPerm(boardID, info.getTenantId(), "B")) {
					mBoardInfoVO.setAccess_("1");
					mBoardInfoVO.setAccess_FG("1");
					mBoardInfoVO.setBoardAdmin_FG("false");
					mBoardInfoVO.setListView_FG("true");
					mBoardInfoVO.setRead_FG("true");
					mBoardInfoVO.setWrite_FG("false");
					mBoardInfoVO.setReply_FG("false");
					mBoardInfoVO.setDelete_FG("false");
				}
			}
		}
		
		/* 2018-10-26 홍승비 - 게시판의 그룹게시판이 구분값 99인지 확인하여 게시판 boardInfo에 isAllGroupBoard값 셋팅 */
		mBoardInfoVO.setIsAllGroupBoard("");
		if (boardGroupID != null) {
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("boardID", boardGroupID);
			map.put("primary", info.getPrimary());
			map.put("tenantID", info.getTenantId());
			
			MBoardInfoVO strGroupProp = mBoardDAO.getBoardProperty(map);
			if (strGroupProp.getGuBun() != null && strGroupProp.getGuBun().equals("99")) {
				mBoardInfoVO.setIsAllGroupBoard("Y");
			} else {
				mBoardInfoVO.setIsAllGroupBoard("N");
			}
		} else if (guBun != null && guBun.equals("99")) { // 현재 접근한 게시판이 게시판 그룹인 경우
			mBoardInfoVO.setIsAllGroupBoard("Y");
		} else {
			mBoardInfoVO.setIsAllGroupBoard("N");
		}
		if (orgBoardProp.getUseKeyword() != null) {
			mBoardInfoVO.setUseKeyword(orgBoardProp.getUseKeyword());
		}
		
	    if (mBoardInfoVO.getBoardID().equals("{FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF}") || mBoardInfoVO.getBoardID().equals("{YYYYYYYY-YYYY-YYYY-YYYY-YYYYYYYYYYYY}") || mBoardInfoVO.getBoardID().equals("{ZZZZZZZZ-ZZZZ-ZZZZ-ZZZZ-ZZZZZZZZZZZZ}")) {
	    	mBoardInfoVO.setAccess_("1");
	    	mBoardInfoVO.setAccess_FG("1");
	    	mBoardInfoVO.setBoardAdmin_FG("false");
	    	mBoardInfoVO.setListView_FG("true");
	    	mBoardInfoVO.setRead_FG("true");
	    	mBoardInfoVO.setWrite_FG("true");
	    	mBoardInfoVO.setReply_FG("true");
	    	mBoardInfoVO.setDelete_FG("true");
		}
	    /* 회사관리자, 게시관리자들은 '그룹사게시판이 아닌 경우에만' 고정된 관리자 권한을 갖는다. 전체관리자는 전부 관리자로 허용된다.*/
	    else if (commonUtil.isAdmin(info.getUserId(), info.getTenantId(), rollInfo, "c") ||
				(!mBoardInfoVO.getIsAllGroupBoard().equals("Y") && commonUtil.isAdmin(info.getUserId(), info.getTenantId(), rollInfo, "n;k"))) {
	    	mBoardInfoVO.setAccess_("1");
	    	mBoardInfoVO.setAccess_FG("1");
			mBoardInfoVO.setBoardAdmin_FG("true");
			mBoardInfoVO.setListView_FG("true");
			mBoardInfoVO.setRead_FG("true");
			mBoardInfoVO.setWrite_FG("true");
			mBoardInfoVO.setReply_FG("true");
			mBoardInfoVO.setDelete_FG("true");
		} else if (mBoardInfoVO.getBoardGroupAdmin_FG() != null && mBoardInfoVO.getBoardGroupAdmin_FG().equals("OK")) {
			mBoardInfoVO.setAccess_("1");
			mBoardInfoVO.setAccess_FG("1");
			mBoardInfoVO.setBoardAdmin_FG("true");
			mBoardInfoVO.setListView_FG("true");
			mBoardInfoVO.setRead_FG("true");
			mBoardInfoVO.setWrite_FG("true");
			mBoardInfoVO.setReply_FG("true");
			mBoardInfoVO.setDelete_FG("true");
		} else if (mBoardInfoVO.getBoardAdmin_FG() == null || mBoardInfoVO.getBoardAdmin_FG().equals("")) {
			mBoardInfoVO.setAccess_("1");
			mBoardInfoVO.setAccess_FG("1");
			mBoardInfoVO.setBoardAdmin_FG("false");
			mBoardInfoVO.setListView_FG("false");
			mBoardInfoVO.setRead_FG("false");
			mBoardInfoVO.setWrite_FG("false");
			mBoardInfoVO.setReply_FG("false");
			mBoardInfoVO.setDelete_FG("false");
		}
	    
	    logger.debug("boardInfo before ended    ::   BoardGroupAdmin_FG=" + mBoardInfoVO.getBoardGroupAdmin_FG() + " | BoardAdmin_FG=" + mBoardInfoVO.getBoardAdmin_FG()  + " | Access_=" + mBoardInfoVO.getAccess_()
				+ " | ListView_FG=" + mBoardInfoVO.getListView_FG() + " | Read_FG=" + mBoardInfoVO.getRead_FG() + " | Write_FG=" + mBoardInfoVO.getWrite_FG()
				+ " | Reply_FG=" + mBoardInfoVO.getReply_FG() + " | Delete_FG=" + mBoardInfoVO.getDelete_FG());
	    logger.debug("getBoardInfo ended");
		return mBoardInfoVO;
	}

	@Override
	public MBoardInfoVO getBoardProperty(String boardID, String primary, int tenantID, String userID) throws Exception {
		logger.debug("getBoardProperty started.");
		logger.debug("boardID = " + boardID + " || primary = " + primary + " || tenantID = " + tenantID);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("boardID", boardID);
		map.put("primary", primary);
		map.put("tenantID", tenantID);
		
		MBoardInfoVO vo = mBoardDAO.getBoardProperty(map);
		MOptionVO mobileInfo = mOptionService.optionInfo(userID, tenantID);
		
		if (vo.getGuBun() != null && (vo.getGuBun().equals("4") || vo.getGuBun().equals("3"))) {
			vo.setType("photoBoardItem");
		}
		
		if (vo.getBoardID().equals("{FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF}")) {
			vo.setType("newBoardItemList");
			vo.setBoardName(egovMessageSource.getMessage("ezBoard.t480", new Locale(commonUtil.getTwoLetterLangFromLangNum(mobileInfo.getLang()))));
		} else if (vo.getBoardID().equals("{ZZZZZZZZ-ZZZZ-ZZZZ-ZZZZ-ZZZZZZZZZZZZ}")) {
			vo.setType("allBoardItemList");
			vo.setBoardName(egovMessageSource.getMessage("ezBoard.allboard.hth01", new Locale(commonUtil.getTwoLetterLangFromLangNum(mobileInfo.getLang()))));
		} else if (vo.getBoardID().equals("{YYYYYYYY-YYYY-YYYY-YYYY-YYYYYYYYYYYY}")) {
			vo.setType("recentBoardItemList");
			vo.setBoardName(egovMessageSource.getMessage("ezBoard.lyj01", new Locale(commonUtil.getTwoLetterLangFromLangNum(mobileInfo.getLang()))));
		} else {
			vo.setType("boardItemList");
		}
		
		logger.debug("getBoardProperty ended.");
		
		return vo;
	}
	
	/* 2019-06-11 홍승비 - 하위부서 허용/불가여부 체크하여 권한 가져오는 쿼리 추가 (파라미터 오버로딩) */
	public MBoardInfoVO getACL(String pBoardID, String userDeptPath, int tenantID, int isDept, int isEqualDept) throws Exception {
		logger.debug("getACL started");

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("boardID", pBoardID);
		map.put("userDeptPath", userDeptPath);
		map.put("tenantID", tenantID);
		map.put("v_ISDEPT", isDept);
		map.put("v_ISEQUALDEPT", isEqualDept);
		
		logger.debug("getACL ended");
		return mBoardDAO.getACL(map);
	}
	
	private List<MBoardItemVO> getBoardItemList(String boardID, String userID, String gubun, int listSize, int boardItemListCount, String lastDate, int tenantID, String offset, String pSearchText, String parentWriteDate, String upperitemidtree, String versionManage) throws Exception {
		logger.debug("getBoarditemList started.");
		logger.debug("boardID = " + boardID + " || userID = " + userID + " || gubun = " + gubun + " || boardItemListCount = " + boardItemListCount + " || tenantID = " + tenantID + " || lastDate = " + lastDate);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("boardID", boardID);
		map.put("userID", userID);
		map.put("gubun", (gubun == null || !gubun.equals("2") || !gubun.equals("3")) ? "1" : gubun);
		map.put("listSize", listSize);
		map.put("lastDate", lastDate);
		map.put("nowDate", commonUtil.getTodayUTCTime(""));
		map.put("offset", commonUtil.getMinuteUTC(offset));
		map.put("tenantID", tenantID);
		map.put("pSearchText", pSearchText.replace("%", "\\%").replace("_", "\\_"));
		map.put("parentWriteDate", parentWriteDate);
		map.put("upperitemidtree", upperitemidtree);
		map.put("useVersion", versionManage);
		
		MBoardInfoVO boardProp = getBoardProperty(boardID, "1", tenantID, userID);
		if (boardProp.getUseKeyword() != null && boardProp.getUseKeyword().equals("Y")) {
			map.put("useKeyword", boardProp.getUseKeyword());
		}
		
		String apprFlag = mBoardDAO.getBoardApprFlag(map);
		
		if (apprFlag != null && apprFlag.equals("Y")) {
			map.put("apprFlag", apprFlag);
		}
		
		List<MBoardItemVO> list = mBoardDAO.getBoardItemList(map);
		
		logger.debug("getBoarditemList ended.");
		
		return list;
	}
	
	private List<MBoardItemVO> getNoticePostItemList(String boardID, String userID, String gubun, int pageNum, int tenantID, String offset) throws Exception {
		logger.debug("getNoticePostItemList started");
		logger.debug("boardID = " + boardID + " || userID = " + userID + " || gubun = " + gubun + " pageNum = " + pageNum + " || tenantID = " + tenantID);
		
		int startRow = ((pageNum - 1) * mobileListSize) + 1;
	 	int endRow = (pageNum * mobileListSize); 
				
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("boardID", boardID);
		map.put("userID", userID);
		//Oracle
		map.put("startRow", startRow);
		map.put("endRow", endRow);
		//Maria
		map.put("rowCount", endRow - (startRow - 1));
		map.put("limit", startRow - 1);
		map.put("nowDate", commonUtil.getTodayUTCTime(""));
		map.put("offset", commonUtil.getMinuteUTC(offset));
		map.put("tenantID", tenantID);
		
    	String apprFlag = mBoardDAO.getBoardApprFlag(map);

		if (apprFlag != null && apprFlag.equals("Y")) {
			map.put("apprFlag", apprFlag);
		}
		
		List<MBoardItemVO> list = mBoardDAO.getNoticePostItemList(map);
		
		logger.debug("getNoticePostItemList ended.");
		
		return list;
	}
	
	private List<MBoardNewListVO> getNewBoardItemList(String boardID, String userID, String gubun, int startRow, int endRow, int boardItemListCount, int tenantID, String offset, String pSearchText, String parentWriteDate, String upperitemidtree) throws Exception {
		logger.debug("getNewBoardItemList started.");
		logger.debug("boardID = " + boardID + " || userID = " + userID + " || gubun = " + gubun + " || startRow = " + startRow + " || endRow = " + endRow + " || boardItemListCount = " + boardItemListCount + " || tenantID = " + tenantID);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("boardID", boardID);
		map.put("userID", userID);
		map.put("gubun", (gubun == null || !gubun.equals("2") || !gubun.equals("3")) ? "1" : gubun);
		map.put("nowDate", commonUtil.getTodayUTCTime(""));
		map.put("offset", commonUtil.getMinuteUTC(offset));
		map.put("tenantID", tenantID);
		map.put("pSearchText", pSearchText.replace("%", "\\%").replace("_", "\\_"));
		map.put("parentWriteDate", parentWriteDate);
		map.put("upperitemidtree", upperitemidtree);
		
		List<MBoardNewListVO> list = mBoardDAO.getNewItemList(map);
		
		logger.debug("getNewBoardItemList ended.");
		
		return list;
	}
	
	@Override
	public int getBoardItemListCount(String boardID, String userID, String gubun, int tenantID, String pSearchText, String versionManage) throws Exception {
		logger.debug("getBoardItemListCount started.");
		logger.debug("boardID = " + boardID + " || userID = " + userID + " || gubun = " + gubun + " || tenantID = " + tenantID);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("boardID", boardID);
		map.put("userID", userID);
		map.put("gubun", (gubun == null || !gubun.equals("2") || !gubun.equals("3")) ? "1" : gubun);
		map.put("nowDate", commonUtil.getTodayUTCTime(""));
		map.put("pSearchText", pSearchText.replace("%", "\\%").replace("_", "\\_"));
		map.put("tenantID", tenantID);
		map.put("useVersion", versionManage);


		MBoardInfoVO boardProp = getBoardProperty(boardID, "1", tenantID, userID);
		if (boardProp.getUseKeyword() != null && boardProp.getUseKeyword().equals("Y")) {
			map.put("useKeyword", boardProp.getUseKeyword());
		}
		
		String apprFlag = mBoardDAO.getBoardApprFlag(map);
		
		if (apprFlag != null && apprFlag.equals("Y")) {
			map.put("apprFlag", apprFlag);
		}
		
		int result = mBoardDAO.getBoardItemListCount(map);
		
		logger.debug("getBoardItemListCount ended. result = " + result);
		
		return result;
	}
	
	private int getNoticePostItemListCount(String boardID, String userID, String gubun, int tenantID) throws Exception {
		logger.debug("getNoticePostItemListCount started.");
		logger.debug("boardID = " + boardID + " || userID = " + userID + " || gubun = " + gubun + " || tenantID = " + tenantID);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("boardID", boardID);
		map.put("userID", userID);
		map.put("gubun", (gubun == null || !gubun.equals("2") || !gubun.equals("3")) ? "1" : gubun);
		map.put("nowDate", commonUtil.getTodayUTCTime(""));
		map.put("tenantID", tenantID);
		
		String apprFlag = mBoardDAO.getBoardApprFlag(map);
		
		if (apprFlag != null && apprFlag.equals("Y")) {
			map.put("apprFlag", apprFlag);
		}
		
		int result = mBoardDAO.getNoticePostItemListCount(map);
		
		logger.debug("getNoticePostItemListCount ended. result = " + result);
		
		return result;
	}

	/* 2018-07-03 홍승비 - 게시판 즐겨찾기 리스트에 companyID 조건 추가 */
	@Override
	public List<MBoardFavoriteVO> getFavoriteList(String userID, String companyID, int tenantID, String primary) throws Exception {
		logger.debug("getFavoriteList started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userID", userID);
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);
		map.put("primary", primary);

		logger.debug("getFavoriteList ended");
		return mBoardDAO.getFavoriteList(map);
	}

	@Override
	public MBoardItemVO getBrdItemInfo(String itemID, String lang, int tenantID) throws Exception {
		logger.debug("getBrdItemInfo started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("itemID", itemID);
		map.put("tenantID", tenantID);
		map.put("lang", lang);

		logger.debug("getBrdItemInfo ended");
		return mBoardDAO.getBrdItemInfo(map);
	}

	@Override
	public void insertBrdItem(JSONObject boardListVO, MCommonVO info, String realPath, String mhtData) throws Exception {
		logger.debug("insertBrdItem started");
		
		int tenantID = info.getTenantId();
		String offset = info.getOffSet();
		@SuppressWarnings("unused")
		boolean saveMHTResult = false;
		String filePath = commonUtil.getUploadPath("upload_board.ROOT", info.getTenantId());
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("itemID", boardListVO.get("itemID"));
		map.put("boardID", boardListVO.get("boardID"));
		map.put("writerID", boardListVO.get("userID"));
		map.put("writerName", info.getUserName());
		map.put("writerName2", info.getUserName2());
		map.put("writerDeptID", info.getDeptId());
		map.put("writerDeptName", info.getDeptName());
		map.put("writerDeptName2", info.getDeptName2());
		map.put("writerCompanyID", info.getCompanyId());
		map.put("writerCompanyName", info.getCompanyName());
		map.put("writerCompanyName2", info.getCompanyName2());
		map.put("writeDate", commonUtil.getTodayUTCTime(""));
		map.put("tenantID", info.getTenantId());
		map.put("importance", boardListVO.get("importance"));
		map.put("title", boardListVO.get("title"));
		map.put("contentLocation", commonUtil.getUploadPath("upload_board.ROOT", tenantID) + commonUtil.separator + boardListVO.get("boardID") + commonUtil.separator + "doc" + commonUtil.separator + boardListVO.get("itemID") + ".mht");
		/* 2018-07-04 홍승비 - content 칼럼 데이터 저장을 위한 처리 추가 */
		map.put("content", boardListVO.get("content"));
		
		if (boardListVO.get("startDate") != null && !boardListVO.get("startDate").equals("")) {
			map.put("startDate", commonUtil.getDateStringInUTC(String.valueOf(boardListVO.get("startDate")), offset, true));
			map.put("writeDate", commonUtil.getTodayUTCTime(""));
		} else {
			map.put("startDate", commonUtil.getTodayUTCTime(""));
		}

		if (boardListVO.get("notiStart") != null && !boardListVO.get("notiStart").equals("")) {
			map.put("notiStart", commonUtil.getDateStringInUTC(String.valueOf(boardListVO.get("notiStart")), offset, true));
		}

		if (boardListVO.get("notiEnd") != null && !boardListVO.get("notiEnd").equals("")) {
			map.put("notiEnd", commonUtil.getDateStringInUTC(String.valueOf(boardListVO.get("notiEnd")), offset, true));
		} 
		
		// 모바일에서는 영구게시만 지원
		map.put("endDate", "9999-12-30 14:59:59");
		// 현재 모바일에는 게시요약 정보가 없다. null로 들어가지 않도록 처리한다.
		map.put("abstract", "");
		
		// 모바일에서는 답변을 달기가 없기 때문에, itemID로 들어감
		map.put("upperItemIDTree", boardListVO.get("itemID"));
		// 새로 작성할때는 1로 fix
		map.put("itemLevel", "1");
		// 리플이나 수정일때는 값받아와야함.
		map.put("parentWriteDate", "docNO");
		map.put("extensionAttribute1", "0");
		// 공지사항 여부
		map.put("extensionAttribute2", boardListVO.get("notice"));
		// 게시물에 저장되는 직위명(3/32), 전화번호(4) 추가
		map.put("extensionAttribute3", info.getTitle());
		map.put("extensionAttribute32", info.getTitle2());
		map.put("extensionAttribute4", info.getPhone());
		map.put("extensionAttribute5", boardListVO.get("extensionAttribute5"));
		map.put("docPassword", boardListVO.get("docPassword"));
		// 탑라이터(원글작성자)ID는 자기 자신임(모바일 버전에서는 답변 작성 불가하므로)
		map.put("topWriterID", info.getUserId());
		// 모바일에는 확장칼럼 입력 필드가 없다. null로 들어가지 않도록 처리한다.
		map.put("extensionAttribute6", "");
		map.put("extensionAttribute7", "");
		map.put("extensionAttribute8", "");
		map.put("extensionAttribute9", "");
		map.put("extensionAttribute10", "");
		
		//mht파일저장
		saveMHTResult = saveMHT(mhtData, boardListVO.get("itemID").toString(), boardListVO.get("boardID").toString(), filePath, "BOARD", realPath);
		
		//첨부파일 저장
		if (boardListVO.get("attachments") != null && !boardListVO.get("attachments").equals("")) {
			if (!saveAttachmentsInfo(boardListVO.get("attachments").toString(), boardListVO.get("itemID").toString(), boardListVO.get("boardID").toString(), filePath, "BOARD", realPath, info.getTenantId(), boardListVO.get("realFileNames").toString())) {
				//return egovMessageSource.getMessage("ezCommunity.lhj05", locale);
			}
			map.put("hasAttach", "1");
		} else {
			map.put("hasAttach", "0");
		}

		map.put("publicFlag", boardListVO.get("publicFlag"));
		
		String tempString = mBoardDAO.getApprFlag(map);
		
		if (tempString != null && tempString.equals("Y")) {
			mBoardDAO.insertBrdItem(map);
		} else {
			mBoardDAO.insertBrdItem2(map);
		}
		
		logger.debug("insertBrdItem ended");
	}
	
	/**
	 * 게시판 게시물 첨부파일저장 실행 Method
	 */
	public boolean saveAttachmentsInfo(String strAttachments, String strItemID, String strBoardID, String strFilePath, String strType, String realPath, int tenantID, String realFileNames) throws Exception{
		logger.debug("saveAttachmentsInfo started");
		
        long fileSize = 0;
        boolean rtnValue = false;
        String filePath = "";
        String filePath2 = "";
        String fileName = "";
        
        try {
        	if (!strAttachments.substring(strAttachments.length() - 1).equals("|")) {
        		strAttachments += "|";
        	}

			if (!realFileNames.substring(realFileNames.length() - 1).equals("|")) {
				realFileNames += "|";
			}
        	
        	for (int i = 0; i < strAttachments.split("\\|").length; i++) {
        		if (strType.equals("BOARD")) {
        			if (strAttachments.split("\\|")[i].indexOf("upload_board") > -1) {
        				filePath = strAttachments.split("\\|")[i];
        			} else {
        				filePath = strFilePath + commonUtil.separator + strAttachments.split("\\|")[i];
        			}
        			EzFAL.EzFile file = new EzFAL.EzFile(realPath + filePath);
        			fileSize = file.length();
        			
        			if (strAttachments.split("\\|")[i].indexOf("tempUploadFile") > -1) {
        				filePath2 = strFilePath + commonUtil.separator + strBoardID + commonUtil.separator + "uploadFile" + strAttachments.split("\\|")[i].replace("tempUploadFile", "");
        				
        				EzFAL.EzFile fileinfo = new EzFAL.EzFile(realPath + filePath2);
        				
        				if (!fileinfo.exists()) {
        					EzFAL.moveFile(file, fileinfo);
        				}
        			} else if (strAttachments.split("\\|")[i].indexOf("upload_board") > -1) {
        				filePath2 = strAttachments.split("\\|")[i];
        			} else {
        				filePath2 = strFilePath + commonUtil.separator + strAttachments.split("\\|")[i];
        			}
        			file = null;
        			fileName = commonUtil.detectPathTraversal(realFileNames.split("\\|")[i]);
        		} else {
        			EzFAL.EzFile file = new EzFAL.EzFile(realPath + commonUtil.getUploadPath("upload_board.TEMPUPLOADFILE", tenantID)  + commonUtil.separator + strAttachments.split("\\|")[i].split("/")[2]);
        			fileSize = file.length();
        			
        			filePath2 = strFilePath + commonUtil.separator + strBoardID + commonUtil.separator + "uploadFile" + commonUtil.separator + strAttachments.split("\\|")[i].split("/")[2];
        			
        			EzFAL.EzFile fileinfo = new EzFAL.EzFile(realPath + filePath2);
        			
        			if (!fileinfo.exists()) {
        				EzFAL.moveFile(file, fileinfo);
        				file.delete();
        			}
        			file = null;
					fileName = commonUtil.detectPathTraversal(realFileNames.split("\\|")[i]);
				}
        		
        		//fileName = filePath2.replace(strFilePath + commonUtil.separator + strBoardID + commonUtil.separator + "uploadFile", "").substring(40);
        		
        		saveAttachInfo(strItemID, i, filePath2, fileSize, fileName, tenantID);
        	}
        	
        	rtnValue = true;
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			logger.debug(e.getMessage());
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
			rtnValue = false;
		}
        
        logger.debug("saveAttachmentsInfo ended");
        return rtnValue;
	}
	
	public void saveAttachInfo(String strItemID, int seqNum, String filePath, long fileSize, String fileName, int tenantID) throws Exception {
		logger.debug("saveAttachInfo started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_STRITEMID", strItemID);
		map.put("seqNum", seqNum);
		map.put("v_STRATTACHMENTS", filePath);
		map.put("v_FILESIZE", fileSize);
		map.put("v_FILENAME", fileName);
		map.put("v_TENANTID", tenantID);
		
		mBoardDAO.saveAttachInfo(map);
		
		logger.debug("saveAttachInfo ended");
	}
	
	@Override
	public void updateItem(JSONObject boardListVO, MCommonVO info, String realPath, String mhtData) throws Exception {
		logger.debug("updateItem started");
		
		@SuppressWarnings("unused")
		boolean saveMHTResult = false;
		String filePath = commonUtil.getUploadPath("upload_board.ROOT", info.getTenantId());
		String offset = info.getOffSet();
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("writeDate", commonUtil.getTodayUTCTime(""));
		map.put("importance", boardListVO.get("importance"));
		map.put("title", boardListVO.get("title"));
		//map.put("startDate", boardListVO.get("startDate"));
		//map.put("endDate", boardListVO.get("endDate"));
		map.put("abstract", boardListVO.get("abstract"));
		map.put("writerName", boardListVO.get("writerName"));
		map.put("writerName2", boardListVO.get("writerName2"));
		map.put("extensionAttribute2", boardListVO.get("notice"));
		map.put("extensionAttribute5", boardListVO.get("extensionAttribute5"));
		map.put("docPassword", boardListVO.get("docPassword"));
		map.put("extensionAttribute6", boardListVO.get("extensionAttribute6"));
		map.put("extensionAttribute7", boardListVO.get("extensionAttribute7"));
		map.put("extensionAttribute8", boardListVO.get("extensionAttribute8"));
		map.put("extensionAttribute9", boardListVO.get("extensionAttribute9"));
		map.put("extensionAttribute10", boardListVO.get("extensionAttribute10"));
		map.put("publicFlag", boardListVO.get("publicFlag"));
		map.put("tenantID", info.getTenantId());
		map.put("itemID", boardListVO.get("itemID"));
		/* 2018-07-04 홍승비 - content 칼럼 데이터 저장을 위한 처리 추가 */
		map.put("content", boardListVO.get("content"));
		
		BoardPropertyVO board = ezBoardService.getBoardProperty(boardListVO.get("boardID").toString(), info.getTenantId());
		map.put("guBun", board.getGuBun());
		if (!"2".equals(board.getGuBun())) {
			map.put("updaterID", boardListVO.get("updaterID"));
			map.put("updateDate", commonUtil.getTodayUTCTime(""));
		}
		
		//mht파일저장
		saveMHTResult = saveMHT(mhtData, boardListVO.get("itemID").toString(), boardListVO.get("boardID").toString(), filePath, "BOARD", realPath);
		
		if (boardListVO.get("attachments") != null && !boardListVO.get("attachments").equals("")) {
			map.put("hasAttach", "1");
		} else {
			map.put("hasAttach", "0");
		}
		
		if (boardListVO.get("notiStart") != null && !boardListVO.get("notiStart").equals("")) {
			map.put("notiStart", commonUtil.getDateStringInUTC(String.valueOf(boardListVO.get("notiStart")), offset, true));
		}

		if (boardListVO.get("notiEnd") != null && !boardListVO.get("notiEnd").equals("")) {
			map.put("notiEnd", commonUtil.getDateStringInUTC(String.valueOf(boardListVO.get("notiEnd")), offset, true));
		}
		
		mBoardDAO.updateItem(map);
		mBoardDAO.setApprFlag(map);
		mBoardDAO.newItem(map);
		
		//첨부파일 저장
		if (boardListVO.get("attachments") != null && !boardListVO.get("attachments").equals("")) {
			if (!saveAttachmentsInfo(boardListVO.get("attachments").toString(), boardListVO.get("itemID").toString(), boardListVO.get("boardID").toString(), filePath, "BOARD", realPath, info.getTenantId(), boardListVO.get("realFileNames").toString())) {
				//return egovMessageSource.getMessage("ezCommunity.lhj05", locale);
			}
			map.put("hasAttach", "1");
		} else {
			map.put("hasAttach", "0");
		}
	
		logger.debug("updateItem ended");
	}
	
	/**
	 * 게시판 mht저장 실행 Method
	 */
	public boolean saveMHT(String strHTML, String strMHTFilename, String strBoardID, String strFilePath, String strType, String realPath) throws Exception{
		logger.debug("saveMHT started");
		
		String docPath = "";
		String mhtFilePath = "";
		boolean ret = true;
		
        if (strType.equals("BOARD")) {
            strHTML = strHTML.replace("'", "''");
        }
        
		docPath = strFilePath + commonUtil.separator + strBoardID;
		mhtFilePath = strMHTFilename + ".mht";
		
		String stordFilePathReal = docPath + commonUtil.separator + "doc";
		
		EzFAL.EzFile file = new EzFAL.EzFile(realPath + stordFilePathReal);
		
		if (!file.exists()) {
			boolean _flag = file.mkdirs();
			file = new EzFAL.EzFile(realPath + docPath + commonUtil.separator + "uploadFile");
			file.mkdirs();
			
			if (!_flag) {
			    throw new IOException("Directory creation Failed ");
			}
		}
		
		try (InputStream stream = new ByteArrayInputStream(strHTML.getBytes("UTF-8"));
			 OutputStream bos = new EzFAL.EzFileOutputStream(realPath + stordFilePathReal + commonUtil.separator + mhtFilePath)) {
			
			int bytesRead = 0;
			byte[] buffer = new byte[2048];
			
			while ((bytesRead = stream.read(buffer, 0, 2048)) != -1) {
				bos.write(buffer, 0, bytesRead);
			}
			
			ret = true;
		} catch (Exception e) {
			ret = false;
		}
		
		logger.debug("saveMHT ended");
		return ret;
	}
	
	/* 현재 메서드로 호출되어 쓰이는 곳은 없다 */
	@Override
	public void insertBrdItem2(JSONObject boardListVO) throws Exception {
		logger.debug("insertBrdItem2 started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("itemID", boardListVO.get("itemID"));
		map.put("boardID", boardListVO.get("boardID"));
		map.put("writerID", boardListVO.get("writerID"));
		map.put("writerName", boardListVO.get("writerName"));
		map.put("writerName2", boardListVO.get("writerName2"));
		map.put("writerDeptID", boardListVO.get("writerDeptID"));
		map.put("writerDeptName", boardListVO.get("writerDeptName"));
		map.put("writerDeptName2", boardListVO.get("writerDeptName2"));
		map.put("writerCompanyID", boardListVO.get("writerCompanyID"));
		map.put("writerCompanyName", boardListVO.get("writerCompanyName"));
		map.put("writerCompanyName2", boardListVO.get("writerCompanyName2"));
		map.put("writeDate", commonUtil.getTodayUTCTime(""));
		map.put("parentWriteDate", boardListVO.get("parentWriteDate"));
		map.put("tenantID", boardListVO.get("tenantID"));
		map.put("importance", boardListVO.get("importance"));
		map.put("title", boardListVO.get("title"));
		map.put("contentLocation", boardListVO.get("contentLocation"));
		map.put("startDate", boardListVO.get("startDate"));
		map.put("endDate", boardListVO.get("endDate"));
		map.put("abstract", boardListVO.get("abstract"));
		map.put("hasAttach", boardListVO.get("hasAttach"));
		map.put("upperItemIDTree", boardListVO.get("upperItemIDTree"));
		map.put("itemLevel", boardListVO.get("itemLevel"));
		map.put("extensionAttribute1", boardListVO.get("extensionAttribute1"));
		map.put("extensionAttribute2", boardListVO.get("extensionAttribute2"));
		map.put("extensionAttribute3", boardListVO.get("extensionAttribute3"));
		map.put("extensionAttribute32", boardListVO.get("extensionAttribute32"));
		map.put("extensionAttribute4", boardListVO.get("extensionAttribute4"));
		map.put("extensionAttribute5", boardListVO.get("extensionAttribute5"));
		map.put("docPassword", boardListVO.get("docPassword"));
		map.put("topWriterID", boardListVO.get("topWriterID"));
		map.put("extensionAttribute6", boardListVO.get("extensionAttribute6"));
		map.put("extensionAttribute7", boardListVO.get("extensionAttribute7"));
		map.put("extensionAttribute8", boardListVO.get("extensionAttribute8"));
		map.put("extensionAttribute9", boardListVO.get("extensionAttribute9"));
		map.put("extensionAttribute10", boardListVO.get("extensionAttribute10"));
		
		mBoardDAO.insertBrdItem2(map);
		logger.debug("insertBrdItem2 ended");
	}

	@Override
	public void deleteItem(String itemID, String boardID, int tenantID) throws Exception {
		logger.debug("deleteItem started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("itemID", itemID);
		map.put("boardID", boardID);
		map.put("tenantID", tenantID);
		
		mBoardDAO.deleteBoardItem(map);
		mBoardDAO.deleteBoardReply(map);
		mBoardDAO.deleteBoardItemRead2(map);
		mBoardDAO.deleteScrapBoardItem(map);
		
		mBoardDAO.insertDeleteReservedItem(map);
		
		logger.debug("deleteItem ended");
	}

	/* 2018-07-03 홍승비 - 좌측메뉴 리스트 표시 시 companyID 조건 추가 */
	@Override
	public List<MBoardTreeVO> brdBoardTree(String rootBoardID, String accessID, int mode, int selectBy, String excludeBoardID, String companyID, int tenantID, String primary, int isDept, int isEqualDept, boolean isCompanyAdmin, String boardGroupAdmin_FG) throws Exception {
		logger.debug("brdBoardTree started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("rootBoardID", rootBoardID);
		map.put("userID", accessID);
		map.put("mode", mode);
		map.put("selectBy", selectBy);
		map.put("excludeBoardID", excludeBoardID);
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);
		map.put("primary", primary);
		map.put("v_ISDEPT", isDept);
		map.put("v_ISEQUALDEPT", isEqualDept);
		/* 2019-06-11 홍승비 - 게시판그룹에 관리자권한 존재하는 경우, 해당 게시판그룹의 하위게시판 전부 가져오도록 수정 */
		map.put("v_isCompanyAdmin", isCompanyAdmin);
		map.put("v_boardGroupAdmin_FG", boardGroupAdmin_FG);
		map.put("guestPermitYN", ezCommonService.getTenantConfig("useBoardGuestPermit", tenantID));
		
		logger.debug("brdBoardTree ended");
		return mBoardDAO.brdBoardTree(map);
	}

	@Override
	public String checkIfBoardGroupAdmin(String rootBoardID, String userID, String deptID, String companyID, int tenantID) throws Exception {
		logger.debug("checkIfBoardGroupAdmin started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("boardID", rootBoardID);
		map.put("userID", userID);
		map.put("deptID", deptID);
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);
		
		logger.debug("checkIfBoardGroupAdmin ended");
		return mBoardDAO.checkIfBoardGroupAdmin(map);
	}

	/* 2018-07-03 홍승비 - 새게시물 리스트 표시 시 deptID, companyID 조건 추가, 게시판 그룹 관리자 권한 체크 */
	@Override
	public List<MBoardNewListVO> getNewBoardList(String userID, String lastDate, String deptID, String companyID, int tenantID, String offset,String pSearchText) throws Exception {
		logger.debug("getNewBoardList started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("userID", userID);
		//mainList 임시 10까지
		map.put("listSize", 50);
		map.put("lastDate", lastDate);
		map.put("nowDate", commonUtil.getTodayUTCTime(""));
		map.put("offset", commonUtil.getMinuteUTC(offset));
		map.put("deptID", deptID);
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);
		map.put("pSearchText", pSearchText.replace("%", "\\%").replace("_", "\\_"));
		
		logger.debug("getNewBoardList ended");
		return mBoardDAO.getNewItemList(map);
	}
	
	/* 2018-07-09 홍승비 - 포탈 메인 새게시물 리스트 표시 시 deptID, companyID 조건 추가, 게시판 그룹 관리자 권한 체크 */
	@Override
	public List<MBoardNewListVO> getBoardMainList(String userID, String listCnt, String deptID, String companyID, int tenantID, String offset) throws Exception {
		logger.debug("getBoardMainList started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("userID", userID);
		map.put("listSize", Integer.parseInt(listCnt));
		map.put("nowDate", commonUtil.getTodayUTCTime(""));
		map.put("offset", commonUtil.getMinuteUTC(offset));
		map.put("deptID", deptID);
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);

		logger.debug("getNewBoardList ended");
		return mBoardDAO.getNewItemList(map);
	}
	
	/* 2018-07-03 홍승비 - 좌측메뉴 리스트 표시 시 companyID 조건 추가 */
	@SuppressWarnings("unchecked")
	@Override
	public List<MBoardTreeVO> getBoardTree(String rootBoardID, int mode, int subFlag, int selectBy, String excludeBoardID, MCommonVO info) throws Exception {
		logger.debug("getBoardTree started");
		
		MOptionVO mobileInfo = mOptionService.optionInfo(info.getUserId(), info.getTenantId());
		String primary = commonUtil.getPrimaryData(mobileInfo.getLang(), info.getTenantId());
		String rollInfo = info.getRollInfo();
		int tenantID = info.getTenantId();
		String deptID = info.getDeptId();
		String companyID = info.getCompanyId();
		boolean isCompanyAdmin = false; // 전체관리자 플래그
		boolean isNormalAdmin = false; // 전체관리자가 아닌 관리자 플래그 (게시관리자, 회사관리자)
		
		String boardGroupAdmin_FG = "";
		if (rootBoardID.equalsIgnoreCase("top")) {
			boardGroupAdmin_FG = "NO";
		} else {
			boardGroupAdmin_FG = checkIfBoardGroupAdmin(rootBoardID, info);
		}
		
		StringJoiner pAccessID = new StringJoiner(",");
		pAccessID.add(info.getUserId());
		String[] reverseDeptPath = ezOrganService.getDeptFullPath(deptID, tenantID).split(",");
		List<String> addJobDeptList = new ArrayList<String>();
		
		/* 2019-09-18 홍승비 - 개인ID 이후, 부서ID 이전 위치에 직위+직책ID (사내겸직 직위 포함) 추가 */
		String userJJID = ezBoardService.getUserJJID(info.getUserId(), companyID, tenantID);
		pAccessID.add(userJJID);
		
		for (int i = reverseDeptPath.length -1; i >= 0 ; i--) {
			pAccessID.add(reverseDeptPath[i]);
		}
		
		String pAccessIDStr = pAccessID.toString();
		addJobDeptList.add(pAccessIDStr);
		
		/* 2019-05-28 홍승비 - 현재 소속 회사의 사내겸직이 존재하면 사내겸직부서ID와 그 상위부서ID까지 권한체크에 포함하도록 수정 */
		List<String> addJobList = getPDOAddJobDeptID(info.getUserId(), companyID, tenantID);
		StringJoiner addJobStr = new StringJoiner(",");
		addJobStr.add(info.getDeptId());
		if (addJobList != null && addJobList.size() > 0) {
			for (int i = 0; i < addJobList.size(); i++) {
				addJobStr.add(addJobList.get(i));
				String upperDept = getUpperDeptID(addJobList.get(i), tenantID);
				
				if (upperDept != null && !upperDept.equals("")) {
					boolean loopContinue = true;
					StringJoiner upperDeptStr = new StringJoiner(",");
					upperDeptStr.add(upperDept);
					
					while (loopContinue) {
						String upperDeptLoop = getUpperDeptID(upperDept, tenantID);
						if (upperDeptLoop != null && !upperDeptLoop.equals("")) {
							upperDeptStr.add(upperDeptLoop);
							upperDept = upperDeptLoop;
						} else {
							loopContinue = false;
						}
					}
					addJobDeptList.add(addJobList.get(i) + "," + upperDeptStr.toString());
				}
			}
		}
		
		mode = boardGroupAdmin_FG.equals("OK") || commonUtil.isAdmin(info.getUserId(), info.getTenantId(), rollInfo, "c;n;k") ? 0 : 1;
	    /* 2019-06-11 홍승비 - 전체관리자, 회사/게시관리자 플래그 추가 */
		if (commonUtil.isAdmin(info.getUserId(), info.getTenantId(), rollInfo, "c")) {
			isCompanyAdmin = true;
		} else if (commonUtil.isAdmin(info.getUserId(), info.getTenantId(), rollInfo, "n;k")) {
			isNormalAdmin = true;
		}
		
		List<MBoardTreeVO> brdBoardTreeList = new ArrayList<MBoardTreeVO>();
		List<HashSet<String>> strBanBoardIDListSetDept = new ArrayList<HashSet<String>>();
		HashSet<String> strBanBoardIDListSetUser = new HashSet<String>();
		HashSet<String> strBanBoardIDListSetJJ = new HashSet<String>();
		HashSet<String> userJJIDSet = new HashSet<String>(Arrays.asList(userJJID.split(",")));
		String tempDeptList = addJobStr.toString();
		
		if ((mode == 0 && isCompanyAdmin == true) || boardGroupAdmin_FG.equals("OK")) {
			brdBoardTreeList = brdBoardTree(rootBoardID, "everyone", mode, selectBy, excludeBoardID, companyID, tenantID, primary, 0, 0, isCompanyAdmin, boardGroupAdmin_FG);
		} else {
			/* 2019-06-05 홍승비 - 게시판 트리 생성 시 사내겸직 부서경로 각각에 대해 게시판 가져오고, 접근불가 게시판 제거하도록 수정 */
			int addJobDeptListSize = addJobDeptList.size();
			for (int jl = 0; jl < addJobDeptListSize; jl++) {
				HashSet<String> strBanBoardIDListSetTemp = new HashSet<String>();
				int addJobDeptListPathSize = addJobDeptList.get(jl).split(",").length;
				for (int i = 0; i < addJobDeptListPathSize; i++) {
					String boardID = "";
					// 게시판 권한 추가시 하위부서 권한 상관없이 리스트가 보여지던 현상 수정
					/* 2019-05-30 홍승비 - 현재 소속 회사의 사내겸직도 isEqaulDept값을 체크하도록 수정 */
					int isEqaulDept = 0;
					for (int j = 0; j < tempDeptList.split(",").length; j++) {
						// 사원ID, 부서ID, 회사ID에 대하여 해당부서 직속여부 판단
						if(addJobDeptList.get(jl).split(",")[i].trim().equalsIgnoreCase(tempDeptList.split(",")[j])) {
							isEqaulDept = 1;
							break;
						} else {
							isEqaulDept = 0;
						}
					}
					
					int isDept = isDeptChk(addJobDeptList.get(jl).split(",")[i].trim(), tenantID);
					List<MBoardTreeVO> tempBrdBoardTreeList = brdBoardTree(rootBoardID, addJobDeptList.get(jl).split(",")[i].trim(), mode, selectBy, excludeBoardID, companyID, tenantID, primary, isDept, isEqaulDept, isCompanyAdmin, boardGroupAdmin_FG);
	            	
					if (tempBrdBoardTreeList != null && tempBrdBoardTreeList.size() > 0) {
						for (MBoardTreeVO k : tempBrdBoardTreeList) {
							if (brdBoardTreeList.size() > 0) {
								int tempCnt = 0;
								
								for (MBoardTreeVO h : brdBoardTreeList) {
									if (h.getBoardId().equals(k.getBoardId())) {
										tempCnt++;
									}
								}
								
								if (tempCnt == 0) {
									brdBoardTreeList.add(k);
								}
							} else {
								brdBoardTreeList.add(k);
							}
						}
					}
					
					/* 2019-06-12 홍승비 - 전체관리자가 아닌 관리자라면(isNormalAdmin), 그룹사게시판의 경우에만 불가/허용여부 판단용 게시판ID와 accessID를 가져오도록 수정 */
					List<BoardVO> boardTreeList = ezBoardAdminService.getBoardTree_Get2(addJobDeptList.get(jl).split(",")[i].trim(), rootBoardID, tenantID, isNormalAdmin, isDept, isEqaulDept);
					if (boardTreeList.size() > 0) {
						for (int r = 0; r < boardTreeList.size(); r++) {
							boardID = boardTreeList.get(r).getBoardId();
							
							/* 2019-09-24 그룹권한 적용으로 그룹에 속한 개인권한 다수 저장 가능 */
							if (addJobDeptList.get(jl).split(",")[i].equals(info.getUserId())) { // 개인권한은 따로 저장 (맨 처음 한 번만 동작)
								strBanBoardIDListSetUser.add(boardID);
							}
							else if (userJJIDSet.contains(addJobDeptList.get(jl).split(",")[i].trim())) { // 직위/직책권한 저장
								strBanBoardIDListSetJJ.add(boardID);
							}
							else { // 부서권한 저장
								// 하위부서와 상위부서가 동일한 게시판에 대해 권한을 가져서 충돌하는 경우, 하위부서를 우선으로 적용한다.
								// 즉, contains로 strBanBoardIDListSetTemp의 게시판ID 존재 여부를 체크하여 동일한 게시판ID가 이미 존재한다면 스킵한다.
								if (strBanBoardIDListSetTemp.contains(boardID.substring(0, boardID.indexOf("|")) + "|0;") || 
										strBanBoardIDListSetTemp.contains(boardID.substring(0, boardID.indexOf("|")) + "|1;")) {
									continue;
								} else {
									strBanBoardIDListSetTemp.add(boardID);
								}
							}
						}
					}
				}
				
				if (!strBanBoardIDListSetTemp.isEmpty()) {
					strBanBoardIDListSetDept.add((HashSet<String>)strBanBoardIDListSetTemp.clone());
				}
				
				strBanBoardIDListSetTemp.clear();
			}
		}
		
		HashSet<String> strBanBoardIDListSetDept2 = new HashSet<String>();
		for (int i = 0; i < strBanBoardIDListSetDept.size(); i++) {
			strBanBoardIDListSetDept2.addAll(strBanBoardIDListSetDept.get(i));
		}
		
	    /* 2018-10-05 홍승비 - 게시판순서 오름차순 정렬 시 o1=o2(0), o1>o2(1), o1<o2(-1) 분기 추가 */
	    Collections.sort(brdBoardTreeList, new Comparator<MBoardTreeVO>() {
			@Override
			public int compare(MBoardTreeVO o1, MBoardTreeVO o2) {
				return Integer.parseInt(o1.getTreeViewOrder()) < Integer.parseInt(o2.getTreeViewOrder()) ? -1 : Integer.parseInt(o1.getTreeViewOrder()) > Integer.parseInt(o2.getTreeViewOrder()) ? 1 : 0;
			}
		});
	    
	    /* 2019-06-12 홍승비 - 접근 불가한 게시판 체크 시 전체관리자가 아닌 관리자도 해당 분기 타도록 수정 */
	    Iterator<MBoardTreeVO> it = brdBoardTreeList.iterator();
	    while (it.hasNext()) {
	    	MBoardTreeVO tempMBoardTree = it.next();
	    	
	    	if (!isCompanyAdmin) {
	    		// 개인권한 최우선 확인 (strBanBoardIDListSetUser 직접 사용)
	    		/* 2019-09-24 홍승비 - 그룹권한에 포함된 개인/직위,직책권한도 고려하도록 수정 (동일한 우선순위 권한 간의 불가/허용 충돌 시 '허용' 기준으로 판정) */
				if (strBanBoardIDListSetUser.contains(tempMBoardTree.getBoardId() + "|0;") && !strBanBoardIDListSetUser.contains(tempMBoardTree.getBoardId() + "|1;")) {
					it.remove();
					brdBoardTreeList.remove(tempMBoardTree);
					continue;
				}
				// 개인권한에 대해 '허용'권한과 '불가'권한이 모두 존재하지 않음 => 직위, 직책을 체크
				// 개인권한 미존재
				else if (!strBanBoardIDListSetUser.contains(tempMBoardTree.getBoardId() + "|0;") && !strBanBoardIDListSetUser.contains(tempMBoardTree.getBoardId() + "|1;")) {
					// 직위,직책권한 중 '불가'만 존재
					if  (strBanBoardIDListSetJJ.contains(tempMBoardTree.getBoardId() + "|0;") && !strBanBoardIDListSetJJ.contains(tempMBoardTree.getBoardId() + "|1;")) {
						it.remove();
						brdBoardTreeList.remove(tempMBoardTree);
						continue;
					}
					// 개인권한에 대해 '허용'권한과 '불가'권한이 모두 존재하지 않음 + 직위, 직책에 대해 '허용'권한과 '불가'권한이 모두 존재하지 않음 => 부서권한을 체크
					// 직위,직책권한 미존재
					else if (!strBanBoardIDListSetJJ.contains(tempMBoardTree.getBoardId() + "|0;") && !strBanBoardIDListSetJJ.contains(tempMBoardTree.getBoardId() + "|1;")) {
						 // 부서권한 중 '불가'만 존재
						if (strBanBoardIDListSetDept2.contains(tempMBoardTree.getBoardId() + "|0;") && !strBanBoardIDListSetDept2.contains(tempMBoardTree.getBoardId() + "|1;")) {
							it.remove();
							brdBoardTreeList.remove(tempMBoardTree);
							continue;
						}
					}
				}
			}
	    	
	    	//자식존재여부 체크
	    	String isLeaf = checkIfLeafBoard(tempMBoardTree.getBoardId(), tenantID);
	    	brdBoardTreeList.get(brdBoardTreeList.indexOf(tempMBoardTree)).setIsLeaf(isLeaf);
	    
	    	Map<String, Object> map = new HashMap<String, Object>();
	    	map.put("boardID", tempMBoardTree.getBoardId());
			map.put("userID", info.getUserId());
			map.put("gubun", (tempMBoardTree.getGuBun() == null || !tempMBoardTree.getGuBun().equals("2") || !tempMBoardTree.getGuBun().equals("3")) ? "1" : tempMBoardTree.getGuBun());
			map.put("nowDate", commonUtil.getTodayUTCTime(""));
			map.put("pSearchText", "");
			map.put("tenantID", tenantID);
		    
	    	int listCount = mBoardDAO.getBoardItemListCount(map);

	    	brdBoardTreeList.get(brdBoardTreeList.indexOf(tempMBoardTree)).setListCount(listCount);
	    }
	    
	    logger.debug("getBoardTree ended");
		return brdBoardTreeList;
	}

	@Override
	public void getBoardTree_Set(String pStrLang, String query, String result, int tenantID) throws Exception {
		logger.debug("getBoardTree_Set started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_STRLANG", pStrLang);
		map.put("v_PQUERY", query);
		map.put("v_RESULT", result);
		map.put("v_TENANTID", tenantID);
		
		mBoardDAO.getBoardTree_Set(map);
		logger.debug("getBoardTree_Set ended");
	}

	@Override
	public List<MBoardTreeVO> getBoardTree_Get2(String pAccessID, String pRootBoardID, int tenantID) throws Exception {
		logger.debug("getBoardTree_Get2 started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_PACCESSID", pAccessID);
		map.put("v_PROOTBOARDID", pRootBoardID);
		map.put("v_TENANTID", tenantID);
		
		logger.debug("getBoardTree_Get2 ended");
		return mBoardDAO.getBoardTree_Get2(map);
	}

	public String checkIfLeafBoard(String pBoardID, int tenantID) {
		logger.debug("checkIfLeafBoard started");
		
		try {
	        int ret = ezBoardAdminService.checkIfLeafBoard(pBoardID, tenantID);
	        
	        if (ret > 0) {
	        	logger.debug("checkIfLeafBoard ended");
	        	return "FALSE";
	        } else {
	        	logger.debug("checkIfLeafBoard ended");
	        	return "TRUE";
	        }
		} catch(Exception ex) {
			return "FALSE";
		}
	}

	/* 2018-07-03 홍승비 - 좌측메뉴 리스트 새게시물 카운트 표시 시 companyID 조건 추가 */
	@Override
	public Integer getNewBoardListCount(String userID, String startDate, String companyID, int tenantID, String pSearchText) throws Exception {
		logger.debug("getNewBoardListCount started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("userID", userID);
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);
		map.put("startDate", startDate);
		map.put("nowDate", commonUtil.getTodayUTCTime(""));
		map.put("pSearchText", pSearchText.replace("%", "\\%").replace("_", "\\_"));
		
		logger.debug("getNewBoardListCount ended");
		return mBoardDAO.getNewBoardListCount(map);
	}

	/* 2018-07-04 홍승비 - 모바일 게시판 즐겨찾기 추가 시 companyID 삽입 */
	@Override
	public void insertFavorite(String userID, String boardID, String companyID, int tenantID, String isAllGroupBoard) throws Exception {
		logger.debug("insertFavorite started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("userID", userID);
		map.put("boardID", boardID);
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);
		map.put("isAllGroupBoard", isAllGroupBoard);
		
		mBoardDAO.insertFavorite(map);
		logger.debug("insertFavorite ended");
	}

	@Override
	public void deleteFavorite(String userID, String boardID, int tenantID) throws Exception {
		logger.debug("deleteFavorite started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("userID", userID);
		map.put("tenantID", tenantID);
		map.put("boardID", boardID);
		
		mBoardDAO.deleteFavorite(map);
		logger.debug("deleteFavorite ended");
	}

	@Override
	public List<MBoardAttachVO> getAttachList(String itemID, int tenantID) throws Exception {
		logger.debug("getAttachList started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("itemID", itemID);
		map.put("tenantID", tenantID);
		return mBoardDAO.getAttachList(map);
	}

	@Override
	public String getDeptPathCode(String departmentID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("departmentID", departmentID);
		map.put("tenantID", tenantID);
		return mBoardDAO.getDeptPathCode(map);
	}

	@Override
	public String getMhtContent(String realPath, String domain, MCommonVO userInfo, String url, Locale locale, String scheme) throws Exception {
		String filePath = "";
		String uploadModule = commonUtil.getUploadPath("upload_common.MHTIMAGE", userInfo.getTenantId()) + commonUtil.separator;
		
		filePath = realPath + uploadModule;
		
	    EzFAL.EzFile file = new EzFAL.EzFile(filePath);
	        
	    if (!file.exists()) {
	    	file.mkdirs();
	    }
	    
	    String m_strMHT = "";
        
        try {
    		m_strMHT = ezCommonService.loadMHTFile(realPath + url);
		} catch (Exception e) {
			m_strMHT= "";
		}
	    
        String strHTML = ezCommonService.startMHT2HTML(filePath, m_strMHT, filePath, realPath, locale, domain, scheme);
        logger.debug("strHTML : " + strHTML);
        
        strHTML = strHTML.replace("/fileroot", "/mobile/ezCommon/mFileDown.do?fileName=*.INLINE.*&filePath=/fileroot");

        Document doc = Jsoup.parse(strHTML);
        
        String bodyHTML = doc.getElementsByTag("BODY").html();
        
		return bodyHTML;
	}

	@Override
	public List<MBoardAttachVO> photoViewDB(String itemID, String boardID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("itemID", itemID);
		map.put("boardID", boardID);
		map.put("tenantID", tenantID);
		return mBoardDAO.photoViewDB(map);
	}

	@Override
	public Integer photoViewDBCount(String itemID, String boardID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("itemID", itemID);
		map.put("boardID", boardID);
		map.put("tenantID", tenantID);
		return mBoardDAO.photoViewDBCount(map);
	}

	/* 2018-07-03 홍승비 - 모바일 게시물 조회자정보에 companyID 추가 */
	@Override
	public void setAsRead(MCommonVO userInfo, String boardID, String itemID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pBoardID", boardID);
		map.put("v_pItemID", itemID);
		map.put("v_pUserID", userInfo.getUserId());
		map.put("v_pUserName", userInfo.getUserName());
		map.put("v_pUserDeptName", userInfo.getDeptName());
		map.put("v_pUserCompanyName", userInfo.getCompanyName());
		map.put("v_pUserTitle", userInfo.getTitle());
		map.put("v_pUserName2", userInfo.getUserName2());
		map.put("v_pUserDeptName2", userInfo.getDeptName2());
		map.put("v_pUserCompanyName2", userInfo.getCompanyName2());
		map.put("v_pUserTitle2", userInfo.getTitle2());
		map.put("v_COMPANYID", userInfo.getCompanyId());
		map.put("v_TENANTID", userInfo.getTenantId());
		map.put("nowDate", commonUtil.getTodayUTCTime(""));
		
		// 해당 게시물을 읽었는가에 따라 조회수 신규삽입 + 업데이트 설정
		String tempString = mBoardDAO.getBoardItemRead(map);
		
		if (tempString != null && !tempString.equals("")) {
			mBoardDAO.setAsRead(map);
			
			String tempWriterID = mBoardDAO.getWriterID(map);
			
			if (tempWriterID == null || !tempWriterID.equals(userInfo.getUserId())) {
				mBoardDAO.setAsRead2(map);
			}
		}
	}

	@Override
	public String checkFavorite(String userID, String boardID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userID", userID);
		map.put("boardID", boardID);
		map.put("tenantID", tenantID);
		return mBoardDAO.checkFavorite(map);
	}
	
	/* 2019-04-10 홍승비 - 사용자가 원회사이고 사내겸직이 존재하면 사내겸직부서ID를 리턴 */
	@Override
	public List<String> getPDOAddJobDeptID(String userID, String companyID, int tenantID) throws Exception {
		logger.debug("getPDOAddJobDeptID started.");
		
		Map<String, Object> map = new HashMap<>();
		
		map.put("v_pUserID", userID);
		map.put("v_pCompanyID", companyID);
		map.put("v_TENANTID", tenantID);
		
		logger.debug("getPDOAddJobDeptID ended.");
		return mBoardDAO.getPDOAddJobDeptID(map);
	}
	
	/* 2019-06-11 홍승비 - 해당 부서ID로 상위부서ID(회사포함) 가져오기*/
	@Override
	public String getUpperDeptID(String deptID, int tenantID) throws Exception {
		logger.debug("getUpperDeptID started.");
		
		Map<String, Object> map = new HashMap<>();
		
		map.put("v_DEPTID", deptID);
		map.put("v_TENANTID", tenantID);
		
		logger.debug("getUpperDeptID ended.");
		return mBoardDAO.getUpperDeptID(map);
	}
	
	/* 2019-06-11 홍승비 - 해당 ID가 부서(회사)ID인지 확인하는 기능 서비스로 분리 */
	@Override
	public int isDeptChk(String id, int tenantID) throws Exception {
		logger.debug("isDeptChk started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("id", id);
		map.put("tenantID", tenantID);
		
		logger.debug("isDeptChk ended.");
		return mBoardDAO.isDeptChk(map);
	}
	
	/** 2019-05-29 홍승비 - 어레이 리스트로 넘겨준 권한 BoardPropertyVO를 취합하는 메서드 */
	public MBoardInfoVO sumBoardACL(List<MBoardInfoVO> boardACLList, MBoardInfoVO boardInfo) {
		logger.debug("sumBoardACL started");
		
		List<MBoardInfoVO> resultACLList = boardACLList;
		MBoardInfoVO resultACL = boardInfo;

		resultACL.setBoardGroupAdmin_FG("NO");
		resultACL.setAccess_("0");
		resultACL.setBoardAdmin_FG("false");
		resultACL.setListView_FG("false");
		resultACL.setRead_FG("false");
		resultACL.setWrite_FG("false");
		resultACL.setReply_FG("false");
		resultACL.setDelete_FG("false");
		
		for (MBoardInfoVO aclList: resultACLList) {
			if (aclList.getBoardGroupAdmin_FG() != null && aclList.getBoardGroupAdmin_FG().equals("OK")) { // 게시판 그룹 관리자 권한
				resultACL.setBoardGroupAdmin_FG("OK");
			}
			if (aclList.getBoardAdmin_FG() != null && aclList.getBoardAdmin_FG().equals("true")) { // 게시판 관리자 권한
				resultACL.setBoardAdmin_FG("true");
			}
			if (aclList.getAccess_() != null && aclList.getAccess_().equals("1")) { // 접근
				resultACL.setAccess_("1");
			}
			if (aclList.getListView_FG() != null && aclList.getListView_FG().equals("true")) { // 리스트 보기
				resultACL.setListView_FG("true");
			}
			if (aclList.getRead_FG() != null && aclList.getRead_FG().equals("true")) { // 읽기
				resultACL.setRead_FG("true");
			}
			if (aclList.getWrite_FG() != null && aclList.getWrite_FG().equals("true")) { // 쓰기
				resultACL.setWrite_FG("true");
			}
			if (aclList.getReply_FG() != null && aclList.getReply_FG().equals("true")) { // 답변
				resultACL.setReply_FG("true");
			}
			if (aclList.getDelete_FG() != null && aclList.getDelete_FG().equals("true")) { // 자신의 게시물 삭제
				resultACL.setDelete_FG("true");
			}
		}
		
		logger.debug("sumBoardACL ended");
		return resultACL;
	}
	
	/** 2019-06-11 홍승비 - 사내겸직, 하위부서 허용여부 판단하여 게시판 그룹의 관리자권한 체크 */
	public String checkIfBoardGroupAdmin(String pBoardGroupID, MCommonVO userInfo) throws Exception {
		logger.debug("checkIfBoardGroupAdmin started");
		
		String result = "NO";
		String[] reverseDeptPath = ezOrganService.getDeptFullPath(userInfo.getDeptId(), userInfo.getTenantId()).split(",");
		StringJoiner pAccessID = new StringJoiner(",");
		List<String> addJobDeptList = new ArrayList<String>();
		
		/* 2019-09-18 홍승비 - 개인ID 이후, 부서ID 이전 위치에 직위+직책ID (사내겸직 직위 포함) 추가 */
		String userJJID = ezBoardService.getUserJJID(userInfo.getUserId(), userInfo.getCompanyId(), userInfo.getTenantId());
		
		pAccessID.add(userInfo.getUserId());
		pAccessID.add(userJJID);
		for (int i = reverseDeptPath.length -1; i >= 0 ; i--) {
			pAccessID.add(reverseDeptPath[i]);
		}
		
		String pAccessIDStr = pAccessID.toString();
		addJobDeptList.add(pAccessIDStr);
		
		List<String> addJobList = getPDOAddJobDeptID(userInfo.getUserId(), userInfo.getCompanyId(), userInfo.getTenantId());
		StringJoiner addJobStr = new StringJoiner(",");
		addJobStr.add(userInfo.getDeptId());
		if (addJobList != null && addJobList.size() > 0) {
			for (int i = 0; i < addJobList.size(); i++) {
				addJobStr.add(addJobList.get(i));
				String upperDept = getUpperDeptID(addJobList.get(i), userInfo.getTenantId());
				
				if (upperDept != null && !upperDept.equals("")) {
					boolean loopContinue = true;
					StringJoiner upperDeptStr = new StringJoiner(",");
					upperDeptStr.add(upperDept);
					
					while (loopContinue) {
						String upperDeptLoop = getUpperDeptID(upperDept, userInfo.getTenantId());
						if (upperDeptLoop != null && !upperDeptLoop.equals("")) {
							upperDeptStr.add(upperDeptLoop);
							upperDept = upperDeptLoop;
						} else {
							loopContinue = false;
						}
					}
					addJobDeptList.add(addJobList.get(i) + "," + upperDeptStr.toString());
				}
			}
		}
		
		boolean isBoardGroup = false;
		MBoardInfoVO orgBoardProp = getBoardProperty(pBoardGroupID, userInfo.getPrimary(), userInfo.getTenantId(), userInfo.getUserId());
		if (orgBoardProp != null) {
			if (orgBoardProp.getBoardGroupID() != null && !orgBoardProp.getBoardGroupID().equals("")) { // 하위게시판
				isBoardGroup = false;
			} else { // 게시판그룹
				isBoardGroup = true;
			}
		}
		
		Set<String> boardGroupAdminFGSetDept = new HashSet<String>();
		Set<String> boardGroupAdminFGSetJJ = new HashSet<String>();
		Set<String> userJJIDSet = new HashSet<String>(Arrays.asList(userJJID.split(",")));
		
		boolean isUserHasACL = false;
		String tempDeptList = addJobStr.toString();
		int addJobDeptListSize = addJobDeptList.size();
		for (int jl = 0; jl < addJobDeptListSize; jl++) {
			if (isUserHasACL == false) {
				int addJobDeptListPathSize = addJobDeptList.get(jl).split(",").length;
				for (int i = 0; i < addJobDeptListPathSize; i++) {
					int isEqualDept = 0;
					for (int j = 0; j < tempDeptList.split(",").length; j++) {
						if(addJobDeptList.get(jl).split(",")[i].trim().equalsIgnoreCase(tempDeptList.split(",")[j])) {
							isEqualDept = 1;
							break;
						} else {
							isEqualDept = 0;
						}
					}
					
					int isDept = isDeptChk(addJobDeptList.get(jl).split(",")[i].trim(), userInfo.getTenantId());
					
					/* 2019-09-24 홍승비 - 권한그룹을 포함하여 게시판그룹 관리자권한 체크 */
					// 권한그룹 적용 시 개인권한이 다수 존재 가능하므로, 권한을 리스트로 가져온 뒤 '허용(OK)'기준으로 취합한다.
					List<String> boardGroupAdminNew_FG_List = ezBoardService.checkIfBoardGroupAdminNew(pBoardGroupID, addJobDeptList.get(jl).split(",")[i].trim(), userInfo.getTenantId(), isDept, isEqualDept, isBoardGroup);
					String boardGroupAdminNew_FG = ""; // 공백으로 설정해야 제대로 루프를 돈다 (하단 equals 분기 참고)
					// 전달한 ACCESSID에 대한 게시판 관리자권한 리스트 (OK, NO)
					if (boardGroupAdminNew_FG_List != null && boardGroupAdminNew_FG_List.size() > 0) { // 권한이 없으면 공백값을 유지 > 다음 루프 진행
						if (boardGroupAdminNew_FG_List.contains("OK")) { // 동일한 우선순위의 권한에 대해서, OK가 하나라도 존재한다면 OK로 판정
							boardGroupAdminNew_FG = "OK";
						} else {
							boardGroupAdminNew_FG = "NO";
						}
					}
					
					if (!boardGroupAdminNew_FG.equals("")) {
						if (addJobDeptList.get(jl).split(",")[i].trim().equals(userInfo.getUserId())) { // 개인의 권한
							result = boardGroupAdminNew_FG;
							isUserHasACL = true;
							break;
						}
						else if (userJJIDSet.contains(addJobDeptList.get(jl).split(",")[i].trim())) { // 직위, 직책 권한
							boardGroupAdminFGSetJJ.add(boardGroupAdminNew_FG);
							isUserHasACL = false;
							// 직위, 직책권한은 레코드 전부 찾을때까지 break 안함
						}
						else { // 부서, 회사의 권한
							boardGroupAdminFGSetDept.add(boardGroupAdminNew_FG);
							isUserHasACL = false;
							break;
						}
					}
				}
			}
		}
		
		// 개인권한이 있다면 개인권한을  result로 사용함(상단 루프 내부 참고) / 개인권한이 없다면 직위, 직책권한 -> 부서권한 순으로 체크
		if (isUserHasACL == false) {
			if (boardGroupAdminFGSetJJ.size() > 0 && boardGroupAdminFGSetJJ.contains("OK")) { // 직위, 직책권한이 존재하고 OK를 가지는 경우
				result = "OK";
			} else if (boardGroupAdminFGSetJJ.size() == 0 && boardGroupAdminFGSetDept.contains("OK")) { // 직위, 직책권한이 없고 부서권한이 OK를 가지는 경우
				result = "OK";
			} // 이외의 경우는 직위, 직책권한이 존재하고 NO만 가지는 경우 || 직위, 직잭권한이 없고 부서권한이 NO만 가지는 경우
		}
		
		logger.debug("result in checkIfBoardGroupAdmin   ::   " + result);
		logger.debug("checkIfBoardGroupAdmin ended");
		return result;
	}
	
	/* 2019-09-25 홍승비 - 그룹권한을 포함하여 ACCESSID에 대한 권한정보를 리스트로 리턴하는 메서드  */
	public List<MBoardInfoVO> getACLListNew(String pBoardID, String userDeptPath, int tenantID, int isDept, int isEqualDept) throws Exception {
		logger.debug("getACL started");

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("boardID", pBoardID);
		map.put("userDeptPath", userDeptPath);
		map.put("tenantID", tenantID);
		map.put("v_ISDEPT", isDept);
		map.put("v_ISEQUALDEPT", isEqualDept);
		
		logger.debug("getACL ended");
		return mBoardDAO.getACLListNew(map);
	}
	
	/* 2020-04-13 홍승비 - QNA게시판 게시물 카운트 추가 */
	@Override
	public int getQNABoardItemListCount(String boardID, MBoardInfoVO mBoardInfoVO, String userID, String gubun, int tenantID, String pSearchText) throws Exception {
		logger.debug("getQNABoardItemListCount started.");
		logger.debug("boardID = " + boardID + " || userID = " + userID + " || gubun = " + gubun + " || tenantID = " + tenantID);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("boardID", boardID);
		map.put("userID", userID);
		map.put("nowDate", commonUtil.getTodayUTCTime(""));
		map.put("pSearchText", pSearchText.replace("%", "\\%").replace("_", "\\_"));
		map.put("tenantID", tenantID);
		map.put("v_PADMINTYPE", mBoardInfoVO.getBoardAdmin_FG());
		
		MBoardInfoVO boardProp = getBoardProperty(boardID, "1", tenantID, userID);
		if (boardProp.getUseKeyword() != null && boardProp.getUseKeyword().equals("Y")) {
			map.put("useKeyword", boardProp.getUseKeyword());
		}
		
		String apprFlag = mBoardDAO.getBoardApprFlag(map);
		
		if (apprFlag != null && apprFlag.equals("Y")) {
			map.put("apprFlag", apprFlag);
		}
		
		int result = mBoardDAO.getQNABoardItemListCount(map);
		
		logger.debug("getQNABoardItemListCount ended. result = " + result);
		
		return result;
	}
	
	/* 2020-04-13 홍승비- QNA게시판 게시물 리스트 추가  */
	private List<MBoardItemVO> getQNABoardItemList(String boardID, MBoardInfoVO mBoardInfoVO, String userID, String gubun, int listSize, int boardItemListCount, String lastDate, int tenantID, String offset, String pSearchText, String parentWriteDate, String upperitemidtree) throws Exception {
		logger.debug("getQNABoardItemList started.");
		logger.debug("boardID = " + boardID + " || userID = " + userID + " || gubun = " + gubun + " || QNAboardItemListCount = " + boardItemListCount + " || tenantID = " + tenantID + " || lastDate = " + lastDate);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("boardID", boardID);
		map.put("userID", userID);
		map.put("listSize", listSize);
		map.put("lastDate", lastDate);
		map.put("nowDate", commonUtil.getTodayUTCTime(""));
		map.put("offset", commonUtil.getMinuteUTC(offset));
		map.put("tenantID", tenantID);
		map.put("pSearchText", pSearchText.replace("%", "\\%").replace("_", "\\_"));
		map.put("parentWriteDate", parentWriteDate);
		map.put("upperitemidtree", upperitemidtree);
		map.put("v_PADMINTYPE", mBoardInfoVO.getBoardAdmin_FG());


		MBoardInfoVO boardProp = getBoardProperty(boardID, "1", tenantID, userID);
		if (boardProp.getUseKeyword() != null && boardProp.getUseKeyword().equals("Y")) {
			map.put("useKeyword", boardProp.getUseKeyword());
		}
		
		String apprFlag = mBoardDAO.getBoardApprFlag(map);
		
		if (apprFlag != null && apprFlag.equals("Y")) {
			map.put("apprFlag", apprFlag);
		}
		
		List<MBoardItemVO> list = mBoardDAO.getQNABoardItemList(map);
		
		logger.debug("getQNABoardItemList ended.");
		
		return list;
	}
	
	/* 2022-11-18 홍승비 - 모바일 게시판 댓글 저장 기능 추가 */
	@Override
	public void saveOneLineReply(String itemID, String replyID, String boardID, String userID, String displayName, String displayName2, int tenantID, String companyID, String content, String imageContent) throws Exception {
		logger.debug("saveOneLineReply started");

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("ITEMID", itemID);
		map.put("REPLYID", replyID);
		map.put("BOARDID", boardID);
		map.put("USERID", userID);
		map.put("USERNAME", displayName);
		map.put("USERNAME2", displayName2);
		map.put("CONTENT", content);
		map.put("PASSWORD", ""); // 모바일은 익명게시판의 댓글작성 불가능 (게시암호 공백으로 전달)
		map.put("TENANTID", tenantID);
		map.put("COMPANYID", companyID);
		map.put("WRITEDATE", commonUtil.getTodayUTCTime("yyyy-MM-dd HH:mm:ss"));
		map.put("IMAGECONTENT", imageContent);
		
		mBoardDAO.saveOneLineReply(map);

		logger.debug("saveOneLineReply ended");
	}

	/* 2023-11-13 전인하 - 모바일 게시판 댓글 수정 */
	public void updateOneLineReply(String contentId, String replyID, String content, int tenantId, String imageContent) throws Exception {
		logger.debug("updateOneLineReply/Mobile started");

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("CONTENTID", contentId);
		map.put("REPLYID", replyID);
		map.put("CONTENT", content);
		map.put("TENANTID", tenantId);
		map.put("IMAGECONTENT", imageContent);

		mBoardDAO.updateOneLineReply(map);

		logger.debug("updateOneLineReply/Mobile ended");
	}

	/* 2023-11-13 전인하 - 모바일 게시판 대댓글 삽입 */
	@Override
	public void saveOneLineReReply(String contentId, String boardId, String replyID, String parentReplyID, String content, String password, MCommonVO info, String imageContent) throws Exception {
		logger.debug("insertOneLineReReply/Mobile started");

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("PITEMID", contentId);
		map.put("PREPLYID", replyID);
		map.put("PBOARDID", boardId);
		map.put("USERID", info.getUserId());
		map.put("USERNAME", info.getUserName());
		map.put("USERNAME2", info.getUserName2());
		map.put("nowDate", commonUtil.getTodayUTCTime(""));
		map.put("PCONTENT", content);
		map.put("PPASSWORD", password);
		map.put("PARENTREPLYID", parentReplyID);
		map.put("TENANTID", info.getTenantId());
		map.put("COMPANYID", info.getCompanyId());
		map.put("IMAGECONTENT", imageContent);
		
		mBoardDAO.saveOneLineReReply(map);

		logger.debug("insertOneLineReReply/Mobile ended");

	}
	@Override
	public int checkThisReplyExist(String replyId, String itemId, int tenantId) throws Exception {
		logger.debug("checkThisReplyExist started");

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("REPLYID", replyId);
		map.put("PITEMID", itemId);
		map.put("TENANTID", tenantId);

		logger.debug("checkThisReplyExist ended");
		
		return mBoardDAO.checkThisReplyExist(map);
	}
	
	public String getGubun(String BoardID) throws Exception {
		String gubun = mBoardDAO.getGubun(BoardID);
		return gubun;
	}

	@Override
	public int getAllBoardItemListCount(String userId, String companyId, int tenantId) throws Exception {
		
		logger.debug("getAllBoardItemListCount started");

		Map<String, Object> map = new HashMap<String, Object>();

		map.put("v_pUserID", userId);
		map.put("v_COMPANYID", companyId);
		map.put("v_TENANTID", tenantId);
		map.put("nowDate", commonUtil.getTodayUTCTime(""));

		logger.debug("getAllBoardItemListCount ended");
		return mBoardDAO.getAllBoardItemListCount(map);
	}

	@Override
	public List<MBoardListVO> getAllBoardItemList(String userId, String lastDate, String deptId, String companyId, int tenantId, String offSet) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();

		map.put("v_PUSERID", userId);
		map.put("v_COMPANYID", companyId);
		map.put("v_TENANTID", tenantId);
		map.put("listSize", 50);
		map.put("lastDate", lastDate);
		map.put("offset", commonUtil.getMinuteUTC(offSet));
		map.put("nowDate", commonUtil.getTodayUTCTime(""));
		
		logger.debug("getAllBoardItemList ended");
		return mBoardDAO.getAllBoardItemList(map);
	}
	
	
	/* 2023-11-21 기민혁 - 모바일 스크랩 리스트 호출 */
	@Override
	public List<MBoardNewListVO> getScrapBoardList(String userID, String deptID, String companyID, int tenantID, String offset,String pSearchText, ArrayList<String> scrapBoardListView_FG) throws Exception {
		logger.debug("getScrapBoardList started");

		Map<String, Object> map = new HashMap<String, Object>();

		map.put("userID", userID);
		map.put("listSize", 50);
		map.put("offset", commonUtil.getMinuteUTC(offset));
		map.put("nowDate", commonUtil.getTodayUTCTime(""));
		map.put("deptID", deptID);
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);
		map.put("pSearchText", pSearchText.replace("%", "\\%").replace("_", "\\_"));
		map.put("scrapBoardListView_FG", scrapBoardListView_FG);

		List<MBoardNewListVO> mScrapBoardList = mBoardDAO.getScrapBoardList(map);

		String nowDate = commonUtil.getTodayUTCTime("");
		nowDate = EgovDateUtil.addDay(nowDate, -1, "yyyy-MM-dd HH:mm:ss");
		for (MBoardNewListVO vo : mScrapBoardList) {
			if (vo.getWriteDate().toString().compareTo(nowDate) > 0) {
				vo.setNewItemFlag("Y");
			} else {
				vo.setNewItemFlag("N");
			}
		}

		logger.debug("getScrapBoardList ended");
		return mScrapBoardList;
	}

	/* 2023-11-21 기민혁 - 모바일 스크랩 리스트 count */
	@Override
	public Integer getScrapBoardListCount(String userID, String companyID, int tenantID, String pSearchText, ArrayList<String> scrapBoardListView_FG) throws Exception {
		logger.debug("getScrapBoardListCount started");

		Map<String, Object> map = new HashMap<String, Object>();

		map.put("userID", userID);
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);
		map.put("nowDate", commonUtil.getTodayUTCTime(""));
		map.put("pSearchText", pSearchText.replace("%", "\\%").replace("_", "\\_"));
		map.put("scrapBoardListView_FG", scrapBoardListView_FG);
		
		logger.debug("getScrapBoardListCount ended");
		return mBoardDAO.getScrapBoardListCount(map);
	}
	
	@Override
	public Map<String, ArrayList<String>> getScrapBoardListReadView_FG(MCommonVO info) throws Exception {
		MBoardInfoVO scrapBoardInfo = new MBoardInfoVO();
			ArrayList<String> scrapBoardListView_FG = new ArrayList<String>();
			ArrayList<String> scrapBoardListRead_FG = new ArrayList<String>();
			List<HashMap<String, Object>> scrapBoardList = ezBoardService.getUserScrapBoardList(info.getUserId(), info.getTenantId());
			String deptPathCode = info.getUserId() + "," + getDeptPathCode(info.getDeptId(), info.getTenantId());
			Map<String, ArrayList<String>> result = new HashMap<>();
		
			if (scrapBoardList != null && scrapBoardList.size() > 0) {
				for (HashMap<String, Object> scrapBoard : scrapBoardList) {
					String checkBoardID = (String) scrapBoard.get("BOARDID");
					scrapBoardInfo = getBoardProperty(checkBoardID, info.getPrimary(), info.getTenantId(), info.getUserId());
					scrapBoardInfo = getBoardInfo(scrapBoardInfo, info.getRollInfo(), deptPathCode, info);
					if (scrapBoardInfo.getListView_FG().equals("true")) {
						scrapBoardListView_FG.add(checkBoardID);
					}

					if(scrapBoardInfo.getRead_FG().equals("true")){
						scrapBoardListRead_FG.add(checkBoardID);
					}
					scrapBoardInfo = null;
				}
			}
		result.put("scrapBoardListRead_FG", scrapBoardListRead_FG);
		result.put("scrapBoardListView_FG", scrapBoardListView_FG);
		
		return result;
	}

	/* 2024-09-09 이유정 - 모바일 게시판 > 최근게시물 리스트 카운트 */
	@Override
	public Integer getAllNewBoardListCount(String userID, String startDate, String companyID, int tenantID, String pSearchText) throws Exception {
		logger.debug("getAllNewBoardListCount started");

		Map<String, Object> map = new HashMap<String, Object>();

		map.put("userID", userID);
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);
		map.put("startDate", startDate);
		map.put("nowDate", commonUtil.getTodayUTCTime(""));
		map.put("pSearchText", pSearchText.replace("%", "\\%").replace("_", "\\_"));

		logger.debug("getAllNewBoardListCount ended");
		return mBoardDAO.getAllNewBoardListCount(map);
	}

	/* 2024-09-09 이유정 - 모바일 게시판 > 최근게시물 리스트 */
	@Override
	public List<MBoardNewListVO> getAllNewBoardList(String userID, String lastDate, String deptID, String companyID, int tenantID, String offset,String pSearchText) throws Exception {
		logger.debug("getAllNewBoardList started");

		Map<String, Object> map = new HashMap<String, Object>();

		map.put("userID", userID);
		//mainList 임시 10까지
		map.put("listSize", 50);
		map.put("lastDate", lastDate);
		map.put("nowDate", commonUtil.getTodayUTCTime(""));
		map.put("offset", commonUtil.getMinuteUTC(offset));
		map.put("deptID", deptID);
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);
		map.put("pSearchText", pSearchText.replace("%", "\\%").replace("_", "\\_"));

		logger.debug("getAllNewBoardList ended");
		return mBoardDAO.getAllNewBoardList(map);
	}
	
}
