package egovframework.ezEKP.ezCommunity.service;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.w3c.dom.Document;

import egovframework.ezEKP.ezCommunity.vo.CommunityBoardInfoVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityBoardItemVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityBoardListVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityBoardPropertyVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityBoardTreeVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityCBoardVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityClubVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityLeftCommunityVO;
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

	public CommunityCBoardVO bbsViewNewGet1(String bName, String no) throws Exception;
	
	public CommunityCBoardVO bbsEditNew(String bName, String no, String lang) throws Exception;
	
	public CommunityCBoardVO bbsEditOkGet1(String bName, String gant, String code) throws Exception;
	
	public CommunityCBoardVO bbsDelOkGet(String bName, String itemNo, String code) throws Exception;
	
	public CommunityClubVO commMakeOkGet1(String clubName, String cCateA, String cCateB, String cCateC, String lang) throws Exception;
	
	public CommunityClubVO aspCommInfoGet1(String code) throws Exception;
	
	public CommunityBoardPropertyVO getBoardInfo(LoginVO userInfo, String pBoardID) throws Exception;
	
	public CommunityBoardListVO boardItemListGet1(String pBoardID, String id) throws Exception;
	
	public CommunityBoardPropertyVO getACL(String pBoardID, String pAccessID) throws Exception;

	public CommunityBoardPropertyVO getBoardProperty(String pBoardID) throws Exception;
	
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

	public int checkIfLeafBoardGet(String boardID) throws Exception;

	public int getBBSListGet1(String bName, String lang, String pKeyword, String sRadio) throws Exception;

	public int bbsAdminCheck(String userID, String rollInfo) throws Exception;
	
	public int commMakeOkGet2() throws Exception;
	
	public int commMakeOkGet4() throws Exception;
	
	public int commHomeGet2(String code) throws Exception;

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

	public String checkIfHasReply(String itemList) throws Exception;

	public CommunityBoardItemVO getItemXML(String pBoardID, String pItemID) throws Exception;

	public String newItem(Document xmlData, String pMode, String realPath) throws Exception;
	
	public boolean saveMHT (String strHTML, String strMHTFileName, String strBoardID, String strFilePath, String realPath) throws Exception;

	public String getVersionInfo(String pBoardID) throws Exception;

	public Map<String, String> getAdjacentItems(String pItemID, String pBoardID, String upperItemIDTree, String parentWriteDate) throws Exception;

	public String getItemAttachmentXML(String itemID) throws Exception;
	
	public String getProperSizeDisplay(int pSize) throws Exception;
	
	public boolean saveAttachmentsInfo(String attachments, String itemID, String boardID, String pUploadFilePath, String thumbPath, String realPath) throws Exception;
	
//	public String extractString(String pSource, String pStarts, String pEnds) throws Exception;

//	public String sortXML(String pXML, String pSortBy) throws Exception;
}
