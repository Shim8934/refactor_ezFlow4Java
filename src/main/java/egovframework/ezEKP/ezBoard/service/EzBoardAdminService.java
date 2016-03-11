package egovframework.ezEKP.ezBoard.service;

import java.util.List;

import egovframework.ezEKP.ezBoard.vo.BoardBackgroundVO;
import egovframework.ezEKP.ezBoard.vo.BoardPropertyVO;
import egovframework.ezEKP.ezBoard.vo.BoardTreeVO;
import egovframework.ezEKP.ezBoard.vo.EzBoardVO;
import egovframework.ezEKP.ezBoard.vo.MyFavoriteVO;

public interface EzBoardAdminService {

	public String checkIfBoardGroupAdmin(String pRootBoardID, String pUserID, String pDeptID, String pCompanyID) throws Exception;

	public List<EzBoardVO> checkApplyUser() throws Exception;

	public String getBoardTree_Get1(String pStrLang, String string) throws Exception;

	public List<EzBoardVO> getBoardTree_Get2(String pAccessID, String pRootBoardID) throws Exception;

	public List<BoardTreeVO> brdBoardTree(String pRootBoardID, String pAccessID, int pMode, int pSelectBy, String pExcludeBoardID) throws Exception;

	public void getBoardTree_Set(String pStrLang, String string, String string2) throws Exception;

	public int checkIfLeafBoard(String pBoardID) throws Exception;

	public List<MyFavoriteVO> getMyBoardTree_get3(String userID, String pRootTreeID) throws Exception;
	
	public List<BoardTreeVO> get_Admin_TopBoardList(String parentBoardID) throws Exception;
	
	public List<BoardBackgroundVO> getBackGroundImage(BoardBackgroundVO boardBackgroundVO) throws Exception;

	public BoardPropertyVO getACL(String pBoardID, String userDeptPath) throws Exception;
	
	public void createBoardGroup(BoardPropertyVO boardPropertyVO) throws Exception;
	
	public void createBoard(BoardPropertyVO boardPropertyVO) throws Exception;
	
	public void saveBoardOrder(String pBoardIDList) throws Exception;
	
	public void deleteBoard(String boardID) throws Exception;
	
	public void statusChangeBackGroundImage(BoardBackgroundVO boardBackgroundVO) throws Exception;
	
	public void saveBackGroundImage(BoardBackgroundVO boardBackgroundVO) throws Exception;
	
	public void deleteBackGroundImage(BoardBackgroundVO boardBackgroundVO) throws Exception;
	
	public void moveBoard(String orgBoardID, String newParentBoardID, String newBoardGroupID) throws Exception;
	
	public void saveBoardProperty(BoardPropertyVO boardPropertyVO) throws Exception;

}
