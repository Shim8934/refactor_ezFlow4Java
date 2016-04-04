package egovframework.ezEKP.ezBoard.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.ezEKP.ezBoard.vo.BoardAttributeVO;
import egovframework.ezEKP.ezBoard.vo.BoardBackgroundVO;
import egovframework.ezEKP.ezBoard.vo.BoardListHeaderVO;
import egovframework.ezEKP.ezBoard.vo.BoardPropertyVO;
import egovframework.ezEKP.ezBoard.vo.BoardTreeVO;
import egovframework.ezEKP.ezBoard.vo.BoardVO;
import egovframework.ezEKP.ezBoard.vo.BoardMyFavoriteVO;
import egovframework.rte.psl.dataaccess.EgovAbstractDAO;

@Repository("EzBoardAdminDAO")
public class EzBoardAdminDAO extends EgovAbstractDAO {	
		
	@SuppressWarnings("unchecked")
	public List<BoardVO> checkApplyUser() throws Exception{
		return (List<BoardVO>) list("EzBoardAdminDAO.checkApplyUser");
	}
	
	@SuppressWarnings("unchecked")
	public List<BoardVO> getBoardTree_Get2(Map<String, Object> map) throws Exception{		
		return (List<BoardVO>) list("EzBoardAdminDAO.getBoardTree_Get2",	map);
	}
	
	@SuppressWarnings("unchecked")
	public List<BoardTreeVO> brdBoardTree(Map<String, Object> map) throws Exception{		
		return (List<BoardTreeVO>) list("EzBoardAdminDAO.brdBoardTree", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<BoardTreeVO> get_Admin_TopBoardList(String parentBoardID) {		
		return (List<BoardTreeVO>) list("EzBoardAdminDAO.get_Admin_TopBoardList", parentBoardID);
	}
	
	@SuppressWarnings("unchecked")
	public List<BoardMyFavoriteVO> getMyBoardTree_get3(Map<String, Object> map) throws Exception{		
		return (List<BoardMyFavoriteVO>) list("EzBoardAdminDAO.getMyBoardTree_get3", map);
	}	
	
	@SuppressWarnings("unchecked")
	public List<BoardBackgroundVO> getBackGroundImage(BoardBackgroundVO boardBackgroundVO) {		
		return (List<BoardBackgroundVO>) list("EzBoardAdminDAO.getBackGroundImage", boardBackgroundVO);
	}	

	@SuppressWarnings("unchecked")
	public List<BoardAttributeVO> getBoardHeader(Map<String, Object> map) throws Exception{		
		return (List<BoardAttributeVO>) list("EzBoardAdminDAO.getBoardHeader", map);		
	}
	
	@SuppressWarnings("unchecked")
	public List<BoardAttributeVO> getBoardAttribute(String boardID) throws Exception{
		return (List<BoardAttributeVO>) list("EzBoardAdminDAO.getBoardAttribute", boardID);
	}
	
	@SuppressWarnings("unchecked")
	public List<BoardPropertyVO> getBoardAccessList(Map<String, Object> map) throws Exception{
		return (List<BoardPropertyVO>) list("EzBoardAdminDAO.getBoardAccessList", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<BoardPropertyVO> getUnderBoardID(Map<String, Object> map) throws Exception{
		return (List<BoardPropertyVO>) list("EzBoardAdminDAO.getUnderBoardID", map);
	}
	
	public BoardPropertyVO getACL(Map<String, Object> map) throws Exception{		
		return (BoardPropertyVO) select("EzBoardAdminDAO.getACL", map);
	}
	
	public String getBoardTree_Get1(Map<String, Object> map) throws Exception{		
		return (String) select("EzBoardAdminDAO.getBoardTree_Get1", map);
	}

	public String checkIfBoardGroupAdmin(Map<String, Object> map) throws Exception{
		select("EzBoardAdminDAO.checkIfBoardGroupAdmin", map);
		
		int ret = (int) map.get("v_pCount");
		
		if(ret > 0 ){
			return "OK";
		}else{
			return "NO";
		}
	}	

	public int checkIfLeafBoard(Map<String, Object> map) throws Exception{		
		return (int) select("EzBoardAdminDAO.checkIfLeafBoard", map);
	}
	
	public void createBoardGroup(Map<String, Object> map) throws Exception{		
		select("EzBoardAdminDAO.createBoardGroup", map);
	}
	
	public void createBoard(Map<String, Object> map) throws Exception{
		select("EzBoardAdminDAO.createBoard", map);
	}
	
	public void saveBoardOrder(Map<String, Object> map) throws Exception{			
		select("EzBoardAdminDAO.saveBoardOrder", map);
	}
	
	public void deleteBoard(Map<String, Object> map) throws Exception{		
		select("EzBoardAdminDAO.deleteBoard", map);
	}
	
	public void addMyBoards(Map<String, Object> map) {
		insert("EzBoardAdminDAO.addMyBoards", map);
	}
	
	public void saveAttribute(BoardAttributeVO boardAttributeVO) throws Exception{		
		insert("EzBoardAdminDAO.saveAttribute", boardAttributeVO);
	}

	public void saveHeader(BoardListHeaderVO boardListHeaderVO) throws Exception{
		insert("EzBoardAdminDAO.saveHeader", boardListHeaderVO);
	}

	public void saveACL(Map<String, Object> map) throws Exception{
		insert("EzBoardAdminDAO.saveACL", map);
	}
	
	public void setUnderBoardIDAcl(Map<String, Object> map) throws Exception{
		insert("EzBoardAdminDAO.setUnderBoardIDAcl", map);		
	}

	public void setUnderBoardIDAcl2(Map<String, Object> map) throws Exception{
		insert("EzBoardAdminDAO.setUnderBoardIDAcl2", map);
	}

	public void copyBoardAcl(Map<String, Object> map) throws Exception{
		insert("EzBoardAdminDAO.copyBoardAcl", map);		
	}
	
	public void saveBoardProperty_appr(Map<String, Object> map) throws Exception{
		insert("EzBoardAdminDAO.saveBoardProperty_appr", map);		
	}
	
	public void apprProperty_info(Map<String, Object> map) throws Exception{
		insert("EzBoardAdminDAO.apprProperty_info", map);	
	}

	public void saveBoardProperty_port(Map<String, Object> map) throws Exception{		
		insert("EzBoardAdminDAO.trunkBoard", map);
	}
	
	public void setMyBoardTreeConfig(BoardMyFavoriteVO boardMyFavoriteVO) throws Exception{
		update("EzBoardAdminDAO.setMyBoardTreeConfig", boardMyFavoriteVO);
	}
	
	public void setMyBoardTreeMoveCopy(BoardMyFavoriteVO boardMyFavoriteVO) throws Exception{
		update("EzBoardAdminDAO.setMyBoardTreeMoveCopy", boardMyFavoriteVO);
	}

	public void getBoardTree_Set(Map<String, Object> map) throws Exception{		
		update("EzBoardAdminDAO.getBoardTree_Set", map);
	}		
	
	public void statusChangeBackGroundImage(BoardBackgroundVO boardBackgroundVO) throws Exception{	
		update("EzBoardAdminDAO.statusChangeBackGroundImage", boardBackgroundVO);
	}
	
	public void saveBackGroundImage(Map<String, Object> map) throws Exception{		
		update("EzBoardAdminDAO.saveBackGroundImage", map);
	}
	
	public void moveBoard(Map<String, Object> map) throws Exception{		
		update("EzBoardAdminDAO.moveBoard", map);
	}
	
	public void saveBoardProperty(Map<String, Object> map) throws Exception{		
		update("EzBoardAdminDAO.saveBoardProperty", map);
	}
	
	public void updateAttribute(BoardAttributeVO boardAttributeVO) throws Exception{		
		update("EzBoardAdminDAO.updateAttribute", boardAttributeVO);
	}
	
	public void deleteAttribute(String boardID) throws Exception{		
		delete("EzBoardAdminDAO.deleteAttribute", boardID);
	}	
	
	public void deleteBackGroundImage(BoardBackgroundVO boardBackgroundVO) throws Exception{		
		delete("EzBoardAdminDAO.deleteBackGroundImage", boardBackgroundVO);
	}

	public void deleteHeader(String boardID) throws Exception{
		delete("EzBoardAdminDAO.deleteHeader", boardID);
	}

	public void deleteACL(Map<String, Object> map) throws Exception{
		delete("EzBoardAdminDAO.deleteACL", map);		
	}
	public void trunkBoard() throws Exception{
		delete("EzBoardAdminDAO.trunkBoard", "");
	}

	


}
