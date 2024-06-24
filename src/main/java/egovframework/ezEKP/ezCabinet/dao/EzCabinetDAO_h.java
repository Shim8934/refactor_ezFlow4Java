package egovframework.ezEKP.ezCabinet.dao;

import java.util.List;
import java.util.Map;
import org.springframework.stereotype.Repository;
import egovframework.ezEKP.ezCabinet.vo.CabinetAttachFileVO;
import egovframework.ezEKP.ezCabinet.vo.CabinetItemVO;
import egovframework.ezEKP.ezCabinet.vo.CabinetRelationItemVO;
import egovframework.ezEKP.ezWebFolder.vo.SimpleUserVO;
import org.egovframe.rte.psl.dataaccess.EgovAbstractDAO;

@SuppressWarnings("unchecked")
@Repository("EzCabinetDAO_h")
public class EzCabinetDAO_h extends EgovAbstractDAO {
	public List<SimpleUserVO> getDeptMemberList(Map<String, Object> map) {
		return (List<SimpleUserVO>)list("EzCabinetDAO_h.getDeptMemberList", map);
	}
	
	public List<SimpleUserVO> getShareUserList(Map<String, Object> map) {
		return (List<SimpleUserVO>)list("EzCabinetDAO_h.getShareUserList", map);
	}
	
	public int getTotalDeptMembers(Map<String, Object> map) {
		return (int)select("EzCabinetDAO_h.getTotalDeptMembers", map);
	}
	
	public List<SimpleUserVO> getSearchMemberList(Map<String, Object> map) {
		return (List<SimpleUserVO>)list("EzCabinetDAO_h.getSearchMemberList", map);
	}
	
	public int getTotalSearchMembers(Map<String, Object> map) {
		return (int)select("EzCabinetDAO_h.getTotalSearchMembers", map);
	}
	
	public void saveShareUserList(Map<String, Object> map) {
		insert("EzCabinetDAO_h.saveShareUserList", map);
	}
	
	public void updateShareList(Map<String, Object> map) {
		update("EzCabinetDAO_h.updateShareList", map);
	}
	
	public int getMaximumShareId(Map<String, Object> map) {
		return (int)select("EzCabinetDAO_h.getMaximumShareId", map);
	}
	
	public CabinetItemVO getFileDetail(Map<String, Object> map) {
		return (CabinetItemVO)select("EzCabinetDAO_h.getFileDetail", map);
	}
	
	public List<CabinetAttachFileVO> getAllAttachFile(Map<String, Object> map) {
		return (List<CabinetAttachFileVO>)list("EzCabinetDAO_h.getAllAttachFile", map);
	}
	
	public List<CabinetRelationItemVO> getRelatedFileList(Map<String, Object> map) {
		return (List<CabinetRelationItemVO>)list("EzCabinetDAO_h.getRelatedFileList", map);
	}
	
	public void modifyItem(CabinetItemVO itemVO) {
		update ("EzCabinetDAO_h.modifyItem", itemVO);
	}
	
	public List<SimpleUserVO> getAncestorShareUserList(Map<String, Object> map) {
		return (List<SimpleUserVO>)list("EzCabinetDAO_h.getAncestorShareUserList", map);
	}

	public void deleteShareUserList(Map<String, Object> map) {
		delete("EzCabinetDAO_h.deleteShareList", map);
	}

	public void modifyShareUserList(Map<String, Object> map) {
		update("EzCabinetDAO_h.modifyShareUserList", map);
	}
}
