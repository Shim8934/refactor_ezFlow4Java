package egovframework.ezEKP.ezWebFolder.service;

import java.util.List;

import org.json.simple.JSONObject;

import egovframework.ezEKP.ezWebFolder.vo.FolderFileVO;
import egovframework.ezEKP.ezWebFolder.vo.FolderVO;
import egovframework.ezEKP.ezWebFolder.vo.TrashCanVO;
import egovframework.let.user.login.vo.LoginVO;

public interface EzWebFolderService_m {

	List<FolderFileVO> getShares (String companyId, String deptId, String userId, String startDate, String endDate, String fileExt, String fileName, String createName, String pageSize, String pageNum, String fileType, int tenantId, String type) throws Exception;
	
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
