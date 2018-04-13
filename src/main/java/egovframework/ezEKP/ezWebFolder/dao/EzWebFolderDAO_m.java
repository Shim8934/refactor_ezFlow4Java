package egovframework.ezEKP.ezWebFolder.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.ezEKP.ezWebFolder.vo.FavoriteFileVO;
import egovframework.ezEKP.ezWebFolder.vo.FolderFileVO;
import egovframework.ezEKP.ezWebFolder.vo.ShareVO;
import egovframework.ezEKP.ezWebFolder.vo.TrashCanVO;
import egovframework.rte.psl.dataaccess.EgovAbstractDAO;

@Repository("EzWebFolderDAO_m")
@SuppressWarnings("unchecked")
public class EzWebFolderDAO_m extends EgovAbstractDAO {

	public List<ShareVO> getSharingList(Map<String, Object> map) {
		return (List<ShareVO>)list("EzWebFolderDAO_m.getSharingList", map);
	}
	
	public List<ShareVO> getSharedList(Map<String, Object> map) {
		return (List<ShareVO>)list("EzWebFolderDAO_m.getSharedList", map);
	}
	
	public List<Map<String, Object>> getSharingCount(Map<String, Object> map) {
		return (List<Map<String, Object>>)list("EzWebFolderDAO_m.getSharingCount", map);
	}
	
	public List<Map<String, Object>> getSharedCount(Map<String, Object> map) {
		return (List<Map<String, Object>>)list("EzWebFolderDAO_m.getSharedCount", map);
	}
	
	public List<String> getUserNameList(Map<String, Object> map) {
		return (List<String>)list("EzWebFolderDAO_m.getUserNameList", map);
	}
	
	public List<String> getFolderUserIdList_D(Map<String, Object> map) {
		return (List<String>)list("EzWebFolderDAO_m.getFolderUserIdList_D", map);
	}
	
	public int isShared(Map<String, Object> map) {
		return (Integer) select("EzWebFolderDAO_m.isShared", map);
	}
	
	public List<FolderFileVO> getShareGet(Map<String, Object> map) {
		return (List<FolderFileVO>) list("EzWebFolderDAO_m.getShareGet", map);
	}

	public List<FolderFileVO> getShareGive(Map<String, Object> map) {
		return (List<FolderFileVO>) list("EzWebFolderDAO_m.getShareGive", map);
	}

	public int getShareSeq(Map<String, Object> map) {
		return (int) select("EzWebFolderDAO_m.getShareSeq", map);
	}

	public void delShare(Map<String, Object> map) {
		delete("EzWebFolderDAO_m.delShare", map);
	}

	public void insertShare(Map<String, Object> map) {
		insert("EzWebFolderDAO_m.insertShare", map);
	}

	public List<String> userDeptList(Map<String, Object> map) {
		return (List<String>) list("EzWebFolderDAO_m.userDeptList", map);
	}

	public List<String> chiefDeptPath(Map<String, Object> map) {
		return (List<String>) list("EzWebFolderDAO_m.chiefDeptPath", map);
	}

	public List<String> chiefDeptList(Map<String, Object> map) {
		return (List<String>) list("EzWebFolderDAO_m.chiefDeptList", map);
	}

	public List<FavoriteFileVO> getFavorites(Map<String, Object> map) {
		return (List<FavoriteFileVO>) list("EzWebFolderDAO_m.getFavorites", map);
	}
	
	public Integer getFavoriteFolderCount(Map<String, Object> map) {
		return (Integer) select("EzWebFolderDAO_m.getFavoriteFolderCount", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<TrashCanVO> getFileList (Map<String, Object> map) {
		return (List<TrashCanVO>) list ("EzWebFolderDAO_m.getFileList", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<TrashCanVO> getFolderList (Map<String, Object> map) {
		return (List<TrashCanVO>) list ("EzWebFolderDAO_m.getFolderList", map);
	}
	
	public String getFolderPath (Map<String, Object> map) {
		return (String) select ("EzWebFolderDAO_m.getFolderPath", map);
	}
	
	public int updateFileUseStatus (Map<String, Object> map) {
		return  update ("EzWebFolderDAO_m.updateFileUseStatus", map); 
	}
	
	public int updateFolderUseStatus (Map<String, Object> map) {
		return update("EzWebFolderDAO_m.updateFolderUseStatus", map);
	}
	
	public int updateStatusAllFilesInFolder (Map<String, Object> map) {
		return update("EzWebFolderDAO_m.updateStatusAllFilesInFolder", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<TrashCanVO> getFileListByFolderId (Map<String, Object> map) {
		return (List<TrashCanVO>) list ("EzWebFolderDAO_m.getFileListByFolderId", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<TrashCanVO> getFolderByFolderPath (Map<String, Object> map){
		return (List<TrashCanVO>) list ("EzWebFolderDAO_m.getFolderByFolderPath", map);
	}

	public Integer getFavoriteFileCount(Map<String, Object> map) {
		return (Integer) select("EzWebFolderDAO_m.getFavoriteFileCount", map);
	}
	
	public Integer isExistsFavorite(Map<String, Object> map) {
		return (Integer) select("EzWebFolderDAO_m.isExistsFavorite", map);
	}
	
	public void addFavorite(Map<String, Object> map) {
		insert("EzWebFolderDAO_m.addFavorite", map);
	}
	
	public void deleteFavorite(Map<String, Object> map) {
		delete("EzWebFolderDAO_m.deleteFavorite", map);
	}
}
