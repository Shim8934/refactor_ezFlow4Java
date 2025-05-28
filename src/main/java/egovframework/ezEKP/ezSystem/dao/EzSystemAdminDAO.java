package egovframework.ezEKP.ezSystem.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.ezEKP.ezSystem.vo.AccessIdVO;
import egovframework.ezEKP.ezSystem.vo.ConnectionInfoVO;
import egovframework.ezEKP.ezSystem.vo.DeptChangeInfoVO;
import egovframework.ezEKP.ezSystem.vo.IPBandVO;
import egovframework.ezEKP.ezSystem.vo.PasswordPolicyVO;
import egovframework.ezEKP.ezSystem.vo.PermissionInfoVO;
import egovframework.ezEKP.ezSystem.vo.SysParamVO;
import egovframework.ezEKP.ezSystem.vo.SystemConfigTypeVO;
import egovframework.ezEKP.ezSystem.vo.SystemConfigVO;
import egovframework.ezEKP.ezSystem.vo.UserChangeInfoVO;
import egovframework.let.main.vo.MainVO;
import org.egovframe.rte.psl.dataaccess.EgovAbstractDAO;

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

	@SuppressWarnings("unchecked")
	public List<ConnectionInfoVO> getLoginHistNotAdmin(Map<String, Object> map) throws Exception {
		return (List<ConnectionInfoVO>) list("EzSystemAdminDAO.getLoginHistNotAdmin", map);
	}
	
	public int getLoginHistCount(Map<String, Object> map) throws Exception {
		return (int) select("EzSystemAdminDAO.getLoginHistCount", map); 
	}

	public int getLoginHistCountNotAdmin(Map<String, Object> map) throws Exception {
		return (int) select("EzSystemAdminDAO.getLoginHistCountNotAdmin", map); 
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
	
	public void updateMenuChange(Map<String, Object> paramMap) throws Exception {
		update("EzSystemAdminDAO.updateMenuChange", paramMap);
	}
	
	public String getAccessCountryList(Map<String, Object> paramMap) throws Exception {
		return (String) select("EzSystemAdminDAO.getAccessCountryList", paramMap);
	}
		
	public void setAccessCountry(Map<String, Object> paramMap) throws Exception {
		insert("EzSystemAdminDAO.setAccessCountry", paramMap);
	}
	
	public int updateAccessCountry(Map<String, Object> paramMap) throws Exception {
		return update("EzSystemAdminDAO.updateAccessCountry", paramMap);
	}
	
	public int updateSystemAdminIPAllow(SysParamVO sysParamVO) throws Exception {
		return update("EzSystemAdminDAO.updateSysParam", sysParamVO);
    }
	
	@SuppressWarnings("unchecked")
	public List<IPBandVO> getAdminAccessIPBand(int tenantID) throws Exception {
	    return (List<IPBandVO>) list("EzSystemAdminDAO.getAdminAccessIPBand", tenantID);
    }
	
	public void insertAdminIPBand(Map<String, Object> map) throws Exception {
		insert("EzSystemAdminDAO.insertAdminIPBand", map);
	}
 
	public IPBandVO getSystemAdminIPBand(String ipNo) throws Exception {
		int pIpNo = Integer.parseInt(ipNo);
		
		return (IPBandVO) select("EzSystemAdminDAO.getSystemAdminIPBand", pIpNo);
	}
	
	public void updateAdminIPBand(Map<String, Object> map) throws Exception {
		update("EzSystemAdminDAO.updateAdminIPBand", map);
	}

	public Integer isExistSystemAdminIPBand(List<String> ipNoList) throws Exception {
		return (Integer) select ("EzSystemAdminDAO.isExistSystemAdminIPBand", ipNoList);
	}

	public void deleteAdminIPBand(List<String> ipNoList) throws Exception {
		delete ("EzSystemAdminDAO.deleteAdminIPBand", ipNoList);
	}
	
	@SuppressWarnings("unchecked")
	public Map<String, String> getPwPolicy(Map<String, Object> paramMap) throws Exception {
		return (Map<String, String>) select("EzSystemAdminDAO.getPwPolicy", paramMap);
	}
	
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getPwPolicyPattern(Map<String, Object> paramMap) throws Exception {
		return (List<Map<String, Object>>) list("EzSystemAdminDAO.getPwPolicyPattern", paramMap);
	}

	public int insertPwPolicy(PasswordPolicyVO pwPolicyVo) throws Exception {
		return update("EzSystemAdminDAO.insertPwPolicy", pwPolicyVo);
	}

	public int insertPwPolicyPattern(Map<String, Object> paramMap) throws Exception {
		return update("EzSystemAdminDAO.insertPwPolicyPattern", paramMap);
	}

	public int updatePwPolicy(PasswordPolicyVO pwPolicyVo) throws Exception {
		return update("EzSystemAdminDAO.updatePwPolicy", pwPolicyVo);
	}
	
	public int deletePwPolicyPattern(Map<String, Object> paramMap) throws Exception {
		return update("EzSystemAdminDAO.deletePwPolicyPattern", paramMap);
	}
	
	public int updateCompanyConfigParam(SysParamVO sysParamVO) throws Exception {
		return update("EzSystemAdminDAO.updateCompanyConfigParam", sysParamVO);
	}

	public int insertCompanyConfigParam(SysParamVO sysParamVO) throws Exception {
		return update("EzSystemAdminDAO.insertCompanyConfigParam", sysParamVO);
	}
	@SuppressWarnings("unchecked")
	public List<MainVO> getAdminAccessHist(Map<String, Object> map) throws Exception {
		return (List<MainVO>) list("EzSystemAdminDAO.getAdminAccessHist", map);
	}
	
	public int getAdminAccessHistCount(Map<String, Object> map) throws Exception {
		return (int) select("EzSystemAdminDAO.getAdminAccessHistCount", map); 
	}

	@SuppressWarnings("unchecked")
	public List<PermissionInfoVO> getPermissionChHist(Map<String, Object> map) throws Exception {
		return (List<PermissionInfoVO>) list("EzSystemAdminDAO.getPermissionChHist", map);
	}

	@SuppressWarnings("unchecked")
	public int getPermissionChHistCount(Map<String, Object> map) throws Exception {
		return (int) select("EzSystemAdminDAO.getPermissionChHistCount", map);
	}

	public String getFileExtension(int tenentID) throws  Exception {
		return (String) select("EzSystemAdminDAO.getFileExtension", tenentID);
	}

	public void updateFileExtension(Map<String,Object> map) throws Exception {
		update("EzSystemAdminDAO.updateFileExtension", map);
	}
	
	public void insertUserChangeHist(UserChangeInfoVO userChangeInfoVO) throws Exception{
		insert("EzSystemAdminDAO.insertUserChangeHist", userChangeInfoVO);
	}
	
	@SuppressWarnings("unchecked")
	public List<UserChangeInfoVO> getUserChHistList(Map<String, Object> map) throws Exception{
		return (List<UserChangeInfoVO>) list("EzSystemAdminDAO.getUserChHistList", map);
	}
	
	public int getUserChHistListCount(Map<String, Object> map) throws Exception{
		return (int) select("EzSystemAdminDAO.getUserChHistListCount", map);
	}

	@SuppressWarnings("unchecked")
	public List<DeptChangeInfoVO> getDeptChHistList(Map<String, Object> map) throws Exception {
		return (List<DeptChangeInfoVO>) list("EzSystemAdminDAO.getDeptChHistList", map);
	}

	public int getDeptChHistListCount(Map<String, Object> map) throws Exception {
		return (int) select("EzSystemAdminDAO.getDeptChHistListCount", map);
	}

	public void insertDeptChangeHist(DeptChangeInfoVO deptChangeInfoVO) throws Exception {
		insert("EzSystemAdminDAO.insertDeptChangeHist", deptChangeInfoVO);
	}

	@SuppressWarnings("unchecked")
	public List<ConnectionInfoVO> getConnectorList(Map<String, Object> map) throws Exception {
		return (List<ConnectionInfoVO>) list("EzSystemAdminDAO.getConnectorList", map);
	}

	public int getConnectorListCount(Map<String, Object> map) throws Exception {
		return (int) select("EzSystemAdminDAO.getConnectorListCount", map);
	}
	public void updateResetThemeAllCompany() throws Exception {
		update("EzSystemAdminDAO.updateResetThemeAllCompany");
	}

	public void deleteThemeAllUser() throws Exception {
		delete("EzSystemAdminDAO.deleteThemeAllUser");
	}

	public void updateResetThemeAllUser() throws Exception {
		update("EzSystemAdminDAO.updateResetThemeAllUser");
	}

	public void deletePortletAllUser() throws Exception {
		delete("EzSystemAdminDAO.deletePortletAllUser");
	}

	public void deletePortletSizeAllUser() throws Exception {
		delete("EzSystemAdminDAO.deletePortletSizeAllUser");
	}
	
	public int getSystemConfigListCount(Map<String, Object> map) throws Exception {
		return (int) select("EzSystemAdminDAO.getSystemConfigListCount", map);
	}
	
	public int getSystemConfigListCountPopup(Map<String, Object> map) throws Exception {
		return (int) select("EzSystemAdminDAO.getSystemConfigListCountPopup", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<SystemConfigVO> getSystemConfigList (Map<String, Object> map) throws Exception {
		return (List<SystemConfigVO>) list("EzSystemAdminDAO.getSystemConfigList", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<SystemConfigVO> getSystemConfigListPopup (Map<String, Object> map) throws Exception {
		return (List<SystemConfigVO>) list("EzSystemAdminDAO.getSystemConfigListPopup", map);
	}
	
	public SystemConfigVO getSystemConfig(Map<String, Object> map) throws Exception {
		return (SystemConfigVO) select("EzSystemAdminDAO.getSystemConfig", map);
	}
	
	public void deletesyStemConfig(Map<String, Object> map) throws Exception {
		delete("EzSystemAdminDAO.deletesyStemConfig", map);
	}
	
	public void insertStemConfig(Map<String, Object> map) throws Exception {
		insert("EzSystemAdminDAO.insertStemConfig", map);
	}
	
	public void updateStemConfig(Map<String, Object> map) throws Exception {
		update("EzSystemAdminDAO.updateStemConfig", map);
	}

	@SuppressWarnings("unchecked")
	public List<SystemConfigTypeVO> getSystemConfigTypeList(Map<String, Object> map) throws Exception {
		return (List<SystemConfigTypeVO>) list("EzSystemAdminDAO.getSystemConfigTypeList", map);
	}

	public int getSystemConfigTypeListCount(Map<String, Object> map) throws Exception {
		return (int) select("EzSystemAdminDAO.getSystemConfigTypeListCount", map);
	}

	public void deleteSystemConfigType(Map<String, Object> map) throws Exception {
		delete("EzSystemAdminDAO.deleteSystemConfigType", map);
	}

	public int checkDuplicateCode(Map<String, Object> map) throws Exception {
		return (int) select("EzSystemAdminDAO.checkDuplicateCode", map);
	}

	public void deleteSystemConfigByTypeCode(Map<String, Object> map) throws Exception {
		delete("EzSystemAdminDAO.deleteSystemConfigByTypeCode", map);
	}

	public SystemConfigTypeVO getSystemConfigType(Map<String, Object> map) throws Exception {
		return (SystemConfigTypeVO) select("EzSystemAdminDAO.getSystemConfigType", map);
	}

	public int checkDuplicateTypeCode(Map<String, Object> map) throws Exception {
		return (int) select("EzSystemAdminDAO.checkDuplicateTypeCode", map);
	}

	public void insertSystemConfigType(Map<String, Object> map) {
		insert("EzSystemAdminDAO.insertSystemConfigType", map);
	}

	public void updateSystemConfigType(Map<String, Object> map) {
		update("EzSystemAdminDAO.updateSystemConfigType", map);
	}

	public void disableDeleteSystemConfig(Map<String, Object> map) {
		update("EzSystemAdminDAO.disableDeleteSystemConfig", map);
	}

	public List<IPBandVO> getFidoAuthenticList(Map<String, Object> map) throws Exception {
		return (List<IPBandVO>) list("EzSystemAdminDAO.getFidoAuthenticList", map);
	}

	public int getFidoAuthenticInfo(Map<String, Object> map) throws Exception {
		return (int) select("EzSystemAdminDAO.getFidoAuthenticInfo", map);
	}

	public IPBandVO getSystemFidoIPBand(String ipNo) throws Exception {
		int pIpNo = Integer.parseInt(ipNo);

		return (IPBandVO) select("EzSystemAdminDAO.getSystemFidoIPBand", pIpNo);
	}

	public void insertFidoIPBand(Map<String, Object> map) throws Exception{
		insert("EzSystemAdminDAO.insertFidoIPBand", map);
	}

	public void updateFidoIPBand(Map<String, Object> map) throws Exception {
		update("EzSystemAdminDAO.updateFidoIPBand", map);
	}

	public void deleteFidoIPBand(List<String> ipNoList) throws Exception {
		delete ("EzSystemAdminDAO.deleteFidoIPBand", ipNoList);
	}
}
