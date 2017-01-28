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

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.interceptor.TransactionAspectSupport;
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
import egovframework.let.user.login.vo.LoginVO;
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
	
	private static final Logger logger = LoggerFactory.getLogger(EzBoardAdminServiceImpl.class);

	@Override
	public String checkIfBoardGroupAdmin(String pRootBoardID, String pUserID, String pDeptID, String pCompanyID, int tenantID) throws Exception{
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_pBoardID", pRootBoardID);
		map.put("v_pUserID", pUserID);
		map.put("v_pDeptID", pDeptID);
		map.put("v_pCompanyID", pCompanyID);
		map.put("v_TENANTID", tenantID);
		
		return ezBoardAdminDAO.checkIfBoardGroupAdmin(map);
	}

	@Override
	public String addMyBoards(String userID, String boardID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PUSERID", userID);
		map.put("v_PBOARDID", boardID);
		map.put("v_TENANTID", tenantID);
		map.put("v_PQUERY", userID);
		
		try {
			ezBoardAdminDAO.addMyBoards(map);
			ezBoardAdminDAO.getBoardTree_Set_D(map);
			
			return "OK";
		} catch (Exception e) {
			return "NO";
		}
	}

	@Override
	public String setMyBoardTreeConfig(BoardMyFavoriteVO boardMyFavoriteVO) throws Exception {
		try {
			if (boardMyFavoriteVO.getMode().equals("NEW")) {
				ezBoardAdminDAO.setMyBoardTreeConfig_N(boardMyFavoriteVO);	
			} else if (boardMyFavoriteVO.getMode().equals("MOD")) {
				ezBoardAdminDAO.setMyBoardTreeConfig_M(boardMyFavoriteVO);	
			} else if (boardMyFavoriteVO.getMode().equals("DEL")) {
				ezBoardAdminDAO.setMyBoardTreeConfig_D(boardMyFavoriteVO);	
			}
			
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
	public String saveMHT(String boardID, String formContent, String realPath, int tenantID) throws Exception {
		InputStream stream = null;
		OutputStream bos = null;
		String mhtFilePath = "";
		String dbPath = "";
		
		try{			
			String docPath = commonUtil.getUploadPath("upload_board.FORM", tenantID) + commonUtil.separator;	
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
	public List<BoardVO> checkApplyUser(int tenantID) throws Exception{
		return ezBoardAdminDAO.checkApplyUser(tenantID);
	}

	@Override
	public String getBoardTree_Get1(String pStrLang, String pQuery, int tenantID) throws Exception{
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_STRLANG", pStrLang);
		map.put("v_PQUERY", pQuery);
		map.put("v_TENANTID", tenantID);
		
		return ezBoardAdminDAO.getBoardTree_Get1(map);
	}

	@Override
	public List<BoardVO> getBoardTree_Get2(String pAccessID, String pRootBoardID, int tenantID) throws Exception{
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_PACCESSID", pAccessID);
		map.put("v_PROOTBOARDID", pRootBoardID);
		map.put("v_TENANTID", tenantID);
		
		return ezBoardAdminDAO.getBoardTree_Get2(map);
	}

	@Override
	public List<BoardTreeVO> brdBoardTree(String pRootBoardID, String pAccessID, int pMode, int pSelectBy, String pExcludeBoardID, int tenantID) throws Exception{
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_pRootBoardID", pRootBoardID);
		map.put("v_pUserID", pAccessID);
		map.put("v_pDeptID", "");
		map.put("v_pCompanyID","");
		map.put("v_pMode", pMode);
		map.put("v_pSelectBy", pSelectBy);
		map.put("v_pExcludeBoardID", pExcludeBoardID);
		map.put("v_TENANTID", tenantID);
		
		return ezBoardAdminDAO.brdBoardTree(map);
	}

	@Override
	public void getBoardTree_Set(String pStrLang, String query, String result, int tenantID) throws Exception{
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_STRLANG", pStrLang);
		map.put("v_PQUERY", query);
		map.put("v_RESULT", result);
		map.put("v_TENANTID", tenantID);
		
		ezBoardAdminDAO.getBoardTree_Set(map);		
	}
	
	@Override
	public void getBoardTree_Set_D(String pStrLang, String query, int tenantID) throws Exception{
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_STRLANG", pStrLang);
		map.put("v_PQUERY", query);
		map.put("v_TENANTID", tenantID);
		
		ezBoardAdminDAO.getBoardTree_Set_D(map);
	}

	@Override
	public int checkIfLeafBoard(String pBoardID, int tenantID) throws Exception{
		Map<String, Object> map = new HashMap<String, Object>();		
		map.put("v_PBOARDID", pBoardID);
		map.put("v_TENANTID", tenantID);
		
		return ezBoardAdminDAO.checkIfLeafBoard(map);
	}

	@Override
	public int checkForm(String boardID, String mode, int tenantID) throws Exception{
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_PBOARDID", boardID);
		map.put("v_PMODE", mode);
		map.put("v_TENANTID", tenantID);
		
		return ezBoardAdminDAO.checkForm(map);
	}

	@Override
	public List<BoardMyFavoriteVO> getMyBoardTree_get3(String userID, String pRootTreeID, int tenantID) throws Exception{
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PUSERID", userID);
		map.put("v_PTREEUPPER", pRootTreeID);
		map.put("v_TENANTID", tenantID);
		
		return ezBoardAdminDAO.getMyBoardTree_get3(map);
	}

	@Override
	public List<BoardTreeVO> get_Admin_TopBoardList(String parentBoardID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("parentBoardID", parentBoardID);
		map.put("tenantID", tenantID);
		
		return ezBoardAdminDAO.get_Admin_TopBoardList(map);
		
	}
	
	@Override
	public List<BoardBackgroundVO> getBackGroundImage(BoardBackgroundVO boardBackgroundVO) throws Exception {
		return ezBoardAdminDAO.getBackGroundImage(boardBackgroundVO);
		
	}
	
	@Override
	public List<BoardAttributeVO> getBoardHeader(String gubun, String boardID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PBOARDTYPE", gubun);
		map.put("v_PBOARDID", boardID);
		map.put("v_TENANTID", tenantID);
		
		String tempString = ezBoardAdminDAO.getBoardItemListOptionBoard(map);
		
		if (tempString != null && !tempString.equals("")) {
			return ezBoardAdminDAO.getBoardHeader_B(map);
		} else {
			return ezBoardAdminDAO.getBoardHeader(map);
		}
	}	

	@Override
	public List<BoardPropertyVO> getBoardAccessList(String boardID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();		
		map.put("v_PBOARDID", boardID);
		map.put("v_TENANTID", tenantID);

		return ezBoardAdminDAO.getBoardAccessList(map);
	}	

	@Override
	public List<BoardPropertyVO> getUnderBoardID(String boardID, String type, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_PBOARDID", boardID);
		map.put("v_PTYPE", type);
		map.put("v_TENANTID", tenantID);
		
		return ezBoardAdminDAO.getUnderBoardID(map);
	}

	@Override
	public BoardPropertyVO getACL(String pBoardID, String userDeptPath, int tenantID) throws Exception{
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("pBoardID", pBoardID);
		map.put("userDeptPath", userDeptPath);
		map.put("tenantID", tenantID);
		
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
		map.put("v_TENANTID", boardPropertyVO.getTenantID());
		
		ezBoardAdminDAO.createBoardGroup(map);
		ezBoardAdminDAO.createBoardGroup2(map);
		
		trunkBoard(boardPropertyVO.getTenantID());
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
		map.put("v_TENANTID", boardPropertyVO.getTenantID());	
		
		ezBoardAdminDAO.createBoard_I(map);
		ezBoardAdminDAO.createBoard_I2(map);
		
		String boardTreePath = getBoardTreePath(boardPropertyVO.getBoardID(), boardPropertyVO.getTenantID());
		map.put("boardTreePath", boardTreePath);
		
		ezBoardAdminDAO.createBoard_U(map);
		
		trunkBoard(boardPropertyVO.getTenantID());
	}

	public String getBoardTreePath(String boardID, int tenantID) throws Exception{
		String tempString = "";
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("boardID", boardID);
		map.put("tenantID", tenantID);
		
		String parentBoardID = ezBoardAdminDAO.getParentBoardID(map);
		
		if (parentBoardID != null && !parentBoardID.equals("None")) {
			while (!parentBoardID.equals("top")) {
				map.put("parentBoardID", parentBoardID);
				
				String tempBoardID = ezBoardAdminDAO.getBoardID(map);
				tempString += tempBoardID;
				
				map.put("boardID", tempBoardID);
				
				parentBoardID = ezBoardAdminDAO.getParentBoardID(map);
				
				if (!parentBoardID.equals("top")) {
					tempString += ",";
				}
			}
		}
		
		return tempString;
	}

	@Override
	public void saveBoardOrder(String pBoardIDList, int tenantID) throws Exception {
		String[] tempBoardID = pBoardIDList.split(";");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_tenantID", tenantID);

		for (int k = 0; k < tempBoardID.length; k++) {
			map.put("v_boardID", tempBoardID[k]);
			map.put("v_count", k + 1);
			
			ezBoardAdminDAO.saveBoardOrder(map);
		}
		
		trunkBoard(tenantID);
	}

	@Override
	public void deleteBoard(String boardID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pBoardID", boardID);
		map.put("v_TENANTID", tenantID);
		
		ezBoardAdminDAO.deleteBoardManage(map);
		ezBoardAdminDAO.deleteBoardInfo(map);
		ezBoardAdminDAO.deleteBoardMyBoard(map);
		ezBoardAdminDAO.insertDeleteReservedBoard(map);
		
		trunkBoard(tenantID);
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
		
		if (fName == null) {
			map.put("v_ORGFILENAME","");
			map.put("v_SAVEFILENAME","");
		} else {
			map.put("v_ORGFILENAME",boardBackgroundVO.getOrgFileName());
			map.put("v_SAVEFILENAME",boardBackgroundVO.getSaveFileName());
		}
		map.put("v_BACKGROUNDID",boardBackgroundVO.getBackgroundID());
        map.put("v_REGUSERID",boardBackgroundVO.getRegUserID());
        map.put("v_REGDATE",now);
        map.put("v_WIDTH",boardBackgroundVO.getWidth());
        map.put("v_HEIGHT",boardBackgroundVO.getHeight());
        map.put("v_MODE",boardBackgroundVO.getType());
        map.put("v_TENANTID",boardBackgroundVO.getTenantID());
		
        if (boardBackgroundVO.getType().equals("NEW")) {
        	ezBoardAdminDAO.saveBackGroundImage_I(map);
        } else {
        	ezBoardAdminDAO.saveBackGroundImage_U(map);
        }
	}
	
	@Override
	public void deleteBackGroundImage(BoardBackgroundVO boardBackgroundVO) throws Exception {
		ezBoardAdminDAO.deleteBackGroundImage(boardBackgroundVO);
	}

	@Override
	public void moveBoard(String orgBoardID, String newParentBoardID, String newBoardGroupID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_pOrgBoardID", orgBoardID);
        map.put("v_pNewParentBoardID", newParentBoardID);
        map.put("v_pNewBoardGroupID", newBoardGroupID);
        map.put("v_TENANTID", tenantID);
        
		ezBoardAdminDAO.moveBoard(map);
		ezBoardAdminDAO.moveBoard2(map);
		
		trunkBoard(tenantID);
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
		map.put("v_TENANTID", boardPropertyVO.getTenantID());
		
		ezBoardAdminDAO.saveBoardProperty(map);
		ezBoardAdminDAO.saveBoardProperty2(map);
		
		if (boardPropertyVO.getPortlet() != null) {
			if (boardPropertyVO.getPortlet().equals("Y")) {
				trunkBoard(boardPropertyVO.getTenantID());
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
					saveBoardProperty_appr(boardID, apprUserID, pMode, boardPropertyVO.getTenantID());
				}
				
				if (boardPropertyVO.getOrgApprFlag() != null) {
					if (!boardPropertyVO.getApprFlag().equals(boardPropertyVO.getOrgApprFlag())) {
						apprProperty_info(boardID, "Y", boardPropertyVO.getTenantID());
					}
				}
			} else {
				String pMode = "DEL";				
				saveBoardProperty_appr(boardID, "", pMode, boardPropertyVO.getTenantID());
				
				if (boardPropertyVO.getOrgApprFlag() != null) {
					if (!boardPropertyVO.getApprFlag().equals(boardPropertyVO.getOrgApprFlag())) {
						apprProperty_info(boardID, "N", boardPropertyVO.getTenantID());
					}
				}
			}
		}		
		// board_treechache 테이블 trunk
		trunkBoard(boardPropertyVO.getTenantID());
	}

	@Override
	public List<BoardAttributeVO> getBoardAttribute(String boardID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();		
		map.put("v_BOARDID", boardID);
		map.put("v_TENANTID", tenantID);
		
		return ezBoardAdminDAO.getBoardAttribute(map);
	}
	
	@Override
	public void deleteAttribute(String boardID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();		
		map.put("v_BOARDID", boardID);
		map.put("v_TENANTID", tenantID);
		
		ezBoardAdminDAO.deleteAttribute(map);
	}
	
	@Override
	public String saveAttribute(Document doc, LoginVO userInfo, BoardAttributeVO boardAttributeVO) throws Exception {
		String rtnValue = "";
		
		try {
			String boardID = doc.getElementsByTagName("BOARDID").item(0).getTextContent();
			deleteAttribute(boardID, userInfo.getTenantId());
			
			int colSize = doc.getElementsByTagName("COLNAME1").getLength();
			String attributeYN = "N";
			boardAttributeVO.setBoardID(boardID);
			boardAttributeVO.setTenantID(userInfo.getTenantId());
			
			for (int i = 0; i < colSize; i++) {
				boardAttributeVO.setTableCol(doc.getElementsByTagName("TABLECOL").item(i).getTextContent());
				boardAttributeVO.setSn(i + "");
				boardAttributeVO.setColName1(doc.getElementsByTagName("COLNAME1").item(i).getTextContent());
				boardAttributeVO.setColName2(doc.getElementsByTagName("COLNAME2").item(i).getTextContent());
				boardAttributeVO.setValue(doc.getElementsByTagName("VALUE").item(i).getTextContent());
				boardAttributeVO.setColType(doc.getElementsByTagName("COLTYPE").item(i).getTextContent());
				boardAttributeVO.setMust(doc.getElementsByTagName("MUST").item(i).getTextContent());
				
				ezBoardAdminDAO.saveAttribute(boardAttributeVO);
			}
			
			if (colSize > 0) {
				attributeYN = "Y";
			}
			
			boardAttributeVO.setValue(attributeYN);
			
			updateAttribute(boardAttributeVO);
			
			rtnValue = "OK";
		} catch (Exception e) {
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
			rtnValue = "ERROR";
			logger.error("EzBoardAdmin :: saveAttribute");
		}
		
		return rtnValue;
	}
	
	@Override
	public void updateAttribute(BoardAttributeVO boardAttributeVO) throws Exception {		
		ezBoardAdminDAO.updateAttribute(boardAttributeVO);
	}

	@Override
	public void deleteHeader(String boardID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();		
		map.put("v_BOARDID", boardID);
		map.put("v_TENANTID", tenantID);
		
		ezBoardAdminDAO.deleteHeader(map);
	}

	@Override
	public String saveHeader(Document doc, LoginVO userInfo, BoardListHeaderVO boardListHeaderVO) throws Exception {
		String rtnValue = "";
		
		try {
			String boardID = doc.getElementsByTagName("BOARDID").item(0).getTextContent();
			deleteHeader(boardID, userInfo.getTenantId());
			
			int colSize = doc.getElementsByTagName("NAME1").getLength();
			boardListHeaderVO.setBoardID(boardID);
			boardListHeaderVO.setTenantID(userInfo.getTenantId());
			
			for (int i = 0; i < colSize; i++) {
				boardListHeaderVO.setSn(i + "");
				boardListHeaderVO.setName1(doc.getElementsByTagName("NAME1").item(i).getTextContent());
				boardListHeaderVO.setName2(doc.getElementsByTagName("NAME2").item(i).getTextContent());
				boardListHeaderVO.setName3(doc.getElementsByTagName("NAME1").item(i).getTextContent());
				boardListHeaderVO.setName4(doc.getElementsByTagName("NAME2").item(i).getTextContent());
				boardListHeaderVO.setColName(doc.getElementsByTagName("COLNAME").item(i).getTextContent());
				boardListHeaderVO.setWidth(doc.getElementsByTagName("WIDTH").item(i).getTextContent());
				boardListHeaderVO.setName("Y");
				
				ezBoardAdminDAO.saveHeader(boardListHeaderVO);
			}
			
			rtnValue = "OK";
		} catch (Exception e) {
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
			rtnValue = "ERROR";
			logger.error("EzBoardAdmin :: saveHeader :: " + e.getMessage());
		}
		
		return rtnValue;
	}

	@Override
	public void saveACL(Map<String, Object> map) throws Exception {
		int tempCount = ezBoardAdminDAO.getBoardManage(map);
		
		if (tempCount > 0) {
			ezBoardAdminDAO.saveACL_U(map);
		} else {
			ezBoardAdminDAO.saveACL_I(map);
		}
		
		trunkBoard((int) map.get("v_TENANTID"));
	}

	@Override
	public void deleteACL(Document doc, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_TENANTID", tenantID);
		
		for (int i = 0; i < doc.getElementsByTagName("ROW").getLength(); i++) {
			map.put("v_pBoardID", doc.getElementsByTagName("BOARDID").item(i).getTextContent());
			map.put("v_pAccessID", doc.getElementsByTagName("TARGETID").item(i).getTextContent());
			
			ezBoardAdminDAO.deleteACL(map);
		}
		
		trunkBoard(tenantID);
	}

	public void trunkBoard(int tenantID) throws Exception {
		ezBoardAdminDAO.trunkBoard(tenantID);
	}	

	@Override
	public void setUnderBoardIDAcl(BoardPropertyVO vo) throws Exception {	
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_pBoardID", vo.getBoardID());
		map.put("v_pAccessID", vo.getAccessID());
		map.put("v_PACCESSNAME", vo.getAccessName());
		map.put("v_PACCESSNAME2", vo.getAccessName2());
		
		if (vo.getAccessLevel() != null && !vo.getAccessLevel().trim().equals("")) {
			map.put("v_PACCESSLEVEL", Integer.parseInt(vo.getAccessLevel()));
		} else {
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
		map.put("v_TENANTID", vo.getTenantID());
		
		int tempCount = ezBoardAdminDAO.getBoardManage(map);
		
		if (tempCount > 0) {
			ezBoardAdminDAO.setUnderBoardIDAcl_U(map);
		} else {
			ezBoardAdminDAO.setUnderBoardIDAcl_I(map);
		}
	}

	@Override
	public void setUnderBoardIDAcl2(String defaultBoardID, String boardID, String parentBoardID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_PDEFAULTBOARDID", defaultBoardID);
		map.put("v_pBoardID", boardID);
		map.put("v_PPARENTBOARDID", parentBoardID);
		map.put("v_TENANTID", tenantID);
		
		ezBoardAdminDAO.deleteBoardManage(map);
		ezBoardAdminDAO.setUnderBoardIDAcl2(map);
	}

	@Override
	public void copyBoardAcl(String boardID, String defaultBoardID,	String parentBoardID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_pBoardID", boardID);
		map.put("v_PDEFAULTBOARDID", defaultBoardID);
		map.put("v_PPARENTBOARDID", parentBoardID);
		map.put("v_TENANTID", tenantID);
		
		ezBoardAdminDAO.deleteBoardManage(map);
		ezBoardAdminDAO.copyBoardAcl(map);
	}

	@Override
	public void saveBoardProperty_appr(String boardID, String apprUserID, String pMode, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_pBoardID", boardID);
		map.put("v_pAPPRUSERID", apprUserID);
		map.put("v_pMODE", pMode);
		map.put("v_TENANTID", tenantID);
		
		if (pMode.equals("DEL")) {
			ezBoardAdminDAO.saveBoardProperty_appr_D(map);
		}
		
		if (apprUserID != null && !apprUserID.equals("")) {
			ezBoardAdminDAO.saveBoardProperty_appr_I(map);
		}
		
	}

	@Override
	public void apprProperty_info(String boardID, String mode, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_PBOARDID", boardID);
		map.put("v_PMODE", mode);
		map.put("v_TENANTID", tenantID);
		
		ezBoardAdminDAO.apprProperty_info(map);
	}

	@Override
	public void setBoardForm(String boardID, String formLocation, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_PBOARDID", boardID);
		map.put("v_PFORMLOCATION", formLocation);
		map.put("v_TENANTID", tenantID);
		
		ezBoardAdminDAO.setBoardForm(map);
	}
	
	
}
