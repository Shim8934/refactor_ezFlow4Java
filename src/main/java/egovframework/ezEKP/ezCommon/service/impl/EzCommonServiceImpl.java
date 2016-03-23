package egovframework.ezEKP.ezCommon.service.impl;

import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import egovframework.ezEKP.ezCommon.dao.EzCommonDAO;
import egovframework.ezEKP.ezCommon.service.EzCommonService;

@Service("EzCommonService")
public class EzCommonServiceImpl implements EzCommonService {
	
	@Resource(name = "EzCommonDAO")
	private EzCommonDAO ezCommonDAO;
	
	@Override
	public String getContentInfo(String type, String itemID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PTYPE", type);
		map.put("v_PID", itemID);
		return ezCommonDAO.getContentInfo(map);
	}

}
