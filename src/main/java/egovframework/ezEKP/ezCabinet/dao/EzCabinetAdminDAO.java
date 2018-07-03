package egovframework.ezEKP.ezCabinet.dao;

import java.util.List;
import java.util.Map;
import org.springframework.stereotype.Repository;
import egovframework.ezEKP.ezCabinet.vo.CompanyCapacityVO;
import egovframework.ezEKP.ezCabinet.vo.UserCapacityVO;
import egovframework.rte.psl.dataaccess.EgovAbstractDAO;

@Repository("EzCabinetAdminDAO")
public class EzCabinetAdminDAO extends EgovAbstractDAO {
	public CompanyCapacityVO getCompanyCapacity(Map<String, Object> map) {
		return (CompanyCapacityVO)select("EzCabinetAdminDAO.getCompanyCapacity", map);
	}
	
	public void saveCompanyCapacity(Map<String, Object> map) {
		insert("EzCabinetAdminDAO.saveCompanyCapacity", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<UserCapacityVO> getListUserCapacity(Map<String, Object> map) {
		return (List<UserCapacityVO>)list("EzCabinetAdminDAO.getListUserCapacity", map);
	}
	
	public int getTotalListUserCapacity(Map<String, Object> map) {
		return (int)select("EzCabinetAdminDAO.getTotalListUserCapacity", map);
	}
	
	public void changeUserCapacity(Map<String, Object> map) {
		insert("EzCabinetAdminDAO.changeUserCapacity", map);
	}
	
}
