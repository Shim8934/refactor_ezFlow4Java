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

	List<EzBoardVO> getLeft_BoardSTD(String redirectBoardID) throws Exception;

	List<MyFavoriteVO> get_favoriteList(String userID, String pMode) throws Exception;

	String get_parentBoardName(String BoardIdList, int boardIdListCount) throws Exception;

	BoardPropertyVO getBoardProperty(String pBoardID) throws Exception;
	
	BoardConfigVO getBoardList_Config(String userId) throws Exception;
	
	void setBoardList_Config(String pUserID, Map<String, Object> map) throws Exception;

	List<BoardListHeaderVO> getListHeader(EzBoardVO ezBoardVO) throws Exception;

	int getNewItemListCount(String userID, String nowDate, String fromNow) throws Exception;

	BoardConfigVO getPersonalCount(String userID) throws Exception;

	List<HashMap<String, Object>> getNewItemList(BoardListVO boardListVO) throws Exception;

	int getBrdNewItemCount(MyFavoriteVO myFavoriteVO) throws Exception;

	int getThumbNailCount(MyFavoriteVO myFavoriteVO) throws Exception;

	int getBrdTotalItemCount(MyFavoriteVO myFavoriteVO)  throws Exception;

}
