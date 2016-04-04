package egovframework.ezEKP.ezBoard.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import egovframework.ezEKP.ezBoard.dao.EzBoardDAO;
import egovframework.ezEKP.ezBoard.service.EzBoardService;
import egovframework.ezEKP.ezBoard.vo.BoardAttachVO;
import egovframework.ezEKP.ezBoard.vo.BoardConfigVO;
import egovframework.ezEKP.ezBoard.vo.BoardListHeaderVO;
import egovframework.ezEKP.ezBoard.vo.BoardListVO;
import egovframework.ezEKP.ezBoard.vo.BoardMyFavoriteVO;
import egovframework.ezEKP.ezBoard.vo.BoardPropertyVO;
import egovframework.ezEKP.ezBoard.vo.BoardReadVO;
import egovframework.ezEKP.ezBoard.vo.BoardVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;

@Service("EzBoardService")
public class EzBoardServiceImpl implements EzBoardService {

	@Resource(name="EzBoardDAO")
	private EzBoardDAO ezBoardDAO;
	
	@Autowired
	private CommonUtil commonUtil;

	@Override
	public List<BoardVO> getLeft_BoardSTD(String redirectBoardID) throws Exception{
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("redirectBoardID", redirectBoardID);
		return ezBoardDAO.getLeft_BoardSTD(map);
	}

	@Override
	public List<BoardMyFavoriteVO> get_favoriteList(String userID, String pMode) throws Exception{
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_USERID", userID);
		map.put("v_MODE", pMode);
		return ezBoardDAO.get_favoriteList(map);
	}

	@Override
	public String get_parentBoardName(String boardIdList, int boardIdListCount) throws Exception{
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_BOARDIDLIST", boardIdList);
		map.put("v_BOARDCOUNTLIST", boardIdListCount);
		return ezBoardDAO.get_parentBoardName(map);
	}

	@Override
	public String getBoardProperty(String pBoardID, BoardPropertyVO boardInfo, LoginVO userInfo) throws Exception{
		BoardPropertyVO strProp = ezBoardDAO.getBoardProperty(pBoardID);
		
		StringBuilder sb = new StringBuilder();

        sb.append("<NODES>");
        sb.append("<NODE>");
        sb.append("<ITEMEXPIRES>" + strProp.getItemExpires() + "</ITEMEXPIRES>");
        sb.append("<ATTACHLIMIT>" + strProp.getAttachSizeLimit() + "</ATTACHLIMIT>");
        sb.append("<DESCRIPTION><![CDATA[" + strProp.getBoardDescription() + "]]></DESCRIPTION>");
        sb.append("<BOARDNAME><![CDATA[" + strProp.getBoardName() + "]]></BOARDNAME>");
        sb.append("<BOARDNAME2><![CDATA[" + strProp.getBoardName2() + "]]></BOARDNAME2>");
        sb.append("<ALERTPOSTITEM><![CDATA[" + strProp.getAlertPostItem() + "]]></ALERTPOSTITEM>");
        sb.append("<REPLYNOTIFY><![CDATA[" + strProp.getReplyNotify() + "]]></REPLYNOTIFY>");
        sb.append("<URL><![CDATA[" + strProp.getUrl() + "]]></URL>");
        sb.append("<GUBUN><![CDATA[" + strProp.getGuBun() + "]]></GUBUN>");
        sb.append("<DELETEAFTER><![CDATA[" + strProp.getDeleteAfter() + "]]></DELETEAFTER>");
        sb.append("<BOARDCOLOR><![CDATA[" + strProp.getBoardColor() + "]]></BOARDCOLOR>");
        sb.append("<BOARDNO><![CDATA[" + strProp.getBoardNo() + "]]></BOARDNO>");
        sb.append("<PORTLET><![CDATA[" + strProp.getPortlet() + "]]></PORTLET>");
        sb.append("<ONELINEREPLY>" + strProp.getOneLineReply() + "</ONELINEREPLY>");
        sb.append("<BACKGROUND>" + strProp.getBackGround() + "</BACKGROUND>");
        sb.append("<FORMFLAG>" + strProp.getFormFlag() + "</FORMFLAG>");
        sb.append("<APPRFLAG>" + strProp.getApprFlag() + "</APPRFLAG>");
        sb.append("<APPRMAILFLAG>" + strProp.getApprMailFlag() + "</APPRMAILFLAG>");
        sb.append("</NODE>");
        sb.append("</NODES>");
        
        return sb.toString();
	}
	
	@Override
	public BoardPropertyVO getBoardProperty(String pBoardID) throws Exception{
		return ezBoardDAO.getBoardProperty(pBoardID);
	}
	
	@Override
	public BoardConfigVO getBoardList_Config(String userId) throws Exception {
		return ezBoardDAO.getBoardList_Config(userId);
	}

	@Override
	public List<BoardListHeaderVO> getListHeader(BoardVO ezBoardVO) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PBOARDTYPE", ezBoardVO.getBoardType());
		map.put("v_PSTRLANG", ezBoardVO.getLang());
		return ezBoardDAO.getListHeader(map);
	}

	@Override
	public void setListOrder(String pUserID, Map<String, Object> map) throws Exception {
		map.put("v_ORDERBOARDIDLIST", map.get("pBoardList"));
		map.put("v_ORDERBOARDLISTCOUNT", map.get("pBoardListCount"));
		map.put("v_DELBOARDIDLIST", map.get("pDelBoardList"));
		map.put("v_DELBOARDLISTCOUNT", map.get("pDelBoardListCount"));
		map.put("v_USERID", pUserID);
		map.put("v_ERR_CD", map.get("v_ERR_CD"));
		ezBoardDAO.setListOrder(map);
	}

	@Override
	public int getNewItemListCount(String userID, String nowDate, String fromNow)  throws Exception{
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pUserID", userID);
		map.put("v_pNow", nowDate);
		map.put("v_pFromNow", fromNow);
		return ezBoardDAO.getNewItemListCount(map);
	}

	@Override
	public BoardConfigVO getPersonalCount(String userID) throws Exception {
		return ezBoardDAO.getPersonalCount(userID);
	}

	@Override
	public List<HashMap<String, Object>> getNewItemList(BoardListVO boardListVO) throws Exception{
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PUSERID", boardListVO.getUserID());
		map.put("v_PSTARTROW", boardListVO.getStartRow());
		map.put("v_PENDROW", boardListVO.getEndRow());
		map.put("v_PTOTALCOUNT", boardListVO.getTotalCount());
		map.put("iv_PORDERBYSUB", boardListVO.getOrderBySub());
		map.put("v_PORDERBYMAIN", boardListVO.getOrderByMain());
		return ezBoardDAO.getNewItemList(map);
	}

	@Override
	public void setBoardList_Config(String pUserID, Map<String, Object> map) throws Exception {
		map.put("v_PUSERID", pUserID);
		map.put("v_PLISTCNT", map.get("pListCount"));
		map.put("v_PREVIEWMODE", map.get("pPreview"));
		map.put("v_PREVIEWWLIST", map.get("pPreviewWList"));
		map.put("v_PREVIEWWCONTENT", map.get("pPreviewWContent"));
		map.put("v_PREVIEWHLIST", map.get("pPreviewHList"));
		map.put("v_PREVIEWHCONTENT", map.get("pPreviewHContent"));
		ezBoardDAO.setBoardList_Config(pUserID, map); 
	}

	@Override
	public int getBrdNewItemCount(String userID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pUserID", userID);
		return ezBoardDAO.getBrdNewItemCount(map);
	}

	@Override
	public int getThumbNailCount(BoardMyFavoriteVO myFavoriteVO) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PBOARDID", myFavoriteVO.getBoardId());
		map.put("v_PNOW", myFavoriteVO.getNowDate());
		map.put("v_PUSERID", myFavoriteVO.getUserId());
		map.put("v_PTYPE", myFavoriteVO.getType());
		return ezBoardDAO.getThumbNailCount(map);
	}

	@Override
	public int getBrdTotalItemCount(BoardMyFavoriteVO myFavoriteVO) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PBOARDID", myFavoriteVO.getBoardId());
		map.put("v_PUSERID", myFavoriteVO.getUserId());
		map.put("v_PTYPE", myFavoriteVO.getType());
		return ezBoardDAO.getBrdTotalItemCount(map);
	}

	@Override
	public int getQNABrdTotalItemCount(BoardMyFavoriteVO myFavoriteVO) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PBOARDID", myFavoriteVO.getBoardId());
		map.put("v_PNOW", myFavoriteVO.getNowDate());
		map.put("v_PUSERID", myFavoriteVO.getUserId());
		map.put("v_PTYPE", myFavoriteVO.getType());
		map.put("v_PADMINTYPE", myFavoriteVO.getBoardAdmin_FG());
		return ezBoardDAO.getQNABrdTotalItemCount(map);
	}

	@Override
	public void setTabUsed(String pUserID, String pBoardList, String tabUsed) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_BOARDID", pBoardList);
		map.put("v_TABUSED", tabUsed);
		map.put("v_USERID", pUserID);
		ezBoardDAO.setTabUsed(map);
	}
	
	@Override
	public void setNotiOrder(String itemID) throws Exception {
		ezBoardDAO.setNotiOrder(itemID);
	}

	@Override
	public void updateCopyItem(String destItemID) throws Exception {
		ezBoardDAO.updateCopyItem(destItemID);
	}

	@Override
	public void updateMoveItem(String destItemID, String orgItemID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PITEMID", destItemID);
		map.put("v_PORGITEMID", orgItemID);
		ezBoardDAO.updateMoveItem(map);
	}

	@Override
	public void deleteItem(String itemIDs, String boardID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_STRITEMLIST", itemIDs);
		map.put("v_BOARDID", boardID);
		ezBoardDAO.deleteItem(map);
	}

	@Override
	public void deleteTempItem(String itemIDs, String boardID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_STRITEMLIST", itemIDs);
		map.put("v_BOARDID", boardID);
		ezBoardDAO.deleteTempItem(map);
	}

	@Override
	public List<BoardListHeaderVO> getListHeaderBoardID(BoardVO ezBoardVO) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PBOARDID", ezBoardVO.getBoardId());
		map.put("v_PSTRLANG", ezBoardVO.getLang());
		map.put("v_PBOARDTYPE", ezBoardVO.getBoardType());
		return ezBoardDAO.getListHeaderBoardID(map);
	}

	@Override
	public List<BoardAttachVO> brdGetItemAttachmentInfo(String pItemID) throws Exception {
		return ezBoardDAO.brdGetItemAttachmentInfo(pItemID);
	}

	@Override
	public List<BoardReadVO> getReaderList(String boardID, String itemID, String userID, String lang) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("boardID", boardID);
		map.put("itemID", itemID);
		map.put("userID", userID);
		map.put("lang", lang);
		return ezBoardDAO.getReaderList(map);
	}

	@Override
	public int getNoticePostItemCount(String boardId) throws Exception {
		return ezBoardDAO.getNoticePostItemCount(boardId);
	}

	@Override
	public int getBoardTotalItemCount(String boardId, String userID, String type) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PBOARDID", boardId);
		map.put("v_PUSERID", userID);
		map.put("v_PTYPE", type);
		return ezBoardDAO.getBrdTotalItemCount(map);
	}

	@Override
	public List<HashMap<String, Object>> getNoticePostItem(BoardVO ezBoardVO, int personalCount) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		int start = 0;
        int end = 0;
        start = ((ezBoardVO.getPageNum() - 1) * personalCount) + 1;
        end = (ezBoardVO.getPageNum() * personalCount);
        
		map.put("v_PBOARDID", ezBoardVO.getBoardId());
		map.put("v_START", start);
		map.put("v_END", end);
		return ezBoardDAO.getNoticePostItem(map);
	}

	@Override
	public List<HashMap<String, Object>> getBoardListItem(String boardId, String userID, int startRow, int endRow, int boardCount, String orderOption1, String orderOption2, String type) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PUSERID", userID);
		map.put("v_PBOARDID", boardId);
		map.put("v_PSTARTROW", startRow);
		map.put("v_PENDROW", endRow);
		map.put("v_PTOTALCOUNT", boardCount);
		map.put("iv_PORDERBYSUB", orderOption1);
		map.put("v_PORDERBYMAIN", orderOption2);
		map.put("v_TYPE", type);
		return ezBoardDAO.getBoardListItem(map);
	}

	@Override
	public List<HashMap<String, Object>> getSearchBoardItemList(BoardListVO boardListVO, BoardVO boardVO) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PUSERID", boardListVO.getUserID());
		map.put("v_PBOARDID", boardVO.getBoardId());
		map.put("v_PSTARTROW", boardListVO.getStartRow());
		map.put("v_PENDROW", boardListVO.getEndRow());
		map.put("v_PTOTALCOUNT", boardListVO.getTotalCount());
		map.put("iv_PORDERBYSUB", boardListVO.getOrderBySub());
		map.put("v_PORDERBYMAIN", boardListVO.getOrderByMain());
		map.put("v_PSUBFLAG", boardVO.getSubFlag());
		map.put("v_PSUBQUERY", boardVO.getSearchQuery());
		map.put("v_TITLE", boardVO.getTitle());
		map.put("v_WRITERNAME", boardVO.getWriterName());
		map.put("v_ABSTRACT", boardVO.getABSTRACT());
		return ezBoardDAO.getSearchBoardItemList(map);
	}

	@Override
	public int getCheckItemID(String itemID, String boardType, String userDeptPath) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_ITEMID", itemID);
		map.put("v_BOARDTYPE", boardType);
		map.put("v_ACCESSID", userDeptPath);
		return ezBoardDAO.getCheckItemID(map);
	}

	@Override
	public BoardListVO getBrdGetItemInfo(String boardID, String itemID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pBoardID", boardID);
		map.put("v_pItemID", itemID);
		return ezBoardDAO.getBrdGetItemInfo(map);
	}

	@Override
	public BoardListVO getItemInfo(String itemID) throws Exception {
		return ezBoardDAO.getItemInfo(itemID);
	}

	@Override
	public BoardListVO getCopyItem(String orgItemID, String orgBoardID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PORGITEMID", orgItemID);
		map.put("v_PORGBOARDID", orgBoardID);
		return ezBoardDAO.getCopyItem(map);
	}

	@Override
	public List<String> getCopyItemAttach(String orgItemID) throws Exception {
		return ezBoardDAO.getCopyItemAttach(orgItemID);
	}

	@Override
	public void setAsRead(LoginVO userInfo, String boardID, String itemID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("iv_pBoardID", boardID);
		map.put("v_pItemID", itemID);
		map.put("v_pUserID", userInfo.getId());
		map.put("v_pUserName", userInfo.getDisplayName1());
		map.put("v_pUserDeptName", userInfo.getDeptName1());
		map.put("v_pUserCompanyName", userInfo.getCompanyName1());
		map.put("v_pUserTitle", userInfo.getTitle1());
		map.put("v_pUserName2", userInfo.getDisplayName2());
		map.put("v_pUserDeptName2", userInfo.getDeptName2());
		map.put("v_pUserCompanyName2", userInfo.getCompanyName2());
		map.put("v_pUserTitle2", userInfo.getTitle2());
		ezBoardDAO.setAsRead(map);
	}

	@Override
	public int getCheckApprUserList(String userID, String itemID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PUSERID", userID);
		map.put("v_PITEMID", itemID);
		return ezBoardDAO.getCheckApprUserList(map);
	}

	@Override
	public int getSearchBoardItemCount(BoardVO boardVO) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pBoardID", boardVO.getBoardId());
		map.put("v_PSUBFLAG", boardVO.getSubFlag());
		map.put("v_PSUBQUERY", boardVO.getSearchQuery());
		return ezBoardDAO.getSearchBoardItemCount(map);
	}

	@Override
	public void setAsReads(LoginVO userInfo, String boardID, String pItemIDList) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("iv_pBoardID", boardID);
		map.put("v_pItemID", pItemIDList);
		map.put("v_pUserID", userInfo.getId());
		map.put("v_pUserName", userInfo.getDisplayName1());
		map.put("v_pUserDeptName", userInfo.getDeptName1());
		map.put("v_pUserCompanyName", userInfo.getCompanyName1());
		map.put("v_pUserTitle", userInfo.getTitle1());
		map.put("v_pUserName2", userInfo.getDisplayName2());
		map.put("v_pUserDeptName2", userInfo.getDeptName2());
		map.put("v_pUserCompanyName2", userInfo.getCompanyName2());
		map.put("v_pUserTitle2", userInfo.getTitle2());
		ezBoardDAO.setAsReads(map);
	}

	@Override
	public String checkForm(String boardID, String mode) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PBOARDID", boardID);
		map.put("v_PMODE", mode);
		
		String checkForm = "";
		int checkCnt = ezBoardDAO.checkForm(map);
		
		if(checkCnt > 0){
			checkForm = "TRUE";
		}else{
			checkForm = "FALSE";
		}
		return checkForm;
	}

	@Override
	public String checkBackGroundImage(String boardID) throws Exception {
		String check = "";
		int checkCnt = ezBoardDAO.checkBackGroundImage(boardID);
		if(checkCnt > 0){
			check = "TRUE";
		}else{
			check = "FALSE";
		}
		return check;
	}

	@Override
	public String brdCheckIfHasReply(String itemIDs) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pItemID", itemIDs);
		String check = "";
		int checkCnt = ezBoardDAO.brdCheckIfHasReply(map);
		if(checkCnt > 0){
			check = "TRUE";
		}else{
			check = "FALSE";
		}
		return check;
	}

	@Override
	public String getNoticePostItemAll(String boardID) throws Exception {
		List<BoardListVO> resultList = ezBoardDAO.getNoticePostItemAll(boardID);
		
		StringBuilder sb = new StringBuilder();
		sb.append("<DATA>");
		
		for(int i = 0; i < resultList.size(); i++){
			sb.append(commonUtil.getQueryResult(resultList.get(i)));
		}
		sb.append("</DATA>");
		
		return sb.toString();
	}

	@Override
	public String getParentBoardID(String boardID) throws Exception {
		return ezBoardDAO.getParentBoardID(boardID);
	}

	@Override
	public String getDocPassWord(String itemID) throws Exception {
		return ezBoardDAO.getDocPassWord(itemID);
	}

	@Override
	public void brdNewItem(BoardListVO boardListVO) throws Exception {
		ezBoardDAO.brdNewItem(boardListVO);
		ezBoardDAO.newItem(boardListVO.getItemID());
	}

	@Override
	public void brdNewItemTemp(BoardListVO boardListVO) throws Exception {
		ezBoardDAO.brdNewItemTemp(boardListVO);
		ezBoardDAO.newItem(boardListVO.getItemID());
	}

	@Override
	public void saveAttachInfo(String strItemID, String filePath, long fileSize, String fileName) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_STRITEMID", strItemID);
		map.put("v_STRATTACHMENTS", filePath);
		map.put("v_FILESIZE", fileSize);
		map.put("v_FILENAME", fileName);
		ezBoardDAO.saveAttachInfo(map);
	}
	
}
