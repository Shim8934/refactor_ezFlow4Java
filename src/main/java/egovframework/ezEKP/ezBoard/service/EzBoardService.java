package egovframework.ezEKP.ezBoard.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import egovframework.ezEKP.ezBoard.vo.BoardAttachVO;
import egovframework.ezEKP.ezBoard.vo.BoardLineReplyVO;
import egovframework.ezEKP.ezBoard.vo.BoardListHeaderVO;
import egovframework.ezEKP.ezBoard.vo.BoardListVO;
import egovframework.ezEKP.ezBoard.vo.BoardPropertyVO;
import egovframework.ezEKP.ezBoard.vo.BoardConfigVO;
import egovframework.ezEKP.ezBoard.vo.BoardReadVO;
import egovframework.ezEKP.ezBoard.vo.BoardVO;
import egovframework.ezEKP.ezBoard.vo.BoardMyFavoriteVO;
import egovframework.let.user.login.vo.LoginVO;

public interface EzBoardService {

	public List<BoardVO> getLeft_BoardSTD(String redirectBoardID) throws Exception;
	
	public List<BoardVO> get_apprUserList(String boardID) throws Exception;

	public List<BoardMyFavoriteVO> get_favoriteList(String userID, String pMode) throws Exception;

	public List<BoardListHeaderVO> getListHeader(BoardVO ezBoardVO) throws Exception;
	
	public List<BoardListHeaderVO> getListHeaderBoardID(BoardVO ezBoardVO) throws Exception;
	
	public List<BoardAttachVO> brdGetItemAttachmentInfo(String pItemID) throws Exception;
	
	public List<BoardReadVO> getReaderList(String boardID, String itemID, String userID, String lang) throws Exception;
	
	public List<BoardListVO> getAdjacentItems1(String boardID, String parentWriteDate, String upperItemIDTree) throws Exception;
	
	public List<BoardListVO> getAdjacentItems2(String boardID, String parentWriteDate) throws Exception;
	
	public List<BoardListVO> getAdjacentItems3(String boardID, String parentWriteDate, String itemID, String upperItemIDTree, String previousItemID) throws Exception;
	
	public List<BoardListVO> getAdjacentItems2Photo(String boardID, String parentWriteDate) throws Exception;

	public List<BoardListVO> getAdjacentItems3Photo(String boardID, String parentWriteDate) throws Exception;
	
	public List<BoardAttachVO> photoViewDB(String itemID, String boardID, int pStartRow, int pEndRow) throws Exception;
	
	public List<BoardAttachVO> photoViewDBAll(String itemID, String boardID) throws Exception;
	
	public List<BoardListVO> getReservedItemList(String userID, int startRow, int endRow, String sortBy, String lang) throws Exception;
	
	public List<BoardLineReplyVO> readOneLineReply(String boardID, String itemID, String userName) throws Exception;
	
	public List<HashMap<String, Object>> getNewItemList(BoardListVO boardListVO) throws Exception;

	public List<HashMap<String, Object>> getNoticePostItem(BoardVO ezBoardVO, int personalCount) throws Exception;

	public List<HashMap<String, Object>> getBoardListItem(String boardId, String userID, int startRow, int endRow, int boardCount, String orderOption1, String orderOption2, String type) throws Exception;
	
	public List<HashMap<String, Object>> getQnABoardListItem(String boardId, String userID, int startRow, int endRow, int boardCount, String orderOption1, String orderOption2, String type, String adminType) throws Exception;
	
	public List<HashMap<String, Object>> getSearchBoardItemList(BoardListVO boardListVO, BoardVO boardVO) throws Exception;
	
	public List<HashMap<String, Object>> getThumbnailList(BoardListVO boardListVO, BoardVO boardVO) throws Exception;
	
	public List<HashMap<String, Object>> getSearchThumbnailList(BoardListVO boardListVO, BoardVO boardVO) throws Exception;
	
	public List<HashMap<String, Object>> getMyNoticePostItem(String userID, String type, int start, int end) throws Exception;
	
	public List<HashMap<String, Object>> getMyBoardListItem(String userID, int startRow, int endRow, int boardCount, String orderOption1, String orderOption2) throws Exception;

	public List<HashMap<String, Object>> getMyBoardListItemTemp(String userID, int startRow, int endRow, int boardCount, String orderOption1, String orderOption2) throws Exception;
	
	public List<HashMap<String, Object>> getApprBoardListItem(String id, int startRow, int endRow, int boardCount, String orderOption1, String orderOption2) throws Exception;
	
	public List<HashMap<String, Object>> getSearchMyBoardItemList(BoardListVO boardListVO, BoardVO boardVO) throws Exception;

	public List<HashMap<String, Object>> getSearchMyBoardItemListTemp(BoardListVO boardListVO, BoardVO boardVO) throws Exception;

	public List<String> getCopyItemAttach(String orgItemID) throws Exception;
	
	public BoardPropertyVO getBoardProperty(String pBoardID) throws Exception;
	
	public BoardConfigVO getPersonalCount(String userID) throws Exception;

	public BoardConfigVO getBoardList_Config(String userId) throws Exception;
	
	public BoardListVO getBrdGetItemInfo(String boardID, String itemID) throws Exception;
	
	public BoardListVO getItemInfo(String itemID) throws Exception;
	
	public BoardListVO getCopyItem(String orgItemID, String orgBoardID) throws Exception;
	
	public BoardListVO getBrdGetItemInfoTemp(String boardID, String itemID) throws Exception;
	
	public String getBoardProperty(String pBoardID, BoardPropertyVO boardInfo, LoginVO userInfo) throws Exception;
	
	public String get_parentBoardName(String BoardIdList, int boardIdListCount) throws Exception;
	
	public String checkForm(String boardID, String mode) throws Exception;

	public String checkBackGroundImage(String boardID) throws Exception;

	public String brdCheckIfHasReply(String itemIDs) throws Exception;
	
	public String getNoticePostItemAll(String boardID) throws Exception;
	
	public String getParentBoardID(String boardID) throws Exception;
	
	public String getDocPassWord(String itemID) throws Exception;
	
	public String deleteTempItem(String strItemID) throws Exception;
	
	public String getItemXML(String boardID, String itemID, String lang) throws Exception;

	public String getItemTempXML(String boardID, String itemID, String lang) throws Exception;
	
	public String setBoardConfig(String userID, String listCount, String preView) throws Exception;
	
	public String apprItem(String userID, String itemList, String pMod) throws Exception;
	
	public String deleteOneLineReply(String id, String replyID, String guBun) throws Exception;
	
	public String checkOneLineOwner(String replyID, String userID) throws Exception;
	
	public String getThumbListXML (String pUserID, String pBoardType, String pBoardID, int pPageNum, String sortHeader, String sortOption, String strLang) throws Exception;
	
	public int getReservedItemListCount(String userID) throws Exception;
	
	public int getNewItemListCount(String userID) throws Exception;

	public int getBrdNewItemCount(String userID) throws Exception;

	public int getThumbNailCount(BoardMyFavoriteVO myFavoriteVO) throws Exception;

	public int getBrdTotalItemCount(BoardMyFavoriteVO myFavoriteVO)  throws Exception;

	public int getQNABrdTotalItemCount(BoardMyFavoriteVO myFavoriteVO) throws Exception;
	
	public int getNoticePostItemCount(String boardId) throws Exception;

	public int getBoardTotalItemCount(String boardId, String userID, String type) throws Exception;

	public int getCheckItemID(String itemID, String boardType, String userDeptPath) throws Exception;
	
	public int getCheckApprUserList(String id, String itemID) throws Exception;
	
	public int getSearchBoardItemCount(BoardVO boardVO) throws Exception;
	
	public int checkApprUserList(String userID, String itemID) throws Exception;
	
	public int getMyBoardTotalItemCount(String userID) throws Exception;

	public int getMyBoardTotalItemCountTemp(String userID) throws Exception;
	
	public int getMyNoticePostItemCount(String userID) throws Exception;
	
	public int getSearchMyBoardItemCount(LoginVO userInfo, BoardVO boardVO) throws Exception;

	public int getSearchMyBoardItemCountTemp(LoginVO userInfo, BoardVO boardVO) throws Exception;
	
	public int getApprBoardTotalItemCount(String userID) throws Exception;
	
	public void brdNewItem(BoardListVO boardListVO) throws Exception;
	
	public void brdNewItemPhoto(BoardListVO boardListVO) throws Exception;
	
	public void brdNewItemTemp(BoardListVO boardListVO) throws Exception;
	
	public void brdNewItemTempPhoto(BoardListVO boardListVO) throws Exception;
	
	public void photoListInsert(BoardListVO boardListVO) throws Exception;
	
	public void brdUpdateItem(BoardListVO boardListVO, String mode) throws Exception;

	public void saveAttachInfo(String strItemID, String filePath, long fileSize, String fileName) throws Exception;
	
	public void saveOneLineReply(String itemID, String replyID, String boardID, LoginVO userInfo, String content, String password) throws Exception;
	
	public void setBoardList_Config(String pUserID, Map<String, Object> map) throws Exception;

	public void setAsRead(LoginVO userInfo, String boardID, String itemID) throws Exception;

	public void setAsReads(LoginVO userInfo, String pBoardID, String pItemIDList) throws Exception;
	
	public void setListOrder(String pUserID, Map<String, Object> map) throws Exception;

	public void setTabUsed(String pUserID, String pBoardList, String tabUsed) throws Exception;
	
	public void setMainImageID(String mainImageID, String itemID, String type) throws Exception;
	
	public void setNotiOrder(String itemID) throws Exception;
	
	public void photoListUpdate(String imageID, String boardID, String content, String file_Path, String itemID, String mainFg) throws Exception;

	public void updateCopyItem(String itemID) throws Exception;
	
	public void updateMoveItem(String destItemID, String orgItemID) throws Exception;
	
	public void setBoardList_Config2(String userID, String listCount, String previewMode, String list, String content) throws Exception;
	
	public void photoListAlbumEdit(String boardID, String itemID, String title, String content) throws Exception;
	
	public void photoListAlbumEditTemp(String boardID, String itemID, String title, String content) throws Exception;
	
	public void deleteItem(String itemIDs, String boardID) throws Exception;

	public void deleteTempItem(String itemIDs, String boardID) throws Exception;
	
	public void photoListDel(String boardID, String imageID) throws Exception;

}
