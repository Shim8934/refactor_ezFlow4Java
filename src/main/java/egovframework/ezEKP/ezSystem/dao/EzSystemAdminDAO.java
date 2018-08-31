package egovframework.ezEKP.ezSystem.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;
import org.stringtemplate.v4.compiler.CodeGenerator.list_return;
import org.stringtemplate.v4.compiler.STParser.mapExpr_return;

import egovframework.ezEKP.ezOrgan.vo.OrganUserVO;
import egovframework.ezEKP.ezSystem.vo.AccessIdVO;
import egovframework.ezEKP.ezSystem.vo.ConnectionInfoVO;
import egovframework.ezEKP.ezSystem.vo.IPBandVO;
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
	
	public void updateSystemIPAllow(Map<String, Object> map) throws Exception {
		update("EzSystemAdminDAO.updateSystemIPAllow", map);
    }
	
	@SuppressWarnings("unchecked")
	public List<IPBandVO> getAllIPBand(int tenantID) throws Exception {
	    return (List<IPBandVO>) list("EzSystemAdminDAO.getSystemAllIPBand", tenantID);
    }
	
	public void insertIPBand(Map<String, Object> map) throws Exception {
		insert("EzSystemAdminDAO.insertIPBand", map);
	}
	
	public IPBandVO getSystemIPBand(String ipNo) throws Exception {
		return (IPBandVO) select("EzSystemAdminDAO.getSystemIPBand", ipNo);
	}
	
	public void updateIPBand(Map<String, Object> map) throws Exception {
		update("EzSystemAdminDAO.updateIPBand", map);
	}
	
	public void deleteIPBand(List<String> ipNoList) throws Exception {
		delete ("EzSystemAdminDAO.deleteIPBand", ipNoList);
	}
	
	@SuppressWarnings("unchecked")
	public List<AccessIdVO> getAllAccessList(Map<String, Object> map) throws Exception {
		return (List<AccessIdVO>) list("EzSystemAdminDAO.getAllAccessList", map);
    }
	
	@SuppressWarnings("unchecked")
	public List<AccessIdVO> getAllAccessList2(Map<String, Object> map) throws Exception {
		return (List<AccessIdVO>) list("EzSystemAdminDAO.getAllAccessList2", map);
    }
	
	@SuppressWarnings("unchecked")
	public List<AccessIdVO> getAllAccessListDept(Map<String, Object> map) throws Exception {
		return (List<AccessIdVO>) list("EzSystemAdminDAO.getAllAccessListDept", map);
    }
	
	@SuppressWarnings("unchecked")
	public List<AccessIdVO> getAllAccessListDept2(Map<String, Object> map) throws Exception {
		return (List<AccessIdVO>) list("EzSystemAdminDAO.getAllAccessListDept2", map);
    }
	
	public void deleteAccessId(List<String> accessNoList) throws Exception {
		delete ("EzSystemAdminDAO.deleteAccessId", accessNoList);
	}
	
}
