package egovframework.ezEKP.ezBoard.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import egovframework.ezEKP.ezBoard.dao.EzBoardAdminDAO;
import egovframework.ezEKP.ezBoard.service.EzBoardAdminService;
import egovframework.ezEKP.ezBoard.vo.BoardTreeVO;
import egovframework.ezEKP.ezBoard.vo.EzBoardVO;

@Service("EzBoardAdminService")
public class EzBoardAdminServiceImpl implements EzBoardAdminService {
	
	@Resource(name="EzBoardAdminDAO")
	private EzBoardAdminDAO ezBoardAdminDAO;

	@Override
	public String checkIfBoardGroupAdmin(String pRootBoardID, String pUserID, String pDeptID, String pCompanyID) throws Exception{
		return ezBoardAdminDAO.checkIfBoardGroupAdmin(pRootBoardID,pUserID,pDeptID,pCompanyID);
	}

	@Override
	public List<EzBoardVO> checkApplyUser() throws Exception{
		return ezBoardAdminDAO.checkApplyUser();
	}

	@Override
	public String getBoardTree_Get1(String pStrLang, String pQuery) throws Exception{
		return ezBoardAdminDAO.getBoardTree_Get1(pStrLang,pQuery);
	}

	@Override
	public String getDeptFullPath(String pDeptID, String string) throws Exception{
		return ezBoardAdminDAO.getDeptFullPath(pDeptID, string);
	}

	@Override
	public List<EzBoardVO> getBoardTree_Get2(String pAccessID, String pRootBoardID) throws Exception{
		return ezBoardAdminDAO.getBoardTree_Get2(pAccessID, pRootBoardID);
	}

	@Override
	public List<BoardTreeVO> brdBoardTree(String pRootBoardID, String pAccessID, int pMode, int pSelectBy, String pExcludeBoardID) throws Exception{
		return ezBoardAdminDAO.brdBoardTree(pRootBoardID, pAccessID, pMode, pSelectBy, pExcludeBoardID);
	}

	@Override
	public void getBoardTree_Set(String pStrLang, String string, String string2) throws Exception{
		ezBoardAdminDAO.getBoardTree_Set(pStrLang, string, string2);		
	}

	@Override
	public int checkIfLeafBoard(String pBoardID) throws Exception{
		return ezBoardAdminDAO.checkIfLeafBoard(pBoardID);
	}

}
