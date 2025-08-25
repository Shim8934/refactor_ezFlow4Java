package egovframework.ezMobile.ezBoard.service;

import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import org.json.simple.JSONObject;

import egovframework.ezMobile.ezBoard.vo.MBoardAttachVO;
import egovframework.ezMobile.ezBoard.vo.MBoardFavoriteVO;
import egovframework.ezMobile.ezBoard.vo.MBoardInfoVO;
import egovframework.ezMobile.ezBoard.vo.MBoardItemVO;
import egovframework.ezMobile.ezBoard.vo.MBoardListHeaderVO;
import egovframework.ezMobile.ezBoard.vo.MBoardListVO;
import egovframework.ezMobile.ezBoard.vo.MBoardNewListVO;
import egovframework.ezMobile.ezBoard.vo.MBoardTreeVO;
import egovframework.ezMobile.ezOption.vo.MCommonVO;

public interface MBoardService {
	List<MBoardListHeaderVO> getListHeader(MBoardInfoVO mBoardInfoVO, String lang, int tenantID) throws Exception;
	
	List<MBoardItemVO> getBoardItemList(MBoardInfoVO mBoardInfoVO, MCommonVO info, String lastDate,String userID,String add, String pSearchText, String parentWriteDate, String upperitemidtree) throws Exception;

	// 현재 주석처리되어 미사용
	List<MBoardNewListVO> getNewBoarditemList(MBoardInfoVO mBoardInfoVO, MCommonVO info, String userID, String pSearchText, String parentWriteDate, String upperitemidtree) throws Exception;
	
	/* 2018-07-03 홍승비 - 게시판 풋터리스트에 companyID 조건 추가 */
	List<MBoardFavoriteVO> getFavoriteList(String userID, String companyID, int tenantID, String primary) throws Exception;
	
	/* 2018-07-03 홍승비 - 좌측메뉴 리스트 표시 시 companyID 조건 추가 */
	/* 2019-06-11 홍승비 - 하위부서 허용/불가권한 적용되지 않는 오류 수정(EzBoardAdmin 참고), 전체관리자 외의 관리자도 그룹사게시판 권한 체크하도록 수정 */
	List<MBoardTreeVO> brdBoardTree(String rootBoardID, String accessID, int mode, int selectBy, String excludeBoardID, String companyID, int tenantID, String primary, int isDept, int isEqualDept, boolean isCompanyAdmin, String boardGroupAdmin_FG) throws Exception;
	
	/* 2018-07-03 홍승비 - 포탈 메인 새게시물 리스트 표시 시 deptID, companyID 조건 추가  */
	List<MBoardNewListVO> getBoardMainList(String userID, String listCnt, String deptID, String companyID, int tenantID, String offset) throws Exception;
	
	/* 2018-07-03 홍승비 - 새게시물 리스트 표시 시 deptID, companyID 조건 추가 */
	List<MBoardNewListVO> getNewBoardList(String userID, String lastDate, String deptID, String companyID, int tenantID, String offset, String pSearchText) throws Exception;
	
	List<MBoardAttachVO> getAttachList(String itemID, int tenantID) throws Exception;
	
	List<MBoardAttachVO> photoViewDB(String itemID, String boardID,int tenantID) throws Exception;
	
	List<MBoardTreeVO> getBoardTree(String rootBoardID, int mode, int subFlag, int selectBy, String excludeBoardID, MCommonVO info) throws Exception;
	
	List<MBoardTreeVO> getBoardTree_Get2(String pAccessID, String pRootBoardID, int tenantID) throws Exception;
	
	MBoardInfoVO getBoardInfo(MBoardInfoVO mBoardInfoVO, String rollInfo, String deptPathCode, MCommonVO info) throws Exception;
	
	MBoardInfoVO getBoardProperty(String boardID, String primary, int tenantID, String userID) throws Exception;
	
	MBoardItemVO getBrdItemInfo(String itemID, String lang, int tenantID) throws Exception;
	
	//String getBoardTree_Get1(String pStrLang, String pQuery, int tenantID) throws Exception;
	
	String checkIfBoardGroupAdmin(String rootBoardID, String userID, String deptID, String companyID, int tenantID) throws Exception;
	
	String getDeptPathCode(String departmentID,int tenantID) throws Exception;
	
	String getMhtContent(String realPath, String domain, MCommonVO userInfo, String url,Locale locale, String scheme) throws Exception;
	
	String checkFavorite(String userID, String boardID, int tenantID) throws Exception;
	
	/* 2018-07-03 홍승비 - 새게시물 카운트 표시 시 companyID 조건 추가 */
	Integer getNewBoardListCount(String userID, String startDate, String companyID, int tenantID, String pSearchText) throws Exception;
	
	int getBoardItemListCount(String boardID, String userID, String guBun, int tenantID, String pSearchText, String versionManage) throws Exception;
	
	Integer photoViewDBCount(String itemID, String boardID, int tenantID) throws Exception;
	
	void insertBrdItem(JSONObject boardListVO, MCommonVO info, String realPath, String mhtData) throws Exception;
	
	void insertBrdItem2(JSONObject boardListVO) throws Exception;
	
	void setAsRead(MCommonVO userInfo, String boardID, String itemID) throws Exception;
	
	void updateItem(JSONObject boardListVO, MCommonVO info, String realPath, String mhtData) throws Exception;
	
	void deleteItem(String itemID, String boardID, int tenantID) throws Exception;
	
	/* 2018-10-25 홍승비 - 모바일 그룹사게시판 즐겨찾기 분기 추가 */
	/* 2018-07-04 홍승비 - 모바일 게시판 즐겨찾기 추가 시 companyID 삽입 */
	void insertFavorite(String userID, String boardID, String companyID, int tenantID, String isAllGroupBoard) throws Exception;
	
	void deleteFavorite(String userID, String boardID, int tenantID) throws Exception;
	
	//void getBoardTree_Set_D(String pStrLang, String query, int tenantID) throws Exception;
	
	void getBoardTree_Set(String pStrLang, String query, String result, int tenantID) throws Exception;
	
	/* 2019-04-10 홍승비 - 사용자가 원회사이고 사내겸직이 존재하면 사내겸직부서ID를 리턴 */
	public List<String> getPDOAddJobDeptID(String userID, String companyID, int tenantID) throws Exception;
	
	/* 2019-06-11 홍승비 - 해당 부서ID로 상위부서ID(회사포함) 가져오기*/
	public String getUpperDeptID(String deptID, int tenantID) throws Exception;
	
	/* 2019-06-11 홍승비 - 해당 ID가 부서(회사)ID인지 확인하는 기능 서비스로 분리 */
	public int isDeptChk(String id, int tenantID) throws Exception;
	
	/* 2020-04-13 홍승비 - QNA게시판 게시물 카운트 추가 */
	int getQNABoardItemListCount(String boardID, MBoardInfoVO mBoardInfoVO, String userID, String guBun, int tenantID, String pSearchText) throws Exception;

	/* 2022-11-18 홍승비 - 모바일 게시판 댓글 저장 기능 추가 */
	public void saveOneLineReply(String itemID, String replyID, String boardID, String userID, String displayName, String displayName2, int tenantID, String companyID, String content, String imageContent) throws Exception;

	/* 2023-11-13 전인하 - 모바일 게시판 댓글 수정 */
	public void updateOneLineReply(String contentId, String replyID, String content, int tenantId, String imageContent) throws Exception;

	/* 2023-11-13 전인하 - 모바일 게시판 대댓글 삽입 */
	public void saveOneLineReReply(String contentId, String boardId, String replyID, String parentReplyID, String content, String password, MCommonVO info, String imageContent) throws Exception;

	/* 2023-11-13 전인하 - 부모댓글인지 체크 (자식댓글 갯수 반환) */
	public int checkThisReplyExist(String replyId, String itemId, int tenantId) throws Exception;
	
	public String getGubun(String BoardID) throws Exception;

	public int getAllBoardItemListCount(String userId, String companyId, int tenantId) throws Exception;

	List<MBoardListVO> getAllBoardItemList(String userId, String lastDate, String deptId, String companyId, int tenantId, String offSet) throws Exception;

	/* 2023-11-21 기민혁 - 모바일 스크랩 리스트 호출 */
	List<MBoardNewListVO> getScrapBoardList(String userID, String deptID, String companyID, int tenantID, String offset, String pSearchText, ArrayList<String> scrapBoardListView_FG) throws Exception;

	/* 2023-11-21 기민혁 - 모바일 스크랩 리스트 count */
	Integer getScrapBoardListCount(String userID, String companyID, int tenantID, String pSearchText, ArrayList<String> scrapBoardListView_FG) throws Exception;

	public Map<String, ArrayList<String>> getScrapBoardListReadView_FG(MCommonVO info) throws Exception;

	/* 2024-09-09 이유정 - 모바일 게시판 > 최근게시물 리스트 카운트 */
	Integer getAllNewBoardListCount(String userID, String startDate, String companyID, int tenantID, String pSearchText) throws Exception;
	
	/* 2024-09-09 이유정 - 모바일 게시판 > 최근게시물 리스트 */
	List<MBoardNewListVO> getAllNewBoardList(String userID, String lastDate, String deptID, String companyID, int tenantID, String offset, String pSearchText) throws Exception;

	List<MBoardTreeVO> getBoardInfoByList(MBoardInfoVO boardInfo, String rollInfo, String deptPathCode, MCommonVO info, List<MBoardTreeVO> list) throws Exception;
}
