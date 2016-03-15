package egovframework.ezEKP.ezBoard.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.ibm.icu.text.SimpleDateFormat;
import com.ibm.icu.util.Calendar;

import egovframework.ezEKP.ezBoard.dao.EzBoardAdminDAO;
import egovframework.ezEKP.ezBoard.service.EzBoardAdminService;
import egovframework.ezEKP.ezBoard.vo.BoardAttributeVO;
import egovframework.ezEKP.ezBoard.vo.BoardBackgroundVO;
import egovframework.ezEKP.ezBoard.vo.BoardPropertyVO;
import egovframework.ezEKP.ezBoard.vo.BoardTreeVO;
import egovframework.ezEKP.ezBoard.vo.BoardVO;
import egovframework.ezEKP.ezBoard.vo.BoardMyFavoriteVO;

@Service("EzBoardAdminService")
public class EzBoardAdminServiceImpl implements EzBoardAdminService {	
	
	@Resource(name="EzBoardAdminDAO")
	private EzBoardAdminDAO ezBoardAdminDAO;

	@Override
	public String checkIfBoardGroupAdmin(String pRootBoardID, String pUserID, String pDeptID, String pCompanyID) throws Exception{
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_pBoardID", pRootBoardID);
		map.put("v_pUserID", pUserID);
		map.put("v_pDeptID", pDeptID);
		map.put("v_pCompanyID", pCompanyID);
		
		return ezBoardAdminDAO.checkIfBoardGroupAdmin(map);
	}

	@Override
	public List<BoardVO> checkApplyUser() throws Exception{
		return ezBoardAdminDAO.checkApplyUser();
	}

	@Override
	public String getBoardTree_Get1(String pStrLang, String pQuery) throws Exception{
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_STRLANG", pStrLang);
		map.put("v_PQUERY", pQuery);
		
		return ezBoardAdminDAO.getBoardTree_Get1(map);
	}

	@Override
	public List<BoardVO> getBoardTree_Get2(String pAccessID, String pRootBoardID) throws Exception{
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_PACCESSID", pAccessID);
		map.put("v_PROOTBOARDID", pRootBoardID);
		
		return ezBoardAdminDAO.getBoardTree_Get2(map);
	}

	@Override
	public List<BoardTreeVO> brdBoardTree(String pRootBoardID, String pAccessID, int pMode, int pSelectBy, String pExcludeBoardID) throws Exception{
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_pRootBoardID", pRootBoardID);
		map.put("v_pUserID", pAccessID);
		map.put("v_pDeptID", "");
		map.put("v_pCompanyID","");
		map.put("v_pMode", pMode);
		map.put("v_pSelectBy", pSelectBy);
		map.put("v_pExcludeBoardID", pExcludeBoardID);
		
		return ezBoardAdminDAO.brdBoardTree(map);
	}

	@Override
	public void getBoardTree_Set(String pStrLang, String string, String string2) throws Exception{
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_STRLANG", pStrLang);
		map.put("v_PQUERY", string);
		map.put("v_RESULT", string2);
		
		ezBoardAdminDAO.getBoardTree_Set(map);		
	}

	@Override
	public int checkIfLeafBoard(String pBoardID) throws Exception{
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_PBOARDID", pBoardID);
		
		return ezBoardAdminDAO.checkIfLeafBoard(map);
	}

	@Override
	public List<BoardMyFavoriteVO> getMyBoardTree_get3(String userID, String pRootTreeID) throws Exception{
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_PUSERID", userID);
		map.put("v_PTREEUPPER", pRootTreeID);
		
		return ezBoardAdminDAO.getMyBoardTree_get3(map);
	}

	@Override
	public List<BoardTreeVO> get_Admin_TopBoardList(String parentBoardID) throws Exception {
		// TODO Auto-generated method stub
		return ezBoardAdminDAO.get_Admin_TopBoardList(parentBoardID);
		
	}
	
	@Override
	public List<BoardBackgroundVO> getBackGroundImage(BoardBackgroundVO boardBackgroundVO) throws Exception {
		// TODO Auto-generated method stub
		return ezBoardAdminDAO.getBackGroundImage(boardBackgroundVO);
		
	}
	
	@Override
	public List<BoardBackgroundVO> getBoardHeader(String boardID, String gubun) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_PBOARDID", boardID);
		map.put("v_PBOARDTYPE", gubun);
		
		return ezBoardAdminDAO.getBoardHeader(map);		
	}

	@Override
	public BoardPropertyVO getACL(String pBoardID, String userDeptPath) throws Exception{
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("pBoardID", pBoardID);
		map.put("userDeptPath", userDeptPath);
		
		return ezBoardAdminDAO.getACL(map);
	}

	@Override
	public void createBoardGroup(BoardPropertyVO boardPropertyVO) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_BOARDGROUPID", boardPropertyVO.getBoardGroupID());
		map.put("v_BOARDGROUPNAME", boardPropertyVO.getBoardGroupName());
		map.put("v_BOARDGROUPNAME2", boardPropertyVO.getBoardGroupName2());
		map.put("v_ACCESSID", boardPropertyVO.getAccessID());
		map.put("v_ACCESSNAME", boardPropertyVO.getAccessName());
		map.put("v_ACCESSNAME2", boardPropertyVO.getAccessName2());
		map.put("v_PARENTBOARDID", "top");
		// TODO Auto-generated method stub
		ezBoardAdminDAO.createBoardGroup(map);
	}

	@Override
	public void createBoard(BoardPropertyVO boardPropertyVO) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_BOARDID", boardPropertyVO.getBoardID());
		map.put("v_BOARDNAME", boardPropertyVO.getBoardName());
		map.put("v_BOARDNAME2", boardPropertyVO.getBoardName2());
		map.put("v_PARENTBOARDID", boardPropertyVO.getParentBoardID());
		map.put("v_BOARDGROUPID", boardPropertyVO.getBoardGroupID());
		map.put("v_ACCESSID", boardPropertyVO.getAccessID());
		map.put("v_ACCESSNAME", boardPropertyVO.getAccessName());
		map.put("v_ACCESSNAME2", boardPropertyVO.getAccessName2());	
		// TODO Auto-generated method stub
		ezBoardAdminDAO.createBoard(map);
	}

	@Override
	public void saveBoardOrder(String pBoardIDList) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		int pBoardListCount = pBoardIDList.split(";").length - 1;
		
		map.put("v_pBoardIDList", pBoardIDList);
		map.put("v_pBoardListCount", pBoardListCount);
		// TODO Auto-generated method stub
		ezBoardAdminDAO.saveBoardOrder(map);
	}

	@Override
	public void deleteBoard(String boardID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_pBoardID", boardID);
		// TODO Auto-generated method stub
		ezBoardAdminDAO.deleteBoard(map);
	}

	@Override
	public void statusChangeBackGroundImage(BoardBackgroundVO boardBackgroundVO) throws Exception {
		// TODO Auto-generated method stub
		ezBoardAdminDAO.statusChangeBackGroundImage(boardBackgroundVO);
	}

	@Override
	public void saveBackGroundImage(BoardBackgroundVO boardBackgroundVO) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		Calendar cal = Calendar.getInstance();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		String now = sdf.format(cal.getTime());
		String fName = boardBackgroundVO.getOrgFileName();
		
		if(fName == null){		
			map.put("v_ORGFILENAME"," ");
			map.put("v_SAVEFILENAME"," ");
		}else{
			map.put("v_ORGFILENAME",boardBackgroundVO.getOrgFileName());
			map.put("v_SAVEFILENAME",boardBackgroundVO.getSaveFileName());
		}
		map.put("v_BACKGROUNDID",boardBackgroundVO.getBackgroundID());
        map.put("v_REGUSERID",boardBackgroundVO.getRegUserID());
        map.put("v_REGDATE",now);
        map.put("v_WIDTH",boardBackgroundVO.getWidth());
        map.put("v_HEIGHT",boardBackgroundVO.getHeight());
        map.put("v_MODE",boardBackgroundVO.getType());
		
		// TODO Auto-generated method stub
		ezBoardAdminDAO.saveBackGroundImage(map);
	}
	
	@Override
	public void deleteBackGroundImage(BoardBackgroundVO boardBackgroundVO) throws Exception {
		// TODO Auto-generated method stub
		ezBoardAdminDAO.deleteBackGroundImage(boardBackgroundVO);
	}

	@Override
	public void moveBoard(String orgBoardID, String newParentBoardID, String newBoardGroupID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		// TODO Auto-generated method stub
		map.put("v_pOrgBoardID", orgBoardID);
        map.put("v_pNewParentBoardID", newParentBoardID);
        map.put("v_pNewBoardGroupID", newBoardGroupID);
        
		ezBoardAdminDAO.moveBoard(map);
	}

	@Override
	public void saveBoardProperty(BoardPropertyVO boardPropertyVO) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		// TODO Auto-generated method stub
		map.put("v_PBOARDID", boardPropertyVO.getBoardID());
		map.put("v_PATTACHMAX", boardPropertyVO.getAttachSizeLimit());
		map.put("v_PDESCRIPTION", boardPropertyVO.getBoardDescription());
		map.put("v_PEXPIRES", boardPropertyVO.getItemExpires());
		map.put("v_PURL", boardPropertyVO.getUrl());
		map.put("v_PREPLYNOTIFY", boardPropertyVO.getReplyNotify());
		map.put("v_PGUBUN", boardPropertyVO.getGuBun());
		map.put("v_PBOARDNAME", boardPropertyVO.getBoardName());
		map.put("v_PDELETEAFTER", boardPropertyVO.getDeleteAfter());
		map.put("v_PBOARDCOLOR", boardPropertyVO.getBoardColor());
		map.put("v_PBOARDNAME2", boardPropertyVO.getBoardName2());
		map.put("v_PPORTLET", boardPropertyVO.getPortlet());
		map.put("v_PONELINEREPLY", boardPropertyVO.getOneLineReply());
		map.put("v_PBACKGROUND", boardPropertyVO.getBackGround());
		map.put("v_PFORM", boardPropertyVO.getFormFlag());
		map.put("v_PAPPRFLAG", boardPropertyVO.getApprFlag());
		map.put("v_PAPPRMAILFLAG", boardPropertyVO.getApprMailFlag());
		
		ezBoardAdminDAO.saveBoardProperty(map);
	}

	@Override
	public List<BoardAttributeVO> getBoardAttribute(String boardID) throws Exception {
		return ezBoardAdminDAO.getBoardAttribute(boardID);
	}
	
	
}
