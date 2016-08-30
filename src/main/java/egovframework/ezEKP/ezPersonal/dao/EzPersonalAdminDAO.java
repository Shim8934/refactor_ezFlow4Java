package egovframework.ezEKP.ezPersonal.dao;

import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.rte.psl.dataaccess.EgovAbstractDAO;

@Repository("EzPersonalAdminDAO")
public class EzPersonalAdminDAO extends EgovAbstractDAO{

	public Integer getNoticeCount(Map<String, Object> map) {
		select("EzPersonalAdmin.EZSP_GETNOTICECOUNT", map);
		return (Integer) map.get("v_pCount");
	}

}
