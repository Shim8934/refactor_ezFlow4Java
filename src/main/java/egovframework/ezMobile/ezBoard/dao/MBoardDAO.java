package egovframework.ezMobile.ezBoard.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.ezMobile.ezBoard.vo.MBoardAttachVO;
import egovframework.ezMobile.ezBoard.vo.MBoardFavoriteVO;
import egovframework.ezMobile.ezBoard.vo.MBoardInfoVO;
import egovframework.ezMobile.ezBoard.vo.MBoardItemVO;
import egovframework.ezMobile.ezBoard.vo.MBoardListHeaderVO;
import egovframework.ezMobile.ezBoard.vo.MBoardNewListVO;
import egovframework.ezMobile.ezBoard.vo.MBoardTreeVO;
import egovframework.rte.psl.dataaccess.EgovAbstractDAO;

@Repository("MBoardDAO")
public class MBoardDAO extends EgovAbstractDAO {
	@SuppressWarnings("unchecked")
	public List<MBoardListHeaderVO> getListHeader(Map<String, Object> map) throws Exception {
		return (List<MBoardListHeaderVO>) list("MBoardDAO.getListHeader", map);
	}

	@SuppressWarnings("unchecked")
	public List<MBoardItemVO> getBoardItemList(Map<String, Object> map) throws Exception {
		return (List<MBoardItemVO>) list("MBoardDAO.getBoardItemList", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<MBoardNewListVO> getNewItemList(Map<String, Object> map) throws Exception {
		return (List<MBoardNewListVO>) list("MBoardDAO.getNewItemList", map);
	}

	@SuppressWarnings("unchecked")
	public List<MBoardItemVO> getNoticePostItemList(Map<String, Object> map) throws Exception {
		return (List<MBoardItemVO>) list("MBoardDAO.getNoticePostItemList", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<MBoardFavoriteVO> getFavoriteList(Map<String, Object> map) throws Exception{
		return (List<MBoardFavoriteVO>) list("MBoardDAO.getFavoriteList", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<MBoardTreeVO> brdBoardTree(Map<String, Object> map) throws Exception{		
		return (List<MBoardTreeVO>) list("MBoardDAO.brdBoardTree", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<MBoardInfoVO> getBoardTreeGet2(Map<String, Object> map) throws Exception{		
		return (List<MBoardInfoVO>) list("MBoardDAO.getBoardTreeGet2", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<MBoardAttachVO> getAttachList(Map<String, Object> map) throws Exception{		
		return (List<MBoardAttachVO>) list("MBoardDAO.getAttachList", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<MBoardAttachVO> photoViewDB(Map<String, Object> map) throws Exception{		
		return (List<MBoardAttachVO>) list("MBoardDAO.photoViewDB", map);
	}
	
	public MBoardItemVO getBrdItemInfo(Map<String, Object> map) throws Exception {
		return (MBoardItemVO) select("MBoardDAO.getBrdItemInfo", map);
	}

	public MBoardInfoVO getBoardProperty(Map<String, Object> map) throws Exception {
		return (MBoardInfoVO) select("MBoardDAO.getBoardProperty", map);
	}

	public MBoardInfoVO getACL(Map<String, Object> map) throws Exception {
		return (MBoardInfoVO) select("MBoardDAO.getACL", map);
	}

	public String getBoardApprFlag(Map<String, Object> map) throws Exception {
		return (String) select("MBoardDAO.getBoardApprFlag", map);
	}
	
	public String checkIfBoardGroupAdmin(Map<String, Object> map) throws Exception{
		int ret = (int) select("EzBoardAdminDAO.checkIfBoardGroupAdmin", map);
		
		if (ret > 0 ) {
			return "OK";
		} else {
			return "NO";
		}
	}
	
	public String checkFavorite(Map<String, Object> map) throws Exception{
		int ret = (int) select("MBoardDAO.checkFavorite", map);
		
		if (ret > 0 ) {
			return "OK";
		} else {
			return "NO";
		}
	}
	
	public String getDeptPathCode(Map<String, Object> map) throws Exception{
		return (String) select("MBoardDAO.getDeptPathCode", map);
	}
	
	public String getBoardItemRead(Map<String, Object> map) throws Exception{
		return (String) select("MBoardDAO.getBoardItemRead", map);
	}

	public String getWriterID(Map<String, Object> map) throws Exception{
		return (String) select("MBoardDAO.getWriterID", map);
	}

	public Integer getBoardItemListCount(Map<String, Object> map) throws Exception {
		return (Integer) select("MBoardDAO.getBoardItemListCount", map);
	}

	public Integer getNoticePostItemListCount(Map<String, Object> map) throws Exception {
		return (Integer) select("MBoardDAO.getNoticePostItemListCount", map);
	}
	
	public Integer getNewBoardListCount(Map<String, Object> map) throws Exception {
		return (Integer) select("MBoardDAO.getNewBoardListCount", map);
	}
	
	public Integer photoViewDBCount(Map<String, Object> map) throws Exception {
		return (Integer) select("MBoardDAO.photoViewDBCount", map);
	}
	
	public void insertBrdItem(Map<String, Object> map) throws Exception{
		insert("MBoardDAO.insertBrdItem", map);
	}
	
	public void insertBrdItem2(Map<String, Object> map) throws Exception{
		insert("MBoardDAO.insertBrdItem2", map);
	}
	
	public void insertFavorite(Map<String, Object> map) throws Exception{
		insert("MBoardDAO.insertFavorite", map);
	}
	
	public void setAsRead(Map<String, Object> map) throws Exception{
		insert("MBoardDAO.setAsRead", map);
	}
	
	public void saveAttachInfo(Map<String, Object> map) throws Exception{
		insert("MBoardDAO.saveAttachInfo", map);
	}
	
	public void setAsRead2(Map<String, Object> map) throws Exception{
		update("MBoardDAO.setAsRead2", map);
	}
	
	public void updateItem(Map<String, Object> map) throws Exception{
		update("MBoardDAO.updateItem", map);
	}
	
	public void deleteBoardItem(Map<String, Object> map) throws Exception{
		delete("MBoardDAO.deleteBoardItem", map);
	}
	
	public void deleteBoardReply(Map<String, Object> map) throws Exception{
		delete("MBoardDAO.deleteBoardReply", map);
	}
	
	public void deleteBoardItemRead2(Map<String, Object> map) throws Exception{
		delete("MBoardDAO.deleteBoardItemRead2", map);
	}
	
	public void insertDeleteReservedItem(Map<String, Object> map) throws Exception{
		delete("MBoardDAO.insertDeleteReservedItem", map);
	}
	
	public void deleteFavorite(Map<String, Object> map) throws Exception{
		delete("MBoardDAO.deleteFavorite", map);
	}
	
}
