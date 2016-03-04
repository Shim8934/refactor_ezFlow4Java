package egovframework.ezEKP.ezBoard.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.ezEKP.ezBoard.vo.BoardListHeaderVO;
import egovframework.ezEKP.ezBoard.vo.BoardPropertyVO;
import egovframework.ezEKP.ezBoard.vo.BoardConfigVO;
import egovframework.ezEKP.ezBoard.vo.EzBoardVO;
import egovframework.ezEKP.ezBoard.vo.MyFavoriteVO;
import egovframework.rte.psl.dataaccess.EgovAbstractDAO;

@Repository("EzBoardDAO")
public class EzBoardDAO extends EgovAbstractDAO{

	@SuppressWarnings("unchecked")
	public List<EzBoardVO> getLeft_BoardSTD(Map<String, Object> map) throws Exception{
		return (List<EzBoardVO>) list("EzBoardDAO.getLeft_BoardSTD", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<MyFavoriteVO> get_favoriteList(Map<String, Object> map) throws Exception{
		return (List<MyFavoriteVO>) list("EzBoardDAO.get_favoriteList", map);
	}
	
	public BoardConfigVO getBoardList_Config(String userID) {
		return (BoardConfigVO) select("EzBoardDAO.getBoardList_Config", userID);
	}

	public String get_parentBoardName(Map<String, Object> map) throws Exception{
		return (String) select("EzBoardDAO.get_parentBoardName", map);
	}

	public BoardPropertyVO getBoardProperty(String pBoardID) throws Exception{
		return (BoardPropertyVO) select("EzBoardDAO.getBoardProperty", pBoardID);
	}

	@SuppressWarnings("unchecked")
	public List<BoardListHeaderVO> getListHeader(Map<String, Object> map) throws Exception{
		return (List<BoardListHeaderVO>) list("EzBoardDAO.getListHeader", map);
	}

	public int getNewItemListCount(Map<String, Object> map) throws Exception{
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
	public List<HashMap<String, Object>> getNewItemList(Map<String, Object> map) throws Exception{
		return (List<HashMap<String, Object>>) list("EzBoardDAO.getNewItemList", map);
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
	
	public void setListOrder(String pUserID, Map<String, Object> map) throws Exception {
		map.put("v_ORDERBOARDIDLIST", map.get("pBoardList"));
		map.put("v_ORDERBOARDLISTCOUNT", map.get("pBoardListCount"));
		map.put("v_DELBOARDIDLIST", map.get("pDelBoardList"));
		map.put("v_DELBOARDLISTCOUNT", map.get("pDelBoardListCount"));
		map.put("v_USERID", pUserID);
		map.put("v_ERR_CD", map.get("v_ERR_CD"));
		update("EzBoardDAO.set_ListOrder",map);
	}
	
	public void setTabUsed(String pUserID, Map<String, Object> map) throws Exception{
		map.put("v_BOARDID", map.get("boardId"));
		map.put("v_TABUSED", map.get("tabUsed"));
		map.put("v_USERID", pUserID);
		update("EzBoardDAO.set_TabUsed",map);
	}
	
}