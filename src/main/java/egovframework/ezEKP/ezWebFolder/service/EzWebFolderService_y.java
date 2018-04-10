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
			String searchFileType, String searchPageCount, int pStart , int pEnd, String offset ) throws Exception;

	Map<String, Integer> getFileToTalCount(String folderId,String folderType,String userId,String deptId, int tenantId, String parameter,
			String searchExt, String searchFileName, String searchStartDate,
			String searchEndDate, String searchCreateName,
			String searchFileType, String searchPageCount, int pStart, int pEnd , String offset) throws Exception;

	// 폴더 전체 리스트 
	List<Map<String, Object>> getFolderList( String admin , String userId,String deptId, String comId, String folderId,
			String folderType, int tenantId, String primary) throws Exception;
	
	// folder insert위한 폴서 세부 정보 folderDetail
	FolderVO getFolderDetail(String folderUppId, String userId, int tenantId ,String comId)throws Exception;
	
	// 폴더 생성
	String insertFolder (int tenantId, String comId,String deptId, String userId, String folderType, 
			String newFolderName1,String newFolderName2, FolderVO uppFolder, String timeUTC);
	
	// folderUser 테이블에 데이터 생성
	LoginVO getUserInfo (int tenantId , String comId, String userId ) throws Exception;
	
	// 부서폴더 리스트 가져오는 메서드
	List<Map<String, Object>> getDeptFolder (int tenantId, String userId ,String deptId , String comId, String folderType) throws Exception;
	
	// 겸직자인지 판단하는 메서드 
	List<Map<String, Object>> getAddJobList (int tenantId, String userId ,String deptId , String comId) throws Exception;
	
	// 부서장인지 판단하는 메서드 
	List<Map<String, Object>> getDeptHeader (int tenantId, String userId ,String deptId , String comId) throws Exception;

	// 첫 로그인 후 폴더가 존재하는지 판단하는 메서드 
	int existFolderChk(String userId, String deptId, String comId, String folderType, int tenantId, String primary);

	// 부서 폴더가 존재하는지 판단하는 메서드 
	String existFolderChk_D(String userId, String deptId, String comId,	String folderType, int tenantId,String timeUTC, String primary) throws Exception;
	
	// 폴더 수정
	void updateFolder(String folderId, int tenantId, String userId, String comId, String newFolderName1, String newFolderName2 , String timeUTC);
	
	// 폴더 삭제
	void deleteSubFldAFile(String folderId, int tenantId, String comId , String userId , String timeUTC);
	
	// 하위폴더가 모두 자신이 만든 폴더인지 확인하는 메서드
	// 모두 자신이 만든 폴더이면 true , 아니라서 삭제가 불가능하면  false 
	int checkCreater(String folderId , int tenantId, String comId, String userId );
	
	// 본인이 환경설정에서 설정해놓은 listCount를 출력
	int getUsrListCount (int tenantId, String userId ) ;
}
