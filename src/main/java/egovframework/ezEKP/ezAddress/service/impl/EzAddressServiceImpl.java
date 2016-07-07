package egovframework.ezEKP.ezAddress.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import egovframework.ezEKP.ezAddress.dao.EzAddressDAO;
import egovframework.ezEKP.ezAddress.service.EzAddressService;
import egovframework.ezEKP.ezAddress.vo.AddressVO;
import egovframework.ezEKP.ezAddress.vo.SimpleAddressVO;

@Service("EzAddressService")
public class EzAddressServiceImpl implements EzAddressService {
	
	@Resource(name = "EzAddressDAO")
	private EzAddressDAO ezAddressDAO;

	@Override
	public List<AddressVO> getAddressInfo(String dong) throws Exception {
		return ezAddressDAO.getAddressInfo(dong);
	}

	@Override
	public List<SimpleAddressVO> getSimpleAddress(String userId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();		
		map.put("v_PUSERID", userId);
		
		return ezAddressDAO.getSimpleAddress(map);
	}

	@Override
	public void setSimpleAddress(String pUserId, String pMailList) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_USERID", pUserId);
		map.put("v_SN", 0);
		map.put("v_NAME", "");
		map.put("v_EMAIL", "");
		map.put("v_STATUS", 1);
		
		ezAddressDAO.setSimpleAddress(map);
		
		String[] mailList = pMailList.split("\\|");
		
		for (int i=0; i<mailList.length; i++) {
			map = new HashMap<String, Object>();
			map.put("v_USERID", pUserId);
			map.put("v_SN", i);
			map.put("v_NAME", mailList[i].split(";")[0]);
			map.put("v_EMAIL", mailList[i].split(";")[1]);
			map.put("v_STATUS", 0);
			
			ezAddressDAO.setSimpleAddress(map);
			
		}
	}
	
	
	
}
