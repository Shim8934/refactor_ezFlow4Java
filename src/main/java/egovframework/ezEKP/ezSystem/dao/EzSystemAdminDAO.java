package egovframework.ezEKP.ezSystem.dao;

import java.util.List;

import org.springframework.stereotype.Repository;

import egovframework.ezEKP.ezSystem.vo.SysParamVO;
import egovframework.rte.psl.dataaccess.EgovAbstractDAO;

@Repository("EzSystemAdminDAO")
public class EzSystemAdminDAO extends EgovAbstractDAO {
	@SuppressWarnings("unchecked")
	public List<SysParamVO> getSysParam(int tenantID){
		return (List<SysParamVO>)list("EzSystemAdminDAO.getSysParam",tenantID);
	}
	public int updateSysParam(List<SysParamVO> list){
		return update("");
	}
}
