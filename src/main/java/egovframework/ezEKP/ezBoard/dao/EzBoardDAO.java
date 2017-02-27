package egovframework.ezEKP.ezBoard.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.ezEKP.ezBoard.vo.BoardAccessVO;
import egovframework.ezEKP.ezBoard.vo.BoardAttachVO;
import egovframework.ezEKP.ezBoard.vo.BoardConfigVO;
import egovframework.ezEKP.ezBoard.vo.BoardDeleteItemVO;
import egovframework.ezEKP.ezBoard.vo.BoardLineReplyVO;
import egovframework.ezEKP.ezBoard.vo.BoardListHeaderVO;
import egovframework.ezEKP.ezBoard.vo.BoardListVO;
import egovframework.ezEKP.ezBoard.vo.BoardMyFavoriteVO;
import egovframework.ezEKP.ezBoard.vo.BoardPropertyVO;
import egovframework.ezEKP.ezBoard.vo.BoardReadVO;
import egovframework.ezEKP.ezBoard.vo.BoardVO;
import egovframework.let.user.login.vo.LoginVO;
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
	public List<BoardAttachVO> brdGetItemAttachmentInfo(Map<String, Object> map) throws Exception{
		return (List<BoardAttachVO>) list("EzBoardDAO.brdGetItemAttachmentInfo", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<BoardReadVO> getReaderList(Map<String, Object> map) throws Exception{
		return (List<BoardReadVO>) list("EzBoardDAO.getReaderList", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<BoardListVO> getNoticePostItemAll(Map<String, Object> map) throws Exception{
		return (List<BoardListVO>) list("EzBoardDAO.getNoticePostItemAll", map);
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
	public List<BoardLineReplyVO> readOneLineReply(Map<String, Object> map) throws Exception{
		return (List<BoardLineReplyVO>) list("EzBoardDAO.readOneLineReply", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<BoardAccessVO> getPostNotiMailUserList(Map<String, Object> map) throws Exception{
		return (List<BoardAccessVO>) list("EzBoardDAO.getPostNotiMailUserList", map);
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
	public List<HashMap<String, Object>> getApprBoardListItem(Map<String, Object> map) throws Exception{
		return (List<HashMap<String, Object>>) list("EzBoardDAO.getApprBoardListItem", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<String> getCopyItemAttach(Map<String, Object> map) throws Exception{
		return (List<String>) list("EzBoardDAO.getCopyItemAttach", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<BoardListVO> getUnreadItems(Map<String, Object> map) throws Exception {
		return (List<BoardListVO>) list("EzBoardDAO.getUnreadItems", map);
	}
	
	public BoardListVO getBrdGetItemInfo(Map<String, Object> map) throws Exception{
		return (BoardListVO) select("EzBoardDAO.getBrdGetItemInfo", map);
	}
	
	public BoardListVO getBrdGetItemInfoTemp(Map<String, Object> map) throws Exception{
		return (BoardListVO) select("EzBoardDAO.getBrdGetItemInfoTemp", map);
	}

	public BoardConfigVO getPersonalCount(LoginVO userInfo) throws Exception{
		return (BoardConfigVO) select("EzBoardDAO.getPersonalCount", userInfo);
	}
	
	public BoardConfigVO getBoardList_Config(Map<String, Object> map) throws Exception{
		return (BoardConfigVO) select("EzBoardDAO.getBoardList_Config", map);
	}

	public BoardPropertyVO getBoardProperty(Map<String, Object> map) throws Exception{
		return (BoardPropertyVO) select("EzBoardDAO.getBoardProperty", map);
	}
	
	public BoardListVO getItemInfo(Map<String, Object> map) {
		return (BoardListVO) select("EzBoardDAO.getItemInfo", map);
	}
	
	public BoardListVO getCopyItem(Map<String, Object> map) throws Exception{
		return (BoardListVO) select("EzBoardDAO.getCopyItem", map);
	}
	
	public String get_parentBoardName(Map<String, Object> map) throws Exception{
		return (String) select("EzBoardDAO.get_parentBoardName", map);
	}
	
	public String getParentBoardID(Map<String, Object> map) throws Exception{
		return (String) select("EzBoardDAO.getParentBoardID", map);
	}
	
	public String getDocPassWord(Map<String, Object> map) throws Exception{
		return (String) select("EzBoardDAO.getDocPassWord", map);
	}
	
	public void deleteOneLineReply(Map<String, Object> map) {
		delete("EzBoardDAO.deleteOneLineReply", map);
	}
	
	public String portalPageItemEdit(Map<String, Object> map) {
		return (String) select("EzBoardDAO.portalPageItemEdit", map);
	}
	
	public String getBoardGroupID(Map<String, Object> map) throws Exception{
		return (String) select("EzBoardDAO.getBoardGroupID", map);
	}
	
	public String getBoardName(Map<String, Object> map) throws Exception{
		return (String) select("EzBoardDAO.getBoardName", map);
	}
	
	public String getBoardApprList(BoardMyFavoriteVO myFavoriteVO) throws Exception{
		return (String) select("EzBoardDAO.getBoardApprList", myFavoriteVO);
	}
	
	public BoardMyFavoriteVO getBoardNewBoardOrder(Map<String, Object> map) throws Exception{
		return (BoardMyFavoriteVO) select("EzBoardDAO.getBoardNewBoardOrder", map);
	}
	
	public String getBoardConfig(Map<String, Object> map) throws Exception{
		return (String) select("EzBoardDAO.getBoardConfig", map);
	}
	
	public String getBoardApprJoinItem(BoardMyFavoriteVO myFavoriteVO) throws Exception{
		return (String) select("EzBoardDAO.getBoardApprJoinItem", myFavoriteVO);
	}
	
	public String getListOptionBoardID(Map<String, Object> map) throws Exception{
		return (String) select("EzBoardDAO.getListOptionBoardID", map);
	}
	
	public String getBoardApprListUser(Map<String, Object> map) throws Exception{
		return (String) select("EzBoardDAO.getBoardApprListUser", map);
	}
	
	public int getBrdNewItemCount(Map<String, Object> map) throws Exception{
		return (int) select("EzBoardDAO.getBrdNewItemCount",map);
	}

	public int getThumbNailCount(BoardMyFavoriteVO myFavoriteVO) throws Exception{
		return (int) select("EzBoardDAO.getThumbNailCount",myFavoriteVO);
	}
	
	public int getThumbNailCount2(BoardMyFavoriteVO myFavoriteVO) throws Exception{
		return (int) select("EzBoardDAO.getThumbNailCount2",myFavoriteVO);
	}

	public int getBrdTotalItemCount(BoardMyFavoriteVO myFavoriteVO) throws Exception{
		return (int) select("EzBoardDAO.getBrdTotalItemCount",myFavoriteVO);
	}
	
	public int getBrdTotalItemCount2(BoardMyFavoriteVO myFavoriteVO) throws Exception{
		return (int) select("EzBoardDAO.getBrdTotalItemCount2",myFavoriteVO);
	}

	public int getQNABrdTotalItemCount(Map<String, Object> map) throws Exception{
		return (int) select("EzBoardDAO.getQNABrdTotalItemCount",map);
	}
	
	public int getNewItemListCount(Map<String, Object> map) throws Exception{
		return (int) select("EzBoardDAO.getNewItemListCount", map);
	}
	
	public int getNoticePostItemCount(BoardVO boardVO) throws Exception{
		return (int) select("EzBoardDAO.getNoticePostItemCount", boardVO);
	}

	public int getBoardTotalItemCount(Map<String, Object> map) throws Exception{
		return (int) select("EzBoardDAO.getBoardTotalItemCount", map);
	}

	public int getCheckItemID(Map<String, Object> map) throws Exception{
		return (int) select("EzBoardDAO.getCheckItemID", map);
	}
	
	public int checkForm(Map<String, Object> map) throws Exception{
		return (int) select("EzBoardDAO.checkForm", map);
	}

	public int brdCheckIfHasReply(Map<String, Object> map) throws Exception{
		return (int) select("EzBoardDAO.brdCheckIfHasReply", map);
	}
	
	public int checkBackGroundImage(Map<String, Object> map) throws Exception{
		return (int) select("EzBoardDAO.checkBackGroundImage", map);
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
		return (int) select("EzBoardDAO.getMyBoardTotalItemCount", map);
	}

	public int getMyBoardTotalItemCountTemp(Map<String, Object> map) throws Exception{
		return (int) select("EzBoardDAO.getMyBoardTotalItemCountTemp", map);
	}
	
	public int getMyNoticePostItemCount(Map<String, Object> map) {
		return (int) select("EzBoardDAO.getMyNoticePostItemCount", map);
	}
	
	public int getSearchMyBoardItemCount(Map<String, Object> map) throws Exception{
		return (int) select("EzBoardDAO.getSearchMyBoardItemCount", map);
	}

	public int getSearchMyBoardItemCountTemp(Map<String, Object> map) throws Exception{
		return (int) select("EzBoardDAO.getSearchMyBoardItemCountTemp", map);
	}
	
	public int checkOneLineOwner(Map<String, Object> map) throws Exception{
		return (int) select("EzBoardDAO.checkOneLineOwner", map);
	}
	
	public int getReservedItemListCount(Map<String, Object> map) throws Exception{
		return (int) select("EzBoardDAO.getReservedItemListCount", map);
	}
	
	public int getItemViewNew(Map<String, Object> map) throws Exception{
		return (int) select("EzBoardDAO.getItemViewNew", map);
	}
	
	public int getApprBoardTotalItemCount(Map<String, Object> map) throws Exception{
		return (int) select("EzBoardDAO.getApprBoardTotalItemCount", map);
	}
	
	public int getUnreadItemsCount(Map<String, Object> map) throws Exception{
		return (int) select("EzBoardDAO.boardListPortal", map);
	}
	
	public void photoSaveDB(Map<String, Object> map) throws Exception{
		insert("EzBoardDAO.photoSaveDB", map);
	}
	
	public void brdNewItem(BoardListVO boardListVO) throws Exception{
		insert("EzBoardDAO.brdNewItem", boardListVO);
	}
	
	public void brdNewItem2(BoardListVO boardListVO) throws Exception{
		insert("EzBoardDAO.brdNewItem2", boardListVO);
	}
	
	public void brdNewItemTemp(BoardListVO boardListVO) throws Exception{
		insert("EzBoardDAO.brdNewItemTemp", boardListVO);
	}
	
	public void brdNewItemPhoto(BoardListVO boardListVO) throws Exception{
		insert("EzBoardDAO.brdNewItemPhoto", boardListVO);
	}
	
	public void brdNewItemPhoto2(BoardListVO boardListVO) throws Exception{
		insert("EzBoardDAO.brdNewItemPhoto2", boardListVO);
	}

	public void brdNewItemTempPhoto(BoardListVO boardListVO) throws Exception{
		insert("EzBoardDAO.brdNewItemTempPhoto", boardListVO);
	}
	
	public void newItem(BoardListVO boardListVO) throws Exception{
		insert("EzBoardDAO.newItem", boardListVO);
	}
	
	public void setAsRead(Map<String, Object> map) throws Exception{
		insert("EzBoardDAO.setAsRead", map);
	}
	
	public void saveAttachInfo(Map<String, Object> map) throws Exception{
		insert("EzBoardDAO.saveAttachInfo", map);
	}
	
	public void saveOneLineReply(Map<String, Object> map) throws Exception{
		insert("EzBoardDAO.saveOneLineReply", map);
	}
	
	public void photoListInsert(BoardListVO boardListVO) throws Exception{
		insert("EzBoardDAO.photoListInsert", boardListVO);
	}
	
	public void insertBoardNewBoardOrder(Map<String, Object> map) throws Exception{
		insert("EzBoardDAO.insertBoardNewBoardOrder", map);
	}
	
	public void setBoardList_Config_I(BoardConfigVO boardConfigVO) throws Exception{
		insert("EzBoardDAO.setBoardList_Config_I", boardConfigVO);
	}
	
	public void setBoardConfig2(Map<String, Object> map) throws Exception{
		insert("EzBoardDAO.setBoardConfig2", map);
	}
	
	public void setListOrder_U(Map<String, Object> map) throws Exception {
		update("EzBoardDAO.set_ListOrder_U",map);
	}
	
	public void setListOrder(Map<String, Object> map) throws Exception {
		update("EzBoardDAO.set_ListOrder",map);
	}
	
	public void setListOrder_D(Map<String, Object> map) throws Exception {
		delete("EzBoardDAO.set_ListOrder_D",map);
	}
	
	public void setTabUsed(Map<String, Object> map) throws Exception{
		update("EzBoardDAO.set_TabUsed",map);
	}
	
	public void setTabUsed2(Map<String, Object> map) throws Exception{
		update("EzBoardDAO.set_TabUsed2",map);
	}
	
	public void setNotiOrder(Map<String, Object> map) throws Exception{
		update("EzBoardDAO.setNotiOrder", map);
	}
	
	public void updateCopyItem(Map<String, Object> map) throws Exception{
		update("EzBoardDAO.updateCopyItem", map);
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
	
	public int setMainImageID(Map<String, Object> map) throws Exception{
		return update("EzBoardDAO.setMainImageID", map);
	}
	
	public String setMainImageID2(Map<String, Object> map) throws Exception{
		return (String) select("EzBoardDAO.setMainImageID2", map);
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
	
	public void setBoardList_Config2_U(Map<String, Object> map) throws Exception{
		update("EzBoardDAO.setBoardList_Config2_U", map);
	}
	
	public void setBoardList_Config2_I(Map<String, Object> map) throws Exception{
		insert("EzBoardDAO.setBoardList_Config2_I", map);
	}
	
	public void apprItem(Map<String, Object> map) throws Exception{
		update("EzBoardDAO.apprItem", map);
	}
	
	public void updateMyBoard(BoardMyFavoriteVO boardMyFavoriteVO) throws Exception{
		update("EzBoardDAO.updateMyBoard", boardMyFavoriteVO);
	}
	
	public void setBoardList_Config_U(BoardConfigVO boardConfigVO) throws Exception{
		update("EzBoardDAO.setBoardList_Config_U", boardConfigVO);
	}
	
	public void photoListDel(Map<String, Object> map) throws Exception{
		delete("EzBoardDAO.photoListDel", map);
	}

	public String getBoardItemRead(Map<String, Object> map) throws Exception{
		return (String) select("EzBoardDAO.getBoardItemRead", map);
	}

	public String getWriterID(Map<String, Object> map) throws Exception{
		return (String) select("EzBoardDAO.getWriterID", map);
	}

	public void setAsRead2(Map<String, Object> map) throws Exception{
		update("EzBoardDAO.setAsRead2", map);
	}

	public void setInitReadCount(BoardListVO boardListVO) throws Exception{
		update("EzBoardDAO.setInitReadCount", boardListVO);
	}

	public void setApprFlag(BoardListVO boardListVO) throws Exception{
		update("EzBoardDAO.setApprFlag", boardListVO);
	}

	public void deleteBoardItemRead(BoardListVO boardListVO) throws Exception{
		delete("EzBoardDAO.deleteBoardItemRead", boardListVO);
	}

	public void deletePhotoImageItem(Map<String, Object> map) throws Exception{
		delete("EzBoardDAO.deletePhotoImageItem", map);
	}

	public String getApprFlag(BoardListVO boardListVO) throws Exception{
		return (String) select("EzBoardDAO.getApprFlag", boardListVO);
	}

	public String getBoardItem(Map<String, Object> map) throws Exception{
		return (String) select("EzBoardDAO.getBoardItem", map);
	}

	public void deleteBoardItem(Map<String, Object> map) throws Exception{
		delete("EzBoardDAO.deleteBoardItem", map);
	}

	public void deleteBoardReply(Map<String, Object> map) throws Exception{
		delete("EzBoardDAO.deleteBoardReply", map);
	}

	public void deleteBoardItemRead2(Map<String, Object> map) throws Exception{
		delete("EzBoardDAO.deleteBoardItemRead2", map);
	}

	public void deleteBoardItemAttach(Map<String, Object> map) throws Exception{
		delete("EzBoardDAO.deleteBoardItemAttach", map);
	}

	public void insertDeleteReservedItem(Map<String, Object> map) throws Exception{
		insert("EzBoardDAO.insertDeleteReservedItem", map);
	}

	public void deleteBoardItemTemp(Map<String, Object> map) throws Exception{
		delete("EzBoardDAO.deleteBoardItemTemp", map);
	}

	public int getBoardOneLineReply(Map<String, Object> map) throws Exception{
		return (int) select("EzBoardDAO.getBoardOneLineReply", map);
	}

	@SuppressWarnings("unchecked")
	public List<BoardListVO> getReplyNoticeMail(Map<String, Object> map) throws Exception {
		return (List<BoardListVO>) list("EzBoardDAO.getReplyNoticeMail", map);
	}

	@SuppressWarnings("unchecked")
	public List<LoginVO> getSendApprMailList(Map<String, Object> map) throws Exception {
		return (List<LoginVO>) list("EzBoardDAO.getSendApprMailList", map);
	}

	public String getContentInfo(Map<String, Object> map) throws Exception {
		return (String) select("EzBoardDAO.getContentInfo", map);
	}

	public BoardAttachVO getAttachInfo(Map<String, Object> map) throws Exception {
		return (BoardAttachVO) select("EzBoardDAO.getAttachInfo", map);
	}
	
	public void deleteItemTempPhoto(BoardListVO boardListVO) throws Exception {
        delete("EzBoardDAO.deleteItemTempPhoto", boardListVO);
    }

    public void deleteImageItem(BoardListVO boardListVO) throws Exception {
        delete("EzBoardDAO.deleteImageItem", boardListVO);
	}

	public int photoViewDBCount(Map<String, Object> map) throws Exception {
		return (int) select("EzBoardDAO.photoViewDBCount", map);
	}

	public String getOneLinePassWord(Map<String, Object> map) throws Exception {
		return (String) select("EzBoardDAO.getOneLinePassWord", map);
	}

	@SuppressWarnings("unchecked")
	public List<BoardDeleteItemVO> getExpiredItems() throws Exception {
		return (List<BoardDeleteItemVO>) list("EzBoardDAO.getExpiredItems");
	}

	@SuppressWarnings("unchecked")
	public List<BoardDeleteItemVO> getDeleteReservedBoard() throws Exception {
		return (List<BoardDeleteItemVO>) list("EzBoardDAO.getDeleteReservedBoard");
	}

	@SuppressWarnings("unchecked")
	public List<BoardDeleteItemVO> getDeleteReservedBoardItem() throws Exception {
		return (List<BoardDeleteItemVO>) list("EzBoardDAO.getDeleteReservedBoardItem");
	}

	public void deleteReservedBoardItem(BoardDeleteItemVO boardDeleteItemVO) throws Exception {
		delete("EzBoardDAO.deleteReservedBoardItem", boardDeleteItemVO);
	}

	public void deleteReservedBoard(BoardDeleteItemVO k) throws Exception {
		delete("EzBoardDAO.deleteReservedBoard", k);
	}
	
    
}