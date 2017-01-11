package egovframework.ezEKP.ezBoard.service.impl;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Properties;
import java.util.UUID;

import javax.annotation.Resource;

import org.apache.commons.io.FileUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezBoard.dao.EzBoardDAO;
import egovframework.ezEKP.ezBoard.service.EzBoardAdminService;
import egovframework.ezEKP.ezBoard.service.EzBoardService;
import egovframework.ezEKP.ezBoard.vo.BoardAccessVO;
import egovframework.ezEKP.ezBoard.vo.BoardAttachVO;
import egovframework.ezEKP.ezBoard.vo.BoardConfigVO;
import egovframework.ezEKP.ezBoard.vo.BoardItemVO;
import egovframework.ezEKP.ezBoard.vo.BoardLineReplyVO;
import egovframework.ezEKP.ezBoard.vo.BoardListHeaderVO;
import egovframework.ezEKP.ezBoard.vo.BoardListVO;
import egovframework.ezEKP.ezBoard.vo.BoardMyFavoriteVO;
import egovframework.ezEKP.ezBoard.vo.BoardPropertyVO;
import egovframework.ezEKP.ezBoard.vo.BoardReadVO;
import egovframework.ezEKP.ezBoard.vo.BoardTreeVO;
import egovframework.ezEKP.ezBoard.vo.BoardVO;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.fcc.service.EgovDateUtil;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service("EzBoardService")
public class EzBoardServiceImpl extends EgovAbstractServiceImpl implements EzBoardService {

	@Resource(name="EzBoardDAO")
	private EzBoardDAO ezBoardDAO;
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private Properties config;
	
	@Resource(name = "EzBoardAdminService")
	private EzBoardAdminService ezBoardAdminService;

	@Resource(name = "EzOrganService")
	private EzOrganService ezOrganService;
	
	@Resource(name = "EzCommonService")
	private EzCommonService ezCommonService;
	
	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;
	
	private static final Logger logger = LoggerFactory.getLogger(EzBoardServiceImpl.class);

	@Override
	public List<BoardVO> getLeft_BoardSTD(String redirectBoardID, int tenantID) throws Exception{
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_REDIRECTBOARDID", redirectBoardID);
		map.put("v_TENANTID", tenantID);
		
		return ezBoardDAO.getLeft_BoardSTD(map);
	}	

	@Override
	public List<BoardVO> get_apprUserList(String boardID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PBOARDID", boardID);
		map.put("v_TENANTID", tenantID);
		
		return ezBoardDAO.get_apprUserList(map);
	}

	@Override
	public List<BoardMyFavoriteVO> get_favoriteList(String userID, String pMode, int tenantID) throws Exception{
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_USERID", userID);
		map.put("v_MODE", pMode);
		map.put("v_TENANTID", tenantID);
		
		BoardMyFavoriteVO boardMyFavoriteVO = ezBoardDAO.getBoardNewBoardOrder(map);
		
		if (boardMyFavoriteVO != null && boardMyFavoriteVO.getBoardId() != null && !boardMyFavoriteVO.equals("")) {
			ezBoardDAO.updateMyBoard(boardMyFavoriteVO);
		} else {
			ezBoardDAO.insertBoardNewBoardOrder(map);
			
			BoardMyFavoriteVO boardMyFavoriteVO2 = new BoardMyFavoriteVO();
			boardMyFavoriteVO2.setTabUsed("Y");
			boardMyFavoriteVO2.setViewOrder("0");
			
			ezBoardDAO.updateMyBoard(boardMyFavoriteVO2);
		}
		
		return ezBoardDAO.get_favoriteList(map);
	}

	@Override
	public String get_parentBoardName(String boardIdList, int boardIdListCount, String primary, int tenantID, Locale locale) throws Exception{
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PRIMARY", primary);
		map.put("v_TENANTID", tenantID);

		String[] boardIDs = boardIdList.split(";");
		String rtnValue = "";
		
		for (int k = 0; k < boardIdListCount; k++) {
			map.put("v_BOARDID", boardIDs[k]);
			
			String boardGroupID = ezBoardDAO.getBoardGroupID(map);
			
			if (boardGroupID != null && !boardGroupID.equals("")) {
				map.put("v_BOARDGROUPID", boardGroupID);
				
				rtnValue = rtnValue + ezBoardDAO.getBoardName(map) + ";";
			} else {
				rtnValue = rtnValue + egovMessageSource.getMessage("ezBoard.hyj01", locale);;
			}
		}
		
		return rtnValue;
	}

	@Override
	public String getBoardProperty(String pBoardID, BoardPropertyVO boardInfo, LoginVO userInfo) throws Exception{
		BoardPropertyVO strProp = getBoardProperty(pBoardID, userInfo.getTenantId());
		
		StringBuilder sb = new StringBuilder();

        sb.append("<NODES>");
        sb.append("<NODE>");
        sb.append("<ITEMEXPIRES>" + strProp.getItemExpires() + "</ITEMEXPIRES>");
        sb.append("<ATTACHLIMIT>" + strProp.getAttachSizeLimit() + "</ATTACHLIMIT>");
        sb.append("<DESCRIPTION><![CDATA[" + strProp.getBoardDescription() + "]]></DESCRIPTION>");
        sb.append("<BOARDNAME><![CDATA[" + strProp.getBoardName() + "]]></BOARDNAME>");
        sb.append("<BOARDNAME2><![CDATA[" + strProp.getBoardName2() + "]]></BOARDNAME2>");
        sb.append("<ALERTPOSTITEM><![CDATA[" + strProp.getAlertPostItem() + "]]></ALERTPOSTITEM>");
        sb.append("<REPLYNOTIFY><![CDATA[" + strProp.getReplyNotify() + "]]></REPLYNOTIFY>");
        sb.append("<URL><![CDATA[" + strProp.getUrl() + "]]></URL>");
        sb.append("<GUBUN><![CDATA[" + strProp.getGuBun() + "]]></GUBUN>");
        sb.append("<DELETEAFTER><![CDATA[" + strProp.getDeleteAfter() + "]]></DELETEAFTER>");
        sb.append("<BOARDCOLOR><![CDATA[" + strProp.getBoardColor() + "]]></BOARDCOLOR>");
        sb.append("<BOARDNO><![CDATA[" + strProp.getBoardNo() + "]]></BOARDNO>");
        sb.append("<PORTLET><![CDATA[" + strProp.getPortlet() + "]]></PORTLET>");
        sb.append("<ONELINEREPLY>" + strProp.getOneLineReply() + "</ONELINEREPLY>");
        sb.append("<BACKGROUND>" + strProp.getBackGround() + "</BACKGROUND>");
        sb.append("<FORMFLAG>" + strProp.getFormFlag() + "</FORMFLAG>");
        sb.append("<APPRFLAG>" + strProp.getApprFlag() + "</APPRFLAG>");
        sb.append("<APPRMAILFLAG>" + strProp.getApprMailFlag() + "</APPRMAILFLAG>");
        sb.append("</NODE>");
        sb.append("</NODES>");
        
        return sb.toString();
	}
	
	@Override
	public BoardPropertyVO getBoardProperty(String pBoardID, int tenantID) throws Exception{
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_BOARDID", pBoardID);
		map.put("v_TENANTID", tenantID);
		
		return ezBoardDAO.getBoardProperty(map);
	}
	
	@Override
	public BoardConfigVO getBoardList_Config(String userId, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_USERID", userId);
		map.put("v_TENANTID", tenantID);
		
		return ezBoardDAO.getBoardList_Config(map);
	}

	@Override
	public List<BoardListHeaderVO> getListHeader(BoardVO ezBoardVO) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_LISTCODE", ezBoardVO.getBoardType());
		map.put("v_PSTRLANG", ezBoardVO.getLang());
		map.put("v_TENANTID", ezBoardVO.getTenantID());
		
		return ezBoardDAO.getListHeader(map);
	}

	@Override
	public void setListOrder(LoginVO userInfo, String pBoardList, String pDelBoardList) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("tenantID", userInfo.getTenantId());
		map.put("userID", userInfo.getId());
		
		String[] boardIDs = pBoardList.split(";");
		String[] delBoardIDs = pDelBoardList.split(";");
		
		for (int k = 0; k < boardIDs.length; k++) {
			map.put("boardID", boardIDs[k]);
			map.put("count", k + 1);
			
			ezBoardDAO.setListOrder_U(map);
		}
		
		ezBoardDAO.setListOrder(map);
		
		for (int k = 0; k < delBoardIDs.length; k++) {
			map.put("boardID", delBoardIDs[k]);
			
			ezBoardDAO.setListOrder_D(map);
		}
	}

	@Override
	public int getNewItemListCount(LoginVO userInfo)  throws Exception{
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pUserID", userInfo.getId());
		map.put("v_TENANTID", userInfo.getTenantId());
		map.put("nowDate", commonUtil.getTodayUTCTime(""));
		
		return ezBoardDAO.getNewItemListCount(map);
	}

	@Override
	public BoardConfigVO getPersonalCount(LoginVO userInfo) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_USERID", userInfo.getId());
		map.put("v_TENANTID", userInfo.getTenantId());
		
		BoardConfigVO boardConfigVO = new BoardConfigVO();
		String tempString = ezBoardDAO.getBoardConfig(map);
		
		if (tempString != null && !tempString.equals("")) {
			boardConfigVO = ezBoardDAO.getPersonalCount(userInfo);
		} else {
			boardConfigVO.setListCount(20);
			boardConfigVO.setPreview("OFF");
			boardConfigVO.setPreviewWList(50);
			boardConfigVO.setPreviewWContent(50);
			boardConfigVO.setPreviewHList(50);
			boardConfigVO.setPreviewHContent(50);
		}
		
		return boardConfigVO;
	}

	@Override
	public List<HashMap<String, Object>> getNewItemList(BoardListVO boardListVO) throws Exception{
		if (boardListVO.getOrderBySub().length() > 0) {
			if (boardListVO.getOrderBySub().indexOf("WRITEDATE") > -1) {
				if (boardListVO.getOrderBySub().indexOf("WRITEDATE DESC") > -1) {
					boardListVO.setOrderBySub(" A.PARENTWRITEDATE DESC, A.WRITEDATE ");
				} else {
					boardListVO.setOrderBySub(" A.PARENTWRITEDATE, A.WRITEDATE ");
				}
			}
		} else {
			boardListVO.setOrderBySub(" A.PARENTWRITEDATE DESC, A.WRITEDATE ");
		}
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PUSERID", boardListVO.getUserID());
		map.put("v_TENANTID", boardListVO.getTenantID());
		map.put("v_PSTARTROW", boardListVO.getStartRow());
		map.put("v_PENDROW", boardListVO.getEndRow());
		map.put("iv_PORDERBYSUB", boardListVO.getOrderBySub());
		map.put("nowDate", commonUtil.getTodayUTCTime(""));
		
		return ezBoardDAO.getNewItemList(map);
	}

	@Override
	public void setBoardList_Config(BoardConfigVO boardConfigVO) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_USERID", boardConfigVO.getUserId());
		map.put("v_TENANTID", boardConfigVO.getTenantID());
		
		String configFlag = ezBoardDAO.getBoardConfig(map);
		
		if (configFlag != null && !configFlag.equals("")) {
			ezBoardDAO.setBoardList_Config_U(boardConfigVO); 
		} else {
			ezBoardDAO.setBoardList_Config_I(boardConfigVO); 
		}
	}

	@Override
	public int getBrdNewItemCount(String userID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pUserID", userID);
		map.put("v_TENANTID", tenantID);
		map.put("nowDate", commonUtil.getTodayUTCTime(""));
		
		return ezBoardDAO.getBrdNewItemCount(map);
	}

	@Override
	public int getThumbNailCount(BoardMyFavoriteVO myFavoriteVO) throws Exception {
		String tempString = ezBoardDAO.getBoardApprList(myFavoriteVO);
		int rtnCount = 0;

		if (tempString != null && !tempString.equals("")) {
			rtnCount = ezBoardDAO.getThumbNailCount(myFavoriteVO);
		} else {
			rtnCount = ezBoardDAO.getThumbNailCount2(myFavoriteVO);
		}
		
		return rtnCount;
	}

	@Override
	public int getBrdTotalItemCount(BoardMyFavoriteVO myFavoriteVO) throws Exception {
		String tempString = ezBoardDAO.getBoardApprJoinItem(myFavoriteVO);
		int rtnCount = 0;
		
		if (tempString != null && !tempString.equals("")) {
			rtnCount = ezBoardDAO.getBrdTotalItemCount(myFavoriteVO);
		} else {
			rtnCount = ezBoardDAO.getBrdTotalItemCount2(myFavoriteVO);
		}
		
		return rtnCount;
	}

	@Override
	public int getQNABrdTotalItemCount(BoardMyFavoriteVO myFavoriteVO) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PBOARDID", myFavoriteVO.getBoardId());
		map.put("v_PUSERID", myFavoriteVO.getUserId());
		map.put("v_PTYPE", myFavoriteVO.getType());
		map.put("v_PADMINTYPE", myFavoriteVO.getBoardAdmin_FG());
		map.put("v_TENANTID", myFavoriteVO.getTenantID());
		map.put("nowDate", commonUtil.getTodayUTCTime(""));
		
		return ezBoardDAO.getQNABrdTotalItemCount(map);
	}

	@Override
	public void setTabUsed(String pUserID, String pBoardList, String tabUsed, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_BOARDID", pBoardList);
		map.put("v_TABUSED", tabUsed);
		map.put("v_USERID", pUserID);
		map.put("v_TENANTID", tenantID);
		
		if (pBoardList != null && pBoardList.equals("{FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF}")) {
			ezBoardDAO.setTabUsed(map);
			ezBoardDAO.setTabUsed2(map);
		} else {
			ezBoardDAO.setTabUsed2(map);
		}
		
	}
	
	@Override
	public void setMainImageID(String mainImageID, String itemID, String type, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_IMAGEID", mainImageID);
		map.put("v_ITEMID", itemID);
		map.put("v_TYPE", type);
		map.put("v_TENANTID", tenantID);
		
		ezBoardDAO.setMainImageID(map);
		ezBoardDAO.setMainImageID2(map);
		
	}

	@Override
	public void setNotiOrder(String itemID, int tenantID, int sn) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("itemID", itemID);
		map.put("tenantID", tenantID);
		map.put("sn", sn);
		
		ezBoardDAO.setNotiOrder(map);
	}

	@Override
	public void photoListUpdate(String imageID, String boardID, String content, String file_Path, String itemID, String mainFg, String oFileName, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_ImageID", imageID);
		map.put("v_BoardID", boardID);
		map.put("v_FilePath", file_Path);
		map.put("v_FileContent", content);
		map.put("v_OFileName", oFileName);
		map.put("v_TENANTID", tenantID);
		map.put("nowDate", commonUtil.getTodayUTCTime(""));
		
		ezBoardDAO.photoListUpdate(map);
		
		if(mainFg.equals("Y")){
			setMainImageID(imageID, itemID, "1", tenantID);
		}
	}

	@Override
	public void updateCopyItem(String destItemID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("destItemID", destItemID);
		map.put("tenantID", tenantID);
		
		ezBoardDAO.updateCopyItem(map);
	}

	@Override
	public void updateMoveItem(String destItemID, String orgItemID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("itemID", orgItemID);
		map.put("destItemID", destItemID);
		map.put("tenantID", tenantID);
		
		ezBoardDAO.updateMoveItem(map);
		ezBoardDAO.deleteBoardItem(map);
		ezBoardDAO.deleteBoardItemRead2(map);
		ezBoardDAO.deleteBoardReply(map);
	}

	@Override
	public void setBoardList_Config2(String userID, String listCount, String previewMode, String list, String content, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_USERID", userID);
		map.put("v_LISTCNT", listCount);
		map.put("v_PREVIEWMODE", previewMode);
		map.put("v_LIST", list);
		map.put("v_CONTENT", content);
		map.put("v_TENANTID", tenantID);
		
		String tempString = ezBoardDAO.getBoardConfig(map);
		
		if (tempString != null && !tempString.equals("")) {
			ezBoardDAO.setBoardList_Config2_U(map);
		} else {
			ezBoardDAO.setBoardList_Config2_I(map);
		}
		
	}

	@Override
	public void photoListAlbumEdit(String boardID, String itemID, String title, String content, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_BOARDID", boardID);
		map.put("v_ITEMID", itemID);
		map.put("v_TITLE", title);
		map.put("v_CONTENT", content);
		map.put("v_TENANTID", tenantID);
		
		ezBoardDAO.photoListAlbumEdit(map);
	}

	@Override
	public void photoListAlbumEditTemp(String boardID, String itemID, String title, String content, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_BOARDID", boardID);
		map.put("v_ITEMID", itemID);
		map.put("v_TITLE", title);
		map.put("v_CONTENT", content);
		map.put("v_TENANTID", tenantID);
		
		ezBoardDAO.photoListAlbumEditTemp(map);
	}

	@Override
	public void deleteItem(String itemID, String boardID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("itemID", itemID);
		map.put("boardID", boardID);
		map.put("tenantID", tenantID);
		
		ezBoardDAO.deleteBoardItem(map);
		ezBoardDAO.deleteBoardReply(map);
		ezBoardDAO.deleteBoardItemRead2(map);
		ezBoardDAO.deleteBoardItemAttach(map);
		ezBoardDAO.insertDeleteReservedItem(map);
	}

	@Override
	public void deleteTempItem(String itemID, String boardID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("itemID", itemID);
		map.put("boardID", boardID);
		map.put("tenantID", tenantID);
		
		ezBoardDAO.deleteBoardItemTemp(map);
		ezBoardDAO.deleteBoardReply(map);
		ezBoardDAO.deleteBoardItemRead2(map);
		ezBoardDAO.insertDeleteReservedItem(map);
	}

	@Override
	public void photoListDel(String boardID, String imageID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_BoardID", boardID);
		map.put("v_ImageID", imageID);
		map.put("v_TENANTID", tenantID);
		
		ezBoardDAO.photoListDel(map);
	}

	@Override
	public List<BoardListHeaderVO> getListHeaderBoardID(BoardVO ezBoardVO) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PBOARDID", ezBoardVO.getBoardId());
		map.put("v_PSTRLANG", ezBoardVO.getLang());
		map.put("v_LISTCODE", ezBoardVO.getBoardType());
		map.put("v_TENANTID", ezBoardVO.getTenantID());
		
		String tempString = ezBoardDAO.getListOptionBoardID(map);
		
		if (tempString != null && !tempString.equals("")) {
			return ezBoardDAO.getListHeaderBoardID(map);
		} else {
			return ezBoardDAO.getListHeader(map); 
		}
	}

	@Override
	public List<BoardAttachVO> brdGetItemAttachmentInfo(String pItemID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("itemID", pItemID);
		map.put("tenantID", tenantID);
		
		return ezBoardDAO.brdGetItemAttachmentInfo(map);
	}

	@Override
	public List<BoardReadVO> getReaderList(String boardID, String itemID, String userID, String lang, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("boardID", boardID);
		map.put("itemID", itemID);
		map.put("userID", userID);
		map.put("lang", lang);
		map.put("tenantID", tenantID);
		
		return ezBoardDAO.getReaderList(map);
	}

	@Override
	public int getNoticePostItemCount(BoardVO boardVO) throws Exception {
		return ezBoardDAO.getNoticePostItemCount(boardVO);
	}

	@Override
	public List<HashMap<String, Object>> getNoticePostItem(BoardVO ezBoardVO, int personalCount) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		int start = 0;
        int end = 0;
        start = ((ezBoardVO.getPageNum() - 1) * personalCount) + 1;
        end = (ezBoardVO.getPageNum() * personalCount);
        
        BoardMyFavoriteVO boardMyFavoriteVO = new BoardMyFavoriteVO();
        boardMyFavoriteVO.setBoardId(ezBoardVO.getBoardId());
        boardMyFavoriteVO.setTenantID(ezBoardVO.getTenantID());
        
        String tempString = ezBoardDAO.getBoardApprJoinItem(boardMyFavoriteVO);
        
        if (tempString != null && ! tempString.equals("")) {
        	map.put("v_TEMP", "1");
        } else {
        	map.put("v_TEMP", "");
        }
        
		map.put("v_PBOARDID", ezBoardVO.getBoardId());
		map.put("v_START", start);
		map.put("v_END", end);
		map.put("v_TENANTID", ezBoardVO.getTenantID());
		map.put("nowDate", commonUtil.getTodayUTCTime(""));
		
		return ezBoardDAO.getNoticePostItem(map);
	}

	@Override
	public List<HashMap<String, Object>> getBoardListItem(String boardID, String userID, int startRow, int endRow, int boardCount, String orderOption1, String orderOption2, String type, int tenantID) throws Exception {
		String strSQL = "";
		
		if (orderOption1.length() > 0) {
			if (orderOption1.indexOf("WRITEDATE") > -1) {
				if (orderOption1.indexOf("WRITEDATE DESC") > -1) {
					orderOption1 =" A.PARENTWRITEDATE DESC, A.WRITEDATE ";
				} else {
					orderOption1 = " A.PARENTWRITEDATE, A.WRITEDATE ";
				}
			}
		} else {
			orderOption1 = " A.PARENTWRITEDATE DESC, A.WRITEDATE ";
		}
		
		BoardMyFavoriteVO boardMyFavoriteVO = new BoardMyFavoriteVO();
        boardMyFavoriteVO.setBoardId(boardID);
        boardMyFavoriteVO.setTenantID(tenantID);
        
        String tempString = ezBoardDAO.getBoardApprJoinItem(boardMyFavoriteVO);
        
        if (tempString != null && !tempString.equals("")) {
        	strSQL += " AND A.APPRFLAG = 'Y' ";
        }
        
		if (type.equals("1")) {
			strSQL += " AND STARTDATE <= '" + commonUtil.getTodayUTCTime("") + "' AND ENDDATE > '" + commonUtil.getTodayUTCTime("") + "') T1 WHERE RNUM BETWEEN '" + startRow + "' AND '" + endRow + "' " ;
		} else if (type.equals("2")) {
			strSQL += " AND STARTDATE <= '" + commonUtil.getTodayUTCTime("") + "' AND ENDDATE > '" + commonUtil.getTodayUTCTime("") + "') T1 WHERE RNUM BETWEEN '" + startRow + "' AND '" + endRow + "' AND READFLAG = '0' " ;
		} else if (type.equals("3")) {
			strSQL += " AND STARTDATE <= '" + commonUtil.getTodayUTCTime("") + "' AND ENDDATE < '" + commonUtil.getTodayUTCTime("") + "') T1 WHERE RNUM BETWEEN '" + startRow + "' AND '" + endRow + "' " ;
		}
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PUSERID", userID);
		map.put("v_PBOARDID", boardID);
		map.put("v_TENANTID", tenantID);
		map.put("iv_PORDERBYSUB", orderOption1);
		map.put("v_STRSQL", strSQL);
		
		return ezBoardDAO.getBoardListItem(map);
	}

	@Override
	public List<HashMap<String, Object>> getQnABoardListItem(String boardId, String userID, int startRow, int endRow, int boardCount, String orderOption1, String orderOption2, String type, String adminType, int tenantID) throws Exception {
		String strSQL = "";
		
		if (orderOption1.length() > 0) {
			if (orderOption1.indexOf("WRITEDATE") > -1) {
				if (orderOption1.indexOf("WRITEDATE DESC") > -1) {
					orderOption1 = " A.PARENTWRITEDATE DESC, A.WRITEDATE ";
				} else {
					orderOption1 = " A.PARENTWRITEDATE, A.WRITEDATE ";
				}
			}
		} else {
			orderOption1 = " A.PARENTWRITEDATE DESC, A.WRITEDATE ";
		}
		
		if (adminType.equals("false")) {
			strSQL += " AND TOPWRITERID = '" + userID + "' ";
		}
		
		if (type.equals("1")) {
			strSQL += " AND STARTDATE <= '" + commonUtil.getTodayUTCTime("") + "' AND ENDDATE > '" + commonUtil.getTodayUTCTime("") + "') T1 WHERE RNUM BETWEEN '" + startRow + "' AND '" + endRow + "' " ;
		} else if (type.equals("2")) {
			strSQL += " AND STARTDATE <= '" + commonUtil.getTodayUTCTime("") + "' AND ENDDATE > '" + commonUtil.getTodayUTCTime("") + "') T1 WHERE RNUM BETWEEN '" + startRow + "' AND '" + endRow + "' AND READFLAG = '0' " ;
		} else if (type.equals("3")) {
			strSQL += " AND STARTDATE <= '" + commonUtil.getTodayUTCTime("") + "' AND ENDDATE < '" + commonUtil.getTodayUTCTime("") + "') T1 WHERE RNUM BETWEEN '" + startRow + "' AND '" + endRow + "' " ;
		}
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PUSERID", userID);
		map.put("v_PBOARDID", boardId);
		map.put("iv_PORDERBYSUB", orderOption1);
		map.put("v_STRSQL", strSQL);
		map.put("v_TENANTID", tenantID);
		
		return ezBoardDAO.getQnABoardListItem(map);
	}

	@Override
	public List<HashMap<String, Object>> getSearchBoardItemList(BoardListVO boardListVO, BoardVO boardVO) throws Exception {
		if (boardListVO.getOrderBySub().length() > 0) {
			if (boardListVO.getOrderBySub().indexOf("WRITEDATE") > -1) {
				if (boardListVO.getOrderBySub().indexOf("WRITEDATE DESC") > -1) {
					boardListVO.setOrderBySub(" A.PARENTWRITEDATE DESC, A.WRITEDATE ");
				} else {
					boardListVO.setOrderBySub(" A.PARENTWRITEDATE, A.WRITEDATE ");
				}
			}
		} else {
			boardListVO.setOrderBySub(" A.PARENTWRITEDATE DESC, A.WRITEDATE ");
		}
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PUSERID", boardListVO.getUserID());
		map.put("v_PBOARDID", boardVO.getBoardId());
		map.put("v_PSTARTROW", boardListVO.getStartRow());
		map.put("v_PENDROW", boardListVO.getEndRow());
		map.put("v_PTOTALCOUNT", boardListVO.getTotalCount());
		map.put("iv_PORDERBYSUB", boardListVO.getOrderBySub());
		map.put("v_PSUBFLAG", boardVO.getSubFlag());
		map.put("v_PSUBQUERY", boardVO.getSearchQuery());
		map.put("v_TITLE", boardVO.getTitle());
		map.put("v_WRITERNAME", boardVO.getWriterName());
		map.put("v_ABSTRACT", boardVO.getABSTRACT());
		map.put("v_TENANTID", boardVO.getTenantID());
		map.put("nowDate", commonUtil.getTodayUTCTime(""));
		
		if (boardVO.getSubFlag().equals("Y")) {
			map.put("v_PWHEREBOARD", " (A.BOARDID = '" + boardVO.getBoardId() + "' OR BOARDID IN (SELECT BOARDID FROM EZBOARDSTD.TBL_BOARD_BOARDINFO WHERE TENANT_ID = '" + boardVO.getTenantID() + "' AND PARENTBOARDID = '" + boardVO.getBoardId() + "'))");
		} else {
			map.put("v_PWHEREBOARD", " A.BOARDID = '" + boardVO.getBoardId() + "' ");
		}
		
		BoardMyFavoriteVO myFavoriteVO = new BoardMyFavoriteVO();
		myFavoriteVO.setBoardId(boardVO.getBoardId());
		myFavoriteVO.setTenantID(boardVO.getTenantID());
		
		String tempString = ezBoardDAO.getBoardApprList(myFavoriteVO);
		
		if (tempString != null && !tempString.equals("")) {
			map.put("v_TEMP", " AND A.APPRFLAG = 'Y' ");
		}
		
		return ezBoardDAO.getSearchBoardItemList(map);
	}

	@Override
	public List<HashMap<String, Object>> getThumbnailList(BoardListVO boardListVO, BoardVO boardVO) throws Exception {
		String strSQL = "";
		
		if (boardListVO.getOrderBySub().length() > 0) {
			if (boardListVO.getOrderBySub().indexOf("WRITEDATE") > -1) {
				if (boardListVO.getOrderBySub().indexOf("WRITEDATE DESC") > -1) {
					boardListVO.setOrderBySub(" A.PARENTWRITEDATE DESC, A.WRITEDATE ");
				} else {
					boardListVO.setOrderBySub(" A.PARENTWRITEDATE, A.WRITEDATE ");
				}
			}
		} else {
			boardListVO.setOrderBySub(" A.PARENTWRITEDATE DESC, A.WRITEDATE ");
		}
		
		BoardMyFavoriteVO boardMyFavoriteVO = new BoardMyFavoriteVO();
        boardMyFavoriteVO.setBoardId(boardVO.getBoardId());
        boardMyFavoriteVO.setTenantID(boardVO.getTenantID());
        
        String tempString = ezBoardDAO.getBoardApprJoinItem(boardMyFavoriteVO);
        
        if (tempString != null && !tempString.equals("")) {
        	strSQL += " AND A.APPRFLAG = 'Y' ";
        }
		
        if (boardVO.getType().equals("1")) {
        	strSQL += " AND STARTDATE <= '" + commonUtil.getTodayUTCTime("") + "' AND ENDDATE > '" + commonUtil.getTodayUTCTime("") + "') T1 WHERE RNUM BETWEEN '" + boardListVO.getStartRow() + "' AND '" + boardListVO.getEndRow() + "' " ;
        } else if (boardVO.getType().equals("2")) {
        	strSQL += " AND STARTDATE <= '" + commonUtil.getTodayUTCTime("") + "' AND ENDDATE > '" + commonUtil.getTodayUTCTime("") + "') T1 WHERE RNUM BETWEEN '" + boardListVO.getStartRow() + "' AND '" + boardListVO.getEndRow() + "' AND READFLAG = '0' " ;
        }
        
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PUSERID", boardListVO.getUserID());
		map.put("v_TENANTID", boardVO.getTenantID());
		map.put("v_PBOARDID", boardVO.getBoardId());
		map.put("iv_PORDERBYSUB", boardListVO.getOrderBySub());
		map.put("v_STRSQL", strSQL);
		
		return ezBoardDAO.getThumbnailList(map);
	}

	@Override
	public List<HashMap<String, Object>> getSearchThumbnailList(BoardListVO boardListVO, BoardVO boardVO) throws Exception {
		if (boardListVO.getOrderBySub().length() > 0) {
			if (boardListVO.getOrderBySub().indexOf("WRITEDATE") > -1) {
				if (boardListVO.getOrderBySub().indexOf("WRITEDATE DESC") > -1) {
					boardListVO.setOrderBySub(" A.PARENTWRITEDATE DESC, A.WRITEDATE ");
				} else {
					boardListVO.setOrderBySub(" A.PARENTWRITEDATE, A.WRITEDATE ");
				}
			}
		} else {
			boardListVO.setOrderBySub(" A.PARENTWRITEDATE DESC, A.WRITEDATE ");
		}
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PUSERID", boardListVO.getUserID());
		map.put("v_PBOARDID", boardVO.getBoardId());
		map.put("v_PSTARTROW", boardListVO.getStartRow());
		map.put("v_PENDROW", boardListVO.getEndRow());
		map.put("v_PTOTALCOUNT", boardListVO.getTotalCount());
		map.put("iv_PORDERBYSUB", boardListVO.getOrderBySub());
		map.put("v_PSUBFLAG", boardVO.getSubFlag());
		map.put("v_PSUBQUERY", boardVO.getSearchQuery());
		map.put("v_TITLE", boardVO.getTitle());
		map.put("v_WRITERNAME", boardVO.getWriterName());
		map.put("v_ABSTRACT", boardVO.getABSTRACT());
		map.put("v_TENANTID", boardVO.getTenantID());
		map.put("v_TEMP", "");
		map.put("nowDate", commonUtil.getTodayUTCTime(""));
		
		if (boardVO.getSubFlag().equals("Y")) {
			map.put("v_PWHEREBOARD", " (A.BOARDID = '" + boardVO.getBoardId() + "' OR BOARDID IN (SELECT BOARDID FROM EZBOARDSTD.TBL_BOARD_BOARDINFO WHERE TENANT_ID = '" + boardVO.getTenantID() + "' AND PARENTBOARDID = '" + boardVO.getBoardId() + "'))");
		} else {
			map.put("v_PWHEREBOARD", " A.BOARDID = '" + boardVO.getBoardId() + "' ");
		}
		
		BoardMyFavoriteVO myFavoriteVO = new BoardMyFavoriteVO();
		myFavoriteVO.setBoardId(boardVO.getBoardId());
		myFavoriteVO.setTenantID(boardVO.getTenantID());
		
		String tempString = ezBoardDAO.getBoardApprList(myFavoriteVO);
		
		if (tempString != null && !tempString.equals("")) {
			map.put("v_TEMP", " AND A.APPRFLAG = 'Y' ");
		}
		
		return ezBoardDAO.getSearchThumbnailList(map);
	}

	@Override
	public List<HashMap<String, Object>> getMyNoticePostItem(LoginVO userInfo, String type, int start, int end) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PUSERID", userInfo.getId());
		map.put("v_TENANTID", userInfo.getTenantId());
		map.put("v_TYPE", type);
		map.put("v_START", start);
		map.put("v_END", end);
		map.put("nowDate", commonUtil.getTodayUTCTime(""));
		
		return ezBoardDAO.getMyNoticePostItem(map);
	}

	@Override
	public List<HashMap<String, Object>> getMyBoardListItem(LoginVO userInfo, int startRow, int endRow, int boardCount, String orderOption1, String orderOption2) throws Exception {
		if (orderOption1.length() > 0) {
			if (orderOption1.indexOf("WRITEDATE") > -1) {
				if (orderOption1.indexOf("WRITEDATE DESC") > -1) {
					orderOption1 = " A.PARENTWRITEDATE DESC, A.WRITEDATE ";
				} else {
					orderOption1 = " A.PARENTWRITEDATE, A.WRITEDATE ";
				}
			}
		} else {
			orderOption1 = " A.PARENTWRITEDATE DESC, A.WRITEDATE ";
		}
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PUSERID", userInfo.getId());
		map.put("v_TENANTID", userInfo.getTenantId());
		map.put("v_PSTARTROW", startRow);
		map.put("v_PENDROW", endRow);
		map.put("iv_PORDERBYSUB", orderOption1);
		map.put("nowDate", commonUtil.getTodayUTCTime(""));
		
		return ezBoardDAO.getMyBoardListItem(map);
	}

	@Override
	public List<HashMap<String, Object>> getMyBoardListItemTemp(LoginVO userInfo, int startRow, int endRow, int boardCount, String orderOption1, String orderOption2) throws Exception {
		if (orderOption1.length() > 0) {
			if (orderOption1.indexOf("WRITEDATE") > -1) {
				if (orderOption1.indexOf("WRITEDATE DESC") > -1) {
					orderOption1 = " A.PARENTWRITEDATE DESC, A.WRITEDATE ";
				} else {
					orderOption1 = " A.PARENTWRITEDATE, A.WRITEDATE ";
				}
			}
		} else {
			orderOption1 = " A.PARENTWRITEDATE DESC, A.WRITEDATE ";
		}
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PUSERID", userInfo.getId());
		map.put("v_TENANTID", userInfo.getTenantId());
		map.put("v_PSTARTROW", startRow);
		map.put("v_PENDROW", endRow);
		map.put("iv_PORDERBYSUB", orderOption1);
		
		return ezBoardDAO.getMyBoardListItemTemp(map);
	}

	@Override
	public List<HashMap<String, Object>> getApprBoardListItem(LoginVO userInfo, int startRow, int endRow, int boardCount, String orderOption1, String orderOption2) throws Exception {
		if (orderOption1.length() > 0) {
			if (orderOption1.indexOf("WRITEDATE") > -1) {
				if (orderOption1.indexOf("WRITEDATE DESC") > -1) {
					orderOption1 = " A.PARENTWRITEDATE DESC, A.WRITEDATE ";
				} else {
					orderOption1 = " A.PARENTWRITEDATE, A.WRITEDATE ";
				}
			}
		} else {
			orderOption1 = " A.PARENTWRITEDATE DESC, A.WRITEDATE ";
		}
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PUSERID", userInfo.getId());
		map.put("v_TENANTID", userInfo.getTenantId());
		map.put("v_PSTARTROW", startRow);
		map.put("v_PENDROW", endRow);
		map.put("iv_PORDERBYSUB", orderOption1);
		map.put("nowDate", commonUtil.getTodayUTCTime(""));
		
		return ezBoardDAO.getApprBoardListItem(map);
	}

	@Override
	public List<HashMap<String, Object>> getSearchMyBoardItemList(BoardListVO boardListVO, BoardVO boardVO) throws Exception {
		if (boardListVO.getOrderBySub().length() > 0) {
			if (boardListVO.getOrderBySub().indexOf("WRITEDATE") > -1) {
				if (boardListVO.getOrderBySub().indexOf("WRITEDATE DESC") > -1) {
					boardListVO.setOrderBySub(" A.PARENTWRITEDATE DESC, A.WRITEDATE ");
				} else {
					boardListVO.setOrderBySub(" A.PARENTWRITEDATE, A.WRITEDATE ");
				}
			}
		} else {
			boardListVO.setOrderBySub(" A.PARENTWRITEDATE DESC, A.WRITEDATE ");
		}
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PUSERID", boardListVO.getUserID());
		map.put("v_PSTARTROW", boardListVO.getStartRow());
		map.put("v_PENDROW", boardListVO.getEndRow());
		map.put("v_PTOTALCOUNT", boardListVO.getTotalCount());
		map.put("iv_PORDERBYSUB", boardListVO.getOrderBySub());
		map.put("v_PORDERBYMAIN", boardListVO.getOrderByMain());
		map.put("v_PSUBFLAG", boardVO.getSubFlag());
		map.put("v_PSUBQUERY", boardVO.getSearchQuery());
		map.put("v_TENANTID", boardVO.getTenantID());
		map.put("nowDate", commonUtil.getTodayUTCTime(""));
		
		return ezBoardDAO.getSearchMyBoardItemList(map);
	}

	@Override
	public List<HashMap<String, Object>> getSearchMyBoardItemListTemp(BoardListVO boardListVO, BoardVO boardVO) throws Exception {
		if (boardListVO.getOrderBySub().length() > 0) {
			if (boardListVO.getOrderBySub().indexOf("WRITEDATE") > -1) {
				if (boardListVO.getOrderBySub().indexOf("WRITEDATE DESC") > -1) {
					boardListVO.setOrderBySub(" A.PARENTWRITEDATE DESC, A.WRITEDATE ");
				} else {
					boardListVO.setOrderBySub(" A.PARENTWRITEDATE, A.WRITEDATE ");
				}
			}
		} else {
			boardListVO.setOrderBySub(" A.PARENTWRITEDATE DESC, A.WRITEDATE ");
		}
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PUSERID", boardListVO.getUserID());
		map.put("v_PSTARTROW", boardListVO.getStartRow());
		map.put("v_PENDROW", boardListVO.getEndRow());
		map.put("v_PTOTALCOUNT", boardListVO.getTotalCount());
		map.put("iv_PORDERBYSUB", boardListVO.getOrderBySub());
		map.put("v_PORDERBYMAIN", boardListVO.getOrderByMain());
		map.put("v_PSUBFLAG", boardVO.getSubFlag());
		map.put("v_PSUBQUERY", boardVO.getSearchQuery());
		map.put("v_TENANTID", boardVO.getTenantID());
		
		return ezBoardDAO.getSearchMyBoardItemListTemp(map);
	}

	@Override
	public int getCheckItemID(String itemID, String boardType, String userDeptPath, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_ITEMID", itemID);
		map.put("v_BOARDTYPE", boardType);
		map.put("v_ACCESSID", userDeptPath);
		map.put("v_TENANTID", tenantID);
		
		return ezBoardDAO.getCheckItemID(map);
	}

	@Override
	public BoardListVO getBrdGetItemInfo(String boardID, String itemID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pItemID", itemID);
		map.put("v_TENANTID", tenantID);
		
		return ezBoardDAO.getBrdGetItemInfo(map);
	}

	@Override
	public BoardListVO getBrdGetItemInfoTemp(String boardID, String itemID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pBoardID", boardID);
		map.put("v_pItemID", itemID);
		map.put("v_TENANTID", tenantID);
		
		return ezBoardDAO.getBrdGetItemInfoTemp(map);
	}

	@Override
	public BoardListVO getItemInfo(String itemID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("itemID", itemID);
		map.put("tenantID", tenantID);
		
		String tempString = ezBoardDAO.getBoardItem(map);
		
		if (tempString != null && !tempString.equals("")) {
			map.put("tempString", tempString);
		} else {
			map.put("tempString", "");
		}
		
		return ezBoardDAO.getItemInfo(map);
	}

	@Override
	public BoardListVO getCopyItem(String orgItemID, String orgBoardID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PORGITEMID", orgItemID);
		map.put("v_PORGBOARDID", orgBoardID);
		map.put("v_TENANTID", tenantID);
		
		return ezBoardDAO.getCopyItem(map);
	}

	@Override
	public List<BoardListVO> getAdjacentItems1(String boardID, String parentWriteDate, String upperItemIDTree, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PBOARDID", boardID);
		map.put("v_PPARENTWRITEDATE", parentWriteDate);
		map.put("v_PUPPERITEMIDTREE", upperItemIDTree);
		map.put("v_TENANTID", tenantID);
		map.put("nowDate", commonUtil.getTodayUTCTime(""));
		
		return ezBoardDAO.getAdjacentItems1(map);
	}

	@Override
	public List<BoardListVO> getAdjacentItems2(String boardID, String parentWriteDate, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PBOARDID", boardID);
		map.put("v_PPARENTWRITEDATE", parentWriteDate);
		map.put("v_TENANTID", tenantID);
		map.put("nowDate", commonUtil.getTodayUTCTime(""));
		
		return ezBoardDAO.getAdjacentItems2(map);
	}

	@Override
	public List<BoardListVO> getAdjacentItems3(String boardID, String parentWriteDate, String itemID, String upperItemIDTree, String previousItemID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PBOARDID", boardID);
		map.put("v_PPARENTWRITEDATE", parentWriteDate);
		map.put("v_PITEMID", itemID);
		map.put("v_PUPPERITEMIDTREE", upperItemIDTree);
		map.put("v_PREVIOUSITEMID", previousItemID);
		map.put("v_TENANTID", tenantID);
		map.put("nowDate", commonUtil.getTodayUTCTime(""));
		
		return ezBoardDAO.getAdjacentItems3(map);
	}

	@Override
	public List<BoardListVO> getAdjacentItems2Photo(String boardID, String parentWriteDate, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PBOARDID", boardID);
		map.put("v_PPARENTWRITEDATE", parentWriteDate);
		map.put("v_TENANTID", tenantID);
		map.put("nowDate", commonUtil.getTodayUTCTime(""));
		
		return ezBoardDAO.getAdjacentItems2Photo(map);
	}

	@Override
	public List<BoardListVO> getAdjacentItems3Photo(String boardID, String parentWriteDate, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PBOARDID", boardID);
		map.put("v_PPARENTWRITEDATE", parentWriteDate);
		map.put("v_TENANTID", tenantID);
		map.put("nowDate", commonUtil.getTodayUTCTime(""));
		
		return ezBoardDAO.getAdjacentItems3Photo(map);
	}

	@Override
	public List<BoardAttachVO> photoViewDB(String itemID, String boardID, int pStartRow, int pEndRow, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pItemID", itemID);
		map.put("v_pBoardID", boardID);
		map.put("v_pStartRow", pStartRow);
		map.put("v_pEndRow", pEndRow);
		map.put("v_TENANTID", tenantID);
		
		return ezBoardDAO.photoViewDB(map);
	}

	@Override
	public List<BoardAttachVO> photoViewDBAll(String itemID, String boardID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pItemID", itemID);
		map.put("v_pBoardID", boardID);
		map.put("v_TENANTID", tenantID);
		
		return ezBoardDAO.photoViewDBAll(map);
	}

	@Override
	public List<String> getCopyItemAttach(String orgItemID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("orgItemID", orgItemID);
		map.put("tenantID", tenantID);
		
		return ezBoardDAO.getCopyItemAttach(map);
	}

	@Override
	public void setAsRead(LoginVO userInfo, String boardID, String itemID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pBoardID", boardID);
		map.put("v_pItemID", itemID);
		map.put("v_pUserID", userInfo.getId());
		map.put("v_pUserName", userInfo.getDisplayName1());
		map.put("v_pUserDeptName", userInfo.getDeptName1());
		map.put("v_pUserCompanyName", userInfo.getCompanyName1());
		map.put("v_pUserTitle", userInfo.getTitle1());
		map.put("v_pUserName2", userInfo.getDisplayName2());
		map.put("v_pUserDeptName2", userInfo.getDeptName2());
		map.put("v_pUserCompanyName2", userInfo.getCompanyName2());
		map.put("v_pUserTitle2", userInfo.getTitle2());
		map.put("v_TENANTID", userInfo.getTenantId());
		map.put("nowDate", commonUtil.getTodayUTCTime(""));
		
		String tempString = ezBoardDAO.getBoardItemRead(map);
		
		if (tempString != null && !tempString.equals("")) {
			ezBoardDAO.setAsRead(map);
			
			String tempWriterID = ezBoardDAO.getWriterID(map);
			
			if (tempWriterID.equals(userInfo.getId())) {
				ezBoardDAO.setAsRead2(map);
			}
		}
	}

	@Override
	public int getCheckApprUserList(String userID, String itemID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PUSERID", userID);
		map.put("v_PITEMID", itemID);
		map.put("v_TENANTID", tenantID);
		
		return ezBoardDAO.getCheckApprUserList(map);
	}

	@Override
	public int getSearchBoardItemCount(BoardVO boardVO) throws Exception {
		if (boardVO.getSearchQuery().length() > 0) {
			boardVO.setSearchQuery(" AND " + boardVO.getSearchQuery());
		}
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pBoardID", boardVO.getBoardId());
		map.put("v_PSUBFLAG", boardVO.getSubFlag());
		map.put("v_PSUBQUERY", boardVO.getSearchQuery());
		map.put("v_TENANTID", boardVO.getTenantID());
		
		if (boardVO.getSubFlag().equals("Y")) {
			map.put("v_PWHEREBOARD", " (BOARDID = '" + boardVO.getBoardId() + "' OR BOARDID IN (SELECT BOARDID FROM EZBOARDSTD.TBL_BOARD_BOARDINFO WHERE TENANT_ID = '" + boardVO.getTenantID() + "' AND PARENTBOARDID = '" + boardVO.getBoardId() + "'))");
		} else {
			map.put("v_PWHEREBOARD", " BOARDID = '" + boardVO.getBoardId() + "' ");
		}
		
		return ezBoardDAO.getSearchBoardItemCount(map);
	}

	@Override
	public int checkApprUserList(String userID, String itemID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PUSERID", userID);
		map.put("v_PITEMID", itemID);
		map.put("v_TENANTID", tenantID);
		
		return ezBoardDAO.checkApprUserList(map);
	}

	@Override
	public int getMyBoardTotalItemCount(LoginVO userInfo) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PUSERID", userInfo.getId());
		map.put("v_TENANTID", userInfo.getTenantId());
		map.put("nowDate", commonUtil.getTodayUTCTime(""));
		
		return ezBoardDAO.getMyBoardTotalItemCount(map);
	}

	@Override
	public int getMyBoardTotalItemCountTemp(LoginVO userInfo) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PUSERID", userInfo.getId());
		map.put("v_TENANTID", userInfo.getTenantId());
		
		return ezBoardDAO.getMyBoardTotalItemCountTemp(map);
	}

	@Override
	public int getMyNoticePostItemCount(LoginVO userInfo) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PUSERID", userInfo.getId());
		map.put("v_TENANTID", userInfo.getTenantId());
		map.put("nowDate", commonUtil.getTodayUTCTime(""));
		
		return ezBoardDAO.getMyNoticePostItemCount(map);
	}

	@Override
	public int getSearchMyBoardItemCount(LoginVO userInfo, BoardVO boardVO) throws Exception {
		if (boardVO.getSearchQuery().length() > 0) {
			boardVO.setSearchQuery(" AND " + boardVO.getSearchQuery());
		}
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PUSERID", userInfo.getId());
		map.put("v_PSUBFLAG", boardVO.getSubFlag());
		map.put("v_PSUBQUERY", boardVO.getSearchQuery());
		map.put("v_TENANTID", boardVO.getTenantID());
		map.put("nowDate", commonUtil.getTodayUTCTime(""));
		
		return ezBoardDAO.getSearchMyBoardItemCount(map);
	}

	@Override
	public int getSearchMyBoardItemCountTemp(LoginVO userInfo, BoardVO boardVO) throws Exception {
		if (boardVO.getSearchQuery().length() > 0) {
			boardVO.setSearchQuery(" AND " + boardVO.getSearchQuery());
		}
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PUSERID", userInfo.getId());
		map.put("v_PSUBFLAG", boardVO.getSubFlag());
		map.put("v_PSUBQUERY", boardVO.getSearchQuery());
		map.put("v_TENANTID", boardVO.getTenantID());
		
		return ezBoardDAO.getSearchMyBoardItemCountTemp(map);
	}

	@Override
	public int getApprBoardTotalItemCount(LoginVO userInfo) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("id", userInfo.getId());
		map.put("tenantID", userInfo.getTenantId());
		map.put("nowDate", commonUtil.getTodayUTCTime(""));
		
		return ezBoardDAO.getApprBoardTotalItemCount(map);
	}

	@Override
	public String checkForm(String boardID, String mode, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PBOARDID", boardID);
		map.put("v_PMODE", mode);
		map.put("v_TENANTID", tenantID);
		
		String checkForm = "";
		int checkCnt = ezBoardDAO.checkForm(map);
		
		if (checkCnt > 0) {
			checkForm = "TRUE";
		} else {
			checkForm = "FALSE";
		}
		
		return checkForm;
	}

	@Override
	public String checkBackGroundImage(String boardID, int tenantID) throws Exception {
		String check = "";
		int checkCnt = ezBoardDAO.checkBackGroundImage(boardID);
		
		if (checkCnt > 0) {
			check = "TRUE";
		} else {
			check = "FALSE";
		}
		
		return check;
	}

	@Override
	public String brdCheckIfHasReply(String itemID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pItemID", itemID);
		map.put("v_TENANTID", tenantID);
		
		String check = "";
		int checkCnt = ezBoardDAO.brdCheckIfHasReply(map);
		
		if (checkCnt > 0) {
			check = "TRUE";
		} else {
			check = "FALSE";
		}
		
		return check;
	}

	@Override
	public String getNoticePostItemAll(String boardID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("boardID", boardID);
		map.put("tenantID", tenantID);
		map.put("nowDate", commonUtil.getTodayUTCTime(""));
		
		List<BoardListVO> resultList = ezBoardDAO.getNoticePostItemAll(map);
		
		StringBuilder sb = new StringBuilder();
		sb.append("<DATA>");
		
		for (int i = 0; i < resultList.size(); i++) {
			sb.append(commonUtil.getQueryResult(resultList.get(i)));
		}
		sb.append("</DATA>");
		
		return sb.toString();
	}

	@Override
	public String getParentBoardID(String boardID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("boardID", boardID);
		map.put("tenantID", tenantID);
		
		return ezBoardDAO.getParentBoardID(map);
	}

	@Override
	public String getDocPassWord(String itemID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("itemID", itemID);
		map.put("tenantID", tenantID);
		
		return ezBoardDAO.getDocPassWord(map);
	}

	@Override
	public String deleteTempItem(String strItemID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("itemID", strItemID);
		map.put("tenantID", tenantID);
		
		try {
			ezBoardDAO.deleteBoardItemTemp(map);
			ezBoardDAO.deleteBoardItemAttach(map);
			ezBoardDAO.deleteBoardItemRead2(map);
			ezBoardDAO.deleteBoardReply(map);
			
			return "OK";
		} catch (Exception e) {
			logger.error("EzBoard :: deleteTempItem");
			return "NO";
		}
	}

	@Override
	public String getItemXML(String boardID, String itemID, String lang, String offset, int tenantID) throws Exception {
		StringBuilder sb = new StringBuilder();
		
		if (boardID != null) {
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("v_pBoardID", boardID);
			map.put("v_pItemID", itemID);
			map.put("v_TENANTID", tenantID);
			
			BoardListVO itemInfo = ezBoardDAO.getBrdGetItemInfo(map);
			
			sb.append("<NODES>");
			sb.append("<NODE>");
			sb.append("<ItemID>" + itemInfo.getItemID() + "</ItemID>");
			sb.append("<WriterID>" + itemInfo.getWriterID() + "</WriterID>");
			
			if (lang.equals("")) {
				sb.append("<WriterName>" + commonUtil.cleanValue(itemInfo.getWriterName()) + "</WriterName>");
				sb.append("<WriterDeptName>" + commonUtil.cleanValue(itemInfo.getWriterDeptName()) + "</WriterDeptName>");
				sb.append("<WriterCompanyName>" + commonUtil.cleanValue(itemInfo.getWriterCompanyName()) + "</WriterCompanyName>");
			} else {
				sb.append("<WriterName>" + commonUtil.cleanValue(itemInfo.getWriterName2()) + "</WriterName>");
				sb.append("<WriterDeptName>" + commonUtil.cleanValue(itemInfo.getWriterDeptName2()) + "</WriterDeptName>");
				sb.append("<WriterCompanyName>" + commonUtil.cleanValue(itemInfo.getWriterCompanyName2()) + "</WriterCompanyName>");
			}
			sb.append("<WriteDate>" + commonUtil.getDateStringInUTC(itemInfo.getWriteDate(), offset, false) + "</WriteDate>");
			sb.append("<ParentWriteDate>" + commonUtil.getDateStringInUTC(itemInfo.getParentWriteDate(), offset, false) + "</ParentWriteDate>");
			sb.append("<Importance>" + itemInfo.getImportance() + "</Importance>");
			sb.append("<Title>" + commonUtil.cleanValue(itemInfo.getTitle()) + "</Title>");
			sb.append("<ContentLocation>" + itemInfo.getContentLocation() + "</ContentLocation>");
			sb.append("<StartDate>" + commonUtil.getDateStringInUTC(itemInfo.getStartDate(), offset, false) + "</StartDate>");
			sb.append("<EndDate>" + commonUtil.getDateStringInUTC(itemInfo.getEndDate(), offset, false) + "</EndDate>");
			sb.append("<Abstract>" + commonUtil.cleanValue(itemInfo.getABSTRACT()) + "</Abstract>");
			sb.append("<Attachments>" + commonUtil.cleanValue(itemInfo.getAttachments()) + "</Attachments>");
			sb.append("<UpperItemIDTree>" + itemInfo.getUpperItemIDTree() + "</UpperItemIDTree>");
			sb.append("<ItemLevel>" + itemInfo.getItemLevel() + "</ItemLevel>");
			sb.append("<copiedItem>" + itemInfo.getCopiedItem() + "</copiedItem>");
			sb.append("<ExtensionAttribute1>" + commonUtil.cleanValue(itemInfo.getExtensionAttribute1()) + "</ExtensionAttribute1>");
			sb.append("<ExtensionAttribute2>" + commonUtil.cleanValue(itemInfo.getExtensionAttribute2()) + "</ExtensionAttribute2>");
			
			if (lang.equals("")) {
				sb.append("<ExtensionAttribute3>" + commonUtil.cleanValue(itemInfo.getExtensionAttribute3()) + "</ExtensionAttribute3>");
			} else {
				sb.append("<ExtensionAttribute3>" + commonUtil.cleanValue(itemInfo.getExtensionAttribute32()) + "</ExtensionAttribute3>");
			}
			sb.append("<ExtensionAttribute4>" + commonUtil.cleanValue(itemInfo.getExtensionAttribute4()) + "</ExtensionAttribute4>");
			sb.append("<ExtensionAttribute5>" + commonUtil.cleanValue(itemInfo.getExtensionAttribute5()) + "</ExtensionAttribute5>");
			sb.append("<MainContent>" + commonUtil.cleanValue(itemInfo.getMainContent()) + "</MainContent>");   
			sb.append("<APPRFLAG>" + commonUtil.cleanValue(itemInfo.getApprFlag()) + "</APPRFLAG>");
			sb.append("<GUBUN>" + commonUtil.cleanValue(itemInfo.getGuBun()) + "</GUBUN>");
			//확장값 추가
			sb.append("<ExtensionAttribute6>" + commonUtil.cleanValue(itemInfo.getExtensionAttribute6()) + "</ExtensionAttribute6>");
			sb.append("<ExtensionAttribute7>" + commonUtil.cleanValue(itemInfo.getExtensionAttribute7()) + "</ExtensionAttribute7>");
			sb.append("<ExtensionAttribute8>" + commonUtil.cleanValue(itemInfo.getExtensionAttribute8()) + "</ExtensionAttribute8>");
			sb.append("<ExtensionAttribute9>" + commonUtil.cleanValue(itemInfo.getExtensionAttribute9()) + "</ExtensionAttribute9>");
			sb.append("<ExtensionAttribute10>" + commonUtil.cleanValue(itemInfo.getExtensionAttribute10()) + "</ExtensionAttribute10>");
			sb.append("<BoardID>" + commonUtil.cleanValue(itemInfo.getBoardID()) + "</BoardID>");
			sb.append("</NODE>");
			sb.append("</NODES>");
		} else {
			sb.append("<NODES>");
			sb.append("</NODES>");
		}

		return sb.toString();
	}

	@Override
	public String getItemTempXML(String boardID, String itemID, String lang, String offset, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pBoardID", boardID);
		map.put("v_pItemID", itemID);
		map.put("v_TENANTID", tenantID);
		
		BoardListVO itemInfo = ezBoardDAO.getBrdGetItemInfoTemp(map);

		StringBuilder sb = new StringBuilder();

		sb.append("<NODES>");
		sb.append("<NODE>");
		sb.append("<ItemID>" + itemInfo.getItemID() + "</ItemID>");
		sb.append("<WriterID>" + itemInfo.getWriterID() + "</WriterID>");
		
		if (lang.equals("")) {
			sb.append("<WriterName>" + commonUtil.cleanValue(itemInfo.getWriterName()) + "</WriterName>");
			sb.append("<WriterDeptName>" + commonUtil.cleanValue(itemInfo.getWriterDeptName()) + "</WriterDeptName>");
			sb.append("<WriterCompanyName>" + commonUtil.cleanValue(itemInfo.getWriterCompanyName()) + "</WriterCompanyName>");
		} else {
			sb.append("<WriterName>" + commonUtil.cleanValue(itemInfo.getWriterName2()) + "</WriterName>");
			sb.append("<WriterDeptName>" + commonUtil.cleanValue(itemInfo.getWriterDeptName2()) + "</WriterDeptName>");
			sb.append("<WriterCompanyName>" + commonUtil.cleanValue(itemInfo.getWriterCompanyName2()) + "</WriterCompanyName>");
		}
		sb.append("<WriteDate>" + commonUtil.getDateStringInUTC(itemInfo.getWriteDate(), offset, false) + "</WriteDate>");
		sb.append("<ParentWriteDate>" + commonUtil.getDateStringInUTC(itemInfo.getParentWriteDate(), offset, false) + "</ParentWriteDate>");
		sb.append("<Importance>" + itemInfo.getImportance() + "</Importance>");
		sb.append("<Title>" + commonUtil.cleanValue(itemInfo.getTitle()) + "</Title>");
		sb.append("<ContentLocation>" + itemInfo.getContentLocation() + "</ContentLocation>");
		sb.append("<StartDate>" + commonUtil.getDateStringInUTC(itemInfo.getStartDate(), offset, false) + "</StartDate>");
		sb.append("<EndDate>" + commonUtil.getDateStringInUTC(itemInfo.getEndDate(), offset, false) + "</EndDate>");
		sb.append("<Abstract>" + commonUtil.cleanValue(itemInfo.getABSTRACT()) + "</Abstract>");
		sb.append("<Attachments>" + commonUtil.cleanValue(itemInfo.getAttachments()) + "</Attachments>");
		sb.append("<UpperItemIDTree>" + itemInfo.getUpperItemIDTree() + "</UpperItemIDTree>");
		sb.append("<ItemLevel>" + itemInfo.getItemLevel() + "</ItemLevel>");
		sb.append("<copiedItem>" + itemInfo.getCopiedItem() + "</copiedItem>");
		sb.append("<ExtensionAttribute1>" + commonUtil.cleanValue(itemInfo.getExtensionAttribute1()) + "</ExtensionAttribute1>");
		sb.append("<ExtensionAttribute2>" + commonUtil.cleanValue(itemInfo.getExtensionAttribute2()) + "</ExtensionAttribute2>");
		
        if (lang.equals("")) {
        	sb.append("<ExtensionAttribute3>" + commonUtil.cleanValue(itemInfo.getExtensionAttribute3()) + "</ExtensionAttribute3>");
        } else {
        	sb.append("<ExtensionAttribute3>" + commonUtil.cleanValue(itemInfo.getExtensionAttribute32()) + "</ExtensionAttribute3>");
        }
        sb.append("<ExtensionAttribute4>" + commonUtil.cleanValue(itemInfo.getExtensionAttribute4()) + "</ExtensionAttribute4>");
		sb.append("<ExtensionAttribute5>" + commonUtil.cleanValue(itemInfo.getExtensionAttribute5()) + "</ExtensionAttribute5>");
        sb.append("<MainContent>" + commonUtil.cleanValue(itemInfo.getMainContent()) + "</MainContent>");   
        //확장값 추가
        sb.append("<ExtensionAttribute6>" + commonUtil.cleanValue(itemInfo.getExtensionAttribute6()) + "</ExtensionAttribute6>");
        sb.append("<ExtensionAttribute7>" + commonUtil.cleanValue(itemInfo.getExtensionAttribute7()) + "</ExtensionAttribute7>");
        sb.append("<ExtensionAttribute8>" + commonUtil.cleanValue(itemInfo.getExtensionAttribute8()) + "</ExtensionAttribute8>");
        sb.append("<ExtensionAttribute9>" + commonUtil.cleanValue(itemInfo.getExtensionAttribute9()) + "</ExtensionAttribute9>");
        sb.append("<ExtensionAttribute10>" + commonUtil.cleanValue(itemInfo.getExtensionAttribute10()) + "</ExtensionAttribute10>");
        sb.append("<BoardID>" + commonUtil.cleanValue(itemInfo.getBoardID()) + "</BoardID>");
		sb.append("</NODE>");
		sb.append("</NODES>");

		return sb.toString();
	}

	@Override
	public String setBoardConfig(String userID, String listCount, String preView, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_USERID", userID);
		map.put("v_LISTCOUNT", listCount);
		map.put("v_PREVIEW", preView);
		map.put("v_TENANTID", tenantID);
		
		try {
			String tempString = ezBoardDAO.getBoardConfig(map);
			
			if (tempString != null && !tempString.equals("")) {
				ezBoardDAO.setBoardConfig(map);
			} else {
				ezBoardDAO.setBoardConfig2(map);
			}
			
			return "OK";
		} catch (Exception e) {
			return "NO";
		}
	}

	@Override
	public String apprItem(String userID, String item, String pMod, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_ITEMID", item);
		map.put("v_MODE", pMod);
		map.put("v_USERID", userID);
		map.put("v_TENANTID", tenantID);
		
		try {
			String tempString = ezBoardDAO.getBoardApprListUser(map);
			
			if (tempString != null && !tempString.equals("")) {
				ezBoardDAO.apprItem(map);
			}
			
			return "OK";
		} catch (Exception e) {
			logger.error("EzBoard :: apprItem");
			return "ERROR" + e.getMessage();
		}
	}

	@Override
	public String deleteOneLineReply(String userID, String replyID, String guBun, int tenantID) throws Exception {
		String rtnValue = "";
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_USERINFO_USERID", userID);
		map.put("v_REPLYID", replyID);
		map.put("v_GUBUN", guBun);
		map.put("v_TENANTID", tenantID);
		
		try {
			int totalCount = ezBoardDAO.getBoardOneLineReply(map);
			
			if (totalCount > 0) {
				ezBoardDAO.deleteOneLineReply(map);
				
				rtnValue = "OK_DELETED";
			} else {
				rtnValue = "FAIL";
			}
		} catch (Exception e) {
			logger.error("EzBoard :: deleteOneLineReply");
			rtnValue = "FAIL";
		}
		
		return rtnValue;
	}

	@Override
	public String checkOneLineOwner(String replyID, String userID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_ReplyID", replyID);
		map.put("v_UserID", userID);
		map.put("v_TENANTID", tenantID);
		
		String resultMessage = "";
		int result = ezBoardDAO.checkOneLineOwner(map);
		
		if(result > 0) {
			resultMessage = "OK_MINE";
		} else {
			resultMessage = "FAIL";
		}
		
		return resultMessage;
	}

	@Override
	public List<BoardListVO> getReservedItemList(String userID, int startRow, int endRow, String sortBy, String lang, String offset, int tenantID) throws Exception {
		if(!(endRow > 0)){
			endRow = 0;
		}
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PENDROW", endRow);
		map.put("v_PUSERID", userID);
		map.put("v_PSORTBY", sortBy);
		map.put("v_TENANTID", tenantID);
		map.put("nowDate", commonUtil.getTodayUTCTime(""));
		
		List<BoardListVO> boardListVOs = ezBoardDAO.getReservedItemList(map);
		
		for (int k = 0; k < boardListVOs.size(); k++) {
			boardListVOs.get(k).setStartDate(commonUtil.getDateStringInUTC(boardListVOs.get(k).getStartDate(), offset, false));
			boardListVOs.get(k).setEndDate(commonUtil.getDateStringInUTC(boardListVOs.get(k).getEndDate(), offset, false));
		}
		
		return boardListVOs;
	}

	@Override
	public List<BoardLineReplyVO> readOneLineReply(String boardID, String itemID, String userName, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_BoardID", boardID);
		map.put("v_ItemID", itemID);
		map.put("v_UserName", userName);
		map.put("v_TENANTID", tenantID);
		
		return ezBoardDAO.readOneLineReply(map);
	}

	@Override
	public int getReservedItemListCount(String userID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userID", userID);
		map.put("tenantID", tenantID);
		map.put("nowDate", commonUtil.getTodayUTCTime(""));
		
		return ezBoardDAO.getReservedItemListCount(map);
	}

	@Override
	public void brdNewItem(BoardListVO boardListVO) throws Exception {
		String tempString = ezBoardDAO.getApprFlag(boardListVO);
		
		if (tempString != null && tempString.equals("Y")) {
			ezBoardDAO.brdNewItem(boardListVO);
		} else {
			ezBoardDAO.brdNewItem2(boardListVO);
		}
		
		ezBoardDAO.newItem(boardListVO);
	}

	@Override
	public void brdNewItemPhoto(BoardListVO boardListVO) throws Exception {
		String tempString = ezBoardDAO.getApprFlag(boardListVO);
		
		if (tempString != null && tempString.equals("Y")) {
			ezBoardDAO.brdNewItemPhoto(boardListVO);
		} else {
			ezBoardDAO.brdNewItemPhoto2(boardListVO);
		}
		
		photoSaveDB(boardListVO);
		ezBoardDAO.newItem(boardListVO);
	}

	@Override
	public void brdNewItemTemp(BoardListVO boardListVO) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pIMAGEID", boardListVO.getImageID());
		map.put("v_TENANTID", boardListVO.getTenantID());
		
		ezBoardDAO.deletePhotoImageItem(map);
		ezBoardDAO.brdNewItemTemp(boardListVO);
		ezBoardDAO.newItem(boardListVO);
	}

	@Override
	public void brdNewItemTempPhoto(BoardListVO boardListVO) throws Exception {
		ezBoardDAO.brdNewItemTempPhoto(boardListVO);
		photoSaveDB(boardListVO);
		ezBoardDAO.newItem(boardListVO);
	}

	@Override
	public void photoListInsert(BoardListVO boardListVO) throws Exception {
		ezBoardDAO.photoListInsert(boardListVO);
	}

	@Override
	public void brdUpdateItem(BoardListVO boardListVO, String mode) throws Exception {
		ezBoardDAO.brdUpdateItem(boardListVO);
		
		if (boardListVO.getReadFlag().equals("Y")) {
			ezBoardDAO.setInitReadCount(boardListVO);
		}
		ezBoardDAO.setApprFlag(boardListVO);
		ezBoardDAO.deleteBoardItemRead(boardListVO);
		
		if(mode.equals("PHOTO")){
			photoSaveDB(boardListVO);
		}
		
		ezBoardDAO.newItem(boardListVO);
	}

	public void photoSaveDB(BoardListVO boardListVO) throws Exception{
		Map<String, Object> map = new HashMap<String, Object>();
		String strFilePath = "";
		
		for(int i = 0; i < boardListVO.getImageCount(); i++){
			strFilePath = boardListVO.getExtensionAttribute5().split(";")[i];
			File file = new File(boardListVO.getRealPath() + boardListVO.getFilePath() + commonUtil.separator + strFilePath);
			strFilePath = boardListVO.getBoardID() + commonUtil.separator + "uploadFile" + boardListVO.getExtensionAttribute5().split(";")[i].replace("tempUploadFile", "");
			File mvFile = new File(boardListVO.getRealPath() + boardListVO.getFilePath() + commonUtil.separator + strFilePath);
			
			if(!mvFile.exists()){
				FileUtils.copyFile(file, mvFile);
			}
			
			map.put("v_pIMAGEID", boardListVO.getImagePath().split(";")[i].trim());
			map.put("v_pItemID", boardListVO.getItemID());
			map.put("v_pBoardID", boardListVO.getBoardID());
			map.put("v_pWriterID", boardListVO.getWriterID());
			map.put("v_pWriterName", boardListVO.getWriterName());
			map.put("v_pWriterDeptID", boardListVO.getWriterDeptID());
			map.put("v_pFilePath", strFilePath);
			map.put("v_pWriteDate", boardListVO.getWriteDate());
			map.put("v_TENANTID", boardListVO.getTenantID());
			
			try {
				map.put("v_pFileContent", boardListVO.getImageContent().split(";:;")[i]);
			} catch (Exception e) {
				map.put("v_pFileContent", "");
			}
			map.put("v_pImageName", boardListVO.getImageNames().split(";")[i]);
			
			ezBoardDAO.deletePhotoImageItem(map);
			ezBoardDAO.photoSaveDB(map);
		}
	}

	@Override
	public void saveAttachInfo(String strItemID, String filePath, long fileSize, String fileName, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_STRITEMID", strItemID);
		map.put("v_STRATTACHMENTS", filePath);
		map.put("v_FILESIZE", fileSize);
		map.put("v_FILENAME", fileName);
		map.put("v_TENANTID", tenantID);
		
		ezBoardDAO.saveAttachInfo(map);
	}
	
	@Override
	public void saveOneLineReply(String itemID, String replyID, String boardID, LoginVO userInfo, String content, String password) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("PITEMID", itemID);
		map.put("PREPLYID", replyID);
		map.put("PBOARDID", boardID);
		map.put("USERID", userInfo.getId());
		map.put("USERNAME", userInfo.getDeptName1());
		map.put("USERNAME2", userInfo.getDeptName2());
		map.put("PCONTENT", content);
		map.put("PPASSWORD", password);
		map.put("TENANTID", userInfo.getTenantId());
		map.put("nowDate", commonUtil.getTodayUTCTime(""));
		
		ezBoardDAO.saveOneLineReply(map);
	}
	
	public String getThumbListXML(String pUserID, String pBoardType, String pBoardID, int pPageNum, String sortHeader, String sortOption, String strLang, String offset, int tenantID) throws Exception {
		BoardListVO boardListVO = new BoardListVO();
		BoardVO ezBoardVO = new BoardVO();
		ezBoardVO.setBoardType(pBoardType);
		ezBoardVO.setLang(strLang);
		
		BoardMyFavoriteVO myFavoriteVO = new BoardMyFavoriteVO();
		myFavoriteVO.setBoardId(pBoardID);
		myFavoriteVO.setUserId(pUserID);
        myFavoriteVO.setType(pBoardType);
		
		StringBuilder sb = new StringBuilder();
		String orderOption1 = "";
		String orderOption2 = "";
		
		String strMultiData = commonUtil.getMultiData(strLang);
		
		List<BoardListHeaderVO> list = getListHeader(ezBoardVO);
		
		int i = 0;
		int hLength = list.size();
		
		int boardCount = getThumbNailCount(myFavoriteVO);
		int personalCount = 5;
		
		sb.append("<DOCLIST>");
		sb.append("<TOTALCNT>"+boardCount+"</TOTALCNT>");
		sb.append("<PAGECNT>"+boardCount+"</PAGECNT>");
		sb.append("<PERSONALCNT>"+personalCount+"</PERSONALCNT>");
		sb.append("<LISTVIEWDATA>");
		sb.append("<ROWS>");
		
//		BoardConfigVO pCount = getPersonalCount(pUserID);
		
		int startRow = 1;
		int endRow = 0;
		String fieldName = "";
		String fieldValue = "";
		
		startRow = (personalCount * (pPageNum - 1)) + 1;
		endRow = personalCount * pPageNum;
		
		BoardVO boardVO = new BoardVO();
		
		boardListVO.setUserID(pUserID);
		boardListVO.setBoardID(pBoardID);
		boardListVO.setStartRow(startRow);
		boardListVO.setEndRow(endRow);
		boardListVO.setTotalCount(boardCount);
		boardListVO.setOrderBySub(orderOption1.trim());
		boardListVO.setOrderByMain(orderOption2.trim());
		boardVO.setType("1");
		boardVO.setBoardId(pBoardID);
		boardVO.setTenantID(tenantID);
		
		List<HashMap<String, Object>> boardList = getThumbnailList(boardListVO, boardVO);
		
		int dLength = boardList.size();
		
		for (int j=0; j<dLength; j++) {
			sb.append("<ROW>");
			for (i =0; i < hLength; i++) {
				sb.append("<CELL>");
				fieldName = list.get(i).getColName().toUpperCase();
				
				if (fieldName.equals("WRITERNAME") || fieldName.equals("WRITERJOBTITLE") || fieldName.equals("WRITERDEPTNAME")) {
					fieldName = fieldName + strMultiData;
				}
				
				if (fieldName.equals("WRITEDATE")) {
					fieldValue =(String)boardList.get(j).get(fieldName);
                	fieldValue = fieldValue.substring(0, fieldValue.length()-3);
                	fieldValue = commonUtil.getDateStringInUTC(fieldValue, offset, false);
				} else {
					fieldValue = commonUtil.cleanValue(String.valueOf(boardList.get(j).get(fieldName)));
				}
				
				sb.append("<VALUE>"+fieldValue+"</VALUE>");
				
				if (i == 0) {
					sb.append("<DATA1>" + boardList.get(j).get("BOARDID") + "</DATA1>");
                	sb.append("<DATA2>" + boardList.get(j).get("ITEMID") + "</DATA2>");
        			sb.append("<DATA3>" + boardList.get(j).get("WRITERID") + "</DATA3>");
        			String nowDate = commonUtil.getTodayUTCTime("");
				    nowDate = EgovDateUtil.addDay(nowDate, -1, "yyyy-MM-dd HH:mm:ss");
				    
					if (boardList.get(j).get("WRITEDATE").toString().compareTo(nowDate) > 0) {
						sb.append("<DATA4>Y</DATA4>");
					} else {
						sb.append("<DATA4>N</DATA4>");
					}
					sb.append("<DATA5>" + boardList.get(j).get("FILEPATH") + "</DATA5>");
					sb.append("<DATA6>" + boardList.get(j).get("MAINCONTENT") + "</DATA6>");
				}
				sb.append("</CELL>");
			}
			sb.append("</ROW>");
		}
		
		sb.append("</ROWS>");
		sb.append("</LISTVIEWDATA>");
		sb.append("</DOCLIST>");
		
		return sb.toString();
	}

	@Override
	public String portalPageItemEdit(String boardID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("boardID", boardID);
		map.put("tenantID", tenantID);
		
		return ezBoardDAO.portalPageItemEdit(map);
	}

	/**
	 * 게시판 트리 표출 Method
	 */
	@Override
	public String getBoardTree(String pRootBoardID, String pUserID, String pDeptID, String pCompanyID, int pMode, int pSubFlag, int pSelectBy, String pExcludeBoardID, String pStrLang, int tenantID) throws Exception {
		int count = 0;
        String strForbiddenBoardIDList = "";				
        String retValue = ezBoardAdminService.getBoardTree_Get1(pStrLang, pRootBoardID + "," + pUserID + "," + pDeptID + "," + pCompanyID + "," + pMode + "," + pSubFlag + "," + pSelectBy + "," + pExcludeBoardID, tenantID);
        
        if (retValue != null && retValue.length() > 30) {
    		return retValue;
        }
        
        String pAccessID = pUserID + "," + ezOrganService.getDeptFullPath(pDeptID, tenantID) + ",everyone";
        String strRollInfo = ezOrganService.getPropertyValue(pUserID, "extensionattribute1", tenantID);        
        List<BoardTreeVO> brdBoardTreeList = new ArrayList<BoardTreeVO>();
        
        for (int i = 0; i < pAccessID.split(",").length; i++) {
            String boardID = "";
            
            if (pMode == 0) {
            	brdBoardTreeList = ezBoardAdminService.brdBoardTree(pRootBoardID, "everyone", pMode, pSelectBy, pExcludeBoardID, tenantID);            
            } else {
            	brdBoardTreeList = ezBoardAdminService.brdBoardTree(pRootBoardID, pUserID, pMode, pSelectBy, pExcludeBoardID, tenantID);            
            }
            
            List<BoardVO> boardTreeList = ezBoardAdminService.getBoardTree_Get2(pAccessID.split(",")[i].trim(), pRootBoardID, tenantID);
            
            if (boardTreeList.size() > 0) {
                for (int r = 0; r < boardTreeList.size(); r++) {
            		boardID = boardTreeList.get(r).getBoardId().split(",")[0];
        			strForbiddenBoardIDList += boardID.trim();
                }
            }
        }

        StringBuilder result = new StringBuilder();
        
        if (pSubFlag == 1) {
        	result.append("<NODES>");
        } else {
        	result.append("<TREEVIEWDATA>");
        }
        
        for (int i = 0; i < brdBoardTreeList.size(); i++) {
        	if (strRollInfo != null && strRollInfo.toLowerCase().indexOf("c=1") == -1 && strRollInfo.toLowerCase().indexOf("k=1") == -1 && strRollInfo.toLowerCase().indexOf("n=1") == -1) {
                if (strForbiddenBoardIDList.indexOf(brdBoardTreeList.get(i).getBoardId()) > -1) {
                	continue;
                }
            }
        	result.append("<NODE>");
        	if (pRootBoardID.equals("top")) {
        		if (pStrLang.equals("")) {
        			result.append("<VALUE><![CDATA[" + brdBoardTreeList.get(i).getBoardName() + "]]></VALUE>");
        		} else {
        			result.append("<VALUE><![CDATA[" + brdBoardTreeList.get(i).getBoardName2() + "]]></VALUE>");
        		}        	
        	} else {
        		if (pStrLang.equals("")) {
        			result.append("<VALUE><![CDATA[" + brdBoardTreeList.get(i).getBoardName() + "]]></VALUE>");
        		} else {
        			result.append("<VALUE><![CDATA[" + brdBoardTreeList.get(i).getBoardName2() + "]]></VALUE>");
        		}        	
        	}
            result.append("<STYLE><![CDATA[]]></STYLE>");
            result.append("<DATA1>" + brdBoardTreeList.get(i).getBoardId() + "</DATA1>");
            
            if (pRootBoardID.equals("top")) {
            	if (pStrLang.equals("")) {
            		result.append("<DATA2><![CDATA[" + brdBoardTreeList.get(i).getBoardName() + "]]></DATA2>");
            	} else {
            		result.append("<DATA2><![CDATA[" + brdBoardTreeList.get(i).getBoardName2() + "]]></DATA2>");
            	}            
            } else {
            	if (pStrLang.equals("")) {
            		result.append("<DATA2><![CDATA[" + brdBoardTreeList.get(i).getBoardName() + "]]></DATA2>");
            	} else {
            		result.append("<DATA2><![CDATA[" + brdBoardTreeList.get(i).getBoardName2() + "]]></DATA2>");
            	}            
            }
            result.append("<DATA3>" + pRootBoardID + "</DATA3>");
            result.append("<DATA4>" + brdBoardTreeList.get(i).getBoardColor() + "</DATA4>");
            result.append("<DATA5>" + brdBoardTreeList.get(i).getGuBun() + "</DATA5>"); //20070228 포토게시판관련으로 추가함
            result.append("<EXPANDED>FALSE</EXPANDED>");
            result.append("<ISLEAF>" + checkIfLeafBoard(brdBoardTreeList.get(i).getBoardId(), tenantID) + "</ISLEAF>");

            if (count == 0 && pSubFlag != 1) {
            	result.append("<SELECT>TRUE</SELECT>");
            }
            result.append("</NODE>");
            
            count++;
        }
        
        if (pSubFlag == 1) {
        	result.append("</NODES>");
        } else {
        	result.append("</TREEVIEWDATA>");
        }
        
        ezBoardAdminService.getBoardTree_Set_D(pStrLang, pRootBoardID + "," + pUserID + "," + pDeptID + "," + pCompanyID + "," + pMode + "," + pSubFlag + "," + pSelectBy + "," + pExcludeBoardID, tenantID);
        ezBoardAdminService.getBoardTree_Set(pStrLang, pRootBoardID + "," + pUserID + "," + pDeptID + "," + pCompanyID + "," + pMode + "," + pSubFlag + "," + pSelectBy + "," + pExcludeBoardID, result.toString(), tenantID);

        return result.toString();
	}

	/**
	 * 게시판 트리하위여부 표출 Method
	 */
	public String checkIfLeafBoard(String pBoardID, int tenantID) {
		try {
	        int ret = ezBoardAdminService.checkIfLeafBoard(pBoardID, tenantID);
	        
	        if (ret > 0) {
	        	return "FALSE";
	        } else {
	        	return "TRUE";
	        }
		} catch(Exception ex) {
			return "FALSE";
		}
	}

	@Override
	public String getItemAttachmentXMLRetrans(BoardItemVO boardItemVO) throws Exception {
		logger.debug("getItemAttachmentXMLRetrans started");
		
		StringBuilder resultXML = new StringBuilder();

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("itemID", boardItemVO.getItemID());
		map.put("tenantID", boardItemVO.getTenantID());
		
		List<BoardAttachVO> boardAttachVOs = ezBoardDAO.brdGetItemAttachmentInfo(map);
		
		resultXML.append("<NODES>");
		
		if (boardItemVO.getMode().equals("boardAttach")) {
			File file = new File(boardItemVO.getFilePath() + boardItemVO.getConLocation());
			
			String fileExtension = boardItemVO.getConLocation().substring(boardItemVO.getConLocation().lastIndexOf("."));
			String newFilePath = commonUtil.getUploadPath("upload_board.TEMPUPLOADFILE", boardItemVO.getTenantID()) + 
					commonUtil.separator + "{" + UUID.randomUUID().toString() + "}_" + boardItemVO.getTitle() + fileExtension;
			long mhtSize = file.length();
			
			FileUtils.copyFile(file, new File(newFilePath));
			
			resultXML.append("<NODE>");
			resultXML.append("<ItemID>" + boardItemVO.getItemID() + "</ItemID>");
			resultXML.append("<FilePath>" + commonUtil.cleanValue(newFilePath) + "</FilePath>");
			resultXML.append("<FileSize>" + getProperSizeDisplay(mhtSize) + "</FileSize>");
			resultXML.append("<FileSize2>" + mhtSize + "</FileSize2>");
			resultXML.append("</NODE>");
		}
		
		for (int k = 0; k < boardAttachVOs.size(); k++) {
			String filePath = boardAttachVOs.get(k).getFilePath();
			String newFilePath = filePath.split("/")[filePath.split("/").length - 1];
			
			newFilePath = commonUtil.getUploadPath("upload_board.TEMPUPLOADFILE", boardItemVO.getTenantID()) +
					commonUtil.separator + "{" + UUID.randomUUID().toString() + "}" + newFilePath.substring(newFilePath.lastIndexOf("_"), newFilePath.length() - newFilePath.lastIndexOf("_"));
			
			FileUtils.copyFile(new File(boardItemVO.getFilePath() + filePath), new File(boardItemVO.getFilePath() + newFilePath));
			
			resultXML.append("<NODE>");
			resultXML.append("<ItemID>" + boardAttachVOs.get(k).getItemID() + "</ItemID>");
			resultXML.append("<FilePath>" + commonUtil.cleanValue(newFilePath) + "</FilePath>");
			resultXML.append("<FileSize>" + getProperSizeDisplay(Long.parseLong(boardAttachVOs.get(k).getFileSize())) + "</FileSize>");
			resultXML.append("<FileSize2>" + boardAttachVOs.get(k).getFileSize() + "</FileSize2>");
			resultXML.append("</NODE>");
		}
		
		resultXML.append("</NODES>");

		logger.debug("getItemAttachmentXMLRetrans ended");
		
		return resultXML.toString();
	}

	private String getProperSizeDisplay(long mhtSize) {
		logger.debug("getProperSizeDisplay started");
		
		String resultSize = "";

		if (mhtSize > 1048576) {
			resultSize = String.valueOf(mhtSize / 1024 / 102.4 / 10) + " MB";
		} else if (mhtSize > 1024) {
			resultSize = String.valueOf(mhtSize / 102.4 / 10) + " KB";
		} else {
			resultSize = String.valueOf(mhtSize) + " Byte";
		}

		logger.debug("getProperSizeDisplay ended");
		
		return resultSize;
	}

	@Override
	public String getItemAttachmentXML(BoardItemVO boardItemVO) throws Exception {
		logger.debug("getItemAttachmentXML started");

		StringBuilder resultXML = new StringBuilder();

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("itemID", boardItemVO.getItemID());
		map.put("tenantID", boardItemVO.getTenantID());
		
		List<BoardAttachVO> boardAttachVOs = ezBoardDAO.brdGetItemAttachmentInfo(map);
		
		resultXML.append("<NODES>");
		
		for (int k = 0; k < boardAttachVOs.size(); k++) {
			resultXML.append("<NODE>");
			resultXML.append("<ItemID>" + boardAttachVOs.get(k).getItemID() + "</ItemID>");
			resultXML.append("<GUID>" + boardAttachVOs.get(k).getGuid() + "</GUID>");
			resultXML.append("<FilePath>" + commonUtil.cleanValue(boardAttachVOs.get(k).getFilePath()) + "</FilePath>");
			resultXML.append("<FileSize>" + getProperSizeDisplay(Long.parseLong(boardAttachVOs.get(k).getFileSize())) + "</FileSize>");
			resultXML.append("<FileSize2>" + boardAttachVOs.get(k).getFileSize() + "</FileSize2>");
			resultXML.append("</NODE>");
		}
		
		resultXML.append("</NODES>");

		logger.debug("getItemAttachmentXML ended");
		
		return resultXML.toString();
	}

	@Override
	public List<BoardAccessVO> getPostNotiMailUserList(String boardID, String primary, int tenantID)
			throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("boardID", boardID);
		map.put("primary", primary);
		map.put("tenantID", tenantID);
		
		return ezBoardDAO.getPostNotiMailUserList(map);
	}

	@Override
	public int getItemViewNew(String boardID, String itemID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("boardID", boardID);
		map.put("itemID", itemID);
		map.put("tenantID", tenantID);
		
		return ezBoardDAO.getItemViewNew(map);
	}

	@Override
	public List<BoardListVO> getReplyNoticeMail(String boardID, String itemTreeID, String lang, int tenantID) throws Exception {
		logger.debug("getReplyNoticeMail started");

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("boardID", boardID);
		map.put("itemTreeID", itemTreeID.substring(0, 38));
		map.put("lang", commonUtil.getMultiData(lang));
		map.put("tenantID", tenantID);
		
		logger.debug("getReplyNoticeMail ended");
		
		return ezBoardDAO.getReplyNoticeMail(map);
	}

	@Override
	public List<LoginVO> getSendApprMailList(String boardID, String lang, int tenantID) throws Exception {
		logger.debug("getSendApprMailList started");

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("boardID", boardID);
		map.put("lang", commonUtil.getMultiData(lang));
		map.put("tenantID", tenantID);

		logger.debug("getSendApprMailList ended");
		
		return ezBoardDAO.getSendApprMailList(map);
	}

}
