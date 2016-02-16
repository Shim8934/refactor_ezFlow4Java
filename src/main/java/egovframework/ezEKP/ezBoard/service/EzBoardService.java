package egovframework.ezEKP.ezBoard.service;

import java.util.List;

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

}
