package egovframework.ezEKP.ezBoard.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import egovframework.ezEKP.ezBoard.vo.BoardListHeaderVO;
import egovframework.ezEKP.ezBoard.vo.BoardListVO;
import egovframework.ezEKP.ezBoard.vo.BoardPropertyVO;
import egovframework.ezEKP.ezBoard.vo.BoardConfigVO;
import egovframework.ezEKP.ezBoard.vo.EzBoardVO;
import egovframework.ezEKP.ezBoard.vo.MyFavoriteVO;

public interface EzBoardService {

	public List<EzBoardVO> getLeft_BoardSTD(String redirectBoardID) throws Exception;

	public List<MyFavoriteVO> get_favoriteList(String userID, String pMode) throws Exception;

	public String get_parentBoardName(String BoardIdList, int boardIdListCount) throws Exception;

	public BoardPropertyVO getBoardProperty(String pBoardID) throws Exception;
	
	public BoardConfigVO getBoardList_Config(String userId) throws Exception;
	
	public void setBoardList_Config(String pUserID, Map<String, Object> map) throws Exception;

	public List<BoardListHeaderVO> getListHeader(EzBoardVO ezBoardVO) throws Exception;

	public int getNewItemListCount(String userID, String nowDate, String fromNow) throws Exception;

	public BoardConfigVO getPersonalCount(String userID) throws Exception;

	public List<HashMap<String, Object>> getNewItemList(BoardListVO boardListVO) throws Exception;

	public int getBrdNewItemCount(MyFavoriteVO myFavoriteVO) throws Exception;

	public int getThumbNailCount(MyFavoriteVO myFavoriteVO) throws Exception;

	public int getBrdTotalItemCount(MyFavoriteVO myFavoriteVO)  throws Exception;

	public int getQNABrdTotalItemCount(MyFavoriteVO myFavoriteVO) throws Exception;
	
	public void setListOrder(String pUserID, Map<String, Object> map) throws Exception;

	public void setTabUsed(String pUserID, String pBoardList, String tabUsed) throws Exception;
	
	public List<BoardListHeaderVO> getListHeaderBoardID(EzBoardVO ezBoardVO) throws Exception;

	public int getNoticePostItemCount(String boardId) throws Exception;

	public int getBoardTotalItemCount(String boardId, String userID, String type) throws Exception;

	public List<HashMap<String, Object>> getNoticePostItem(EzBoardVO ezBoardVO, int personalCount) throws Exception;

	public List<HashMap<String, Object>> getBoardListItem(String boardId, String userID, int startRow, int endRow, int boardCount, String orderOption1, String orderOption2, String type) throws Exception;

}
