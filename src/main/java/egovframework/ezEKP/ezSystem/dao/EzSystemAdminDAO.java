package egovframework.ezEKP.ezSystem.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;
import org.stringtemplate.v4.compiler.CodeGenerator.list_return;
import org.stringtemplate.v4.compiler.STParser.mapExpr_return;

import egovframework.ezEKP.ezSystem.vo.ConnectionInfoVO;
import egovframework.ezEKP.ezSystem.vo.SysParamVO;
import egovframework.rte.psl.dataaccess.EgovAbstractDAO;

@Repository("EzSystemAdminDAO")
public class EzSystemAdminDAO extends EgovAbstractDAO {
	
	@SuppressWarnings("unchecked")
	public List<SysParamVO> getSysParam(int tenantID) throws Exception {
		return (List<SysParamVO>)list("EzSystemAdminDAO.getSysParam", tenantID);
	}
	
	public int updateSysParam(SysParamVO sysParamVO) throws Exception {
		return update("EzSystemAdminDAO.updateSysParam", sysParamVO);
	}
	
	@SuppressWarnings("unchecked")
	public List<ConnectionInfoVO> getLoginHist(Map<String, Object> map) throws Exception {
		return (List<ConnectionInfoVO>) list("EzSystemAdminDAO.getLoginHist", map);
	}
	
	public int getLoginHistCount(Map<String, Object> map) throws Exception {
		return (int) select("EzSystemAdminDAO.getLoginHistCount", map); 
	}
	
	public void deleteLoginHist(Map<String, Object> map) throws Exception {
        delete("EzSystemAdminDAO.deleteLoginHist", map);
    }
	
}
