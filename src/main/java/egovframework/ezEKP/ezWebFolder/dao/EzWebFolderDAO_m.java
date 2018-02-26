package egovframework.ezEKP.ezWebFolder.dao;

import java.util.List;
import java.util.Map;
import org.springframework.stereotype.Repository;
import egovframework.ezEKP.ezWebFolder.vo.FolderFileVO;
import egovframework.rte.psl.dataaccess.EgovAbstractDAO;

@Repository("EzWebFolderDAO_m")
public class EzWebFolderDAO_m extends EgovAbstractDAO {
	@SuppressWarnings("unchecked")
	public List<FolderFileVO> getShareGet(Map<String, Object> map) {
		return (List<FolderFileVO>)list("EzWebFolderDAO_m.getShareGet", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<FolderFileVO> getShareGive(Map<String, Object> map) {
		return (List<FolderFileVO>)list("EzWebFolderDAO_m.getShareGive", map);
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
