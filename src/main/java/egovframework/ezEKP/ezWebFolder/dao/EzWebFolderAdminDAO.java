package egovframework.ezEKP.ezWebFolder.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.ezEKP.ezWebFolder.vo.FileLogVO;
import egovframework.ezEKP.ezWebFolder.vo.FileVO;
import egovframework.ezEKP.ezWebFolder.vo.FolderSimpleVO;
import egovframework.ezEKP.ezWebFolder.vo.UserCapacityVO;
import egovframework.ezEKP.ezWebFolder.vo.WebfolderConfigVO;
import org.egovframe.rte.psl.dataaccess.EgovAbstractDAO;

@Repository("EzWebFolderAdminDAO")
public class EzWebFolderAdminDAO extends EgovAbstractDAO {

	public int existCompany(Map<String, Object> map) {
		return (int) select("EzWebFolderAdminDAO.existCompany", map);
	}

	public void saveConfig(Map<String, Object> map) {
		insert("EzWebFolderAdminDAO.saveConfig", map);
	}

	public WebfolderConfigVO getEveryCompanyConfig(Map<String, Object> map) {
		return (WebfolderConfigVO) select("EzWebFolderAdminDAO.getEveryCompanyConfig", map);
	}

	public WebfolderConfigVO getWebfolderConfig(Map<String, Object> map) {
		return (WebfolderConfigVO)select("EzWebFolderAdminDAO.getWebfolderConfig", map);
	}

//	@SuppressWarnings("unchecked")
//	public List<CapacityVO> getListUserCapacity(Map<String, Object> map) {
//		return (List<CapacityVO>)list("EzWebFolderAdminDAO.getListUserCapacity", map);
//	}

//	public void updateNewAmount(Map<String, Object> map) {
//		insert("EzWebFolderAdminDAO.updateNewAmount", map);
//	}

	@SuppressWarnings("unchecked")
	public List<FileLogVO> getListFileLogs(Map<String, Object> map) {
		return (List<FileLogVO>)list("EzWebFolderAdminDAO.getListFileLogs", map);
	}

	public void insertFileLog(Map<String, Object> map) {
		insert("EzWebFolderAdminDAO.insertFileLog", map);
	}

	public int insertFolder(Map<String, Object> map) {
		return (int)insert("EzWebFolderAdminDAO.insertFolder", map);
	}
	public int updateFolder(Map<String, Object> map) {
		return (int)insert("EzWebFolderAdminDAO.updateFolder", map);
	}

	public void insertFolderUser(Map<String, Object> map) {
		insert("EzWebFolderAdminDAO.insertFolderUser", map);
	}

	public void deleteFolderUsers(Map<String, Object> map) {
		delete("EzWebFolderAdminDAO.deleteFolderUsers", map);
	}

	public int getTotalFileLogs(Map<String, Object> map) {
		return (int)select("EzWebFolderAdminDAO.getTotalFileLogs", map);
	}

//	public int getTotalListUserCapacity(Map<String, Object> map) {
//		return (int)select("EzWebFolderAdminDAO.getTotalListUserCapacity", map);
//	}

	public int insertFolder2(Map<String, Object> map) {
		return (int)insert("EzWebFolderAdminDAO.insertFolder2", map);
	}
	public int updateFolder2(Map<String, Object> map) {
		return (int)insert("EzWebFolderAdminDAO.updateFolder2", map);
	}

	public void deleteFolderUsersOfChief(Map<String, Object> map) {
		delete("EzWebFolderAdminDAO.deleteFolderUsersOfChief", map);
	}

	public void moveListSubFolders(Map<String, Object> map) {
		update("EzWebFolderAdminDAO.moveListSubFolders", map);
	}

	public void setEveryDefaultCapacity(Map<String, Object> map) {
		insert("EzWebFolderAdminDAO.setEveryDefaultCapacity", map);
	}

	public void setDefaultCapacity(Map<String, Object> map) {
		update("EzWebFolderAdminDAO.setDefaultCapacity", map);
	}

	public void setCapacity(Map<String, Object> map) {
		insert("EzWebFolderAdminDAO.setCapacity", map);
	}

	public void setCapacityForCompany(Map<String, Object> map) {
		insert("EzWebFolderAdminDAO.setCapacityForCompany", map);
	}

	public void deleteCapacities(Map<String, Object> map) {
		delete("EzWebFolderAdminDAO.deleteCapacities", map);
	}

	@SuppressWarnings("unchecked")
	public List<UserCapacityVO> getCapacityList(Map<String, Object> map) {
		return (List<UserCapacityVO>) list("EzWebFolderAdminDAO.getCapacityList", map);
	}

	public int getTotalCapacityCount(Map<String, Object> map) {
		return (int) select("EzWebFolderAdminDAO.getTotalCapacityCount", map);
	}

	public UserCapacityVO getCapacity(Map<String, Object> map) {
		return (UserCapacityVO) select("EzWebFolderAdminDAO.getCapacity", map);
	}

	public UserCapacityVO getCapacityForFolderId(Map<String, Object> map) {
		return (UserCapacityVO) select("EzWebFolderAdminDAO.getCapacityForFolderId", map);
	}

	public double getFolderSize(Map<String, Object> map) {
		return (double)select("EzWebFolderAdminDAO.getFolderSize", map);
	}

	// webfolder
	public void insertFolderUserSeq(Map<String, Object> map) {
		insert("EzWebFolderAdminDAO.insertFileFolderUser", map);
	}
	
	public void deleteFolderUsersByUserId(Map<String, Object> map) {
		delete("EzWebFolderAdminDAO.deleteFolderUsersByUserId", map);
	}

	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getDecryptedAllSubFilePath(Map<String, Object> map) {
		return (List<Map<String, Object>>) list("EzWebFolderAdminDAO.getDecryptedAllSubFilePath", map);
	}

	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getEncryptedAllSubFilePath(Map<String, Object> map) {
		return (List<Map<String, Object>>) list("EzWebFolderAdminDAO.getEncryptedAllSubFilePath", map);
	}

	public void deleteSelectedFolderUser(Map<String, Object> map) {
		delete("EzWebFolderAdminDAO.deleteSelectedFolderUser", map);
	}

	public void deleteSelectedFileUser(Map<String, Object> map) {
		delete("EzWebFolderAdminDAO.deleteSelectedFileUser", map);
	}
		
	public List<FolderSimpleVO> selectSubAllFolder(Map<String, Object> map) {
		return (List<FolderSimpleVO>) list("EzWebFolderAdminDAO.selectSubAllFolder", map);
	}

	@SuppressWarnings("unchecked")
	public List<String> getFolderIdsByManagerUserId(Map<String, Object> map) {
		return (List<String>) list("EzWebFolderAdminDAO.getFolderIdsByManagerUserId", map);
	}

	@SuppressWarnings("unchecked")
	public List<String> getTopFoldersByManagerUserId(Map<String, Object> map) {
		return (List<String>) list("EzWebFolderAdminDAO.getTopFoldersByManagerUserId", map);
	}

	public List<FileVO> folderInFileList(Map<String, Object> map) {
		return (List<FileVO>) list("EzWebFolderAdminDAO.folderInFileList", map);	
	}
}