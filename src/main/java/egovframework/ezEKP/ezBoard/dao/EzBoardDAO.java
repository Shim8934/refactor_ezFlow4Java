package egovframework.ezEKP.ezBoard.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

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
	
	public void setBoardList_Config(String pUserID, Map<String, Object> map) {		
		map.put("v_PUSERID", pUserID);
		map.put("v_PLISTCNT", map.get("pListCount"));
		map.put("v_PREVIEWMODE", map.get("pPreview"));
		map.put("v_PREVIEWWLIST", map.get("pPreviewWList"));
		map.put("v_PREVIEWWCONTENT", map.get("pPreviewWContent"));
		map.put("v_PREVIEWHLIST", map.get("pPreviewHList"));
		map.put("v_PREVIEWHCONTENT", map.get("pPreviewHContent"));
		update("EzBoardDAO.setBoardList_Config", map);
	}
}