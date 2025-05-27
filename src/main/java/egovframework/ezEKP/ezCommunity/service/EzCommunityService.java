package egovframework.ezEKP.ezCommunity.service;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.ui.Model;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.w3c.dom.Document;

import egovframework.ezEKP.ezCommunity.vo.CommunityBoardInfoVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityBoardItemAttachmentVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityBoardItemVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityBoardListVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityBoardPropertyVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityCBoardVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityCCategoryVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityCClubGuestVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityCClubUserVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityCComCloseVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityCPollManagerVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityCPollQuestionVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityCPollResponseVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityClubVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityMemberInfoVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityOneLineReplyVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityMemberGradeVO;
import egovframework.let.user.login.vo.LoginVO;

public interface EzCommunityService {
	public List<CommunityCBoardVO> bbsListGet2(String bName, String primary, String pKeyword, String sRadio, int tenantID, String companyID) throws Exception;
	
	public List<CommunityCBoardVO> bbsViewNewGet2(String bName, int tenantID) throws Exception;
	
	public List<CommunityCBoardVO> getLeftBoardList(int tenantID) throws Exception;

	/* 2024-01-22 홍승비 - 커뮤니티 게시판 댓글 표출 시 게시판 구분값 분기 추가 */
	/* 2018-07-17 홍승비 - 사원정보 deptID 파라미터 선택을 위해 companyID 조건 추가 */
	public List<CommunityOneLineReplyVO> readOneLineReply(String primary, String pBoardID, String pItemID, String companyID, int tenantID, String offset, String gubun) throws Exception;
	
	/* 커뮤니티 게시물 조회자 정보 가져올 때 deptID도 함께 가져오도록 수정(companyID 조건 추가) */
	public StringBuffer getReaderList(String pBoardID, String pItemID, String string, String string2, String companyID, int tenantID, int pageNum, int perCount, String offset) throws Exception;

	public List<CommunityCPollResponseVO> pollETCTableGet(String questionID, int tenantID) throws Exception;
	
	public List<CommunityCCategoryVO> mainPageGet4(String cat, int tenantID) throws Exception;
	
	/* 2018-06-21 홍승비 - 커뮤니티 메인홈 하단 카테고리별 커뮤니티 표출 companyID 조건 추가 */
	public List<CommunityClubVO> categoryListGet(String type, String mode, int startRow, int endRow, int mariaStart, int mariaEnd, String companyID, int tenantID) throws Exception;
	
	/* 2018-06-21 홍승비 - 커뮤니티 메인홈 하단 카테고리별 커뮤니티 검색 companyID 조건 추가 */
	public List<CommunityClubVO> searchCop(String search, String keyword, int startRow, int endRow, String mode, String companyID, int tenantID) throws Exception ;
	
	/* 2020-08-31 홍승비 - 자신이 가입한 커뮤니티 표출 시 소팅 여부 조건 추가 */
	public List<CommunityClubVO> getLeftCommunity(LoginVO userInfo, String sortByClubno) throws Exception;
	
	public List<CommunityBoardInfoVO> commHomeBoardInfo(String code, int tenantID) throws Exception;
	
	/* 2018-05-18 홍승비 - UTC시간에 offset을 적용한 writeDate를 가져오기 위해 offset 추가*/
	public List<CommunityBoardItemVO> commHomeBoardItemList(String boardID, int tenantID, String offset) throws Exception;
	
	public List<CommunityClubVO> adminNoticeMailOkGet2(String code, int tenantID) throws Exception;
	
	public CommunityCBoardVO bbsViewNewGet1(String bName, String no, int tenantID, String offset) throws Exception;
	
	public CommunityCBoardVO bbsEditNew(String bName, String no, String lang, int tenantID) throws Exception;
	
	public CommunityCBoardVO bbsDelOkGet(String bName, String itemNo, String code, int tenantID) throws Exception;
	
	public CommunityClubVO aspCommInfoGet1(String code, int tenantID) throws Exception;
	
	public CommunityClubVO adminLeftGet(String code, int tenantID) throws Exception;
	
	public CommunityClubVO adminLogoGet(String code, String primary, int tenantID) throws Exception;
	
	public CommunityClubVO adminLogoGet2(String code, int tenantId) throws Exception;
	
	public CommunityClubVO adminCommCloseOkGet2(String code, int tenantID) throws Exception;
		
	public CommunityClubVO adminNoticeMailOkGet1(String code, int tenantID) throws Exception;
	
	public CommunityClubVO joinOkGet3(String code, String lang, int tenantID) throws Exception;
	
	/* 2018-06-21 홍승비 - 오늘의 커뮤니티 표출 companyID 조건 추가 */
	public CommunityClubVO todayCopGet2(int num, String companyID, int tenantID) throws Exception;
	
	public CommunityClubVO boardItemListPhotoGet1(String id, String boardID, int tenantID) throws Exception;
	
	public CommunityClubVO leftCommunityGet4(String code, String companyID, int tenantID)throws Exception;
	
	public CommunityBoardPropertyVO getBoardInfo(LoginVO userInfo, String pBoardID) throws Exception;
	
	public CommunityBoardPropertyVO brdGetACL(String pBoardID, String pAccessID, int tenantID) throws Exception;

	public CommunityBoardPropertyVO getBoardProperty(String pBoardID, int tenantID) throws Exception;
	
	public CommunityBoardListVO boardItemListGet1(String pBoardID, String id, int tenantID) throws Exception;
	
	public CommunityBoardItemVO getItemXML(String pBoardID, String pItemID, LoginVO usreInfo) throws Exception;
	
	public CommunityCClubGuestVO guestEditGet(String code, String primary, String no, String id, int tenantID) throws Exception;
	
	public CommunityCPollManagerVO pollEditGet1(String managerID, int tenantID) throws Exception;

	public CommunityCPollQuestionVO pollEditGet2(String managerID, int tenantID) throws Exception;

	public CommunityMemberInfoVO commOutGet(String cSysopID, String companyID, String primary, int tenantID) throws Exception;
	
	/* 겸직사원의 커뮤니티 선택 시 companyID로 조건 추가 */
	public CommunityMemberInfoVO aspCommInfoGet2(String primary, String sysopID, String companyID, int tenantID) throws Exception;
	
	public CommunityMemberInfoVO getMemberInfo(String companyID, String cID, int tenantID) throws Exception;
	
	public CommunityMemberInfoVO joinOkGet4(String companyID, String id, int tenantID) throws Exception;

	public CommunityCClubUserVO adminMemberListOkGet(String code, String cID, String companyID, int tenantID) throws Exception;

	public CommunityCComCloseVO adminCommCloseOkGet1(String code, int tenantID) throws Exception;
	
	/* 2018-06-21 홍승비 - 커뮤니티 메인홈 하단 카테고리별 커뮤니티 표출 companyID 조건 추가 */
	public CommunityCCategoryVO mainPageCategory(String c_Code, String cat, String companyID, int tenantID) throws Exception;
	
	public Map<String, String> getAdjacentItemsPhoto(String boardID, CommunityBoardItemVO item, int tenantID, String offset) throws Exception;
	
	public String goAdminOkGet2(String pClubID, LoginVO userInfo) throws Exception;
	
	public String commHomeInfo(LoginVO userInfo, String code, HttpServletRequest request) throws Exception;
	
	public String upload(MultipartHttpServletRequest request, HttpServletResponse response, LoginVO userInfo) throws Exception;
	
	public String confirmPassword(String itemID, String newPassword) throws Exception;
	
	public String bbsList(LoginVO userInfo, List<CommunityCBoardVO> cBoardList, String code, int curPage, String bName, int comNoPerPage) throws Exception;
	
	public String bbsEditOk(LoginVO userInfo, HttpServletRequest request) throws Exception;
	
	public String bbsDelOk(LoginVO userInfo, HttpServletRequest request, CommunityCBoardVO board, String itemNo, String goToPage, String bName, int adminCheck, int tenantID) throws Exception;
	
	public String guestOne(LoginVO userInfo, String sRadio, String keyword, String code, int comNoPerPage, int curPage) throws Exception;
	
	public String pollMain(LoginVO userInfo, String code) throws Exception;
	
	public String pollAddOk(int sel, String selType, String selRes, int selectedNo, int answerCount, Model model, LoginVO userInfo) throws Exception;
	
	public String commViewMember(LoginVO userInfo, String code, String strSysopID, String keyword, String sRadio, int comNoPerPage, int curPage, String selectGrade) throws Exception;
	
	public String adminHomeBoard1(LoginVO userInfo, String code) throws Exception;
	
	public String adminHomeBoard2(LoginVO userInfo, String code) throws Exception;
	
	public String adminHomeBoard3(LoginVO userInfo, String code) throws Exception;
	
	public String adminOuterList(LoginVO userInfo, String code) throws Exception;

	public String adminMemberList(LoginVO userInfo, String code, String flag, String ser, String strSysopID, String mode) throws Exception;
	
	public String myCopNewBoardItem(LoginVO userInfo, int startRow, int endRow) throws Exception;

	public String getBestNewCommunity(LoginVO userInfo, String mode) throws Exception;

	public String leftCommunityGet1(String code, String userInfoUserID, String companyID, int tenantID) throws Exception;

	public String getCommunityThumInfo(String pBoardID, String pFileName, String pType, int tenantID) throws Exception;
	
	public String getBoardTitleName(String strBoardName, String strClubNo, int tenantID) throws Exception;
	
	public String bbsEditGet1(String bName, String no, int tenantID) throws Exception;
	
	public String getFileFolderName(String bName) throws Exception;
	
	public String commHomeGet1(String id, String code, int tenantID) throws Exception;
	
	public String commHomeGet4(String code, int tenantID) throws Exception;
	
	public String getBoardTree(String pRootBoardID, String pUserID, String pDeptID, String pCompanyID, int pMode, int pSubFlag, int pSelectBy, String pExcludeBoardID, String pClubNo, String primary, int tenantID) throws Exception;
	
	public String checkIfBoardGroupAdmin(String pRootBoardID, String id, String deptID, String companyID, int tenantID) throws Exception;

	public String getCategory(String strSelCateA, String strSelCateB, String strSelCateC, LoginVO userInfo) throws Exception;
	
	public String searchItemXML(LoginVO userInfo, String boardID, String title, String writerName, String abstracts, String searchStart, String searchEnd, int pStartRow, int pEndRow) throws Exception;
	
	public String checkIfHasReply(String itemList, int tenantID) throws Exception;

	public String newItem(Document xmlData, String pMode, String realPath, LoginVO userInfo) throws Exception;
	
	public String getItemAttachmentXML(String itemID, int tenantID, String realPath, String pMode) throws Exception;
	
	public String getReservedItemListXML(String id, int pStartRow, int pEndRow, String pSortBy, String primary, int tenantID, String offset) throws Exception;

	public String checkReplyPassword(String pItemID, String pReplyID, int tenantID) throws Exception;

	public String getACL(String id, String pComID, int tenantID) throws Exception;

	public String copyItem(String pOrgItemID, String pOrgBoardID, String pDestItemID, String pDestBoardID, String realPath, LoginVO userInfo) throws Exception;

	public String pollMainGet1(String id, String code, int tenantID) throws Exception;

	public String adminMemberListGet2(String code, int tenantID) throws Exception;
	
	public String categoryPrint(String c_Cate_A, String c_Cate_B, String c_Cate_C, LoginVO userInfo) throws Exception;

	public String commOutOk(HttpServletRequest request, String loginCookie, String code, String reason) throws Exception;

	public String adminBasicGet1(String code, int tenantID) throws Exception;

	public String adminBasicGet2(String code, int tenantID) throws Exception;
	
	public String saveBoardOrder(String xmlData, int tenantID) throws Exception;
	
	public String moveBoard(String orgBoardID, String newParentBoardID, String newBoardGroupID, int tenantID) throws Exception;

	public String brdDeleteBoard(String boardID, int tenantID) throws Exception;

	public String adminSearchItemXML(LoginVO userInfo, String boardID, String title, String writerName, String abstracts, String searchStart, String searchEnd, int pStartRow, int pEndRow) throws Exception;
	
	public String saveBoardProperty(LoginVO userInfo, CommunityBoardInfoVO vo) throws Exception;
	
	public String checkOneLineOwner(String pReplyID, String id, int tenantID) throws Exception;
	
	public String setAsRead(LoginVO userInfo, String boardID, String itemIDList) throws Exception;
	
	public String join1Get(String no, String lang, int tenantID) throws Exception;

	public String joinGet1(String code, String lang, int tenantID) throws Exception;

	public String joinGet2(String sysopID, String companyID, String lang, int tenantID) throws Exception;

	public String joinOkGet1(String code, String id, int tenantID) throws Exception;

	public String joinOkGet2(String code, String id, int tenantID) throws Exception;
	
	public String getACLGet1(String cID, int tenantID) throws Exception;

	public String getACLGet2(String uID, String cID, int tenantID) throws Exception;

	public String adminMemPermit(LoginVO userInfo, String code) throws Exception;
	
	public String todayCopGet3(String c_Cate, String type, int tenantID) throws Exception;
	
	public String getNewItemListXML(LoginVO userInfo, int pStartRow, int pEndRow, String pSortBy) throws Exception;
	
	public String getBoardListItemPhotoXML(LoginVO userInfo, String pBoardID, int pStartRow, int pEndRow, String pSortBy) throws Exception;

	public String leftCommunityGet2(String code, String companyID, int tenantID) throws Exception;
	
	public String checkPassword(String pItemID, int tenantID) throws Exception;
	
	public String adminLogoUpload(String code, String realPath, String logoPath, MultipartFile logoFile, int tenantId) throws Exception;
	
	public String adminThumbUpload(String code, String realPath,String thumbPath, MultipartFile thumbFile, int tenantId) throws Exception;
	
	public String getMyCoummunityBoardList(LoginVO userInfo, String clubNo) throws Exception;
	
//	public String getContentInfo(String type, String itemID, int tenantID) throws Exception;
	
	public int searchItemCount(LoginVO userInfo, String boardID, String title, String writerName, String abstracts, String startDateTime, String endDateTime) throws Exception;
	
	public int guestOneGet1(String sRadio, String keyword, String code, String primary, int tenantID) throws Exception;
		
	public int pollResGet1(String id, String code, int tenantID) throws Exception;
	
	public int pollETCViewGet(String questionID, int tenantID) throws Exception;
	
	/* 2018-11-26 홍승비 - 커뮤니티 회원목록 카운트에 companyID 조건 추가 */
	public int commViewMemberGet2(String code, String primary, String keyword, String sRadio, String companyID, int tenantID, String selectGrade) throws Exception;
	
	public int adminMemPermitGet1(String code, int tenantID) throws Exception;
	
	public int adminSearchItemCount(LoginVO userInfo, String boardID, String title, String writerName, String abstracts, String startDateTime, String endDateTime) throws Exception;
	
	/* 2018-06-21 홍승비 - 오늘의 커뮤니티 표출 companyID 조건 추가 */
	public int todayCopGet1(String companyID, int tenantID) throws Exception;
	
	public int categoryListItemCntGet(String c_ClubNo, int tenantID) throws Exception;
	
	public int getNewItemListCount(String id, int tenantID) throws Exception;
	
	public int getBoardTotalItemCount(String pBoardID, int tenantID) throws Exception;
	
	public int boardPropertyGet(String boardID, int tenantID) throws Exception;

	public int adminOuterListGet1(String code, int tenantID) throws Exception;
	
	/* 2018-07-18 홍승비 - 회원탈퇴/마스터이취임 화면 회원 검색 시 카운트 변하도록 수정, primary 추가 */
	public int adminMemberListGet1(String code, String flag, String ser, String primary, int tenantID) throws Exception;

	public int adminMemberListOkGetE(String code, String cID, int tenantID) throws Exception;	

	/* 2018-11-23 홍승비 - 커뮤니티 공지사항에 companyID 조건 추가 */
	public int bbsListGet1(String bName, String primary, String pKeyword, String sRadio, String companyID, int tenantID) throws Exception;
	
	public int getReservedItemListCount(String id, int tenantID) throws Exception;
	
	public int noticeSysopCheck(String code, String id, String rollInfo, String companyID, int tenantID) throws Exception;
	
	public int mainPage(LoginVO userInfo) throws Exception;
	
	public int commHomeGet2(String code, int tenantID) throws Exception;
	
	public boolean guestEditOk(LoginVO userInfo, CommunityCClubGuestVO item, String code, String mode, String memo, String[] cNo, boolean bIsMyContent) throws Exception;
	
	public void deleteOneLineReply(String id, String pReplyID, String gubun, int tenantID) throws Exception;
	
	public void commMakeOk(LoginVO userInfo, CommunityClubVO clubVO, MultipartHttpServletRequest request, HttpServletResponse response) throws Exception;
	
	public void boardItemList(LoginVO userInfo, Model model, HttpServletRequest request, HttpServletResponse response, CommunityBoardPropertyVO boardInfo, CommunityBoardListVO boardList) throws Exception;
	
	public void newBoardItem(CommunityBoardItemVO item, CommunityBoardPropertyVO boardInfo, LoginVO userInfo, String pItemID, String pBoardID, String pUrl, String pMode, String expireDays, Model model) throws Exception;
	
	public void boardItemView(LoginVO userInfo, CommunityBoardPropertyVO boardInfo, CommunityBoardItemVO item, String pItemID, String pBoardID, String showAdjacent, String adjacentItemsEnableFlag, Model model) throws Exception;
	
	public void pollAddGo(LoginVO userInfo, HttpServletRequest request, HttpServletResponse response) throws Exception;
	
	public void pollDelete(LoginVO userInfo, HttpServletRequest request, HttpServletResponse response) throws Exception;
	
	public void pollRes(LoginVO userInfo, Model model, String pollManagerID, String pollState, HttpServletResponse response) throws Exception;
	
	/* 2018-10-01 홍승비 - 설문조사 응답 후 리스트로 이동하지 않고 해당 설문조사를 유지하도록 수정 */
	public void pollResOk(LoginVO userInfo, String code, String questionID, String pollSelect, String answerETC, String isSave, String answerType, String answerCount, String pollManagerID, String pollState, HttpServletResponse response) throws Exception;
	
	public void pollEditOk(String pClubNo, String subject, String startDate, String endDate, String managerID, int tenantID, HttpServletResponse response) throws Exception;
	
	public void adminLogoOk(MultipartHttpServletRequest request, int tenantID) throws Exception;

	public void joinOkInsert(String companyID, String userID, String userName, String userName2, String companyName, String companyName2, String companyZip, String companyAddress, String deptName, String deptName2, String companyTel, String companyFax, String homeTel, String handPhone, String eMail, String birthDay, String gender, int tenantID) throws Exception;

	public boolean communityConnCHK(String id, String clubID, String boardID, String rollInfo, int mode, HttpServletResponse response, LoginVO userInfo, String type) throws Exception;

	public void updateLastDate(String strNow, String code, String id, int tenantID) throws Exception;

	public void deleteItem(String itemList, int tenantID) throws Exception;

	public void saveOneLineReply(Document xmlDoc, LoginVO userInfo) throws Exception;
	
	public void adminBasicOkUpdate(CommunityClubVO clubVO, String code, int tenantID) throws Exception;

	public void adminHomeBoardSet(String clear, String position, int sn, String cn, String boardID, int tenantID) throws Exception;

	public void createBoardGroup(String code, String boardGroupID, String boardGroupName, String boardGroupName2, LoginVO userInfo) throws Exception;

	public void deleteBoard(int tenantID) throws Exception;

	public void createBoardInsert(String code, String boardID, String boardName, String boardName2, String parentBoardID, String boardGroupID, String comatt, LoginVO userInfo, String readGrade, String writeGrade) throws Exception;

	public void adminOuterOkNoSet(String flag, String userID, String code, int tenantID) throws Exception;

	public void adminMemberListOkGoSe(String mode, String code, String cID, String cNm, LoginVO userInfo) throws Exception;
	
	public void adminCommCloseOkInsert(String code, String commName, String commName2, String sysopID, String companyName, String companyId, String todayTime, String reason, String closeState, int tenantID) throws Exception;

	public void joinOkSet1(String code, String id, String todayTime, String companyID, int tenantID, String joinGrade) throws Exception;
	
	public void joinOkUpdate1(String id, String code, String cIntro, String openEmail, String openHp, String openComp, String openBirth, String openSex, String openHouse, int tenantID) throws Exception;

	public void joinOkUpdate2(String id, String code, String cIntro, String openEmail, String openHp, String openComp, String openHouse, String openJob, String openBirth, String openSex, int tenantID) throws Exception;
	
	public void joinOkUpdate3(String companyID, String id, String birthDay, int tenantID) throws Exception;
	
	public void okNoSet(String flag, String code, String cID, int tenantID, String joinGrade) throws Exception;

	public void commMakeUpload(String mode, String fileName, String fileData, String logoPath, int tenantID) throws Exception;

	public void adminLogoUploadIE9(String code, String type, String imageSrc, String logoPath, String fileName, String fileData, int tenantID) throws Exception;

	public void joinOkSendMail(HttpServletRequest request, String loginCookie, LoginVO userInfo, CommunityClubVO clubVO) throws Exception;
	
	public void okNoSetSendMail(HttpServletRequest request, String loginCookie, LoginVO userInfo, String flag, String code, String cID) throws Exception;

	public void deleteExpiredItems(String realPath) throws Exception;

	public void deleteReservedBoard(String realPath) throws Exception;

	public void deleteReservedBoardItem(String realPath)throws Exception;

	public void sendReplyNoticeMail(HttpServletRequest request, String boardID, String itemID, String itemTreeID, String loginCookie) throws Exception;

	public String getOneLineReplyCount(String pBoardID, String pItemID,int tenantId) throws Exception;
	
	public int getReaderListCount(String boardID, String itemID, String userID, int tenantID) throws Exception;

	public int bbsGetReplyItemCnt(String itemNo, int tenantId) throws Exception;

	public String getClubConfirmType(String code, int tenantID) throws Exception;

	public String getIsNewItemExists(String boardID, String userID, int tenantID) throws Exception;

	public boolean checkUserInCommunity(String clubNo, String userID, int tenantID) throws Exception;
	
	public String encodeURIComponent(String url) throws Exception; 

	public String popularBoardItem(LoginVO userInfo) throws Exception;
	
	public boolean saveHWP(String strHTML, String strFileName, String strBoardID, String strFilePath, String realPath) throws Exception;

	public void insertGuestOneLineReply(int itemID, String clubNo, String companyID, int tenantID, String content, LoginVO userInfo) throws Exception;

	public void deleteGuestOneLineReply(String replyId, int tenantID) throws Exception;

	public void modifyGuestOneLineReply(String replyId, String content, int tenantID) throws Exception;

	// 2024-10-17 조수빈 - 커뮤니티 내의 게시글 통합 검색 목록 반환 메소드
	public String commBoardTotalSearchList(List<Map<String, String>> searchMaps, LoginVO userInfo, String sortBy, String pageNum, String code) throws Exception;

	// 2024-10-17 조수빈 - 커뮤니티 내의 게시글 통합 검색 카운트 반환 메소드
	public int commuTotalSearchCount(List<Map<String, String>> searchMaps, LoginVO userInfo, String sortBy, String pageNum, String code) throws Exception;

	// 2024-10-17 조수빈 - 커뮤니티 내의 게시글 통합 검색 카운트 반환 메소드
	public List<CommunityBoardItemAttachmentVO> getItemAttachmentInfo(String itemID, int tenantId) throws Exception;

	// 2024-10-17 조수빈 - 게시판 조회 권한 체크 메소드
	public String getReadFlag(String boardID, LoginVO userInfo) throws Exception;
	
	public String getClubNameLocalization(String userLang, CommunityClubVO clubVO) throws Exception;

	public String getClubBoardNameLocalization(String userLang, CommunityBoardPropertyVO clubBoardVO) throws Exception;

	public int checkPollPeriod(String code, String pollManagerID, LoginVO userInfo) throws Exception;

	public void updateJoinGrade(String strNow, String code, String id, int tenantID) throws Exception;

	public String saveGradeList(String code, List<String> gradelist, String companyID, int tenantID) throws Exception;

	public void deleteGradeList(String code, String companyID, int tenantID) throws Exception;

	public List<CommunityMemberGradeVO> getMemberGrade(String code, String companyID, int tenantID) throws Exception;

	public String getMemberGradeName(String code, String gradeCode, String companyID, int tenantID) throws Exception;

	public void updateMemberGrade(String code, String grade, List<String> id, String companyID, int tenantID) throws Exception;

	public String getUserGrade(String code, String userId, String companyID, int tenantID) throws Exception;

	public String getMemListReadGrade(String code, String companyID, int tenantID) throws Exception;

	public int getGradeCount(String code, String grade, String companyID, int tenantID) throws Exception;

	public void updateBoardManageGrade(String boardID, String readGrade, String writeGrade, int tenantID) throws Exception;

	public String getCommunityJoinGrade(String code, String companyID, int tenantID) throws Exception;
}
