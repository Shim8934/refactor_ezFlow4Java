package egovframework.ezEKP.ezCabinet.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.ezEKP.ezCabinet.vo.CabinetShareVO;
import egovframework.ezEKP.ezWebFolder.vo.SimpleUserVO;
import egovframework.rte.psl.dataaccess.EgovAbstractDAO;

@SuppressWarnings("unchecked")
@Repository("EzCabinetDAO_h")
public class EzCabinetDAO_h extends EgovAbstractDAO {
	
	public List<SimpleUserVO> getDeptMemberList(Map<String, Object> map) {
		return (List<SimpleUserVO>)list("EzCabinetDAO_h.getDeptMemberList", map);
	}
	
	public List<CabinetShareVO> getShareUserList(Map<String, Object> map) {
		return (List<CabinetShareVO>) list("EzCabinetDAO_h.getShareUserList", map);
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

}
