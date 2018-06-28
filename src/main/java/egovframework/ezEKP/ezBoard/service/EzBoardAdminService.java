package egovframework.ezEKP.ezBoard.service;

import java.util.List;
import java.util.Map;

import org.w3c.dom.Document;

import egovframework.ezEKP.ezBoard.vo.BoardAttributeVO;
import egovframework.ezEKP.ezBoard.vo.BoardBackgroundVO;
import egovframework.ezEKP.ezBoard.vo.BoardListHeaderVO;
import egovframework.ezEKP.ezBoard.vo.BoardMyFavoriteVO;
import egovframework.ezEKP.ezBoard.vo.BoardPropertyVO;
import egovframework.ezEKP.ezBoard.vo.BoardTreeVO;
import egovframework.ezEKP.ezBoard.vo.BoardVO;
import egovframework.let.user.login.vo.LoginVO;

public interface EzBoardAdminService {
	
	public List<BoardVO> checkApplyUser(int tenantID) throws Exception;
	
	public List<BoardVO> getBoardTree_Get2(String pAccessID, String pRootBoardID, int tenantID) throws Exception;
	
	public List<BoardTreeVO> get_Admin_TopBoardList(String parentBoardID, String multiLang, int tenantID) throws Exception;
	
	public List<BoardTreeVO> brdBoardTree(String pRootBoardID, String pAccessID, int pMode, int pSelectBy, String pExcludeBoardID, int tenantID) throws Exception;
	
	public List<BoardAttributeVO> getBoardAttribute(String boardID, int tenantID) throws Exception;
	
	public List<BoardAttributeVO> getBoardHeader(String gubun, String boardID, int tenantID) throws Exception;
	
	public List<BoardMyFavoriteVO> getMyBoardTree_get3(String userID, String pRootTreeID, int tenantID) throws Exception;	
	
	public List<BoardBackgroundVO> getBackGroundImage(BoardBackgroundVO boardBackgroundVO) throws Exception;	
	
	public List<BoardPropertyVO> getBoardAccessList(String boardID, int tenantID) throws Exception;
	
	public List<BoardPropertyVO> getUnderBoardID(String boardID, String type, int tenantID) throws Exception;
	
	public BoardPropertyVO getACL(String pBoardID, String userDeptPath, int tenantID) throws Exception;

	public String getBoardTree_Get1(String pStrLang, String pQuery, int tenantID) throws Exception;
	
	public String checkIfBoardGroupAdmin(String pRootBoardID, String pUserID, String pDeptID, String pCompanyID, int tenantID) throws Exception;
	
	public String addMyBoards(String userID, String boardID, int tenantID) throws Exception;
	
	public String setMyBoardTreeConfig(BoardMyFavoriteVO boardMyFavoriteVO) throws Exception;
	
	public String setMyBoardTreeMoveCopy(BoardMyFavoriteVO boardMyFavoriteVO) throws Exception;
	
	public String saveMHT(String boardID, String formContent, String realPath, int tenantID) throws Exception;
	
	public int checkIfLeafBoard(String pBoardID, int tenantID) throws Exception;
	
	public int checkForm(String boardID, String mode, int tenantID) throws Exception;
	
	public void getBoardTree_Set(String pStrLang, String query, String result, int tenantID) throws Exception;	
		
	public void createBoardGroup(BoardPropertyVO boardPropertyVO) throws Exception;
	
	public void createBoard(BoardPropertyVO boardPropertyVO) throws Exception;
	
	public void saveBoardOrder(String pBoardIDList, int tenantID) throws Exception;
	
	public void deleteBoard(String boardID, int tenantID) throws Exception;
	
	public void statusChangeBackGroundImage(BoardBackgroundVO boardBackgroundVO) throws Exception;
	
	public void saveBackGroundImage(BoardBackgroundVO boardBackgroundVO) throws Exception;
	
	public void deleteBackGroundImage(BoardBackgroundVO boardBackgroundVO) throws Exception;
	
	public void moveBoard(String orgBoardID, String newParentBoardID, String newBoardGroupID, int tenantID) throws Exception;
	
	public void saveBoardProperty(BoardPropertyVO boardPropertyVO) throws Exception;
	
	public void deleteAttribute(String boardID, int tenantID) throws Exception;
		
	public void updateAttribute(BoardAttributeVO boardAttributeVO) throws Exception;

	public String saveAttribute(Document doc, LoginVO userInfo, BoardAttributeVO boardAttributeVO) throws Exception;

	public void deleteHeader(String boardID, int tenantID) throws Exception;

	public String saveHeader(Document doc, LoginVO userInfo, BoardListHeaderVO boardListHeaderVO) throws Exception;

	public void saveACL(Map<String, Object> map) throws Exception;

	public void deleteACL(Document doc, int tenantID) throws Exception;

	public void setUnderBoardIDAcl(BoardPropertyVO vo) throws Exception;

	public void setUnderBoardIDAcl2(String defaultBoardID, String boardID, String parentBoardID, int tenantID) throws Exception;

	public void saveBoardProperty_appr(String boardID, String apprUserID, String pMode, int tenantID) throws Exception;

	public void apprProperty_info(String boardID, String mode, int tenantID) throws Exception;

	public void setBoardForm(String boardID, String formLocation, int tenantID) throws Exception;

	public void getBoardTree_Set_D(String pStrLang, String query, int tenantID) throws Exception;

	public String copyBoardAcl(Document doc, int tenantID) throws Exception;
	

}
