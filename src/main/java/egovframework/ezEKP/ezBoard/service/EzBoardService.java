package egovframework.ezEKP.ezBoard.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import egovframework.ezEKP.ezBoard.vo.BoardAttachVO;
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
	
	public List<HashMap<String, Object>> getNewItemList(BoardListVO boardListVO) throws Exception;

	public List<HashMap<String, Object>> getNoticePostItem(BoardVO ezBoardVO, int personalCount) throws Exception;

	public List<HashMap<String, Object>> getBoardListItem(String boardId, String userID, int startRow, int endRow, int boardCount, String orderOption1, String orderOption2, String type) throws Exception;
	
	public List<HashMap<String, Object>> getSearchBoardItemList(BoardListVO boardListVO, BoardVO boardVO) throws Exception;

	public List<String> getCopyItemAttach(String orgItemID) throws Exception;
	
	public BoardPropertyVO getBoardProperty(String pBoardID) throws Exception;
	
	public BoardConfigVO getPersonalCount(String userID) throws Exception;

	public BoardConfigVO getBoardList_Config(String userId) throws Exception;
	
	public BoardListVO getBrdGetItemInfo(String boardID, String itemID) throws Exception;
	
	public BoardListVO getItemInfo(String itemID) throws Exception;
	
	public BoardListVO getCopyItem(String orgItemID, String orgBoardID) throws Exception;
	
	public String getBoardProperty(String pBoardID, BoardPropertyVO boardInfo, LoginVO userInfo) throws Exception;
	
	public String get_parentBoardName(String BoardIdList, int boardIdListCount) throws Exception;
	
	public String checkForm(String boardID, String mode) throws Exception;

	public String checkBackGroundImage(String boardID) throws Exception;

	public String brdCheckIfHasReply(String itemIDs) throws Exception;
	
	public String getNoticePostItemAll(String boardID) throws Exception;
	
	public String getParentBoardID(String boardID) throws Exception;
	
	public String getDocPassWord(String itemID) throws Exception;
	
	public int getNewItemListCount(String userID, String nowDate, String fromNow) throws Exception;

	public int getBrdNewItemCount(String userID) throws Exception;

	public int getThumbNailCount(BoardMyFavoriteVO myFavoriteVO) throws Exception;

	public int getBrdTotalItemCount(BoardMyFavoriteVO myFavoriteVO)  throws Exception;

	public int getQNABrdTotalItemCount(BoardMyFavoriteVO myFavoriteVO) throws Exception;
	
	public int getNoticePostItemCount(String boardId) throws Exception;

	public int getBoardTotalItemCount(String boardId, String userID, String type) throws Exception;

	public int getCheckItemID(String itemID, String boardType, String userDeptPath) throws Exception;
	
	public int getCheckApprUserList(String id, String itemID) throws Exception;
	
	public int getSearchBoardItemCount(BoardVO boardVO) throws Exception;
	
	public void brdNewItem(BoardListVO boardListVO) throws Exception;
	
	public void brdNewItemTemp(BoardListVO boardListVO) throws Exception;

	public void saveAttachInfo(String strItemID, String filePath, long fileSize, String fileName) throws Exception;
	
	public void setBoardList_Config(String pUserID, Map<String, Object> map) throws Exception;

	public void setAsRead(LoginVO userInfo, String boardID, String itemID) throws Exception;

	public void setAsReads(LoginVO userInfo, String pBoardID, String pItemIDList) throws Exception;
	
	public void setListOrder(String pUserID, Map<String, Object> map) throws Exception;

	public void setTabUsed(String pUserID, String pBoardList, String tabUsed) throws Exception;
	
	public void setNotiOrder(String itemID) throws Exception;

	public void updateCopyItem(String itemID) throws Exception;
	
	public void updateMoveItem(String destItemID, String orgItemID) throws Exception;
	
	public void deleteItem(String itemIDs, String boardID) throws Exception;

	public void deleteTempItem(String itemIDs, String boardID) throws Exception;
	



}
