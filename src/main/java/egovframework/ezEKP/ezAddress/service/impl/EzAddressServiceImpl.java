package egovframework.ezEKP.ezAddress.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import egovframework.ezEKP.ezAddress.dao.EzAddressDAO;
import egovframework.ezEKP.ezAddress.service.EzAddressService;
import egovframework.ezEKP.ezAddress.vo.AddressVO;

@Service("EzAddressService")
public class EzAddressServiceImpl implements EzAddressService {
	
	@Resource(name = "EzAddressDAO")
	private EzAddressDAO ezAddressDAO;

	@Override
	public List<AddressVO> getAddressInfo(String dong) throws Exception {
		return ezAddressDAO.getAddressInfo(dong);
	}
	
	
	
}
