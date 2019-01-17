package egovframework.ezEKP.ezSystem.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

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
	public List<AccessIdVO> getAllAccessListDept(Map<String, Object> map) throws Exception {
		return (List<AccessIdVO>) list("EzSystemAdminDAO.getAllAccessListDept", map);
    }
	
	@SuppressWarnings("unchecked")
	public List<String> getAllAccessListUserCompare(int tenantID) throws Exception {
		return (List<String>) list("EzSystemAdminDAO.getAllAccessListUserCompare", tenantID);
    }
	
	@SuppressWarnings("unchecked")
	public List<String> getAllAccessListDeptCompare(int tenantID) throws Exception {
		return (List<String>) list("EzSystemAdminDAO.getAllAccessListDeptCompare", tenantID);
    }
	
	
	public void deleteAccessId(List<String> accessNoList) throws Exception {
		delete ("EzSystemAdminDAO.deleteAccessId", accessNoList);
	}
	
	public void insertAccessId(Map<String, Object> map) throws Exception {
		insert("EzSystemAdminDAO.insertAccessId", map);
	}
	
	public long selectModuleSize(String tableNames, String notTableNames) throws Exception {
		Map<String, String> paramMap = new HashMap<String, String>();
		paramMap.put("tableNames", tableNames);
		paramMap.put("notTableNames", notTableNames);
		
		return (long) select("EzSystemAdminDAO.selectModuleSize", paramMap);
	}
	
	public void deleteWebfolderLog(Map<String, Object> map) throws Exception {
        delete("EzSystemAdminDAO.deleteWebfolderLog", map);
    }

	public void insertMultiLogintype(Map<String, Object> paramMap) throws Exception {
		insert("EzSystemAdminDAO.insertMultiLoginType", paramMap);
	}
	
	public void updateMultiLogintype(Map<String, Object> paramMap) throws Exception {
		insert("EzSystemAdminDAO.updateMultiLoginType", paramMap);
	}

}
