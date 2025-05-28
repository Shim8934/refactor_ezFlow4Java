package egovframework.ezEKP.ezWebFolder.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.ezEKP.ezOrgan.vo.OrganUserVO;
import egovframework.ezEKP.ezWebFolder.vo.FavoriteVO;
import egovframework.ezEKP.ezWebFolder.vo.FolderTreeVO;
import egovframework.ezEKP.ezWebFolder.vo.ShareSubVO;
import egovframework.ezEKP.ezWebFolder.vo.ShareVO;
import egovframework.ezEKP.ezWebFolder.vo.SimpleShareVO;
import egovframework.ezEKP.ezWebFolder.vo.TrashCanVO;
import org.egovframe.rte.psl.dataaccess.EgovAbstractDAO;

@Repository("EzWebFolderDAO_m")
@SuppressWarnings("unchecked")
public class EzWebFolderDAO_m extends EgovAbstractDAO {
	
	public List<FolderTreeVO> getShareFolderTree(Map<String, Object> map) {
		return (List<FolderTreeVO>) list("EzWebFolderDAO_m.getShareFolderTree", map);
	}
	
	public List<ShareVO> getSharingList(Map<String, Object> map) {
		return (List<ShareVO>) list("EzWebFolderDAO_m.getSharingList", map);
	}
	
	public List<ShareVO> getSharedList(Map<String, Object> map) {
		return (List<ShareVO>) list("EzWebFolderDAO_m.getSharedList", map);
	}
	
	public List<Map<String, Object>> getSharingCount(Map<String, Object> map) {
		return (List<Map<String, Object>>) list("EzWebFolderDAO_m.getSharingCount", map);
	}
	
	public List<Map<String, Object>> getSharedCount(Map<String, Object> map) {
		return (List<Map<String, Object>>) list("EzWebFolderDAO_m.getSharedCount", map);
	}
	
	public List<SimpleShareVO> getShareInfo(Map<String, Object> map) {
		return (List<SimpleShareVO>) list("EzWebFolderDAO_m.getShareInfo", map);
	}
	
	public List<ShareSubVO> getShareSubInfo(Map<String, Object> map) {
		return (List<ShareSubVO>) list("EzWebFolderDAO_m.getShareSubInfo", map);
	}
	
	public List<String> getUserNameList(Map<String, Object> map) {
		return (List<String>) list("EzWebFolderDAO_m.getUserNameList", map);
	}
	
	public List<String> getFolderUserIdList_D(Map<String, Object> map) {
		return (List<String>) list("EzWebFolderDAO_m.getFolderUserIdList_D", map);
	}
	
	
	public int checkSharePermission(Map<String, Object> map) {
		return (Integer) select("EzWebFolderDAO_m.checkSharePermission", map);
	}
	
	public int checkShared1(Map<String, Object> map) {
		return (Integer) select("EzWebFolderDAO_m.checkShared1", map);
	}
	
	public int checkShared2(Map<String, Object> map) {
		return (Integer) select("EzWebFolderDAO_m.checkShared2", map);
	}
	
	public int insertShare(Map<String, Object> map) {
		return (int) insert("EzWebFolderDAO_m.insertShare", map);
	}
	
	public void insertShareSub(Map<String, Object> map) {
		insert("EzWebFolderDAO_m.insertShareSub", map);
	}
	
	public int getShareId(Map<String, Object> map) {
		return (int) select("EzWebFolderDAO_m.getShareId", map);
	}
	
	public List<Integer> getShareIdList(Map<String, Object> map) {
		return (List<Integer>) list("EzWebFolderDAO_m.getShareIdList", map);
	}
	
	public void updateShareUserNameList(Map<String, Object> map) {
		update("EzWebFolderDAO_m.updateShareUserNameList", map);
	}
	
	public void deleteShare(Map<String, Object> map) {
		delete("EzWebFolderDAO_m.deleteShare", map);
	}
	
	public void deleteShareSub(Map<String, Object> map) {
		delete("EzWebFolderDAO_m.deleteShareSub", map);
	}
	
	public void deleteShareWithSub(Map<String, Object> map) {
		delete("EzWebFolderDAO_m.deleteShareWithSub", map);
	}
	
	public List<ShareVO> getHiddenSharedList(Map<String, Object> map) {
		return (List<ShareVO>)list("EzWebFolderDAO_m.getHiddenSharedList", map);
	}

	public List<Map<String, Object>> getHiddenSharedCount(Map<String, Object> map) {
		return (List<Map<String, Object>>)list("EzWebFolderDAO_m.getHiddenSharedCount", map);
	}
	
	public void hideShare(Map<String, Object> map) {
		insert("EzWebFolderDAO_m.hideShare", map);
	}
	
	public void showShare(Map<String, Object> map) {
		delete("EzWebFolderDAO_m.showShare", map);
	}
	
	public List<FavoriteVO> getFavorites(Map<String, Object> map) {
		return (List<FavoriteVO>) list("EzWebFolderDAO_m.getFavorites", map);
	}
	
	public Map<String, Long> getFavoritesCount(Map<String, Object> map) {
		return (Map<String, Long>) map("EzWebFolderDAO_m.getFavoritesCount", map, "targetType", "count");
	}
	
	public Integer isExistsFavorite(Map<String, Object> map) {
		return (Integer) select("EzWebFolderDAO_m.isExistsFavorite", map);
	}
	
	public void addFavorite(Map<String, Object> map) {
		insert("EzWebFolderDAO_m.addFavorite", map);
	}
	
	public int deleteFavorite(Map<String, Object> map) {
		return delete("EzWebFolderDAO_m.deleteFavorite", map);
	}
	
	public int deleteFavoritesInFolder(Map<String, Object> map) {
		return delete("EzWebFolderDAO_m.deleteFavoritesInFolder");
	}
	
	public List<TrashCanVO> getTrashCanList (Map<String, Object> map) {
		return (List<TrashCanVO>) list ("EzWebFolderDAO_m.getTrashCanList", map);
	}
	
	public String getFolderPath (Map<String, Object> map) {
		return (String) select ("EzWebFolderDAO_m.getFolderPath", map);
	}
	
	public int deleteFile (Map<String, Object> map) {
		return  delete ("EzWebFolderDAO_m.deleteFile", map); 
	}
	
	public int deleteFileUser(Map<String, Object> map) {
		return  delete ("EzWebFolderDAO_m.deleteFileUser", map); 
	}
	
	public int deleteFolder (Map<String, Object> map) {
		return delete("EzWebFolderDAO_m.deleteFolder", map);
	}
	
	public int deleteFolderUser (Map<String, Object> map) {
		return delete("EzWebFolderDAO_m.deleteFolderUser", map);
	}
	
	public List <String> selectAllFilesInFolder (Map<String, Object> map) {
		return (List<String>) list("EzWebFolderDAO_m.selectAllFilesInFolder", map);
	}
	
	public int restoreFile (Map<String, Object> map){
		return update ("EzWebFolderDAO_m.restoreFile", map);
	}
	
	public int restoreFolder(Map<String, Object> map) {
		return update ("EzWebFolderDAO_m.restoreFolder", map);
	}
	
	public List<TrashCanVO> getFileListByFolderId (Map<String, Object> map) {
		return (List<TrashCanVO>) list ("EzWebFolderDAO_m.getFileListByFolderId", map);
	}
	
	public List<TrashCanVO> getFolderByFolderPath (Map<String, Object> map){
		return (List<TrashCanVO>) list ("EzWebFolderDAO_m.getFolderByFolderPath", map);
	}
	
	public int getTrashFileCount(Map<String, Object> map) {
		return (Integer) select("EzWebFolderDAO_m.getTrashFileCount", map);
	}
	
	public int getTrashFolderCount(Map<String, Object> map) {
		return (Integer) select("EzWebFolderDAO_m.getTrashFolderCount", map);
	}
	
	public int getTrashVersionCount(Map<String, Object> map) {
		return (Integer) select("EzWebFolderDAO_m.getTrashVersionCount", map);
	}

	public void moveFile(Map<String, Object> map) {
		update("EzWebFolderDAO_m.moveFile", map);
	}
	
	public List<String> getAllFolderIdNotInFolder (Map<String, Object> map) {
		return (List<String>) list("EzWebFolderDAO_m.getAllFolderIdNotInFolder", map);
	}
	
	public List<Map<String,String>> selectSubFolders(Map<String, Object> map) {
		return (List<Map<String, String>>) list("EzWebFolderDAO_m.selectSubFolders", map);
	}
	
	public void insertWebFolderApplyHistory(Map<String, Object> map) {
		insert("EzWebFolderDAO_m.insertWebFolderApplyHistory", map);
	}
	
	public void insertWebFolderApplyHistoryMember(Map<String, Object> map) {
		insert("EzWebFolderDAO_m.insertWebFolderApplyHistoryMember", map);
	}

	public int getWebFolderApplyHistoryListCount(Map<String, Object> map) {
		return (int) select("EzWebFolderDAO_m.getWebFolderApplyHistoryCount", map);
	}

	public List<Map<String, String>> getWebFolderApplyHistoryList(Map<String, Object> map) {
		return (List<Map<String, String>>) list("EzWebFolderDAO_m.getWebFolderApplyHistoryList", map);
	}

	public Map<String, String> getWebFolderApplyHistory(Map<String, Object> map) {
		return (Map<String, String>) select("EzWebFolderDAO_m.getWebFolderApplyHistory", map);
	}

	public List<Map<String, String>> getWebFolderApplyHistoryMember(Map<String, Object> map) {
		return (List<Map<String, String>>) list("EzWebFolderDAO_m.getWebFolderApplyHistoryMember", map);
	}

	public List<OrganUserVO> getWebFolderAdminUserList(Map<String, Object> map) {
		return (List<OrganUserVO>) list("EzWebFolderDAO_m.getWebFolderAdminUserList", map);
	}

	public void deleteWebFolderApplyHistory(Map<String, Object> map) {
		delete("EzWebFolderDAO_m.deleteWebFolderApplyHistory", map);
	}

	public void deleteWebFolderApplyHistoryMember(Map<String, Object> map) {
		delete("EzWebFolderDAO_m.deleteWebFolderApplyHistoryMember", map);
	}
	
	public void changeWebFolderAppliApprovalStatus(Map<String, Object> map) {
		update("EzWebFolderDAO_m.changeWebFolderAppliApprovalStatus", map);
	}
}
