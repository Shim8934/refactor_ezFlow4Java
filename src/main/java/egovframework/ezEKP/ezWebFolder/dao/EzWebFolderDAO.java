package egovframework.ezEKP.ezWebFolder.dao;

import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.rte.psl.dataaccess.EgovAbstractDAO;

@Repository("EzWebFolderDAO")
public class EzWebFolderDAO extends EgovAbstractDAO {
	public String getFileSequence(Map<String, Object> map) {
		return (String)select("EzWebFolderDAO.getFileSequence", map);
	}
	
	public void insertFile(Map<String, Object> map) {
		insert("EzWebFolderDAO.insertFile", map);
	}

	public String getFileIconFromExt(Map<String, Object> map) {		
		return (String)select("EzWebFolderDAO.getFileIconFromExt", map);
	}
}
