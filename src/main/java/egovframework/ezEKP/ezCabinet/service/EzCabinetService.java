package egovframework.ezEKP.ezCabinet.service;

import java.util.List;

import org.json.simple.JSONArray;

import egovframework.ezEKP.ezCabinet.vo.CabinetModuleVO;
import egovframework.ezEKP.ezCabinet.vo.SimpleDeptVO;

public interface EzCabinetService {
	//Company Tree process functions
	SimpleDeptVO getAllDepts(String companyId, int level, String primary, int tenantId) throws Exception;
	String getDeptPath(String deptId, int tenantId) throws Exception;
	SimpleDeptVO getSimpleCompany(String deptId, int level, String primary, int tenantId) throws Exception;
	void getAllDepts(SimpleDeptVO sDept, String[] path, String primary, int tenantId, int order, int level) throws Exception;
	
	//User module setting functions
	List<CabinetModuleVO> getModuleListForUser(String userId, String companyId, int tenantId) throws Exception;
	void saveModulesSetting(JSONArray modules, String userId, String companyId, int tenantId) throws Exception;
}
