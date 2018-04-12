package egovframework.ezEKP.ezWebFolder.service;

import java.util.List;
import java.util.Map;

import org.json.simple.JSONObject;

import egovframework.ezEKP.ezWebFolder.vo.FolderVO;
import egovframework.ezEKP.ezWebFolder.vo.TrashCanVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.ezEKP.ezWebFolder.vo.ShareVO;

public interface EzWebFolderService_m {

	public List<ShareVO> getSharingList(String userId, String primary, String offset, int startPoint, int pageSize, int tenantId) throws Exception;
	
	public List<ShareVO> getSharedList(String userId, String  deptId, String compId, String primary, String offset, int startPoint, int pageSize, int tenantId) throws Exception;
	
	public Map<String, Integer> getSharingCount(String userId, String primary, String offset, int pageSize, int tenantId) throws Exception;
	
	public Map<String, Integer> getSharedCount(String userId, String deptId, String compId, String primary, String offset, int pageSize, int tenantId) throws Exception;
	
	public int getShareSeq(int tenantId) throws Exception;
	
	public void insertShare(int seqId, String companyId, String userId, String userType, String folderFileId, String folderFileType, String createId, int tenantId) throws Exception;
	
	public void delShare(String companyId, String folderFileId, String folderFileType, String createId, int tenantId) throws Exception;
	
	public JSONObject getTrashCanList(String userId, String offset, int tenantId) throws Exception;
	
	public List<TrashCanVO> getFolderList (String userId, String offset, int tenantId) throws Exception;

	public List<TrashCanVO> getFileList (String userId, String offset, int tenantId) throws Exception;

	public String getFolderPath (String folderId, int tenantId) throws Exception;

	public void permanetDeleteSelectedFiles (String[] fileIDList, LoginVO userInfo, String realPath) throws Exception;

	public void realFileDelete(String fileName, String realPath, LoginVO userInfo) throws Exception;
	
	public void realFileDeleteInFolder (String folderPath, String comPanyId ,String realPath, LoginVO userInfo, String offset, int tenantId) throws Exception;
	
	public void updateFileUseStatus (String fileId, int tenantId) throws Exception;
	
	public void updateFolderUseStatus (FolderVO folderVO) throws Exception;
	
	public void updateStatusAllFilesInFolder (FolderVO folderVO) throws Exception;
	
	public List<TrashCanVO> getFileByFolderId (String folderId, int tenantId, String userId) throws Exception;

	public List<TrashCanVO> getFolderByFolderPath (String folderPath, int tenantId, String companyId) throws Exception;
}
