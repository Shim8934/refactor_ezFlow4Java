package egovframework.ezEKP.ezWebFolder.service;

import java.util.List;
import egovframework.ezEKP.ezWebFolder.vo.FileTypeVO;
import egovframework.ezEKP.ezWebFolder.vo.FileVO;
import egovframework.ezEKP.ezWebFolder.vo.FolderSimpleVO;
import egovframework.ezEKP.ezWebFolder.vo.FolderUserVO;
import egovframework.ezEKP.ezWebFolder.vo.FolderVO;

public interface EzWebFolderService {
	String getFileSequence(int tenantId) throws Exception;
	void insertFile(FileVO fileVO) throws Exception;
	FileVO getFileByFileId(String fileId, String offset, int tenantId) throws Exception;
	FileTypeVO getFileTypeByFileExt(String extend, int tenantId) throws Exception;
	void deleteFileByFileId(String fileId, int tenantId) throws Exception;
	void updateFileUseStatus(String fileId, int tenantId) throws Exception;
	void updateFileName(String fileId, String newName, int tenantId) throws Exception;
	void moveFile(String fileId, String folderId, int tenantId) throws Exception;
	String getFileLogSequence(int tenantId) throws Exception;
	FolderVO getFolderByFolderId(String folderId, String offset, int tenantId) throws Exception;
	FolderSimpleVO getSimpleFolder(String folderId, String primary, int tenantId) throws Exception;
	List<FolderSimpleVO> getAllSimpleSubFolders(String folderUpperId, String primary, int tenantId) throws Exception;
	FolderVO getCompanyFolderId(String companyId, String offset, int tenantId) throws Exception;
	void getAllSubDepts(FolderSimpleVO company, String primary, int tenantId, int i) throws Exception;
	void getAllSubDepts(FolderSimpleVO company, String primary, int tenantId, String[] fdPath, int order) throws Exception;
	void updateDownCnt(String fileId, int tenantId) throws Exception;
	List<FolderUserVO> getFolderUsers(String folderId, int tenantId) throws Exception;
	String getFolderSequence(int tenantId) throws Exception;
	String getMaxFolderStep(String folderId, int tenantId) throws Exception;
	String getFolderUserSequence(int tenantId) throws Exception;
	void updateFolderUseStatus(String folderId, int tenantId) throws Exception;
	List<FileVO> getAllFilesInFolder(String folderId, String originalPath, String searchChk, String startDate, String endDate, String fileExt, String fileName, String userName, String fileType, int startPoint, int pageSize, String primary, String offset, int tenantId) throws Exception;
	List<FileVO> getAllFiles(String folderPath, String originalPath, String searchChk, String startDate, String endDate, String fileExt, String fileName, String userName, String fileType, int startPoint, int pageSize, String primary, String offset, int tenantId) throws Exception;
	int getTotalFileCnt(String folderId, String searchChk, String startDate, String endDate, String fileExt, String fileName, String userName, String fileType, int startPoint, int pageSize, String primary, int tenantId) throws Exception;
	int getTotalFileCnt2(String folderPath, String searchChk, String startDate, String endDate, String fileExt, String fileName, String userName, String fileType, int startPoint, int pageSize, String primary, int tenantId) throws Exception;
	List<FolderVO> getAllSubFolders(String folderId, String offset, int tenantId) throws Exception;
}