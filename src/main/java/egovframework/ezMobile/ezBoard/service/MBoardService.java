package egovframework.ezMobile.ezBoard.service;

import java.util.List;
import java.util.Locale;
import java.util.Map;

import org.json.simple.JSONObject;

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
	
	List<MBoardItemVO> getBoardItemList(MBoardInfoVO mBoardInfoVO, MCommonVO info, String userID) throws Exception;

	List<MBoardNewListVO> getNewBoarditemList(MBoardInfoVO mBoardInfoVO, MCommonVO info, String userID) throws Exception;
	
	List<MBoardFavoriteVO> getFavoriteList(String userID, int tenantID) throws Exception;
	
	List<MBoardTreeVO> brdBoardTree(String rootBoardID, String accessID, int mode, int selectBy, String excludeBoardID, int tenantID) throws Exception;
	
	List<MBoardNewListVO> getBoardMainList(String userID, String listCnt, int tenantID) throws Exception;
	
	List<MBoardNewListVO> getNewBoardList(String userID, int tenantID) throws Exception;
	
	List<MBoardTreeVO> getBoardTree(String rootBoardID, int mode, int subFlag, int selectBy, String excludeBoardID, MCommonVO info) throws Exception;
	
	List<MBoardAttachVO> getAttachList(String itemID, int tenantID) throws Exception;
	
	List<MBoardAttachVO> photoViewDB(String itemID, String boardID,int tenantID) throws Exception;
	
	MBoardInfoVO getBoardInfo(MBoardInfoVO mBoardInfoVO, String rollInfo, String deptPathCode, MCommonVO info) throws Exception;
	
	MBoardInfoVO getBoardProperty(String boardID, String primary, int tenantID) throws Exception;
	
	MBoardItemVO getBrdItemInfo(String itemID, String lang, int tenantID) throws Exception;
	
	String checkIfBoardGroupAdmin(String rootBoardID, String userID, String deptID, String companyID, int tenantID) throws Exception;
	
	String getDeptPathCode(String departmentID,int tenantID) throws Exception;
	
	String getMhtContent(String realPath, String domain, MCommonVO userInfo, String url,Locale locale) throws Exception;
	
	Integer getNewBoardListCount(String userID, String startDate, int tenantID) throws Exception;
	
	int getBoardItemListCount(String boardID, String userID, String guBun, int tenantID) throws Exception;
	
	Integer photoViewDBCount(String itemID, String boardID, int tenantID) throws Exception;
	
	void insertBrdItem(JSONObject boardListVO, String offset, int tenantID) throws Exception;
	
	void insertBrdItem2(JSONObject boardListVO) throws Exception;
	
	void updateItem(JSONObject boardListVO) throws Exception;
	
	void deleteItem(String itemID, String boardID, int tenantID) throws Exception;
	
	void insertFavorite(String userID, String boardID, int tenantID) throws Exception;
	
	void deleteFavorite(String userID, String boardID, int tenantID) throws Exception;
}
