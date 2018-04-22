package egovframework.ezEKP.ezWebFolder.service;

import java.util.List;
import java.util.Map;

import org.json.simple.JSONObject;

import egovframework.ezEKP.ezWebFolder.vo.FavoriteFileVO;
import egovframework.ezEKP.ezWebFolder.vo.FolderVO;
import egovframework.ezEKP.ezWebFolder.vo.SearchVO;
import egovframework.ezEKP.ezWebFolder.vo.ShareVO;
import egovframework.ezEKP.ezWebFolder.vo.TrashCanVO;
import egovframework.let.user.login.vo.LoginVO;

public interface EzWebFolderService_m {

	public void insertIfNotExistRootForder(String userId, String userName1, String userName2, String compId, List<Map<String, String>> permissionIdList, String offset, int tenantId) throws Exception;
	
	public List<Map<String, Object>> getFolderTree(String userId, String deptId, String compId, String folderType, String primary, int tenantId) throws Exception;
	
	public List<ShareVO> getSharingList(String userId, String primary, String offset, int startPoint, int pageSize, SearchVO searchInfo, int tenantId) throws Exception;
	
	public List<ShareVO> getSharedList(String userId, String  deptId, String compId, String primary, String offset, int startPoint, int pageSize, SearchVO searchInfo, int tenantId) throws Exception;
	
	public Map<String, Integer> getSharingCount(String userId, String primary, String offset, int pageSize, SearchVO searchInfo, int tenantId) throws Exception;
	
	public Map<String, Integer> getSharedCount(String userId, String deptId, String compId, String primary, String offset, int pageSize, SearchVO searchInfo, int tenantId) throws Exception;
	
	public List<Map<String, String>> getPermissionIdList(String userId, String deptId, String compId, int tenantId) throws Exception;
	
	public boolean isShared(String folderFileId, String folderFileType, String folderPath, int tenantId) throws Exception;
	
	public void insertShare(String sharerId, String folderFileId, String folderFileType, List<Map<String, String>> userList, String offset, int tenantId) throws Exception;
	
	public void updateShare(String sharerId, String folderFileId, String folderFileType, List<Map<String, String>> userList, String offset, int tenantId) throws Exception;
	
	public void deleteShare(String sharerId, String folderFileId, String folderFileType, String offset, int tenantId) throws Exception;
	
	public void hideShare(String userId, String folderFileId, String folderFileType, String offset, int tenantId) throws Exception;

	public void showShare(String userId, String folderFileId, String folderFileType, String offset, int tenantId) throws Exception;
	
	int getShareSeq(int tenantId) throws Exception;
	
	public JSONObject getTrashCanList(String userId, String offset, int tenantId, int pStart, int pEnd, String searchExt, String searchFileName, String searchFileType, String searchCreateName, String endrollStartDate, String endrollEndDate, String delStartDate, String delEndDate) throws Exception;

	public String getFolderPath(String folderId, int tenantId) throws Exception;

	public void permanetDeleteSelectedFiles(String[] fileIDList,String[] folderIDList ,LoginVO userInfo, String realPath) throws Exception;

	public void realFileDelete(String fileName, String realPath, LoginVO userInfo) throws Exception;
	
	public void realFileDeleteInFolder(String folderPath, String comPanyId ,String realPath, LoginVO userInfo, String offset, int tenantId) throws Exception;

	public void deleteFile(String fileId, int tenantId) throws Exception;

	public void deleteFolder(FolderVO folderVO) throws Exception;

	public void deleteAllFilesInFolder(FolderVO folderVO) throws Exception;

	public List<TrashCanVO> getFileByFolderId(String folderId, int tenantId, String userId) throws Exception;

	public List<TrashCanVO> getFolderByFolderPath(String folderPath, int tenantId, String companyId) throws Exception;
	
	List<FavoriteFileVO> getFavorites(String userId, String offset, int tenantId, SearchVO searchInfo, int startIndex, int listCount) throws Exception;
	
	Map<String, Integer> getFavoriteCount(String userId, String offset, int tenantId, SearchVO searchInfo) throws Exception;
	
	boolean isExistsFavorite(String userId, String targetId, String targetType, int tenantId) throws Exception;
	
	void addFavorite(String userId, String targetId, String targetType, String createDate, int tenantId) throws Exception;
	
	void deleteFavorite(String userId, String targetId, String targetType, int tenantId) throws Exception;
	
	public void restoreFile (String fileId, int tenantId, String userId, String timeUTC) throws Exception;

	public void restoreFolder (String folderPath, int tenantId, String userId, String companyId, String timeUTC) throws Exception;
	
	public void restoreTrashCan (String[] fileIDList, String[] folderIDList, int tenantId, String userId, String offset, String companyId, String timeUTC) throws Exception;
	
	public void restoreFileInFolder(String folderPath, int tenantId, String userId, String timeUTC) throws Exception;

	public void moveTrashCan(String[] fileIDList, String[] folderIDList,String folderId, int tenantId, String userId, String offset, String companyId, String userName1, String userName2, String timeUTC) throws Exception;

	void moveFolder(FolderVO folderVO, FolderVO destFoldeVO, String userId, String offset, int tenantId, String timeUTC) throws Exception;

	void movSubFolders(String userId, String folderType, String oldPath, String newPath, String timeUTC, String ownerId, int levelDistance, int tenantId) throws Exception;
}