package egovframework.ezEKP.ezBoard.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.ezEKP.ezBoard.vo.BoardConfigVO;
import egovframework.ezEKP.ezBoard.vo.EzBoardVO;
import egovframework.ezEKP.ezBoard.vo.MyFavoriteVO;
import egovframework.rte.psl.dataaccess.EgovAbstractDAO;

@Repository("EzBoardDAO")
public class EzBoardDAO extends EgovAbstractDAO{
	Map<String, Object> map = new HashMap<String, Object>();

	@SuppressWarnings("unchecked")
	public List<EzBoardVO> getLeft_BoardSTD(String redirectBoardID) {
		map.put("redirectBoardID", redirectBoardID);
		return (List<EzBoardVO>) list("EzBoardDAO.getLeft_BoardSTD", map);
	}

	@SuppressWarnings("unchecked")
	public List<MyFavoriteVO> get_favoriteList(String userID, String pMode) {
		map.put("v_USERID", userID);
		map.put("v_MODE", pMode);
		return (List<MyFavoriteVO>) list("EzBoardDAO.get_favoriteList", map);
	}
	
	@SuppressWarnings("unchecked")
	public BoardConfigVO getBoardList_Config(String userID) {
		map.put("v_USERID", userID);
		return (BoardConfigVO) select("EzBoardDAO.getBoardList_Config", map);
	}

	public String get_parentBoardName(String boardIdList, int boardIdListCount) {
		// TODO Auto-generated method stub
		return null;
	}
	
	

}