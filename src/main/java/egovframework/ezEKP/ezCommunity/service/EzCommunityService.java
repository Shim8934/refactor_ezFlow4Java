package egovframework.ezEKP.ezCommunity.service;

import java.util.List;
import java.util.Locale;

import egovframework.ezEKP.ezCommunity.vo.CommunityCBoardVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityLeftCommunityVO;

public interface EzCommunityService {
	
	List<CommunityLeftCommunityVO> leftCommunityGet3(String userID) throws Exception;
	
	List<CommunityCBoardVO> getLeftBoardList() throws Exception;

	String leftCommunityGet1(String code, String userInfoUserID) throws Exception;

	String leftCommunityGet2(String code) throws Exception;
	
	String leftCommunityGet4(String code) throws Exception;
	/** 나중에도안쓰면 삭제*/
	String checkIfBoardGroupAdmin(String pRootBoardID, String id, String deptID, String companyID) throws Exception;
	/** 나중에도안쓰면 삭제*/
	String getBoardTree(String pRootBoardID, String id, String deptID, String companyID, int pMode, int parseInt, int pSelectBy, String pExcludeBoardID, String code, String multiData) throws Exception;

	String getCategoryValueA(String strSelCateA, Locale locale) throws Exception;

	String getCategoryValueB(String strSelCateB, Locale locale) throws Exception;
	
	String getCategoryValueC(String strSelCateC, Locale locale) throws Exception;
	


}
