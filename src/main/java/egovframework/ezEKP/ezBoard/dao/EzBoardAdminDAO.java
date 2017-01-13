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
	public List<BoardVO> checkApplyUser(int tenantID) throws Exception{
		return (List<BoardVO>) list("EzBoardAdminDAO.checkApplyUser", tenantID);
	}
	
	@SuppressWarnings("unchecked")
	public List<BoardVO> getBoardTree_Get2(Map<String, Object> map) throws Exception{		
		return (List<BoardVO>) list("EzBoardAdminDAO.getBoardTree_Get2", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<BoardTreeVO> brdBoardTree(Map<String, Object> map) throws Exception{		
		return (List<BoardTreeVO>) list("EzBoardAdminDAO.brdBoardTree", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<BoardTreeVO> get_Admin_TopBoardList(Map<String, Object> map) {		
		return (List<BoardTreeVO>) list("EzBoardAdminDAO.get_Admin_TopBoardList", map);
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
	public List<BoardAttributeVO> getBoardHeader_B(Map<String, Object> map) throws Exception{		
		return (List<BoardAttributeVO>) list("EzBoardAdminDAO.getBoardHeader_B", map);		
	}
	
	@SuppressWarnings("unchecked")
	public List<BoardAttributeVO> getBoardAttribute(Map<String, Object> map) throws Exception{
		return (List<BoardAttributeVO>) list("EzBoardAdminDAO.getBoardAttribute", map);
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
		int ret = (int) select("EzBoardAdminDAO.checkIfBoardGroupAdmin", map);
		
		if (ret > 0 ) {
			return "OK";
		} else {
			return "NO";
		}
	}	

	public int checkIfLeafBoard(Map<String, Object> map) throws Exception{		
		return (int) select("EzBoardAdminDAO.checkIfLeafBoard", map);
	}
	
	public int checkForm(Map<String, Object> map) throws Exception{
		return (int) select("EzBoardAdminDAO.checkForm", map);
	}
	
	public void createBoardGroup(Map<String, Object> map) throws Exception{		
		insert("EzBoardAdminDAO.createBoardGroup", map);
	}
	
	public void createBoardGroup2(Map<String, Object> map) throws Exception{		
		insert("EzBoardAdminDAO.createBoardGroup2", map);
	}
	
	public void createBoard_I(Map<String, Object> map) throws Exception{
		insert("EzBoardAdminDAO.createBoard_I", map);
	}
	
	public void createBoard_I2(Map<String, Object> map) throws Exception{
		insert("EzBoardAdminDAO.createBoard_I2", map);
	}
	
	public void createBoard_U(Map<String, Object> map) throws Exception{
		update("EzBoardAdminDAO.createBoard_U", map);
	}
	
	public void saveBoardOrder(Map<String, Object> map) throws Exception{			
		update("EzBoardAdminDAO.saveBoardOrder", map);
	}
	
	public void deleteBoard(Map<String, Object> map) throws Exception{		
		delete("EzBoardAdminDAO.deleteBoard", map);
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

	public void saveACL_I(Map<String, Object> map) throws Exception{
		insert("EzBoardAdminDAO.saveACL_I", map);
	}
	
	public void saveACL_U(Map<String, Object> map) throws Exception{
		update("EzBoardAdminDAO.saveACL_U", map);
	}
	
	public void setUnderBoardIDAcl_U(Map<String, Object> map) throws Exception{
		update("EzBoardAdminDAO.setUnderBoardIDAcl_U", map);		
	}
	
	public void setUnderBoardIDAcl_I(Map<String, Object> map) throws Exception{
		insert("EzBoardAdminDAO.setUnderBoardIDAcl_I", map);		
	}

	public void setUnderBoardIDAcl2(Map<String, Object> map) throws Exception{
		insert("EzBoardAdminDAO.setUnderBoardIDAcl2", map);
	}

	public void copyBoardAcl(Map<String, Object> map) throws Exception{
		insert("EzBoardAdminDAO.copyBoardAcl", map);		
	}
	
	public void saveBoardProperty_appr_D(Map<String, Object> map) throws Exception{
		delete("EzBoardAdminDAO.saveBoardProperty_appr_D", map);		
	}
	
	public void saveBoardProperty_appr_I(Map<String, Object> map) throws Exception{
		insert("EzBoardAdminDAO.saveBoardProperty_appr_I", map);		
	}
	
	public void apprProperty_info(Map<String, Object> map) throws Exception{
		insert("EzBoardAdminDAO.apprProperty_info", map);	
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
	
	public void saveBackGroundImage_I(Map<String, Object> map) throws Exception{		
		update("EzBoardAdminDAO.saveBackGroundImage_I", map);
	}
	
	public void saveBackGroundImage_U(Map<String, Object> map) throws Exception{		
		update("EzBoardAdminDAO.saveBackGroundImage_U", map);
	}
	
	public void moveBoard(Map<String, Object> map) throws Exception{		
		update("EzBoardAdminDAO.moveBoard", map);
	}
	
	public void moveBoard2(Map<String, Object> map) throws Exception{		
		update("EzBoardAdminDAO.moveBoard2", map);
	}
	
	public void saveBoardProperty(Map<String, Object> map) throws Exception{		
		update("EzBoardAdminDAO.saveBoardProperty", map);
	}
	
	public void saveBoardProperty2(Map<String, Object> map) throws Exception{		
		update("EzBoardAdminDAO.saveBoardProperty2", map);
	}
	
	public void updateAttribute(BoardAttributeVO boardAttributeVO) throws Exception{		
		update("EzBoardAdminDAO.updateAttribute", boardAttributeVO);
	}

	public void setBoardForm(Map<String, Object> map) throws Exception{
		update("EzBoardAdminDAO.setBoardForm", map);
	}
	
	public void deleteAttribute(Map<String, Object> map) throws Exception{		
		delete("EzBoardAdminDAO.deleteAttribute", map);
	}	
	
	public void deleteBackGroundImage(BoardBackgroundVO boardBackgroundVO) throws Exception{		
		delete("EzBoardAdminDAO.deleteBackGroundImage", boardBackgroundVO);
	}

	public void deleteHeader(Map<String, Object> map) throws Exception{
		delete("EzBoardAdminDAO.deleteHeader", map);
	}

	public void deleteACL(Map<String, Object> map) throws Exception{
		delete("EzBoardAdminDAO.deleteACL", map);		
	}
	public void trunkBoard(int tenantID) throws Exception{
		delete("EzBoardAdminDAO.trunkBoard", tenantID);
	}

	public void getBoardTree_Set_D(Map<String, Object> map) throws Exception{
		delete("EzBoardAdminDAO.getBoardTree_Set_D", map);
	}

	public void deleteTreeCache(Map<String, Object> map) throws Exception{
		delete("EzBoardAdminDAO.deleteTreeCache", map);
	}

	public void setMyBoardTreeConfig_N(BoardMyFavoriteVO boardMyFavoriteVO) throws Exception{
		insert("EzBoardAdminDAO.setMyBoardTreeConfig_N", boardMyFavoriteVO);
	}

	public void setMyBoardTreeConfig_M(BoardMyFavoriteVO boardMyFavoriteVO) throws Exception{
		update("EzBoardAdminDAO.setMyBoardTreeConfig_M", boardMyFavoriteVO);
	}

	public void setMyBoardTreeConfig_D(BoardMyFavoriteVO boardMyFavoriteVO) throws Exception{
		delete("EzBoardAdminDAO.setMyBoardTreeConfig_D", boardMyFavoriteVO);
	}

	public String getParentBoardID(Map<String, Object> map) throws Exception{
		return (String) select("EzBoardAdminDAO.getParentBoardID", map);
	}

	public String getBoardID(Map<String, Object> map) throws Exception{
		return (String) select("EzBoardAdminDAO.getBoardID", map);
	}

	public void deleteBoardManage(Map<String, Object> map) throws Exception{
		delete("EzBoardAdminDAO.deleteBoardManage", map);
	}

	public void deleteBoardInfo(Map<String, Object> map) throws Exception{
		delete("EzBoardAdminDAO.deleteBoardInfo", map);
	}

	public void deleteBoardMyBoard(Map<String, Object> map) throws Exception{
		delete("EzBoardAdminDAO.deleteBoardMyBoard", map);
	}

	public void insertDeleteReservedBoard(Map<String, Object> map) throws Exception{
		insert("EzBoardAdminDAO.insertDeleteReservedBoard", map);
	}

	public String getBoardItemListOptionBoard(Map<String, Object> map) throws Exception{
		return (String) select("EzBoardAdminDAO.getBoardItemListOptionBoard", map);
	}

	public int getBoardManage(Map<String, Object> map) throws Exception{
		return (int) select("EzBoardAdminDAO.getBoardManage", map);
	}

}
