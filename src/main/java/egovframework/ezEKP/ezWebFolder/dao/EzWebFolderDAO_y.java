package egovframework.ezEKP.ezWebFolder.dao;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.ezEKP.ezWebFolder.vo.FileVO;
import egovframework.ezEKP.ezWebFolder.vo.FolderTreeVO;
import egovframework.ezEKP.ezWebFolder.vo.FolderVO;
import egovframework.let.user.login.vo.LoginVO;
import org.egovframe.rte.psl.dataaccess.EgovAbstractDAO;

@SuppressWarnings("unchecked")
@Repository("EzWebFolderDAO_y")
public class EzWebFolderDAO_y extends EgovAbstractDAO {
	
	public int checkRootFolder(Map<String, Object> map) {
		return (int) select("EzWebFolderDAO_y.checkRootFolder", map);
	}
	
	public int insertRootFolder(Map<String, Object> map) {
		return (int) insert("EzWebFolderDAO_y.insertRootFolder", map);
	}
	
	public List<FolderTreeVO> getUserFolderTree(Map<String, Object> map) {
		return (List<FolderTreeVO>) list("EzWebFolderDAO_y.getUserFolderTree",map);
	}
	
	public List<FolderTreeVO> getDeptFolderTree(Map<String, Object> map) {
		return (List<FolderTreeVO>) list("EzWebFolderDAO_y.getDeptFolderTree",map);
	}
	
	public List<FolderTreeVO> getCompFolderTree(Map<String, Object> map) {
		return (List<FolderTreeVO>) list("EzWebFolderDAO_y.getCompFolderTree",map);
	}
	
	// fileList 가져오는 메소드
	public List<FileVO> getFileList(Map<String, Object> map) {
		return  (List<FileVO>) list("EzWebFolderDAO_y.getFileList",map);
	}
	
	// fileList 가져오는 메소드2 모든 폴더들이 다 동일한 조건 
	public List<FileVO> getFileList2(Map<String, Object> map) {
		return  (List<FileVO>) list("EzWebFolderDAO_y.getFileList2",map);
	}
	
	public List<FileVO> getFileListR(Map<String, Object> map) {
		return  (List<FileVO>) list("EzWebFolderDAO_y.getFileListR",map);
	}
	
	public List<FileVO> searchFileList(Map<String, Object> map) {
		return  (List<FileVO>) list("EzWebFolderDAO_y.searchFileList",map);
	}
	
	public List<FileVO> searchFileList2(Map<String, Object> map) {
		return  (List<FileVO>) list("EzWebFolderDAO_y.searchFileList2",map);
	}
	
	public List<FileVO> searchFileListR(Map<String, Object> map) {
		return  (List<FileVO>) list("EzWebFolderDAO_y.searchFileListR",map);
	}
	
	public int getFldTotalCount(Map<String, Object> map) {
		return (int) select("EzWebFolderDAO_y.getFldToTalCount",map);
	}

	public int getFldTotalCount2(Map<String, Object> map) {
		return (int) select("EzWebFolderDAO_y.getFldToTalCount2",map);
	}
	
	public int getFileTotalCount (Map<String, Object> map) {
		return (int) select("EzWebFolderDAO_y.getFileToTalCount",map);
	}
	
	public int getFileTotalCountR (Map<String, Object> map) {
		return (int) select("EzWebFolderDAO_y.getFileToTalCountR",map);
	}
	
	public int searchFileToTalCount (Map<String, Object> map) {
		return (int) select("EzWebFolderDAO_y.searchFileToTalCount",map);
	}

	public int searchFileToTalCount2 (Map<String, Object> map) {
		return (int) select("EzWebFolderDAO_y.searchFileToTalCount2",map);
	}
	
	public int searchFileToTalCountR (Map<String, Object> map) {
		return (int) select("EzWebFolderDAO_y.searchFileToTalCountR",map);
	}
	
	// 폴더 상세 정보 
	public FolderVO getFolderDetail(Map<String, Object> map) {
		return (FolderVO) select("EzWebFolderDAO_y.getFolderDetail", map);
	}
	
	// 폴더 상세 정보 
	public FolderVO getFolderDetailByFileId(Map<String, Object> map) {
		return (FolderVO) select("EzWebFolderDAO_y.folderDetailByFileId", map);
	}

	public int insertFolder(Map<String, Object> map) {
		return  (int) insert("EzWebFolderDAO_y.insertFolder", map);
	}
	
	public void updateFolderPath(Map<String, Object> map) {
		insert("EzWebFolderDAO_y.updateFolderPath", map);
	}

	public LoginVO getUserInfo(Map<String, Object> map) {
		return  (LoginVO) select("EzWebFolderDAO_y.getUserInfo", map);
	}
	
	public int getFolderStep(Map<String, Object> map) {
		return  (int) select("EzWebFolderDAO_y.getFolderStep", map);
	}
	
	public List<String> getAddJobList(Map<String, Object> map) {
		return (List<String>) list("EzWebFolderDAO_y.getAddJobList", map);
	}
	
	public void updateFolder(Map<String, Object> map) {
		update("EzWebFolderDAO_y.updateFolder", map );
	}
	
	public void deleteFolder(Map<String, Object> map) {
		update("EzWebFolderDAO_y.deleteFolder", map );
	}
	
	public void deleteSubFolder(Map<String, Object> map) {
		update("EzWebFolderDAO_y.deleteSubFolder", map );
	}
	
	public void deleteFileInFolder(Map<String, Object> map) {
		update("EzWebFolderDAO_y.deleteFileInFolder", map );
	}
	
	// result는 만약 다른 사람이 만든 폴더나 파일이 있으면 1-return 
	public int checkSubCreater(Map<String, Object> map) {
		return (int) select("EzWebFolderDAO_y.checkSubCreater", map );
	}
	
	// result는 만약 다른 사람이 만든 폴더나 파일이 있으면 1-return 
	public int checkFileCreater(Map<String, Object> map) {
		return (int) select("EzWebFolderDAO_y.checkFileCreater", map );
	}

	public int getUsrListCnt(Map<String, Object> map) {
		return (int) select ("EzWebFolderDAO_y.getUsrListCnt", map);
	}
	
	// listCount 수정시 insert 
	public void insertEnv(Map<String, Object> map) {
		update("EzWebFolderDAO_y.envInsert", map);
	}
	
	public int checkCompanyFolderPermission(Map<String, Object> map) {
		return (int) select("EzWebFolderDAO_y.checkCompanyFolderPermission", map);
	}
	
	public int checkCompanyFilePermission(Map<String, Object> map) {
		return (int) select("EzWebFolderDAO_y.checkCompanyFilePermission", map);
	}
	
	// 파일 상세 정보 탐색기지원
	public FileVO getFileDetailForExplorer(Map<String, Object> map) {
		return (FileVO) select("EzWebFolderDAO_y.getFileDetailForExplorer", map);
	}
	
	// 폴더 상세 정보 탐색기지원
	public FileVO getFolderDetailForExplorer(Map<String, Object> map) {
		return (FileVO) select("EzWebFolderDAO_y.getFolderDetailForExplorer", map);
	}
	
	// 파일 overWrite 기능 (탐색기 지원)
	public int updateFileRealData (Map<String, Object> map ) {
		return update("EzWebFolderDAO_y.updateFileRealData", map);
	}

	// 웹폴더 탐색기에서 로그인 기능  - 토큰 생성 (탐색기 지원)
	public String setAuthLoginTokenSql (Map<String, Object> map) {
		return (String) insert("EzWebFolderDAO_y.insertToken", map);
	}
	
	// 웹폴더 탐색기에서 로그인 기능 - 토큰 삭제 (탐색기 지원)
	public int deleteAuthLoginTokenSql (Map<String, Object> map) {
		return delete("EzWebFolderDAO_y.deleteToken", map);
	}
	
	// 웹폴더 탐색기에서 로그인 기능 - 토큰 존재여부 판단 (탐색기 지원)
	public int existsTokenCheck (Map<String, Object> map) {
		return (int) select("EzWebFolderDAO_y.existsToken", map);
	}

	// 웹폴더 탐색기에서 로그인 기능 - token userId 존재 판단 (탐색기 지원)
	// 위와는 다르게 userid와 tenantid만 가지고 있는지만 판단
	public int existsUserIdTokenCheck (Map<String, Object> map) {
		return (int) select("EzWebFolderDAO_y.existsUserIdTokenCheck", map);
	}
	
	// userId 로 필요한 folderType별 folderId 출력 
	public String folderIdByUserIdAndFolderType (Map<String, Object> map) {
		return (String) select("EzWebFolderDAO_y.folderIdByUserIdAndFolderType", map);
	}

	public ArrayList<Map<String, Object>> selectWebfolderFiletoAnother(Map<String, Object> map) {
		return  (ArrayList<Map<String, Object>>) list("EzWebFolderDAO_y.selectWebfolderFiletoAnother", map);
	}
	
	public List<String> getWebFolderUserGroupList(Map<String, Object> map) {
		return (List<String>) list("EzWebFolderDAO_y.getWebFolderUserGroupList", map);
	}

	public List<String> getjikWiChekAddjobList(Map<String, Object> map) {
		return (List<String>) list("EzWebFolderDAO_y.getjikWiChekAddjobList", map);
	}

	public FileVO selectFileDetail(Map<String, Object> map) {
		return (FileVO) select("EzWebFolderDAO_y.selectFileDetail", map);
	}

	public List<Map<String,String>> getFolderUser (Map<String, Object> map) {
		return (List<Map<String, String>>) list("EzWebFolderDAO_y.getFolderUser", map);
	}
		
	public List<Map<String, Object>> selectRootFolderListInfo (Map<String, Object> map) {
		return (List<Map<String, Object>>) list("EzWebFolderDAO_y.getRootFolderListInfo",map);
	}
	
}
