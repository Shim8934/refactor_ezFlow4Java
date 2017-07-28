package egovframework.ezMobile.ezBoard.service;

import java.util.List;
import java.util.Map;

import egovframework.ezMobile.ezBoard.vo.MBoardFavoriteVO;
import egovframework.ezMobile.ezBoard.vo.MBoardInfoVO;
import egovframework.ezMobile.ezBoard.vo.MBoardItemVO;
import egovframework.ezMobile.ezBoard.vo.MBoardListHeaderVO;
import egovframework.ezMobile.ezOption.vo.MCommonVO;
import egovframework.let.user.login.vo.LoginVO;

public interface MBoardService {
	List<MBoardListHeaderVO> getListHeader(MBoardInfoVO mBoardInfoVO, String lang, int tenantID) throws Exception;
	
	List<MBoardItemVO> getBoardItemList(MBoardInfoVO mBoardInfoVO, MCommonVO info, String userID) throws Exception;

	List<MBoardItemVO> getNewBoarditemList(MBoardInfoVO mBoardInfoVO, MCommonVO info, String userID) throws Exception;
	
	List<MBoardFavoriteVO> getFavoriteList(String userID, int tenantID) throws Exception;
	
	MBoardInfoVO getBoardInfo(MBoardInfoVO mBoardInfoVO, String rollInfo, String deptPathCode, MCommonVO info) throws Exception;
	
	MBoardInfoVO getBoardProperty(String boardID, String primary, int tenantID) throws Exception;
	
	MBoardItemVO getBrdItemInfo(String itemID, String lang, int tenantID) throws Exception;
}
