package egovframework.ezEKP.ezWebFolder.service;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

import egovframework.ezEKP.ezOrgan.vo.OrganDeptVO;
import egovframework.ezEKP.ezWebFolder.vo.DuplicateInfoVO;
import egovframework.ezEKP.ezWebFolder.vo.FileHistoryVO;
import egovframework.ezEKP.ezWebFolder.vo.FileUploadVO;
import egovframework.ezEKP.ezWebFolder.vo.FileTypeVO;
import egovframework.ezEKP.ezWebFolder.vo.FileVO;
import egovframework.ezEKP.ezWebFolder.vo.FolderSimpleVO;
import egovframework.ezEKP.ezWebFolder.vo.FolderUserVO;
import egovframework.ezEKP.ezWebFolder.vo.FolderVO;
import egovframework.ezEKP.ezWebFolder.vo.SimpleDeptVO;
import egovframework.ezEKP.ezWebFolder.vo.SimpleUserVO;
import egovframework.ezEKP.ezWebFolder.vo.WebfolderEnvVO;
import egovframework.ezEKP.ezWebFolder.vo.result.UploadResult;
import egovframework.let.user.login.vo.LoginVO;

public interface EzWebFolderService {
	String getFileSequence(int tenantId) throws Exception;
	int insertFile(FileVO fileVO) throws Exception;
	void insertFileUser(FileVO fileVO, String seqId, String userId, String userType, String comId) throws Exception;
	FileVO getFileByFileId(String fileId, String offset, int tenantId) throws Exception;
	void deleteFileByFileId(String fileId, int tenantId) throws Exception;
	void updateFileUseStatus(String userId, String fileId, String timeUTC, int tenantId) throws Exception;
	void updateFileName(String fileId, String newName, String timeUTC, int tenantId) throws Exception;
	void moveFile(String fileId, String folderId, int tenantId) throws Exception;
	void moveRenameFile(String fileId, String folderId, String newFileName, int tenantId) throws Exception;
	String getFileLogSequence(int tenantId) throws Exception;
	FolderVO getFolderByFolderId(String folderId, String offset, int tenantId) throws Exception;
	FolderSimpleVO getSimpleFolder(String folderId, int tenantId) throws Exception;
	List<FolderSimpleVO> getAllSimpleSubFolders(String folderUpperId, int tenantId, List<String> idList) throws Exception;
	FolderVO getRootFolderId(String companyId, String type, String offset, int tenantId) throws Exception;
	void getAllSubDepts(FolderSimpleVO company, int tenantId, int i) throws Exception;
	void getAllSubDepts(FolderSimpleVO company, int tenantId, int i, List<String> idList) throws Exception;
	void getAllSubDepts(FolderSimpleVO company, int tenantId, String[] fdPath, int order) throws Exception;
	void updateDownCnt(String fileId, int tenantId) throws Exception;
	List<FolderUserVO> getFolderUsers(String folderId, int tenantId) throws Exception;
	List<FolderUserVO> getFileUsers(String fileId, int tenantId) throws Exception;
	String getFolderSequence(int tenantId) throws Exception;
	String getMaxFolderStep(String folderId, int tenantId) throws Exception;
	String getFolderUserSequence(int tenantId, String type) throws Exception;
	void updateFolderUseStatus(FolderVO folder, LoginVO userInfo) throws Exception;
//	List<FileVO> getDuplicateNameFiles(List<String> fileNames, String parentFolderId, String offset, int tenantId) throws Exception;
//	List<FolderVO> getDuplicateNameFolders(List<String> folderNames, String parentFolderId, String offset, int tenantId) throws Exception;
	List<DuplicateInfoVO> getAllDuplicateInfo(String fileName, String targetFolderId, String offset, int tenantId) throws Exception;
	List<DuplicateInfoVO> getAllDuplicateInfo(DuplicateInfoVO.Type originElementType, String originElementId, String targetFolderId, String offset, int tenantId) throws Exception;
	List<DuplicateInfoVO> getAllDuplicateInfoForRename(DuplicateInfoVO.Type originElementType, String originElementId, String newName, String targetFolderId, String offset, int tenantId) throws Exception;
	List<FileVO> getAllFilesInFolder(String sqlCode, String order, String folderId, String originalPath, String searchChk, 
			String startDate, String endDate, String fileExt, String fileName, String userName, String fileType, int startPoint, 
			int pageSize, String primary, String offset, int tenantId, String sortType, String sortColumn) throws Exception;
	List<FileVO> getAllFiles(String sqlCode, String order, String folderPath, String originalPath, String searchChk, 
			String startDate, String endDate, String fileExt, String fileName, String userName, String fileType, 
			int startPoint, int pageSize, String primary, String offset, int tenantId, String sortType, String SortColumn) throws Exception;
	int getTotalFileCnt(String folderId, String searchChk, String startDate, String endDate, String fileExt, String fileName, String userName, String fileType, String primary, int tenantId) throws Exception;
	int getTotalFileCnt2(String folderPath, String searchChk, String startDate, String endDate, String fileExt, String fileName, String userName, String fileType, String primary, int tenantId) throws Exception;
	List<FolderVO> getAllSubFolders(String folderId, String offset, int tenantId) throws Exception;
	SimpleDeptVO getAllDepts(String companyId, int level, String primary, int tenantId) throws Exception;
	SimpleDeptVO getSimpleCompany(String deptId, int level, String primary, int tenantId) throws Exception;
	void getAllDepts(SimpleDeptVO sDept, String[] path, String primary, int tenantId, int order, int level, String adminOrgan) throws Exception;
	String getDeptPath(String deptId, int tenantId) throws Exception;
	List<SimpleUserVO> getDeptMemberList(String deptId, String primary, int tenantId, String adminOrgan) throws Exception;
	List<FolderSimpleVO> getAllSimpleDeptFolder(String companyId, LoginVO userInfo) throws Exception;
	List<OrganDeptVO> getAllDepartments(String companyId, String primary, int tenantId) throws Exception;
	List<FolderSimpleVO> getDeptFolderTreeForUser(String userId, String deptID, int tenantId) throws Exception;
	FolderSimpleVO getCompanySimpleFolder(String companyID, LoginVO userInfo) throws Exception;
	List<FolderSimpleVO> getCompanySubSimpleFolder(String userId, String deptId, String compFolderId, String compId, int tenantId, List<String> idList) throws Exception;
	FolderSimpleVO getUserSimpleFolder(String userId, int tenantId) throws Exception;
	boolean checkDepartChief(String userId, int tenantId) throws Exception;
	WebfolderEnvVO getListCount(String userId, int tenantId) throws Exception;
	void updateListCount(String userId, String listCount, int tenantId) throws Exception;
	List<SimpleDeptVO> getAllDeptsForChief(String userId, int level, String primary, int tenantId) throws Exception;
	List<SimpleDeptVO> getSelectedDeptsForChief(String userId, int level, String primary, int tenantId) throws Exception;
	int checkFilesOwner(String userId, String fileList, int tenantId) throws Exception;
	//Added
	String getFolderPath(String[] split, String primary, int tenantId) throws Exception;
	UploadResult saveUploadedFiles(List<FileUploadVO> multiFileLists, JSONArray nameArray, FolderVO folder, String realPath, LoginVO userInfo, boolean isEncrypt, String parentId) throws Exception;
	void getDownloadedFiles(String[] folderIdList, String[] fileIDList, String realPath, LoginVO userInfo, String userAgent, HttpServletRequest request, HttpServletResponse response) throws Exception;
	// 휴지통 용량 초과 하는지 체크
	boolean canDelete(String[] fileIdList, String[] folderIdList, String userId, int tenantId) throws Exception;
	void deleteSelectedFiles(String[] fileIDList, LoginVO userInfo) throws Exception;
	// 예연추가 delete시 선택된 파일, 폴더 함께 삭제 
	String deleteSelectedFilesFolders (String[] fileIDList, String[] folderIDList ,LoginVO userInfo) throws Exception ;
	void saveLog(String string, String companyId, String offset, String userId, String userName1, String userName2, String fileName, long fileSize, String fileExt, String fileTypeName, int tenantId) throws Exception;
	void saveLog(String string, String companyId, String offset, String userId, String userName1, String userName2, int tenantId, FileVO fileVO, String version, String primary) throws Exception;
	String getMaxFileID(int tenantId) throws Exception;
	JSONObject moveFiles(String folderId, String fileList, String mode, String privileges, LoginVO userInfo, boolean isOverwritable) throws Exception;
	JSONObject moveFiles(String folderId, String fileList, List<String> nameList, String mode, String privileges, LoginVO userInfo, boolean isOverwritable) throws Exception;
	JSONObject moveFolders(String folderList, String destFolderId, String mode, String privileges, LoginVO userInfo) throws Exception;
	Map<String, String> getAllFolderNameMap(List<String> testbnk, String primary, int tenantId);
	List<String> getFolderListFromFileId(List<String> fileIds, int tenantId) throws Exception;
	String getWebFolderDirPath(int tenantId);
	double getTotalFilesSize(String fileList, int tenantId) throws Exception;
	List<FolderSimpleVO> getAllSimpleShareFolder(String userId, String deptId, String compId, int tenantId) throws Exception;
	void updateFileExt(String fileId, String oldFilePath, String fileExt,String realFileExt, String timeUTC, int tenantId) throws Exception;
	FileTypeVO getFileTypeByFileExt(String string, int tenantId) throws Exception;

	void insertEncryptionFolder(String folderId, int tenantId);

	void deleteEncryptionFolder(String folderId, int tenantId);

	void insertEncryptedFile(String fileId, int tenantId);

	void deleteEncryptedLatestVersion(String fileId, int tenantId);

	void deleteEncryptedAllVersions(String fileId, int tenantId);

	void deleteEncryptedVersion(String fileId, int version, int tenantId);

	FolderVO getEncryptionRootFolder(String folderId, int tenantId);

	boolean isEncryptionFolder(String folderId, int tenantId);

	boolean isEncryptedFile(String fileId, int tenantId);

	boolean isEncryptedVersion(String fileId, int version, int tenantId);

	boolean isEncryptedFilePath(String filePath);

	List<FileHistoryVO> getFileHistories(String fileId, String offset, int tenantId) throws Exception;

	FileHistoryVO getFileHistory(String fileId, int version, String offset, int tenantId) throws Exception;

	void incrementFileVersion(LoginVO user, String fileId) throws Exception;

	void incrementFileVersion(LoginVO user, String fileId, boolean isdel) throws Exception;

	void revertFileVersion(LoginVO user, String fileId, int version) throws Exception;

	boolean restoreFileVersionFromTrash(LoginVO user, String fileId, int version) throws Exception;

	void deleteFileVersion(LoginVO user, String fileId, int version) throws Exception;

	void deletePermanetlyFileHistory(String fileId, int version, int tenantId, LoginVO userInfo) throws Exception;

	void deletePermanetlyFileHistories(String fileId, int tenantId);

	void getDownloadedVersions(String fileId, int[] versions, LoginVO user, String userAgent, HttpServletRequest request, HttpServletResponse response) throws Exception;

	public String getStringListOfWebFolderMembers(int tenantId, String webFolderId) throws Exception;

	boolean containsReplyFile(String fileId, int tenantId);

	List<String> getContainsReplyFiles(String folderId, int tenantId);

	List<String> getContainsReplyFiles(List<String> fileIds, int tenantId);

	int checkFileUserExists(String userId, String fileId);
	
	int checkFolderUserExists(String userId, String folderId, Boolean manager);

	List<String> getNotInheritFolders(int tenantId);

	boolean isNotInheritFolder(String folderId, int tenantId);

	boolean containsNotInheritFolder(String[] fileIds, String[] folderIds, int tenantId) throws Exception;

	void insertNotInheritFolder(String folderId, int tenantId);

	void deleteNotInheritFolder(String folderId, int tenantId);
}