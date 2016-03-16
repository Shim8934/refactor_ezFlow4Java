package egovframework.ezEKP.ezOrgan.service.impl;

import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import egovframework.ezEKP.ezOrgan.dao.EzOrganDAO;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.ezEKP.ezOrgan.vo.OrganDeptVO;

@Service("EzOrganService")
public class EzOrganServiceImpl implements EzOrganService {
	
	@Resource(name = "EzOrganDAO")
	private EzOrganDAO ezOrganDAO;
	
	@Override
	public String getPropertyValue(String userid, String propName) throws Exception{
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_CN",userid);
		map.put("v_FIELD", propName);
		return ezOrganDAO.getPropertyValue(map);
	}

	@Override
	public String getSIPUriList(String pCNList, String eMailList) throws Exception{
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("iv_CNLIST", pCNList);
		map.put("iv_EMAILLIST", eMailList);
		return ezOrganDAO.getSIPUriList(map);
	}

	@Override
	public String getDeptFullPath(String deptID) throws Exception {
		return ezOrganDAO.getDeptFullPath(deptID);
	}

	@Override
	public OrganDeptVO getPropertyList(String userID,  String primary) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userID", userID);
		map.put("primary", primary);
		return ezOrganDAO.getPropertyList(map);
	}
	
}
