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

	public String leftCommunityGet1(String code, String userInfoUserID) throws Exception;

	public String leftCommunityGet2(String code) throws Exception;
	
	public String leftCommunityGet4(String code) throws Exception;
	
	public String brdCheckIfBoardGroupAdmin(String pRootBoardID, String id, String deptID, String companyID) throws Exception;

	public String getCategoryValueA(String strSelCateA, Locale locale) throws Exception;

	public String getCategoryValueB(String strSelCateB, Locale locale) throws Exception;
	
	public String getCategoryValueC(String strSelCateC, Locale locale) throws Exception;

	public String getBoardTreeGet1(String pRootBoardID, String pUserID, String pDeptID, String pCompanyID, int pMode, int pSubFlag, int pSelectBy, String pExcludeBoardID, String pClubNo, String strLang) throws Exception;

	public void getBoardTreeSet(String pRootBoardID, String pUserID, String pDeptID, String pCompanyID, int pMode, int pSubFlag, int pSelectBy, String pExcludeBoardID, String pClubNo, String strLang, String result) throws Exception;

	public int checkIfLeafBoardGet(String pBoardID) throws Exception;

	public List<CommunityClubVO> goAdminOkGet2(String pClubID) throws Exception;
	
//	public String extractString(String pSource, String pStarts, String pEnds) throws Exception;

//	public String sortXML(String pXML, String pSortBy) throws Exception;
}
