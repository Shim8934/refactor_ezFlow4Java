package egovframework.ezEKP.ezCabinet.dao;

import java.util.Map;
import org.springframework.stereotype.Repository;
import egovframework.ezEKP.ezCabinet.vo.CompanyCapacityVO;
import egovframework.rte.psl.dataaccess.EgovAbstractDAO;

@Repository("EzCabinetAdminDAO")
public class EzCabinetAdminDAO extends EgovAbstractDAO {
	public CompanyCapacityVO getCompanyCapacity(Map<String, Object> map) {
		return (CompanyCapacityVO)select("EzCabinetAdminDAO.getCompanyCapacity", map);
	}
	
	public void saveCompanyCapacity(Map<String, Object> map) {
		insert("EzCabinetAdminDAO.saveCompanyCapacity", map);
	}
	
}
