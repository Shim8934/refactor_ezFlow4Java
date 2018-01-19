package egovframework.ezEKP.ezWebFolder.dao;

import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.ezEKP.ezWebFolder.vo.FileTypeVO;
import egovframework.ezEKP.ezWebFolder.vo.FileVO;
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
}
