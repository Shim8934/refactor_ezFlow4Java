package egovframework.ezEKP.ezBoard.service;

import java.util.List;

import egovframework.ezEKP.ezBoard.vo.EzBoardVO;
import egovframework.ezEKP.ezBoard.vo.MyFavoriteVO;

public interface EzBoardService {

	List<EzBoardVO> getLeft_BoardSTD(String redirectBoardID) throws Exception;

	List<MyFavoriteVO> get_favoriteList(String userID, String pMode);

	String get_parentBoardName(String BoardIdList, int boardIdListCount);

}
