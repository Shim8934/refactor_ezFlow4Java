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
	public List<CommunityCBoardVO> bbsListGet2(String bName, String lang, String pKeyword, String sRadio, int tenantID) throws Exception;
	
	public List<CommunityCBoardVO> bbsViewNewGet2(String bName, int tenantID) throws Exception;
	
	public List<CommunityCBoardVO> getLeftBoardList(int tenantID) throws Exception;

	public List<CommunityOneLineReplyVO> readOneLineReply(String lang, String pBoardID, String pItemID, int tenantID, String offset) throws Exception;
	
	public List<CommunityBoardItemReadVO> getReaderList(String pBoardID, String pItemID, int tenantID, String offset) throws Exception;

	public List<CommunityCPollResponseVO> pollETCTableGet(String questionID, int tenantID) throws Exception;
	
	public List<CommunityCCategoryVO> mainPageGet4(String cat, int tenantID) throws Exception;
	
	public List<CommunityClubVO> categoryListGet(String type, String mode, int startRow, int endRow, int tenantID) throws Exception;
	
	public List<CommunityClubVO> searchCop(String search, String keyword, int startRow, int endRow, String mode, int tenantID) throws Exception ;
	
	public List<CommunityClubVO> getLeftCommunity(LoginVO userInfo) throws Exception;
	
	public List<CommunityBoardInfoVO> commHomeBoardInfo(String code, int tenantID) throws Exception;
	
	public List<CommunityBoardItemVO> commHomeBoardItemList(String boardID, int tenantID) throws Exception;
	
	public List<CommunityClubVO> adminNoticeMailOkGet2(String code, int tenantID) throws Exception;
	
	public CommunityCBoardVO bbsViewNewGet1(String bName, String no, int tenantID, String offset) throws Exception;
	
	public CommunityCBoardVO bbsEditNew(String bName, String no, String lang, int tenantID) throws Exception;
	
	public CommunityCBoardVO bbsDelOkGet(String bName, String itemNo, String code, int tenantID) throws Exception;
	
	public CommunityClubVO aspCommInfoGet1(String code, int tenantID) throws Exception;
	
	public CommunityClubVO adminLeftGet(String code, int tenantID) throws Exception;
	
	public CommunityClubVO adminLogoGet(String code, String lang, int tenantID) throws Exception;
	
	public CommunityClubVO adminCommCloseOkGet2(String code, int tenantID) throws Exception;
		
	public CommunityClubVO adminNoticeMailOkGet1(String code, int tenantID) throws Exception;
	
	public CommunityClubVO joinOkGet3(String code, String lang, int tenantID) throws Exception;
	
	public CommunityClubVO todayCopGet2(int num, int tenantID) throws Exception;
	
	public CommunityClubVO boardItemListPhotoGet1(String id, String boardID, int tenantID) throws Exception;
	
	public CommunityClubVO leftCommunityGet4(String code, int tenantID)throws Exception;
	
	public CommunityBoardPropertyVO getBoardInfo(LoginVO userInfo, String pBoardID) throws Exception;
	
	public CommunityBoardPropertyVO brdGetACL(String pBoardID, String pAccessID, int tenantID) throws Exception;

	public CommunityBoardPropertyVO getBoardProperty(String pBoardID, int tenantID) throws Exception;
	
	public CommunityBoardListVO boardItemListGet1(String pBoardID, String id, int tenantID) throws Exception;
	
	public CommunityBoardItemVO getItemXML(String pBoardID, String pItemID, LoginVO usreInfo) throws Exception;
	
	public CommunityCClubGuestVO guestEditGet(String code, String lang, String no, String id, int tenantID) throws Exception;
	
	public CommunityCPollManagerVO pollEditGet1(String managerID, int tenantID) throws Exception;

	public CommunityCPollQuestionVO pollEditGet2(String managerID, int tenantID) throws Exception;

	public CommunityMemberInfoVO commOutGet(String cSysopID, String companyID, String lang, int tenantID) throws Exception;
	
	public CommunityMemberInfoVO aspCommInfoGet2(String lang, String sysopID, int tenantID) throws Exception;
	
	public CommunityMemberInfoVO getMemberInfo(String companyID, String cID, int tenantID) throws Exception;
	
	public CommunityMemberInfoVO joinOkGet4(String companyID, String id, int tenantID) throws Exception;

	public CommunityCClubUserVO adminMemberListOkGet(String code, String cID, String companyID, int tenantID) throws Exception;

	public CommunityCComCloseVO adminCommCloseOkGet1(String code, int tenantID) throws Exception;
	
	public CommunityCCategoryVO mainPageCategory(String c_Code, String cat, int tenantID) throws Exception;
	
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
	
	public String commViewMember(LoginVO userInfo, String code, String strSysopID, String keyword, String sRadio, int comNoPerPage, int curPage) throws Exception;
	
	public String adminHomeBoard1(LoginVO userInfo, String code) throws Exception;
	
	public String adminHomeBoard2(LoginVO userInfo, String code) throws Exception;
	
	public String adminHomeBoard3(LoginVO userInfo, String code) throws Exception;
	
	public String adminOuterList(LoginVO userInfo, String code) throws Exception;

	public String adminMemberList(LoginVO userInfo, String code, String flag, String ser, String strSysopID, String mode) throws Exception;
	
	public String myCopNewBoardItem(LoginVO userInfo, int startRow, int endRow) throws Exception;

	public String getBestNewCommunity(LoginVO userInfo, String mode) throws Exception;

	public String leftCommunityGet1(String code, String userInfoUserID, int tenantID) throws Exception;

	public String getBoardTreeGet1(String pRootBoardID, String pUserID, String pDeptID, String pCompanyID, int pMode, int pSubFlag, int pSelectBy, String pExcludeBoardID, String pClubNo, String strLang, int tenantID) throws Exception;

	public String getCommunityThumInfo(String pBoardID, String pFileName, String pType, int tenantID) throws Exception;
	
	public String getBoardTitleName(String strBoardName, String strClubNo, int tenantID) throws Exception;
	
	public String bbsEditGet1(String bName, String no, int tenantID) throws Exception;
	
	public String getFileFolderName(String bName) throws Exception;
	
	public String commHomeGet1(String id, String code, int tenantID) throws Exception;
	
	public String commHomeGet4(String code, int tenantID) throws Exception;
	
	public String getBoardTree(String pRootBoardID, String pUserID, String pDeptID, String pCompanyID, int pMode, int pSubFlag, int pSelectBy, String pExcludeBoardID, String pClubNo, String strLang, int tenantID) throws Exception;
	
	public String checkIfBoardGroupAdmin(String pRootBoardID, String id, String deptID, String companyID, int tenantID) throws Exception;

	public String getCategory(String strSelCateA, String strSelCateB, String strSelCateC, LoginVO userInfo) throws Exception;
	
	public String searchItemXML(LoginVO userInfo, String boardID, String title, String writerName, String abstracts, String searchStart, String searchEnd, int pStartRow, int pEndRow) throws Exception;
	
	public String checkIfHasReply(String itemList, int tenantID) throws Exception;

	public String newItem(Document xmlData, String pMode, String realPath, LoginVO userInfo) throws Exception;
	
	public String getItemAttachmentXML(String itemID, int tenantID) throws Exception;
	
	public String getReservedItemListXML(String id, int pStartRow, int pEndRow, String pSortBy, String lang, int tenantID, String offset) throws Exception;

	public String checkReplyPassword(String pItemID, String pReplyID, int tenantID) throws Exception;

	public String getACL(String id, String pComID, int tenantID) throws Exception;

	public String copyItem(String pOrgItemID, String pOrgBoardID, String pDestItemID, String pDestBoardID, String realPath, LoginVO userInfo) throws Exception;

	public String pollMainGet1(String id, String code, int tenantID) throws Exception;

	public String adminMemberListGet2(String code, int tenantID) throws Exception;
	
	public String categoryPrint(String c_Cate_A, String c_Cate_B, String c_Cate_C, LoginVO userInfo) throws Exception;

	public String commOutOk(String loginCookie, String code, String reason) throws Exception;

	public String adminBasicGet1(String code, int tenantID) throws Exception;

	public String adminBasicGet2(String code, int tenantID) throws Exception;
	
	public String saveBoardOrder(String xmlData, int tenantID) throws Exception;
	
	public String moveBoard(String orgBoardID, String newParentBoardID, String newBoardGroupID, int tenantID) throws Exception;

	public String brdDeleteBoard(String boardID, int tenantID) throws Exception;

	public String adminSearchItemXML(LoginVO userInfo, String boardID, String title, String writerName, String abstracts, String searchStart, String searchEnd, int pStartRow, int pEndRow) throws Exception;
	
	public String saveBoardProperty(LoginVO userInfo, String xmlData) throws Exception;
	
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

	public String leftCommunityGet2(String code, int tenantID) throws Exception;
	
	public String checkPassword(String pItemID, int tenantID) throws Exception;
	
	public String adminLogoUpload(String code, String realPath, String logoPath, MultipartFile logoFile, int tenantId) throws Exception;
	
//	public String getContentInfo(String type, String itemID, int tenantID) throws Exception;
	
	public int searchItemCount(LoginVO userInfo, String boardID, String title, String writerName, String abstracts, String startDateTime, String endDateTime) throws Exception;
	
	public int guestOneGet1(String sRadio, String keyword, String code, String lang, int tenantID) throws Exception;
		
	public int pollResGet1(String id, String code, int tenantID) throws Exception;
	
	public int pollETCViewGet(String questionID, int tenantID) throws Exception;
	
	public int commViewMemberGet2(String code, String lang, String keyword, String sRadio, int tenantID) throws Exception;
	
	public int adminMemPermitGet1(String code, int tenantID) throws Exception;
	
	public int adminSearchItemCount(LoginVO userInfo, String boardID, String title, String writerName, String abstracts, String startDateTime, String endDateTime) throws Exception;
	
	public int todayCopGet1(int tenantID) throws Exception;
	
	public int categoryListItemCntGet(String c_ClubNo, int tenantID) throws Exception;
	
	public int getNewItemListCount(String id, int tenantID) throws Exception;
	
	public int getBoardTotalItemCount(String pBoardID, int tenantID) throws Exception;
	
	public int boardPropertyGet(String boardID, int tenantID) throws Exception;

	public int adminOuterListGet1(String code, int tenantID) throws Exception;
	
	public int adminMemberListGet1(String code, int tenantID) throws Exception;

	public int adminMemberListOkGetE(String code, String cID, int tenantID) throws Exception;	

	public int bbsListGet1(String bName, String lang, String pKeyword, String sRadio, int tenantID) throws Exception;
	
	public int getReservedItemListCount(String id, int tenantID) throws Exception;
	
	public int noticeSysopCheck(String code, String id, String rollInfo, String companyID, int tenantID) throws Exception;
	
	public int mainPage(LoginVO userInfo) throws Exception;
	
	public int commHomeGet2(String code, int tenantID) throws Exception;
	
	public boolean guestEditOk(LoginVO userInfo, CommunityCClubGuestVO item, String code, String mode, String memo, String[] cNo, boolean bIsMyContent) throws Exception;
	
	public void deleteOneLineReply(String id, String pReplyID, String gubun, int tenantID) throws Exception;
	
	public void commMakeOk(LoginVO userInfo, CommunityClubVO clubVO, MultipartHttpServletRequest request, HttpServletResponse response) throws Exception;
	
	public void boardItemList(LoginVO userInfo, Model model, HttpServletRequest request, HttpServletResponse response, CommunityBoardPropertyVO boardInfo, CommunityBoardListVO boardList) throws Exception;
	
	public void newBoardItem(CommunityBoardItemVO item, CommunityBoardPropertyVO boardInfo, LoginVO userInfo, String pItemID, String pBoardID, String pUrl, String pMode, String expireDays, String hasAttach, Model model) throws Exception;
	
	public void boardItemView(LoginVO userInfo, CommunityBoardPropertyVO boardInfo, CommunityBoardItemVO item, String pItemID, String pBoardID, String showAdjacent, String adjacentItemsEnableFlag, Model model) throws Exception;
	
	public void pollAddGo(LoginVO userInfo, HttpServletRequest request, HttpServletResponse response) throws Exception;
	
	public void pollDelete(LoginVO userInfo, HttpServletRequest request, HttpServletResponse response) throws Exception;
	
	public void pollRes(LoginVO userInfo, Model model, String pollManagerID, String pollState, HttpServletResponse response) throws Exception;
	
	public void pollResOk(LoginVO userInfo, String code, String questionID, String pollSelect, String answerETC, String isSave, String answerType, String answerCount, HttpServletResponse response) throws Exception;
	
	public void pollEditOk(String pClubNo, String subject, String startDate, String endDate, String managerID, int tenantID, HttpServletResponse response) throws Exception;
	
	public void adminLogoOk(MultipartHttpServletRequest request, int tenantID) throws Exception;

	public void joinOkInsert(String companyID, String userID, String userName, String userName2, String companyName, String companyName2, String companyZip, String companyAddress, String deptName, String deptName2, String companyTel, String companyFax, String homeTel, String handPhone, String eMail, String birthDay, String gender, int tenantID) throws Exception;

	public boolean communityConnCHK(String id, String clubID, String boardID, String rollInfo, int mode, HttpServletResponse response, LoginVO userInfo) throws Exception;

	public void updateLastDate(String strNow, String code, String id, int tenantID) throws Exception;

	public void deleteItem(String itemList, int tenantID) throws Exception;

	public void saveOneLineReply(Document xmlDoc, LoginVO userInfo) throws Exception;
	
	public void adminBasicOkUpdate(CommunityClubVO clubVO, String code, int tenantID) throws Exception;

	public void adminHomeBoardSet(String clear, String position, int sn, String cn, String boardID, int tenantID) throws Exception;

	public void createBoardGroup(String code, String boardGroupID, String boardGroupName, String boardGroupName2, LoginVO userInfo) throws Exception;

	public void deleteBoard(int tenantID) throws Exception;

	public void createBoardInsert(String code, String boardID, String boardName, String boardName2, String parentBoardID, String boardGroupID, String comatt, LoginVO userInfo) throws Exception;

	public void adminOuterOkNoSet(String flag, String userID, String code, int tenantID) throws Exception;

	public void adminMemberListOkGoSe(String mode, String code, String cID, String cNm, int tenantID) throws Exception;
	
	public void adminCommCloseOkInsert(String code, String commName, String commName2, String sysopID, String companyName, String todayTime, String reason, String closeState, int tenantID) throws Exception;

	public void joinOkSet1(String code, String id, String todayTime, String companyID, int tenantID) throws Exception;
	
	public void joinOkUpdate1(String id, String code, String cIntro, String openEmail, String openHp, String openComp, String openBirth, String openSex, String openHouse, int tenantID) throws Exception;

	public void joinOkUpdate2(String id, String code, String cIntro, String openEmail, String openHp, String openComp, String openHouse, String openJob, String openBirth, String openSex, int tenantID) throws Exception;
	
	public void joinOkUpdate3(String companyID, String id, String birthDay, int tenantID) throws Exception;
	
	public void okNoSet(String flag, String code, String cID, int tenantID) throws Exception;

	public void commMakeUpload(String mode, String fileName, String fileData, String logoPath, int tenantID) throws Exception;

	public void adminLogoUploadIE9(String code, String type, String imageSrc, String logoPath, String fileName, String fileData, int tenantID) throws Exception;

	public void joinOkSendMail(String loginCookie, LoginVO userInfo, CommunityClubVO clubVO) throws Exception;
	
	public void okNoSetSendMail(String loginCookie, LoginVO userInfo, String flag, String code, String cID) throws Exception;
		
}
