package egovframework.ezEKP.ezWebFolder.service;

import java.util.List;

import egovframework.ezEKP.ezWebFolder.vo.FolderFileVO;

public interface EzWebFolderService_m {

	List<FolderFileVO> getShares (String companyId, String deptId, String userId, String startDate, String endDate, String fileExt, String fileName, String createName, String pageSize, String pageNum, String fileType, int tenantId, String type) throws Exception;
	
	public int getShareSeq(int tenantId) throws Exception;
	
	public void insertShare(int seqId, String companyId, String userId, String userType, String folderFileId, String folderFileType, String createId, int tenantId) throws Exception;
	
	public void delShare(String companyId, String folderFileId, String folderFileType, String createId, int tenantId) throws Exception;
	
}
