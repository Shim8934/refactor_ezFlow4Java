package egovframework.ezEKP.ezCabinet.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.annotation.Resource;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import egovframework.ezEKP.ezCabinet.dao.EzCabinetDAO_h;
import egovframework.ezEKP.ezCabinet.service.EzCabinetService_h;
import egovframework.ezEKP.ezCabinet.vo.CabinetShareVO;
import egovframework.ezEKP.ezWebFolder.vo.SimpleUserVO;

@Service
public class EzCabinetServiceImpl_h implements EzCabinetService_h{
	
	private static final Logger logger = LoggerFactory.getLogger(EzCabinetServiceImpl_h.class);

	@Resource(name = "EzCabinetDAO_h")
	private EzCabinetDAO_h ezCabinetDAO_h;
	
	@Override
	public List<SimpleUserVO> getDeptMemberList(String deptId, String primary, int startPoint, int listCount, int tenantId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("deptId",     deptId);
		map.put("startPoint", startPoint);
		map.put("listCount",  listCount);
		map.put("primary",    primary);
		map.put("tenantId",   tenantId);
		
		return ezCabinetDAO_h.getDeptMemberList(map);
	}
	
	@Override
	public List<CabinetShareVO> getShareUserList(String cabinetId, String userId, String primary, int tenantId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("cabinetId", cabinetId);
		map.put("userId", userId);
		map.put("primary", primary);
		map.put("tenantId", tenantId);
		
		return ezCabinetDAO_h.getShareUserList(map);
	}
	
	@Override
	public int getTotalDeptMembers(String deptId, int tenantId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("deptId",   deptId);
		map.put("tenantId", tenantId);
		
		return ezCabinetDAO_h.getTotalDeptMembers(map);
	}
	
	
}
