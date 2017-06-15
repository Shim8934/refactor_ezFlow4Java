package egovframework.ezMobile.ezBoard.service;

import java.util.List;

import egovframework.ezMobile.ezBoard.vo.MBoardInfoVO;
import egovframework.ezMobile.ezBoard.vo.MBoardItemVO;
import egovframework.ezMobile.ezBoard.vo.MBoardListHeaderVO;
import egovframework.let.user.login.vo.LoginVO;

public interface MBoardService {
	List<MBoardListHeaderVO> getListHeader(MBoardInfoVO mBoardInfoVO, String lang, int tenantID) throws Exception;
	
	List<MBoardItemVO> getBoardItemList(MBoardInfoVO mBoardInfoVO, LoginVO userInfo) throws Exception;

	List<MBoardItemVO> getNewBoarditemList(MBoardInfoVO mBoardInfoVO, LoginVO userInfo) throws Exception;
	
	MBoardInfoVO getBoardInfo(MBoardInfoVO mBoardInfoVO, LoginVO userInfo) throws Exception;
	
	MBoardInfoVO getBoardProperty(String boardID, String primary, int tenantID) throws Exception;
}
