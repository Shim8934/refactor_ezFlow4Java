package egovframework.ezMobile.ezBoard.service.impl;

import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.commons.io.FileUtils;
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
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.ezMobile.ezBoard.dao.MBoardDAO;
import egovframework.ezMobile.ezBoard.service.MBoardService;
import egovframework.ezMobile.ezBoard.vo.MBoardAttachVO;
import egovframework.ezMobile.ezBoard.vo.MBoardFavoriteVO;
import egovframework.ezMobile.ezBoard.vo.MBoardInfoVO;
import egovframework.ezMobile.ezBoard.vo.MBoardItemVO;
import egovframework.ezMobile.ezBoard.vo.MBoardListHeaderVO;
import egovframework.ezMobile.ezBoard.vo.MBoardNewListVO;
import egovframework.ezMobile.ezBoard.vo.MBoardTreeVO;
import egovframework.ezMobile.ezOption.service.MOptionService;
import egovframework.ezMobile.ezOption.vo.MCommonVO;
import egovframework.ezMobile.ezOption.vo.MOptionVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.fcc.service.EgovDateUtil;

@Service("MBoardService")
public class MBoardServiceImpl implements MBoardService {
	private static final Logger logger = LoggerFactory.getLogger(MBoardServiceImpl.class);
	
	final public int mobileListSize = 20;
	final public String newBoardID = "{FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF}";
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Resource(name = "MBoardDAO")
	private MBoardDAO mBoardDAO;
	
	@Resource(name = "EzBoardAdminService")
	private EzBoardAdminService ezBoardAdminService;
	
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
        
		int boardCount = getBoardItemListCount(boardID, userID, gubun, tenantID,pSearchText);
		List<MBoardItemVO> mBoardItemList = getBoardItemList(boardID, userID, gubun, listSize, boardCount, lastDate,tenantID, offset, pSearchText, parentWriteDate, upperitemidtree);
		
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
		
        int boardCount = getBoardItemListCount(boardID, userID, gubun, tenantID,pSearchText);
        
        List<MBoardNewListVO> mBoardItemList = getNewBoardItemList(boardID, userID, gubun, startRow, endRow, boardCount, tenantID, offset, pSearchText, parentWriteDate, upperitemidtree);
        
        logger.debug("getNewBoarditemList ended");
		return mBoardItemList;
	}

	//게시판 정보조회 -> MBoardInfoVO.parentBoardID 불필요시 추후 삭제
	@Override
	public MBoardInfoVO getBoardInfo(MBoardInfoVO mBoardInfoVO, String rollInfo, String deptPathCode, MCommonVO info) throws Exception {
		logger.debug("getBoardInfo started");
		
		mBoardInfoVO.setSs_board_maxRows(mobileListSize);
		mBoardInfoVO.setSs_searchBoard_maxRows(mobileListSize);

		String boardName = mBoardInfoVO.getBoardName();
		String guBun = mBoardInfoVO.getGuBun();
		String boardID = mBoardInfoVO.getBoardID();
		String type = mBoardInfoVO.getType();
		String apprFlag = mBoardInfoVO.getApprFlag();
	    String deptPathOrgan="";
	    
	    for (int ch=0; ch<deptPathCode.split(",").length; ch++) {
	        if (ch == 0) {
	        	deptPathOrgan += deptPathCode.split(",")[ch].trim();
	        } else {
	        	deptPathOrgan += "," + deptPathCode.split(",")[deptPathCode.split(",").length-(ch)].trim();
	        }
	    }
	    
	    String userDeptPath = deptPathOrgan+",everyone";

		//for (String userDept : userDeptPath.split(",")) {

		for (int i=0; i<userDeptPath.split(",").length; i++) {
			MBoardInfoVO aclVO = getACL(mBoardInfoVO, userDeptPath.split(",")[i].trim(), info.getTenantId());
			
			if (aclVO != null) {
				mBoardInfoVO = aclVO;
				mBoardInfoVO.setBoardName(boardName);
				mBoardInfoVO.setGuBun(guBun);
				mBoardInfoVO.setBoardID(boardID);
				mBoardInfoVO.setType(type);
				mBoardInfoVO.setApprFlag(apprFlag);
				break;
			}/* else {
				mBoardInfoVO.setBoardID(aclVO.getBoardID());
				mBoardInfoVO.setAccessID(aclVO.getAccessID());
				mBoardInfoVO.setAccessLevel(aclVO.getAccessLevel());
				mBoardInfoVO.setAccess_(aclVO.getAccess_());
				mBoardInfoVO.setParentBoardID(aclVO.getParentBoardID());
				mBoardInfoVO.setBoardAdmin_FG(aclVO.getBoardAdmin_FG());
				mBoardInfoVO.setListView_FG(aclVO.getListView_FG());
				mBoardInfoVO.setRead_FG(aclVO.getRead_FG());
				mBoardInfoVO.setWrite_FG(aclVO.getWrite_FG());
				mBoardInfoVO.setReply_FG(aclVO.getReply_FG());
				mBoardInfoVO.setDelete_FG(aclVO.getDelete_FG());
				mBoardInfoVO.setInherit_FG(aclVO.getInherit_FG());
				mBoardInfoVO.setPostNotice(aclVO.getPostNotice());
				mBoardInfoVO.setBoardGroupACL(aclVO.getBoardGroupACL());
			}*/
		}
		
		String boardGroupAdmin_FG = ezBoardAdminService.checkIfBoardGroupAdmin(mBoardInfoVO.getBoardID(), info.getUserId(), info.getDeptId(), info.getCompanyId(), info.getTenantId());
		mBoardInfoVO.setBoardGroupAdmin_FG(boardGroupAdmin_FG);
		
	    if (mBoardInfoVO.getBoardID().equals("{FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF}")) {
	    	mBoardInfoVO.setAccess_FG("1");
	    	mBoardInfoVO.setBoardAdmin_FG("false");
	    	mBoardInfoVO.setListView_FG("true");
	    	mBoardInfoVO.setRead_FG("true");
	    	mBoardInfoVO.setWrite_FG("true");
	    	mBoardInfoVO.setReply_FG("true");
	    	mBoardInfoVO.setDelete_FG("true");
		} else if (rollInfo != null && (rollInfo.toLowerCase().indexOf("c=1") > -1 || rollInfo.toLowerCase().indexOf("k=1") > -1 || rollInfo.toLowerCase().indexOf("n=1") > -1)) {
			mBoardInfoVO.setAccess_FG("1");
			mBoardInfoVO.setBoardAdmin_FG("true");
			mBoardInfoVO.setListView_FG("true");
			mBoardInfoVO.setRead_FG("true");
			mBoardInfoVO.setWrite_FG("true");
			mBoardInfoVO.setReply_FG("true");
			mBoardInfoVO.setDelete_FG("true");
		} else if (mBoardInfoVO.getBoardGroupAdmin_FG() != null && mBoardInfoVO.getBoardGroupAdmin_FG().equals("OK")) {
			mBoardInfoVO.setAccess_FG("1");
			mBoardInfoVO.setBoardAdmin_FG("true");
			mBoardInfoVO.setListView_FG("true");
			mBoardInfoVO.setRead_FG("true");
			mBoardInfoVO.setWrite_FG("true");
			mBoardInfoVO.setReply_FG("true");
			mBoardInfoVO.setDelete_FG("true");
		} else if (mBoardInfoVO.getBoardAdmin_FG() == null || mBoardInfoVO.getBoardAdmin_FG().equals("")) {
			mBoardInfoVO.setAccess_FG("1");
			mBoardInfoVO.setBoardAdmin_FG("false");
			mBoardInfoVO.setListView_FG("false");
			mBoardInfoVO.setRead_FG("false");
			mBoardInfoVO.setWrite_FG("false");
			mBoardInfoVO.setReply_FG("false");
			mBoardInfoVO.setDelete_FG("false");
		}
		
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
		
		if (vo.getGuBun().equals("4") || vo.getGuBun().equals("3")) {
			vo.setType("photoBoardItem");
		}
		
		if (vo.getBoardID().equals("{FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF}")) {
			vo.setType("newBoardItemList");
			vo.setBoardName(egovMessageSource.getMessage("ezBoard.t480", new Locale(commonUtil.getTwoLetterLangFromLangNum(mobileInfo.getLang()))));
		} else {
			vo.setType("boardItemList");
		}
		
		logger.debug("getBoardProperty ended.");
		
		return vo;
	}

	private MBoardInfoVO getACL(MBoardInfoVO vo, String userDeptPath, int tenantID) throws Exception {
		logger.debug("getACL started.");
		logger.debug("boardID = " + vo.getBoardID() + " || userDeptPath = " + userDeptPath + " || tenantID = " + tenantID);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("boardID", vo.getBoardID());
		map.put("userDeptPath", userDeptPath);
		map.put("tenantID", tenantID);
		
		vo = mBoardDAO.getACL(map);
		
		logger.debug("getACL ended.");
		
		return vo;
	}
	
	private List<MBoardItemVO> getBoardItemList(String boardID, String userID, String gubun, int listSize, int boardItemListCount, String lastDate, int tenantID, String offset, String pSearchText, String parentWriteDate, String upperitemidtree) throws Exception {
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
	public int getBoardItemListCount(String boardID, String userID, String gubun, int tenantID, String pSearchText) throws Exception {
		logger.debug("getBoardItemListCount started.");
		logger.debug("boardID = " + boardID + " || userID = " + userID + " || gubun = " + gubun + " || tenantID = " + tenantID);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("boardID", boardID);
		map.put("userID", userID);
		map.put("gubun", (gubun == null || !gubun.equals("2") || !gubun.equals("3")) ? "1" : gubun);
		map.put("nowDate", commonUtil.getTodayUTCTime(""));
		map.put("pSearchText", pSearchText.replace("%", "\\%").replace("_", "\\_"));
		map.put("tenantID", tenantID);
		
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
			if (!saveAttachmentsInfo(boardListVO.get("attachments").toString(), boardListVO.get("itemID").toString(), boardListVO.get("boardID").toString(), filePath, "BOARD", realPath, info.getTenantId())) {
				//return egovMessageSource.getMessage("ezCommunity.lhj05", locale);
			}
			map.put("hasAttach", "1");
		} else {
			map.put("hasAttach", "0");
		}
		
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
	public boolean saveAttachmentsInfo(String strAttachments, String strItemID, String strBoardID, String strFilePath, String strType, String realPath, int tenantID) throws Exception{
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
        	
        	for (int i = 0; i < strAttachments.split("\\|").length; i++) {
        		if (strType.equals("BOARD")) {
        			if (strAttachments.split("\\|")[i].indexOf("upload_board") > -1) {
        				filePath = strAttachments.split("\\|")[i];
        			} else {
        				filePath = strFilePath + commonUtil.separator + strAttachments.split("\\|")[i];
        			}
        			File file = new File(realPath + filePath);
        			fileSize = file.length();
        			
        			if (strAttachments.split("\\|")[i].indexOf("tempUploadFile") > -1) {
        				filePath2 = strFilePath + commonUtil.separator + strBoardID + commonUtil.separator + "uploadFile" + strAttachments.split("\\|")[i].replace("tempUploadFile", "");
        				
        				File fileinfo = new File(realPath + filePath2);
        				
        				if (!fileinfo.exists()) {
        					FileUtils.moveFile(file, fileinfo);
        				}
        			} else if (strAttachments.split("\\|")[i].indexOf("upload_board") > -1) {
        				filePath2 = strAttachments.split("\\|")[i];
        			} else {
        				filePath2 = strFilePath + commonUtil.separator + strAttachments.split("\\|")[i];
        			}
        			file = null;
        		} else {
        			File file = new File(realPath + commonUtil.getUploadPath("upload_board.TEMPUPLOADFILE", tenantID)  + commonUtil.separator + strAttachments.split("\\|")[i].split("/")[2]);
        			fileSize = file.length();
        			
        			filePath2 = strFilePath + commonUtil.separator + strBoardID + commonUtil.separator + "uploadFile" + commonUtil.separator + strAttachments.split("\\|")[i].split("/")[2];
        			
        			File fileinfo = new File(realPath + filePath2);
        			
        			if (!fileinfo.exists()) {
        				FileUtils.moveFile(file, fileinfo);
        				file.delete();
        			}
        			file = null;
        		}
        		
        		fileName = filePath2.replace(strFilePath + commonUtil.separator + strBoardID + commonUtil.separator + "uploadFile", "").substring(40);
        		
        		saveAttachInfo(strItemID, i, filePath2, fileSize, fileName, tenantID);
        	}
        	
        	rtnValue = true;
		} catch (Exception e) {
			e.printStackTrace();
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
		
		boolean saveMHTResult = false;
		String filePath = commonUtil.getUploadPath("upload_board.ROOT", info.getTenantId());
		
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
		map.put("tenantID", info.getTenantId());
		map.put("itemID", boardListVO.get("itemID"));
		/* 2018-07-04 홍승비 - content 칼럼 데이터 저장을 위한 처리 추가 */
		map.put("content", boardListVO.get("content"));
		
		//mht파일저장
		saveMHTResult = saveMHT(mhtData, boardListVO.get("itemID").toString(), boardListVO.get("boardID").toString(), filePath, "BOARD", realPath);
		
		if (boardListVO.get("attachments") != null && !boardListVO.get("attachments").equals("")) {
			map.put("hasAttach", "1");
		} else {
			map.put("hasAttach", "0");
		}
		
		mBoardDAO.updateItem(map);
		mBoardDAO.setApprFlag(map);
		mBoardDAO.newItem(map);
		
		//첨부파일 저장
		if (boardListVO.get("attachments") != null && !boardListVO.get("attachments").equals("")) {
			if (!saveAttachmentsInfo(boardListVO.get("attachments").toString(), boardListVO.get("itemID").toString(), boardListVO.get("boardID").toString(), filePath, "BOARD", realPath, info.getTenantId())) {
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
		
		File file = new File(realPath + stordFilePathReal);
		
		if (!file.exists()) {
			boolean _flag = file.mkdirs();
			file = new File(realPath + docPath + commonUtil.separator + "uploadFile");
			file.mkdirs();
			
			if (!_flag) {
			    throw new IOException("Directory creation Failed ");
			}
		}
		
		InputStream stream = null;
		OutputStream bos = null;
		
		try {
			stream = new ByteArrayInputStream(strHTML.getBytes("UTF-8"));
			bos = new FileOutputStream(realPath + stordFilePathReal + commonUtil.separator + mhtFilePath);
			
			int bytesRead = 0;
			byte[] buffer = new byte[2048];
			
			while ((bytesRead = stream.read(buffer, 0, 2048)) != -1) {
				bos.write(buffer, 0, bytesRead);
			}
			
			ret = true;
		} catch (Exception e) {
			ret = false;
		} finally {
			if(bos != null){
				bos.close();
			}
			if(stream != null){
				stream.close();
			}
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
		
		mBoardDAO.insertDeleteReservedItem(map);
		
		logger.debug("deleteItem ended");
	}

	/* 2018-07-03 홍승비 - 좌측메뉴 리스트 표시 시 companyID 조건 추가 */
	@Override
	public List<MBoardTreeVO> brdBoardTree(String rootBoardID, String accessID, int mode, int selectBy, String excludeBoardID, String companyID, int tenantID, String primary, int isDept, int isEqualDept) throws Exception {
		logger.debug("brdBoardTree started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("rootBoardID", rootBoardID);
		map.put("userID", accessID);
		map.put("deptID", "");
		map.put("mode", mode);
		map.put("selectBy", selectBy);
		map.put("excludeBoardID", excludeBoardID);
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);
		map.put("primary", primary);
		map.put("v_ISDEPT", isDept);
		map.put("v_ISEQUALDEPT", isEqualDept);
		
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
		map.put("listSize", listCnt);
		map.put("nowDate", commonUtil.getTodayUTCTime(""));
		map.put("offset", commonUtil.getMinuteUTC(offset));
		map.put("deptID", deptID);
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);

		logger.debug("getNewBoardList ended");
		return mBoardDAO.getNewItemList(map);
	}
	
	/* 2018-07-03 홍승비 - 좌측메뉴 리스트 표시 시 companyID 조건 추가 */
	@Override
	public List<MBoardTreeVO> getBoardTree(String rootBoardID, int mode, int subFlag, int selectBy, String excludeBoardID, MCommonVO info) throws Exception {
		logger.debug("getBoardTree started");
		
		MOptionVO mobileInfo = mOptionService.optionInfo(info.getUserId(), info.getTenantId());
		String primary = commonUtil.getPrimaryData(mobileInfo.getLang(), info.getTenantId());
		String rollInfo = info.getRollInfo();
		int tenantID = info.getTenantId();
		String deptID = info.getDeptId();
		String companyID = info.getCompanyId();
		String boardGroupAdminFg = checkIfBoardGroupAdmin(rootBoardID, info.getUserId(), deptID, companyID, info.getTenantId());
		
	    if (rollInfo != null && (boardGroupAdminFg.equals("OK") || rollInfo.toLowerCase().indexOf("c=1") > -1 || rollInfo.toLowerCase().indexOf("k=1") > -1 || rollInfo.toLowerCase().indexOf("n=1") > -1)) {
	    	mode = 0;
	    } else {
	    	mode = 1;
	    }
	    
	    /* 2018-10-05 홍승비 - 변경된 게시판권한 스펙 모바일에도 적용(개인>부서>회사) */
	    String accessID = info.getUserId();
		String[] reverseDeptPath = ezOrganService.getDeptFullPath(deptID, tenantID).split(",");
		for (int i = reverseDeptPath.length -1; i >= 0 ; i--) {
			accessID += "," + reverseDeptPath[i];
			if (i == 0) {
				accessID += ",everyone";
			}
		}
		
		List<MBoardTreeVO> brdBoardTreeList = new ArrayList<MBoardTreeVO>();
	    
	    for (int i = 0; i < accessID.split(",").length; i++) {
            
            if (mode == 0) {
            	brdBoardTreeList = brdBoardTree(rootBoardID, "everyone", mode, selectBy, excludeBoardID, companyID, tenantID, primary, 0, 0);
            } else {
            	// 게시판 권한 추가시 하위부서 권한 상관없이 리스트가 보여지던 현상 수정
				int isEqaulDept = accessID.split(",")[i].trim().equalsIgnoreCase(deptID) ? 1 : 0;
				int isDept = mBoardDAO.isDeptChk(accessID.split(",")[i].trim(), tenantID);
				
            	List<MBoardTreeVO> tempBrdBoardTreeList = brdBoardTree(rootBoardID, accessID.split(",")[i].trim(), mode, selectBy, excludeBoardID, companyID, tenantID, primary, isDept, isEqaulDept);
            	
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
            }
        }
	  
	    /* 2018-10-05 홍승비 - 게시판순서 오름차순 정렬 시 o1=o2(0), o1>o2(1), o1<o2(-1) 분기 추가 */
	    Collections.sort(brdBoardTreeList, new Comparator<MBoardTreeVO>() {
			@Override
			public int compare(MBoardTreeVO o1, MBoardTreeVO o2) {
				return Integer.parseInt(o1.getTreeViewOrder()) < Integer.parseInt(o2.getTreeViewOrder()) ? -1 : Integer.parseInt(o1.getTreeViewOrder()) > Integer.parseInt(o2.getTreeViewOrder()) ? 1 : 0;
			}
		});
	    
	    Map<String, Object> map = new HashMap<String, Object>();
		
	    for (int i=0; i< brdBoardTreeList.size(); i++) {
	    	//자식존재여부 체크
	    	String isLeaf = checkIfLeafBoard(brdBoardTreeList.get(i).getBoardId(), tenantID);
	    	brdBoardTreeList.get(i).setIsLeaf(isLeaf);
	    	
	    	map.put("boardID", brdBoardTreeList.get(i).getBoardId());
			map.put("userID", info.getUserId());
			map.put("gubun", (brdBoardTreeList.get(i).getGuBun() == null || !brdBoardTreeList.get(i).getGuBun().equals("2") || !brdBoardTreeList.get(i).getGuBun().equals("3")) ? "1" : brdBoardTreeList.get(i).getGuBun());
			map.put("nowDate", commonUtil.getTodayUTCTime(""));
			map.put("pSearchText", "");
			map.put("tenantID", tenantID);
		    
	    	int listCount = mBoardDAO.getBoardItemListCount(map);
	    	
	    	brdBoardTreeList.get(i).setListCount(listCount);
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
	public void insertFavorite(String userID, String boardID, String companyID, int tenantID) throws Exception {
		logger.debug("insertFavorite started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("userID", userID);
		map.put("boardID", boardID);
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);
		
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
		
	    File file = new File(filePath);
	        
	    if (!file.exists()) {
	    	file.mkdir();
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
	
}
