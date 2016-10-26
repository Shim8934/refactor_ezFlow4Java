package egovframework.ezEKP.ezBoard.service.impl;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.commons.io.FileUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import egovframework.ezEKP.ezBoard.dao.EzBoardDAO;
import egovframework.ezEKP.ezBoard.service.EzBoardAdminService;
import egovframework.ezEKP.ezBoard.service.EzBoardService;
import egovframework.ezEKP.ezBoard.vo.BoardAttachVO;
import egovframework.ezEKP.ezBoard.vo.BoardConfigVO;
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
	
	@Resource(name = "EzBoardAdminService")
	private EzBoardAdminService ezBoardAdminService;

	@Resource(name = "EzOrganService")
	private EzOrganService ezOrganService;
	
	@Resource(name = "EzCommonService")
	private EzCommonService ezCommonService;

	@Override
	public List<BoardVO> getLeft_BoardSTD(String redirectBoardID) throws Exception{
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_REDIRECTBOARDID", redirectBoardID);
		return ezBoardDAO.getLeft_BoardSTD(map);
	}	

	@Override
	public List<BoardVO> get_apprUserList(String boardID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PBOARDID", boardID);
		
		return ezBoardDAO.get_apprUserList(map);
	}

	@Override
	public List<BoardMyFavoriteVO> get_favoriteList(String userID, String pMode) throws Exception{
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_USERID", userID);
		map.put("v_MODE", pMode);
		return ezBoardDAO.get_favoriteList(map);
	}

	@Override
	public String get_parentBoardName(String boardIdList, int boardIdListCount, String primary) throws Exception{
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_BOARDIDLIST", boardIdList);
		map.put("v_BOARDCOUNTLIST", boardIdListCount);
		map.put("v_PRIMARY", primary);
		return ezBoardDAO.get_parentBoardName(map);
	}

	@Override
	public String getBoardProperty(String pBoardID, BoardPropertyVO boardInfo, LoginVO userInfo) throws Exception{
		BoardPropertyVO strProp = ezBoardDAO.getBoardProperty(pBoardID);
		
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
	public BoardPropertyVO getBoardProperty(String pBoardID) throws Exception{
		return ezBoardDAO.getBoardProperty(pBoardID);
	}
	
	@Override
	public BoardConfigVO getBoardList_Config(String userId) throws Exception {
		return ezBoardDAO.getBoardList_Config(userId);
	}

	@Override
	public List<BoardListHeaderVO> getListHeader(BoardVO ezBoardVO) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PBOARDTYPE", ezBoardVO.getBoardType());
		map.put("v_PSTRLANG", ezBoardVO.getLang());
		return ezBoardDAO.getListHeader(map);
	}

	@Override
	public void setListOrder(String pUserID, Map<String, Object> map) throws Exception {
		map.put("v_ORDERBOARDIDLIST", map.get("pBoardList"));
		map.put("v_ORDERBOARDLISTCOUNT", map.get("pBoardListCount"));
		map.put("v_DELBOARDIDLIST", map.get("pDelBoardList"));
		map.put("v_DELBOARDLISTCOUNT", map.get("pDelBoardListCount"));
		map.put("v_USERID", pUserID);
		map.put("v_ERR_CD", map.get("v_ERR_CD"));
		ezBoardDAO.setListOrder(map);
	}

	@Override
	public int getNewItemListCount(String userID)  throws Exception{
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pUserID", userID);
		return ezBoardDAO.getNewItemListCount(map);
	}

	@Override
	public BoardConfigVO getPersonalCount(String userID) throws Exception {
		return ezBoardDAO.getPersonalCount(userID);
	}

	@Override
	public List<HashMap<String, Object>> getNewItemList(BoardListVO boardListVO) throws Exception{
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PUSERID", boardListVO.getUserID());
		map.put("v_PSTARTROW", boardListVO.getStartRow());
		map.put("v_PENDROW", boardListVO.getEndRow());
		map.put("v_PTOTALCOUNT", boardListVO.getTotalCount());
		map.put("iv_PORDERBYSUB", boardListVO.getOrderBySub());
		map.put("v_PORDERBYMAIN", boardListVO.getOrderByMain());
		return ezBoardDAO.getNewItemList(map);
	}

	@Override
	public void setBoardList_Config(String pUserID, Map<String, Object> map) throws Exception {
		map.put("v_PUSERID", pUserID);
		map.put("v_PLISTCNT", map.get("pListCount"));
		map.put("v_PREVIEWMODE", map.get("pPreview"));
		map.put("v_PREVIEWWLIST", map.get("pPreviewWList"));
		map.put("v_PREVIEWWCONTENT", map.get("pPreviewWContent"));
		map.put("v_PREVIEWHLIST", map.get("pPreviewHList"));
		map.put("v_PREVIEWHCONTENT", map.get("pPreviewHContent"));
		ezBoardDAO.setBoardList_Config(pUserID, map); 
	}

	@Override
	public int getBrdNewItemCount(String userID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pUserID", userID);
		return ezBoardDAO.getBrdNewItemCount(map);
	}

	@Override
	public int getThumbNailCount(BoardMyFavoriteVO myFavoriteVO) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PBOARDID", myFavoriteVO.getBoardId());
		map.put("v_PUSERID", myFavoriteVO.getUserId());
		map.put("v_PTYPE", myFavoriteVO.getType());
		return ezBoardDAO.getThumbNailCount(map);
	}

	@Override
	public int getBrdTotalItemCount(BoardMyFavoriteVO myFavoriteVO) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PBOARDID", myFavoriteVO.getBoardId());
		map.put("v_PUSERID", myFavoriteVO.getUserId());
		map.put("v_PTYPE", myFavoriteVO.getType());
		return ezBoardDAO.getBrdTotalItemCount(map);
	}

	@Override
	public int getQNABrdTotalItemCount(BoardMyFavoriteVO myFavoriteVO) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PBOARDID", myFavoriteVO.getBoardId());
		map.put("v_PNOW", myFavoriteVO.getNowDate());
		map.put("v_PUSERID", myFavoriteVO.getUserId());
		map.put("v_PTYPE", myFavoriteVO.getType());
		map.put("v_PADMINTYPE", myFavoriteVO.getBoardAdmin_FG());
		return ezBoardDAO.getQNABrdTotalItemCount(map);
	}

	@Override
	public void setTabUsed(String pUserID, String pBoardList, String tabUsed) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_BOARDID", pBoardList);
		map.put("v_TABUSED", tabUsed);
		map.put("v_USERID", pUserID);
		ezBoardDAO.setTabUsed(map);
	}
	
	@Override
	public void setMainImageID(String mainImageID, String itemID, String type) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_IMAGEID", mainImageID);
		map.put("v_ITEMID", itemID);
		map.put("v_TYPE", type);
		ezBoardDAO.setMainImageID(map);
		
	}

	@Override
	public void setNotiOrder(String itemID) throws Exception {
		ezBoardDAO.setNotiOrder(itemID);
	}

	@Override
	public void photoListUpdate(String imageID, String boardID, String content, String file_Path, String itemID, String mainFg, String oFileName) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_ImageID", imageID);
		map.put("v_BoardID", boardID);
		map.put("v_FilePath", file_Path);
		map.put("v_FileContent", content);
		map.put("v_OFileName", oFileName);
		ezBoardDAO.photoListUpdate(map);
		
		if(mainFg.equals("Y")){
			setMainImageID(imageID, itemID, "1");
		}
	}

	@Override
	public void updateCopyItem(String destItemID) throws Exception {
		ezBoardDAO.updateCopyItem(destItemID);
	}

	@Override
	public void updateMoveItem(String destItemID, String orgItemID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PITEMID", destItemID);
		map.put("v_PORGITEMID", orgItemID);
		ezBoardDAO.updateMoveItem(map);
	}

	@Override
	public void setBoardList_Config2(String userID, String listCount, String previewMode, String list, String content) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PUSERID", userID);
		map.put("v_PLISTCNT", listCount);
		map.put("v_PREVIEWMODE", previewMode);
		map.put("v_LIST", list);
		map.put("v_CONTENT", content);
		ezBoardDAO.setBoardList_Config2(map);
	}

	@Override
	public void photoListAlbumEdit(String boardID, String itemID, String title, String content) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_BOARDID", boardID);
		map.put("v_ITEMID", itemID);
		map.put("v_TITLE", title);
		map.put("v_CONTENT", content);
		ezBoardDAO.photoListAlbumEdit(map);
	}

	@Override
	public void photoListAlbumEditTemp(String boardID, String itemID, String title, String content) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_BOARDID", boardID);
		map.put("v_ITEMID", itemID);
		map.put("v_TITLE", title);
		map.put("v_CONTENT", content);
		ezBoardDAO.photoListAlbumEditTemp(map);
	}

	@Override
	public void deleteItem(String itemIDs, String boardID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_STRITEMLIST", itemIDs);
		map.put("v_BOARDID", boardID);
		ezBoardDAO.deleteItem(map);
	}

	@Override
	public void deleteTempItem(String itemIDs, String boardID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_STRITEMLIST", itemIDs);
		map.put("v_BOARDID", boardID);
		ezBoardDAO.deleteTempItem(map);
	}

	@Override
	public void photoListDel(String boardID, String imageID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_BoardID", boardID);
		map.put("v_ImageID", imageID);
		ezBoardDAO.photoListDel(map);
	}

	@Override
	public List<BoardListHeaderVO> getListHeaderBoardID(BoardVO ezBoardVO) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PBOARDID", ezBoardVO.getBoardId());
		map.put("v_PSTRLANG", ezBoardVO.getLang());
		map.put("v_PBOARDTYPE", ezBoardVO.getBoardType());
		return ezBoardDAO.getListHeaderBoardID(map);
	}

	@Override
	public List<BoardAttachVO> brdGetItemAttachmentInfo(String pItemID) throws Exception {
		return ezBoardDAO.brdGetItemAttachmentInfo(pItemID);
	}

	@Override
	public List<BoardReadVO> getReaderList(String boardID, String itemID, String userID, String lang) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("boardID", boardID);
		map.put("itemID", itemID);
		map.put("userID", userID);
		map.put("lang", lang);
		return ezBoardDAO.getReaderList(map);
	}

	@Override
	public int getNoticePostItemCount(String boardId) throws Exception {
		return ezBoardDAO.getNoticePostItemCount(boardId);
	}

	@Override
	public int getBoardTotalItemCount(String boardId, String userID, String type) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PBOARDID", boardId);
		map.put("v_PUSERID", userID);
		map.put("v_PTYPE", type);
		return ezBoardDAO.getBrdTotalItemCount(map);
	}

	@Override
	public List<HashMap<String, Object>> getNoticePostItem(BoardVO ezBoardVO, int personalCount) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		int start = 0;
        int end = 0;
        start = ((ezBoardVO.getPageNum() - 1) * personalCount) + 1;
        end = (ezBoardVO.getPageNum() * personalCount);
        
		map.put("v_PBOARDID", ezBoardVO.getBoardId());
		map.put("v_START", start);
		map.put("v_END", end);
		return ezBoardDAO.getNoticePostItem(map);
	}

	@Override
	public List<HashMap<String, Object>> getBoardListItem(String boardId, String userID, int startRow, int endRow, int boardCount, String orderOption1, String orderOption2, String type) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PUSERID", userID);
		map.put("v_PBOARDID", boardId);
		map.put("v_PSTARTROW", startRow);
		map.put("v_PENDROW", endRow);
		map.put("v_PTOTALCOUNT", boardCount);
		map.put("iv_PORDERBYSUB", orderOption1);
		map.put("v_PORDERBYMAIN", orderOption2);
		map.put("v_TYPE", type);
		return ezBoardDAO.getBoardListItem(map);
	}

	@Override
	public List<HashMap<String, Object>> getQnABoardListItem(String boardId, String userID, int startRow, int endRow, int boardCount, String orderOption1, String orderOption2, String type, String adminType) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PUSERID", userID);
		map.put("v_PBOARDID", boardId);
		map.put("v_PSTARTROW", startRow);
		map.put("v_PENDROW", endRow);
		map.put("v_PTOTALCOUNT", boardCount);
		map.put("iv_PORDERBYSUB", orderOption1);
		map.put("v_PORDERBYMAIN", orderOption2);
		map.put("v_TYPE", type);
		map.put("v_ADMINTYPE", adminType);
		return ezBoardDAO.getQnABoardListItem(map);
	}

	@Override
	public List<HashMap<String, Object>> getSearchBoardItemList(BoardListVO boardListVO, BoardVO boardVO) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PUSERID", boardListVO.getUserID());
		map.put("v_PBOARDID", boardVO.getBoardId());
		map.put("v_PSTARTROW", boardListVO.getStartRow());
		map.put("v_PENDROW", boardListVO.getEndRow());
		map.put("v_PTOTALCOUNT", boardListVO.getTotalCount());
		map.put("iv_PORDERBYSUB", boardListVO.getOrderBySub().trim());
		map.put("v_PORDERBYMAIN", boardListVO.getOrderByMain().trim());
		map.put("v_PSUBFLAG", boardVO.getSubFlag());
		map.put("v_PSUBQUERY", boardVO.getSearchQuery());
		map.put("v_TITLE", boardVO.getTitle());
		map.put("v_WRITERNAME", boardVO.getWriterName());
		map.put("v_ABSTRACT", boardVO.getABSTRACT());
		return ezBoardDAO.getSearchBoardItemList(map);
	}

	@Override
	public List<HashMap<String, Object>> getThumbnailList(BoardListVO boardListVO, BoardVO boardVO) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PUSERID", boardListVO.getUserID());
		map.put("v_PBOARDID", boardVO.getBoardId());
		map.put("v_PSTARTROW", boardListVO.getStartRow());
		map.put("v_PENDROW", boardListVO.getEndRow());
		map.put("v_PTOTALCOUNT", boardListVO.getTotalCount());
		map.put("iv_PORDERBYSUB", boardListVO.getOrderBySub().trim());
		map.put("v_PORDERBYMAIN", boardListVO.getOrderByMain().trim());
		map.put("v_PTYPE", boardVO.getType());
		return ezBoardDAO.getThumbnailList(map);
	}

	@Override
	public List<HashMap<String, Object>> getSearchThumbnailList(BoardListVO boardListVO, BoardVO boardVO) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PUSERID", boardListVO.getUserID());
		map.put("v_PBOARDID", boardVO.getBoardId());
		map.put("v_PSTARTROW", boardListVO.getStartRow());
		map.put("v_PENDROW", boardListVO.getEndRow());
		map.put("v_PTOTALCOUNT", boardListVO.getTotalCount());
		map.put("iv_PORDERBYSUB", boardListVO.getOrderBySub().trim());
		map.put("v_PORDERBYMAIN", boardListVO.getOrderByMain().trim());
		map.put("v_PSUBFLAG", boardVO.getSubFlag());
		map.put("v_PSUBQUERY", boardVO.getSearchQuery());
		map.put("v_TITLE", boardVO.getTitle());
		map.put("v_WRITERNAME", boardVO.getWriterName());
		map.put("v_ABSTRACT", boardVO.getABSTRACT());
		return ezBoardDAO.getSearchThumbnailList(map);
	}

	@Override
	public List<HashMap<String, Object>> getMyNoticePostItem(String userID, String type, int start, int end) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PUSERID", userID);
		map.put("v_TYPE", type);
		map.put("v_START", start);
		map.put("v_END", end);
		return ezBoardDAO.getMyNoticePostItem(map);
	}

	@Override
	public List<HashMap<String, Object>> getMyBoardListItem(String userID, int startRow, int endRow, int boardCount, String orderOption1, String orderOption2) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PUSERID", userID);
		map.put("v_PSTARTROW", startRow);
		map.put("v_PENDROW", endRow);
		map.put("v_PTOTALCOUNT", boardCount);
		map.put("iv_PORDERBYSUB", orderOption1);
		map.put("v_PORDERBYMAIN", orderOption2);
		return ezBoardDAO.getMyBoardListItem(map);
	}

	@Override
	public List<HashMap<String, Object>> getMyBoardListItemTemp(String userID, int startRow, int endRow, int boardCount, String orderOption1, String orderOption2) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PUSERID", userID);
		map.put("v_PSTARTROW", startRow);
		map.put("v_PENDROW", endRow);
		map.put("v_PTOTALCOUNT", boardCount);
		map.put("iv_PORDERBYSUB", orderOption1);
		map.put("v_PORDERBYMAIN", orderOption2);
		return ezBoardDAO.getMyBoardListItemTemp(map);
	}

	@Override
	public List<HashMap<String, Object>> getApprBoardListItem(String userID, int startRow, int endRow, int boardCount, String orderOption1, String orderOption2) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PUSERID", userID);
		map.put("v_PSTARTROW", startRow);
		map.put("v_PENDROW", endRow);
		map.put("v_PTOTALCOUNT", boardCount);
		map.put("iv_PORDERBYSUB", orderOption1);
		map.put("v_PORDERBYMAIN", orderOption2);
		return ezBoardDAO.getApprBoardListItem(map);
	}

	@Override
	public List<HashMap<String, Object>> getSearchMyBoardItemList(BoardListVO boardListVO, BoardVO boardVO) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PUSERID", boardListVO.getUserID());
		map.put("v_PSTARTROW", boardListVO.getStartRow());
		map.put("v_PENDROW", boardListVO.getEndRow());
		map.put("v_PTOTALCOUNT", boardListVO.getTotalCount());
		map.put("iv_PORDERBYSUB", boardListVO.getOrderBySub());
		map.put("v_PORDERBYMAIN", boardListVO.getOrderByMain());
		map.put("v_PSUBFLAG", boardVO.getSubFlag());
		map.put("v_PSUBQUERY", boardVO.getSearchQuery());
		return ezBoardDAO.getSearchMyBoardItemList(map);
	}

	@Override
	public List<HashMap<String, Object>> getSearchMyBoardItemListTemp(BoardListVO boardListVO, BoardVO boardVO) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PUSERID", boardListVO.getUserID());
		map.put("v_PSTARTROW", boardListVO.getStartRow());
		map.put("v_PENDROW", boardListVO.getEndRow());
		map.put("v_PTOTALCOUNT", boardListVO.getTotalCount());
		map.put("iv_PORDERBYSUB", boardListVO.getOrderBySub());
		map.put("v_PORDERBYMAIN", boardListVO.getOrderByMain());
		map.put("v_PSUBFLAG", boardVO.getSubFlag());
		map.put("v_PSUBQUERY", boardVO.getSearchQuery());
		return ezBoardDAO.getSearchMyBoardItemListTemp(map);
	}

	@Override
	public int getCheckItemID(String itemID, String boardType, String userDeptPath) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_ITEMID", itemID);
		map.put("v_BOARDTYPE", boardType);
		map.put("v_ACCESSID", userDeptPath);
		return ezBoardDAO.getCheckItemID(map);
	}

	@Override
	public BoardListVO getBrdGetItemInfo(String boardID, String itemID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pBoardID", boardID);
		map.put("v_pItemID", itemID);
		return ezBoardDAO.getBrdGetItemInfo(map);
	}

	@Override
	public BoardListVO getBrdGetItemInfoTemp(String boardID, String itemID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pBoardID", boardID);
		map.put("v_pItemID", itemID);
		return ezBoardDAO.getBrdGetItemInfoTemp(map);
	}

	@Override
	public BoardListVO getItemInfo(String itemID) throws Exception {
		return ezBoardDAO.getItemInfo(itemID);
	}

	@Override
	public BoardListVO getCopyItem(String orgItemID, String orgBoardID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PORGITEMID", orgItemID);
		map.put("v_PORGBOARDID", orgBoardID);
		return ezBoardDAO.getCopyItem(map);
	}

	@Override
	public List<BoardListVO> getAdjacentItems1(String boardID, String parentWriteDate, String upperItemIDTree) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PBOARDID", boardID);
		map.put("v_PPARENTWRITEDATE", parentWriteDate);
		map.put("v_PUPPERITEMIDTREE", upperItemIDTree);
		return ezBoardDAO.getAdjacentItems1(map);
	}

	@Override
	public List<BoardListVO> getAdjacentItems2(String boardID, String parentWriteDate) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PBOARDID", boardID);
		map.put("v_PPARENTWRITEDATE", parentWriteDate);
		return ezBoardDAO.getAdjacentItems2(map);
	}

	@Override
	public List<BoardListVO> getAdjacentItems3(String boardID, String parentWriteDate, String itemID, String upperItemIDTree, String previousItemID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PBOARDID", boardID);
		map.put("v_PPARENTWRITEDATE", parentWriteDate);
		map.put("v_PITEMID", itemID);
		map.put("v_PUPPERITEMIDTREE", upperItemIDTree);
		map.put("v_PREVIOUSITEMID", previousItemID);
		return ezBoardDAO.getAdjacentItems3(map);
	}

	@Override
	public List<BoardListVO> getAdjacentItems2Photo(String boardID, String parentWriteDate) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PBOARDID", boardID);
		map.put("v_PPARENTWRITEDATE", parentWriteDate);
		return ezBoardDAO.getAdjacentItems2Photo(map);
	}

	@Override
	public List<BoardListVO> getAdjacentItems3Photo(String boardID, String parentWriteDate) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PBOARDID", boardID);
		map.put("v_PPARENTWRITEDATE", parentWriteDate);
		return ezBoardDAO.getAdjacentItems3Photo(map);
	}

	@Override
	public List<BoardAttachVO> photoViewDB(String itemID, String boardID, int pStartRow, int pEndRow) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pItemID", itemID);
		map.put("v_pBoardID", boardID);
		map.put("v_pStartRow", pStartRow);
		map.put("v_pEndRow", pEndRow);
		return ezBoardDAO.photoViewDB(map);
	}

	@Override
	public List<BoardAttachVO> photoViewDBAll(String itemID, String boardID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pItemID", itemID);
		map.put("v_pBoardID", boardID);
		return ezBoardDAO.photoViewDBAll(map);
	}

	@Override
	public List<String> getCopyItemAttach(String orgItemID) throws Exception {
		return ezBoardDAO.getCopyItemAttach(orgItemID);
	}

	@Override
	public void setAsRead(LoginVO userInfo, String boardID, String itemID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("iv_pBoardID", boardID);
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
		ezBoardDAO.setAsRead(map);
	}

	@Override
	public int getCheckApprUserList(String userID, String itemID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PUSERID", userID);
		map.put("v_PITEMID", itemID);
		return ezBoardDAO.getCheckApprUserList(map);
	}

	@Override
	public int getSearchBoardItemCount(BoardVO boardVO) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pBoardID", boardVO.getBoardId());
		map.put("v_PSUBFLAG", boardVO.getSubFlag());
		map.put("v_PSUBQUERY", boardVO.getSearchQuery());
		return ezBoardDAO.getSearchBoardItemCount(map);
	}

	@Override
	public int checkApprUserList(String userID, String itemID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PUSERID", userID);
		map.put("v_PITEMID", itemID);
		return ezBoardDAO.checkApprUserList(map);
	}

	@Override
	public int getMyBoardTotalItemCount(String userID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PUSERID", userID);
		return ezBoardDAO.getMyBoardTotalItemCount(map);
	}

	@Override
	public int getMyBoardTotalItemCountTemp(String userID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PUSERID", userID);
		return ezBoardDAO.getMyBoardTotalItemCountTemp(map);
	}

	@Override
	public int getMyNoticePostItemCount(String userID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PUSERID", userID);
		return ezBoardDAO.getMyNoticePostItemCount(map);
	}

	@Override
	public int getSearchMyBoardItemCount(LoginVO userInfo, BoardVO boardVO) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PUSERID", userInfo.getId());
		map.put("v_PSUBFLAG", boardVO.getSubFlag());
		map.put("v_PSUBQUERY", boardVO.getSearchQuery());
		return ezBoardDAO.getSearchMyBoardItemCount(map);
	}

	@Override
	public int getSearchMyBoardItemCountTemp(LoginVO userInfo, BoardVO boardVO) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PUSERID", userInfo.getId());
		map.put("v_PSUBFLAG", boardVO.getSubFlag());
		map.put("v_PSUBQUERY", boardVO.getSearchQuery());
		return ezBoardDAO.getSearchMyBoardItemCountTemp(map);
	}

	@Override
	public int getApprBoardTotalItemCount(String userID) throws Exception {
		return ezBoardDAO.getApprBoardTotalItemCount(userID);
	}

	@Override
	public void setAsReads(LoginVO userInfo, String boardID, String pItemIDList) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("iv_pBoardID", boardID);
		map.put("v_pItemID", pItemIDList);
		map.put("v_pUserID", userInfo.getId());
		map.put("v_pUserName", userInfo.getDisplayName1());
		map.put("v_pUserDeptName", userInfo.getDeptName1());
		map.put("v_pUserCompanyName", userInfo.getCompanyName1());
		map.put("v_pUserTitle", userInfo.getTitle1());
		map.put("v_pUserName2", userInfo.getDisplayName2());
		map.put("v_pUserDeptName2", userInfo.getDeptName2());
		map.put("v_pUserCompanyName2", userInfo.getCompanyName2());
		map.put("v_pUserTitle2", userInfo.getTitle2());
		ezBoardDAO.setAsReads(map);
	}

	@Override
	public String checkForm(String boardID, String mode) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PBOARDID", boardID);
		map.put("v_PMODE", mode);
		
		String checkForm = "";
		int checkCnt = ezBoardDAO.checkForm(map);
		
		if(checkCnt > 0){
			checkForm = "TRUE";
		}else{
			checkForm = "FALSE";
		}
		return checkForm;
	}

	@Override
	public String checkBackGroundImage(String boardID) throws Exception {
		String check = "";
		int checkCnt = ezBoardDAO.checkBackGroundImage(boardID);
		if(checkCnt > 0){
			check = "TRUE";
		}else{
			check = "FALSE";
		}
		return check;
	}

	@Override
	public String brdCheckIfHasReply(String itemIDs) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pItemID", itemIDs);
		String check = "";
		int checkCnt = ezBoardDAO.brdCheckIfHasReply(map);
		if(checkCnt > 0){
			check = "TRUE";
		}else{
			check = "FALSE";
		}
		return check;
	}

	@Override
	public String getNoticePostItemAll(String boardID) throws Exception {
		List<BoardListVO> resultList = ezBoardDAO.getNoticePostItemAll(boardID);
		
		StringBuilder sb = new StringBuilder();
		sb.append("<DATA>");
		
		for(int i = 0; i < resultList.size(); i++){
			sb.append(commonUtil.getQueryResult(resultList.get(i)));
		}
		sb.append("</DATA>");
		
		return sb.toString();
	}

	@Override
	public String getParentBoardID(String boardID) throws Exception {
		return ezBoardDAO.getParentBoardID(boardID);
	}

	@Override
	public String getDocPassWord(String itemID) throws Exception {
		return ezBoardDAO.getDocPassWord(itemID);
	}

	@Override
	public String deleteTempItem(String strItemID) throws Exception {
		try {
			ezBoardDAO.deleteTempItem(strItemID);
			return "OK";
		} catch (Exception e) {
			return "NO";
		}
	}

	@Override
	public String getItemXML(String boardID, String itemID, String lang) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pBoardID", boardID);
		map.put("v_pItemID", itemID);
		BoardListVO itemInfo = ezBoardDAO.getBrdGetItemInfo(map);

		StringBuilder sb = new StringBuilder();

		sb.append("<NODES>");
		sb.append("<NODE>");
		sb.append("<ItemID>" + itemInfo.getItemID() + "</ItemID>");
		sb.append("<WriterID>" + itemInfo.getWriterID() + "</WriterID>");
		
		if(lang.equals("")){
			sb.append("<WriterName>" + commonUtil.cleanValue(itemInfo.getWriterName()) + "</WriterName>");
			sb.append("<WriterDeptName>" + commonUtil.cleanValue(itemInfo.getWriterDeptName()) + "</WriterDeptName>");
			sb.append("<WriterCompanyName>" + commonUtil.cleanValue(itemInfo.getWriterCompanyName()) + "</WriterCompanyName>");
		}else{
			sb.append("<WriterName>" + commonUtil.cleanValue(itemInfo.getWriterName2()) + "</WriterName>");
			sb.append("<WriterDeptName>" + commonUtil.cleanValue(itemInfo.getWriterDeptName2()) + "</WriterDeptName>");
			sb.append("<WriterCompanyName>" + commonUtil.cleanValue(itemInfo.getWriterCompanyName2()) + "</WriterCompanyName>");
		}
		sb.append("<WriteDate>" + itemInfo.getWriteDate() + "</WriteDate>");
		sb.append("<ParentWriteDate>" + itemInfo.getParentWriteDate() + "</ParentWriteDate>");
		sb.append("<Importance>" + itemInfo.getImportance() + "</Importance>");
		sb.append("<Title>" + commonUtil.cleanValue(itemInfo.getTitle()) + "</Title>");
		sb.append("<ContentLocation>" + itemInfo.getContentLocation() + "</ContentLocation>");
		sb.append("<StartDate>" + itemInfo.getStartDate() + "</StartDate>");
		sb.append("<EndDate>" + itemInfo.getEndDate() + "</EndDate>");
		sb.append("<Abstract>" + commonUtil.cleanValue(itemInfo.getABSTRACT()) + "</Abstract>");
		sb.append("<Attachments>" + commonUtil.cleanValue(itemInfo.getAttachments()) + "</Attachments>");
		sb.append("<UpperItemIDTree>" + itemInfo.getUpperItemIDTree() + "</UpperItemIDTree>");
		sb.append("<ItemLevel>" + itemInfo.getItemLevel() + "</ItemLevel>");
		sb.append("<copiedItem>" + itemInfo.getCopiedItem() + "</copiedItem>");
		sb.append("<ExtensionAttribute1>" + commonUtil.cleanValue(itemInfo.getExtensionAttribute1()) + "</ExtensionAttribute1>");
		sb.append("<ExtensionAttribute2>" + commonUtil.cleanValue(itemInfo.getExtensionAttribute2()) + "</ExtensionAttribute2>");
        if(lang.equals("")){
        	sb.append("<ExtensionAttribute3>" + commonUtil.cleanValue(itemInfo.getExtensionAttribute3()) + "</ExtensionAttribute3>");
        }else{
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

		return sb.toString();
	}

	@Override
	public String getItemTempXML(String boardID, String itemID, String lang) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pBoardID", boardID);
		map.put("v_pItemID", itemID);
		BoardListVO itemInfo = ezBoardDAO.getBrdGetItemInfoTemp(map);

		StringBuilder sb = new StringBuilder();

		sb.append("<NODES>");
		sb.append("<NODE>");
		sb.append("<ItemID>" + itemInfo.getItemID() + "</ItemID>");
		sb.append("<WriterID>" + itemInfo.getWriterID() + "</WriterID>");
		
		if(lang.equals("")){
			sb.append("<WriterName>" + commonUtil.cleanValue(itemInfo.getWriterName()) + "</WriterName>");
			sb.append("<WriterDeptName>" + commonUtil.cleanValue(itemInfo.getWriterDeptName()) + "</WriterDeptName>");
			sb.append("<WriterCompanyName>" + commonUtil.cleanValue(itemInfo.getWriterCompanyName()) + "</WriterCompanyName>");
		}else{
			sb.append("<WriterName>" + commonUtil.cleanValue(itemInfo.getWriterName2()) + "</WriterName>");
			sb.append("<WriterDeptName>" + commonUtil.cleanValue(itemInfo.getWriterDeptName2()) + "</WriterDeptName>");
			sb.append("<WriterCompanyName>" + commonUtil.cleanValue(itemInfo.getWriterCompanyName2()) + "</WriterCompanyName>");
		}
		sb.append("<WriteDate>" + itemInfo.getWriteDate() + "</WriteDate>");
		sb.append("<ParentWriteDate>" + itemInfo.getParentWriteDate() + "</ParentWriteDate>");
		sb.append("<Importance>" + itemInfo.getImportance() + "</Importance>");
		sb.append("<Title>" + commonUtil.cleanValue(itemInfo.getTitle()) + "</Title>");
		sb.append("<ContentLocation>" + itemInfo.getContentLocation() + "</ContentLocation>");
		sb.append("<StartDate>" + itemInfo.getStartDate() + "</StartDate>");
		sb.append("<EndDate>" + itemInfo.getEndDate() + "</EndDate>");
		sb.append("<Abstract>" + commonUtil.cleanValue(itemInfo.getABSTRACT()) + "</Abstract>");
		sb.append("<Attachments>" + commonUtil.cleanValue(itemInfo.getAttachments()) + "</Attachments>");
		sb.append("<UpperItemIDTree>" + itemInfo.getUpperItemIDTree() + "</UpperItemIDTree>");
		sb.append("<ItemLevel>" + itemInfo.getItemLevel() + "</ItemLevel>");
		sb.append("<copiedItem>" + itemInfo.getCopiedItem() + "</copiedItem>");
		sb.append("<ExtensionAttribute1>" + commonUtil.cleanValue(itemInfo.getExtensionAttribute1()) + "</ExtensionAttribute1>");
		sb.append("<ExtensionAttribute2>" + commonUtil.cleanValue(itemInfo.getExtensionAttribute2()) + "</ExtensionAttribute2>");
        if(lang.equals("")){
        	sb.append("<ExtensionAttribute3>" + commonUtil.cleanValue(itemInfo.getExtensionAttribute3()) + "</ExtensionAttribute3>");
        }else{
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
	public String setBoardConfig(String userID, String listCount, String preView) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PUSERID", userID);
		map.put("v_PLISTCOUNT", listCount);
		map.put("v_PPREVIEW", preView);
		try {
			ezBoardDAO.setBoardConfig(map);
			return "OK";
		} catch (Exception e) {
			return "NO";
		}
	}

	@Override
	public String apprItem(String userID, String itemList, String pMod) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_ITEMID", itemList);
		map.put("v_MODE", pMod);
		map.put("v_USERID", userID);
		try {
			ezBoardDAO.apprItem(map);
			return "OK";
		} catch (Exception e) {
			return "ERROR" + e.getMessage();
		}
	}

	@Override
	public String deleteOneLineReply(String userID, String replyID, String guBun) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_USERINFO_USERID", userID);
		map.put("v_REPLYID", replyID);
		map.put("v_GUBUN", guBun);
		return ezBoardDAO.deleteOneLineReply(map);
	}

	@Override
	public String checkOneLineOwner(String replyID, String userID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_ReplyID", replyID);
		map.put("v_UserID", userID);
		
		String resultMessage = "";
		int result = ezBoardDAO.checkOneLineOwner(map);
		
		if(result > 0){
			resultMessage = "OK_MINE";
		}else{
			resultMessage = "FAIL";
		}
		
		return resultMessage;
	}

	@Override
	public List<BoardListVO> getReservedItemList(String userID, int startRow, int endRow, String sortBy, String lang) throws Exception {
		if(!(endRow > 0)){
			endRow = 0;
		}
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PENDROW", endRow);
		map.put("v_PUSERID", userID);
		map.put("v_PSORTBY", sortBy);
		return ezBoardDAO.getReservedItemList(map);
	}

	@Override
	public List<BoardLineReplyVO> readOneLineReply(String boardID, String itemID, String userName) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_BoardID", boardID);
		map.put("v_ItemID", itemID);
		map.put("v_UserName", userName);
		return ezBoardDAO.readOneLineReply(map);
	}

	@Override
	public int getReservedItemListCount(String userID) throws Exception {
		return ezBoardDAO.getReservedItemListCount(userID);
	}

	@Override
	public void brdNewItem(BoardListVO boardListVO) throws Exception {
		ezBoardDAO.brdNewItem(boardListVO);
		ezBoardDAO.newItem(boardListVO.getItemID());
	}

	@Override
	public void brdNewItemPhoto(BoardListVO boardListVO) throws Exception {
		ezBoardDAO.brdNewItemPhoto(boardListVO);
		photoSaveDB(boardListVO);
		ezBoardDAO.newItem(boardListVO.getItemID());
	}

	@Override
	public void brdNewItemTemp(BoardListVO boardListVO) throws Exception {
		ezBoardDAO.brdNewItemTemp(boardListVO);
		ezBoardDAO.newItem(boardListVO.getItemID());
	}

	@Override
	public void brdNewItemTempPhoto(BoardListVO boardListVO) throws Exception {
		ezBoardDAO.brdNewItemTempPhoto(boardListVO);
		photoSaveDB(boardListVO);
		ezBoardDAO.newItem(boardListVO.getItemID());
	}

	@Override
	public void photoListInsert(BoardListVO boardListVO) throws Exception {
		ezBoardDAO.photoListInsert(boardListVO);
	}

	@Override
	public void brdUpdateItem(BoardListVO boardListVO, String mode) throws Exception {
		ezBoardDAO.brdUpdateItem(boardListVO);
		if(mode.equals("PHOTO")){
			photoSaveDB(boardListVO);
		}
		ezBoardDAO.newItem(boardListVO.getItemID());
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
			
			try {
				map.put("v_pFileContent", boardListVO.getImageContent().split(";:;")[i]);
			} catch (Exception e) {
				map.put("v_pFileContent", "");
			}
			map.put("v_pImageName", boardListVO.getImageNames().split(";")[i]);
			
			ezBoardDAO.photoSaveDB(map);
		}
	}

	@Override
	public void saveAttachInfo(String strItemID, String filePath, long fileSize, String fileName) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_STRITEMID", strItemID);
		map.put("v_STRATTACHMENTS", filePath);
		map.put("v_FILESIZE", fileSize);
		map.put("v_FILENAME", fileName);
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
		ezBoardDAO.saveOneLineReply(map);
	}
	
	public String getThumbListXML (String pUserID, String pBoardType, String pBoardID, int pPageNum, String sortHeader, String sortOption, String strLang) throws Exception {
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
				} else {
					fieldValue = commonUtil.cleanValue(String.valueOf(boardList.get(j).get(fieldName)));
				}
				
				sb.append("<VALUE>"+fieldValue+"</VALUE>");
				
				if (i == 0) {
					sb.append("<DATA1>"+boardList.get(j).get("BOARDID")+"</DATA1>");
                	sb.append("<DATA2>"+boardList.get(j).get("ITEMID")+"</DATA2>");
        			sb.append("<DATA3>"+boardList.get(j).get("WRITERID")+"</DATA3>");
        			String nowDate = EgovDateUtil.getTodayTime();
				    nowDate = EgovDateUtil.addDay(nowDate, -1, "yyyy-MM-dd HH:mm:ss");
				    
					if (boardList.get(j).get("WRITEDATE").toString().compareTo(nowDate) > 0) {
						sb.append("<DATA4>Y</DATA4>");
					} else {
						sb.append("<DATA4>N</DATA4>");
					}
					sb.append("<DATA5>"+boardList.get(j).get("FILEPATH")+"</DATA5>");
					sb.append("<DATA6>"+ boardList.get(j).get("MAINCONTENT") +"</DATA6>");
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
	public String portalPageItemEdit(String boardID) throws Exception {
		return ezBoardDAO.portalPageItemEdit(boardID);
	}

	/**
	 * 게시판 트리 표출 Method
	 */
	@Override
	public String getBoardTree(String pRootBoardID, String pUserID, String pDeptID, String pCompanyID, int pMode, int pSubFlag, int pSelectBy, String pExcludeBoardID, String pStrLang) throws Exception {
		int count = 0;
        String strForbiddenBoardIDList = "";				
        String retValue = ezBoardAdminService.getBoardTree_Get1(pStrLang, pRootBoardID + "," + pUserID + "," + pDeptID + "," + pCompanyID + "," + pMode + "," + pSubFlag + "," + pSelectBy + "," + pExcludeBoardID);
        
        if (retValue != null && retValue.length() > 30) {
    		return retValue;
        }
        
        String pAccessID = pUserID + "," + ezOrganService.getDeptFullPath(pDeptID) + ",everyone";
        String strRollInfo = ezOrganService.getPropertyValue(pUserID, "extensionattribute1");        
        List<BoardTreeVO> brdBoardTreeList = new ArrayList<BoardTreeVO>();
        
        for (int i = 0; i < pAccessID.split(",").length; i++) {
            String boardID = "";
            
            if (pMode == 0) {
            	brdBoardTreeList = ezBoardAdminService.brdBoardTree(pRootBoardID, "everyone", pMode, pSelectBy, pExcludeBoardID);            
            } else {
            	brdBoardTreeList = ezBoardAdminService.brdBoardTree(pRootBoardID, pUserID, pMode, pSelectBy, pExcludeBoardID);            
            }
            
            List<BoardVO> boardTreeList = ezBoardAdminService.getBoardTree_Get2(pAccessID.split(",")[i].trim(), pRootBoardID);
            
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
        			result.append("<VALUE><![CDATA[" + commonUtil.cleanValue(brdBoardTreeList.get(i).getBoardName()) + "]]></VALUE>");
        		} else {
        			result.append("<VALUE><![CDATA[" + commonUtil.cleanValue(brdBoardTreeList.get(i).getBoardName2()) + "]]></VALUE>");
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
            		result.append("<DATA2><![CDATA[" + commonUtil.cleanValue(brdBoardTreeList.get(i).getBoardName()) + "]]></DATA2>");
            	} else {
            		result.append("<DATA2><![CDATA[" + commonUtil.cleanValue(brdBoardTreeList.get(i).getBoardName2()) + "]]></DATA2>");
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
            result.append("<ISLEAF>" + checkIfLeafBoard(brdBoardTreeList.get(i).getBoardId()) + "</ISLEAF>");

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
        
        ezBoardAdminService.getBoardTree_Set(pStrLang, pRootBoardID + "," + pUserID + "," + pDeptID + "," + pCompanyID + "," + pMode + "," + pSubFlag + "," + pSelectBy + "," + pExcludeBoardID, result.toString());

        return result.toString();
	}

	/**
	 * 게시판 트리하위여부 표출 Method
	 */
	public String checkIfLeafBoard(String pBoardID) {
		try {
	        int ret = ezBoardAdminService.checkIfLeafBoard(pBoardID);
	        
	        if (ret > 0) {
	        	return "FALSE";
	        } else {
	        	return "TRUE";
	        }
		} catch(Exception ex) {
			return "FALSE";
		}
	}
}
