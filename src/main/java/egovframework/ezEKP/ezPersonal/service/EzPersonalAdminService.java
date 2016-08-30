package egovframework.ezEKP.ezPersonal.service;

public interface EzPersonalAdminService {

	int getNoticeCount(String companyID) throws Exception;

	String getNoticeList(String companyID, int totalCount, int pageSize, int pStart) throws Exception;

}
