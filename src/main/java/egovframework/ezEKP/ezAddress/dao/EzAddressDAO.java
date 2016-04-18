package egovframework.ezEKP.ezAddress.dao;

import java.util.List;

import org.springframework.stereotype.Repository;

import egovframework.ezEKP.ezAddress.vo.AddressVO;
import egovframework.rte.psl.dataaccess.EgovAbstractDAO;

@Repository("EzAddressDAO")
public class EzAddressDAO extends EgovAbstractDAO {

	@SuppressWarnings("unchecked")
	public List<AddressVO> getAddressInfo(String dong) throws Exception{
		return (List<AddressVO>) list("EzAddressDAO.getAddressInfo", dong);
	}
		
}