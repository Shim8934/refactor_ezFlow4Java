package egovframework.ezMobile.ezBoard.service;

import java.util.List;
import java.util.Locale;

import org.json.simple.JSONObject;

import egovframework.ezEKP.ezBoard.vo.BoardVO;
import egovframework.ezMobile.ezBoard.vo.MBoardAttachVO;
import egovframework.ezMobile.ezBoard.vo.MBoardFavoriteVO;
import egovframework.ezMobile.ezBoard.vo.MBoardInfoVO;
import egovframework.ezMobile.ezBoard.vo.MBoardItemVO;
import egovframework.ezMobile.ezBoard.vo.MBoardListHeaderVO;
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
	List<MBoardTreeVO> brdBoardTree(String rootBoardID, String accessID, int mode, int selectBy, String excludeBoardID, String companyID, int tenantID, String primary) throws Exception;
	
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
	
	int getBoardItemListCount(String boardID, String userID, String guBun, int tenantID, String pSearchText) throws Exception;
	
	Integer photoViewDBCount(String itemID, String boardID, int tenantID) throws Exception;
	
	void insertBrdItem(JSONObject boardListVO, MCommonVO info, String realPath, String mhtData) throws Exception;
	
	void insertBrdItem2(JSONObject boardListVO) throws Exception;
	
	void setAsRead(MCommonVO userInfo, String boardID, String itemID) throws Exception;
	
	void updateItem(JSONObject boardListVO, MCommonVO info, String realPath, String mhtData) throws Exception;
	
	void deleteItem(String itemID, String boardID, int tenantID) throws Exception;
	
	/* 2018-07-04 홍승비 - 모바일 게시판 즐겨찾기 추가 시 companyID 삽입 */
	void insertFavorite(String userID, String boardID, String companyID, int tenantID) throws Exception;
	
	void deleteFavorite(String userID, String boardID, int tenantID) throws Exception;
	
	//void getBoardTree_Set_D(String pStrLang, String query, int tenantID) throws Exception;
	
	void getBoardTree_Set(String pStrLang, String query, String result, int tenantID) throws Exception;
}
