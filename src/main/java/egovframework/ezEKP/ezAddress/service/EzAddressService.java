package egovframework.ezEKP.ezAddress.service;

import java.util.List;
import egovframework.ezEKP.ezAddress.vo.AddressVO;

public interface EzAddressService {

	public List<AddressVO> getAddressInfo(String dong) throws Exception;
		
 
}
