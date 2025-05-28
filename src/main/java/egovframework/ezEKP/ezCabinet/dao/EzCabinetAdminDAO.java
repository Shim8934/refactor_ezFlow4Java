package egovframework.ezEKP.ezCabinet.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.ezEKP.ezCabinet.vo.CabinetModuleVO;
import egovframework.ezEKP.ezCabinet.vo.CompanyCapacityVO;
import egovframework.ezEKP.ezCabinet.vo.UserCapacityVO;
import org.egovframe.rte.psl.dataaccess.EgovAbstractDAO;

@SuppressWarnings("unchecked")
@Repository("EzCabinetAdminDAO")
public class EzCabinetAdminDAO extends EgovAbstractDAO {
	public CompanyCapacityVO getCompanyCapacity(Map<String, Object> map) {
		return (CompanyCapacityVO)select("EzCabinetAdminDAO.getCompanyCapacity", map);
	}
	
	public void saveCompanyCapacity(Map<String, Object> map) {
		insert("EzCabinetAdminDAO.saveCompanyCapacity", map);
	}
	
	public List<UserCapacityVO> getListUserCapacity(Map<String, Object> map) {
		return (List<UserCapacityVO>)list("EzCabinetAdminDAO.getListUserCapacity", map);
	}
	
	public int getTotalListUserCapacity(Map<String, Object> map) {
		return (int)select("EzCabinetAdminDAO.getTotalListUserCapacity", map);
	}
	
	public void changeUserCapacity(Map<String, Object> map) {
		insert("EzCabinetAdminDAO.changeUserCapacity", map);
	}
	
	public void deleteUserCapacity(Map<String, Object> map) {
		delete("EzCabinetAdminDAO.deleteUserCapacity", map);
	}
	
	public List<CabinetModuleVO> getModuleListForAdmin(Map<String, Object> map) {
		return (List<CabinetModuleVO>)list("EzCabinetAdminDAO.getModuleListForAdmin", map);
	}
	
	public void insertModulForAdmin(CabinetModuleVO module) {
		insert("EzCabinetAdminDAO.insertModulForAdmin", module);
	}
	
	public void saveModulesSetting(Map<String, Object> map) {
		update("EzCabinetAdminDAO.saveModulesSetting", map);
	}
	
	public UserCapacityVO getUserCapacity(Map<String, Object> map) {
		return (UserCapacityVO)select("EzCabinetAdminDAO.getUserCapacity", map);
	}
}
