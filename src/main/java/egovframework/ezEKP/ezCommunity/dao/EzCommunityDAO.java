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
import egovframework.ezEKP.ezCommunity.vo.CommunityMemberInfoVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityMyCommunityVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityOneLineReplyVO;
import egovframework.rte.psl.dataaccess.EgovAbstractDAO;

@Repository("EzCommunityDAO")
public class EzCommunityDAO extends EgovAbstractDAO{
	@SuppressWarnings("unchecked")
	public List<CommunityClubVO> leftCommunityGet3(Map<String, Object> map) throws Exception {
		return (List<CommunityClubVO>) list("EzCommunityDAO.leftCommunityGet3", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<CommunityCBoardVO> getLeftBoardList(int tenantID) throws Exception {
		return (List<CommunityCBoardVO>) list("EzCommunityDAO.getLeftBoardList", tenantID);
	}
	
	@SuppressWarnings("unchecked")
	public List<CommunityCCategoryVO> getCategoryValueA(int tenantID) throws Exception {
		return (List<CommunityCCategoryVO>) list("EzCommunityDAO.getCategoryValueA", tenantID);
	}

	@SuppressWarnings("unchecked")
	public List<CommunityCCategoryVO> getCategoryValueB(int tenantID) throws Exception {
		return (List<CommunityCCategoryVO>) list("EzCommunityDAO.getCategoryValueB");
	}
	
	@SuppressWarnings("unchecked")
	public List<CommunityCCategoryVO> getCategoryValueC(int tenantID) throws Exception {
		return (List<CommunityCCategoryVO>) list("EzCommunityDAO.getCategoryValueC");
	}
	
	@SuppressWarnings("unchecked")
	public List<CommunityBoardTreeVO> brdBoardTree(Map<String, Object> map) throws Exception {
		return (List<CommunityBoardTreeVO>) list("EzCommunityDAO.brdBoardTree", map);
	}

	@SuppressWarnings("unchecked")
	public List<CommunityBoardTreeVO> getBoardTreeGet2(Map<String, Object> map) throws Exception {
		return (List<CommunityBoardTreeVO>) list("EzCommunityDAO.getBoardTreeGet2", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<String> goAdminOkGet1(int tenantID) throws Exception {
		return (List<String>) list("EzCommunityDAO.goAdminOkGet1", tenantID);
	}
	
	@SuppressWarnings("unchecked")
	public List<CommunityClubVO> goAdminOkGet2(Map<String, Object> map) throws Exception {
		return (List<CommunityClubVO>) list("EzCommunityDAO.goAdminOkGet2", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<CommunityCBoardVO> bbsListGet2(Map<String, Object> map) throws Exception {
		return (List<CommunityCBoardVO>) list("EzCommunityDAO.bbsListGet2", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<CommunityCBoardVO> bbsViewNewGet2(Map<String, Object> map) throws Exception {
		return (List<CommunityCBoardVO>) list("EzCommunityDAO.bbsViewNewGet2", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<CommunityBoardInfoVO> copHomeBoardGet(Map<String, Object> map) throws Exception {
		return (List<CommunityBoardInfoVO>) list("EzCommunityDAO.copHomeBoardGet", map);
	}

	@SuppressWarnings("unchecked")
	public List<CommunityBoardItemVO> copHomeBoardItemGet(Map<String, Object> map) throws Exception {
		return (List<CommunityBoardItemVO>) list("EzCommunityDAO.copHomeBoardItemGet", map);
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
	public List<CommunityBoardItemAttachmentVO> getItemAttachmentXML(Map<String, Object> map) throws Exception {
		return (List<CommunityBoardItemAttachmentVO>) list("EzCommunityDAO.getItemAttachmentXML", map);
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
	public List<CommunityCPollManagerVO> pollMainGet2(Map<String, Object> map) throws Exception {
		return (List<CommunityCPollManagerVO>) list("EzCommunityDAO.pollMainGet2", map);
	}

	@SuppressWarnings("unchecked")
	public List<CommunityCPollQuestionVO> pollDeleteGet2(Map<String, Object> map) throws Exception {
		return (List<CommunityCPollQuestionVO>) list("EzCommunityDAO.pollDeleteGet2", map);
	}

	@SuppressWarnings("unchecked")
	public List<CommunityCPollAnswerVO> pollDeleteGet4(Map<String, Object> map) throws Exception {
		return (List<CommunityCPollAnswerVO>) list("EzCommunityDAO.pollDeleteGet4", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<CommunityCPollAnswerVO> pollResGet6(Map<String, Object> map) throws Exception {
		return (List<CommunityCPollAnswerVO>) list("EzCommunityDAO.pollResGet6", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<CommunityCPollResponseVO> pollETCTableGet(Map<String, Object> map) throws Exception {
		return (List<CommunityCPollResponseVO>) list("EzCommunityDAO.pollETCTableGet", map);
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
	public List<CommunityBoardItemAttachmentVO> copyItemGet2(Map<String, Object> map) {
		return (List<CommunityBoardItemAttachmentVO>) list("EzCommunityDAO.copyItemGet2", map);
	}

	@SuppressWarnings("unchecked")
	public List<String> myCommunityGet(Map<String, Object> map) throws Exception {
		return (List<String>) list("EzCommunityDAO.myCommunityGet", map);
	}

	@SuppressWarnings("unchecked")
	public List<CommunityMyCommunityVO> myCommunityItemGet(Map<String, Object> map) throws Exception {
		return (List<CommunityMyCommunityVO>) list("EzCommunityDAO.myCommunityItemGet", map);
	}

	@SuppressWarnings("unchecked")
	public List<CommunityMyCommunityVO> mainPageGet5(Map<String, Object> map) throws Exception {
		return (List<CommunityMyCommunityVO>) list("EzCommunityDAO.mainPageGet5", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<CommunityMyCommunityVO> mainPageGet6(Map<String, Object> map) throws Exception {
		return (List<CommunityMyCommunityVO>) list("EzCommunityDAO.mainPageGet6", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<CommunityCClubUserVO> adminMemberListGet3(Map<String, Object> map) throws Exception {
		return (List<CommunityCClubUserVO>) list("EzCommunityDAO.adminMemberListGet3", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<CommunityCCategoryVO> mainPageGet4(Map<String, Object> map) throws Exception {
		return (List<CommunityCCategoryVO>) list("EzCommunityDAO.mainPageGet4", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<CommunityClubVO> categoryListGet(Map<String, Object> map) throws Exception {
		return (List<CommunityClubVO>) list("EzCommunityDAO.categoryListGet", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<CommunityClubVO> searchCop(Map<String, Object> map) throws Exception {
		return (List<CommunityClubVO>) list("EzCommunityDAO.searchCop", map);
	}

	@SuppressWarnings("unchecked")
	public List<CommunityBoardItemVO> boardItemListPhotoGet2 (Map<String, Object> map) throws Exception {
		return (List<CommunityBoardItemVO>) list("EzCommunityDAO.boardItemListPhotoGet2", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<CommunityBoardItemVO> getAdjacentItemsGet2Pho(Map<String, Object> map) throws Exception {
		return (List<CommunityBoardItemVO>) list("EzCommunityDAO.getAdjacentItemsGet2Pho", map);
	}

	@SuppressWarnings("unchecked")
	public List<CommunityBoardItemVO> getAdjacentItemsGet3Pho(Map<String, Object> map) throws Exception {
		return (List<CommunityBoardItemVO>) list("EzCommunityDAO.getAdjacentItemsGet3Pho", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<String> getClubCHK(Map<String, Object> map) throws Exception {
		return (List<String>) select("EzCommunityDAO.getClubCHK", map);
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

	public CommunityBoardPropertyVO getBoardProperty(Map<String, Object> map) throws Exception{
		return (CommunityBoardPropertyVO) select("EzCommunityDAO.brdGetBoardProperty", map);
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
	
	public CommunityCPollManagerVO pollEditGet1(Map<String, Object> map) throws Exception {
		return (CommunityCPollManagerVO) select("EzCommunityDAO.pollEditGet1", map);
	}

	public CommunityCPollQuestionVO pollEditGet2(Map<String, Object> map) throws Exception {
		return (CommunityCPollQuestionVO) select("EzCommunityDAO.pollEditGet2", map);
	}
	
	public CommunityMemberInfoVO commViewMemberGet3(Map<String, Object> map) throws Exception {
		return (CommunityMemberInfoVO) select("EzCommunityDAO.commViewMemberGet3", map);
	}

	public CommunityMemberInfoVO commOutGet(Map<String, Object> map) throws Exception {
		return (CommunityMemberInfoVO) select("EzCommunityDAO.commOutGet", map);
	}
	
	public Integer commOutOkGet1(Map<String, Object> map) throws Exception {
		return (Integer) select("EzCommunityDAO.commOutOkGet1", map);
	}
	
	public CommunityCPollManagerVO pollResGet2(Map<String, Object> map) throws Exception {
		return (CommunityCPollManagerVO) select("EzCommunityDAO.pollResGet2", map);
	}

	public CommunityCPollQuestionVO pollResGet3(Map<String, Object> map) throws Exception {
		return (CommunityCPollQuestionVO) select("EzCommunityDAO.pollResGet3", map);
	}

	public CommunityCPollResponseVO pollResGet5(Map<String, Object> map) throws Exception {
		return (CommunityCPollResponseVO) select("EzCommunityDAO.pollResGet5", map);
	}
	
	public CommunityClubVO adminLeftGet(Map<String, Object> map) throws Exception {
		return (CommunityClubVO) select("EzCommunityDAO.adminLeftGet", map);
	}

	public CommunityClubVO ezCommunityBaseGet1(Map<String, Object> map) throws Exception {
		return (CommunityClubVO) select("EzCommunityDAO.ezCommunityBaseGet1", map);
	}

	public CommunityMemberInfoVO aspCommInfoGet2(Map<String, Object> map) throws Exception {
		return (CommunityMemberInfoVO) select("EzCommunityDAO.aspCommInfoGet2", map);
	}
	
	public CommunityClubVO leftCommunityGet4(Map<String, Object> map) throws Exception {
		return (CommunityClubVO) select("EzCommunityDAO.leftCommunityGet4", map);
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
	
	public CommunityCComCloseVO adminCommCloseOkGet1(Map<String, Object> map) throws Exception {
		return (CommunityCComCloseVO) select("EzCommunityDAO.adminCommCloseOkGet1", map);
	}

	public CommunityClubVO adminCommCloseOkGet2(Map<String, Object> map) throws Exception {
		return (CommunityClubVO) select("EzCommunityDAO.adminCommCloseOkGet2", map);
	}

	public CommunityClubVO adminNoticeMailOkGet1(Map<String, Object> map) throws Exception {
		return (CommunityClubVO) select("EzCommunityDAO.adminNoticeMailOkGet1", map);
	}

	public CommunityClubVO joinOkGet3(Map<String, Object> map) throws Exception {
		return (CommunityClubVO) select("EzCommunityDAO.joinOkGet3", map);
	}
	
	public CommunityMemberInfoVO joinOkGet4(Map<String, Object> map) throws Exception {
		return (CommunityMemberInfoVO) select("EzCommunityDAO.joinOkGet4", map);
	}
	
	public CommunityClubVO todayCopGet2List(Map<String, Object> map) throws Exception {
		return (CommunityClubVO) select("EzCommunityDAO.todayCopGet2List", map);
	}
	
	public CommunityCCategoryVO mainPageCategory(Map<String, Object> map) throws Exception {
		return (CommunityCCategoryVO) select("EzCommunityDAO.mainPageCategory", map);
	}
	
	public CommunityClubVO boardItemListPhotoGet1(Map<String, Object> map) throws Exception {
		return (CommunityClubVO) select("EzCommunityDAO.boardItemListPhotoGet1", map);
	}
	
	public CommunityCClubUserVO getCateDetailViewGet4(Map<String, Object> map) throws Exception {
		return (CommunityCClubUserVO) select("EzCommunityDAO.getCateDetailViewGet4", map);
	}
	
	public String todayCopGet2SelectUserID(Map<String, Object> map) throws Exception {
		return (String) select("EzCommunityDAO.todayCopGet2SelectUserID", map);
	}
	
	public String leftCommunityGet1(Map<String, Object> map) throws Exception {
		return (String) select("EzCommunityDAO.leftCommunityGet1", map);
	}

	public String leftCommunityGet2(Map<String, Object> map) throws Exception {
		return (String) select("EzCommunityDAO.leftCommunityGet2", map);
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
	
	public String bbsEditOkGet3(Map<String, Object> map) throws Exception{
		return (String) select("EzCommunityDAO.bbsEditOkGet3", map);
	}
	
	public String commMakeOkGet6(Map<String, Object> map) throws Exception{
		return (String) select("EzCommunityDAO.commMakeOkGet6", map);
	}
	
	public String commHomeGet1(Map<String, Object> map) throws Exception {
		return (String) select("EzCommunityDAO.commHomeGet1", map);
	}
	
	public String commHomeGet4(Map<String, Object> map) throws Exception {
		return (String) select("EzCommunityDAO.commHomeGet4", map);
	}
	
	public String getVersionInfo(Map<String, Object> map) throws Exception {
		return (String) select("EzCommunityDAO.getVersionInfo", map);
	}
	
	public String deleteItemGet(Map<String, Object> map) throws Exception {
		return (String) select("EzCommunityDAO.deleteItemGet", map);
	}
	
	public String checkReplyPassword(Map<String, Object> map) throws Exception {
		return (String) select("EzCommunityDAO.checkReplyPassword", map);
	}
	
	public String getACL(Map<String, Object> map) throws Exception{
		return (String) select("EzCommunityDAO.getACL", map);
	}
	
	public String pollMainGet1(Map<String, Object> map) throws Exception {
		return (String) select("EzCommunityDAO.pollMainGet1", map);
	}

	public String pollMainGet3(Map<String, Object> map) throws Exception {
		return (String) select("EzCommunityDAO.pollMainGet3", map);
	}

	public String pollAddOkGoGet2(Map<String, Object> map) throws Exception {
		return (String) select("EzcommunityDAO.pollAddOkGoGet2", map);
	}

	public String pollAddOkGoGet3(Map<String, Object> map) throws Exception {
		return (String) select("EzCommunityDAO.pollAddOkGoGet3", map);
	}

	public String pollDeleteGet1(Map<String, Object> map) throws Exception {
		return (String) select("EzCommunityDAO.pollDeleteGet1", map);
	}
	
	public String pollDeleteGet3(Map<String, Object> map) throws Exception {
		return (String) select("EzCommunityDAO.pollDeleteGet3", map);
	}
	
	public String pollResGet4(Map<String, Object> map) throws Exception {
		return (String) select("EzCommunityDAO.pollResGet4", map);
	}
	
	public String adminMemberListGet2(Map<String, Object> map) throws Exception {
		return (String) select("EzCommunityDAO.adminMemberListGet2", map);
	}
	
	public String ezCommunityBaseGet3(Map<String, Object> map) throws Exception {
		return (String) select("EzCommunityDAO.ezCommunityBaseGet3", map);
	}
	
	public String adminBasicGet1(Map<String, Object> map) throws Exception {
		return (String) select("EzCommunityDAO.adminBasicGet1", map);
	}
	
	public String adminBasicGet2(Map<String, Object> map) throws Exception {
		return (String) select("EzCommunityDAO.adminBasicGet2", map);
	}

	public String checkPassword(Map<String, Object> map) throws Exception {
		return (String) select("EzCommunityDAO.checkPassword", map);
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
	
	public String getACLGet1(Map<String, Object> map) throws Exception {
		return (String) select("EzCommunityDAO.getACLGet1", map);
	}

	public String getACLGet2(Map<String, Object> map) throws Exception {
		return (String) select("EzCommunityDAO.getACLGet2", map);
	}
	
	public String setAsReadSelectBoardID(Map<String, Object> map) throws Exception {
		return (String)select("EzCommunityDAO.setAsReadSelectBoardID", map);
	}
	
	public Integer todayCopGet2SelectTotalCount(Map<String, Object> map) throws Exception {
		return (Integer) select("EzCommunityDAO.todayCopGet2SelectTotalCount", map);
	}
	
	public Integer todayCopGet2SelectTemp(Map<String, Object> map) throws Exception {
		return (Integer) select("EzCommunityDAO.todayCopGet2SelectTemp", map);
	}
	
	public Integer brdCheckIfBoardGroupAdmin(Map<String, Object> map) throws Exception {
		return (Integer) select("EzCommunityDAO.brdCheckIfBoardGroupAdmin", map);
	}
		
	public Integer bbsEditOkGet2(Map<String, Object> map) throws Exception{
		return (Integer) select("EzCommunityDAO.bbsEditOkGet2", map);
	}
		
	public Integer commMakeOkGet3(int tenantID) throws Exception {
		return (Integer) select("EzCommunityDAO.commMakeOkGet3", tenantID);
	}
		
	public Integer getBoardTotalItemCount(Map<String, Object> map) throws Exception {
		return (Integer) select("EzCommunityDAO.getBoardTotalItemCount", map);
	}
	
	public Integer searchItemCount(Map<String, Object> map) throws Exception {
		return (Integer) select("EzCommunityDAO.searchItemCount", map);
	}
	
	public Integer adminSearchItemCount(Map<String, Object> map) throws Exception {
		return (Integer) select("EzCommunityDAO.adminSearchItemCount", map);
	}
	
	public Integer brdNewItemCount(Map<String, Object> map) throws Exception {
		return (Integer) select("EzCommunityDAO.brdNewItemCount", map);
	}
	
	public Integer checkIfHasReply(Map<String, Object> map) throws Exception {
		return (Integer) select("EzCommunityDAO.checkIfHasReply", map);
	}
	
	public Integer getReservedItemListCount(Map<String, Object> map) throws Exception {
		return (Integer) select("EzCommunityDAO.getReservedItemListCount", map);
	}

	public Integer deleteOneLineReplySelect(Map<String, Object> map) throws Exception {
		return (Integer) select("EzCommunityDAO.deleteOneLineReplySelect", map);
	}
	
	public Integer guestOneGet1(Map<String, Object> map) throws Exception {
		return (Integer) select("EzCommunityDAO.guestOneGet1", map);
	}

	public Integer pollMainGet4(Map<String, Object> map) throws Exception {
		return (Integer) select("EzCommunityDAO.pollMainGet4", map);
	}

	public Integer pollAddOkGoGet1(Map<String, Object> map) throws Exception {
		return (Integer) select("EzCommunityDAO.pollAddOkGoGet1", map);
	}
	
	public Integer pollResGet1(Map<String, Object> map) throws Exception {
		return (Integer) select("EzCommunityDAO.pollResGet1", map);
	}
	
	public Integer pollETCViewGet(Map<String, Object> map) throws Exception {
		return (Integer) select("EzCommunityDAO.pollETCViewGet", map);
	}
	
	public Integer commViewMemberGet2(Map<String, Object> map) throws Exception {
		return (Integer) select("EzCommunityDAO.commViewMemberGet2", map);
	}
	
	public Integer adminMemPermitGet1(Map<String, Object> map) throws Exception {
		return (Integer) select("EzCommunityDAO.adminMemPermitGet1", map);
	}
	
	public Integer todayCopGet1(int tenantID) throws Exception {
		return (Integer) select("EzCommunityDAO.todayCopGet1", tenantID);
	}
	
	public String todayCopGet3(Map<String, Object> map) throws Exception {
		return (String) select("EzCommunityDAO.todayCopGet3", map);
	}

	public Integer categoryListItemCntGet(Map<String, Object> map) throws Exception {
		return (Integer) select("EzCommunityDAO.categoryListItemCntGet", map);
	}
	
	public Integer pollResGetAllCount(Map<String, Object> map) throws Exception {
		return (Integer) select("EzCommunityDAO.pollResGetAllCount", map);
	}

	public Integer pollResGetCount(Map<String, Object> map) throws Exception {
		return (Integer) select("EzCommunityDAO.pollResGetCount", map);
	}
	
	public Integer adminOuterListGet1(Map<String, Object> map) throws Exception {
		return (Integer) select("EzCommunityDAO.adminOuterListGet1", map);
	}
	
	public Integer checkIfLeafBoardGet(Map<String, Object> map) throws Exception {
		return (Integer) select("EzCommunityDAO.checkIfLeafBoardGet", map);
	}
	
	public Integer bbsListGet1(Map<String, Object> map) throws Exception {
		return (Integer) select("EzCommunityDAO.bbsListGet1", map);
	}
	
	public Integer commMakeOkGet2(int tenantID) throws Exception {
		return (Integer) select("EzCommunityDAO.commMakeOkGet2", tenantID);
	}

	public Integer commMakeOkGet4(int tenantID) throws Exception {
		return (Integer) select("EzCommunityDAO.commMakeOkGet4", tenantID);
	}

	public Integer commHomeGet2(Map<String, Object> map) throws Exception {
		return (Integer) select("EzCommunityDAO.commHomeGet2", map);
	}
	
	public Integer checkOneLineOwner(Map<String, Object> map) throws Exception {
		return (Integer) select("EzCommunityDAO.checkOneLineOwner", map);
	}
	
	public Integer boardPropertyGet(Map<String, Object> map) throws Exception {
		return (Integer) select("EzCommunityDAO.boardPropertyGet", map);
	}
	
	public Integer adminMemberListGet1(Map<String, Object> map) throws Exception {
		return (Integer) select("EzCommunityDAO.adminMemberListGet1", map);
	}

	public Integer adminMemberListOkGetE(Map<String, Object> map) throws Exception {
		return (Integer) select("EzCommunityDAO.adminMemberListOkGetE", map);
	}
	
	public Integer brdNewItemSelect(int tenantID) throws Exception {
		return (Integer) select("EzCommunityDAO.brdNewItemSelect", tenantID);
	}
	
	public Integer createBoardGroupSelect(int tenantID) throws Exception {
		return (Integer) select("EzCommunityDAO.createBoardGroupSelect", tenantID);
	}
	
	public Integer createBoardInsertSelect(int tenantID) throws Exception {
		return (Integer) select("EzCommunityDAO.createBoardInsertSelect", tenantID);
	}
	
	public Integer pollResOkSetSelect(Map<String, Object> map) throws Exception {
		return (Integer)select("EzCommunityDAO.pollResOkSetSelect", map);
	}
	
	public Integer commMakeOkSet2Select(Map<String, Object> map) throws Exception {
		return (Integer) select("EzCommunityDAO.commMAkeOkSet2Select", map);
	}
	
	public Integer setAsReadSelectTemp(Map<String, Object> map) throws Exception {
		return (Integer)select("EzCommunityDAO.setAsReadSelectTemp", map);
	}
	
	public Integer guestEditOkUpdateSelect(Map<String, Object> map) throws Exception {
		return (Integer) select("EzCommunityDAO.guestEditOkUpdateSelect", map);
	}

	public void bbsEditOkInsert(Map<String, Object> map) throws Exception{
		insert("EzCommunityDAO.bbsEditOkInsert", map);
	}

	public void commMakeOkInsert1(int tenantID) throws Exception {
		insert("EzCommunityDAO.commMakeOkInsert1", tenantID);	
	}
	
	public void insertClub(Map<String, Object> map) throws Exception {
		insert("EzCommunityDAO.insertClub", map);
	}
	
	public void insertCommBoardInfo(Map<String, Object> map) throws Exception {
		insert("EzCommunityDAO.insertCommBoardInfo", map);
	}
	
	public void insertCommBoardManage(Map<String, Object> map) throws Exception {
		insert("EzCommunityDAO.insertCommBoardManage", map);
	}
	
	public void insertClubUser(Map<String, Object> map) throws Exception {
		insert("EzCommunityDAO.insertClubUser", map);
	}

	public void joinOkInsert(Map<String, Object> map) throws Exception {
		insert("EzCommunityDAO.joinOkInsert", map);
	}
	
	public void deleteItem4(Map<String, Object> map) throws Exception {
		insert("EzCommunityDAO.deleteItem4", map);
	}
	
	public void brdNewItemInsert(Map<String, Object> map) throws Exception {
		insert("EzCommunityDAO.brdNewItemInsert", map);
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

	public void createBoardGroupInsert1(Map<String, Object> map) throws Exception {
		insert("EzCommunityDAO.createBoardGroupInsert1", map);
	}
	
	public void createBoardGroupInsert2(Map<String, Object> map) throws Exception {
		insert("EzCommunityDAO.createBoardGroupInsert2", map);
	}
	
	public void createBoardGroupInsert3(Map<String, Object> map) throws Exception {
		insert("EzCommunityDAO.createBoardGroupInsert3", map);
	}
	
	public void createBoardInsertInsert1(Map<String, Object> map) throws Exception {
		insert("EzCommunityDAO.createBoardInsertInsert1", map);
	}
	
	public void createBoardInsertInsert2(Map<String, Object> map) throws Exception {
		insert("EzCommunityDAO.createBoardInsertInsert2", map);
	}
	
	public void createBoardInsertInsert3(Map<String, Object> map) throws Exception {
		insert("EzCommunityDAO.createBoardInsertInsert3", map);
	}
	
	public void createBoardInsertDelete(int tenantID) throws Exception {
		delete("EzCommunityDAO.createBoardInsertDelete", tenantID);
	}
	
	public void pollResOkSetInsert(Map<String, Object> map) throws Exception {
		insert("EzCommunityDAO.pollResOkSetInsert", map);
	}
	
	public void pollResOkSetUpdate(Map<String, Object> map) throws Exception {
		insert("EzCommunityDAO.pollResOkSetUpdate", map);
	}
	
	public void adminCommCloseOkInsert(Map<String, Object> map) throws Exception {
		insert("EzCommunityDAO.adminCommCloseOkInsert", map);
	}
	
	public void commMakeOkSet1Insert(Map<String, Object> map) throws Exception {
		insert("EzCommunityDAO.commMakeOkSet1Insert", map);
	}
	
	public void commMakeOkSet2Insert(Map<String, Object> map) throws Exception {
		insert("EzCommunityDAO.commMAkeOkSet2Insert", map);
	}
	
	public void setAsReadInsert(Map<String, Object> map) throws Exception {
		insert("EzCommunityDAO.setAsReadInsert", map);
	}
	
	public void joinOkSet1Insert(Map<String, Object> map) throws Exception {
		insert("EzCommunityDAO.joinOkSet1Insert", map);
	}
	
	public void updateClubID(Map<String, Object> map) throws Exception {
		update("EzCommunityDAO.updateClubID", map);
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

	public void commMakeOkSet1Update(Map<String, Object> map) throws Exception {
		update("EzCommunityDAO.commMakeOkSet1Update", map);
	}
	
	public void commMakeOkSet2Update(Map<String, Object> map) throws Exception {
		update("EzCommunityDAO.commMAkeOkSet2Update", map);
	}
	
	public void commMakeOkSet2Update1(Map<String, Object> map) throws Exception {
		update("EzCommunityDAO.commMAkeOkSet2Update1", map);
	}
	
	public void updateLastDate(Map<String, Object> map) throws Exception {
		update("EzCommunityDAO.updateLastDate", map);
	}
	
	public void setAsReadUpdate(Map<String, Object> map) throws Exception {
		update("EzCommunityDAO.setAsReadUpdate", map);
	}
	
	public void brdUpdateItemUpdate(Map<String, Object> map) throws Exception {
		update("EzCommunityDAO.brdUpdateItemUpdate", map);
	}
	
	public void guestEditOkUpdateUpdate(Map<String, Object> map) throws Exception {
		update("EzCommunityDAO.guestEditOkUpdateUpdate", map);
	}

	public void pollEditOkUpdateManager(Map<String, Object> map) throws Exception {
		update("EzCommunityDAO.pollEditOkUpdateManager", map);
	}
	
	public void pollEditOkUpdateQuestion(Map<String, Object> map) throws Exception {
		update("EzCommunityDAO.pollEditOkUpdateQuestion", map);
	}
	
	public void adminLogoOkUpdate1(Map<String, Object> map) throws Exception {
		update("EzCommunityDAO.adminLogoOkUpdate1", map);
	}

	public void adminCommType(Map<String, Object> map) throws Exception {
		update("EzCommunityDAO.adminCommType", map);
	}

	//TODO 미사용
	/*public void adminLoGoOkUpdate2(Map<String, Object> map) throws Exception {
		update("EzCommunityDAO.adminLogoOkUpdate2", map);
	}*/

	public void adminHomeBoardSet(Map<String, Object> map) throws Exception {
		update("EzCommunityDAO.adminHomeBoardSet", map);
	}

	public void saveBoardOrder(Map<String, Object> map) throws Exception {
		update("EzCommunityDAO.saveBoardOrder", map);
	}
	
	public void adminBasicOkupdate(Map<String, Object> map) throws Exception {
		update("EzCommunityDAO.adminBasicOkUpdate", map);
	}
	
	public void moveBoardUpdate1(Map<String, Object> map) throws Exception {
		update("EzCommunityDAO.moveBoardUpdate1", map);
	}
	
	public void moveBoardUpdate2(Map<String, Object> map) throws Exception {
		update("EzCommunityDAO.moveBoardUpdate2", map);
	}
	
	public void adminOuterOkNoSetUpdate(Map<String, Object> map) throws Exception {
		update("EzCommunityDAO.adminOuterOkNoSetUpdate", map);	
	}

	public void adminMemberListGoSEUpdate1(Map<String, Object> map) throws Exception {
		update("EzCommunityDAO.adminMemberListGoSEUpdate1", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<String> adminMemberListGoSESelect(Map<String, Object> map) throws Exception {
		return (List<String>) list("EzCommunityDAO.adminMemberListGoSESelect", map);
	}
	
	public void adminMemberListGoSEUpdate2(Map<String, Object> map) throws Exception {
		update("EzCommunityDAO.adminMemberListGoSEUpdate2", map);
	}
	
	public void adminMemberListGoSEDelete1(Map<String, Object> map) throws Exception {
		delete("EzCommunityDAO.adminMemberListGoSEDelete1", map);
	}
	
	public void adminMemberListGoSEUpdate3(Map<String, Object> map) throws Exception {
		update("EzCommunityDAO.adminMemberListGoSEUpdate3", map);
	}
	
	public void adminMemberListGoSEDelete2(Map<String, Object> map) throws Exception {
		delete("EzCommunityDAO.adminMemberListGoSEDelete2", map);
	}

	public void brdSaveBoardPropertyUpdate1(Map<String, Object> map) {
		update("EzCommunityDAO.brdSaveBoardPropertyUpdate1", map);
	}
	
	public void brdSaveBoardPropertyUpdate2(Map<String, Object> map) {
		update("EzCommunityDAO.brdSaveBoardPropertyUpdate2", map);
	}
	
	public void copyUpdate(Map<String, Object> map) throws Exception {
		update("EzCommunityDAO.copyUpdate", map);
	}
	
	public void bbsViewNewUpdate(Map<String, Object> map) throws Exception {
		update("EzCommunityDAO.bbsViewNewUpdate", map);
	}

	public void joinOkSet1Update(Map<String, Object> map) throws Exception {
		update("EzCommunityDAO.joinOkSet1Update", map);
	}
	
	public void joinOkUpdate1(Map<String, Object> map) throws Exception {
		update("EzCommunityDAO.joinOkUpdate1", map);
	}

	public void joinOkUpdate2(Map<String, Object> map) throws Exception {
		update("EzCommunityDAO.joinOkUpdate2", map);
	}
	
	public void joinOkUpdate3(Map<String, Object> map) throws Exception {
		update("EzCommunityDAO.joinOkUpdate3", map);
	}
	
	public void okNoSetUpdate1(Map<String, Object> map) throws Exception {
		update("EzCommunityDAO.okNoSetUpdate1", map);
	}
	
	public void okNoSetUpdate2(Map<String, Object> map) throws Exception {
		update("EzCommunityDAO.okNoSetUpdate2", map);
	}
	
	public void deleteOneLineReplyDelete(Map<String, Object> map) throws Exception {
		delete("EzCommunityDAO.deleteOneLineReplyDelete", map);
	}
	
	public void brdUpdateItemDelete(Map<String, Object> map) throws Exception {
		delete("EzCommunityDAO.brdUpdateItemDelete", map);
	}
	
	public void newItemDel(Map<String, Object> map) throws Exception {
		delete("EzCommunityDAO.newItemDel", map);
	}
	
	public void adminOuterOkNoSetDelete1(Map<String, Object> map) throws Exception {
		delete("EzCommunityDAO.adminOuterOkNoSetDelete1", map);	
	}
	
	public void adminOuterOkNoSetDelete2(Map<String, Object> map) throws Exception {
		delete("EzCommunityDAO.adminOuterOkNoSetDelete2", map);	
	}
	
	public void okNoSetDelete(Map<String, Object> map) throws Exception {
		delete("EzCommunityDAO.okNoSetDelete", map);
	}
	
	public void guestEditOkDelete(Map<String, Object> map) throws Exception {
		delete("EzCommunityDAO.guestEditOkDelete", map);
	}
	
	public void deleteBoardTreeChache(Map<String, Object> map) throws Exception {
		delete("EzCommunityDAO.deleteBoardTreeChache", map);
	}
	
	public void insertBoardTreeChache(Map<String, Object> map) throws Exception {
		delete("EzCommunityDAO.insertBoardTreeChache", map);
	}

	public void bbsDelOkDel(Map<String, Object> map) throws Exception {
		delete("EzCommunityDAO.bbsDelOkDel", map);
	}

	public void deleteItem1(Map<String, Object> map) throws Exception {
		delete("EzCommunityDAO.deleteItem1", map);
	}
	
	public void deleteItem2(Map<String, Object> map) throws Exception {
		delete("EzCommunityDAO.deleteItem2", map);
	}
	
	public void deleteItem3(Map<String, Object> map) throws Exception {
		delete("EzCommunityDAO.deleteItem3", map);
	}
	
	public void deleteItem5(Map<String, Object> map) throws Exception {
		delete("EzCommunityDAO.deleteItem5", map);
	}
	
	public void pollDeleteDel1(Map<String, Object> map) throws Exception {
		delete("EzCommunityDAO.pollDeleteDel1", map);
	}

	public void pollDeleteDel2(Map<String, Object> map) throws Exception {
		delete("EzCommunityDAO.pollDeleteDel2", map);
	}

	public void pollDeleteDel3(Map<String, Object> map) throws Exception {
		delete("EzCommunityDAO.pollDeleteDel3", map);
	}
	
	public void pollDeleteDel4(Map<String, Object> map) throws Exception {
		delete("EzCommunityDAO.pollDeleteDel4", map);
	}

	public void deleteBoard(int tenantID) throws Exception {
		delete("EzCommunityDAO.deleteBoard", tenantID);
	}

	public void brdDeleteBoardDelete1(Map<String, Object> map) throws Exception {
		delete("EzCommunityDAO.brdDeleteBoardDelete1", map);
	}
	
	public void brdDeleteBoardDelete2(Map<String, Object> map) throws Exception {
		delete("EzCommunityDAO.brdDeleteBoardDelete2", map);
	}
	
	public void brdDeleteBoardDelete3(Map<String, Object> map) throws Exception {
		delete("EzCommunityDAO.brdDeleteBoardDelete3", map);
	}
	
	public void brdDeleteBoardInsert(Map<String, Object> map) throws Exception {
		delete("EzCommunityDAO.brdDeleteBoardInsert", map);
	}


}
