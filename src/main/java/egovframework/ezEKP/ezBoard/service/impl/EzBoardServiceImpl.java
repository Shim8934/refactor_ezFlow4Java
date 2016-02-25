package egovframework.ezEKP.ezBoard.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import egovframework.ezEKP.ezBoard.dao.EzBoardDAO;
import egovframework.ezEKP.ezBoard.service.EzBoardService;
import egovframework.ezEKP.ezBoard.vo.BoardListHeaderVO;
import egovframework.ezEKP.ezBoard.vo.BoardListVO;
import egovframework.ezEKP.ezBoard.vo.BoardPropertyVO;
import egovframework.ezEKP.ezBoard.vo.BoardConfigVO;
import egovframework.ezEKP.ezBoard.vo.EzBoardVO;
import egovframework.ezEKP.ezBoard.vo.MyFavoriteVO;

@Service("EzBoardService")
public class EzBoardServiceImpl implements EzBoardService {
	
	@Resource(name="EzBoardDAO")
	private EzBoardDAO ezBoardDAO;

	@Override
	public List<EzBoardVO> getLeft_BoardSTD(String redirectBoardID) throws Exception{
		return ezBoardDAO.getLeft_BoardSTD(redirectBoardID);
	}

	@Override
	public List<MyFavoriteVO> get_favoriteList(String userID, String pMode) throws Exception{
		return ezBoardDAO.get_favoriteList(userID,pMode);
	}

	@Override
	public String get_parentBoardName(String BoardIdList, int boardIdListCount) throws Exception{
		return ezBoardDAO.get_parentBoardName(BoardIdList,boardIdListCount);
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
	public List<BoardListHeaderVO> getListHeader(EzBoardVO ezBoardVO) throws Exception {
		return ezBoardDAO.getListHeader(ezBoardVO);
	}

	@Override
	public void setListOrder(String pUserID, Map<String, Object> map) throws Exception {
		ezBoardDAO.setListOrder(pUserID, map);
	}

	@Override
	public int getNewItemListCount(String userID, String nowDate, String fromNow)  throws Exception{
		return ezBoardDAO.getNewItemListCount(userID, nowDate, fromNow);
	}

	@Override
	public BoardConfigVO getPersonalCount(String userID) throws Exception {
		return ezBoardDAO.getPersonalCount(userID);
	}

	@Override
	public List<HashMap<String, Object>> getNewItemList(BoardListVO boardListVO) throws Exception{
		return ezBoardDAO.getNewItemList(boardListVO);
	}

	@Override
	public void setBoardList_Config(String pUserID, Map<String, Object> map) throws Exception {
		ezBoardDAO.setBoardList_Config(pUserID, map); 
	}

	@Override
	public int getBrdNewItemCount(MyFavoriteVO myFavoriteVO) throws Exception {
		return ezBoardDAO.getBrdNewItemCount(myFavoriteVO);
	}

	@Override
	public int getThumbNailCount(MyFavoriteVO myFavoriteVO) throws Exception {
		return ezBoardDAO.getThumbNailCount(myFavoriteVO);
	}

	@Override
	public int getBrdTotalItemCount(MyFavoriteVO myFavoriteVO) throws Exception {
		return ezBoardDAO.getBrdTotalItemCount(myFavoriteVO);
	}

	@Override
	public void setTabUsed(String pUserID, Map<String, Object> map)
			throws Exception {
		ezBoardDAO.setTabUsed(pUserID, map);
	}
	
	
}
