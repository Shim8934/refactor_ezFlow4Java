package egovframework.ezEKP.ezBoard.service;

import java.util.List;

import egovframework.ezEKP.ezBoard.vo.BoardTreeVO;
import egovframework.ezEKP.ezBoard.vo.EzBoardVO;

public interface EzBoardAdminService {

	String checkIfBoardGroupAdmin(String pRootBoardID, String pUserID, String pDeptID, String pCompanyID) throws Exception;

	List<EzBoardVO> checkApplyUser() throws Exception;

	String getBoardTree_Get1(String pStrLang, String string) throws Exception;

	String getDeptFullPath(String pDeptID, String string) throws Exception;

	List<EzBoardVO> getBoardTree_Get2(String pAccessID, String pRootBoardID) throws Exception;

	List<BoardTreeVO> brdBoardTree(String pRootBoardID, String pAccessID, int pMode, int pSelectBy, String pExcludeBoardID) throws Exception;

	void getBoardTree_Set(String pStrLang, String string, String string2) throws Exception;

	int checkIfLeafBoard(String pBoardID) throws Exception;

}
