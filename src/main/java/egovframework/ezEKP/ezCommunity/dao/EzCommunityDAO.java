package egovframework.ezEKP.ezCommunity.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.ezEKP.ezCommunity.vo.CommunityBoardInfoVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityBoardItemAttachmentVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityBoardItemReadVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityBoardItemVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityBoardListVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityBoardPropertyVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityBoardTreeVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityCBoardVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityCCategoryVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityCClubGuestVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityCPollAnswerVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityCPollManagerVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityCPollQuestionVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityCPollResponseVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityClubVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityLeftCommunityVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityOneLineReplyVO;
import egovframework.rte.psl.dataaccess.EgovAbstractDAO;

@Repository("EzCommunityDAO")
public class EzCommunityDAO extends EgovAbstractDAO{
	@SuppressWarnings("unchecked")
	public List<CommunityLeftCommunityVO> leftCommunityGet3(String userID) throws Exception {
		return (List<CommunityLeftCommunityVO>) list("EzCommunityDAO.leftCommunityGet3", userID);
	}
	
	@SuppressWarnings("unchecked")
	public List<CommunityCBoardVO> getLeftBoardList() throws Exception {
		return (List<CommunityCBoardVO>) list("EzCommunityDAO.getLeftBoardList");
	}
	
	@SuppressWarnings("unchecked")
	public List<CommunityCCategoryVO> getCategoryValueA() throws Exception {
		return (List<CommunityCCategoryVO>) list("EzCommunityDAO.getCategoryValueA");
	}

	@SuppressWarnings("unchecked")
	public List<CommunityCCategoryVO> getCategoryValueB() throws Exception {
		return (List<CommunityCCategoryVO>) list("EzCommunityDAO.getCategoryValueB");
	}
	
	@SuppressWarnings("unchecked")
	public List<CommunityCCategoryVO> getCategoryValueC() throws Exception {
		return (List<CommunityCCategoryVO>) list("EzCommunityDAO.getCategoryValueC");
	}
	
	@SuppressWarnings("unchecked")
	public List<CommunityBoardTreeVO> brdBoardTree(Map<String, Object> map) throws Exception {
		return (List<CommunityBoardTreeVO>) list("EzCommunityDAO.brdBoardTree", map);
	}

	@SuppressWarnings("unchecked")
	public List<CommunityBoardTreeVO> getBoardTreeGet2(String pUserID) throws Exception {
		return (List<CommunityBoardTreeVO>) list("EzCommunityDAO.getBoardTreeGet2", pUserID);
	}
	
	@SuppressWarnings("unchecked")
	public List<String> goAdminOkGet1() throws Exception {
		return (List<String>) list("EzCommunityDAO.goAdminOkGet1");
	}
	
	@SuppressWarnings("unchecked")
	public List<CommunityClubVO> goAdminOkGet2(String v_PCLUBID) throws Exception {
		return (List<CommunityClubVO>) list("EzCommunityDAO.goAdminOkGet2", v_PCLUBID);
	}
	
	@SuppressWarnings("unchecked")
	public List<CommunityCBoardVO> getBBSListGet2(Map<String, Object> map) throws Exception {
		return (List<CommunityCBoardVO>) list("EzCommunityDAO.getBBSListGet2", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<CommunityCBoardVO> bbsViewNewGet2(String v_BNAME) throws Exception {
		return (List<CommunityCBoardVO>) list("EzCommunityDAO.bbsViewNewGet2", v_BNAME);
	}
	
	@SuppressWarnings("unchecked")
	public List<CommunityBoardInfoVO> copHomeBoardGet(String v_CN) throws Exception {
		return (List<CommunityBoardInfoVO>) list("EzCommunityDAO.copHomeBoardGet", v_CN);
	}

	@SuppressWarnings("unchecked")
	public List<CommunityBoardItemVO> copHomeBoardItemGet(String v_BOARDID) throws Exception {
		return (List<CommunityBoardItemVO>) list("EzCommunityDAO.copHomeBoardItemGet", v_BOARDID);
	}

	@SuppressWarnings("unchecked")
	public List<CommunityBoardItemVO> getNewItemListXML(Map<String, Object> map) throws Exception {
		return (List<CommunityBoardItemVO>) list("EzCommunityDAO.getNewItemListXML", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<CommunityBoardListVO> boardItemListGet2(Map<String, Object> map) throws Exception {
		return (List<CommunityBoardListVO>) list("EzCommunityDAO.boardItemListGet2", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<CommunityBoardListVO> searchItemXML(Map<String, Object> map) throws Exception {
		return (List<CommunityBoardListVO>) list("EzCommunityDAO.searchItemXML", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<CommunityBoardItemVO> getAdjacentItemsGet1(Map<String, Object> map) throws Exception {
		return (List<CommunityBoardItemVO>) list("EzCommunityDAO.getAdjacentItemGet1", map);
	}

	@SuppressWarnings("unchecked")
	public List<CommunityBoardItemVO> getAdjacentItemGet2(Map<String, Object> map) throws Exception {
		return (List<CommunityBoardItemVO>) list("EzCommunityDAO.getAdjacentItemGet2", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<CommunityBoardItemAttachmentVO> getItemAttachmentXML(String v_pItemID) throws Exception {
		return (List<CommunityBoardItemAttachmentVO>) list("EzCommunityDAO.getItemAttachmentXML", v_pItemID);
	}
	
	@SuppressWarnings("unchecked")
	public List<CommunityBoardListVO> getReservedItemListXML(Map<String, Object> map) throws Exception {
		return (List<CommunityBoardListVO>) list("EzCommunityDAO.getReservedItemListXML", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<CommunityOneLineReplyVO> readOneLineReply(Map<String, Object> map) throws Exception {
		return (List<CommunityOneLineReplyVO>) list("EzCommunityDAO.readOneLineReply", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<CommunityBoardItemReadVO> getReaderList(Map<String, Object> map) throws Exception {
		return (List<CommunityBoardItemReadVO>) list("EzCommunityDAO.getReaderList", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<CommunityCClubGuestVO> guestOneGet2(Map<String, Object> map) throws Exception {
		return (List<CommunityCClubGuestVO>) list("EzCommunityDAO.guestOneGet2", map);
	}
	
	public CommunityCBoardVO bbsViewNewGet1(Map<String, Object> map) throws Exception {	
		return (CommunityCBoardVO) select("EzCommunityDAO.bbsViewNewGet1", map);
	}

	public CommunityCBoardVO bbsEditNew(Map<String, Object> map) throws Exception{
		return (CommunityCBoardVO) select("EzCommunityDAO.bbsEditNew", map);
	}
	
	public CommunityCBoardVO bbsEditOkGet1(Map<String, Object> map) throws Exception{
		return (CommunityCBoardVO) select("EzCommunityDAO.bbsEditOkGet1", map);
	}
	
	public CommunityCBoardVO bbsDelOkGet(Map<String, Object> map) throws Exception{
		return (CommunityCBoardVO) select("EzCommunityDAO.getbbsDelOkGet", map);
	}
	
	public CommunityClubVO commMakeOkGet1(Map<String, Object> map) throws Exception{
		return (CommunityClubVO) select("EzCommunityDAO.commMakeOkGet1", map);
	}
	
	public CommunityBoardListVO boardItemListGet1(Map<String, Object> map) throws Exception {
		return (CommunityBoardListVO) select("EzCommunityDAO.boardItemListGet1", map);
	}

	public CommunityBoardPropertyVO brdGetACL(Map<String, Object> map) throws Exception {
		return (CommunityBoardPropertyVO) select("EzCommunityDAO.brdGetACL", map);
	}

	public CommunityBoardPropertyVO getBoardProperty(String pBoardID) {
		return (CommunityBoardPropertyVO) select("EzCommunityDAO.brdGetBoardProperty", pBoardID);
	}
	
	public CommunityClubVO aspCommInfoGet1(Map<String, Object> map) throws Exception {
		return (CommunityClubVO) select("EzCommunityDAO.aspCommInfoGet1", map);
	}
	
	public CommunityBoardItemVO getItemXML(Map<String, Object> map) throws Exception {
		return (CommunityBoardItemVO) select("EzCommunityDAO.getItemXML", map);
	}

	public CommunityBoardItemVO getAdjacentItemGet3(Map<String, Object> map) throws Exception {
		return (CommunityBoardItemVO) select("EzCommunityDAO.getAdjacentItemGet3", map);
	}
	
	public CommunityBoardItemVO copyItemGet1(Map<String, Object> map) throws Exception {
		return (CommunityBoardItemVO) select("EzCommunityDAO.copyItemGet1", map);
	}
	
	public CommunityCClubGuestVO guestEditGet(Map<String, Object> map) throws Exception {
		return (CommunityCClubGuestVO) select("EzCommunityDAO.guestEditGet", map);
	}
	
	public String leftCommunityGet1(Map<String, Object> map) throws Exception {
		return (String) select("EzCommunityDAO.leftCommunityGet1", map);
	}

	public String leftCommunityGet2(String CODE) throws Exception {
		return (String) select("EzCommunityDAO.leftCommunityGet2", CODE);
	}

	public String leftCommunityGet4(String CODE) throws Exception {
		return (String) select("EzCommunityDAO.leftCommunityGet4", CODE);
	}

	public String brdCheckIfBoardGroupAdmin(Map<String, Object> map) throws Exception {
		return (String) select("EzCommunityDAO.brdCheckIfBoardGroupAdmin", map);
	}
	
	public String getBoardTitleName(Map<String, Object> map) throws Exception {
		return (String) select("EzCommunityDAO.ezCommunityBaseGet4", map);
	}

	public String getBoardTreeGet1(Map<String, Object> map) throws Exception {
		return (String) select("EzCommunityDAO.getBoardTreeGet1", map);
	}
	
	public String ezCommunityBaseGet2(Map<String, Object> map) throws Exception {
		return (String) select("EzCommunityDAO.ezCommunityBaseGet2", map);
	}

	public String bbsEditGet1(Map<String, Object> map) throws Exception {
		return (String) select("EzCommunityDAO.bbsEditGet1", map);
	}
	
	public String bbsEditOkGet2(Map<String, Object> map) throws Exception{
		return (String) select("EzCommunityDAO.bbsEditOkGet2", map);
	}
	
	public String bbsEditOkGet3(Map<String, Object> map) throws Exception{
		return (String) select("EzCommunityDAO.bbsEditOkGet3", map);
	}
	
	public String commMakeOkGet6(Map<String, Object> map) throws Exception{
		return (String) select("EzCommunityDAO.commMakeOkGet6", map);
	}
	
	public String commMakeOkGet3() throws Exception {
		return (String) select("EzCommunityDAO.commMakeOkGet3");
	}
	
	public String getClubCHK(Map<String, Object> map) throws Exception {
		return (String) select("EzCommunityDAO.getClubCHK", map);
	}

	public String commHomeGet1(Map<String, Object> map) throws Exception {
		return (String) select("EzCommunityDAO.commHomeGet1", map);
	}
	
	public String commHomeGet4(String v_CODE) throws Exception {
		return (String) select("EzCommunityDAO.commHomeGet4", v_CODE);
	}
	
	public String getBoardTotalItemCount(Map<String, Object> map) throws Exception {
		return (String) select("EzCommunityDAO.getBoardTotalItemCount", map);
	}
	
	public String searchItemCount(Map<String, Object> map) throws Exception {
		return (String) select("EzCommunityDAO.searchItemCount", map);
	}
	
	public String brdNewItemCount(Map<String, Object> map) throws Exception {
		return (String) select("EzCommunityDAO.brdNewItemCount", map);
	}
	
	public String checkIfHasReply(String v_pItemID) throws Exception {
		return (String) select("EzCommunityDAO.checkIfHasReply", v_pItemID);
	}
	
	public String getVersionInfo(String v_PBOARDID) throws Exception {
		return (String) select("EzCommunityDAO.getVersionInfo", v_PBOARDID);
	}
	
	public String deleteItemGet(String itemID) throws Exception {
		return (String) select("EzCommunityDAO.deleteItemGet", itemID);
	}
	
	public String getReservedItemListCount(Map<String, Object> map) throws Exception {
		return (String) select("EzCommunityDAO.getReservedItemListCount", map);
	}
	
	public String checkReplyPassword(Map<String, Object> map) throws Exception {
		return (String) select("EzCommunityDAO.checkReplyPassword", map);
	}

	public String deleteOneLineReply(Map<String, Object> map) throws Exception {
		return (String) select("EzCommunityDAO.deleteOneLineReply", map);
	}

	public String getACL(Map<String, Object> map) throws Exception{
		return (String) select("EzCommunityDAO.getACL", map);
	}

	public String guestOneGet1(Map<String, Object> map) throws Exception {
		return (String) select("EzCommunityDAO.guestOneGet1", map);
	}
	
	public int checkIfLeafBoardGet(Map<String, Object> map) throws Exception {
		select("EzCommunityDAO.checkIfLeafBoardGet", map);
		return (int) map.get("v_pCount");
	}
	
	public int getBBSListGet1(Map<String, Object> map) throws Exception {
		select("EzCommunityDAO.getBBSListGet1", map);
		return (int) map.get("v_pCount");
	}
	
	public int commMakeOkGet2(Map<String, Object> map) throws Exception {
		select("EzCommunityDAO.commMakeOkGet2", map);
		return (int) map.get("v_pCount");
	}

	public int commMakeOkGet4(Map<String, Object> map) throws Exception {
		select("EzCommunityDAO.commMakeOkGet4", map);
		return (int) map.get("v_pCount");
	}

	public int commHomeGet2(Map<String, Object> map) throws Exception {
		select("EzCommunityDAO.commHomeGet2", map);
		return (int) map.get("v_pCount");
	}
	
	public int checkOneLineOwner(Map<String, Object> map) throws Exception {
		select("EzCommunity.checkOneLineOwner", map);
		return (int) map.get("v_pCount");
	}
	
	public void bbsEditOkSet1(Map<String, Object> map) throws Exception{
		update("EzCommunityDAO.bbsEditOkSet1", map);
	}

	public void bbsEditOkSet2(Map<String, Object> map) throws Exception{
		update("EzCommunityDAO.bbsEditOkSet2", map);
	}

	public void bbsEditOkInsert(Map<String, Object> map) throws Exception{
		insert("EzCommunityDAO.bbsEditOkInsert", map);
	}

	public void getBoardTreeSet(Map<String, Object> map) throws Exception {
		delete("EzCommunityDAO.getBoardTreeSet", map);
	}

	public void bbsDelOkDel(Map<String, Object> map) throws Exception {
		delete("EzCommunityDAO.bbsDelOkDel", map);
	}

	public void commMakeOkInsert1() throws Exception {
		insert("EzCommunityDAO.commMakeOkInsert1");	
	}

	public void commMakeOkInsert2(Map<String, Object> map) throws Exception {
		insert("EzCommunityDAO.commMakeOkInsert2", map);
	}

	public void joinOkInsert(Map<String, Object> map) throws Exception {
		insert("EzCommunityDAO.joinOkInsert", map);
	}

	public void commMakeOkSet1(Map<String, Object> map) throws Exception {
		update("EzCommunityDAO.commMakeOkSet1", map);
	}

	public void commMakeOkSet2(Map<String, Object> map) throws Exception {
		update("EzCommunityDAO.commMAkeOkSet2", map);
	}

	public void updateLastDate(Map<String, Object> map) throws Exception {
		update("EzCommunityDAO.updateLastDate", map);
	}

	public void setAsRead(Map<String, Object> map) throws Exception {
		update("EzCommunityDAO.setAsRead", map);
	}

	public void deleteItem1(String itemID) throws Exception {
		delete("EzCommunityDAO.deleteItem1", itemID);
	}
	
	public void deleteItem2(String itemID) throws Exception {
		delete("EzCommunityDAO.deleteItem2", itemID);
	}
	
	public void deleteItem3(String itemID) throws Exception {
		delete("EzCommunityDAO.deleteItem3", itemID);
	}
	
	public void deleteItem4(Map<String, Object> map) throws Exception {
		insert("EzCommunityDAO.deleteItem4", map);
	}

	public void brdNewItem(Map<String, Object> map) throws Exception {
		insert("EzCommunityDAO.brdNewItem", map);
	}

	public void updateAttachInfo(Map<String, Object> map) throws Exception {
		update("EzCommunityDAO.updateAttachInfo", map);
	}

	public void insertAttachInfo(Map<String, Object> map) throws Exception {
		insert("EzCommunityDAO.insertAttachInfo", map);
	}

	public void brdUpdateItem(Map<String, Object> map) throws Exception {
		update("EzCommunityDAO.brdUpdateItem", map);
	}

	public void saveOneLineReply(Map<String, Object> map) throws Exception {
		insert("EzCommunityDAO.saveOneLineReply", map);		
	}
	
	public void guestEditOkInsert(Map<String, Object> map) throws Exception {
		insert("EzCommunityDAO.guestEditOkInsert", map);
	}

	public void guestEditOkDelete(Map<String, Object> map) throws Exception {
		delete("EzCommunityDAO.guestEditOkDelete", map);
	}

	public void guestEditOkUpdate(Map<String, Object> map) throws Exception {
		update("EzCommunityDAO.guestEditOkUpdate", map);
	}

	public String pollMainGet1(Map<String, Object> map) throws Exception {
		return (String) select("EzCommunityDAO.pollMainGet1", map);
	}

	@SuppressWarnings("unchecked")
	public List<CommunityCPollManagerVO> pollMainGet2(String v_CODE) throws Exception {
		return (List<CommunityCPollManagerVO>) list("EzCommunityDAO.pollMainGet2", v_CODE);
	}

	public String pollMainGet3(String v_MANAGERID) throws Exception {
		return (String) select("EzCommunityDAO.pollMainGet3", v_MANAGERID);
	}

	public String pollMainGet4(String v_STRQUESTIONID) throws Exception {
		return (String) select("EzCommunityDAO.pollMainGet4", v_STRQUESTIONID);
	}

	public String pollAddOkGoGet1(String v_CODE) throws Exception {
		return (String) select("EzCommunityDAO.pollAddOkGoGet1", v_CODE);
	}

	public void pollAddOkGoInsert1(Map<String, Object> map) throws Exception {
		insert("EzCommunityDAO.pollAddOkGoInsert1", map);
	}

	public String pollAddOkGoGet2(Map<String, Object> map) throws Exception {
		return (String) select("EzcommunityDAO.pollAddOkGoGet2", map);
	}

	public void pollAddOkGoInsert2(Map<String, Object> map) throws Exception {
		insert("EzCommunityDAO.pollAddOkGoInsert2", map);
	}

	public String pollAddOkGoGet3(String v_MANAGERID) throws Exception {
		return (String) select("EzCommunityDAO.pollAddOkGoGet3", v_MANAGERID);
	}

	public void pollAddOkGoInsert3(Map<String, Object> map) throws Exception {
		insert("EzCommunityDAO.pollAddOkGoInsert3", map);
	}

	public String pollDeleteGet1(String v_MANAGERID) throws Exception {
		return (String) select("EzCommunityDAO.pollDeleteGet1", v_MANAGERID);
	}

	public String pollDeleteGet3(String v_CODE) throws Exception {
		return (String) select("EzCommunityDAO.pollDeleteGet3", v_CODE);
	}

	@SuppressWarnings("unchecked")
	public List<CommunityCPollQuestionVO> pollDeleteGet2(String v_MANAGERID) throws Exception {
		return (List<CommunityCPollQuestionVO>) list("EzCommunityDAO.pollDeleteGet2", v_MANAGERID);
	}

	@SuppressWarnings("unchecked")
	public List<CommunityCPollAnswerVO> pollDeleteGet4(int v_QUESTIONID) throws Exception {
		return (List<CommunityCPollAnswerVO>) list("EzCommunityDAO.pollDeleteGet4", v_QUESTIONID);
	}

	public void pollDeleteDel1(Map<String, Object> map) throws Exception {
		delete("EzCommunityDAO.pollDeleteDel1", map);
	}

	public void pollDeleteDel2(int v_QUESTIONID) throws Exception {
		delete("EzCommunityDAO.pollDeleteDel2", v_QUESTIONID);
	}

	public void pollDeleteDel3(String v_MANAGERID) throws Exception {
		delete("EzCommunityDAO.pollDeleteDel3", v_MANAGERID);
	}

	public String pollResGet1(Map<String, Object> map) throws Exception {
		return (String) select("EzCommunityDAO.pollResGet1", map);
	}

	public CommunityCPollManagerVO pollResGet2(String v_POLLMANAGERID) throws Exception {
		return (CommunityCPollManagerVO) select("EzCommunityDAO.pollResGet2", v_POLLMANAGERID);
	}

	public CommunityCPollQuestionVO pollResGet3(String v_POLLMANAGERID) throws Exception {
		return (CommunityCPollQuestionVO) select("EzCommunityDAO.pollResGet3", v_POLLMANAGERID);
	}

	public CommunityCPollResponseVO pollResGet5(Map<String, Object> map) throws Exception {
		return (CommunityCPollResponseVO) select("EzCommunityDAO.pollResGet5", map);
	}

	public Integer pollResGetAllCount(int v_QUESTIONID) throws Exception {
		return (Integer) select("EzCommunityDAO.pollResGetAllCount", v_QUESTIONID);
	}

	@SuppressWarnings("unchecked")
	public List<CommunityCPollAnswerVO> pollResGet6(int v_QUESTIONID) throws Exception {
		return (List<CommunityCPollAnswerVO>) list("EzCommunityDAO.pollResGet6", v_QUESTIONID);
	}

	public Integer pollResGetCount(Map<String, Object> map) throws Exception {
		return (Integer) select("EzCommunityDAO.pollResGetCount", map);
	}

	public String pollResGet4(Map<String, Object> map) throws Exception {
		return (String) select("EzCommunityDAO.pollResGet4", map);
	}
}
