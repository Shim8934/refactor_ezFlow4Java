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
	FolderSimpleVO getSimpleFolder(String folderId, int tenantId) throws Exception;
	List<FolderSimpleVO> getAllSimpleSubFolders(String folderUpperId, int tenantId) throws Exception;
	FolderVO getCompanyFolderId(String companyId, String offset, int tenantId) throws Exception;
	void getAllSubDepts(FolderSimpleVO company, int tenantId, int i) throws Exception;
	
	
	// park yeyeun start
	// 파일 list
	List<FileVO> getFileList(String folderId, int tenantId, String companyId, String searchExt,
			String searchFileName, String searchStartDate, String searchEndDate,String searchCreateName,
			String searchFileType, String searchPageCount,String searchListCount ) throws Exception;
	/*
	// 폴더 전체 리스트 
	List<FolderVO> getFolderLsit (String folderType , String userId, String companyId , String tenantId) throws Exception; 
	// 폴더 세부 정보 
	List<FolderVO> getFolderListDetail (String folderId, String folderType, String userId, String tenantId, String companyId ) throws Exception;
	// 폴더 생성
	String insertFolder (FolderVO foldervo ,String tenantId, String companyId)throws Exception;
	// 폴더 수정
	String updateFolder (String folderId, String folderName, String userId, String companyId) throws Exception;
	// 폴더 이동
	String moveFolder (String folderId, String parentId, String tenantId, String companyId) throws Exception;
	// 폴더 복사 
	String copyFolder (String folderId, String parentId, String tenantId, String companyId) throws Exception;
	// 폴더 삭제 
	String deleteFolder (String folderId, String tenantId, String companyId ) throws Exception;
	
	// part yeyeun end
	*/
}
