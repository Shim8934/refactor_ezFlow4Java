package egovframework.ezEKP.ezCommunity.service;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;

import org.w3c.dom.Document;

import egovframework.ezEKP.ezCommunity.vo.CommunityBoardInfoVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityBoardItemReadVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityBoardItemVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityBoardListVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityBoardPropertyVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityBoardTreeVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityCBoardVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityCClubGuestVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityCClubUserVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityCPollAnswerVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityCPollManagerVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityCPollQuestionVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityCPollResponseVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityClubVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityLeftCommunityVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityMemberInfoVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityOneLineReplyVO;
import egovframework.let.user.login.vo.LoginVO;

public interface EzCommunityService {
	
	public List<CommunityLeftCommunityVO> leftCommunityGet3(String userID) throws Exception;
	
	public List<CommunityCBoardVO> getLeftBoardList() throws Exception;
	
	public List<CommunityBoardTreeVO> brdBoardTree(String pRootBoardID, String pUserID, String pDeptID, String pCompanyID, int pMode, int pSelectBy, String pExcludeBoardID, String pClubNo) throws Exception;
	
	public List<CommunityBoardTreeVO> getBoardTreeGet2(String pUserID) throws Exception;
	
	public List<String> goAdminOkGet1() throws Exception;
	
	public List<CommunityClubVO> goAdminOkGet2(String pClubID) throws Exception;
	
	public List<CommunityCBoardVO> getBBSListGet2(String bName, String lang, String pKeyword, String sRadio) throws Exception;
	
	public List<CommunityCBoardVO> bbsViewNewGet2(String bName) throws Exception;
	
	public List<CommunityBoardInfoVO> copHomeBoardGet(String code) throws Exception;
	
	public List<CommunityBoardItemVO> copHomeBoardItemGet(String boardID) throws Exception;
	
	public List<CommunityOneLineReplyVO> readOneLineReply(String lang, String pBoardID, String pItemID) throws Exception;
	
	public List<CommunityBoardItemReadVO> getReaderList(String pBoardID, String pItemID) throws Exception;
	
	public List<CommunityCClubGuestVO> guestOneGet2(String sRadio, String keyword, String code, String lang) throws Exception;
	
	public List<CommunityCPollManagerVO> pollMainGet2(String code) throws Exception;
	
	public List<CommunityCPollAnswerVO> pollResGet6(int questionID) throws Exception;

	public List<CommunityCPollResponseVO> pollETCTableGet(String questionID) throws Exception;

	public List<CommunityCClubUserVO> commViewMemberGet1(String code, String lang, String keyword, String sRadio) throws Exception;
	
	public List<CommunityCPollQuestionVO> pollDeleteGet2(String managerID) throws Exception;

	public List<CommunityCPollAnswerVO> pollDeleteGet4(int questionID) throws Exception;

	public CommunityCBoardVO bbsViewNewGet1(String bName, String no) throws Exception;
	
	public CommunityCBoardVO bbsEditNew(String bName, String no, String lang) throws Exception;
	
	public CommunityCBoardVO bbsEditOkGet1(String bName, String gant, String code) throws Exception;
	
	public CommunityCBoardVO bbsDelOkGet(String bName, String itemNo, String code) throws Exception;
	
	public CommunityClubVO commMakeOkGet1(String clubName, String cCateA, String cCateB, String cCateC, String lang) throws Exception;
	
	public CommunityClubVO aspCommInfoGet1(String code) throws Exception;
	
	public CommunityBoardPropertyVO getBoardInfo(LoginVO userInfo, String pBoardID) throws Exception;
	
	public CommunityBoardListVO boardItemListGet1(String pBoardID, String id) throws Exception;
	
	public CommunityBoardPropertyVO brdGetACL(String pBoardID, String pAccessID) throws Exception;

	public CommunityBoardPropertyVO getBoardProperty(String pBoardID) throws Exception;
	
	public CommunityBoardItemVO getItemXML(String pBoardID, String pItemID) throws Exception;
	
	public CommunityCClubGuestVO guestEditGet(String code, String lang, String no, String id) throws Exception;
	
	public CommunityCPollManagerVO pollResGet2(String pollManagerID) throws Exception;

	public CommunityCPollQuestionVO pollResGet3(String pollManagerID) throws Exception;

	public CommunityCPollResponseVO pollResGet5(int questionID, String id, String companyID) throws Exception;
	
	public CommunityCPollManagerVO pollEditGet1(String managerID) throws Exception;

	public CommunityCPollQuestionVO pollEditGet2(String managerID) throws Exception;
	
	public CommunityMemberInfoVO commViewMemberGet3(String id, String companyID, String lang) throws Exception;

	public CommunityMemberInfoVO commOutGet(String cSysopID, String companyID, String lang) throws Exception;
	
	public CommunityClubVO adminLeftGet(String code) throws Exception;	

	public CommunityMemberInfoVO aspCommInfoGet2(String lang, String sysopID) throws Exception;
	
	public CommunityClubVO adminLogoGet(String code, String lang) throws Exception;
	
	public Map<String, String> getAdjacentItems(String pItemID, String pBoardID, String upperItemIDTree, String parentWriteDate) throws Exception;
	
	public String leftCommunityGet1(String code, String userInfoUserID) throws Exception;

	public String leftCommunityGet2(String code) throws Exception;
	
	public String leftCommunityGet4(String code) throws Exception;
	
	public String brdCheckIfBoardGroupAdmin(String pRootBoardID, String id, String deptID, String companyID) throws Exception;

	public String getCategoryValueA(String strSelCateA) throws Exception;

	public String getCategoryValueB(String strSelCateB) throws Exception;
	
	public String getCategoryValueC(String strSelCateC) throws Exception;

	public String getBoardTreeGet1(String pRootBoardID, String pUserID, String pDeptID, String pCompanyID, int pMode, int pSubFlag, int pSelectBy, String pExcludeBoardID, String pClubNo, String strLang) throws Exception;

	public String getCommunityThumInfo(String pBoardID, String pFileName, String pType) throws Exception;
	
	public String getBoardTitleName(String strBoardName, String strClubNo) throws Exception;
	
	public String bbsEditGet1(String bName, String no) throws Exception;
	
	public String getFileFolderName(String bName) throws Exception;
	
	public String bbsEditOkGet2(String maxIdFieldName, String bName, String code) throws Exception;
	
	public String bbsEditOkGet3(String maxIdFieldName, String bName, String code, String strMaxNum) throws Exception;
	
	public String commMakeOkGet6(String companyID, String id) throws Exception;
	
	public String commMakeOkGet3() throws Exception;
	
	public String commHomeGet1(String id, String code) throws Exception;
	
	public String commHomeGet4(String code) throws Exception;
	
	public String checkIfLeafBoard(String pBoardID) throws Exception;
	
	public String getBoardTree(String pRootBoardID, String pUserID, String pDeptID, String pCompanyID, int pMode, int pSubFlag, int pSelectBy, String pExcludeBoardID, String pClubNo, String strLang) throws Exception;
	
	public String checkIfBoardGroupAdmin(String pRootBoardID, String id, String deptID, String companyID) throws Exception;
	
	public String getNewItemListXML(String id, int pStartRow, int pEndRow, String pSortBy) throws Exception;

	public String getNewItemListCount(String id) throws Exception;

	public String getBoardListItemXML(String id, String pBoardID, int pStartRow, int pEndRow, String pSortBy, String lang) throws Exception;
	
	public String getBoardTotalItemCount(String pBoardID) throws Exception;

	public String getCategory(String strSelCateA, String strSelCateB, String strSelCateC) throws Exception;
	
	public String searchItemXML(String id, String boardID, String title, String writerName, String abstracts, String searchStart, String searchEnd, int pStartRow, int pEndRow, String strLang) throws Exception;
	
	public String searchItemCount(String id, String boardID, String title, String writerName, String abstracts, String startDateTime, String endDateTime) throws Exception;
	
	public String checkIfHasReply(String itemList) throws Exception;

	public String newItem(Document xmlData, String pMode, String realPath) throws Exception;
	
	public String getVersionInfo(String pBoardID) throws Exception;
	
	public String getItemAttachmentXML(String itemID) throws Exception;
	
	public String getProperSizeDisplay(int pSize) throws Exception;
	
	public String getReservedItemListXML(String id, int pStartRow, int pEndRow, String pSortBy, String lang) throws Exception;

	public String checkReplyPassword(String pItemID, String pReplyID) throws Exception;

	public String deleteOneLineReply(String id, String pReplyID, String gubun) throws Exception;

	public String getACL(String id, String pComID) throws Exception;

	public String copyItem(String pOrgItemID, String pOrgBoardID, String pDestItemID, String pDestBoardID, String pUploadFilePath) throws Exception;

	public String guestOneGet1(String sRadio, String keyword, String code, String lang) throws Exception;
	
	public String pollMainGet1(String id, String code) throws Exception;

	public String pollMainGet3(String managerID) throws Exception;

	public String pollMainGet4(String strQuestionID) throws Exception;
	
	public String pollAddOkGoGet1(String code) throws Exception;

	public String pollAddOkGoGet2(String code, int maxNo) throws Exception;

	public String pollAddOkGoGet3(String managerID) throws Exception;
	
	public String pollDeleteGet1(String managerID) throws Exception;

	public String pollDeleteGet3(String code) throws Exception;
	
	public String pollResGet1(String id, String code) throws Exception;
	
	public String pollResGet4(String lang, String pollRegUser) throws Exception;
	
	public String pollETCViewGet(String questionID) throws Exception;
	
	public String commViewMemberGet2(String code, String lang, String keyword, String sRadio) throws Exception;

	public String adminMemberListGet2(String code) throws Exception;
	
	public String getClubMemberInfo(String trim, String string, String lang) throws Exception;
	
	public String categoryPrint(String c_Cate_A, String c_Cate_B, String c_Cate_C) throws Exception;

	public String commOutOk(LoginVO userInfo, String code, String reason) throws Exception;
	
	public String adminMemPermitGet1(String code) throws Exception;

	public String adminBasicGet1(String code) throws Exception;

	public String adminBasicGet2(String code) throws Exception;
	
	public int checkIfLeafBoardGet(String boardID) throws Exception;

	public int getBBSListGet1(String bName, String lang, String pKeyword, String sRadio) throws Exception;

	public int bbsAdminCheck(String userID, String rollInfo) throws Exception;
	
	public int commMakeOkGet2() throws Exception;
	
	public int commMakeOkGet4() throws Exception;
	
	public int commHomeGet2(String code) throws Exception;
	
	public int getReservedItemListCount(String id) throws Exception;
	
	public int checkOneLineOwner(String pReplyID, String id) throws Exception;
	
	public int pollResGetAllCount(int questionID) throws Exception;

	public int pollResGetCount(int questionID, int answerID) throws Exception;

	public int noticeSysopCheck(String code, String id, String rollInfo, String companyID) throws Exception;

	public boolean saveMHT (String strHTML, String strMHTFileName, String strBoardID, String strFilePath, String realPath) throws Exception;

	public boolean saveAttachmentsInfo(String attachments, String itemID, String boardID, String pUploadFilePath, String thumbPath, String realPath) throws Exception;
	
	public void getBoardTreeSet(String pRootBoardID, String pUserID, String pDeptID, String pCompanyID, int pMode, int pSubFlag, int pSelectBy, String pExcludeBoardID, String pClubNo, String strLang, String result) throws Exception;

	public void bbsEditOkSet1(String bName, String title, String gant, String code, String attachList, String textContent) throws Exception;

	public void bbsEditOkSet2(String bName, int myRef, int myStep, String code) throws Exception;

	public void bbsEditOkInsert(String bName, int myRef, int newStep, int newLevel, String attachList, int number, String textContent, String nowDate, String fileName, String code, String companyID, String id, String userNm, String userNm2, String title, String maxIdFieldName) throws Exception;

	public void bbsDelOkDel(String bName, String itemNo, String code) throws Exception;

	public void commMakeOkInsert1() throws Exception;

	public void commMakeOkInsert2(int clubNo, String todayTime, String clubName, String clubName2, String cCateA, String cCateB, String cCateC, String clubType, String clubConfirmType, String intro, int isIn, String logo, String banner, String bBoardName1, String bBoardName2, String comatt, String code, String bNotiName1, String bNotiName2, String pNewID, int boardNo, String id, String displayName1, String companyName1, String deptName1, String pNewSubID, int openEmail, int openHp, int openComp, int openHouse, int openJob, int openBirth, int openSex, String companyID) throws Exception;

	public void joinOkInsert(String companyID, String userID, String userName, String companyName, String companyName2, String companyZip, String companyAddress, String deptName, String deptName2, String companyTel, String companyFax, String homeTel, String handPhone, String eMail, String birthDay, String gender) throws Exception;

	public void commMakeOkSet1(String logoFileName, String thumbnailFileName, String fileName, int fileSize) throws Exception;

	public void commMakeOkSet2(String bannerFileName, String fileName, int fileSize) throws Exception;

	public void communityConnCHK(String id, String clubID, String boardID, String rollInfo, int mode, HttpServletResponse response) throws Exception;

	public void updateLastDate(String strNow, String code, String id) throws Exception;

	public void setAsRead(LoginVO userInfo, String boardID, String itemIDList) throws Exception;

	public void deleteItem(String itemList) throws Exception;

	public void saveOneLineReply(String pItemID, String pReplyID, String pBoardID, String userID, String userName, String userName2, String pContent, String pPassword) throws Exception;
	
	public void guestEditOkInsert(String code, LoginVO userInfo, String memo) throws Exception;

	public void guestEditOkDelete(String no, String code) throws Exception;

	public void guestEditOkUpdate(String no, String code, String memo, String id) throws Exception;

	public void pollAddOkGoInsert1(String code, int maxNo, String subject, String startDate, String endDate, String id) throws Exception;
	
	public void pollAddOkGoInsert2(String managerID, String subject, String answerCount, String selType, String answerViewType) throws Exception;
	
	public void pollAddOkGoInsert3(String questionID, int answerNo, String answerContent) throws Exception;

	public void pollDeleteDel1(int questionID, int answerID) throws Exception;

	public void pollDeleteDel2(int questionID) throws Exception;

	public void pollDeleteDel3(String managerID) throws Exception;

	public void pollResOkSet(String questionID, String pollSelect, String answerETC, String id, String companyID, String isSave, String answerType, String answerCount) throws Exception;

	public void pollEditOkUpdate(String subject, String startDate, String endDate, String managerID) throws Exception;
	
	public void adminBasicOkUpdate(CommunityClubVO clubVO, String code) throws Exception;

	public void adminLogoOkUpdate1(String logoFileNameLogo, String logoFileNameThumbnail, String fileName) throws Exception;

	public void adminCommType(String copType, String fileName) throws Exception;

	public void adminLogoOkUpdate2(String bannerFileName, String fileName) throws Exception;

	public List<CommunityBoardInfoVO> getBoardList(String code, String lang, String position) throws Exception;

	public void adminHomeBoardSet(String clear, String position, int sn, String cn, String boardID) throws Exception;
	
//	public String extractString(String pSource, String pStarts, String pEnds) throws Exception;

//	public String sortXML(String pXML, String pSortBy) throws Exception;
}
