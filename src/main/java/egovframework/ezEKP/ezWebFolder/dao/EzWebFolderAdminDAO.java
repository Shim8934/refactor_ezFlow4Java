package egovframework.ezEKP.ezWebFolder.dao;

import java.util.List;
import java.util.Map;
import org.springframework.stereotype.Repository;
import egovframework.ezEKP.ezWebFolder.vo.FileLogVO;
import egovframework.ezEKP.ezWebFolder.vo.UserCapacityVO;
import egovframework.ezEKP.ezWebFolder.vo.WebfolderConfigVO;
import egovframework.rte.psl.dataaccess.EgovAbstractDAO;

@Repository("EzWebFolderAdminDAO")
public class EzWebFolderAdminDAO extends EgovAbstractDAO {

	public void saveConfig(Map<String, Object> map) {
		insert("EzWebFolderAdminDAO.saveConfig", map);
	}

	public WebfolderConfigVO getWebfolderConfig(Map<String, Object> map) {
		return (WebfolderConfigVO)select("EzWebFolderAdminDAO.getWebfolderConfig", map);
	}

	@SuppressWarnings("unchecked")
	public List<UserCapacityVO> getListUserCapacity(Map<String, Object> map) {
		return (List<UserCapacityVO>)list("EzWebFolderAdminDAO.getListUserCapacity", map);
	}

	public void updateNewAmount(Map<String, Object> map) {
		insert("EzWebFolderAdminDAO.updateNewAmount", map);
	}

	@SuppressWarnings("unchecked")
	public List<FileLogVO> getListFileLogs(Map<String, Object> map) {
		return (List<FileLogVO>)list("EzWebFolderAdminDAO.getListFileLogs", map);
	}

	public void insertFileLog(Map<String, Object> map) {
		insert("EzWebFolderAdminDAO.insertFileLog", map);
	}

	public void insertFolder(Map<String, Object> map) {
		insert("EzWebFolderAdminDAO.insertFolder", map);
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

	public int getTotalListUserCapacity(Map<String, Object> map) {
		return (int)select("EzWebFolderAdminDAO.getTotalListUserCapacity", map);
	}

	public void insertFolder2(Map<String, Object> map) {
		insert("EzWebFolderAdminDAO.insertFolder2", map);
	}

	public void deleteFolderUsersOfChief(Map<String, Object> map) {
		delete("EzWebFolderAdminDAO.deleteFolderUsersOfChief", map);
	}

	public void moveListSubFolders(Map<String, Object> map) {
		update("EzWebFolderAdminDAO.moveListSubFolders", map);
	}

	public UserCapacityVO getUserCapacity(Map<String, Object> map) {
		return (UserCapacityVO)select("EzWebFolderAdminDAO.getUserCapacity", map);
	}

	public double getFolderSize(Map<String, Object> map) {
		return (double)select("EzWebFolderAdminDAO.getFolderSize", map);
	}
}