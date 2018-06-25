package egovframework.ezEKP.ezCommunity.service;

import java.util.HashMap;
import java.util.List;
import java.util.Locale;

import egovframework.ezEKP.ezCommunity.vo.CommunityCComCloseVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityClubVO;
import egovframework.let.user.login.vo.LoginVO;


public interface EzCommunityAdminService {

	/* 2018-06-21 홍승비 - 관리자 > 폐쇄승인 커뮤니티 표출(리스트) */
	List<CommunityCComCloseVO> aspCloseComGet1(String keyword, String sRadio, String s, String lang, String sort1, String sort2, String companyID, int tenantID) throws Exception;
	
	/* 2018-06-21 홍승비 - 관리자 > 커뮤니티 신청승인 표출(리스트) */
	List<CommunityClubVO> aspAdmitComGet1(String keyword, String sRadio, String s, String multiData, String sort1, String sort2, String companyID, int tenantID) throws Exception;
	
	/* 관리자 > 커뮤니티검색화면 표출(하단 리스트) 시 companyID 조건 추가 */
	List<CommunityClubVO> aspSearchKeyGet1(String lang, int iQueryCount, String select, String query, String companyID, int tenantID) throws Exception;
	
	CommunityClubVO admCommunityInfoEdit(String lang, String code, int tenantID) throws Exception;
	
	/* 관리자 > 커뮤니티 폐쇄승인 표출(총 n개 카운트) 시 companyID 조건 추가 */
	int aspCloseComGet2(String keyword, String sRadio, String companyID, int tenantID) throws Exception;

	String communityCloseCom(List<CommunityCComCloseVO> clubList, int curPage, int comNoPerPage, LoginVO userInfo) throws Exception;

	String aspCommInfoGet3(String code, int tenantID) throws Exception;
	
	String aspCommInfoGet4(String code, int tenantID) throws Exception;
	
	/* 2018-06-21 홍승비 - 관리자 > 커뮤니티 신청승인 표출(총 n개 카운트) */
	int aspAdmitComGet2(String keyword, String sRadio, String companyID, int tenantID) throws Exception;

	String admitCom(List<CommunityClubVO> clubList, int curPage, int comNoPerPage) throws Exception;
	
	/* 2018-06-21 홍승비 - 관리자 > 커뮤니티 겸직하는 userID 가져올때 companyID로 조건 추가 */
	String getUserName(String id, String primary, String companyID, int tenantID) throws Exception;

	/* 관리자 > 커뮤니티검색화면 표출(총 n개 keywordCount) 시 companyID 조건 추가 */
	int aspSearchKeyGet2(String lang, String select, String query, String companyID, int tenantID) throws Exception ;
	
	void commCloseAll(String code, Locale locale, int tenantID) throws Exception;

	List<HashMap<String, Object>> aspCommAdmitOkSet1(String code, String lang, int tenantID) throws Exception;

	List<HashMap<String, Object>> aspCommAdmitOkSet2(String code, String lang, String useEzKMS, String comName, int tenantID) throws Exception;

	String admCommunityInfoEditOk(String lang, String cCateA, String cCateB, String cCateC, String clubName, String code, int tenantID) throws Exception;
	
	void createCommunityAdmitSendMail(String loginCookie, LoginVO userInfo, List<HashMap<String, Object>> recipientList, boolean isAdmit) throws Exception;
}
