package egovframework.ezEKP.ezAddress.service;

import java.util.List;

import egovframework.ezEKP.ezAddress.vo.AddressVO;
import egovframework.ezEKP.ezAddress.vo.SimpleAddressVO;

public interface EzAddressService {

	public List<AddressVO> getAddressInfo(String dong) throws Exception;
	public List<SimpleAddressVO> getSimpleAddress(String userId) throws Exception;
	public void setSimpleAddress(String pUserId, String pMailList) throws Exception;
	
}
