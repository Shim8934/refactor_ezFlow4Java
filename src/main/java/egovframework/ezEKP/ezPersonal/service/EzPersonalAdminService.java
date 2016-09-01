package egovframework.ezEKP.ezPersonal.service;

import java.util.List;

import egovframework.ezEKP.ezPersonal.vo.PersonalNoticeVO;

public interface EzPersonalAdminService {

	List<PersonalNoticeVO> getNoticeList(String companyID, int totalCount, int pageSize, int pStart) throws Exception;
	
	PersonalNoticeVO getNoticeInfo(String itemSeq) throws Exception;
	
	String deleteNotice(String itemSeq) throws Exception;
	
	String insertNotice(String companyID, String title, String title2, String content) throws Exception;
	
	String updateNotice(String companyID, String title, String title2, String content, Integer itemSeq) throws Exception;
	
	String getQuickLinkList() throws Exception;
	
	String getQuickLink(String quickLinkID) throws Exception;
	
	String getQuickLinkACL(String quickLinkID) throws Exception;
	
	int getNoticeCount(String companyID) throws Exception;

	

	

}
