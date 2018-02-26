package egovframework.ezEKP.ezWebFolder.service;

import java.util.List;
import java.util.Map;

import egovframework.ezEKP.ezWebFolder.vo.FileVO;
import egovframework.ezEKP.ezWebFolder.vo.FolderVO;

public interface EzWebFolderService_y {
	// park yeyeun start
	// 파일 list
	List<FileVO> getFileList(String folderId,String folderType, int tenantId, String companyId, String searchExt,
			String searchFileName, String searchStartDate, String searchEndDate,String searchCreateName,
			String searchFileType, String searchPageCount,String searchListCount, int pStart , int pEnd ) throws Exception;
	/*
	
	// 폴더 세부 정보 
	List<FolderVO> getFolderListDetail (String folderId, String folderType, String userId, String tenantId, String companyId ) throws Exception;
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
	// 폴더 생성
	String insertFolder (String folderUppId, String folderType ,String tenantId, String companyId)throws Exception;

	int getFileToTalCount(String folderId,String folderType, int tenantId, String parameter,
			String searchExt, String searchFileName, String searchStartDate,
			String searchEndDate, String searchCreateName,
			String searchFileType, String searchPageCount,
			String searchListCount, int pStart, int pEnd) throws Exception;

	// 폴더 전체 리스트 
	List<Map<String, Object>> getFolderList( String admin , String userId,String deptId, String comId, String folderId,
			String folderType, int tenantId) throws Exception;
	
	// folder insert위한 폴서 세부 정보 folderDetail
	FolderVO getFolderDetail(String folderUppId, String folderType, int tenantId ,String comId); 
	
	
}
