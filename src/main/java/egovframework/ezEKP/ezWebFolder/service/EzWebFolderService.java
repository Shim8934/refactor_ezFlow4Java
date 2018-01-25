package egovframework.ezEKP.ezWebFolder.service;

import java.util.List;

import egovframework.ezEKP.ezWebFolder.vo.FileTypeVO;
import egovframework.ezEKP.ezWebFolder.vo.FileVO;
import egovframework.ezEKP.ezWebFolder.vo.FolderSimpleVO;
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
	FolderSimpleVO getSimpleSubFolder(String folderId, int tenantId) throws Exception;
	List<FolderSimpleVO> getAllSimpleSubFolders(String folderUpperId, int tenantId) throws Exception;
}
