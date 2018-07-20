package egovframework.ezEKP.ezCabinet.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.ezEKP.ezCabinet.vo.CabinetItemVO;
import egovframework.ezEKP.ezCabinet.vo.CabinetShareVO;
import egovframework.ezEKP.ezWebFolder.vo.SimpleUserVO;
import egovframework.rte.psl.dataaccess.EgovAbstractDAO;

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

	public int isFileCreator(Map<String, Object> map) {
		return (int)select("EzCabinetDAO_h.isFileCreator", map);
	}

	public CabinetItemVO getFileDetail(Map<String, Object> map) {
		return (CabinetItemVO)select("EzCabinetDAO_h.getFileDetail", map);
	}

}
