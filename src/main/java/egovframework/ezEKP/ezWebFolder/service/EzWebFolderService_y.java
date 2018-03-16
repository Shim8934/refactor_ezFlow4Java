package egovframework.ezEKP.ezWebFolder.service;

import java.util.List;
import java.util.Map;

import egovframework.ezEKP.ezWebFolder.vo.FileVO;
import egovframework.ezEKP.ezWebFolder.vo.FolderVO;
import egovframework.let.user.login.vo.LoginVO;

public interface EzWebFolderService_y {
	// 파일 list
	List<FileVO> getFileList(String folderId,String folderType,String userId,String deptId,int tenantId, String companyId, String searchExt,
			String searchFileName, String searchStartDate, String searchEndDate,String searchCreateName,
			String searchFileType, String searchPageCount,String searchListCount, int pStart , int pEnd ) throws Exception;
	/*
	
	// 폴더 세부 정보 
	List<FolderVO> getFolderListDetail (String folderId, String folderType, String userId, String tenantId, String companyId ) throws Exception;
	// 폴더 이동
	String moveFolder (String folderId, String parentId, String tenantId, String companyId) throws Exception;
	// 폴더 복사 
	String copyFolder (String folderId, String parentId, String tenantId, String companyId) throws Exception;
	// 폴더 삭제 
	String deleteFolder (String folderId, String tenantId, String companyId ) throws Exception;
	
	// part yeyeun end
	*/

	int getFileToTalCount(String folderId,String folderType,String userId,String deptId, int tenantId, String parameter,
			String searchExt, String searchFileName, String searchStartDate,
			String searchEndDate, String searchCreateName,
			String searchFileType, String searchPageCount,
			String searchListCount, int pStart, int pEnd) throws Exception;

	// 폴더 전체 리스트 
	List<Map<String, Object>> getFolderList( String admin , String userId,String deptId, String comId, String folderId,
			String folderType, int tenantId) throws Exception;
	
	// folder insert위한 폴서 세부 정보 folderDetail
	FolderVO getFolderDetail(String folderUppId, String userId, int tenantId ,String comId)throws Exception;
	
	// 폴더 생성
	String insertFolder (int tenantId, String comId,String deptId, String userId, String folderType, String newFolderName1,String newFolderName2, FolderVO uppFolder);
	
	// folderUser 테이블에 데이터 생성
	LoginVO getUserInfo (int tenantId , String comId, String userId ) throws Exception;
	
	// 부서폴더 리스트 가져오는 메서드
	List<Map<String, Object>> getDeptFolder (int tenantId, String userId ,String deptId , String comId, String folderType) throws Exception;
	
	// 겸직자인지 판단하는 메서드 
	List<Map<String, Object>> getAddJobList (int tenantId, String userId ,String deptId , String comId) throws Exception;
	
	// 부서장인지 판단하는 메서드 
	List<Map<String, Object>> getDeptHeader (int tenantId, String userId ,String deptId , String comId) throws Exception;

	// 첫 로그인 후 폴더가 존재하는지 판단하는 메서드 
	int existFolderChk(String userId, String deptId, String comId, String folderType, int tenantId);

	// 부서 폴더가 존재하는지 판단하는 메서드 
	String existFolderChk_D(String userId, String deptId, String comId,	String folderType, int tenantId) throws Exception;
	
	// 폴더 수정
	String updateFolder (String folderId, String folderName, String userId, String companyId) throws Exception;
	
	
	
	
}
