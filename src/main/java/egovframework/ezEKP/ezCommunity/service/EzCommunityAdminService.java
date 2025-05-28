package egovframework.ezEKP.ezCommunity.service;

import java.util.HashMap;
import java.util.List;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;

import egovframework.ezEKP.ezCommunity.vo.CommunityCBoardVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityCComCloseVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityClubVO;
import egovframework.let.user.login.vo.LoginVO;


public interface EzCommunityAdminService {

	/* 2020-01-06 홍승비 - 폐쇄사유 검색옵션 추가 */
	/* 2018-06-21 홍승비 - 관리자 > 폐쇄승인 커뮤니티 표출(리스트) */
	List<CommunityCComCloseVO> aspCloseComGet1(String searchValue, String searchType, String searchType2, String lang, int pageNum, String offSetMin, String companyID, int tenantID) throws Exception;
	
	/* 2020-01-06 홍승비 - 커뮤니티소개 검색옵션 추가 */
	/* 2018-06-21 홍승비 - 관리자 > 커뮤니티 신청승인 표출(리스트) */
	List<CommunityClubVO> aspAdmitComGet1(String searchValue, String searchType, String searchType2, String multiData, int pageNum, String offSetMin, String companyID, int tenantID) throws Exception;
	
	/* 2020-01-03 홍승비 - 커뮤니티 검색 시 커뮤니티소개 검색옵션 다시 추가 */
	/* 관리자 > 커뮤니티검색화면 표출(하단 리스트) 시 companyID 조건 추가 */
	List<CommunityClubVO> aspSearchKeyGet1(String lang, int pageNum, String searchType, String searchType2, String searchValue, String offSetMin, String companyID, int tenantID) throws Exception;
	
	CommunityClubVO admCommunityInfoEdit(String lang, String code, int tenantID) throws Exception;
	
	/* 2020-01-06 홍승비 - 폐쇄사유 검색옵션 추가 */
	/* 관리자 > 커뮤니티 폐쇄승인 표출(총 n개 카운트) 시 companyID 조건 추가 */
	int aspCloseComGet2(String searchValue, String searchType, String searchType2, String multiData, String companyID, int tenantID) throws Exception;

	String communityCloseCom(List<CommunityCComCloseVO> clubList, int curPage, int comNoPerPage, LoginVO userInfo) throws Exception;

	String aspCommInfoGet3(String code, int tenantID) throws Exception;
	
	String aspCommInfoGet4(String code, int tenantID) throws Exception;
	
	/* 2020-01-06 홍승비 - 커뮤니티소개 검색옵션 추가 */
	/* 2018-06-21 홍승비 - 관리자 > 커뮤니티 신청승인 표출(총 n개 카운트) */
	int aspAdmitComGet2(String searchValue, String searchType, String searchType2, String multiData, String companyID, int tenantID) throws Exception;

	String admitCom(List<CommunityClubVO> clubList, int curPage, int comNoPerPage) throws Exception;
	
	/* 2018-06-21 홍승비 - 관리자 > 커뮤니티 겸직하는 userID 가져올때 companyID로 조건 추가 */
	String getUserName(String id, String primary, String companyID, int tenantID) throws Exception;

	/* 2020-01-03 홍승비 - 커뮤니티 검색 시 커뮤니티소개 검색옵션 다시 추가 */
	/* 관리자 > 커뮤니티검색화면 표출(총 n개 keywordCount) 시 companyID 조건 추가 */
	int aspSearchKeyGet2(String lang, String searchType, String searchType2, String searchValue, String companyID, int tenantID) throws Exception ;
	
	void commCloseAll(String code, Locale locale, int tenantID) throws Exception;

	List<HashMap<String, Object>> aspCommAdmitOkSet1(String code, String lang, int tenantID) throws Exception;

	List<HashMap<String, Object>> aspCommAdmitOkSet2(String code, String lang, String useEzKMS, String comName, int tenantID) throws Exception;

	String admCommunityInfoEditOk(String lang, String cCateA, String cCateB, String cCateC, String clubName, String clubDesc, String code, int tenantID) throws Exception;
	
	void createCommunityAdmitSendMail(HttpServletRequest request, String loginCookie, LoginVO userInfo, List<HashMap<String, Object>> recipientList, boolean isAdmit) throws Exception;

	String adminBbsList(LoginVO userInfo, List<CommunityCBoardVO> cBoardList, String code, int curPage, String bName, int comNoPerPage) throws Exception;

	/* 2020-01-06 홍승비 - 폐쇄한 커뮤니티 검색 시 폐쇄사유 추가 */
	int getClosedCommuListCount(String multiData, Locale locale, String searchType2, String searchValue, String companyId, int tenantId) throws Exception;

	/* 2020-01-06 홍승비 - 폐쇄한 커뮤니티 검색 시 폐쇄사유 추가 */
	List<CommunityCComCloseVO> getClosedCommuList(String primary, Locale locale, int pageNum, String searchType2, String searchValue, String offSetMin, String companyId, int tenantId) throws Exception;

	CommunityCComCloseVO closeCommunityInfo(String multiData, String code, String offSetMin, String companyId, int tenantId) throws Exception;

	void adminCommCloseAll(String code, String reason, Locale locale, int tenantId) throws Exception;
	
	void aspCommCloseAllDel(String code, int tenantID) throws Exception;
}
