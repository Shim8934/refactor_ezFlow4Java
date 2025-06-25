package egovframework.ezEKP.ezBoard.service;

import java.util.List;
import java.util.Map;

import egovframework.ezEKP.ezOrgan.vo.OrganDeptVO;
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
	
	/* 2018-06-27 홍승비 - 게시물 승인권한 확인 companyID 조건 추가 */
	public List<BoardVO> checkApplyUser(String companyID, int tenantID) throws Exception;
	
	/* 2019-06-04 홍승비 - 전체관리자가 아닌 관리자라면 *그룹사게시판의 경우에만* 접근불가/허용여부 판단용 [게시판ID,accessID;]를 가져오도록 수정, 하위부서 허용여부 판단용 파라미터 추가 */
	public List<BoardVO> getBoardTree_Get2(String pAccessID, String pRootBoardID, int tenantID, boolean isNormalAdmin, int isDept, int isEqualDept) throws Exception;
	
	/* 2018-10-15 홍승비 - 그룹사게시판 표출용 전체관리자 확인 플래그 추가 */
	/* 2018-06-25 홍승비 - 게시판 > 관리자 > 좌측 게시판리스트 표출 시 companyID 조건 추가 */
	public List<BoardTreeVO> get_Admin_TopBoardList(String parentBoardID, String userLang, String companyID, int tenantID, boolean isCompanyAdmin) throws Exception;
	
	/* 2019-06-04 홍승비 - 그룹사게시판에 권한이 설정되도록 수정했으므로, 전체관리자 외의 관리자도 그룹사게시판 권한 체크하여 트리캐시 생성하도록 수정 */
	/* 2018-10-16 홍승비 - 그룹사게시판 표출을 제어하는 showAllGroupBoard 플래그 추가 */
	public List<BoardTreeVO> brdBoardTree(String pRootBoardID, String pAccessID, int pMode, int pSelectBy, String pExcludeBoardID, String companyID, int tenantID, int isDept, int isEqualDept, String showAllGroupBoard, boolean isCompanyAdmin, String boardGroupAdmin_FG) throws Exception;
	
	public List<BoardAttributeVO> getBoardAttribute(String boardID, int tenantID) throws Exception;
	
	public List<BoardAttributeVO> getBoardHeader(String gubun, String boardID, int tenantID) throws Exception;
	
	/* 2018-06-26 홍승비 - 마이게시판 트리 가져올때 companyID 조건 추가 */
	public List<BoardMyFavoriteVO> getMyBoardTree_get3(String userID, String pRootTreeID, String companyID, int tenantID) throws Exception;	
	
	public List<BoardBackgroundVO> getBackGroundImage(BoardBackgroundVO boardBackgroundVO) throws Exception;	
	
	/* 2018-07-19 홍승비 - 게시판 권한 표출 시 companyID 조건 추가 / 2019-01-28 홍승비 - 그룹사게시판 플래그 추가 */
	public List<BoardPropertyVO> getBoardAccessList(String boardID, String isAllGroupBoard, String companyID, int tenantID) throws Exception;
	
	public List<BoardPropertyVO> getUnderBoardID(String boardID, String type, int tenantID) throws Exception;
	
	public BoardPropertyVO getACL(String pBoardID, String userDeptPath, int tenantID) throws Exception;

	public String getBoardTree_Get1(String pStrLang, String pQuery, int tenantID) throws Exception;
	
	public String checkIfBoardGroupAdmin(String pRootBoardID, String pUserID, String pDeptID, String pCompanyID, int tenantID) throws Exception;
	
	/* 2018-10-18 홍승비 - 그룹사게시판 즐겨찾기 분기 추가 */
	/* 2018-06-27 홍승비 - 즐겨찾기에 게시판 추가 시 companyID 삽입 */
	public String addMyBoards(String userID, String boardID, String isAllGroupBoard, String companyID, int tenantID) throws Exception;
	
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

	public String getBoardTreePath(Map<String, Object> map) throws Exception;
	
	public void saveACL(Map<String, Object> map) throws Exception;

	/* 게시판 권한 삭제 시 companyID 조건 부여 */
	public void deleteACL(Document doc, String companyID, int tenantID) throws Exception;

	public void setUnderBoardIDAcl(BoardPropertyVO vo) throws Exception;

	/* 2018-06-26 홍승비 - 권한전파 시 companyID 조건 추가 / 2019-01-28 홍승비 - 그룹사게시판 플래그 추가 */
	public void setUnderBoardIDAcl2(String defaultBoardID, String boardID, String parentBoardID, String isAllGroupBoard, String companyID, int tenantID) throws Exception;

	public void saveBoardProperty_appr(String boardID, String apprUserID, String pMode, int tenantID) throws Exception;

	public void apprProperty_info(String boardID, String mode, int tenantID) throws Exception;

	public void setBoardForm(String boardID, String formLocation, int tenantID) throws Exception;

	public void getBoardTree_Set_D(String pStrLang, String query, int tenantID) throws Exception;

	/* 2018-06-26 홍승비 - 권한복사 시 companyID 추가 */
	public String copyBoardAcl(Document doc, String companyID, int tenantID) throws Exception;

	public void trunkBoard(int tenantID) throws Exception;
	
	/* 2019-05-29 홍승비 - 하위부서 허용/불가여부 체크하여 권한 가져오는 쿼리 추가 (파라미터 오버로딩) */
	public BoardPropertyVO getACL(String pBoardID, String userDeptPath, int tenantID, int isDept, int isEqualDept) throws Exception;
	
	/* 2019-05-29 홍승비 - 하위부서 허용/불가여부 체크하여 게시판그룹의 관리자 권한 가져오는 쿼리 추가(하위게시판이 아닌 게시판그룹의 관리자 권한만을 체크함) */
	public String checkIfBoardGroupAdmin2(String pRootBoardID, String accessID, int tenantID, int isDept, int isEqualDept, boolean isBoardGroup) throws Exception;

	/* 2019-11-08 홍승비 - 전달된 값으로 BOARDTREEPATH를 업데이트하는 메서드 */
	public void updateBoardTreePath(String boardID, String newBoardTreePath, int tenantID) throws Exception;
	
	/* 2019-11-13 홍승비 - 주어진 게시판ID에 대하여 자신을 포함한 모든 상위게시판들을 문자열로 이어붙여 가져오는 메서드 */
	public String getAllUpperBoardID(String boardID, int tenantID) throws Exception;
	
	/* 2020-01-16 홍승비 - 전달된 값으로 BOARDGROUPID를 업데이트하는 메서드 */
	public void updateBoardGroupID(String boardID, String newBoardGroupID, int tenantID) throws Exception;
	
	/* 2019-10-11 홍승비 - 공지사항 게시판 레코드 삭제 */
	public void deleteNoticeBoard(int tenantId, String companyID) throws Exception;

	/* 2019-10-11 홍승비 - 공지사항 게시판 레코드 갱신 */
	public void updateNoticeBoard(String boardID, int tenantId, String companyID) throws Exception;
	
	/* 2020-12-03 박기범 - 탭게시판 레코드 삭제 */
	public void deleteTabBoard(int tabId, int tenantId, String companyID) throws Exception;

	/* 2020-12-03 박기범 - 탭게시판 레코드 갱신 */
	public void updateTabBoard(int tabId, String boardID, int tenantId, String companyID, String boardName, String boardName2) throws Exception;

	public String getUseFormFlag(String boardID, int tenantID) throws Exception;

	List<OrganDeptVO> getListCompanyInBoard(String userID, String primary, int tenantID);

	public void deleteMyBoardData(String type, String boardID, int tenantID) throws Exception;

	public int getBoardItemCnt(String boardID, int tenantId) throws Exception;

	public String saveHWP(String boardID, String formContent, String realPath, int tenantID) throws Exception;
	
	void deleteScrapBoard(String boardID) throws Exception;

	void deleteScrapContBoard(String boardID) throws Exception;
	
	public String getNewGuid() throws Exception;

	public String createModifyHistory(String boardId, int tenantId)  throws Exception;
}
