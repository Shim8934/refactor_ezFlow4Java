package egovframework.ezEKP.ezPersonal.service;

import java.util.List;

import org.w3c.dom.Document;

import egovframework.ezEKP.ezPersonal.vo.PersonalLightPollVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalNoticeVO;
import egovframework.let.user.login.vo.LoginVO;

public interface EzPersonalAdminService {

	List<PersonalNoticeVO> getNoticeList(String companyID, int totalCount, int pageSize, int pStart) throws Exception;
	
	PersonalNoticeVO getNoticeInfo(String itemSeq) throws Exception;
	
	List<PersonalLightPollVO> getPollList(String companyID, int totalCount, int pageSize, int start) throws Exception;
	
	String deleteNotice(String itemSeq) throws Exception;
	
	String insertNotice(String companyID, String title, String title2, String content) throws Exception;
	
	String updateNotice(String companyID, String title, String title2, String content, Integer itemSeq) throws Exception;
	
	String getQuickLinkList() throws Exception;
	
	String getQuickLink(String quickLinkID) throws Exception;
	
	String getQuickLinkACL(String quickLinkID) throws Exception;
	
	String insertPoll(Document doc) throws Exception;
	
	String deletePoll(String itemSeq) throws Exception;
	
	int getNoticeCount(String companyID) throws Exception;

	int getPollCount(String companyID) throws Exception;

	void saveQuickLink(LoginVO userInfo, Document doc) throws Exception;

}
