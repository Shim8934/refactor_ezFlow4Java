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

	Map<String, Object> map = new HashMap<String, Object>();
	
	@Resource(name="EzBoardDAO")
	private EzBoardDAO ezBoardDAO;

	@Override
	public List<EzBoardVO> getLeft_BoardSTD(String redirectBoardID) throws Exception{
		map.put("redirectBoardID", redirectBoardID);
		return ezBoardDAO.getLeft_BoardSTD(map);
	}

	@Override
	public List<MyFavoriteVO> get_favoriteList(String userID, String pMode) throws Exception{
		map.put("v_USERID", userID);
		map.put("v_MODE", pMode);
		return ezBoardDAO.get_favoriteList(map);
	}

	@Override
	public String get_parentBoardName(String boardIdList, int boardIdListCount) throws Exception{
		map.put("v_BOARDIDLIST", boardIdList);
		map.put("v_BOARDCOUNTLIST", boardIdListCount);
		return ezBoardDAO.get_parentBoardName(map);
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
		map.put("v_PBOARDTYPE", ezBoardVO.getBoardType());
		map.put("v_PSTRLANG", ezBoardVO.getLang());
		return ezBoardDAO.getListHeader(map);
	}

	@Override
	public void setListOrder(String pUserID, Map<String, Object> map) throws Exception {
		ezBoardDAO.setListOrder(pUserID, map);
	}

	@Override
	public int getNewItemListCount(String userID, String nowDate, String fromNow)  throws Exception{
		map.put("v_pUserID", userID);
		map.put("v_pNow", nowDate);
		map.put("v_pFromNow", fromNow);
		return ezBoardDAO.getNewItemListCount(map);
	}

	@Override
	public BoardConfigVO getPersonalCount(String userID) throws Exception {
		return ezBoardDAO.getPersonalCount(userID);
	}

	@Override
	public List<HashMap<String, Object>> getNewItemList(BoardListVO boardListVO) throws Exception{
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
		ezBoardDAO.setBoardList_Config(pUserID, map); 
	}

	@Override
	public int getBrdNewItemCount(MyFavoriteVO myFavoriteVO) throws Exception {
		map.put("v_pUserID", myFavoriteVO.getUserId());
		map.put("v_pNow", myFavoriteVO.getNowDate());
		map.put("v_pFromNow", myFavoriteVO.getFromNow());
		return ezBoardDAO.getBrdNewItemCount(map);
	}

	@Override
	public int getThumbNailCount(MyFavoriteVO myFavoriteVO) throws Exception {
		map.put("v_PBOARDID", myFavoriteVO.getBoardId());
		map.put("v_PNOW", myFavoriteVO.getNowDate());
		map.put("v_PUSERID", myFavoriteVO.getUserId());
		map.put("v_PTYPE", myFavoriteVO.getType());
		return ezBoardDAO.getThumbNailCount(map);
	}

	@Override
	public int getBrdTotalItemCount(MyFavoriteVO myFavoriteVO) throws Exception {
		map.put("v_PBOARDID", myFavoriteVO.getBoardId());
		map.put("v_PNOW", myFavoriteVO.getNowDate());
		map.put("v_PUSERID", myFavoriteVO.getUserId());
		map.put("v_PTYPE", myFavoriteVO.getType());
		return ezBoardDAO.getBrdTotalItemCount(map);
	}

	@Override
	public int getQNABrdTotalItemCount(MyFavoriteVO myFavoriteVO) throws Exception {
		map.put("v_PBOARDID", myFavoriteVO.getBoardId());
		map.put("v_PNOW", myFavoriteVO.getNowDate());
		map.put("v_PUSERID", myFavoriteVO.getUserId());
		map.put("v_PTYPE", myFavoriteVO.getType());
		map.put("v_PADMINTYPE", myFavoriteVO.getBoardAdmin_FG());
		return ezBoardDAO.getQNABrdTotalItemCount(map);
	}

	@Override
	public void setTabUsed(String pUserID, Map<String, Object> map) throws Exception {
		ezBoardDAO.setTabUsed(pUserID, map);
	}
	
	
}
