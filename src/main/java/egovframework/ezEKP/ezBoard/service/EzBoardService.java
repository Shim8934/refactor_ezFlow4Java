package egovframework.ezEKP.ezBoard.service;

import java.util.HashMap;
import java.util.List;
import java.util.Locale;

import org.w3c.dom.Document;

import egovframework.ezEKP.ezBoard.vo.BoardAccessVO;
import egovframework.ezEKP.ezBoard.vo.BoardAttachVO;
import egovframework.ezEKP.ezBoard.vo.BoardConfigVO;
import egovframework.ezEKP.ezBoard.vo.BoardItemVO;
import egovframework.ezEKP.ezBoard.vo.BoardLineReplyVO;
import egovframework.ezEKP.ezBoard.vo.BoardListHeaderVO;
import egovframework.ezEKP.ezBoard.vo.BoardListVO;
import egovframework.ezEKP.ezBoard.vo.BoardMyFavoriteVO;
import egovframework.ezEKP.ezBoard.vo.BoardPropertyVO;
import egovframework.ezEKP.ezBoard.vo.BoardReadVO;
import egovframework.ezEKP.ezBoard.vo.BoardVO;
import egovframework.let.user.login.vo.LoginSimpleVO;
import egovframework.let.user.login.vo.LoginVO;

public interface EzBoardService {

	public List<BoardVO> getLeft_BoardSTD(String redirectBoardID, int tenantID) throws Exception;
	
	public List<BoardVO> get_apprUserList(String boardID, int tenantID) throws Exception;

	public List<BoardMyFavoriteVO> get_favoriteList(String userID, String pMode, int tenantID) throws Exception;

	public List<BoardListHeaderVO> getListHeader(BoardVO ezBoardVO) throws Exception;
	
	public List<BoardListHeaderVO> getListHeaderBoardID(BoardVO ezBoardVO) throws Exception;
	
	public List<BoardAttachVO> brdGetItemAttachmentInfo(String pItemID, int tenantID) throws Exception;
	
	public List<BoardReadVO> getReaderList(String boardID, String itemID, String userID, String lang, int tenantID) throws Exception;
	
	public List<BoardListVO> getAdjacentItems1(String boardID, String parentWriteDate, String upperItemIDTree, int tenantID) throws Exception;
	
	public List<BoardListVO> getAdjacentItems2(String boardID, String parentWriteDate, int tenantID) throws Exception;
	
	public List<BoardListVO> getAdjacentItems3(String boardID, String parentWriteDate, String itemID, String upperItemIDTree, String previousItemID, int tenantID) throws Exception;
	
	public List<BoardListVO> getAdjacentItems2Photo(String boardID, String parentWriteDate, int tenantID) throws Exception;

	public List<BoardListVO> getAdjacentItems3Photo(String boardID, String parentWriteDate, int tenantID) throws Exception;
	
	public List<BoardAttachVO> photoViewDB(String itemID, String boardID, int pStartRow, int pEndRow, int tenantID) throws Exception;
	
	public List<BoardAttachVO> photoViewDBAll(String itemID, String boardID, int tenantID) throws Exception;
	
	public List<BoardListVO> getReservedItemList(String userID, int startRow, int endRow, String sortBy, String lang, String offset, int tenantID) throws Exception;
	
	public List<BoardLineReplyVO> readOneLineReply(String boardID, String itemID, String userName, int tenantID) throws Exception;
	
	public List<BoardListVO> getUnreadItems(String pUserID, String pBoardID, int pMaxCount, int tenantID) throws Exception;
	
	public List<HashMap<String, Object>> getNewItemList(BoardListVO boardListVO) throws Exception;

	public List<HashMap<String, Object>> getNoticePostItem(BoardVO ezBoardVO, int personalCount) throws Exception;

	public List<HashMap<String, Object>> getBoardListItem(String boardId, String userID, int startRow, int endRow, int boardCount, String orderOption1, String orderOption2, String type, int tenantID) throws Exception;
	
	public List<HashMap<String, Object>> getQnABoardListItem(String boardId, String userID, int startRow, int endRow, int boardCount, String orderOption1, String orderOption2, String type, String adminType, int tenantID) throws Exception;
	
	public List<HashMap<String, Object>> getSearchBoardItemList(BoardListVO boardListVO, BoardVO boardVO) throws Exception;
	
	public List<HashMap<String, Object>> getThumbnailList(BoardListVO boardListVO, BoardVO boardVO) throws Exception;
	
	public List<HashMap<String, Object>> getSearchThumbnailList(BoardListVO boardListVO, BoardVO boardVO) throws Exception;
	
	public List<HashMap<String, Object>> getMyNoticePostItem(LoginVO userInfo, String type, int start, int end) throws Exception;
	
	public List<HashMap<String, Object>> getMyBoardListItem(LoginVO userInfo, int startRow, int endRow, int boardCount, String orderOption1, String orderOption2) throws Exception;

	public List<HashMap<String, Object>> getMyBoardListItemTemp(LoginVO userInfo, int startRow, int endRow, int boardCount, String orderOption1, String orderOption2) throws Exception;
	
	public List<HashMap<String, Object>> getApprBoardListItem(LoginVO userInfo, int startRow, int endRow, int boardCount, String orderOption1, String orderOption2) throws Exception;
	
	public List<HashMap<String, Object>> getSearchMyBoardItemList(BoardListVO boardListVO, BoardVO boardVO) throws Exception;

	public List<HashMap<String, Object>> getSearchMyBoardItemListTemp(BoardListVO boardListVO, BoardVO boardVO) throws Exception;
	
	public List<BoardAccessVO> getPostNotiMailUserList(String boardID, String primary, int tenantID) throws Exception;
	
	public List<String> getCopyItemAttach(String orgItemID, int tenantID) throws Exception;
	
	public BoardPropertyVO getBoardProperty(String pBoardID, int tenantID) throws Exception;
	
	public BoardConfigVO getPersonalCount(LoginVO userInfo) throws Exception;

	public BoardConfigVO getBoardList_Config(String userId, int tenantID) throws Exception;
	
	public BoardListVO getBrdGetItemInfo(String boardID, String itemID, String multiLang, int tenantID) throws Exception;
	
	public BoardListVO getItemInfo(String mode, String itemID, String lang, int tenantID) throws Exception;
	
	public BoardListVO getCopyItem(String orgItemID, String orgBoardID, int tenantID) throws Exception;
	
	public BoardListVO getBrdGetItemInfoTemp(String boardID, String itemID, String multiLang, int tenantID) throws Exception;
	
	public String getBoardProperty(String pBoardID, BoardPropertyVO boardInfo, LoginVO userInfo) throws Exception;
	
	public String get_parentBoardName(String BoardIdList, int boardIdListCount, String primary, int tenantID, Locale locale) throws Exception;
	
	public String checkForm(String boardID, String mode, int tenantID) throws Exception;

	public String checkBackGroundImage(String boardID, int tenantID) throws Exception;

	public String brdCheckIfHasReply(String itemID, int tenantID) throws Exception;
	
	public String getNoticePostItemAll(String boardID, int tenantID) throws Exception;
	
	public String getParentBoardID(String boardID, int tenantID) throws Exception;
	
	public String getDocPassWord(String itemID, int tenantID) throws Exception;
	
	public String getItemXML(String boardID, String itemID, String lang, String offset, int tenantID) throws Exception;

	public String getItemTempXML(String boardID, String itemID, String lang, String offset, int tenantID) throws Exception;
	
	public String setBoardConfig(String userID, int listCount, String preView, int tenantID) throws Exception;
	
	public String apprItem(String userID, String itemList, String pMod, int tenantID) throws Exception;
	
	public String deleteOneLineReply(String id, String replyID, String guBun, int tenantID) throws Exception;
	
	public String checkOneLineOwner(String replyID, String userID, int tenantID) throws Exception;
	
	public String portalPageItemEdit(String boardID, int tenantID) throws Exception;
	
	public String getBoardTree(String pRootBoardID, String userID, String deptID, String companyID, int pMode, int pSubFlag, int pSelectBy, String pExcludeBoardID, String lang, int tenantID) throws Exception;
	
	public int getReservedItemListCount(String userID, int tenantID) throws Exception;
	
	public int getNewItemListCount(LoginVO userInfo) throws Exception;

	public int getBrdNewItemCount(String userID, int tenantID) throws Exception;

	public int getThumbNailCount(BoardMyFavoriteVO myFavoriteVO) throws Exception;

	public int getBrdTotalItemCount(BoardMyFavoriteVO myFavoriteVO)  throws Exception;

	public int getQNABrdTotalItemCount(BoardMyFavoriteVO myFavoriteVO) throws Exception;
	
	public int getNoticePostItemCount(BoardVO boardVO) throws Exception;

	public int getCheckItemID(String itemID, String boardType, String userDeptPath, int tenantID) throws Exception;
	
	public int getCheckApprUserList(String id, String itemID, int tenantID) throws Exception;
	
	public int getSearchBoardItemCount(BoardVO boardVO) throws Exception;
	
	public int checkApprUserList(String userID, String itemID, int tenantID) throws Exception;
	
	public int getMyBoardTotalItemCount(LoginVO userInfo) throws Exception;

	public int getMyBoardTotalItemCountTemp(LoginVO userInfo) throws Exception;
	
	public int getMyNoticePostItemCount(LoginVO userInfo) throws Exception;
	
	public int getSearchMyBoardItemCount(LoginVO userInfo, BoardVO boardVO) throws Exception;

	public int getSearchMyBoardItemCountTemp(LoginVO userInfo, BoardVO boardVO) throws Exception;
	
	public int getItemViewNew(String boardID, String itemID, int tenantID) throws Exception;
	
	public int getApprBoardTotalItemCount(LoginVO userInfo) throws Exception;
	
	public int getUnreadItemsCount(String userID, String boardID, int tenantID) throws Exception;
	
	public void brdNewItem(BoardListVO boardListVO) throws Exception;
	
	public void brdNewItemPhoto(BoardListVO boardListVO) throws Exception;
	
	public void brdNewItemTemp(BoardListVO boardListVO) throws Exception;
	
	public void brdNewItemTempPhoto(BoardListVO boardListVO) throws Exception;
	
	public void photoListInsert(BoardListVO boardListVO) throws Exception;
	
	public void brdUpdateItem(BoardListVO boardListVO, String mode) throws Exception;

	public void saveOneLineReply(String itemID, String replyID, String boardID, LoginVO userInfo, String content, String password) throws Exception;
	
	public void setBoardList_Config(BoardConfigVO boardConfigVO) throws Exception;

	public void setAsRead(LoginVO userInfo, String boardID, String itemID) throws Exception;

	public void setTabUsed(String pUserID, String pBoardList, String tabUsed, int tenantID) throws Exception;
	
	public void setMainImageID(String mainImageID, String itemID, int tenantID) throws Exception;
	
	public String setNotiOrder(String itemID, int tenantID) throws Exception;
	
	public void photoListUpdate(String imageID, String boardID, String content, String file_Path, String itemID, String mainFg, String oFileName, int tenantID) throws Exception;

	public void updateCopyItem(String itemID, int tenantID) throws Exception;
	
	public void updateMoveItem(String destItemID, String orgItemID, int tenantID) throws Exception;
	
	public void setBoardList_Config2(String userID, String listCount, String previewMode, String list, String content, int tenantID) throws Exception;
	
	public void photoListAlbumEdit(String boardID, String itemID, String title, String content, int tenantID) throws Exception;
	
	public void photoListAlbumEditTemp(String boardID, String itemID, String title, String content, int tenantID) throws Exception;
	
	public void deleteItem(String mode, String itemID, String boardID, String realPath, int tenantID) throws Exception;

	public void photoListDel(String boardID, String imageID, int tenantID) throws Exception;

	public void setListOrder(LoginVO userInfo, String pBoardList, String pDelBoardList) throws Exception;
	
	public String getItemAttachmentXMLRetrans(BoardItemVO boardItemVO) throws Exception;

	public String getItemAttachmentXML(BoardItemVO boardItemVO) throws Exception;

	public List<BoardListVO> getReplyNoticeMail(String boardID, String itemTreeID, String lang, int tenantID) throws Exception;

	public List<LoginVO> getSendApprMailList(String boardID, String lang, int tenantID) throws Exception;

	public String saveImageItem(String requestXML, String realPath, LoginSimpleVO userInfo) throws Exception;

	public String newItemPhoto(Document doc, String mode, String realPath, LoginVO userInfo, String mainImageID) throws Exception;

	public boolean saveAttachmentsInfo(String attachments, String itemID, String boardID, String filePath, String strType, String realPath, int tenantID) throws Exception;

	public boolean saveMHT(String mainContent, String itemID, String boardID, String filePath, String string, String realPath) throws Exception;

	public String getReverseDateNow() throws Exception;

	public String getContentInfo(String type, String docID, int tenantID) throws Exception;

	public BoardAttachVO getAttachInfo(String itemID, String attID, int tenantID) throws Exception;

	public String deleteTempItem1(String mode, String strItemID, int tenantID) throws Exception;

	public int photoViewDBCount(String itemID, String boardID, int tenantID) throws Exception;

	public String getThumbListXML(LoginVO userInfo, String pBoardType, String pBoardID, int pPageNum, String pOrderCell, String pOrderOption) throws Exception;

	public String getOneLinePassWord(String replyID, String itemID, int tenantID) throws Exception;

	public String deleteItem(String itemList, String mode, String boardID, String realPath, LoginVO userInfo, BoardPropertyVO boardInfo) throws Exception;

	public void deleteExpiredItems(String realPath) throws Exception;

	public void deleteReservedBoard(String realPath) throws Exception;

	public void deleteReservedBoardItem(String realPath) throws Exception;

	public String moveItem(String orgItemIDList, String orgBoardID, String destBoardID, LoginVO userInfo, String uploadFilePath, String realPath) throws Exception;

	public String copyAttachments(String orgBoardID, String destItemID, String destBoardID, List<String> attachmentList, String path, String mode, int tenantID) throws Exception;

	public String insertNewItem(Document doc, String pMode, String realPath, LoginVO userInfo) throws Exception;

	public void copyFiles(String orgItemID, String orgBoardID, String destItemID, String destBoardID, String path, String mode) throws Exception;

	public String copyItem(String orgItemIDList, String orgBoardID, String destBoardID, String uploadFilePath, String realPath, LoginVO userInfo) throws Exception;

}
