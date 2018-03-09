package egovframework.ezEKP.ezAttitude.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.ezEKP.ezAttitude.vo.AttitudeDeptVO;
import egovframework.ezEKP.ezAttitude.vo.AttitudeUserConfigVO;
import egovframework.ezEKP.ezAttitude.vo.AttitudeConfigVO;
import egovframework.rte.psl.dataaccess.EgovAbstractDAO;

@Repository("EzAttitudeDAO")
public class EzAttitudeDAO extends EgovAbstractDAO{
	
	@SuppressWarnings("unchecked")
	public List<AttitudeDeptVO> getCompanyList(Map<String, Object> map) throws Exception{
		return (List<AttitudeDeptVO>) list("ezAttitudeAdminDAO.getCompanyList", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<AttitudeUserConfigVO> getAttitudeUserConfigList(Map<String, Object> map) throws Exception{
		return (List<AttitudeUserConfigVO>) list("ezAttitudeAdminDAO.getAttitudeUserConfigList", map);
	}

	@SuppressWarnings("unchecked")
	public AttitudeConfigVO getAttitudeConfig(Map<String, Object> map) throws Exception{
		return (AttitudeConfigVO) select("ezAttitudeAdminDAO.getAttitudeConfig", map);
	}

	public void updateAttitudeConfig(Map<String, Object> map) {
		update("ezAttitudeAdminDAO.updateAttitudeConfig", map);
	}

}
