package egovframework.ezEKP.ezCabinet.service;

import egovframework.ezEKP.ezCabinet.vo.SimpleDeptVO;

public interface EzCabinetService {
	//Company Tree process functions
	SimpleDeptVO getAllDepts(String companyId, int level, String primary, int tenantId) throws Exception;
	String getDeptPath(String deptId, int tenantId) throws Exception;
	SimpleDeptVO getSimpleCompany(String deptId, int level, String primary, int tenantId) throws Exception;
	void getAllDepts(SimpleDeptVO sDept, String[] path, String primary, int tenantId, int order, int level) throws Exception;
}
