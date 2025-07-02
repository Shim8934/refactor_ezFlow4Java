package egovframework.ezEKP.ezBoard.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.ezEKP.ezBoard.vo.BoardAttributeVO;
import egovframework.ezEKP.ezBoard.vo.BoardBackgroundVO;
import egovframework.ezEKP.ezBoard.vo.BoardListHeaderVO;
import egovframework.ezEKP.ezBoard.vo.BoardPropertyVO;
import egovframework.ezEKP.ezBoard.vo.BoardTreeVO;
import egovframework.ezEKP.ezBoard.vo.BoardVO;
import egovframework.ezEKP.ezBoard.vo.BoardMyFavoriteVO;
import egovframework.ezEKP.ezBoard.vo.BoardListVO;
import org.egovframe.rte.psl.dataaccess.EgovAbstractDAO;

@Repository("EzBoardAdminDAO")
public class EzBoardAdminDAO extends EgovAbstractDAO {	
		
	@SuppressWarnings("unchecked")
	public List<BoardVO> checkApplyUser(Map<String, Object> map) throws Exception {
		return (List<BoardVO>) list("EzBoardAdminDAO.checkApplyUser", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<BoardVO> getBoardTree_Get2(Map<String, Object> map) throws Exception {		
		return (List<BoardVO>) list("EzBoardAdminDAO.getBoardTree_Get2", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<BoardTreeVO> brdBoardTree(Map<String, Object> map) throws Exception{		
		return (List<BoardTreeVO>) list("EzBoardAdminDAO.brdBoardTree", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<BoardTreeVO> get_Admin_TopBoardList(Map<String, Object> map) {		
		return (List<BoardTreeVO>) list("EzBoardAdminDAO.get_Admin_TopBoardList", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<BoardMyFavoriteVO> getMyBoardTree_get3(Map<String, Object> map) throws Exception{		
		return (List<BoardMyFavoriteVO>) list("EzBoardAdminDAO.getMyBoardTree_get3", map);
	}	
	
	@SuppressWarnings("unchecked")
	public List<BoardBackgroundVO> getBackGroundImage(BoardBackgroundVO boardBackgroundVO) {		
		return (List<BoardBackgroundVO>) list("EzBoardAdminDAO.getBackGroundImage", boardBackgroundVO);
	}	

	@SuppressWarnings("unchecked")
	public List<BoardAttributeVO> getBoardHeader(Map<String, Object> map) throws Exception{		
		return (List<BoardAttributeVO>) list("EzBoardAdminDAO.getBoardHeader", map);		
	}
	
	@SuppressWarnings("unchecked")
	public List<BoardAttributeVO> getBoardHeader_B(Map<String, Object> map) throws Exception{		
		return (List<BoardAttributeVO>) list("EzBoardAdminDAO.getBoardHeader_B", map);		
	}
	
	@SuppressWarnings("unchecked")
	public List<BoardAttributeVO> getBoardAttribute(Map<String, Object> map) throws Exception{
		return (List<BoardAttributeVO>) list("EzBoardAdminDAO.getBoardAttribute", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<BoardPropertyVO> getBoardAccessList(Map<String, Object> map) throws Exception{
		return (List<BoardPropertyVO>) list("EzBoardAdminDAO.getBoardAccessList", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<BoardPropertyVO> getUnderBoardID(Map<String, Object> map) throws Exception{
		return (List<BoardPropertyVO>) list("EzBoardAdminDAO.getUnderBoardID", map);
	}
	
	public BoardPropertyVO getACL(Map<String, Object> map) throws Exception{		
		return (BoardPropertyVO) select("EzBoardAdminDAO.getACL", map);
	}
	
	public String getBoardTree_Get1(Map<String, Object> map) throws Exception{		
		return (String) select("EzBoardAdminDAO.getBoardTree_Get1", map);
	}

	public String checkIfBoardGroupAdmin(Map<String, Object> map) throws Exception{
		int ret = (int) select("EzBoardAdminDAO.checkIfBoardGroupAdmin", map);
		
		if (ret > 0 ) {
			return "OK";
		} else {
			return "NO";
		}
	}	

	public int checkIfLeafBoard(Map<String, Object> map) throws Exception{		
		return (int) select("EzBoardAdminDAO.checkIfLeafBoard", map);
	}
	
	public int checkForm(Map<String, Object> map) throws Exception{
		return (int) select("EzBoardAdminDAO.checkForm", map);
	}
	
	public void createBoardGroup(Map<String, Object> map) throws Exception{		
		insert("EzBoardAdminDAO.createBoardGroup", map);
	}
	
	public void createBoardGroup2(Map<String, Object> map) throws Exception{		
		insert("EzBoardAdminDAO.createBoardGroup2", map);
	}
	
	public void createBoard_I(Map<String, Object> map) throws Exception{
		insert("EzBoardAdminDAO.createBoard_I", map);
	}
	
	public void createBoard_I2(Map<String, Object> map) throws Exception{
		insert("EzBoardAdminDAO.createBoard_I2", map);
	}
	
	public void createBoard_U(Map<String, Object> map) throws Exception{
		update("EzBoardAdminDAO.createBoard_U", map);
	}
	
	public void saveBoardOrder(Map<String, Object> map) throws Exception{			
		update("EzBoardAdminDAO.saveBoardOrder", map);
	}
	
	public void deleteBoard(Map<String, Object> map) throws Exception{		
		delete("EzBoardAdminDAO.deleteBoard", map);
	}
	
	public void addMyBoards(Map<String, Object> map) {
		insert("EzBoardAdminDAO.addMyBoards", map);
	}
	
	public void saveAttribute(BoardAttributeVO boardAttributeVO) throws Exception{		
		insert("EzBoardAdminDAO.saveAttribute", boardAttributeVO);
	}

	public void saveHeader(BoardListHeaderVO boardListHeaderVO) throws Exception{
		insert("EzBoardAdminDAO.saveHeader", boardListHeaderVO);
	}

	public void saveACL_I(Map<String, Object> map) throws Exception{
		insert("EzBoardAdminDAO.saveACL_I", map);
	}
	
	public String getBoardTreePath(Map<String, Object> map) throws Exception {
		return (String) select("EzBoardAdminDAO.getBoardTreePath", map);
	}
	
	public void saveACLIncludeUppderBoard(Map<String, Object> map) throws Exception {
		insert("EzBoardAdminDAO.saveACLIncludeUppderBoard", map);
	}
	
	public void saveACLIncludeLowerBoard(Map<String, Object> map) throws Exception {
		update("EzBoardAdminDAO.saveACLIncludeLowerBoard", map);
	}
	
	public void saveACL_U(Map<String, Object> map) throws Exception{
		update("EzBoardAdminDAO.saveACL_U", map);
	}
	
	public void setUnderBoardIDAcl_U(Map<String, Object> map) throws Exception{
		update("EzBoardAdminDAO.setUnderBoardIDAcl_U", map);		
	}
	
	public void setUnderBoardIDAcl_I(Map<String, Object> map) throws Exception{
		insert("EzBoardAdminDAO.setUnderBoardIDAcl_I", map);		
	}

	public void setUnderBoardIDAcl2(Map<String, Object> map) throws Exception{
		insert("EzBoardAdminDAO.setUnderBoardIDAcl2", map);
	}

	public void copyBoardAcl(Map<String, Object> map) throws Exception{
		insert("EzBoardAdminDAO.copyBoardAcl", map);		
	}
	
	public void saveBoardProperty_appr_D(Map<String, Object> map) throws Exception{
		delete("EzBoardAdminDAO.saveBoardProperty_appr_D", map);		
	}
	
	public void saveBoardProperty_appr_I(Map<String, Object> map) throws Exception{
		insert("EzBoardAdminDAO.saveBoardProperty_appr_I", map);		
	}
	
	public void apprProperty_info(Map<String, Object> map) throws Exception{
		insert("EzBoardAdminDAO.apprProperty_info", map);	
	}

	public void setMyBoardTreeConfig(BoardMyFavoriteVO boardMyFavoriteVO) throws Exception{
		update("EzBoardAdminDAO.setMyBoardTreeConfig", boardMyFavoriteVO);
	}
	
	public void setMyBoardTreeMoveCopy(BoardMyFavoriteVO boardMyFavoriteVO) throws Exception{
		update("EzBoardAdminDAO.setMyBoardTreeMoveCopy", boardMyFavoriteVO);
	}

	public void getBoardTree_Set(Map<String, Object> map) throws Exception{		
		update("EzBoardAdminDAO.getBoardTree_Set", map);
	}		
	
	public void statusChangeBackGroundImage(BoardBackgroundVO boardBackgroundVO) throws Exception{	
		update("EzBoardAdminDAO.statusChangeBackGroundImage", boardBackgroundVO);
	}
	
	public void saveBackGroundImage_I(Map<String, Object> map) throws Exception{		
		update("EzBoardAdminDAO.saveBackGroundImage_I", map);
	}
	
	public void saveBackGroundImage_U(Map<String, Object> map) throws Exception{		
		update("EzBoardAdminDAO.saveBackGroundImage_U", map);
	}
	
	public void moveBoard(Map<String, Object> map) throws Exception{		
		update("EzBoardAdminDAO.moveBoard", map);
	}
	
	public void moveBoard2(Map<String, Object> map) throws Exception{		
		update("EzBoardAdminDAO.moveBoard2", map);
	}
	
	public void saveBoardProperty(Map<String, Object> map) throws Exception{		
		update("EzBoardAdminDAO.saveBoardProperty", map);
	}
	
	public void saveBoardProperty2(Map<String, Object> map) throws Exception{		
		update("EzBoardAdminDAO.saveBoardProperty2", map);
	}
	
	public void updateAttribute(BoardAttributeVO boardAttributeVO) throws Exception{		
		update("EzBoardAdminDAO.updateAttribute", boardAttributeVO);
	}

	public void setBoardForm(Map<String, Object> map) throws Exception{
		update("EzBoardAdminDAO.setBoardForm", map);
	}
	
	public void deleteAttribute(Map<String, Object> map) throws Exception{		
		delete("EzBoardAdminDAO.deleteAttribute", map);
	}	
	
	public void deleteBackGroundImage(BoardBackgroundVO boardBackgroundVO) throws Exception{		
		delete("EzBoardAdminDAO.deleteBackGroundImage", boardBackgroundVO);
	}

	public void deleteHeader(Map<String, Object> map) throws Exception{
		delete("EzBoardAdminDAO.deleteHeader", map);
	}

	public void deleteACL(Map<String, Object> map) throws Exception{
		delete("EzBoardAdminDAO.deleteACL", map);		
	}
	
	public void deleteACLUnderBoard(Map<String, Object> map) throws Exception {
		delete("EzBoardAdminDAO.deleteACLUnderBoard", map);
	}

	public void trunkBoard(int tenantID) throws Exception{
		delete("EzBoardAdminDAO.trunkBoard", tenantID);
	}

	public void getBoardTree_Set_D(Map<String, Object> map) throws Exception{
		delete("EzBoardAdminDAO.getBoardTree_Set_D", map);
	}

	public void deleteTreeCache(Map<String, Object> map) throws Exception{
		delete("EzBoardAdminDAO.deleteTreeCache", map);
	}

	public void setMyBoardTreeConfig_N(BoardMyFavoriteVO boardMyFavoriteVO) throws Exception{
		insert("EzBoardAdminDAO.setMyBoardTreeConfig_N", boardMyFavoriteVO);
	}

	public void setMyBoardTreeConfig_M(BoardMyFavoriteVO boardMyFavoriteVO) throws Exception{
		update("EzBoardAdminDAO.setMyBoardTreeConfig_M", boardMyFavoriteVO);
	}

	public void setMyBoardTreeConfig_D(BoardMyFavoriteVO boardMyFavoriteVO) throws Exception{
		delete("EzBoardAdminDAO.setMyBoardTreeConfig_D", boardMyFavoriteVO);
	}

	public String getParentBoardID(Map<String, Object> map) throws Exception{
		return (String) select("EzBoardAdminDAO.getParentBoardID", map);
	}

	public String getBoardID(Map<String, Object> map) throws Exception{
		return (String) select("EzBoardAdminDAO.getBoardID", map);
	}

	public void deleteBoardManage(Map<String, Object> map) throws Exception{
		delete("EzBoardAdminDAO.deleteBoardManage", map);
	}

	public void deleteBoardInfo(Map<String, Object> map) throws Exception{
		delete("EzBoardAdminDAO.deleteBoardInfo", map);
	}

	public void deleteBoardMyBoard(Map<String, Object> map) throws Exception{
		delete("EzBoardAdminDAO.deleteBoardMyBoard", map);
	}

	public void insertDeleteReservedBoard(Map<String, Object> map) throws Exception{
		insert("EzBoardAdminDAO.insertDeleteReservedBoard", map);
	}

	public String getBoardItemListOptionBoard(Map<String, Object> map) throws Exception{
		return (String) select("EzBoardAdminDAO.getBoardItemListOptionBoard", map);
	}

	public int getBoardManage(Map<String, Object> map) throws Exception{
		return (int) select("EzBoardAdminDAO.getBoardManage", map);
	}

	public String getMyBoardTreeUpper(BoardMyFavoriteVO boardMyFavoriteVO) throws Exception {
		return (String) select("EzBoardAdminDAO.getMyBoardTreeUpper", boardMyFavoriteVO);
	}

	/* 2018-07-12 홍승비 - PRI 제약을 가지는 CompanyID 칼럼의 데이터 삽입 판단용 분기 추가 */
	public int checkCompanyIDCol() {
		return (int) select("EzBoardAdminDAO.checkCompanyIDCol");
	}
	
	/* 2018-09-18 홍승비 - 게시판 이름변경 시 마이게시판에 등록된 게시판명도 변경되도록 수정 */
	public void saveBoardProperty3(Map<String, Object> map) throws Exception {		
		update("EzBoardAdminDAO.saveBoardProperty3", map);
	}
	
	/* 2019-05-29 홍승비 - 하위부서 허용/불가여부 체크하여 게시판그룹의 관리자 권한 가져오는 쿼리 추가 */
	public String checkIfBoardGroupAdmin2(Map<String, Object> map) throws Exception {
		return (String) select("EzBoardAdminDAO.checkIfBoardGroupAdmin2", map);
	}

	/* 2019-11-08 홍승비 - 전달된 값으로 BOARDTREEPATH를 업데이트하는 쿼리 */
	public void updateBoardTreePath(Map<String, Object> map) throws Exception {
		update("EzBoardAdminDAO.updateBoardTreePath", map);
	}

	/* 2019-11-13 홍승비 - 권한복사 시 상위게시판에 권한정보 일부 삽입 또는 업데이트 */
	public void saveACLIncludeUppderBoard2(Map<String, Object> map) throws Exception {
		insert("EzBoardAdminDAO.saveACLIncludeUppderBoard2", map);
	}
	
	/* 2019-10-11 홍승비 - 공지사항 게시판 레코드 삭제 쿼리 */
	public void deleteNoticeBoard(Map<String, Object> map) throws Exception {
		delete("EzBoardAdminDAO.deleteNoticeBoard", map);
	}

	/* 2019-10-11 홍승비 - 공지사항 게시판 레코드 삽입 쿼리 */
	public void insertNoticeBoard(Map<String, Object> map) throws Exception {
		insert("EzBoardAdminDAO.insertNoticeBoard", map);
	}
	
	/* 2020-01-16 홍승비 - 전달된 값으로 BOARDGROUPID를 업데이트하는 메서드 */
	public void updateBoardGroupID(Map<String, Object> map) throws Exception {
		update("EzBoardAdminDAO.updateBoardGroupID", map);
	}

	/* 2020-12-03 박기범 - 탭게시판 레코드 삭제 쿼리 */
	public void deleteTabBoard(Map<String, Object> map) throws Exception {
		delete("EzBoardAdminDAO.deleteTabBoard", map);
	}

	/* 2020-12-03 박기범 - 탭게시판 레코드 삽입 쿼리 */
	public void insertTabBoard(Map<String, Object> map) throws Exception {
		insert("EzBoardAdminDAO.insertTabBoard", map);
	}

	/* 2020-12-30 박기범 - 탭게시판 레코드 일괄삭제 쿼리 */
	public void deleteAllComTabBoard(Map<String, Object> map) throws Exception {
		delete("EzBoardAdminDAO.deleteAllComTabBoard", map);
	}
	public void deleteAllTabBoard(Map<String, Object> map) throws Exception {
		delete("EzBoardAdminDAO.deleteAllTabBoard", map);
	}

	public String getUseFormFlag(String boardID, int tenantID) throws Exception {
		HashMap<String, String> map = new HashMap() {{
			put("boardID", boardID);
			put("tenantID", tenantID);
		}};

		return (String)select("EzBoardAdminDAO.getUseFormFlag", map);
	}
	
	public void deleteMyBoardsOnCategoryChange(Map<String, Object> map) throws Exception {
		delete("EzBoardAdminDAO.deleteMyBoardsOnCategoryChange", map);
	}

	public void deleteMyBoardTreeOnCategoryChange(Map<String, Object> map) throws Exception {
		delete("EzBoardAdminDAO.deleteMyBoardTreeOnCategoryChange", map);
	}

	public int getBoardItemCnt(Map<String, Object> map) throws Exception {
		return (int) select("EzBoardAdminDAO.getBoardItemCnt", map);
	}
	public void deleteScrapBoard(String boardID) throws Exception {
		delete("EzBoardAdminDAO.deleteScrapBoard", boardID);
	}

	public void deleteScrapContBoard(String boardID) throws Exception {
		delete("EzBoardAdminDAO.deleteScrapContBoard", boardID);
	}

	public List<BoardListVO> getCreateHistoryTarget(Map<String, Object> map) throws Exception {
		return (List<BoardListVO>) list("EzBoardAdminDAO.getCreateHistoryTarget", map);
	}
	public List<Map<String, String>> boardNotiEndAlram() throws Exception {
		return (List<Map<String, String>>) list("EzBoardAdminDAO.boardNotiEndAlram");
	}

}
