package egovframework.ezEKP.ezCabinet.dao;

import java.util.List;
import java.util.Map;
import org.springframework.stereotype.Repository;
import egovframework.ezEKP.ezCabinet.vo.SimpleDeptVO;
import egovframework.rte.psl.dataaccess.EgovAbstractDAO;

@Repository("EzCabinetDAO")
public class EzCabinetDAO extends EgovAbstractDAO {
	@SuppressWarnings("unchecked")
	public List<SimpleDeptVO> getAllSimpleDeptsOfCompany(Map<String, Object> map) {
		return (List<SimpleDeptVO>)list("EzCabinetDAO.getAllSimpleDeptsOfCompany", map);
	}

	public String getDeptPath(Map<String, Object> map) {
		return (String)select("EzCabinetDAO.getDeptPath", map);
	}

	public SimpleDeptVO getSimpleCompany(Map<String, Object> map) {
		return (SimpleDeptVO)select("EzCabinetDAO.getSimpleCompany", map);
	}

	@SuppressWarnings("unchecked")
	public List<SimpleDeptVO> getAllSimpleSubDepts(Map<String, Object> map) {
		return (List<SimpleDeptVO>)list("EzCabinetDAO.getAllSimpleSubDepts", map);
	}

}
