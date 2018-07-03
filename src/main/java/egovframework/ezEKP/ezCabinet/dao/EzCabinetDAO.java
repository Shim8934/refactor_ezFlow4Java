package egovframework.ezEKP.ezCabinet.dao;

import java.util.List;
import java.util.Map;
import org.springframework.stereotype.Repository;
import egovframework.ezEKP.ezCabinet.vo.CabinetModuleVO;
import egovframework.ezEKP.ezCabinet.vo.SimpleDeptVO;
import egovframework.rte.psl.dataaccess.EgovAbstractDAO;

@SuppressWarnings("unchecked")
@Repository("EzCabinetDAO")
public class EzCabinetDAO extends EgovAbstractDAO {
	public List<SimpleDeptVO> getAllSimpleDeptsOfCompany(Map<String, Object> map) {
		return (List<SimpleDeptVO>)list("EzCabinetDAO.getAllSimpleDeptsOfCompany", map);
	}
	
	public String getDeptPath(Map<String, Object> map) {
		return (String)select("EzCabinetDAO.getDeptPath", map);
	}
	
	public SimpleDeptVO getSimpleCompany(Map<String, Object> map) {
		return (SimpleDeptVO)select("EzCabinetDAO.getSimpleCompany", map);
	}
	
	public List<SimpleDeptVO> getAllSimpleSubDepts(Map<String, Object> map) {
		return (List<SimpleDeptVO>)list("EzCabinetDAO.getAllSimpleSubDepts", map);
	}
	
	public List<CabinetModuleVO> getModuleListForUser(Map<String, Object> map) {
		return (List<CabinetModuleVO>)list("EzCabinetDAO.getModuleListForUser", map);
	}
	
	public List<CabinetModuleVO> getActiveModuleListForUser(Map<String, Object> map) {
		return (List<CabinetModuleVO>)list("EzCabinetDAO.getActiveModuleListForUser", map);
	}

	public void saveModulesSetting(Map<String, Object> map) {
		insert("EzCabinetDAO.saveModulesSetting", map);
	}

}
