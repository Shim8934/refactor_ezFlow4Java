package egovframework.ezMobile.ezBoard.service;

import java.util.List;

import egovframework.ezMobile.ezBoard.vo.MBoardInfoVO;
import egovframework.ezMobile.ezBoard.vo.MBoardListHeaderVO;
import egovframework.let.user.login.vo.LoginVO;

public interface MBoardService {
	List<MBoardListHeaderVO> getListHeader(MBoardInfoVO mBoardInfoVO, String lang, int tenantID) throws Exception;
	
	MBoardInfoVO getBoardInfo(String boardID, LoginVO userInfo) throws Exception;
	
	MBoardInfoVO getBoardProperty(String boardID, String primary, int tenantID) throws Exception;
}
