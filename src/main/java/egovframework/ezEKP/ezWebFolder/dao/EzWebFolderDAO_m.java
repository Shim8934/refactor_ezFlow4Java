package egovframework.ezEKP.ezWebFolder.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.ezEKP.ezWebFolder.vo.ShareVO;
import egovframework.rte.psl.dataaccess.EgovAbstractDAO;

@Repository("EzWebFolderDAO_m")
public class EzWebFolderDAO_m extends EgovAbstractDAO {
	@SuppressWarnings("unchecked")
	public List<ShareVO> getSharingList(Map<String, Object> map) {
		return (List<ShareVO>)list("EzWebFolderDAO_m.getSharingList", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ShareVO> getSharedList(Map<String, Object> map) {
		return (List<ShareVO>)list("EzWebFolderDAO_m.getSharedList", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getSharingCount(Map<String, Object> map) {
		return (List<Map<String, Object>>)list("EzWebFolderDAO_m.getSharingCount", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getSharedCount(Map<String, Object> map) {
		return (List<Map<String, Object>>)list("EzWebFolderDAO_m.getSharedCount", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<String> getUserNameList(Map<String, Object> map) {
		return (List<String>)list("EzWebFolderDAO_m.getUserNameList", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<String> getFolderUserIdList_D(Map<String, Object> map) {
		return (List<String>)list("EzWebFolderDAO_m.getFolderUserIdList_D", map);
	}
	
	public int getShareSeq(Map<String, Object> map) {
		return (int)select("EzWebFolderDAO_m.getShareSeq", map);
	}
	
	public void delShare(Map<String, Object> map) {
		delete("EzWebFolderDAO_m.delShare", map);
	}
	
	public void insertShare(Map<String, Object> map) {
		insert("EzWebFolderDAO_m.insertShare", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<String> userDeptList(Map<String, Object> map) {
		return (List<String>)list("EzWebFolderDAO_m.userDeptList", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<String> chiefDeptPath(Map<String, Object> map) {
		return (List<String>)list("EzWebFolderDAO_m.chiefDeptPath", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<String> chiefDeptList(Map<String, Object> map) {
		return (List<String>)list("EzWebFolderDAO_m.chiefDeptList", map);
	}
	
}
