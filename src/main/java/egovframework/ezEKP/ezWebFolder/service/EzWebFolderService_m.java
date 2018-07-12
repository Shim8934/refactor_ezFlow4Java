package egovframework.ezEKP.ezWebFolder.service;

import java.util.List;
import java.util.Map;

import org.json.simple.JSONObject;

import egovframework.ezEKP.ezWebFolder.vo.FavoriteVO;
import egovframework.ezEKP.ezWebFolder.vo.FileVO;
import egovframework.ezEKP.ezWebFolder.vo.FolderVO;
import egovframework.ezEKP.ezWebFolder.vo.SearchVO;
import egovframework.ezEKP.ezWebFolder.vo.ShareVO;
import egovframework.ezEKP.ezWebFolder.vo.SimpleShareVO;
import egovframework.ezEKP.ezWebFolder.vo.TrashCanVO;
import egovframework.let.user.login.vo.LoginVO;

public interface EzWebFolderService_m {

	List<ShareVO> getSharingList(String subSearchFlag, String userId, String primary, String offset, int startPoint, int pageSize, SearchVO searchInfo, int tenantId) throws Exception;
	
	List<ShareVO> getSharedList(String isSubSearching, String userId, String  deptId, String compId, String primary, String offset, int startPoint, int pageSize, SearchVO searchInfo, int tenantId) throws Exception;
	
	Map<String, Long> getSharingCount(String subSearchFlag, String userId, String primary, String offset, int pageSize, SearchVO searchInfo, int tenantId) throws Exception;
	
	Map<String, Long> getSharedCount(String subSearchFlag, String userId, String deptId, String compId, String primary, String offset, int pageSize, SearchVO searchInfo, int tenantId) throws Exception;
	
	List<SimpleShareVO> getShareInfo(String sharerId, String folderFileId, String folderFileType, String primary, String offset, int tenantId) throws Exception;
	
	List<Map<String, String>> getPermissionIdMapList(String userId, String deptId, String compId, int tenantId) throws Exception;
	
	List<String> getPermissionIdList(String userId, String deptId, String compId, int tenantId) throws Exception;
	
	String checkShared(String folderFileId, String folderFileType, String folderPath, int tenantId) throws Exception;
	
	void insertShare(String sharerId, String folderFileId, String folderFileType, String deptListStr, String userListStr, String offset, int tenantId) throws Exception;
	
	void updateShare(String folderFileId, String folderFileType, String sharerId, String deptListStr, String userListStr, String offset, int tenantId) throws Exception;
	
	void deleteShare(String folderFileId, String folderFileType, String sharerId, int tenantId) throws Exception;
	
	void deleteShareWithSub(String folderFileId, String folderFileType, int tenantId) throws Exception;
	
	List<ShareVO> getHiddenSharedList(String userId, String deptId, String compId, String primary, String offset, int startPoint, int pageSize, int tenantId) throws Exception;

	Map<String, Long> getHiddenSharedCount(String userId, String deptId, String compId, String primary, String offset, int pageSize, int tenantId) throws Exception;
	
	void hideShare(String folderFileId, String folderFileType, String userId, String deptId, String compId, String offset, int tenantId) throws Exception;

	void showShare(String folderFileId, String folderFileType, String userId, String deptId, String compId, String offset, int tenantId) throws Exception;
	
	JSONObject getTrashCanList(String realColmn, String order, String userId, String offset, int tenantId, int pStart, int pEnd, String searchExt, String searchFileName, String searchFileType, String searchCreateName, String enrollStartDate, String enrollEndDate, String delStartDate, String delEndDate, String mode) throws Exception;

	String getFolderPath(String folderId, int tenantId) throws Exception;

	void permanetDeleteSelectedFiles(String[] fileIDList,String[] folderIDList ,LoginVO userInfo, String realPath) throws Exception;

	int realFileDelete(FileVO fileVO, String realPath, LoginVO userInfo, String userName1, String userName2) throws Exception;
	
	int deleteFile(String fileId, int tenantId) throws Exception;

	int deleteFolder(FolderVO folderVO) throws Exception;
	
	void deleteAllFilesInFolder(FolderVO folderVO, String companyId ,String realPath, LoginVO userInfo, String offset, int tenantId, String userId, String userName1, String userName2) throws Exception;

	List<TrashCanVO> getFileByFolderId(String folderId, int tenantId, String userId) throws Exception;

	List<TrashCanVO> getFolderByFolderPath(String folderPath, int tenantId, String companyId) throws Exception;
	
	List<FavoriteVO> getFavorites(String userId, String primary, String offset, int tenantId, SearchVO searchInfo, int startIndex, int listCount) throws Exception;
	
	/**
	 * @return key : value<br>
	 *         "totalCount" : 합산 개수<br>
	 *         "folderCount" : 폴더 개수<br>
	 *         "fileCount" : 파일 개수<br>
	 **/
	Map<String, Long> getFavoritesCount(String userId, String primary, String offset, int tenantId, SearchVO searchInfo) throws Exception;
	
	boolean isExistsFavorite(String userId, String targetId, String targetType, int tenantId) throws Exception;
	
	void addFavorite(String userId, String targetId, String targetType, String createDate, int tenantId) throws Exception;
	
	int deleteFavorite(String userId, String targetId, String targetType, int tenantId) throws Exception;
	
	int deleteFavoriteAnyUser(String targetId, String targetType, int tenantId) throws Exception;
	
	/** 
	 * @return 해당 폴더를 포함한 하위 항목의 모든 즐겨찾기를 삭제
	 **/
	int deleteFavoritesInFolder(String folderId, int tenantId) throws Exception;
	
	int restoreFile (FileVO fileVO, int tenantId, String userId, String timeUTC, String companyId, String offset, String userName1, String userName2) throws Exception;
	
	int restoreFolder (String folderId, int tenantId, String userId, String timeUTC) throws Exception;
	
	int restoreTrashCan (String[] fileIDList, String[] folderIDList, int tenantId, String userId, String offset, String companyId, String timeUTC, String userName1, String userName2) throws Exception;
	
	int restoreFileInFolder (String folderId, int tenantId, String userId, String timeUTC, String companyId, String offset, String userName1, String userName2) throws Exception;

	void moveTrashCan (String[] fileIDList, String[] folderIDList,String folderId, int tenantId, String userId, String offset, String companyId, String userName1, String userName2, String timeUTC) throws Exception;

	void moveFolder (FolderVO folderVO, FolderVO destFoldeVO, String userId, String offset, int tenantId, String timeUTC) throws Exception;

	void moveFile (String fileId, String folderId, int tenantId, String timeUTC) throws Exception;

	List<String> getAllFolderIdNotInFolder(String folderPath, String folderId) throws Exception;
}
