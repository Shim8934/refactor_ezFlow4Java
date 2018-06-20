package egovframework.ezEKP.ezWebFolder.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.ezEKP.ezWebFolder.vo.FileVO;
import egovframework.ezEKP.ezWebFolder.vo.FolderVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.rte.psl.dataaccess.EgovAbstractDAO;

@SuppressWarnings("unchecked")
@Repository("EzWebFolderDAO_y")
public class EzWebFolderDAO_y extends EgovAbstractDAO {
	
	public int checkRootFolder(Map<String, Object> map) {
		return (int) select("EzWebFolderDAO_y.checkRootFolder", map);
	}
	
	public String insertRootFolder(Map<String, Object> map) {
		return (String) insert("EzWebFolderDAO_y.insertRootFolder", map);
	}
	
	public List<Map<String, Object>> getUserFolderTree(Map<String, Object> map) {
		return (List<Map<String, Object>>) list("EzWebFolderDAO_y.getUserFolderTree",map);
	}
	
	public List<Map<String, Object>> getDeptFolderTree(Map<String, Object> map) {
		return (List<Map<String, Object>>) list("EzWebFolderDAO_y.getDeptFolderTree",map);
	}
	
	public List<Map<String, Object>> getCompFolderTree(Map<String, Object> map) {
		return (List<Map<String, Object>>) list("EzWebFolderDAO_y.getCompFolderTree",map);
	}
	
	// fileList 가져오는 메소드
	public List<FileVO> getFileList(Map<String, Object> map) {
		return  (List<FileVO>) list("EzWebFolderDAO_y.getFileList",map);
	}
	
	public List<FileVO> getFileListR(Map<String, Object> map) {
		return  (List<FileVO>) list("EzWebFolderDAO_y.getFileListR",map);
	}
	
	public List<FileVO> searchFileList(Map<String, Object> map) {
		return  (List<FileVO>) list("EzWebFolderDAO_y.searchFileList",map);
	}
	
	public List<FileVO> searchFileListR(Map<String, Object> map) {
		return  (List<FileVO>) list("EzWebFolderDAO_y.searchFileListR",map);
	}
	
	public int getFldTotalCount (Map<String, Object> map) {
		return (int) select("EzWebFolderDAO_y.getFldToTalCount",map);
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

	public String insertFolder(Map<String, Object> map) {
		return  (String) insert("EzWebFolderDAO_y.insertFolder", map);
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
}
