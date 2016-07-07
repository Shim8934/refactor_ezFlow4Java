package egovframework.ezEKP.ezAddress.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.ezEKP.ezAddress.vo.AddressVO;
import egovframework.ezEKP.ezAddress.vo.SimpleAddressVO;
import egovframework.rte.psl.dataaccess.EgovAbstractDAO;

@Repository("EzAddressDAO")
public class EzAddressDAO extends EgovAbstractDAO {

	@SuppressWarnings("unchecked")
	public List<AddressVO> getAddressInfo(String dong) throws Exception{
		return (List<AddressVO>) list("EzAddressDAO.getAddressInfo", dong);
	}
	
	@SuppressWarnings("unchecked")
	public List<SimpleAddressVO> getSimpleAddress(Map<String, Object> map) throws Exception{
		return (List<SimpleAddressVO>) list("EzAddressDAO.getSimpleAddress", map);
	}

	public void setSimpleAddress(Map<String, Object> map) throws Exception{
		update("EzAddressDAO.setSimpleAddress", map);
	}
	
}