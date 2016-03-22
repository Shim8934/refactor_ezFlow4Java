package egovframework.ezEKP.ezBoard.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.ezEKP.ezBoard.vo.BoardListHeaderVO;
import egovframework.ezEKP.ezBoard.vo.BoardListVO;
import egovframework.ezEKP.ezBoard.vo.BoardPropertyVO;
import egovframework.ezEKP.ezBoard.vo.BoardConfigVO;
import egovframework.ezEKP.ezBoard.vo.BoardVO;
import egovframework.ezEKP.ezBoard.vo.BoardMyFavoriteVO;
import egovframework.rte.psl.dataaccess.EgovAbstractDAO;

@Repository("EzBoardDAO")
public class EzBoardDAO extends EgovAbstractDAO{

	@SuppressWarnings("unchecked")
	public List<BoardVO> getLeft_BoardSTD(Map<String, Object> map) throws Exception{
		return (List<BoardVO>) list("EzBoardDAO.getLeft_BoardSTD", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<BoardMyFavoriteVO> get_favoriteList(Map<String, Object> map) throws Exception{
		return (List<BoardMyFavoriteVO>) list("EzBoardDAO.get_favoriteList", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<BoardListHeaderVO> getListHeader(Map<String, Object> map) throws Exception{
		return (List<BoardListHeaderVO>) list("EzBoardDAO.getListHeader", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<BoardListHeaderVO> getListHeaderBoardID(Map<String, Object> map) throws Exception {
		return (List<BoardListHeaderVO>) list("EzBoardDAO.getListHeaderBoardID", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<HashMap<String, Object>> getNoticePostItem(Map<String, Object> map) throws Exception{
		return (List<HashMap<String, Object>>) list("EzBoardDAO.getNoticePostItem", map);
	}

	@SuppressWarnings("unchecked")
	public List<HashMap<String, Object>> getBoardListItem(Map<String, Object> map) throws Exception{
		return (List<HashMap<String, Object>>) list("EzBoardDAO.getBoardListItem", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<HashMap<String, Object>> getNewItemList(Map<String, Object> map) throws Exception{
		return (List<HashMap<String, Object>>) list("EzBoardDAO.getNewItemList", map);
	}
	
	public BoardListVO getBrdGetItemInfo(Map<String, Object> map) throws Exception{
		return (BoardListVO) select("EzBoardDAO.getBrdGetItemInfo", map);
	}

	public BoardConfigVO getPersonalCount(String userID) throws Exception{
		return (BoardConfigVO) select("EzBoardDAO.getPersonalCount", userID);
	}
	
	public BoardConfigVO getBoardList_Config(String userID) throws Exception{
		return (BoardConfigVO) select("EzBoardDAO.getBoardList_Config", userID);
	}

	public BoardPropertyVO getBoardProperty(String pBoardID) throws Exception{
		return (BoardPropertyVO) select("EzBoardDAO.getBoardProperty", pBoardID);
	}

	public String get_parentBoardName(Map<String, Object> map) throws Exception{
		return (String) select("EzBoardDAO.get_parentBoardName", map);
	}
	
	public int getBrdNewItemCount(Map<String, Object> map) throws Exception{
		select("EzBoardDAO.getBrdNewItemCount",map);
		return (int)map.get("v_pCount");
	}

	public int getThumbNailCount(Map<String, Object> map) throws Exception{
		select("EzBoardDAO.getThumbNailCount",map);
		return (int)map.get("v_pCount");
	}

	public int getBrdTotalItemCount(Map<String, Object> map) throws Exception{
		select("EzBoardDAO.getBrdTotalItemCount",map);
		return (int)map.get("v_pCount");
	}

	public int getQNABrdTotalItemCount(Map<String, Object> map) throws Exception{
		select("EzBoardDAO.getQNABrdTotalItemCount",map);
		return (int)map.get("v_pCount");
	}
	
	public int getNewItemListCount(Map<String, Object> map) throws Exception{
		select("EzBoardDAO.getNewItemListCount", map);
		return (int)map.get("v_pCount");
	}
	
	public int getNoticePostItemCount(String boardId) throws Exception{
		return (int)select("EzBoardDAO.getNoticePostItemCount", boardId);
	}

	public int getBoardTotalItemCount(Map<String, Object> map) throws Exception{
		return (int) select("EzBoardDAO.getBoardTotalItemCount", map);
	}

	public int getCheckItemID(Map<String, Object> map) throws Exception{
		select("EzBoardDAO.getCheckItemID", map);
		return (int)map.get("v_pCount");
	}
	
	public int checkForm(Map<String, Object> map) throws Exception{
		select("EzBoardDAO.checkForm", map);
		return (int)map.get("v_pCount");
	}

	public int checkBackGroundImage(String boardID) throws Exception{
		return (int) select("EzBoardDAO.checkBackGroundImage", boardID);
	}

	public int getCheckApprUserList(Map<String, Object> map) throws Exception{
		return (int) select("EzBoardDAO.getCheckApprUserList", map);
	}

	public void brdNewItem(BoardListVO boardListVO) throws Exception{
		insert("EzBoardDAO.brdNewItem", boardListVO);
	}
	
	public void newItem(String itemID) throws Exception{
		insert("EzBoardDAO.newItem", itemID);
	}
	
	public void setAsRead(Map<String, Object> map) throws Exception{
		insert("EzBoardDAO.setAsRead", map);
	}
	
	public void setAsReads(Map<String, Object> map) throws Exception{
		insert("EzBoardDAO.setAsReads", map);
	}
	
	public void saveAttachInfo(Map<String, Object> map) throws Exception{
		insert("EzBoardDAO.saveAttachInfo", map);
	}
	
	public void setListOrder(Map<String, Object> map) throws Exception {
		update("EzBoardDAO.set_ListOrder",map);
	}
	
	public void setTabUsed(Map<String, Object> map) throws Exception{
		update("EzBoardDAO.set_TabUsed",map);
	}
	
	public void setBoardList_Config(String pUserID, Map<String, Object> map) throws Exception{
		update("EzBoardDAO.setBoardList_Config", map);
	}




	
}