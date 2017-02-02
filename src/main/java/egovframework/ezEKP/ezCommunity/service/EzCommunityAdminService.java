package egovframework.ezEKP.ezCommunity.service;

import java.util.HashMap;
import java.util.List;
import java.util.Locale;

import egovframework.ezEKP.ezCommunity.vo.CommunityCComCloseVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityClubVO;
import egovframework.let.user.login.vo.LoginVO;


public interface EzCommunityAdminService {

	List<CommunityCComCloseVO> aspCloseComGet1(String keyword, String sRadio, String s, String lang, String sort1, String sort2, int tenantID) throws Exception;
	
	List<CommunityClubVO> aspAdmitComGet1(String keyword, String sRadio, String s, String multiData, String sort1, String sort2, int tenantID) throws Exception;
	
	List<CommunityClubVO> aspSearchKeyGet1(String lang, int iQueryCount, String select, String query, int tenantID) throws Exception;
	
	CommunityClubVO admCommunityInfoEdit(String lang, String code, int tenantID) throws Exception;
	
	int aspCloseComGet2(String keyword, String sRadio, int tenantID) throws Exception;

	String communityCloseCom(List<CommunityCComCloseVO> clubList, int curPage, int comNoPerPage, LoginVO userInfo) throws Exception;

	String aspCommInfoGet3(String code, int tenantID) throws Exception;
	
	String aspCommInfoGet4(String code, int tenantID) throws Exception;
	
	int aspAdmitComGet2(String keyword, String sRadio, int tenantID) throws Exception;

	String admitCom(List<CommunityClubVO> clubList, int curPage, int comNoPerPage) throws Exception;
	
	String getUserName(String id, int tenantID) throws Exception;

	int aspSearchKeyGet2(String lang, String select, String query, int tenantID) throws Exception ;
	
	void commCloseAll(String code, Locale locale, int tenantID) throws Exception;

	List<HashMap<String, Object>> aspCommAdmitOkSet1(String code, String lang, int tenantID) throws Exception;

	List<HashMap<String, Object>> aspCommAdmitOkSet2(String code, String lang, String useEzKMS, String comName, int tenantID) throws Exception;

	String admCommunityInfoEditOk(String lang, String cCateA, String cCateB, String cCateC, String clubName, String code, int tenantID) throws Exception;
	
	void createCommunityAdmitSendMail(String loginCookie, LoginVO userInfo, List<HashMap<String, Object>> recipientList, boolean isAdmit) throws Exception;
}
