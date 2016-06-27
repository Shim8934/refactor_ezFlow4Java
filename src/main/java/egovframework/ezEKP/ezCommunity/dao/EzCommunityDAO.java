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
import egovframework.ezEKP.ezCommunity.vo.CommunityCClubUserVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityCComCloseVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityCOutApplicationVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityCPollAnswerVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityCPollManagerVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityCPollQuestionVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityCPollResponseVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityClubVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityLeftCommunityVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityMemberInfoVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityMyCommunityVO;
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
	public List<CommunityCBoardVO> bbsListGet2(Map<String, Object> map) throws Exception {
		return (List<CommunityCBoardVO>) list("EzCommunityDAO.bbsListGet2", map);
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
	
	@SuppressWarnings("unchecked")
	public List<CommunityCPollManagerVO> pollMainGet2(String v_CODE) throws Exception {
		return (List<CommunityCPollManagerVO>) list("EzCommunityDAO.pollMainGet2", v_CODE);
	}

	@SuppressWarnings("unchecked")
	public List<CommunityCPollQuestionVO> pollDeleteGet2(String v_MANAGERID) throws Exception {
		return (List<CommunityCPollQuestionVO>) list("EzCommunityDAO.pollDeleteGet2", v_MANAGERID);
	}

	@SuppressWarnings("unchecked")
	public List<CommunityCPollAnswerVO> pollDeleteGet4(int v_QUESTIONID) throws Exception {
		return (List<CommunityCPollAnswerVO>) list("EzCommunityDAO.pollDeleteGet4", v_QUESTIONID);
	}
	
	@SuppressWarnings("unchecked")
	public List<CommunityCPollAnswerVO> pollResGet6(int v_QUESTIONID) throws Exception {
		return (List<CommunityCPollAnswerVO>) list("EzCommunityDAO.pollResGet6", v_QUESTIONID);
	}
	
	@SuppressWarnings("unchecked")
	public List<CommunityCPollResponseVO> pollETCTableGet(String v_QUESTIONID) throws Exception {
		return (List<CommunityCPollResponseVO>) list("EzCommunityDAO.pollETCTableGet", v_QUESTIONID);
	}
	
	@SuppressWarnings("unchecked")
	public List<CommunityCClubUserVO> commViewMemberGet1(Map<String, Object> map) throws Exception {
		return (List<CommunityCClubUserVO>) list("EzCommunityDAO.commViewMemberGet1", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<CommunityBoardInfoVO> getBoardList(Map<String, Object> map) throws Exception {
		return (List<CommunityBoardInfoVO>) list("EzCommunityDAO.getBoardList", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<CommunityBoardListVO> adminSearchItemXML(Map<String, Object> map) throws Exception {
		return (List<CommunityBoardListVO>) list("EzCommunityDAO.adminSearchItemXML", map);
	}

	@SuppressWarnings("unchecked")
	public List<CommunityCOutApplicationVO> adminOuterListGet2(Map<String, Object> map) throws Exception {
		return (List<CommunityCOutApplicationVO>) list("EzCommunityDAO.adminOuterListGet2", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<CommunityCClubUserVO> adminMemPermitGet2(Map<String, Object> map) throws Exception {
		return (List<CommunityCClubUserVO>) list("EzCommunityDAO.adminMemPermitGet2", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<CommunityBoardItemAttachmentVO> copyItemGet2(String v_pOrgItemID) {
		return (List<CommunityBoardItemAttachmentVO>) list("EzCommunityDAO.copyItemGet2", v_pOrgItemID);
	}

	@SuppressWarnings("unchecked")
	public List<String> myCommunityGet(Map<String, Object> map) throws Exception {
		return (List<String>) list("EzCommunityDAO.myCommunityGet", map);
	}

	@SuppressWarnings("unchecked")
	public List<CommunityMyCommunityVO> myCommunityItemGet(String v_COPNO) throws Exception {
		return (List<CommunityMyCommunityVO>) list("EzCommunityDAO.myCommunityItemGet", v_COPNO);
	}

	@SuppressWarnings("unchecked")
	public List<CommunityMyCommunityVO> mainPageGet5(String v_USERINFO_LANG) throws Exception {
		return (List<CommunityMyCommunityVO>) list("EzCommunityDAO.mainPageGet5", v_USERINFO_LANG);
	}
	
	@SuppressWarnings("unchecked")
	public List<CommunityMyCommunityVO> mainPageGet6(String v_USERINFO_LANG) throws Exception {
		return (List<CommunityMyCommunityVO>) list("EzCommunityDAO.mainPageGet6", v_USERINFO_LANG);
	}
	
	@SuppressWarnings("unchecked")
	public List<CommunityCClubUserVO> adminMemberListGet3(Map<String, Object> map) throws Exception {
		return (List<CommunityCClubUserVO>) list("EzCommunityDAO.adminMemberListGet3", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<CommunityCCategoryVO> mainPageGet4(String v_PC_CAT) throws Exception {
		return (List<CommunityCCategoryVO>) list("EzCommunityDAO.mainPageGet4", v_PC_CAT);
	}
	
	@SuppressWarnings("unchecked")
	public List<CommunityClubVO> categoryListGet(Map<String, Object> map) throws Exception {
		return (List<CommunityClubVO>) list("EzCommunityDAO.categoryListGet", map);
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

	public CommunityBoardPropertyVO getBoardProperty(String pBoardID) throws Exception{
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
	
	public CommunityCPollManagerVO pollEditGet1(String v_MANAGERID) throws Exception {
		return (CommunityCPollManagerVO) select("EzCommunityDAO.pollEditGet1", v_MANAGERID);
	}

	public CommunityCPollQuestionVO pollEditGet2(String v_MANAGERID) throws Exception {
		return (CommunityCPollQuestionVO) select("EzCommunityDAO.pollEditGet2", v_MANAGERID);
	}
	
	public CommunityMemberInfoVO commViewMemberGet3(Map<String, Object> map) throws Exception {
		return (CommunityMemberInfoVO) select("EzCommunityDAO.commViewMemberGet3", map);
	}

	public CommunityMemberInfoVO commOutGet(Map<String, Object> map) throws Exception {
		return (CommunityMemberInfoVO) select("EzCommunityDAO.commOutGet", map);
	}
	
	public CommunityCOutApplicationVO commOutOkGet1(Map<String, Object> map) throws Exception {
		return (CommunityCOutApplicationVO) select("EzCommunityDAO.commOutOkGet1", map);
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
	
	public CommunityClubVO adminLeftGet(String v_CODE) throws Exception {
		return (CommunityClubVO) select("EzCommunityDAO.adminLeftGet", v_CODE);
	}

	public CommunityClubVO ezCommunityBaseGet1(String v_STRCODE) throws Exception {
		return (CommunityClubVO) select("EzCommunityDAO.ezCommunityBaseGet1", v_STRCODE);
	}

	public CommunityMemberInfoVO aspCommInfoGet2(Map<String, Object> map) throws Exception {
		return (CommunityMemberInfoVO) select("EzCommunityDAO.aspCommInfoGet2", map);
	}
	
	public CommunityClubVO leftCommunityGet4(String v_CODE) throws Exception {
		return (CommunityClubVO) select("EzCommunityDAO.leftCommunityGet4", v_CODE);
	}
	
	public CommunityClubVO adminLogoGet(Map<String, Object> map) throws Exception {
		return (CommunityClubVO) select("EzCommunityDAO.adminLogoGet", map);
	}
	
	public CommunityMemberInfoVO getMemberInfo(Map<String, Object> map) throws Exception {
		return (CommunityMemberInfoVO) select("EzCommunityDAO.getMemberInfo", map);
	}

	public CommunityCClubUserVO adminMemberListOkGet(Map<String, Object> map) throws Exception {
		return (CommunityCClubUserVO) select("EzCommunityDAO.adminMemberListOkGet", map);
	}
	
	public CommunityCComCloseVO adminCommCloseOkGet1(String v_CODE) throws Exception {
		return (CommunityCComCloseVO) select("EzCommunityDAO.adminCommCloseOkGet1", v_CODE);
	}

	public CommunityClubVO adminCommCloseOkGet2(String v_CODE) throws Exception {
		return (CommunityClubVO) select("EzCommunityDAO.adminCommCloseOkGet2", v_CODE);
	}

	public CommunityClubVO adminNoticeMailOkGet1(String v_CODE) throws Exception {
		return (CommunityClubVO) select("EzCommunityDAO.adminNoticeMailOkGet1", v_CODE);
	}

	public CommunityClubVO joinOkGet3(Map<String, Object> map) throws Exception {
		return (CommunityClubVO) select("EzCommunityDAO.joinOkGet3", map);
	}
	
	public CommunityMemberInfoVO joinOkGet4(Map<String, Object> map) throws Exception {
		return (CommunityMemberInfoVO) select("EzCommunityDAO.joinOkGet4", map);
	}
	
	public CommunityClubVO todayCopGet2(int iv_NUM) throws Exception {
		return (CommunityClubVO) select("EzCommunityDAO.todayCopGet2", iv_NUM);
	}
	
	public CommunityCCategoryVO mainPageCategory(Map<String, Object> map) throws Exception {
		return (CommunityCCategoryVO) select("EzCommunityDAO.mainPageCategory", map);
	}
	
	public String leftCommunityGet1(Map<String, Object> map) throws Exception {
		return (String) select("EzCommunityDAO.leftCommunityGet1", map);
	}

	public String leftCommunityGet2(String CODE) throws Exception {
		return (String) select("EzCommunityDAO.leftCommunityGet2", CODE);
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
	
	public String adminSearchItemCount(Map<String, Object> map) throws Exception {
		return (String) select("EzCommunityDAO.adminSearchItemCount", map);
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
	
	public String pollMainGet1(Map<String, Object> map) throws Exception {
		return (String) select("EzCommunityDAO.pollMainGet1", map);
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

	public String pollAddOkGoGet2(Map<String, Object> map) throws Exception {
		return (String) select("EzcommunityDAO.pollAddOkGoGet2", map);
	}

	public String pollAddOkGoGet3(String v_MANAGERID) throws Exception {
		return (String) select("EzCommunityDAO.pollAddOkGoGet3", v_MANAGERID);
	}

	public String pollDeleteGet1(String v_MANAGERID) throws Exception {
		return (String) select("EzCommunityDAO.pollDeleteGet1", v_MANAGERID);
	}
	
	public String pollDeleteGet3(String v_CODE) throws Exception {
		return (String) select("EzCommunityDAO.pollDeleteGet3", v_CODE);
	}
	
	public String pollResGet1(Map<String, Object> map) throws Exception {
		return (String) select("EzCommunityDAO.pollResGet1", map);
	}
	
	public String pollResGet4(Map<String, Object> map) throws Exception {
		return (String) select("EzCommunityDAO.pollResGet4", map);
	}
	
	public String pollETCViewGet(String v_QUESTIONID) throws Exception {
		return (String) select("EzCommunityDAO.pollETCViewGet", v_QUESTIONID);
	}
	
	public String commViewMemberGet2(Map<String, Object> map) throws Exception {
		return (String) select("EzCommunityDAO.commViewMemberGet2", map);
	}
	
	public String adminMemberListGet2(String v_CODE) throws Exception {
		return (String) select("EzCommunityDAO.adminMemberListGet2", v_CODE);
	}
	
	public String ezCommunityBaseGet3(Map<String, Object> map) throws Exception {
		return (String) select("EzCommunityDAO.ezCommunityBaseGet3", map);
	}
	
	public String adminMemPermitGet1(String v_CODE) throws Exception {
		return (String) select("EzCommunityDAO.adminMemPermitGet1", v_CODE);
	}

	public String adminBasicGet1(String v_CODE) throws Exception {
		return (String) select("EzCommunityDAO.adminBasicGet1", v_CODE);
	}
	
	public String adminBasicGet2(String v_CODE) throws Exception {
		return (String) select("EzCommunityDAO.adminBasicGet2", v_CODE);
	}

	public String checkPassword(String v_PITEMID) throws Exception {
		return (String) select("EzCommunityDAO.checkPassword", v_PITEMID);
	}
	
	public String join1Get(Map<String, Object> map) throws Exception {
		return (String) select("EzCommunityDAO.join1Get", map);
	}

	public String joinGet1(Map<String, Object> map) throws Exception {
		return (String) select("EzCommunityDAO.joinGet1", map);
	}

	public String joinGet2(Map<String, Object> map) throws Exception {
		return (String) select("EzCommunityDAO.joinGet2", map);
	}

	public String joinOkGet1(Map<String, Object> map) throws Exception {
		return (String) select("EzCommunityDAO.joinOkGet1", map);
	}
	
	public String joinOkGet2(Map<String, Object> map) throws Exception {
		return (String) select("EzCommunityDAO.joinOkGet2", map);
	}
	
	public String getACLGet1(String v_CID) throws Exception {
		return (String) select("EzCommunityDAO.getACLGet1", v_CID);
	}

	public String getACLGet2(Map<String, Object> map) throws Exception {
		return (String) select("EzCommunityDAO.getACLGet2", map);
	}
	
	public String todayCopGet1() throws Exception {
		return (String) select("EzCommunityDAO.todayCopGet1");
	}
	
	public String todayCopGet3(Map<String, Object> map) throws Exception {
		return (String) select("EzCommunityDAO.todayCopGet3", map);
	}

	public String categoryListItemCntGet(String v_C_CLUBNO) throws Exception {
		return (String) select("EzCommunityDAO.categoryListItemCntGet", v_C_CLUBNO);
	}
	
	public Integer pollResGetAllCount(int v_QUESTIONID) throws Exception {
		return (Integer) select("EzCommunityDAO.pollResGetAllCount", v_QUESTIONID);
	}

	public Integer pollResGetCount(Map<String, Object> map) throws Exception {
		return (Integer) select("EzCommunityDAO.pollResGetCount", map);
	}
	
	public Integer adminOuterListGet1(String v_CODE) throws Exception {
		return (Integer) select("EzCommunityDAO.adminOuterListGet1", v_CODE);
	}
	
	public Integer checkIfLeafBoardGet(Map<String, Object> map) throws Exception {
		select("EzCommunityDAO.checkIfLeafBoardGet", map);
		return (Integer) map.get("v_pCount");
	}
	
	public Integer bbsListGet1(Map<String, Object> map) throws Exception {
		select("EzCommunityDAO.bbsListGet1", map);
		return (Integer) map.get("v_pCount");
	}
	
	public Integer commMakeOkGet2(Map<String, Object> map) throws Exception {
		select("EzCommunityDAO.commMakeOkGet2", map);
		return (Integer) map.get("v_pCount");
	}

	public Integer commMakeOkGet4(Map<String, Object> map) throws Exception {
		select("EzCommunityDAO.commMakeOkGet4", map);
		return (Integer) map.get("v_pCount");
	}

	public Integer commHomeGet2(Map<String, Object> map) throws Exception {
		select("EzCommunityDAO.commHomeGet2", map);
		return (Integer) map.get("v_pCount");
	}
	
	public Integer checkOneLineOwner(Map<String, Object> map) throws Exception {
		select("EzCommunityDAO.checkOneLineOwner", map);
		return (Integer) map.get("v_pCount");
	}
	
	public Integer boardPropertyGet(Map<String, Object> map) throws Exception {
		select("EzCommunityDAO.boardPropertyGet", map);
		return (Integer) map.get("v_pCount");
	}
	
	public Integer adminMemberListGet1(String v_CODE) throws Exception {
		return (Integer) select("EzCommunityDAO.adminMemberListGet1", v_CODE);
	}

	public Integer adminMemberListOkGetE(Map<String, Object> map) throws Exception {
		select("EzCommunityDAO.adminMemberListOkGetE", map);
		return (Integer) map.get("v_pCount");
	}

	public void bbsEditOkInsert(Map<String, Object> map) throws Exception{
		insert("EzCommunityDAO.bbsEditOkInsert", map);
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
	
	public void deleteItem4(Map<String, Object> map) throws Exception {
		insert("EzCommunityDAO.deleteItem4", map);
	}

	public void brdNewItem(Map<String, Object> map) throws Exception {
		insert("EzCommunityDAO.brdNewItem", map);
	}
	
	public void insertAttachInfo(Map<String, Object> map) throws Exception {
		insert("EzCommunityDAO.insertAttachInfo", map);
	}

	public void saveOneLineReply(Map<String, Object> map) throws Exception {
		insert("EzCommunityDAO.saveOneLineReply", map);		
	}
	
	public void guestEditOkInsert(Map<String, Object> map) throws Exception {
		insert("EzCommunityDAO.guestEditOkInsert", map);
	}
	
	public void pollAddOkGoInsert1(Map<String, Object> map) throws Exception {
		insert("EzCommunityDAO.pollAddOkGoInsert1", map);
	}

	public void pollAddOkGoInsert3(Map<String, Object> map) throws Exception {
		insert("EzCommunityDAO.pollAddOkGoInsert3", map);
	}
	
	public void pollAddOkGoInsert2(Map<String, Object> map) throws Exception {
		insert("EzCommunityDAO.pollAddOkGoInsert2", map);
	}
	
	public void commOutOkInsert(Map<String, Object> map) throws Exception {
		insert("EzCommunityDAO.commOutOkInsert", map);
	}

	public void createBoardGroup(Map<String, Object> map) throws Exception {
		insert("EzCommunityDAO.createBoardGroup", map);
	}
	
	public void createBoardInsert(Map<String, Object> map) throws Exception {
		insert("EzCommunityDAO.createBoardInsert", map);
	}
	
	public void pollResOkSet(Map<String, Object> map) throws Exception {
		insert("EzCommunityDAO.pollResOkSet", map);
	}
	
	public void adminCommCloseOkInser(Map<String, Object> map) throws Exception {
		insert("EzCommunityDAO.adminCommCloseOkInser", map);
	}

	public void updateAttachInfo(Map<String, Object> map) throws Exception {
		update("EzCommunityDAO.updateAttachInfo", map);
	}

	public void bbsEditOkSet1(Map<String, Object> map) throws Exception{
		update("EzCommunityDAO.bbsEditOkSet1", map);
	}

	public void bbsEditOkSet2(Map<String, Object> map) throws Exception{
		update("EzCommunityDAO.bbsEditOkSet2", map);
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

	public void brdUpdateItem(Map<String, Object> map) throws Exception {
		update("EzCommunityDAO.brdUpdateItem", map);
	}

	public void guestEditOkUpdate(Map<String, Object> map) throws Exception {
		update("EzCommunityDAO.guestEditOkUpdate", map);
	}

	public void pollEditOkUpdate(Map<String, Object> map) throws Exception {
		update("EzCommunityDAO.pollEditOkUpdate", map);
	}
	
	public void adminLogoOkUpdate1(Map<String, Object> map) throws Exception {
		update("EzCommunityDAO.adminLogoOkUpdate1", map);
	}

	public void adminCommType(Map<String, Object> map) throws Exception {
		update("EzCommunityDAO.adminCommType", map);
	}

	public void adminLoGoOkUpdate2(Map<String, Object> map) throws Exception {
		update("EzCommunityDAO.adminLogoOkUpdate2", map);
	}

	public void adminHomeBoardSet(Map<String, Object> map) throws Exception {
		update("EzCommunityDAO.adminHomeBoardSet", map);
	}

	public void saveBoardOrder(Map<String, Object> map) throws Exception {
		update("EzCommunityDAO.saveBoardOrder", map);
	}
	
	public void adminBasicOkIpdate(Map<String, Object> map) throws Exception {
		update("EzCommunityDAO.adminBasicOkUpdate", map);
	}
	
	public void moveBoard(Map<String, Object> map) throws Exception {
		update("EzCommunityDAO.moveBoard", map);
	}
	
	public void adminOuterOkNoSet(Map<String, Object> map) throws Exception {
		update("EzCommunityDAO.adminOuterOkNoSet", map);	
	}
	
	public void adminMemberListGoSE(Map<String, Object> map) throws Exception {
		update("EzCommunityDAO.adminMemberListGoSE", map);
	}

	public void brdSaveBoardProperty(Map<String, Object> map) {
		update("EzCommunityDAO.brdSaveBoardProperty", map);
	}
	
	public void copyUpdate(String v_pItemID) throws Exception {
		update("EzCommunityDAO.copyUpdate", v_pItemID);
	}

	public void newItemDel(String v_PITEMID) throws Exception {
		delete("EzCommunityDAO.newItemDel", v_PITEMID);
	}

	public void joinOkSet1(Map<String, Object> map) throws Exception {
		update("EzCommunityDAO.joinOkSet1", map);
	}

	public void joinOkUpdate1(Map<String, Object> map) throws Exception {
		update("EzCommunityDAO.joinOkUpdate1", map);
	}

	public void joinOkUpdate3(Map<String, Object> map) throws Exception {
		update("EzCommunityDAO.joinOkUpdate3", map);
	}

	public void joinOkUpdate2(Map<String, Object> map) throws Exception {
		update("EzCommunityDAO.joinOkUpdate2", map);
	}

	public void okNoSet(Map<String, Object> map) throws Exception {
		update("EzCommunityDAO.okNoSet", map);
	}
	
	public void guestEditOkDelete(Map<String, Object> map) throws Exception {
		delete("EzCommunityDAO.guestEditOkDelete", map);
	}
	
	public void getBoardTreeSet(Map<String, Object> map) throws Exception {
		delete("EzCommunityDAO.getBoardTreeSet", map);
	}

	public void bbsDelOkDel(Map<String, Object> map) throws Exception {
		delete("EzCommunityDAO.bbsDelOkDel", map);
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
	
	public void deleteItem5(String itemID) throws Exception {
		delete("EzCommunityDAO.deleteItem5", itemID);
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

	public void deleteBoard() throws Exception {
		delete("EzCommunityDAO.deleteBoard");
	}

	public void brdDeleteBoard(String v_pBoardID) throws Exception {
		delete("EzCommunityDAO.brdDeleteBoard", v_pBoardID);
	}

	@SuppressWarnings("unchecked")
	public List<CommunityClubVO> searchCop(Map<String, Object> map) throws Exception {
		return (List<CommunityClubVO>) list("EzCommunityDAO.searchCop", map);
		
	}



}
