package egovframework.ezMobile.ezBoard.service;

import java.util.List;
import java.util.Map;

import org.json.simple.JSONObject;

import egovframework.ezMobile.ezBoard.vo.MBoardFavoriteVO;
import egovframework.ezMobile.ezBoard.vo.MBoardInfoVO;
import egovframework.ezMobile.ezBoard.vo.MBoardItemVO;
import egovframework.ezMobile.ezBoard.vo.MBoardListHeaderVO;
import egovframework.ezMobile.ezBoard.vo.MBoardTreeVO;
import egovframework.ezMobile.ezOption.vo.MCommonVO;

public interface MBoardService {
	List<MBoardListHeaderVO> getListHeader(MBoardInfoVO mBoardInfoVO, String lang, int tenantID) throws Exception;
	
	List<MBoardItemVO> getBoardItemList(MBoardInfoVO mBoardInfoVO, MCommonVO info, String userID) throws Exception;

	List<MBoardItemVO> getNewBoarditemList(MBoardInfoVO mBoardInfoVO, MCommonVO info, String userID) throws Exception;
	
	List<MBoardFavoriteVO> getFavoriteList(String userID, int tenantID) throws Exception;
	
	List<MBoardTreeVO> brdBoardTree(String rootBoardID, String accessID, int mode, int selectBy, String excludeBoardID, int tenantID) throws Exception;
	
	List<MBoardItemVO> getBoardMainList(String userID, String listCnt, int tenantID) throws Exception;
	
	List<MBoardItemVO> getNewBoardList(String userID, int tenantID) throws Exception;
	
	List<MBoardTreeVO> getBoardTree(String rootBoardID, int mode, int subFlag, int selectBy, String excludeBoardID, MCommonVO info) throws Exception;
	
	MBoardInfoVO getBoardInfo(MBoardInfoVO mBoardInfoVO, String rollInfo, String deptPathCode, MCommonVO info) throws Exception;
	
	MBoardInfoVO getBoardProperty(String boardID, String primary, int tenantID) throws Exception;
	
	MBoardItemVO getBrdItemInfo(String itemID, String lang, int tenantID) throws Exception;
	
	String checkIfBoardGroupAdmin(String rootBoardID, String userID, String deptID, String companyID, int tenantID) throws Exception;
	
	public Integer getNewBoardListCount(String userID, String startDate, int tenantID) throws Exception;
	
	public void insertBrdItem(JSONObject boardListVO, String offset, int tenantID) throws Exception;
	
	public void insertBrdItem2(JSONObject boardListVO) throws Exception;
	
	public void updateItem(JSONObject boardListVO) throws Exception;
	
	public void deleteItem(String itemID, String boardID, int tenantID) throws Exception;
}
