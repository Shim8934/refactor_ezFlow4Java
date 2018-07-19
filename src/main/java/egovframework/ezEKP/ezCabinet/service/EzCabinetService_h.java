package egovframework.ezEKP.ezCabinet.service;

import java.util.List;

import egovframework.ezEKP.ezCabinet.vo.CabinetShareVO;
import egovframework.ezEKP.ezWebFolder.vo.SimpleUserVO;

public interface EzCabinetService_h {

	List<CabinetShareVO> getShareUserList(String cabinetId, String userId, String primary, int tenantId) throws Exception;

	List<SimpleUserVO> getDeptMemberList(String deptId, String primary, int startPoint, int listCount, int tenantId) throws Exception;

	int getTotalDeptMembers(String deptId, int tenantId) throws Exception;
	
}
