package egovframework.ezEKP.ezCommunity.service;

import java.util.List;
import java.util.Locale;

import egovframework.ezEKP.ezCommunity.vo.CommunityBoardTreeVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityCBoardVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityClubVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityLeftCommunityVO;

public interface EzCommunityService {
	
	public List<CommunityLeftCommunityVO> leftCommunityGet3(String userID) throws Exception;
	
	public List<CommunityCBoardVO> getLeftBoardList() throws Exception;
	
	public List<CommunityBoardTreeVO> brdBoardTree(String pRootBoardID, String pUserID, String pDeptID, String pCompanyID, int pMode, int pSelectBy, String pExcludeBoardID, String pClubNo) throws Exception;
	
	public List<CommunityBoardTreeVO> getBoardTreeGet2(String pUserID) throws Exception;
	
	public List<String> goAdminOkGet1() throws Exception;
	
	public List<CommunityClubVO> goAdminOkGet2(String pClubID) throws Exception;
	
	public List<CommunityCBoardVO> getBBSListGet2(String bName, String lang, String pKeyword, String sRadio) throws Exception;
	
	public List<CommunityCBoardVO> bbsViewNewGet2(String bName) throws Exception;

	public CommunityCBoardVO bbsViewNewGet1(String bName, String no) throws Exception;
	
	public CommunityCBoardVO bbsEditNew(String bName, String no, String lang) throws Exception;
	
	public CommunityCBoardVO bbsEditOkGet1(String bName, String gant, String code) throws Exception;
	
	public CommunityCBoardVO bbsDelOkGet(String bName, String itemNo, String code) throws Exception;
	
	public String leftCommunityGet1(String code, String userInfoUserID) throws Exception;

	public String leftCommunityGet2(String code) throws Exception;
	
	public String leftCommunityGet4(String code) throws Exception;
	
	public String brdCheckIfBoardGroupAdmin(String pRootBoardID, String id, String deptID, String companyID) throws Exception;

	public String getCategoryValueA(String strSelCateA, Locale locale) throws Exception;

	public String getCategoryValueB(String strSelCateB, Locale locale) throws Exception;
	
	public String getCategoryValueC(String strSelCateC, Locale locale) throws Exception;

	public String getBoardTreeGet1(String pRootBoardID, String pUserID, String pDeptID, String pCompanyID, int pMode, int pSubFlag, int pSelectBy, String pExcludeBoardID, String pClubNo, String strLang) throws Exception;

	public String getCommunityThumInfo(String pBoardID, String pFileName, String pType) throws Exception;
	
	public String getBoardTitleName(String strBoardName, String strClubNo) throws Exception;
	
	public String bbsEditGet1(String bName, String no) throws Exception;
	
	public String getFileFolderName(String bName) throws Exception;
	
	public String bbsEditOkGet2(String maxIdFieldName, String bName, String code) throws Exception;
	
	public String bbsEditOkGet3(String maxIdFieldName, String bName, String code, String strMaxNum) throws Exception;
	
	public int checkIfLeafBoardGet(String boardID) throws Exception;

	public int getBBSListGet1(String bName, String lang, String pKeyword, String sRadio) throws Exception;

	public int bbsAdminCheck(String userID, String rollInfo) throws Exception;

	public void getBoardTreeSet(String pRootBoardID, String pUserID, String pDeptID, String pCompanyID, int pMode, int pSubFlag, int pSelectBy, String pExcludeBoardID, String pClubNo, String strLang, String result) throws Exception;

	public void bbsEditOkSet1(String bName, String title, String gant, String code, String attachList, String textContent) throws Exception;

	public void bbsEditOkSet2(String bName, int myRef, int myStep, String code) throws Exception;

	public void bbsEditOkInsert(String bName, int myRef, int newStep, int newLevel, String attachList, int number, String textContent, String nowDate, String fileName, String code, String companyID, String id, String userNm, String userNm2, String title, String maxIdFieldName) throws Exception;

	public void bbsDelOkDel(String bName, String itemNo, String code) throws Exception;

//	public String extractString(String pSource, String pStarts, String pEnds) throws Exception;

//	public String sortXML(String pXML, String pSortBy) throws Exception;
}
