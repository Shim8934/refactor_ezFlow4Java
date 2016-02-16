package egovframework.ezEKP.ezBoard.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.ezEKP.ezBoard.vo.BoardTreeVO;
import egovframework.ezEKP.ezBoard.vo.EzBoardVO;
import egovframework.ezEKP.ezBoard.vo.MyFavoriteVO;
import egovframework.rte.psl.dataaccess.EgovAbstractDAO;

@Repository("EzBoardAdminDAO")
public class EzBoardAdminDAO extends EgovAbstractDAO {

	Map<String, Object> map = new HashMap<String, Object>();
	
	public String checkIfBoardGroupAdmin(String pRootBoardID, String pUserID, String pDeptID, String pCompanyID) throws Exception{
		map.put("v_pBoardID", pRootBoardID);
		map.put("v_pUserID", pUserID);
		map.put("v_pDeptID", pDeptID);
		map.put("v_pCompanyID", pCompanyID);
		
		int ret = (int) select("EzBoardAdminDAO.checkIfBoardGroupAdmin", map);
		if(ret > 0 ){
			return "OK";
		}else{
			return "NO";
		}
	}
	
	@SuppressWarnings("unchecked")
	public List<EzBoardVO> checkApplyUser() throws Exception{
		return (List<EzBoardVO>) list("EzBoardAdminDAO.checkApplyUser");
	}
	
	public String getBoardTree_Get1(String pStrLang, String pQuery) throws Exception{
		map.put("v_STRLANG", pStrLang);
		map.put("v_PQUERY", pQuery);
		return (String) select("EzBoardAdminDAO.getBoardTree_Get1", map);
	}
	public String getDeptFullPath(String pDeptID,String string) throws Exception{
		map.put("v_CN", pDeptID);
		return (String) select("EzBoardAdminDAO.getDeptFullPath", map);
	}

	@SuppressWarnings("unchecked")
	public List<EzBoardVO> getBoardTree_Get2(String trim, String pRootBoardID) throws Exception{
		map.put("v_PACCESSID", trim);
		map.put("v_PROOTBOARDID", pRootBoardID);
		return (List<EzBoardVO>) list("EzBoardAdminDAO.getBoardTree_Get2",	map);
	}

	@SuppressWarnings("unchecked")
	public List<BoardTreeVO> brdBoardTree(String pRootBoardID, String trim, int pMode, int pSelectBy, String pExcludeBoardID) throws Exception{
		map.put("v_pRootBoardID", pRootBoardID);
		map.put("v_pUserID", trim);
		map.put("v_pDeptID", "");
		map.put("v_pCompanyID","");
		map.put("v_pMode", pMode);
		map.put("v_pSelectBy", pSelectBy);
		map.put("v_pExcludeBoardID", pExcludeBoardID);
		return (List<BoardTreeVO>) list("EzBoardAdminDAO.brdBoardTree", map);
	}

	public int checkIfLeafBoard(String pBoardID) throws Exception{
		map.put("v_PBOARDID", pBoardID);
		return (int) select("EzBoardAdminDAO.checkIfLeafBoard", map);
	}

	public void getBoardTree_Set(String trim, String string, String string2) throws Exception{
		map.put("v_STRLANG", trim);
		map.put("v_PQUERY", string);
		map.put("v_RESULT", string2);
		//DB에 XML형식이 박혀서 사용되는데 어떻게 해야될지 모르겠음
//		update("EzBoardAdminDAO.getBoardTree_Set", map);
	}

	public List<MyFavoriteVO> getMyBoardTree_get3(String userID, String pRootTreeID) {
		// TODO Auto-generated method stub
		return null;
	}
	@SuppressWarnings("unchecked")
	public List<BoardTreeVO> get_Admin_TopBoardList(String parentBoardID) {
		// TODO Auto-generated method stub
		return (List<BoardTreeVO>) list("EzBoardAdminDAO.get_Admin_TopBoardList", parentBoardID);
	}
	
	

}
