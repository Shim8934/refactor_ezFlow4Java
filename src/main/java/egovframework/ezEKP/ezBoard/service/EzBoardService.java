package egovframework.ezEKP.ezBoard.service;

import java.util.ArrayList;
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
import egovframework.ezEKP.ezBoard.vo.BoardPollConfigVO;
import egovframework.ezEKP.ezBoard.vo.BoardPropertyVO;
import egovframework.ezEKP.ezBoard.vo.BoardVO;
import egovframework.let.user.login.vo.LoginSimpleVO;
import egovframework.let.user.login.vo.LoginVO;

public interface EzBoardService {

	public List<BoardVO> getLeft_BoardSTD(String redirectBoardID, int tenantID) throws Exception;
	
	public List<BoardVO> get_apprUserList(String boardID, int tenantID) throws Exception;

	/* 2018-06-27 홍승비 - 즐겨찾기 탭 표출 시 companyID 조건 추가 */
	public List<BoardMyFavoriteVO> get_favoriteList(String userID, String pMode, String companyID, int tenantID) throws Exception;

	/* 2019-04-05 홍승비 - DB에 존재하지 않는 헤더 임의로 추가하는 경우 다국어 지원을 위해 userInfo 추가 */
	public List<BoardListHeaderVO> getListHeader(LoginVO userInfo, BoardVO ezBoardVO) throws Exception;
	
	public List<BoardListHeaderVO> getListHeaderBoardID(LoginVO userInfo, BoardVO ezBoardVO) throws Exception;
	
	public List<BoardAttachVO> brdGetItemAttachmentInfo(String pItemID, int tenantID) throws Exception;
	
	/* 2018-07-17 홍승비 - 사원정보 확인용 deptID를 위해 companyID 조건 추가 */
	public StringBuffer getReaderList(String boardID, String itemID, String userID, String lang, String companyID, int tenantID, int pageNum, int perCount, String offset) throws Exception;
	
	public List<BoardListVO> getAdjacentItems1(String boardID, String parentWriteDate, String upperItemIDTree, int tenantID) throws Exception;
	
	public List<BoardListVO> getAdjacentItems2(String boardID, String parentWriteDate, int tenantID) throws Exception;
	
	public List<BoardListVO> getAdjacentItems3(String boardID, String parentWriteDate, String itemID, String upperItemIDTree, String previousItemID, int tenantID) throws Exception;
	
	public List<BoardListVO> getAdjacentItems2Photo(String boardID, String parentWriteDate, int tenantID) throws Exception;

	public List<BoardListVO> getAdjacentItems3Photo(String boardID, String parentWriteDate, int tenantID) throws Exception;
	
	public List<BoardAttachVO> photoViewDB(String itemID, String boardID, int pStartRow, int pEndRow, int tenantID) throws Exception;
	
	public List<BoardAttachVO> photoViewDBAll(String itemID, String boardID, int tenantID) throws Exception;
	
	/* 예약게시물 표출 시 companyID 조건 추가 */
	public List<BoardListVO> getReservedItemList(String userID, int startRow, int endRow, String sortBy, String lang, String offset, String companyID, int tenantID) throws Exception;
	
	/* 2018-10-19 홍승비 - 익명게시물의 댓글 표출조건 gubun값 추가 */
	/* 2018-07-02 홍승비 - 댓글 확인 시 작성자정보에 deptID 추가(작성자의 겸직정보 표시를 위해) */
	public List<BoardLineReplyVO> readOneLineReply(String boardID, String itemID, String userName, String gubun, String companyID, int tenantID) throws Exception;
	
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
	
	public BoardListVO getCopyItem(String orgItemID, int tenantID) throws Exception;
	
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
	
	/* 2018-06-26 홍승비 - 승인게시물 표출 조건으로 companyID 추가 */
	public String apprItem(String userID, String itemList, String pMod, String companyID, int tenantID) throws Exception;
	
	public String deleteOneLineReply(String id, String replyID, String guBun, int tenantID) throws Exception;
	
	public String checkOneLineOwner(String replyID, String userID, int tenantID) throws Exception;
	
	public String portalPageItemEdit(String boardID, int tenantID) throws Exception;
	
	/* 2019-06-05 홍승비 - 사간겸직시 변경된 관리자권한(rollInfo) 전달하도록 파라미터 추가 */
	/* 2018-10-16 홍승비 - 관리자단에서 접근했는지 판단하는 isAdminLeft 플래그를 인자로 추가 */
	/* 2018-06-25 홍승비 - 자신의 회사에 속한 게시판만 표출하도록 compamyID 조건 추가 */
	public String getBoardTree(String pRootBoardID, String userID, String deptID, String companyID, int pMode, int pSubFlag, int pSelectBy,
			String pExcludeBoardID, String lang, String isAdminLeft, boolean isCompanyAdmin, String boardGroupAdmin_FG, String rollInfo, int tenantID) throws Exception;
	
	/* 예약게시물 카운트 표출 시 companyID 조건 추가 */
	public int getReservedItemListCount(String userID, String companyID, int tenantID) throws Exception;
	
	public int getNewItemListCount(LoginVO userInfo) throws Exception;

	public int getBrdNewItemCount(String userID, int tenantID) throws Exception;

	public int getThumbNailCount(BoardMyFavoriteVO myFavoriteVO) throws Exception;

	public int getBrdTotalItemCount(BoardMyFavoriteVO myFavoriteVO)  throws Exception;

	public int getQNABrdTotalItemCount(BoardMyFavoriteVO myFavoriteVO) throws Exception;
	
	public int getNoticePostItemCount(BoardVO boardVO) throws Exception;

	/* 2019-05-31 홍승비 - 게시물 읽기권한 가져올 때 하위부서 허용/불가여부 체크하도록 수정 */
	public int getCheckItemID(String itemID, String boardType, String userDeptPath, int tenantID, int isDept, int isEqualDept) throws Exception;
	
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

	/* 2018-06-27 홍승비 - 즐겨찾기 탭 회사별로 구분 */
	public void setTabUsed(String pUserID, String pBoardList, String tabUsed, String companyID, int tenantID) throws Exception;
	
	public void setMainImageID(String mainImageID, String itemID, int tenantID) throws Exception;
	
	public String setNotiOrder(String itemID, int tenantID) throws Exception;
	
	public void photoListUpdate(String imageID, String boardID, String content, String file_Path, String itemID, String mainFg, String oFileName, int tenantID) throws Exception;

	/* 2019-12-16 홍승비 - 게시물 복사 시 조회자 정보를 유지하기 위한 파라미터 추가 */
	public void updateCopyItem(String destItemID, String orgItemID, String destBoardID, String orgBoardID, int tenantID) throws Exception;
	
	/* 2019-12-13 홍승비 - 게시물 이동 시 조회자 정보를 유지하기 위한 게시판ID 파라미터 추가 */
	public void updateMoveItem(String destItemID, String orgItemID, String destBoardID, String orgBoardID, int tenantID) throws Exception;
	
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

	public String moveItem(String orgItemIDList, String orgBoardIDList, String destBoardID, LoginVO userInfo, String uploadFilePath, String realPath) throws Exception;

	public String copyAttachments(String orgBoardID, String destItemID, String destBoardID, List<String> attachmentList, String path, String mode, int tenantID) throws Exception;

	public String insertNewItem(Document doc, String pMode, String realPath, LoginVO userInfo) throws Exception;

	public void copyFiles(String orgItemID, String orgBoardID, String destItemID, String destBoardID, String path, String mode) throws Exception;

	public String copyItem(String orgItemIDList, String orgBoardID, String destBoardID, String uploadFilePath, String realPath, LoginVO userInfo) throws Exception;

	public BoardPollConfigVO getPollConfig(String pUserID, int tenantId) throws Exception; //baonk added

	public void saveBoardPollConfig(BoardPollConfigVO boardPollConfigVO) throws Exception; //baonk added

	//2017.12.29 강민수92
	public String getOneLineReplyCount(String boardID, String itemID, int tenantID) throws Exception;

	//2018.02.05 김보미
	public int getReaderListCount(String boardID, String itemID, String userID, String lang, int tenantID) throws Exception;

	//2018.04.16 홍승비
	public void setAsReadNew(LoginVO userInfo, String pBoardID, String string) throws Exception;
	
	//2018-05-09 강민수92
	public void moveOneLineReply(String orgBoardID, String orgItemID, String destBoardID, String destItemID) throws Exception;

	//2018-06-07 김혜정
	public List<HashMap<String, Object>> getSearchAllBoardItemList(LoginVO userInfo, BoardListVO boardListVO, BoardVO boardVO, ArrayList<String> listviewTrueList, ArrayList<String> qnaItemList, int pMode) throws Exception;

	//2018-06-08 김혜정
	public int getSearchAllBoardItemCount(LoginVO userInfo, BoardVO boardVO, ArrayList<String> listviewTrueList, ArrayList<String> qnaItemList, int pMode) throws Exception;
	
	//2018-06-11 홍승비
	public String getLastImageID(String boardID, String itemID, int tenantID) throws Exception;
	
	//2018-06-28 홍승비 - 승인게시물 검색용 메서드 추가
	public int getSearchApprBoardItemCount(LoginVO userInfo, BoardVO boardVO) throws Exception;
	
	public List<HashMap<String, Object>> getSearchApprBoardItemList(BoardListVO boardListVO, BoardVO boardVO) throws Exception;
	
	// 20181210 김윤진 - ezTalk Notice Board ID 가져오기.
	public String getEzTalkGateNoticeBoardId(String companyID, int tenantID) throws Exception;
	
	/* 2019-01-15 홍승비 - 수정일(updateDate)만을 업데이트하는 쿼리 추가 */
	public void modUpdateDate(String updateDate, String itemID, int tenantID) throws Exception;
	
	/* 2019-04-05 홍승비 - 좋아요 삽입 */
	public void likeInsert(String userID, String itemID, int tenantID) throws Exception;
	/* 2019-04-05 홍승비 - 좋아요 삭제 */
	public void likeDelete(String userID, String itemID, int tenantID) throws Exception;
	/* 2019-04-05 홍승비 - 좋아요 여부 체크 */
	public String likeCheck(String userID, String itemID, int tenantID) throws Exception;
	/* 2019-04-05 홍승비 - 좋아요 갯수 가져오기 */
	public int getLikeCount(String itemID, int tenantID) throws Exception;
	
	/* 2019-04-10 홍승비 - 사용자가 원회사이고 사내겸직이 존재하면 사내겸직부서ID를 리턴 */
	public List<String> getPDOAddJobDeptID(String userID, String companyID, int tenantID) throws Exception;
	
	/* 2019-05-15 홍승비 - 해당 부서ID로 상위부서ID(회사포함) 가져오기*/
	public String getUpperDeptID(String deptID, int tenantID) throws Exception;
	
	/* 2019-05-29 홍승비 - 해당 ID가 부서(회사)ID인지 확인하는 기능 서비스로 분리 */
	public int isDeptChk(String id, int tenantID) throws Exception;

	/* 2019-11-08 홍승비 - 해당 게시판을 포함하여 하위에 속한 모든 게시판들을 가져오는 메서드 */
	public List<BoardPropertyVO> getAllSubBoardProperty(String boardID, int tenantID) throws Exception;

	/* 2019-11-08 홍승비 - 주어진 게시판ID에 대하여, 새로운 BOARDTREEPATH를 생성해 리턴하는 메서드 */
	public String getNewBoardTreePath(String subBoardID, int tenantId) throws Exception;

	/* 2020-07-14 홍승비 - 선택한 마이게시판 분류 하위에 해당 게시판이 존재하는지 리턴 */
	public String isMyBoardExist(String treeID, String boardID, String userID, int tenantID, String companyID) throws Exception;
	
	/* 2019-09-18 홍승비 - 사용자의 직위와 직책 ID를 전부 문자열로 이어붙여 리턴하는 메서드 (사내겸직 포함) */
	public String getUserJJID(String userID, String companyID, int tenantID) throws Exception;
	
	/* 2019-09-18 홍승비 - 그룹권한을 포함하여 ACCESSID에 대한 권한정보를 리스트로 리턴하는 메서드 */
	public List<BoardPropertyVO> getACLListNew(String pBoardID, String accessID, int tenantID, int isDept, int isEqualDept) throws Exception;
	
	/* 2019-09-18 홍승비 - 그룹권한을 포함하여 ACCESSID에 대한 게시판 그룹의 관리자 권한을 리스트로 리턴하는 메서드 */
	public List<String> checkIfBoardGroupAdminNew(String pRootBoardID, String accessID, int tenantID, int isDept, int isEqualDept, boolean isBoardGroup) throws Exception;

	/* 2019-09-24 홍승비 - 그룹권한을 포함하여 ACCESSID에 대한 게시판 읽기권한을 리스트로 리턴하는 메서드 */
	public List<String> getCheckItemIDNew(String itemID, String boardType, String userDeptPath, int tenantID, int isDept, int isEqualDept) throws Exception;

	/* 2020-06-15 홍승비 - 주어진 게시판ID에 대하여 즐겨찾기 여부를 판단하는 메서드 */
	public int getIsMyBoardExist(String boardID, String userID, int tenantID, String companyID) throws Exception;

	/* 2020-06-15 홍승비 - 즐겨찾기 게시판 단일 삭제 메서드 */
	public void deleteMyBoards(String boardID, String userID, int tenantID, String companyID) throws Exception;
	
	/* 2019-10-11 홍승비 - 회사별 공지사항 게시판ID를 리턴하는 메서드 */
	public String getCompanyNoticeBoardID( String companyID, int tenantID) throws Exception;
	
	/* 2020-12-03 박기범 - 회사별 탭게시판에 등록된 탭ID,boardid, boardname을 리턴하는 메서드 */
	public List<HashMap<String, Object>> getCompanyTabBoardIDList(String companyID, int tenantID) throws Exception;
	
	public int getOneLineCNT(String itemID, int tenantID) throws Exception;

	/* 2021-01-06 홍승비 - 게시물의 읽음여부 판별 시, 현재 사용자가 읽은 게시물을 셀렉트하도록 수정 */
	public int getReaderListCount2(String boardID, String itemID, String userID, int tenantID) throws Exception;
	
	/* 2021-06-23 홍승비 - 그룹권한을 포함하여 ACCESSID에 대한 게시판 접근 + 리스트보기 권한을 리스트로 리턴하는 메서드 (QNA게시판은 관리자권한 체크) */
	public List<String> getBoardAccessListViewFG(String boardID, String gubun, String userDeptPath, int tenantID, int isDept, int isEqualDept) throws Exception;

	/* 2021-06-23 홍승비 - 게시/수정알림 메일 발송을 위한 사용자 정보를 map 리스트로 리턴하는 메서드 */
	public List<HashMap<String, String>> getBoardUserInfoForMailSend(String isAllGroupBoard, String primary, String companyID, int tenantID) throws Exception;
	
	/* 2021-06-23 홍승비 - 댓글알림 메일 발송을 위한 사용자 정보를 map으로 리턴하는 메서드 */
	public List<HashMap<String, String>> getCommentNoticeMail(String boardID, String itemID, String lang, int tenantID) throws Exception;
	
	/* 2023-03-07 이가은 - userID를 조건으로 댓글 반응 여부(좋아요 : Y / 싫어요 : N / 미선택 : 공백 또는 null) 리턴하는 메서드 */
	public String checkReactUser(String itemID, String replyID, String userID, int tenantID) throws Exception;
	
	/* 2023-03-07 이가은 - 댓글 반응 추가하는 메서드 */
	public void inserBoardReact(String itemID, String replyID, String userID, String reactFlag, int tenantID, String companyID, String reactDate) throws Exception;
	
	/* 2023-03-07 이가은 - 댓글 반응 삭제하는 메서드 */
	public void deleteBoardReact(String itemID, String replyID, String userID, int tenantID) throws Exception;
	
	/* 2023-03-07 이가은 - 댓글 삭제되었을 경우 반응 모두 삭제하는 메서드 */
	public void allReactDelete(String itemID, String delReplyID, int tenantID) throws Exception;
	
	/* 2023-03-08 이가은 - 게시물에 대한 사용자의 댓글 반응 HashMap List로 리턴하는 메서드 */
	public List<HashMap<String, String>> getUserReplyReact(String itemID, String userID, int tenantID) throws Exception;
	
	/* 2023-03-08 이가은 - 댓글 존재여부 리턴하는 메서드 */
	public int checkReplyID(String itemID, String replyID, int tenantID) throws Exception;
}
