package egovframework.ezEKP.ezWebFolder.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.ezEKP.ezWebFolder.vo.FileLogVO;
import egovframework.ezEKP.ezWebFolder.vo.FileTypeVO;
import egovframework.ezEKP.ezWebFolder.vo.FileVO;
import egovframework.ezEKP.ezWebFolder.vo.FolderSimpleVO;
import egovframework.ezEKP.ezWebFolder.vo.FolderVO;
import egovframework.rte.psl.dataaccess.EgovAbstractDAO;

@Repository("EzWebFolderDAO")
public class EzWebFolderDAO extends EgovAbstractDAO {
	public String getFileSequence(Map<String, Object> map) {
		return (String)select("EzWebFolderDAO.getFileSequence", map);
	}
	
	public void insertFile(Map<String, Object> map) {
		insert("EzWebFolderDAO.insertFile", map);
	}

	public FileVO getFileByFileId(Map<String, Object> map) {		
		return (FileVO)select("EzWebFolderDAO.getFileByFileId", map);
	}

	public FileTypeVO getFileTypeByFileExt(Map<String, Object> map) {
		return (FileTypeVO)select("EzWebFolderDAO.getFileTypeByFileExt", map);
	}

	public void deleteFileByFileId(Map<String, Object> map) {		
		delete("EzWebFolderDAO.deleteFileByFileId", map);
	}

	public void updateFileUseStatus(Map<String, Object> map) {		
		update("EzWebFolderDAO.updateFileUseStatus", map);
	}

	public void updateFileName(Map<String, Object> map) {
		update("EzWebFolderDAO.updateFileName", map);
	}

	public void moveFile(Map<String, Object> map) {
		update("EzWebFolderDAO.moveFile", map);		
	}

	public String getFileLogSequence(Map<String, Object> map) {
		return (String)select("EzWebFolderDAO.getFileLogSequence", map);
	}

	public FolderVO getFolderByFolderId(Map<String, Object> map) {
		return (FolderVO)select("EzWebFolderDAO.getFolderByFolderId", map);
	}

	public FolderSimpleVO getSimpleSubFolder(Map<String, Object> map) {
		return (FolderSimpleVO)select("EzWebFolderDAO.getSimpleSubFolder", map);
	}

	@SuppressWarnings("unchecked")
	public List<FolderSimpleVO> getAllSimpleSubFolders(Map<String, Object> map) {		
		return (List<FolderSimpleVO>)list("EzWebFolderDAO.getAllSimpleSubFolders", map);
	}

	public FolderVO getCompanyFolderId(Map<String, Object> map) {		
		return (FolderVO)select("EzWebFolderDAO.getCompanyFolderId", map);
	}

	// fileList 가져오는 메소드
	public List<FileVO> getFileList(Map<String, Object> map) {
		return  (List<FileVO>) list("EzWebFolderDAO.getFileList",map);
	}
}
