package egovframework.ezEKP.ezBoard.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.ezEKP.ezBoard.vo.BoardAttachVO;
import egovframework.ezEKP.ezBoard.vo.BoardListHeaderVO;
import egovframework.ezEKP.ezBoard.vo.BoardListVO;
import egovframework.ezEKP.ezBoard.vo.BoardPropertyVO;
import egovframework.ezEKP.ezBoard.vo.BoardConfigVO;
import egovframework.ezEKP.ezBoard.vo.BoardReadVO;
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
	public List<BoardVO> get_apprUserList(Map<String, Object> map) throws Exception{
		return (List<BoardVO>) list("EzBoardDAO.get_apprUserList", map);
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
	public List<BoardAttachVO> brdGetItemAttachmentInfo(String pItemID) throws Exception{
		return (List<BoardAttachVO>) list("EzBoardDAO.brdGetItemAttachmentInfo", pItemID);
	}
	
	@SuppressWarnings("unchecked")
	public List<BoardReadVO> getReaderList(Map<String, Object> map) throws Exception{
		return (List<BoardReadVO>) list("EzBoardDAO.getReaderList", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<BoardListVO> getNoticePostItemAll(String boardID) throws Exception{
		return (List<BoardListVO>) list("EzBoardDAO.getNoticePostItemAll", boardID);
	}
	
	@SuppressWarnings("unchecked")
	public List<BoardListVO> getAdjacentItems1(Map<String, Object> map) throws Exception{
		return (List<BoardListVO>) list("EzBoardDAO.getAdjacentItems1", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<BoardListVO> getAdjacentItems2(Map<String, Object> map) throws Exception{
		return (List<BoardListVO>) list("EzBoardDAO.getAdjacentItems2", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<BoardListVO> getAdjacentItems3(Map<String, Object> map) throws Exception{
		return (List<BoardListVO>) list("EzBoardDAO.getAdjacentItems3", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<BoardListVO> getAdjacentItems2Photo(Map<String, Object> map) throws Exception{
		return (List<BoardListVO>) list("EzBoardDAO.getAdjacentItems2Photo", map);
	}

	@SuppressWarnings("unchecked")
	public List<BoardListVO> getAdjacentItems3Photo(Map<String, Object> map) throws Exception{
		return (List<BoardListVO>) list("EzBoardDAO.getAdjacentItems3Photo", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<BoardAttachVO> photoViewDB(Map<String, Object> map) throws Exception{
		return (List<BoardAttachVO>) list("EzBoardDAO.photoViewDB", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<BoardAttachVO> photoViewDBAll(Map<String, Object> map) throws Exception{
		return (List<BoardAttachVO>) list("EzBoardDAO.photoViewDBAll", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<BoardListVO> getReservedItemList(Map<String, Object> map) throws Exception{
		return (List<BoardListVO>) list("EzBoardDAO.getReservedItemList", map);
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
	public List<HashMap<String, Object>> getQnABoardListItem(Map<String, Object> map) throws Exception{
		return (List<HashMap<String, Object>>) list("EzBoardDAO.getQnABoardListItem", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<HashMap<String, Object>> getNewItemList(Map<String, Object> map) throws Exception{
		return (List<HashMap<String, Object>>) list("EzBoardDAO.getNewItemList", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<HashMap<String, Object>> getSearchBoardItemList(Map<String, Object> map) throws Exception{
		return (List<HashMap<String, Object>>) list("EzBoardDAO.getSearchBoardItemList", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<HashMap<String, Object>> getThumbnailList(Map<String, Object> map) throws Exception{
		return (List<HashMap<String, Object>>) list("EzBoardDAO.getThumbnailList", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<HashMap<String, Object>> getSearchThumbnailList(Map<String, Object> map) throws Exception{
		return (List<HashMap<String, Object>>) list("EzBoardDAO.getSearchThumbnailList", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<HashMap<String, Object>> getMyNoticePostItem(Map<String, Object> map) throws Exception{
		return (List<HashMap<String, Object>>) list("EzBoardDAO.getMyNoticePostItem", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<HashMap<String, Object>> getMyBoardListItem(Map<String, Object> map) throws Exception{
		return (List<HashMap<String, Object>>) list("EzBoardDAO.getMyBoardListItem", map);
	}

	@SuppressWarnings("unchecked")
	public List<HashMap<String, Object>> getMyBoardListItemTemp(Map<String, Object> map) throws Exception{
		return (List<HashMap<String, Object>>) list("EzBoardDAO.getMyBoardListItemTemp", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<HashMap<String, Object>> getSearchMyBoardItemList(Map<String, Object> map) throws Exception{
		return (List<HashMap<String, Object>>) list("EzBoardDAO.getSearchMyBoardItemList", map);
	}

	@SuppressWarnings("unchecked")
	public List<HashMap<String, Object>> getSearchMyBoardItemListTemp(Map<String, Object> map) throws Exception{
		return (List<HashMap<String, Object>>) list("EzBoardDAO.getSearchMyBoardItemListTemp", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<String> getCopyItemAttach(String orgItemID) throws Exception{
		return (List<String>) list("EzBoardDAO.getCopyItemAttach", orgItemID);
	}
	
	public BoardListVO getBrdGetItemInfo(Map<String, Object> map) throws Exception{
		return (BoardListVO) select("EzBoardDAO.getBrdGetItemInfo", map);
	}
	
	public BoardListVO getBrdGetItemInfoTemp(Map<String, Object> map) throws Exception{
		return (BoardListVO) select("EzBoardDAO.getBrdGetItemInfoTemp", map);
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
	
	public BoardListVO getItemInfo(String itemID) {
		return (BoardListVO) select("EzBoardDAO.getItemInfo", itemID);
	}
	
	public BoardListVO getCopyItem(Map<String, Object> map) throws Exception{
		return (BoardListVO) select("EzBoardDAO.getCopyItem", map);
	}
	
	public String get_parentBoardName(Map<String, Object> map) throws Exception{
		return (String) select("EzBoardDAO.get_parentBoardName", map);
	}
	
	public String getParentBoardID(String boardID) throws Exception{
		return (String) select("EzBoardDAO.getParentBoardID", boardID);
	}
	
	public String getDocPassWord(String itemID) throws Exception{
		return (String) select("EzBoardDAO.getDocPassWord", itemID);
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

	public int brdCheckIfHasReply(Map<String, Object> map) throws Exception{
		select("EzBoardDAO.brdCheckIfHasReply", map);
		return (int)map.get("v_pCount");
	}
	
	public int checkBackGroundImage(String boardID) throws Exception{
		return (int) select("EzBoardDAO.checkBackGroundImage", boardID);
	}

	public int getCheckApprUserList(Map<String, Object> map) throws Exception{
		return (int) select("EzBoardDAO.getCheckApprUserList", map);
	}
	
	public int getSearchBoardItemCount(Map<String, Object> map) throws Exception{
		return (int) select("EzBoardDAO.getSearchBoardItemCount", map);
	}
	
	public int getThumbnailItemCount(Map<String, Object> map) throws Exception{
		return (int) select("EzBoardDAO.getThumbnailItemCount", map);
	}
	
	public int checkApprUserList(Map<String, Object> map) throws Exception{
		return (int) select("EzBoardDAO.checkApprUserList", map);
	}
	
	public int getMyBoardTotalItemCount(Map<String, Object> map) throws Exception{
		select("EzBoardDAO.getMyBoardTotalItemCount", map);
		return (int)map.get("v_pCount");
	}

	public int getMyBoardTotalItemCountTemp(Map<String, Object> map) throws Exception{
		select("EzBoardDAO.getMyBoardTotalItemCountTemp", map);
		return (int)map.get("v_pCount");
	}
	
	public int getMyNoticePostItemCount(Map<String, Object> map) {
		select("EzBoardDAO.getMyNoticePostItemCount", map);
		return (int)map.get("v_pCount");
	}
	
	public int getSearchMyBoardItemCount(Map<String, Object> map) throws Exception{
		select("EzBoardDAO.getSearchMyBoardItemCount", map);
		return (int)map.get("v_pCount");
	}

	public int getSearchMyBoardItemCountTemp(Map<String, Object> map) throws Exception{
		select("EzBoardDAO.getSearchMyBoardItemCountTemp", map);
		return (int)map.get("v_pCount");
	}
	
	public int getReservedItemListCount(String userID) throws Exception{
		return (int) select("EzBoardDAO.getReservedItemListCount", userID);
	}
	
	public void photoSaveDB(Map<String, Object> map) throws Exception{
		insert("EzBoardDAO.photoSaveDB", map);
	}
	
	public void brdNewItem(BoardListVO boardListVO) throws Exception{
		insert("EzBoardDAO.brdNewItem", boardListVO);
	}
	
	public void brdNewItemTemp(BoardListVO boardListVO) throws Exception{
		insert("EzBoardDAO.brdNewItemTemp", boardListVO);
	}
	
	public void brdNewItemPhoto(BoardListVO boardListVO) throws Exception{
		insert("EzBoardDAO.brdNewItemPhoto", boardListVO);
	}

	public void brdNewItemTempPhoto(BoardListVO boardListVO) throws Exception{
		insert("EzBoardDAO.brdNewItemTempPhoto", boardListVO);
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
	
	public void photoListInsert(BoardListVO boardListVO) throws Exception{
		insert("EzBoardDAO.photoListInsert", boardListVO);
	}
	
	public void setListOrder(Map<String, Object> map) throws Exception {
		update("EzBoardDAO.set_ListOrder",map);
	}
	
	public void setTabUsed(Map<String, Object> map) throws Exception{
		update("EzBoardDAO.set_TabUsed",map);
	}
	
	public void setNotiOrder(String itemID) throws Exception{
		update("EzBoardDAO.setNotiOrder", itemID);
	}
	
	public void updateCopyItem(String itemID) throws Exception{
		update("EzBoardDAO.updateCopyItem", itemID);
	}
	
	public void updateMoveItem(Map<String, Object> map) throws Exception{
		update("EzBoardDAO.updateMoveItem", map);
	}
	
	public void brdUpdateItem(BoardListVO boardListVO) throws Exception{
		update("EzBoardDAO.brdUpdateItem", boardListVO);
	}
	
	public void photoListUpdate(Map<String, Object> map) throws Exception{
		update("EzBoardDAO.photoListUpdate", map);
	}
	
	public void setBoardList_Config(String pUserID, Map<String, Object> map) throws Exception{
		update("EzBoardDAO.setBoardList_Config", map);
	}
	
	public void setMainImageID(Map<String, Object> map) throws Exception{
		update("EzBoardDAO.setMainImageID", map);
	}

	public void photoListAlbumEdit(Map<String, Object> map) throws Exception{
		update("EzBoardDAO.photoListAlbumEdit", map);
	}
	
	public void photoListAlbumEditTemp(Map<String, Object> map) throws Exception{
		update("EzBoardDAO.photoListAlbumEditTemp", map);
	}
	
	public void setBoardConfig(Map<String, Object> map) throws Exception{
		update("EzBoardDAO.setBoardConfig", map);
	}
	
	public void deleteItem(Map<String, Object> map) throws Exception{
		delete("EzBoardDAO.deleteItem", map);
	}

	public void deleteTempItem(Map<String, Object> map) throws Exception{
		delete("EzBoardDAO.deleteTempItem", map);
	}

	public void photoListDel(Map<String, Object> map) throws Exception{
		delete("EzBoardDAO.photoListDel", map);
	}

	public void deleteTempItem(String strItemID) throws Exception{
		delete("EzBoardDAO.deleteTempItem1", strItemID);
	}

}