package egovframework.ezEKP.ezBoard.service.impl;

import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.w3c.dom.Document;

import com.ibm.icu.text.SimpleDateFormat;
import com.ibm.icu.util.Calendar;

import egovframework.ezEKP.ezBoard.dao.EzBoardAdminDAO;
import egovframework.ezEKP.ezBoard.service.EzBoardAdminService;
import egovframework.ezEKP.ezBoard.vo.BoardAttributeVO;
import egovframework.ezEKP.ezBoard.vo.BoardBackgroundVO;
import egovframework.ezEKP.ezBoard.vo.BoardListHeaderVO;
import egovframework.ezEKP.ezBoard.vo.BoardMyFavoriteVO;
import egovframework.ezEKP.ezBoard.vo.BoardPropertyVO;
import egovframework.ezEKP.ezBoard.vo.BoardTreeVO;
import egovframework.ezEKP.ezBoard.vo.BoardVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service("EzBoardAdminService")
public class EzBoardAdminServiceImpl extends EgovAbstractServiceImpl implements EzBoardAdminService {	
	
	@Resource(name="EzBoardAdminDAO")
	private EzBoardAdminDAO ezBoardAdminDAO;
	
	@Autowired
	private Properties config;
	
	@Autowired
	private CommonUtil commonUtil;

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
	public String addMyBoards(String userID, String boardID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_PUSERID", userID);
		map.put("v_PBOARDID", boardID);
		
		try {
			ezBoardAdminDAO.addMyBoards(map);			
			return "OK";
		} catch (Exception e) {
			return "NO";
		}
	}

	@Override
	public String setMyBoardTreeConfig(BoardMyFavoriteVO boardMyFavoriteVO) throws Exception {
		try {
			ezBoardAdminDAO.setMyBoardTreeConfig(boardMyFavoriteVO);			
			return "OK";
		} catch (Exception e) {
			return "ERROR"; 
		}
	}

	@Override
	public String setMyBoardTreeMoveCopy(BoardMyFavoriteVO boardMyFavoriteVO) throws Exception {
		try {
			ezBoardAdminDAO.setMyBoardTreeMoveCopy(boardMyFavoriteVO);			
			return "OK";
		} catch (Exception e) {
			return "ERROR"; 
		}
	}

	@Override
	public String saveMHT(String boardID, String formContent, String realPath) throws Exception {
		InputStream stream = null;
		OutputStream bos = null;
		String mhtFilePath = "";
		String dbPath = "";
		
		try{			
			String docPath = config.getProperty("upload_board.FORM") + commonUtil.separator;	
			String fullPath = realPath + docPath;
			File doc = new File(fullPath);		
		
			if(!doc.exists() || !doc.isDirectory()){
				doc.mkdir();
			}
			dbPath = docPath + boardID + ".mht";
			mhtFilePath = realPath + dbPath;
			File mht = new File(mhtFilePath);
			
			if(mht.exists()){
				mht.delete();
			}			
			stream = new ByteArrayInputStream(formContent.getBytes("UTF-8"));
			bos = new FileOutputStream(mhtFilePath);
			
			int bytesRead = 0;
			int buffer_size = 1024;
		    byte[] buffer = new byte[buffer_size];
		    
		    while ((bytesRead = stream.read(buffer, 0, buffer_size)) != -1) {
		    	bos.write(buffer, 0, bytesRead);
		    }
		}catch(Exception e){
			
		}finally{
			if(bos != null){
				bos.close();
			}
			if(stream != null){
				stream.close();
			}
		}
		
		return dbPath;
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
	public int checkForm(String boardID, String mode) throws Exception{
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_PBOARDID", boardID);
		map.put("v_PMODE", mode);
		
		return ezBoardAdminDAO.checkForm(map);
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
		return ezBoardAdminDAO.get_Admin_TopBoardList(parentBoardID);
		
	}
	
	@Override
	public List<BoardBackgroundVO> getBackGroundImage(BoardBackgroundVO boardBackgroundVO) throws Exception {
		return ezBoardAdminDAO.getBackGroundImage(boardBackgroundVO);
		
	}
	
	@Override
	public List<BoardAttributeVO> getBoardHeader(String gubun, String boardID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_PBOARDTYPE", gubun);
		map.put("v_PBOARDID", boardID);		

		return ezBoardAdminDAO.getBoardHeader(map);
	}	

	@Override
	public List<BoardPropertyVO> getBoardAccessList(String boardID)	throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();		
		map.put("v_PBOARDID", boardID);

		return ezBoardAdminDAO.getBoardAccessList(map);
	}	

	@Override
	public List<BoardPropertyVO> getUnderBoardID(String boardID, String type) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_PBOARDID", boardID);
		map.put("v_PTYPE", type);
		
		return ezBoardAdminDAO.getUnderBoardID(map);
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
		
		ezBoardAdminDAO.createBoard(map);
	}

	@Override
	public void saveBoardOrder(String pBoardIDList) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		int pBoardListCount = pBoardIDList.split(";").length - 1;
		
		map.put("v_pBoardIDList", pBoardIDList);
		map.put("v_pBoardListCount", pBoardListCount);
		
		ezBoardAdminDAO.saveBoardOrder(map);
		
		trunkBoard();
	}

	@Override
	public void deleteBoard(String boardID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();		
		map.put("v_pBoardID", boardID);
		
		ezBoardAdminDAO.deleteBoard(map);
		
		trunkBoard();
	}

	@Override
	public void statusChangeBackGroundImage(BoardBackgroundVO boardBackgroundVO) throws Exception {
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
		
		ezBoardAdminDAO.saveBackGroundImage(map);
	}
	
	@Override
	public void deleteBackGroundImage(BoardBackgroundVO boardBackgroundVO) throws Exception {
		ezBoardAdminDAO.deleteBackGroundImage(boardBackgroundVO);
	}

	@Override
	public void moveBoard(String orgBoardID, String newParentBoardID, String newBoardGroupID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_pOrgBoardID", orgBoardID);
        map.put("v_pNewParentBoardID", newParentBoardID);
        map.put("v_pNewBoardGroupID", newBoardGroupID);
        
		ezBoardAdminDAO.moveBoard(map);
		
		trunkBoard();
	}

	@Override
	public void saveBoardProperty(BoardPropertyVO boardPropertyVO) throws Exception {
		String boardID = boardPropertyVO.getBoardID();
		Map<String, Object> map = new HashMap<String, Object>();
		
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
		
		if (boardPropertyVO.getPortlet() != null) {
			if (boardPropertyVO.getPortlet().equals("Y")) {
				saveBoardProperty_port(boardID);
			}
		}
		
		if (boardPropertyVO.getApprFlag() != null) {			
			
			if (boardPropertyVO.getApprFlag().equals("Y")) {
				String[] flag = boardPropertyVO.getApprUserList().split(";");				
				
				for (int i=0; i < flag.length; i++) {
					String apprUserID = flag[i];
					String pMode = "DEL";
					
					if (i != 0) {
						pMode = "";
					}					
					saveBoardProperty_appr(boardID, apprUserID, pMode);
				}
				
				if (boardPropertyVO.getOrgApprFlag() != null) {
					if (!boardPropertyVO.getApprFlag().equals(boardPropertyVO.getOrgApprFlag())) {
						apprProperty_info(boardID, "Y");
					}
				}
			} else {
				String pMode = "DEL";				
				saveBoardProperty_appr(boardID, "", pMode);
				
				if (boardPropertyVO.getOrgApprFlag() != null) {
					if (!boardPropertyVO.getApprFlag().equals(boardPropertyVO.getOrgApprFlag())) {
						apprProperty_info(boardID, "N");
					}
				}
			}
		}		
		// board_treechache 테이블 trunk
		trunkBoard();
	}

	@Override
	public List<BoardAttributeVO> getBoardAttribute(String boardID) throws Exception {
		return ezBoardAdminDAO.getBoardAttribute(boardID);
	}
	
	@Override
	public void deleteAttribute(String boardID) throws Exception {
		ezBoardAdminDAO.deleteAttribute(boardID);
	}
	
	@Override
	public void saveAttribute(BoardAttributeVO boardAttributeVO) throws Exception {		
		ezBoardAdminDAO.saveAttribute(boardAttributeVO);
	}
	
	@Override
	public void updateAttribute(BoardAttributeVO boardAttributeVO) throws Exception {		
		ezBoardAdminDAO.updateAttribute(boardAttributeVO);
	}

	@Override
	public void deleteHeader(String boardID) throws Exception {
		ezBoardAdminDAO.deleteHeader(boardID);
	}

	@Override
	public void saveHeader(BoardListHeaderVO boardListHeaderVO)	throws Exception {
		ezBoardAdminDAO.saveHeader(boardListHeaderVO);
	}

	@Override
	public void saveACL(Map<String, Object> map) throws Exception {
		ezBoardAdminDAO.saveACL(map);
		
		trunkBoard();
	}

	@Override
	public void deleteACL(Document doc) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		for (int i = 0; i < doc.getElementsByTagName("ROW").getLength(); i++) {
			map.put("v_pBoardID", doc.getElementsByTagName("BOARDID").item(i).getTextContent());
			map.put("v_pAccessID", doc.getElementsByTagName("TARGETID").item(i).getTextContent());
			
			ezBoardAdminDAO.deleteACL(map);
		}
		
		trunkBoard();
	}

	public void trunkBoard() throws Exception {
		ezBoardAdminDAO.trunkBoard();
	}	

	@Override
	public void setUnderBoardIDAcl(BoardPropertyVO vo) throws Exception {	
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_PBOARDID", vo.getBoardID());
		map.put("v_PACCESSID", vo.getAccessID());
		map.put("v_PACCESSNAME", vo.getAccessName());
		map.put("v_PACCESSNAME2", vo.getAccessName2());
		
		if(vo.getAccessLevel() != null && !vo.getAccessLevel().trim().equals("")){
			map.put("v_PACCESSLEVEL", Integer.parseInt(vo.getAccessLevel()));
		}else{
			map.put("v_PACCESSLEVEL", -1);
		}		
		map.put("v_PACCESS", vo.getAccess_());
		map.put("v_PPARENTBOARDID", vo.getParentBoardID());
		map.put("v_PBOARDADMIN_FG", vo.getBoardAdmin_FG());
		map.put("v_PLISTVIEW_FG", vo.getListView_FG());
		map.put("v_PREAD_FG", vo.getRead_FG());
		map.put("v_PWRITE_FG", vo.getWrite_FG());
		map.put("v_PREPLY_FG", vo.getReply_FG());
		map.put("v_PDELETE_FG", vo.getDelete_FG());
		map.put("v_PINHERIT_FG", vo.getInherit_FG());
		map.put("v_PPOSTNOTICE", vo.getPostNotice());
		map.put("v_PBOARDGROUPACL", vo.getBoardGroupACL());
		
		ezBoardAdminDAO.setUnderBoardIDAcl(map);
	}

	@Override
	public void setUnderBoardIDAcl2(String defaultBoardID, String boardID, String parentBoardID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_PDEFAULTBOARDID", defaultBoardID);
		map.put("v_PBOARDID", boardID);
		map.put("v_PPARENTBOARDID", parentBoardID);
		
		ezBoardAdminDAO.setUnderBoardIDAcl2(map);
	}

	@Override
	public void copyBoardAcl(String boardID, String defaultBoardID,	String parentBoardID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_PBOARDID", boardID);
		map.put("v_PDEFAULTBOARDID", defaultBoardID);
		map.put("v_PPARENTBOARDID", parentBoardID);
		
		ezBoardAdminDAO.copyBoardAcl(map);		
	}

	@Override
	public void saveBoardProperty_appr(String boardID, String apprUserID, String pMode) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_pBoardID", boardID);
		map.put("v_pAPPRUSERID", apprUserID);
		map.put("v_pMODE", pMode);
		
		ezBoardAdminDAO.saveBoardProperty_appr(map);
		
	}

	@Override
	public void apprProperty_info(String boardID, String mode) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_PBOARDID", boardID);
		map.put("v_PMODE", mode);
		
		ezBoardAdminDAO.apprProperty_info(map);
	}

	@Override
	public void saveBoardProperty_port(String boardID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();		
		map.put("v_pBoardID", boardID);		
		
		ezBoardAdminDAO.saveBoardProperty_port(map);
	}

	@Override
	public void setBoardForm(String boardID, String formLocation) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_PBOARDID", boardID);
		map.put("v_PFORMLOCATION", formLocation);
		
		ezBoardAdminDAO.setBoardForm(map);
	}
	
	
}
