package egovframework.ezEKP.ezCommunity.service;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.ui.Model;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.w3c.dom.Document;

import egovframework.ezEKP.ezCommunity.vo.CommunityBoardInfoVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityBoardItemReadVO;
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
import egovframework.let.user.login.vo.LoginVO;

public interface EzCommunityService {
	public List<CommunityCBoardVO> bbsListGet2(String bName, String lang, String pKeyword, String sRadio) throws Exception;
	
	public List<CommunityCBoardVO> bbsViewNewGet2(String bName) throws Exception;

	public List<CommunityOneLineReplyVO> readOneLineReply(String lang, String pBoardID, String pItemID) throws Exception;
	
	public List<CommunityBoardItemReadVO> getReaderList(String pBoardID, String pItemID) throws Exception;

	public List<CommunityCPollResponseVO> pollETCTableGet(String questionID) throws Exception;
	
	public List<CommunityCCategoryVO> mainPageGet4(String cat) throws Exception;
	
	public List<CommunityClubVO> categoryListGet(String type, String mode, int startRow, int endRow) throws Exception;
	
	public List<CommunityClubVO> searchCop(String search, String keyword, int startRow, int endRow, String mode) throws Exception ;
	
	public List<CommunityBoardInfoVO> commHomeBoardInfo(String code) throws Exception;
	
	public List<CommunityBoardItemVO> commHomeBoardItemList(String boardID) throws Exception;
	
	public CommunityCBoardVO bbsViewNewGet1(String bName, String no) throws Exception;
	
	public CommunityCBoardVO bbsEditNew(String bName, String no, String lang) throws Exception;
	
	public CommunityCBoardVO bbsEditOkGet1(String bName, String gant, String code) throws Exception;
	
	public CommunityCBoardVO bbsDelOkGet(String bName, String itemNo, String code) throws Exception;
	
	public CommunityClubVO aspCommInfoGet1(String code) throws Exception;
	
	public CommunityBoardPropertyVO getBoardInfo(LoginVO userInfo, String pBoardID) throws Exception;
	
	public CommunityBoardListVO boardItemListGet1(String pBoardID, String id) throws Exception;
	
	public CommunityBoardPropertyVO brdGetACL(String pBoardID, String pAccessID) throws Exception;

	public CommunityBoardPropertyVO getBoardProperty(String pBoardID) throws Exception;
	
	public CommunityBoardItemVO getItemXML(String pBoardID, String pItemID) throws Exception;
	
	public CommunityCClubGuestVO guestEditGet(String code, String lang, String no, String id) throws Exception;
	
	public CommunityCPollManagerVO pollEditGet1(String managerID) throws Exception;

	public CommunityCPollQuestionVO pollEditGet2(String managerID) throws Exception;

	public CommunityMemberInfoVO commOutGet(String cSysopID, String companyID, String lang) throws Exception;
	
	public CommunityClubVO adminLeftGet(String code) throws Exception;	

	public CommunityMemberInfoVO aspCommInfoGet2(String lang, String sysopID) throws Exception;
	
	public CommunityClubVO adminLogoGet(String code, String lang) throws Exception;
	
	public CommunityMemberInfoVO getMemberInfo(String companyID, String cID) throws Exception;

	public CommunityCClubUserVO adminMemberListOkGet(String code, String cID, String companyID) throws Exception;

	public CommunityCComCloseVO adminCommCloseOkGet1(String code) throws Exception;

	public CommunityClubVO adminCommCloseOkGet2(String code) throws Exception;
	
	public CommunityClubVO adminNoticeMailOkGet1(String code) throws Exception;
	
	public CommunityMemberInfoVO joinOkGet4(String companyID, String id) throws Exception;
	
	public CommunityClubVO joinOkGet3(String code, String lang) throws Exception;
	
	public CommunityClubVO todayCopGet2(int num) throws Exception;
	
	public CommunityCCategoryVO mainPageCategory(String c_Code, String cat) throws Exception;
	
	public CommunityClubVO boardItemListPhotoGet1(String id, String boardID) throws Exception;
	
	public CommunityClubVO leftCommunityGet4(String code)throws Exception;
	
	public Map<String, String> getAdjacentItemsPhoto(String boardID, CommunityBoardItemVO item) throws Exception;
	
	public String getLeftCommunity(LoginVO userInfo) throws Exception;
	
	public String getLeftBoardList() throws Exception;
	
	public String getSubBoard(LoginVO userInfo, HttpServletRequest request) throws Exception;
	
	public String goAdminOk(String data, HttpServletRequest request, CommunityClubVO communityClubVO) throws Exception;
	
	public String commHomeInfo(LoginVO userInfo, String code, HttpServletRequest request) throws Exception;
	
	public String upload(MultipartHttpServletRequest request, HttpServletResponse response) throws Exception;
	
	public String confirmPassword(String itemID, String newPassword) throws Exception;
	
	public String bbsList(LoginVO userInfo, List<CommunityCBoardVO> cBoardList, String code, int curPage, String bName, int comNoPerPage) throws Exception;
	
	public String bbsEditOk(LoginVO userInfo, HttpServletRequest request) throws Exception;
	
	public String bbsDelOk(LoginVO userInfo, HttpServletRequest request, CommunityCBoardVO board, String itemNo, String goToPage, String bName, int adminCheck) throws Exception;
	
	public String guestOne(LoginVO userInfo, String sRadio, String keyword, String code, int comNoPerPage, int curPage) throws Exception;
	
	public String pollMain(LoginVO userInfo, String code) throws Exception;
	
	public String pollAddOk(int sel, String selType, String selRes, int selectedNo, int answerCount, Model model, LoginVO userInfo) throws Exception;
	
	public String commViewMember(LoginVO userInfo, String code, String strSysopID, String keyword, String sRadio, int comNoPerPage, int curPage) throws Exception;
	
	public String adminHomeBoard1(LoginVO userInfo, String code) throws Exception;
	
	public String adminHomeBoard2(LoginVO userInfo, String code) throws Exception;
	
	public String adminHomeBoard3(LoginVO userInfo, String code) throws Exception;
	
	public String adminOuterList(LoginVO userInfo, String code) throws Exception;

	public String adminMemberList(LoginVO userInfo, String code, String flag, String ser, String strSysopID, String mode) throws Exception;
	
	public String myCopNewBoardItem(LoginVO userInfo, int startRow, int endRow) throws Exception;

	public String getBestNewCommunity(LoginVO userInfo, String mode) throws Exception;

	public String leftCommunityGet1(String code, String userInfoUserID) throws Exception;

	public String getBoardTreeGet1(String pRootBoardID, String pUserID, String pDeptID, String pCompanyID, int pMode, int pSubFlag, int pSelectBy, String pExcludeBoardID, String pClubNo, String strLang) throws Exception;

	public String getCommunityThumInfo(String pBoardID, String pFileName, String pType) throws Exception;
	
	public String getBoardTitleName(String strBoardName, String strClubNo) throws Exception;
	
	public String bbsEditGet1(String bName, String no) throws Exception;
	
	public String getFileFolderName(String bName) throws Exception;
	
	public String commHomeGet1(String id, String code) throws Exception;
	
	public String commHomeGet4(String code) throws Exception;
	
	public String getBoardTree(String pRootBoardID, String pUserID, String pDeptID, String pCompanyID, int pMode, int pSubFlag, int pSelectBy, String pExcludeBoardID, String pClubNo, String strLang) throws Exception;
	
	public String checkIfBoardGroupAdmin(String pRootBoardID, String id, String deptID, String companyID) throws Exception;

	public String getCategory(String strSelCateA, String strSelCateB, String strSelCateC, LoginVO userInfo) throws Exception;
	
	public String searchItemXML(String id, String boardID, String title, String writerName, String abstracts, String searchStart, String searchEnd, int pStartRow, int pEndRow, String strLang) throws Exception;
	
	public String searchItemCount(String id, String boardID, String title, String writerName, String abstracts, String startDateTime, String endDateTime) throws Exception;
	
	public String checkIfHasReply(String itemList) throws Exception;

	public String newItem(Document xmlData, String pMode, String realPath, LoginVO userInfo) throws Exception;
	
	public String getItemAttachmentXML(String itemID) throws Exception;
	
	public String getReservedItemListXML(String id, int pStartRow, int pEndRow, String pSortBy, String lang) throws Exception;

	public String checkReplyPassword(String pItemID, String pReplyID) throws Exception;

	public String deleteOneLineReply(String id, String pReplyID, String gubun) throws Exception;

	public String getACL(String id, String pComID) throws Exception;

	public String copyItem(String pOrgItemID, String pOrgBoardID, String pDestItemID, String pDestBoardID, String realPath, LoginVO userInfo) throws Exception;

	public String guestOneGet1(String sRadio, String keyword, String code, String lang) throws Exception;
	
	public String pollMainGet1(String id, String code) throws Exception;
	
	public String pollResGet1(String id, String code) throws Exception;
	
	public String pollETCViewGet(String questionID) throws Exception;
	
	public String commViewMemberGet2(String code, String lang, String keyword, String sRadio) throws Exception;

	public String adminMemberListGet2(String code) throws Exception;
	
	public String categoryPrint(String c_Cate_A, String c_Cate_B, String c_Cate_C, LoginVO userInfo) throws Exception;

	public String commOutOk(LoginVO userInfo, String code, String reason) throws Exception;
	
	public String adminMemPermitGet1(String code) throws Exception;

	public String adminBasicGet1(String code) throws Exception;

	public String adminBasicGet2(String code) throws Exception;
	
	public String saveBoardOrder(String xmlData) throws Exception;
	
	public String moveBoard(String orgBoardID, String newParentBoardID, String newBoardGroupID) throws Exception;

	public String brdDeleteBoard(String boardID) throws Exception;

	public String adminSearchItemCount(String id, String boardID, String title, String writerName, String abstracts, String startDateTime, String endDateTime) throws Exception;

	public String adminSearchItemXML(String id, String boardID, String title, String writerName, String abstracts, String searchStart, String searchEnd, int pStartRow, int pEndRow, String lang) throws Exception;
	
	public String saveBoardProperty(String id, String xmlData) throws Exception;
	
	public String checkOneLineOwner(String pReplyID, String id) throws Exception;
	
	public String setAsRead(LoginVO userInfo, String boardID, String itemIDList) throws Exception;
	
	public String join1Get(String no, String lang) throws Exception;

	public String joinGet1(String code, String lang) throws Exception;

	public String joinGet2(String sysopID, String companyID, String lang) throws Exception;

	public String joinOkGet1(String code, String id) throws Exception;

	public String joinOkGet2(String code, String id) throws Exception;
	
	public String getACLGet1(String cID) throws Exception;

	public String getACLGet2(String uID, String cID) throws Exception;

	public String adminMemPermit(LoginVO userInfo, String code) throws Exception;
	
	public String todayCopGet1() throws Exception;
	
	public String todayCopGet3(String c_Cate, String type) throws Exception;

	public String categoryListItemCntGet(String c_ClubNo) throws Exception;
	
	public String getNewItemListXML(String id, int pStartRow, int pEndRow, String pSortBy) throws Exception;
	
	public String getNewItemListCount(String id) throws Exception;
	
	public String getBoardListItemPhotoXML(String id, String pBoardID, int pStartRow, int pEndRow, String pSortBy, String lang) throws Exception;
	
	public String getBoardTotalItemCount(String pBoardID) throws Exception;
	
	public String leftCommunityGet2(String code) throws Exception;
	
	public String checkPassword(String pItemID) throws Exception;
	
	public Integer boardPropertyGet(String boardID) throws Exception;

	public Integer adminOuterListGet1(String code) throws Exception;
	
	public Integer adminMemberListGet1(String code) throws Exception;

	public Integer adminMemberListOkGetE(String code, String cID) throws Exception;	

	public int bbsListGet1(String bName, String lang, String pKeyword, String sRadio) throws Exception;

	public int bbsAdminCheck(String userID, String rollInfo) throws Exception;
	
	public int getReservedItemListCount(String id) throws Exception;
	
	public int noticeSysopCheck(String code, String id, String rollInfo, String companyID) throws Exception;
	
	public int mainPage(LoginVO userInfo) throws Exception;
	
	public boolean guestEditOk(LoginVO userInfo, CommunityCClubGuestVO item, String code, String mode, String memo, String[] cNo, boolean bIsMyContent) throws Exception;
	
	public void commMakeOk(LoginVO userInfo, CommunityClubVO clubVO, MultipartHttpServletRequest request, HttpServletResponse response) throws Exception;
	
	public void boardItemList(LoginVO userInfo, Model model, HttpServletRequest request, HttpServletResponse response, CommunityBoardPropertyVO boardInfo, CommunityBoardListVO boardList) throws Exception;
	
	public void newBoardItem(CommunityBoardItemVO item, CommunityBoardPropertyVO boardInfo, LoginVO userInfo, String pItemID, String pBoardID, String pUrl, String pMode, String expireDays, String hasAttach, Model model) throws Exception;
	
	public void boardItemView(LoginVO userInfo, CommunityBoardPropertyVO boardInfo, CommunityBoardItemVO item, String pItemID, String pBoardID, String showAdjacent, String adjacentItemsEnableFlag, Model model) throws Exception;
	
	public void pollAddGo(LoginVO userInfo, HttpServletRequest request, HttpServletResponse response) throws Exception;
	
	public void pollDelete(LoginVO userInfo, HttpServletRequest request, HttpServletResponse response) throws Exception;
	
	public void pollRes(LoginVO userInfo, Model model, String pollManagerID, String pollState, HttpServletResponse response) throws Exception;
	
	public void pollResOk(LoginVO userInfo, String code, String questionID, String pollSelect, String answerETC, String isSave, String answerType, String answerCount, HttpServletResponse response) throws Exception;
	
	public void pollEditOk(String pClubNo, String subject, String startDate, String endDate, String managerID, HttpServletResponse response) throws Exception;
	
	public void adminLogoOk(MultipartHttpServletRequest request) throws Exception;

	public void joinOkInsert(String companyID, String userID, String userName, String userName2, String companyName, String companyName2, String companyZip, String companyAddress, String deptName, String deptName2, String companyTel, String companyFax, String homeTel, String handPhone, String eMail, String birthDay, String gender) throws Exception;

	public void communityConnCHK(String id, String clubID, String boardID, String rollInfo, int mode, HttpServletResponse response, LoginVO userInfo) throws Exception;

	public void updateLastDate(String strNow, String code, String id) throws Exception;

	public void deleteItem(String itemList) throws Exception;

	public void saveOneLineReply(Document xmlDoc, LoginVO userInfo) throws Exception;
	
	public void adminBasicOkUpdate(CommunityClubVO clubVO, String code) throws Exception;

	public void adminHomeBoardSet(String clear, String position, int sn, String cn, String boardID) throws Exception;

	public void createBoardGroup(String code, String boardGroupID, String boardGroupName, String boardGroupName2, LoginVO userInfo) throws Exception;

	public void deleteBoard() throws Exception;

	public void createBoardInsert(String code, String boardID, String boardName, String boardName2, String parentBoardID, String boardGroupID, String comatt, LoginVO userInfo) throws Exception;

	public void adminOuterOkNoSet(String flag, String userID, String code) throws Exception;

	public void adminMemberListOkGoSe(String mode, String code, String cID, String cNm) throws Exception;
	
	public void adminCommCloseOkInser(String code, String commName, String commName2, String sysopID, String companyName, String todayTime, String reason, String closeState) throws Exception;

	public void joinOkSet1(String code, String id, String todayTime, String companyID) throws Exception;
	
	public void JoinOkUpdate1(String id, String code, String cIntro, String openEmail, String openHp, String openComp, String openBirth, String openSex, String openHouse) throws Exception;

	public void JoinOkUpdate3(String companyID, String id, String birthDay) throws Exception;

	public void joinOkUpdate2(String id, String code, String cIntro, String openEmail, String openHp, String openComp, String openHouse, String openJob, String openBirth, String openSex) throws Exception;

	public void okNoSet(String flag, String code, String cID) throws Exception;

	public void commMakeUpload(String mode, String fileName, String fileData, String logoPath) throws Exception;
}
