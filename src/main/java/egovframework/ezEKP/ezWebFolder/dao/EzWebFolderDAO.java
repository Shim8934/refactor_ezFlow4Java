package egovframework.ezEKP.ezWebFolder.dao;

import java.util.List;
import java.util.Map;
import org.springframework.stereotype.Repository;
import egovframework.ezEKP.ezOrgan.vo.OrganDeptVO;
import egovframework.ezEKP.ezWebFolder.vo.FileTypeVO;
import egovframework.ezEKP.ezWebFolder.vo.FileVO;
import egovframework.ezEKP.ezWebFolder.vo.FolderSimpleVO;
import egovframework.ezEKP.ezWebFolder.vo.FolderUserVO;
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

	public void updateDownCnt(Map<String, Object> map) {		
		update("EzWebFolderDAO.updateDownCnt", map);
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

	@SuppressWarnings("unchecked")
	public List<FolderUserVO> getFolderUsers(Map<String, Object> map) {
		return (List<FolderUserVO>)list("EzWebFolderDAO.getFolderUsers", map);
	}

	@SuppressWarnings("unchecked")
	public List<OrganDeptVO> getFolderDepts(Map<String, Object> map) {
		return (List<OrganDeptVO>)list("EzWebFolderDAO.getFolderDepts", map);
	}

	public String getFolderSequence(Map<String, Object> map) {
		return (String)select("EzWebFolderDAO.getFolderSequence", map);
	}

	public String getMaxFolderStep(Map<String, Object> map) {
		return (String)select("EzWebFolderDAO.getMaxFolderStep", map);
	}

	public String getFolderUserSequence(Map<String, Object> map) {
		return (String)select("EzWebFolderDAO.getFolderUserSequence", map);
	}

	public void updateFolderUseStatus(Map<String, Object> map) {
		update("EzWebFolderDAO.updateFolderUseStatus", map);
	}

	@SuppressWarnings("unchecked")
	public List<FileVO> getAllFilesInFolder(Map<String, Object> map) {
		return (List<FileVO>)list("EzWebFolderDAO.getAllFilesInFolder", map);
	}

	public int getTotalFileCnt(Map<String, Object> map) {
		return (int)select("EzWebFolderDAO.getTotalFileCnt1", map);
	}

	@SuppressWarnings("unchecked")
	public List<FileVO> getAllFiles(Map<String, Object> map) {
		return (List<FileVO>)list("EzWebFolderDAO.getAllFiles", map);
	}

	public int getTotalFileCnt2(Map<String, Object> map) {
		return (int)select("EzWebFolderDAO.getTotalFileCnt2", map);
	}

	@SuppressWarnings("unchecked")
	public List<FolderVO> getAllSubFolders(Map<String, Object> map) {
		return (List<FolderVO>)list("EzWebFolderDAO.getAllSubFolders", map);
	}
}