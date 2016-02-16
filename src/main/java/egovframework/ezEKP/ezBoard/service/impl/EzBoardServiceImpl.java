package egovframework.ezEKP.ezBoard.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import egovframework.ezEKP.ezBoard.dao.EzBoardDAO;
import egovframework.ezEKP.ezBoard.service.EzBoardService;
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
	public List<MyFavoriteVO> get_favoriteList(String userID, String pMode) {
		return ezBoardDAO.get_favoriteList(userID,pMode);
	}

	@Override
	public String get_parentBoardName(String BoardIdList, int boardIdListCount) {
		return ezBoardDAO.get_parentBoardName(BoardIdList,boardIdListCount);
	}

	@Override
	public BoardConfigVO getBoardList_Config(String userId) throws Exception {
		// TODO Auto-generated method stub
		return ezBoardDAO.getBoardList_Config(userId);
	}
	
	
}
