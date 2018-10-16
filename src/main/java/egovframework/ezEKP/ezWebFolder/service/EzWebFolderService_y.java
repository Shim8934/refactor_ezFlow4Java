package egovframework.ezEKP.ezWebFolder.service;

import java.util.List;
import java.util.Map;

import org.json.simple.JSONObject;

import egovframework.ezEKP.ezWebFolder.vo.FileVO;
import egovframework.ezEKP.ezWebFolder.vo.FolderVO;
import egovframework.let.user.login.vo.LoginVO;

public interface EzWebFolderService_y {
	public void insertIfNotExistRootForder(String userId, String userName1, String userName2, String compId, List<Map<String, String>> permissionIdList, String offset, int tenantId) throws Exception;
	
	public List<Map<String, Object>> getFolderTree(String userId, String deptId, String compId, String folderType, String primary, int tenantId) throws Exception;
	
	// 파일리스트(루트폴더일 경우 모든 파일 가져옴)
	List<FileVO> getFileList(String folderId, String userId, String deptId, int tenantId, String comId, String searchExt, String searchFileName, 
			String searchStartDate, String searchEndDate, String searchCreateName, String searchFileType, String searchPageCount, 
			int pStart, int pEnd, String offset, String primary) throws Exception;
	
	// 파일리스트
	List<FileVO> getFileList2(String folderId, String userId, String deptId, int tenantId, String comId, String searchExt, String searchFileName, 
			String searchStartDate, String searchEndDate, String searchCreateName, String searchFileType, String searchPageCount, 
			int pStart, int pEnd, String offset, String primary) throws Exception;
	
	// 파일리스트의 총 개수 가져오는 메서드(루트폴더일 경우 모든 파일의 개수 가져옴)
	Map<String, Integer> getFileToTalCount(String folderId, String userId, String deptId, int tenantId, String parameter,
			String searchExt, String searchFileName, String searchStartDate, String searchEndDate, String searchCreateName,
			String searchFileType, String searchPageCount, int pStart, int pEnd, String offset, String primary) throws Exception;

	// 파일리스트의 총 개수 가져오는 메서드
	Map<String, Integer> getFileToTalCount2(String folderId, String userId, String deptId, int tenantId, String parameter,
			String searchExt, String searchFileName, String searchStartDate, String searchEndDate, String searchCreateName,
			String searchFileType, String searchPageCount, int pStart, int pEnd, String offset, String primary) throws Exception;

	// folder insert위한 폴서 세부 정보 folderDetail
	FolderVO getFolderDetail(String folderUppId, String userId, int tenantId ,String comId) throws Exception;
	
	// 폴더 생성
	String insertFolder(int tenantId, String comId,String deptId, String userId, String folderType, 
			String newFolderName1,String newFolderName2, FolderVO uppFolder, String timeUTC) throws Exception;
	
	// folderUser 테이블에 데이터 생성
	LoginVO getUserInfo(int tenantId , String comId, String userId ) throws Exception;
	
	// 겸직자인지 판단하는 메서드 
	List<String> getAddJobList(int tenantId, String userId) throws Exception;
	
	// 폴더 수정
	void updateFolder(String folderId, int tenantId, String userId, String comId, String newFolderName1, String newFolderName2 , String timeUTC) throws Exception;
	
	// 폴더 삭제
	int deleteSubFldAFile(String folderId, int tenantId, String comId , String userId , String timeUTC) throws Exception;
	
	// 하위폴더가 모두 자신이 만든 폴더인지 확인하는 메서드
	// 모두 자신이 만든 폴더이면 true , 아니라서 삭제가 불가능하면  false 
	int checkCreater(String folderId , int tenantId, String comId, String userId ) throws Exception;
	
	// 본인이 환경설정에서 설정해놓은 listCount를 출력
	int getUsrListCount(int tenantId, String userId ) throws Exception;

	// listCount 수정시 insert
	void insertEnv(String userId, int tenantId, int listCount) throws Exception;
	
	// folderFileId : targetId, folderFileType : 'D','F'
	String checkPermission(String userId, String deptId, String comId, String folderFileId, String folderFileType, int tenantId) throws Exception;
	
	/** 
	 * @param folders ex) {@code "2,4,7,11"}
	 * @param files ex) {@code "3,8,12,15"}
	 * 
	 * @return 
	 * <pre>
	 * 성공 시: {"status": "ok", "code": 0}
	 * 서버 에러: {"status": "error", "code": 2}
	 * 권한 에러: {"status": "error", "code": 3}
	 * </pre>
	 * **/
	JSONObject checkPermissions(String userId, String deptId, String comId, String folders, String files, int tenantId) throws Exception;
}
