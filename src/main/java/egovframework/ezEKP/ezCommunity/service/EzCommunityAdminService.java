package egovframework.ezEKP.ezCommunity.service;

import java.util.List;

import egovframework.ezEKP.ezCommunity.vo.CommunityCComCloseVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityClubVO;


public interface EzCommunityAdminService {

	List<CommunityCComCloseVO> aspCloseGet1(String keyword, String sRadio, String s, String lang, String sort1, String sort2) throws Exception;
	
	List<CommunityClubVO> aspAdmitComGet1(String keyword, String sRadio, String s, String multiData, String sort1, String sort2) throws Exception;
	
	List<CommunityClubVO> aspSearchKeyGet1(String lang, int iQueryCount, String select, String query) throws Exception;
	
	CommunityClubVO admCommunityInfoEdit(String lang, String code) throws Exception;
	
	String aspCloseComGet2(String keyword, String sRadio) throws Exception;

	String communityCloseCom(List<CommunityCComCloseVO> clubList, int curPage, int comNoPerPage) throws Exception;

	String aspCommInfoGet3(String code) throws Exception;
	
	String aspCommInfoGet4(String code) throws Exception;
	
	String aspAdmitComGet2(String keyword, String sRadio) throws Exception;

	String admitCom(List<CommunityClubVO> clubList, int curPage, int comNoPerPage) throws Exception;
	
	String getUserName(String id) throws Exception;

	Integer aspSearchKeyGet2(String lang, String select, String query) throws Exception ;
	
	void commCloseAll(String code) throws Exception;

	void aspCommAdmitOkSet1(String code, String lang) throws Exception;

	void aspCommAdmitOkSet2(String code, String lang, String useEzKMS, String comName) throws Exception;

	void admCommunityInfoEditOk(String lang, String cCateA, String cCateB, String cCateC, String clubName, String code) throws Exception;

	

	

}
