package egovframework.ezEKP.ezOrgan.dao;

import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.rte.psl.dataaccess.EgovAbstractDAO;

@Repository("EzOrganDAO")
public class EzOrganDAO extends EgovAbstractDAO {

	public String getPropertyValue(Map<String, Object> map) throws Exception{
		return (String) select("EzOrganDAO.getPropertyValue", map);
	}

	public String getSIPUriList(Map<String, Object> map) throws Exception{
		return (String) select("EzOrganDAO.getSIPUriList", map);
	}

	public String getDeptFullPath(String deptID) throws Exception{
		return (String) select("EzOrganDAO.getDeptFullPath", deptID);
	}

	public String getPropertyList(Map<String, Object> map) {
		return (String) select("EzOrganDAO.getDeptInfo", map);
	}
}
