package egovframework.ezEKP.ezCommunity.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.ezEKP.ezCommunity.vo.CommunityBoardInfoVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityBoardItemVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityBoardListVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityBoardPropertyVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityBoardTreeVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityCBoardVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityCCategoryVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityClubVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityLeftCommunityVO;
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

	public CommunityBoardPropertyVO getACL(Map<String, Object> map) throws Exception {
		return (CommunityBoardPropertyVO) select("EzCommunityDAO.getACL", map);
	}

	public CommunityBoardPropertyVO getBoardProperty(String pBoardID) {
		return (CommunityBoardPropertyVO) select("EzCommunityDAO.brdGetBoardProperty", pBoardID);
	}
	
	public CommunityClubVO aspCommInfoGet1(Map<String, Object> map) throws Exception {
		return (CommunityClubVO) select("EzCommunityDAO.aspCommInfoGet1", map);
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

	public String deleteItemGet(String itemID) throws Exception {
		return (String) select("EzCommunityDAO.deleteItemGet", itemID);
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

}
