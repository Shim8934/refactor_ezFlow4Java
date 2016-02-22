package egovframework.ezEKP.ezBoard.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.ezEKP.ezBoard.vo.BoardListHeaderVO;
import egovframework.ezEKP.ezBoard.vo.BoardListVO;
import egovframework.ezEKP.ezBoard.vo.BoardPropertyVO;
import egovframework.ezEKP.ezBoard.vo.BoardConfigVO;
import egovframework.ezEKP.ezBoard.vo.EzBoardVO;
import egovframework.ezEKP.ezBoard.vo.MyFavoriteVO;
import egovframework.rte.psl.dataaccess.EgovAbstractDAO;

@Repository("EzBoardDAO")
public class EzBoardDAO extends EgovAbstractDAO{
	Map<String, Object> map = new HashMap<String, Object>();

	@SuppressWarnings("unchecked")
	public List<EzBoardVO> getLeft_BoardSTD(String redirectBoardID) throws Exception{
		map.put("redirectBoardID", redirectBoardID);
		return (List<EzBoardVO>) list("EzBoardDAO.getLeft_BoardSTD", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<MyFavoriteVO> get_favoriteList(String userID, String pMode) throws Exception{
		map.put("v_USERID", userID);
		map.put("v_MODE", pMode);
		return (List<MyFavoriteVO>) list("EzBoardDAO.get_favoriteList", map);
	}
	
	public BoardConfigVO getBoardList_Config(String userID) {
		return (BoardConfigVO) select("EzBoardDAO.getBoardList_Config", userID);
	}

	public String get_parentBoardName(String boardIdList, int boardIdListCount) throws Exception{
		map.put("v_BOARDIDLIST", boardIdList);
		map.put("v_BOARDCOUNTLIST", boardIdListCount);
		return (String) select("EzBoardDAO.get_parentBoardName", map);
	}

	public BoardPropertyVO getBoardProperty(String pBoardID) throws Exception{
		return (BoardPropertyVO) select("EzBoardDAO.getBoardProperty", pBoardID);
	}

	@SuppressWarnings("unchecked")
	public List<BoardListHeaderVO> getListHeader(EzBoardVO ezBoardVO) throws Exception{
		map.put("v_PBOARDTYPE", ezBoardVO.getBoardType());
		map.put("v_PSTRLANG", ezBoardVO.getLang());
		return (List<BoardListHeaderVO>) list("EzBoardDAO.getListHeader", map);
	}

	public int getNewItemListCount(String id, String nowDate, String fromNow) throws Exception{
		map.put("v_pUserID", id);
		map.put("v_pNow", nowDate);
		map.put("v_pFromNow", fromNow);
		select("EzBoardDAO.getNewItemListCount", map);
		return (int)map.get("v_pCount");
	}

	public BoardConfigVO getPersonalCount(String userID) {
		return (BoardConfigVO) select("EzBoardDAO.getPersonalCount", userID);
	}

	public void setBoardList_Config(String pUserID, Map<String, Object> map) throws Exception{
		map.put("v_PUSERID", pUserID);
		map.put("v_PLISTCNT", map.get("pListCount"));
		map.put("v_PREVIEWMODE", map.get("pPreview"));
		map.put("v_PREVIEWWLIST", map.get("pPreviewWList"));
		map.put("v_PREVIEWWCONTENT", map.get("pPreviewWContent"));
		map.put("v_PREVIEWHLIST", map.get("pPreviewHList"));
		map.put("v_PREVIEWHCONTENT", map.get("pPreviewHContent"));
		update("EzBoardDAO.setBoardList_Config", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<HashMap<String, Object>> getNewItemList(BoardListVO boardListVO) throws Exception{
		map.put("v_PUSERID", boardListVO.getUserID());
		map.put("v_PSTARTROW", boardListVO.getStartRow());
		map.put("v_PENDROW", boardListVO.getEndRow());
		map.put("v_PTOTALCOUNT", boardListVO.getTotalCount());
		map.put("iv_PORDERBYSUB", boardListVO.getOrderBySub());
		map.put("v_PORDERBYMAIN", boardListVO.getOrderByMain());
		return (List<HashMap<String, Object>>) list("EzBoardDAO.getNewItemList", map);
	}

	public int getBrdNewItemCount(MyFavoriteVO myFavoriteVO) throws Exception{
		map.put("v_pUserID", myFavoriteVO.getUserId());
		map.put("v_pNow", myFavoriteVO.getNowDate());
		map.put("v_pFromNow", myFavoriteVO.getFromNow());
		select("EzBoardDAO.getBrdNewItemCount",map);
		return (int)map.get("v_pCount");
	}

	public int getThumbNailCount(MyFavoriteVO myFavoriteVO) throws Exception{
		map.put("v_PBOARDID", myFavoriteVO.getBoardId());
		map.put("v_PNOW", myFavoriteVO.getNowDate());
		map.put("v_PUSERID", myFavoriteVO.getUserId());
		map.put("v_PTYPE", myFavoriteVO.getType());
		select("EzBoardDAO.getThumbNailCount",map);
		return (int)map.get("v_pCount");
	}

	public int getBrdTotalItemCount(MyFavoriteVO myFavoriteVO) throws Exception{
		map.put("v_PBOARDID", myFavoriteVO.getBoardId());
		map.put("v_PNOW", myFavoriteVO.getNowDate());
		map.put("v_PUSERID", myFavoriteVO.getUserId());
		map.put("v_PTYPE", myFavoriteVO.getType());
		select("EzBoardDAO.getBrdTotalItemCount",map);
		return (int)map.get("v_pCount");
	}
	
}