package egovframework.ezMobile.ezBoard.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.ezMobile.ezBoard.vo.MBoardAttachVO;
import egovframework.ezMobile.ezBoard.vo.MBoardFavoriteVO;
import egovframework.ezMobile.ezBoard.vo.MBoardInfoVO;
import egovframework.ezMobile.ezBoard.vo.MBoardItemVO;
import egovframework.ezMobile.ezBoard.vo.MBoardListHeaderVO;
import egovframework.ezMobile.ezBoard.vo.MBoardListVO;
import egovframework.ezMobile.ezBoard.vo.MBoardNewListVO;
import egovframework.ezMobile.ezBoard.vo.MBoardTreeVO;
import org.egovframe.rte.psl.dataaccess.EgovAbstractDAO;

@Repository("MBoardDAO")
public class MBoardDAO extends EgovAbstractDAO {
	@SuppressWarnings("unchecked")
	public List<MBoardListHeaderVO> getListHeader(Map<String, Object> map) throws Exception {
		return (List<MBoardListHeaderVO>) list("MBoardDAO.getListHeader", map);
	}

	@SuppressWarnings("unchecked")
	public List<MBoardItemVO> getBoardItemList(Map<String, Object> map) throws Exception {
		return (List<MBoardItemVO>) list("MBoardDAO.getBoardItemList", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<MBoardNewListVO> getNewItemList(Map<String, Object> map) throws Exception {
		return (List<MBoardNewListVO>) list("MBoardDAO.getNewItemList", map);
	}

	@SuppressWarnings("unchecked")
	public List<MBoardItemVO> getNoticePostItemList(Map<String, Object> map) throws Exception {
		return (List<MBoardItemVO>) list("MBoardDAO.getNoticePostItemList", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<MBoardFavoriteVO> getFavoriteList(Map<String, Object> map) throws Exception{
		return (List<MBoardFavoriteVO>) list("MBoardDAO.getFavoriteList", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<MBoardTreeVO> brdBoardTree(Map<String, Object> map) throws Exception{		
		return (List<MBoardTreeVO>) list("MBoardDAO.brdBoardTree", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<MBoardInfoVO> getBoardTreeGet2(Map<String, Object> map) throws Exception{		
		return (List<MBoardInfoVO>) list("MBoardDAO.getBoardTreeGet2", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<MBoardAttachVO> getAttachList(Map<String, Object> map) throws Exception{		
		return (List<MBoardAttachVO>) list("MBoardDAO.getAttachList", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<MBoardAttachVO> photoViewDB(Map<String, Object> map) throws Exception{		
		return (List<MBoardAttachVO>) list("MBoardDAO.photoViewDB", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<MBoardTreeVO> getBoardTree_Get2(Map<String, Object> map) throws Exception {		
		return (List<MBoardTreeVO>) list("MBoardDAO.getBoardTree_Get2", map);
	}
	
	public MBoardItemVO getBrdItemInfo(Map<String, Object> map) throws Exception {
		return (MBoardItemVO) select("MBoardDAO.getBrdItemInfo", map);
	}

	public MBoardInfoVO getBoardProperty(Map<String, Object> map) throws Exception {
		return (MBoardInfoVO) select("MBoardDAO.getBoardProperty", map);
	}

	public MBoardInfoVO getACL(Map<String, Object> map) throws Exception {
		return (MBoardInfoVO) select("MBoardDAO.getACL", map);
	}

	public String getBoardApprFlag(Map<String, Object> map) throws Exception {
		return (String) select("MBoardDAO.getBoardApprFlag", map);
	}
	
	public String getApprFlag(Map<String, Object> map) throws Exception {
		return (String) select("MBoardDAO.getApprFlag", map);
	}
	
	public String checkIfBoardGroupAdmin(Map<String, Object> map) throws Exception{
		int ret = (int) select("MBoardDAO.checkIfBoardGroupAdmin", map);
		
		if (ret > 0 ) {
			return "OK";
		} else {
			return "NO";
		}
	}
	
	public String checkFavorite(Map<String, Object> map) throws Exception{
		int ret = (int) select("MBoardDAO.checkFavorite", map);
		
		if (ret > 0 ) {
			return "OK";
		} else {
			return "NO";
		}
	}
	
	public String getDeptPathCode(Map<String, Object> map) throws Exception{
		return (String) select("MBoardDAO.getDeptPathCode", map);
	}
	
	public String getBoardItemRead(Map<String, Object> map) throws Exception{
		return (String) select("MBoardDAO.getBoardItemRead", map);
	}

	public String getWriterID(Map<String, Object> map) throws Exception{
		return (String) select("MBoardDAO.getWriterID", map);
	}
	
	public String getBoardTree_Get1(Map<String, Object> map) throws Exception{		
		return (String) select("MBoardDAO.getBoardTree_Get1", map);
	}

	public Integer getBoardItemListCount(Map<String, Object> map) throws Exception {
		return (Integer) select("MBoardDAO.getBoardItemListCount", map);
	}

	public Integer getNoticePostItemListCount(Map<String, Object> map) throws Exception {
		return (Integer) select("MBoardDAO.getNoticePostItemListCount", map);
	}
	
	public Integer getNewBoardListCount(Map<String, Object> map) throws Exception {
		return (Integer) select("MBoardDAO.getNewBoardListCount", map);
	}
	
	public Integer photoViewDBCount(Map<String, Object> map) throws Exception {
		return (Integer) select("MBoardDAO.photoViewDBCount", map);
	}
	
	public void insertBrdItem(Map<String, Object> map) throws Exception{
		insert("MBoardDAO.insertBrdItem", map);
	}
	
	public void insertBrdItem2(Map<String, Object> map) throws Exception{
		insert("MBoardDAO.insertBrdItem2", map);
	}
	
	public void insertFavorite(Map<String, Object> map) throws Exception{
		insert("MBoardDAO.insertFavorite", map);
	}
	
	public void setAsRead(Map<String, Object> map) throws Exception{
		insert("MBoardDAO.setAsRead", map);
	}
	
	public void saveAttachInfo(Map<String, Object> map) throws Exception{
		insert("MBoardDAO.saveAttachInfo", map);
	}
	
	public void getBoardTree_Set(Map<String, Object> map) throws Exception{		
		update("MBoardDAO.getBoardTree_Set", map);
	}	
	
	public void setAsRead2(Map<String, Object> map) throws Exception{
		update("MBoardDAO.setAsRead2", map);
	}
	
	public void updateItem(Map<String, Object> map) throws Exception{
		update("MBoardDAO.updateItem", map);
	}
	
	public void setApprFlag(Map<String, Object> map) throws Exception{
		update("MBoardDAO.setApprFlag", map);
	}
	
	public void setInitReadCount(Map<String, Object> map) throws Exception{
		update("MBoardDAO.setInitReadCount", map);
	}
	
	public void deleteBoardItem(Map<String, Object> map) throws Exception{
		delete("MBoardDAO.deleteBoardItem", map);
	}
	
	public void deleteBoardReply(Map<String, Object> map) throws Exception{
		delete("MBoardDAO.deleteBoardReply", map);
	}
	
	public void deleteBoardItemRead2(Map<String, Object> map) throws Exception{
		delete("MBoardDAO.deleteBoardItemRead2", map);
	}
	
	public void insertDeleteReservedItem(Map<String, Object> map) throws Exception{
		delete("MBoardDAO.insertDeleteReservedItem", map);
	}
	
	public void deleteFavorite(Map<String, Object> map) throws Exception{
		delete("MBoardDAO.deleteFavorite", map);
	}
	
	public void newItem(Map<String, Object> map) throws Exception{
		delete("MBoardDAO.newItem", map);
	}
	
	public void getBoardTree_Set_D(Map<String, Object> map) throws Exception{
		delete("MBoardDAO.getBoardTree_Set_D", map);
	}

	/* 2018-10-05 홍승비 - 하위부서 허용/불가권한 적용되지 않는 오류 수정(EzBoardDAO 참고), 파라미터를 맵으로 수정 */
	public int isDeptChk(Map<String, Object> map) throws Exception {
		return (int) select("MBoardDAO.isDeptChk", map);
	}
	
	/* 2019-04-10 홍승비 - 사용자가 원회사이고 사내겸직이 존재하면 사내겸직부서ID를 리턴하는 쿼리 */
	@SuppressWarnings("unchecked")
	public List<String> getPDOAddJobDeptID(Map<String, Object> map) throws Exception {
		return (List<String>) list("MBoardDAO.getPDOAddJobDeptID", map);
	}
	
	/* 2019-06-12 홍승비 - 해당 부서ID로 상위부서ID(회사포함) 가져오기*/
	public String getUpperDeptID(Map<String, Object> map) throws Exception {
		return (String) select("MBoardDAO.getUpperDeptID", map);
	}

	/* 2019-09-25 홍승비 - 그룹권한을 포함하여 ACCESSID에 대한 권한정보를 리스트로 리턴하는 쿼리  */
	@SuppressWarnings("unchecked")
	public List<MBoardInfoVO> getACLListNew(Map<String, Object> map) throws Exception {
		return (List<MBoardInfoVO>) list("MBoardDAO.getACLListNew", map);
	}

	/* 2020-04-13 홍승비 - QNA게시판 게시물 카운트 추가 */
	public int getQNABoardItemListCount(Map<String, Object> map) throws Exception {
		return (int) select("MBoardDAO.getQNABoardItemListCount", map);
	}
	
	/* 2020-04-13 홍승비- QNA게시판 게시물 리스트 추가  */
	@SuppressWarnings("unchecked")
	public List<MBoardItemVO> getQNABoardItemList(Map<String, Object> map) throws Exception {
		return (List<MBoardItemVO>) list("MBoardDAO.getQNABoardItemList", map);
	}

	/* 2022-11-18 홍승비 - 모바일 게시판 댓글 저장 기능 추가 */
	public void saveOneLineReply(Map<String, Object> map) throws Exception {
		insert("MBoardDAO.saveOneLineReply", map);
	}

	/* 2023-11-13 전인하 - 모바일 게시판 댓글 수정 */
	public void updateOneLineReply(Map<String, Object> map) throws Exception{
		update("MBoardDAO.updateOneLineReply", map);
	}

	/* 2023-11-13 전인하 - 모바일 게시판 대댓글 저장 */
	public void saveOneLineReReply(Map<String, Object> map) {
		insert("MBoardDAO.saveOneLineReReply", map);
	}

	/* 2023-11-13 전인하 - 댓글이 삭제되었는지의 여부 출력(존재하면 1, 삭제되었을 경우 0) */
	public int checkThisReplyExist(Map<String, Object> map) {
		return (int) select("MBoardDAO.checkThisReplyExist", map);
	}
	
	/* 2023-11-07 민지수 - 모바일 게시판 > 게시판 구분값 조회 추가 */
	public String getGubun(String BoardID) throws Exception {
		return (String) select("MBoardDAO.getGubun", BoardID);
	}

	public int getAllBoardItemListCount(Map<String, Object> map) {
		return (int) select("MBoardDAO.getAllBoardItemListCount", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<MBoardListVO> getAllBoardItemList(Map<String, Object> map) {
		return (List<MBoardListVO>) list("MBoardDAO.getAllBoardItemList", map);
	}

	/* 2023-11-22 기민혁 - 모바일 스크랩 리스트 호출 */
	public List<MBoardNewListVO> getScrapBoardList(Map<String, Object> map) throws Exception {
		return (List<MBoardNewListVO>) list("MBoardDAO.getScrapBoardList", map);
	}

	/* 2023-11-22 기민혁 - 모바일 스크랩 리스트 count */
	public Integer getScrapBoardListCount(Map<String, Object> map) throws Exception {
		return (Integer) select("MBoardDAO.getScrapBoardListCount", map);
	}

	/* 2023-11-22 기민혁 - 모바일 스크랩 리스트 삭제 */
	public void deleteScrapBoardItem(Map<String, Object> map) throws Exception{
		delete("MBoardDAO.deleteScrapBoardItem", map);
	}
	
	/* 2024-09-09 이유정 - 모바일 게시판 > 최근게시물 리스트 카운트 쿼리 */
	public Integer getAllNewBoardListCount(Map<String, Object> map) throws Exception {
		return (Integer) select("MBoardDAO.getAllNewBoardListCount", map);
	}

	/* 2024-09-09 이유정 - 모바일 게시판 > 최근게시물 리스트 쿼리 */
	public List<MBoardNewListVO> getAllNewBoardList(Map<String, Object> map) throws Exception {
		return (List<MBoardNewListVO>) list("MBoardDAO.getAllNewBoardList", map);
	}
}
