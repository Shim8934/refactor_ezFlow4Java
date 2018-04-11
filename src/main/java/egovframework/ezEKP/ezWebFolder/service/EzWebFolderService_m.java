package egovframework.ezEKP.ezWebFolder.service;

import java.util.List;
import java.util.Map;

import egovframework.ezEKP.ezWebFolder.vo.ShareVO;

public interface EzWebFolderService_m {

	public List<ShareVO> getSharingList(String userId, String primary, String offset, int startPoint, int pageSize, int tenantId) throws Exception;
	
	public List<ShareVO> getSharedList(String userId, String  deptId, String compId, String primary, String offset, int startPoint, int pageSize, int tenantId) throws Exception;
	
	public Map<String, Integer> getSharingCount(String userId, String primary, String offset, int pageSize, int tenantId) throws Exception;
	
	public Map<String, Integer> getSharedCount(String userId, String deptId, String compId, String primary, String offset, int pageSize, int tenantId) throws Exception;
	
	public int getShareSeq(int tenantId) throws Exception;
	
	public void insertShare(int seqId, String companyId, String userId, String userType, String folderFileId, String folderFileType, String createId, int tenantId) throws Exception;
	
	public void delShare(String companyId, String folderFileId, String folderFileType, String createId, int tenantId) throws Exception;
	
}
