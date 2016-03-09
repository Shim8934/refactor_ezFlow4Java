package egovframework.ezEKP.ezOrgan.service.impl;

import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import egovframework.ezEKP.ezOrgan.dao.EzOrganDAO;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;

@Service("EzOrganService")
public class EzOrganServiceImpl implements EzOrganService {
	
	@Resource(name = "EzOrganDAO")
	EzOrganDAO ezOrganDAO;
	
	Map<String, Object> map = new HashMap<String, Object>();

	@Override
	public String getPropertyValue(String userid, String propName) throws Exception{
		map.put("v_CN",userid);
		map.put("v_FIELD", propName);
		return ezOrganDAO.getPropertyValue(map);
	}

	@Override
	public String getSIPUriList(String pCNList, String eMailList) throws Exception{
		map.put("iv_CNLIST", pCNList);
		map.put("iv_EMAILLIST", eMailList);
		return ezOrganDAO.getSIPUriList(map);
	}

	@Override
	public String getDeptFullPath(String deptID) throws Exception {
		return ezOrganDAO.getDeptFullPath(deptID);
	}

	@Override
	public String getPropertyList(String userID,  String primary) throws Exception {
		map.put("userID", userID);
		map.put("primary", primary);
		return ezOrganDAO.getPropertyList(map);
	}
	
}
