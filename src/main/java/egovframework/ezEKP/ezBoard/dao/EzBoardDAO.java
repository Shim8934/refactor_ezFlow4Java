package egovframework.ezEKP.ezBoard.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import egovframework.ezEKP.ezBoard.vo.BoardKeywordVO;
import egovframework.ezEKP.ezBoard.vo.BoardHistoryVO;
import org.springframework.stereotype.Repository;

import egovframework.ezEKP.ezBoard.vo.BoardAccessVO;
import egovframework.ezEKP.ezBoard.vo.BoardAttachVO;
import egovframework.ezEKP.ezBoard.vo.BoardAttributeVO;
import egovframework.ezEKP.ezBoard.vo.BoardConfigVO;
import egovframework.ezEKP.ezBoard.vo.BoardDeleteItemVO;
import egovframework.ezEKP.ezBoard.vo.BoardDisLikeListVO;
import egovframework.ezEKP.ezBoard.vo.BoardItemVO;
import egovframework.ezEKP.ezBoard.vo.BoardLikeListVO;
import egovframework.ezEKP.ezBoard.vo.BoardLineReplyVO;
import egovframework.ezEKP.ezBoard.vo.BoardListHeaderVO;
import egovframework.ezEKP.ezBoard.vo.BoardListVO;
import egovframework.ezEKP.ezBoard.vo.BoardMyFavoriteVO;
import egovframework.ezEKP.ezBoard.vo.BoardPollConfigVO;
import egovframework.ezEKP.ezBoard.vo.BoardPropertyVO;
import egovframework.ezEKP.ezBoard.vo.BoardReadVO;
import egovframework.ezEKP.ezBoard.vo.BoardScrapListVO;
import egovframework.ezEKP.ezBoard.vo.BoardUserScrapContListVO;
import egovframework.ezEKP.ezBoard.vo.BoardUserScrapContVO;
import egovframework.ezEKP.ezBoard.vo.BoardThumbnailVO;
import egovframework.ezEKP.ezBoard.vo.BoardVO;
import egovframework.ezEKP.ezOrgan.vo.OrganUserVO;
import egovframework.ezEKP.ezBoard.vo.MealDataVO;
import egovframework.let.user.login.vo.LoginVO;
import org.egovframe.rte.psl.dataaccess.EgovAbstractDAO;

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
	
	public int getPhotoCount(BoardMyFavoriteVO myFavoriteVO) throws Exception{
		return (int) select("EzBoardDAO.getPhotoCount", myFavoriteVO);
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

	public List<BoardDeleteItemVO> deleteItemsScrapList() throws Exception {
		return (List<BoardDeleteItemVO>) list("EzBoardDAO.deleteItemsScrapList");
	}
	public void deleteItemsScrap(BoardDeleteItemVO boardDeleteItemVO) throws Exception {
		delete("EzBoardDAO.deleteItemsScrap", boardDeleteItemVO);
	}

	public List<BoardDeleteItemVO> deleteItemsScrapContList() throws Exception {
		return (List<BoardDeleteItemVO>) list("EzBoardDAO.deleteItemsScrapContList");
	}

	public void deleteItemsScrapCont(BoardDeleteItemVO boardDeleteItemVO) throws Exception {
		delete("EzBoardDAO.deleteItemsScrapCont", boardDeleteItemVO);
	}

    //baonk added
	public BoardPollConfigVO getPollConfig(Map<String, Object> map) throws Exception {
		return (BoardPollConfigVO) select("EzBoardDAO.getPollConfig", map);
	}

	public void saveBoardPollConfig(Map<String, Object> map) throws Exception {		
		insert("EzBoardDAO.saveBoardPollConfig", map);
	}	
	//end

	public String getOneLineReplyCount(Map<String, Object> map) throws Exception{
		return String.valueOf(select("EzBoardDAO.getOneLineReplyCount", map));
	}

	public int getReaderListCount(Map<String, Object> map) {
		return (int) select("EzBoardDAO.getReaderListCount", map);
	}
	
	public void updateMoveOneLineReply(Map<String, Object> map) throws Exception {
		update("EzBoardDAO.updateMoveOneLineReply", map);
	}

	@SuppressWarnings("unchecked")
	public List<HashMap<String, Object>> checkBoardManage(Map<String, Object> map) throws Exception{
		return (List<HashMap<String, Object>>) list("EzBoardDAO.CheckBoardManage", map);
	}

	@SuppressWarnings("unchecked")
	public List<HashMap<String, Object>> getSearchAllBoardItemList(Map<String, Object> map) throws Exception{
		return (List<HashMap<String, Object>>) list("EzBoardDAO.getSearchAllBoardItemList", map);
	}

	public int getSearchAllBoardItemCount(Map<String, Object> map) throws Exception{
		return (int) select("EzBoardDAO.getSearchAllBoardItemCount", map);
	}
	
	public int isDeptChk(Map<String, Object> map) throws Exception {
		return (int) select("EzBoardDAO.isDeptChk", map);
	}
	
	/* 2018-06-11 홍승비 - 포토/썸네일 이미지 리스트 중에서 가장 큰 IMAGEID 가져오기 */
	public String getLastImageID(Map<String, Object> map) throws Exception {
		return (String) select("EzBoardDAO.getLastImageID", map);
	}
	/* 2018-06-28 홍승비 - 승인게시물 검색 카운트 쿼리 추가 */
	public int getSearchApprBoardItemCount(Map<String, Object> map) throws Exception {
		return (int) select("EzBoardDAO.getSearchApprBoardItemCount", map);
	}
	
	/* 2018-06-28 홍승비 - 승인게시물 검색 리스트 쿼리 추가 */
	@SuppressWarnings("unchecked")
	public List<HashMap<String, Object>> getSearchApprBoardItemList(Map<String, Object> map) throws Exception {
		return (List<HashMap<String, Object>>) list("EzBoardDAO.getSearchApprBoardItemList", map);
	}
	
	// 20181210 김윤진 - ezTalk Notice Board ID 가져오기.
	public String getEzTalkGateNoticeBoardId(Map<String, Object> map) throws Exception {
		return (String) select("ezNewPortal.getEzTalkGateNoticeBoardId", map);
	}
	
	/* 2019-01-15 홍승비 - 수정일(updateDate)만을 업데이트하는 쿼리 추가 */
	public void modUpdateDate(Map<String, Object> map) throws Exception {
		update("EzBoardDAO.modUpdateDate", map);
	}
	
	/* 2019-04-05 홍승비 - 좋아요 삽입 */
	public void likeInsert(Map<String, Object> map) throws Exception {
		insert("EzBoardDAO.likeInsert", map);
	}
	
	/* 2019-04-05 홍승비 - 좋아요 삭제 */
	public void likeDelete(Map<String, Object> map) throws Exception {
		delete("EzBoardDAO.likeDelete", map);
	}
	
	/* 2019-04-05 홍승비 - 좋아요 여부 체크 */
	public String likeCheck(Map<String, Object> map) throws Exception {
		return (String) select("EzBoardDAO.likeCheck", map);
	}
	
	/* 2019-04-05 홍승비 - 좋아요 갯수 가져오기 */
	public int getlikeCount(Map<String, Object> map) throws Exception {
		return (int) select("EzBoardDAO.getlikeCount", map);
	}
	
	/* 2019-04-10 홍승비 - 사용자가 원회사이고 사내겸직이 존재하면 사내겸직부서ID를 리턴하는 쿼리 */
	@SuppressWarnings("unchecked")
	public List<String> getPDOAddJobDeptID(Map<String, Object> map) throws Exception {
		return (List<String>) list("EzBoardDAO.getPDOAddJobDeptID", map);
	}
	
	/* 2019-05-15 홍승비 - 해당 부서ID로 상위부서ID(회사포함) 가져오기*/
	public String getUpperDeptID(Map<String, Object> map) throws Exception {
		return (String) select("EzBoardDAO.getUpperDeptID", map);
	}
	
	/* 2019-09-18 홍승비 - 사용자의 직위와 직책 ID를 리턴하는 쿼리 (사내겸직 포함) */
	@SuppressWarnings("unchecked")
	public List<String> getUserJJID(Map<String, Object> map) throws Exception {
		return (List<String>) list("EzBoardDAO.getUserJJID", map);
	}
	
	/* 2019-09-18 홍승비 - 그룹권한을 포함하여 ACCESSID에 대한 권한정보를 리스트로 리턴하는 쿼리 */
	@SuppressWarnings("unchecked")
	public List<BoardPropertyVO> getACLListNew(Map<String, Object> map) throws Exception {
		return (List<BoardPropertyVO>) list("EzBoardDAO.getACLListNew", map);
	}

	/* 2019-09-18 홍승비 - 그룹권한을 포함하여 ACCESSID에 대한 게시판 그룹의 관리자 권한을 리스트로 리턴하는 쿼리 */
	@SuppressWarnings("unchecked")
	public List<String> checkIfBoardGroupAdminNew(Map<String, Object> map) throws Exception {
		return (List<String>) list("EzBoardDAO.checkIfBoardGroupAdminNew", map);
	}

	/* 2019-09-24 홍승비 - 그룹권한을 포함하여 ACCESSID에 대한 게시판 읽기권한을 리스트로 리턴하는 쿼리 */
	@SuppressWarnings("unchecked")
	public List<String> getCheckItemIDNew(Map<String, Object> map) throws Exception {
		return (List<String>) list("EzBoardDAO.getCheckItemIDNew", map);
	}

	@SuppressWarnings("unchecked")
	public List<BoardPropertyVO> getAllSubBoardProperty(Map<String, Object> map) throws Exception {
		return (List<BoardPropertyVO>) list("EzBoardDAO.getAllSubBoardProperty", map);
	}

	/* 2019-12-13 홍승비 - 게시물 이동 시 조회자 정보를 삭제하지 않고 유지하는 쿼리 */
	public void updateBoardItemRead(Map<String, Object> map) throws Exception {
		update("EzBoardDAO.updateBoardItemRead", map);
	}

	/* 2019-12-16 홍승비 - 게시물 복사 시 테넌트 컨피그에 따라 기존 게시물의 조회자정보를 삽입하는 쿼리 */
	public void insertBoardItemReadForCopy(Map<String, Object> map) throws Exception {
		insert("EzBoardDAO.insertBoardItemReadForCopy", map);
	}
	
	/* 2020-06-15 홍승비 - 주어진 게시판ID에 대하여 즐겨찾기 여부를 판단하는 쿼리 */
	public int getIsMyBoardExist(Map<String, Object> map) throws Exception {
		return (int) select("EzBoardDAO.getIsMyBoardExist", map);
	}
	
	/* 2019-10-11 홍승비 - 회사별 공지사항 게시판ID를 리턴하는 쿼리 */
	public String getCompanyNoticeBoardID(Map<String, Object> map) throws Exception {
		return (String) select("EzBoardDAO.getCompanyNoticeBoardID", map);
	}
	
	/* 2020-07-14 홍승비 - 선택한 마이게시판 분류 하위의 해당 게시판 카운트 리턴 */
	public int getMyBoardCount(Map<String, Object> map) throws Exception {
		return (int) select("EzBoardDAO.getMyBoardCount", map);
	}

	/* 2020-12-03 박기범 - 탭 공지 게시판 조회 쿼리 추가 */
	@SuppressWarnings("unchecked")
	public List<HashMap<String, Object>> getCompanyTabBoardIDList(Map<String, Object> map) throws Exception {
		return (List<HashMap<String, Object>>) list("EzBoardDAO.getCompanyTabBoardIDList", map);
	}
	
	public int getOneLineCNT(Map<String, Object> map) throws Exception {
		return (int) select("EzBoardDAO.getOneLineCNT", map);
	}

	/* 2021-01-06 홍승비 - 게시물의 읽음여부 판별 시, 현재 사용자가 읽은 게시물을 셀렉트하도록 수정 */
	public int getReaderListCount2(Map<String, Object> map) throws Exception {
		return (int) select("EzBoardDAO.getReaderListCount2", map);
	}
	
	/* 2021-06-23 홍승비 - 그룹권한을 포함하여 ACCESSID에 대한 게시판 접근 + 리스트보기 권한을 리스트로 리턴하는 쿼리 */
	@SuppressWarnings("unchecked")
	public List<String> getBoardAccessListViewFG(Map<String, Object> map) throws Exception {
		return (List<String>) list("EzBoardDAO.getBoardAccessListViewFG", map);
	}

	/* 2021-06-23 홍승비 - 게시알림 메일 발송을 위한 사용자 정보를 map 리스트로 리턴하는 쿼리 */
	@SuppressWarnings("unchecked")
	public List<HashMap<String, String>> getBoardUserInfoForMailSend(Map<String, Object> map) throws Exception {
		return (List<HashMap<String, String>>) list("EzBoardDAO.getBoardUserInfoForMailSend", map);
	}
	
	/* 2021-06-23 홍승비 - 댓글알림 메일 발송을 위한 사용자 정보를 map으로 리턴하는 쿼리 */
	@SuppressWarnings("unchecked")
	public List<HashMap<String, String>> getCommentNoticeMail(Map<String, Object> map) throws Exception {
		return (List<HashMap<String, String>>) list("EzBoardDAO.getCommentNoticeMail", map);
	}
	
	/* 2023-03-07 이가은 - userID를 조건으로 댓글 반응 여부(좋아요 : Y / 싫어요 : N / 미선택 : 공백 또는 null) 리턴하는 쿼리  */
	public String checkReactUser(Map<String, Object> map) throws Exception {
		return (String) select("EzBoardDAO.checkReactUser", map);
	}
	
	/* 2023-03-07 이가은 - 댓글 반응 추가하는 쿼리 */
	public void inserBoardReact(Map<String, Object> map) throws Exception {
		insert("EzBoardDAO.inserBoardReact", map);
	}
	
	/* 2023-03-07 이가은 - 댓글 반응 삭제하는 쿼리 */
	public void deleteBoardReact(Map<String, Object> map) throws Exception {
		delete("EzBoardDAO.deleteBoardReact", map);
	}

	/* 2023-03-07 이가은 - 댓글 삭제되었을 경우 반응 모두 삭제하는 쿼리 */
	public void allReactDelete(Map<String, Object> map) throws Exception {
		delete("EzBoardDAO.allReactDelete", map);
	}

	/* 2023-03-08 이가은 - 게시물에 대한 사용자의 댓글 반응 HashMap List로 리턴하는 쿼리 */
	@SuppressWarnings("unchecked")
	public List<HashMap<String, String>> getUserReplyReact(Map<String, Object> map) throws Exception {
		return (List<HashMap<String, String>>) list("EzBoardDAO.getUserReplyReact", map);
	}
	
	/* 2023-03-08 이가은 - 댓글 존재여부 리턴하는 쿼리 */
	public int checkReplyID(Map<String, Object> map) throws Exception {
		return (int) select("EzBoardDAO.checkReplyID", map);
	}
	
	/* 2024-04-01 한태훈 - 게시판 즐겨찾기 추가 구성원 리스트 호출 */
	@SuppressWarnings("unchecked")
	public List<OrganUserVO> getFavoriteBoardUserList(Map<String, Object> map) throws Exception {
		return (List<OrganUserVO>) list("EzBoardDAO.getFavoriteBoardUserList", map);
	}

	public boolean confirmBoardItemDeletion(Map<String, Object> map) throws Exception {
		return (boolean) select("EzBoardDAO.confirmBoardItemDeletion", map);
	}

	/* 2023-03-30 이가은 - 게시물 댓글의 답글 작성/수정기능 추가 > 답글을 저장하는 쿼리 */
	public void saveOneLineChildReply(Map<String, Object> map) throws Exception {
		insert("EzBoardDAO.saveOneLineChildReply", map);
	}

	/* 2023-03-30 이가은 - 게시물 댓글의 답글 작성/수정기능 추가 > 댓글, 답글 수정되었을 경우 업데이트하는 쿼리 */
	public void updateOneLineReply(Map<String, Object> map) throws Exception {
		update("EzBoardDAO.updateOneLineReply", map);
	}

	/* 2023-04-12 이가은 - 게시물 댓글의 답글 작성/수정기능 추가 > 댓글 삭제 시 자식 댓글 개수 리턴하는 쿼리 */
	public int getChildReplyCnt(Map<String, Object> map) throws Exception {
		return (int) select("EzBoardDAO.getChildReplyCnt", map);
	}

	/* 2023-04-12 이가은 - 게시물 댓글의 답글 작성/수정기능 추가 > 자식있는 부모댓글 삭제할 경우 해당 댓글 값 NULL로 변경하는 쿼리 */
	public void updateDelParentReply(Map<String, Object> map) throws Exception {
		update("EzBoardDAO.updateDelParentReply", map);
	}
	
	/* 2023-04-06 기민혁 - 싫어요 삽입 쿼리*/
	public void disLikeInsert(Map<String, Object> map) throws Exception {
		insert("EzBoardDAO.disLikeInsert", map);
	}
	
	/* 2023-04-06 기민혁 - 싫어요 삭제 쿼리*/
	public void disLikeDelete(Map<String, Object> map) throws Exception {
		delete("EzBoardDAO.disLikeDelete", map);
	}
	
	/* 2023-04-06 기민혁 - 싫어요 체크 여부 확인 쿼리 */
	public String disLikeCheck(Map<String, Object> map) throws Exception {
		return (String) select("EzBoardDAO.disLikeCheck", map);
	}
	
	/* 2023-04-06 기민혁 - 싫어요 갯수 count 쿼리 */
	public int getDisLikeCount(Map<String, Object> map) throws Exception {
		return (int) select("EzBoardDAO.getDisLikeCount", map);
	}
	/* 2023-04-06 기민혁 - 좋아요 리스트 호출 쿼리 */
	@SuppressWarnings("unchecked")
	public List<BoardLikeListVO> getLikeList(Map<String, String> map) throws Exception {
		return (List<BoardLikeListVO>) list("EzBoardDAO.getLikeList",map);
	}

	/* 2023-04-06 기민혁 - 싫어요 리스트 호출 쿼리 */
	@SuppressWarnings("unchecked")
	public List<BoardDisLikeListVO> getDisLikeList(Map<String, String> map) throws Exception {
		return (List<BoardDisLikeListVO>) list("EzBoardDAO.getDisLikeList",map);
	}
	
	/* 2023-04-06 기민혁 - 좋아요/싫어요 정보 호출 쿼리 */
	@SuppressWarnings("unchecked")
	public List<BoardItemVO> getItemInfoList(Map<String, String> map) throws Exception {
		return (List<BoardItemVO>) list("EzBoardDAO.getItemInfoList",map);
	}

	public void insertKeyword(HashMap<String, Object> map) throws Exception {
		insert("EzBoardDAO.insertKeyword", map);
	}

	public void deleteBoardItemKeyword(HashMap<String, Object> map) throws Exception {
		insert("EzBoardDAO.deleteBoardItemKeyword", map);
	}

	public void insertBoardItemKeyword(List<BoardKeywordVO> list) throws Exception {
		insert("EzBoardDAO.insertBoardItemKeyword", list);
	}
	
	public List<BoardKeywordVO> selectBoardKeywordByKeywordName(HashMap<String, Object> map) throws Exception {
		return (List<BoardKeywordVO>) list("EzBoardDAO.selectBoardKeywordByKeywordName", map);
	}

	public List<BoardKeywordVO> selectBoardKeywordByBoardItem(HashMap<String, Object> map) throws Exception {
		return (List<BoardKeywordVO>) list("EzBoardDAO.selectBoardKeywordByBoardItem", map);
	}

	public int getAllBoardItemListCount(Map<String, Object> map) throws Exception {
		return (int) select("EzBoardDAO.getAllBoardItemListCount", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<HashMap<String, Object>> getAllBoardItemList(Map<String, Object> map) throws Exception {
		return (List<HashMap<String, Object>>) list("EzBoardDAO.getAllBoardItemList", map);
	}

	public String getContentlocation(Map<String, Object> map) throws Exception {
		return (String) select("EzBoardDAO.getContentlocation", map);
	}
	
	/* 2023-05-03 기민혁 - 나의 스크랩 데이터 등록 쿼리 */
	public void setScrapItem(Map<String, Object> map) throws Exception {
		insert("EzBoardDAO.setScrapItem", map);
	}

	/* 2023-05-03 기민혁 - 나의 스크랩 등록 확인 쿼리 */
	public int getScrapItemCount(Map<String, Object> map) throws Exception {
		return (int) select("EzBoardDAO.getScrapItemCount", map);
	}
	
	/* 2023-05-03 기민혁 - 나의 스크랩 목록 다중 해제 쿼리 */
	public void deleteScrapItem(BoardScrapListVO scrapList) throws Exception {
		delete("EzBoardDAO.deleteScrapItem", scrapList);
	}
	
	/* 2023-05-03 기민혁 - 나의 스크랩 해제 쿼리 */
	public void delScrapItem(Map<String, Object> map) throws Exception {
		delete("EzBoardDAO.delScrapItem", map);
	}
	
	/* 2023-05-03 기민혁 - 나의 스크랩 등록 item 리스트 호출 쿼리 */
	@SuppressWarnings("unchecked")
	public List<HashMap<String, Object>> getMyBoardListItemScrap(Map<String, Object> map) throws Exception {
		return (List<HashMap<String, Object>>) list("EzBoardDAO.getMyBoardListItemScrap", map);
	}
	
	/* 2023-05-03 기민혁 - 나의 스크랩 item totalcount 쿼리 */
	public int getMyBoardTotalItemCountScrap(Map<String, Object> map) throws Exception {
		return (int) select("EzBoardDAO.getMyBoardTotalItemCountScrap", map);
	}

	/* 2023-05-03 기민혁 - 나의 스크랩 검색 item totalcount 쿼리 */
	public int getSearchMyBoardItemCountScrap(Map<String, Object> map) {
		return (int) select("EzBoardDAO.getSearchMyBoardItemCountScrap", map);		
	}
	
	/* 2023-05-03 기민혁 - 나의 스크랩 검색 item 리스트 호출 쿼리 */
	@SuppressWarnings("unchecked")
	public List<HashMap<String, Object>> getSearchMyBoardItemListScrap(Map<String, Object> map) throws Exception {
		return (List<HashMap<String, Object>>) list("EzBoardDAO.getSearchMyBoardItemListScrap", map);
	}

	/* 2023-05-03 기민혁 - 게시물 삭제시 scrap 목록 삭제 쿼리 */
	public void deleteBoardScrapItem(BoardScrapListVO scrapList) throws Exception {
		delete("EzBoardDAO.deleteBoardScrapItem", scrapList);
	}
	
	/* 2023-05-03 기민혁 - 게시물 scrap 여부 체크 쿼리*/
	public int isScrapitemCount(BoardScrapListVO scrapList) throws Exception{
		return (int) select("EzBoardDAO.isScrapitemCount",scrapList);
	}
	
	/* 2023-05-22 기민혁 - 게시물함 폴더 정보 호출 쿼리*/
	@SuppressWarnings("unchecked")
	public List<BoardUserScrapContVO> getUserScrapContTree(Map<String, Object> map) throws Exception {
		return (List<BoardUserScrapContVO>) list("EzBoardDAO.getUserScrapContTree", map);
	}

	/* 2023-05-22 기민혁 - 게시물함 max ID 생성*/
	public String getUserScrapContMaxID(Map<String, Object> map) throws Exception {
		return (String) select("EzBoardDAO.getUserScrapContMaxID", map);
	}

	/* 2023-05-22 기민혁 - 게시물함  폴더 생성*/
	public void insertUserScrapCont(Map<String, Object> map) throws Exception {
		insert("EzBoardDAO.insertUserScrapCont", map);
	}

	/* 2023-05-22 기민혁 - 게시물함  자식 폴더 표출*/
	@SuppressWarnings("unchecked")
	public List<BoardUserScrapContVO> getUserScrapContTreeLeaf(Map<String, Object> map) {
		return (List<BoardUserScrapContVO>) list("EzBoardDAO.getUserScrapContTreeLeaf", map);
	}

	/* 2023-05-22 기민혁 - 스크랩함 폴더 변경 */
	public void updateUserScrapCont(Map<String, Object> map) {
		update("EzBoardDAO.updateUserScrapCont", map);
	}

	/* 2023-05-22 기민혁 - 스크랩함 삭제할 폴더의 자식 폴더 개수 count  */
	public int getUserScrapContSubCount(Map<String, Object> map) throws Exception {
		return (int) select("EzBoardDAO.getUserScrapContSubCount", map);
	}

	/* 2023-05-22 기민혁 - 스크랩함 삭제할 폴더의 스크랩 게시물 개수 count  */
	public int delUserScrapContItemCnt(Map<String, Object> map) throws Exception{
		return (int) select("EzBoardDAO.delUserScrapContItemCnt", map);
	}

	/* 2023-05-22 기민혁 - 스크랩함 삭제할 폴더의 게시물 삭제  */
	public void delUserScrapContList(Map<String, Object> map) throws Exception{
		delete("EzBoardDAO.delUserScrapContList", map);
	}

	/* 2023-05-22 기민혁 - 스크랩함 폴더 삭제  */
	public void delUserScrapCont(Map<String, Object> map) throws Exception{
		delete("EzBoardDAO.delUserScrapCont", map);
	}

	/* 2023-05-22 기민혁 - 스크랩함 중복 스크랩 정보 count */
	public int getOverlapItemCount( BoardUserScrapContListVO boardUserScrapContListVO) throws Exception {
		return (int) select("EzBoardDAO.getOverlapItemCount", boardUserScrapContListVO);
	}

	/* 2023-05-22 기민혁 - 스크랩함에 게시물 데이터 insert */
	public void setUserScrapContItem( BoardUserScrapContListVO boardUserScrapContListVO) throws Exception {
		insert("EzBoardDAO.setUserScrapContItem", boardUserScrapContListVO);
	}

	/*2023-05-22 기민혁 - 스크랩함 게시물 스크랩 해제*/
	public void deleteScrapContItemList(BoardScrapListVO scrapList) throws Exception {
		delete("EzBoardDAO.deleteScrapContItemList" , scrapList);
	}

	/*2023-05-22 기민혁 - 스크랩함 스크랩 item totalcount*/
	public int getUserScrapContlistCount(Map<String, Object> map) throws Exception {
		return (int) select("EzBoardDAO.getUserScrapContlistCount", map);
	}

	/*2023-05-22 기민혁 - 스크랩함 리스트 표출 */
	@SuppressWarnings("unchecked")
	public List<HashMap<String, Object>> getScrapContItemList(Map<String, Object> map) throws Exception {
		return (List<HashMap<String, Object>>) list("EzBoardDAO.getScrapContItemList", map);
	}

	/*2023-05-22 기민혁 - 스크랩함 검색결과 스크랩 item totalcount*/
	public int getSearchScrapContItemListCount(Map<String, Object> map) throws Exception {
		return (int) select("EzBoardDAO.getSearchScrapContItemListCount" , map);
	}

	/*2023-05-22 기민혁 - 나의 스크랩함 검색리스트 표출 */
	@SuppressWarnings("unchecked")
	public List<HashMap<String, Object>> getSearchScrapContItemList(Map<String, Object> map) {
		return (List<HashMap<String, Object>>) list("EzBoardDAO.getSearchScrapContItemList", map);
	}

	/* 2023-05-22 기민혁 - 게시물 삭제시 scrapcont 목록 삭제*/
	public void deleteBoardScrapContItem(BoardUserScrapContListVO scrapList) throws Exception {
		delete("EzBoardDAO.deleteBoardScrapContItem", scrapList);
	}

	/* 2023-05-02 기민혁 - 게시물 삭제시 스크랩함에 scrap 되어있는지 체크*/
	public int isScrapContItemCount(BoardUserScrapContListVO scrapList) throws Exception{
		return (int) select("EzBoardDAO.isScrapContItemCount",scrapList);
	}

	@SuppressWarnings("unchecked")
	public List<HashMap<String, Object>> getUserScrapBoardList(Map<String, Object> map) throws Exception{
		return (List<HashMap<String, Object>>) list("EzBoardDAO.getUserScrapBoardList", map);
	}

	@SuppressWarnings("unchecked")
	public List<HashMap<String, Object>> getUserScrapContBoardList(Map<String, Object> map) throws Exception{
		return (List<HashMap<String, Object>>) list("EzBoardDAO.getUserScrapContBoardList", map);
	}
	
	public void saveCommentAttach(Map<String, Object> map) throws Exception {
		insert("EzBoardDAO.saveCommentAttach", map);
	}
	
	public void deleteCommentAttach(Map<String, Object> map) throws Exception {
		delete("EzBoardDAO.deleteCommentAttach", map);
	}

    public void updateMovedItemCommentAttach(Map<String, Object> map) {
		update("EzBoardDAO.updateMovedItemCommentAttach", map);
    }
    
	@SuppressWarnings("unchecked")
	public List<BoardThumbnailVO> thumbnailViewDB(Map<String, Object> map) throws Exception{
		return (List<BoardThumbnailVO>) list("EzBoardDAO.thumbnailViewDB", map);
	}
	
	public void thumbnailUpdate(Map<String, Object> map) throws Exception {
		update("EzBoardDAO.thumbnailUpdate", map);
	}

	/* 2024-09-05 이유정 - 게시판 > 최근게시물 리스트 카운트 쿼리 */
	public int getAllNewItemListCount(Map<String, Object> map) throws Exception{
		return (int) select("EzBoardDAO.getAllNewItemListCount", map);
	}
	
	/* 2024-09-05 이유정 - 게시판 > 최근게시물 리스트 쿼리 */
	public List<HashMap<String, Object>> getAllNewItemList(Map<String, Object> map) throws Exception{
		return (List<HashMap<String, Object>>) list("EzBoardDAO.getAllNewItemList", map);
	}
	
	public List<BoardAttachVO> brdGetPhotoItemAttachmentInfo(Map<String, Object> map) throws Exception{
		return (List<BoardAttachVO>) list("EzBoardDAO.brdGetPhotoItemAttachmentInfo", map);
	}

	/* 2024-10-02 이혜림 - 별점 추가하는 쿼리 */
	public void insertItemStarRating(Map<String, Object> map) throws Exception {
		insert("EzBoardDAO.insertItemStarRating", map);
	}

	/* 2024-10-02 이혜림 - 별점 총점, 평균 추가하는 쿼리 */
	public void insertItemStarRatingSummary(Map<String, Object> map) throws Exception {
		insert("EzBoardDAO.insertItemStarRatingSummary", map);
	}

	/* 2024-10-02 이혜림 - 별점 업데이트하는 쿼리 */
	public void updateItemStarRating(Map<String, Object> map) throws Exception {
		update("EzBoardDAO.updateItemStarRating", map);
	}

	/* 2024-10-02 이혜림 - 별점 총점, 평균 업데이트하는 쿼리 */
	public void updateItemStarRatingSummary(Map<String, Object> map) throws Exception {
		update("EzBoardDAO.updateItemStarRatingSummary", map);
	}
	
	/* 2024-10-02 이혜림 - 게시물의 별점을 모두 삭제하는 쿼리 */
	public void deleteStarRating(Map<String, Object> map) throws Exception {
		delete("EzBoardDAO.deleteStarRating", map);
	}

	/* 2024-10-02 이혜림 - 게시물의 총점,평균을 삭제하는 쿼리 */
	public void deleteStarRatingSummary(Map<String, Object> map) throws Exception {
		delete("EzBoardDAO.deleteStarRatingSummary", map);
	}

	/* 2024-10-02 이혜림 - 게시물에 대한 사용자의 별점, 총점, 평균 HashMap dm로 리턴하는 쿼리 */
	@SuppressWarnings("unchecked")
	public HashMap<String, Object> getItemStarRating(Map<String, Object> map) throws Exception {
		return (HashMap<String, Object>) select("EzBoardDAO.getItemStarRating", map);
	}

	@SuppressWarnings("unchecked")
	public List<MealDataVO> getMealPlanList(Map<String, Object> map) throws Exception{
		return (List<MealDataVO>) list("EzBoardDAO.getMealPlanList", map);
	}

	public void saveMealplan(MealDataVO vo) throws Exception{
		insert("EzBoardDAO.saveMealplan", vo);
	}

	public MealDataVO getTodayLunch(Map<String, Object> map) {
		return (MealDataVO) select("EzBoardDAO.getTodayLunch", map);
	}
    
	public String getRealFileNames(Map<String, Object> map) throws Exception {
		return (String)select("EzBoardDAO.getRealFileNames", map);
	}

	public BoardItemVO getFileViewerBoardItemID(Map<String, Object> map) throws Exception {
		return (BoardItemVO) select("EzBoardDAO.getFileViewerBoardItemID", map);
	}

	public boolean isPostDuplicated1(Map<String, Object> map) throws Exception {
		int cnt = (int) select("EzBoardDAO.isPostDuplicated1", map);
		return cnt > 0;
	}

	public String isPostDuplicated2(Map<String, Object> map) throws Exception {
		return (String) select("EzBoardDAO.isPostDuplicated2", map);
	}

	public List<BoardHistoryVO> getModifiedHistoryOfItem(String boardID, String itemID, String companyID, int tenantID) throws Exception {
		return (List<BoardHistoryVO>)list(
				"EzBoardDAO.getModifiedHistoryOfItem",
				new HashMap() {{
					put("boardID", boardID);
					put("itemID", itemID);
					put("companyID", companyID);
					put("tenantID", tenantID);
				}}
		);
	}

	public String getUseVersionFlag(String boardID, int tenantID) throws Exception {
		return (String)select(
				"EzBoardDAO.getUseVersionFlag",
				new HashMap() {{
					put("boardID", boardID);
					put("tenantID", tenantID);
				}}
		);
	}

	public String getItemVersion(String itemID, String companyID, int tenantID) throws Exception {
		return (String)select("EzBoardDAO.getItemVersion",
				new HashMap() {{
					put("itemID", itemID);
					put("companyID", companyID);
					put("tenantID", tenantID);
				}}
		);
	}

	public void addModifyHistory(BoardListVO b) throws Exception {
		insert("EzBoardDAO.addModifyHistory", b);
	}

	public String getParentItemID(String itemID, String companyID, int tenantID) throws Exception {
		return (String)select("EzBoardDAO.getParentItemID",
				new HashMap() {{
					put("itemID", itemID);
					put("companyID", companyID);
					put("tenantID", tenantID);
				}}
		);
	}

	public void deleteVersionedItem(Map<String, Object> map) throws Exception {
		delete("EzBoardDAO.deleteVersionedItem", map);
	}

	public void deleteVersionedItemReply(Map<String, Object> map) throws Exception {
		delete("EzBoardDAO.deleteVersionedItemReply", map);
	}

	public void deleteVersionedItemRead(Map<String, Object> map) throws Exception {
		delete("EzBoardDAO.deleteVersionedItemRead", map);
	}

	public List<String> getVersionedItemHrefList(Map<String, Object> map) throws Exception {
		return (List<String>)list("EzBoardDAO.versionedItemHrefList", map);
	}

	public String getNewestVersion(String boardID, String itemID, int tenantID) throws Exception {
		return (String)select("EzBoardDAO.getNewestVersion",
				new HashMap() {{
					put("boardID", boardID);
					put("itemID", itemID);
					put("tenantID", tenantID);
				}}
		);
	}

	public String getBoardTitle(Map<String, Object> map) throws Exception {
		return (String) select("EzBoardDAO.getBoardTitle", map);
	}

	public void repostItem(Map<String, Object> map) throws Exception {
		update("EzBoardDAO.repostItem", map);
	}

	public List<Map<String, String>> getAnswerList(Map<String, Object> map) throws Exception {
		return (List<Map<String, String>>) list("EzBoardDAO.getAnswerList", map);
	}

	public void repostReplyItem(Map<String, Object> map) throws Exception {
		update("EzBoardDAO.repostReplyItem", map);
	}
}
