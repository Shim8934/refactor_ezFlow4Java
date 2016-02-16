package egovframework.ezEKP.ezOrgan.dao;

import java.util.HashMap;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.rte.psl.dataaccess.EgovAbstractDAO;

@Repository("EzOrganDAO")
public class EzOrganDAO extends EgovAbstractDAO {

	Map<String, Object> map = new HashMap<String, Object>();
	
	public String getPropertyValue(String userid, String propName) {
		map.put("v_CN",userid);
		map.put("v_FIELD", propName);
		return (String) select("EzOrganDAO.getPropertyValue", map);
	}

	public String getSIPUriList(String pCNList, String eMailList) {
		map.put("iv_CNLIST", pCNList);
		map.put("iv_EMAILLIST", eMailList);
		return (String) select("EzOrganDAO.getSIPUriList", map);
	}
	
}
