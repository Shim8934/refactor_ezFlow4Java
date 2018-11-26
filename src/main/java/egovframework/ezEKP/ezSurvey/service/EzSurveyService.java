package egovframework.ezEKP.ezSurvey.service;

import java.util.List;
import egovframework.ezEKP.ezSurvey.vo.SimpleDeptVO;

public interface EzSurveyService {
	//Company Tree process functions
	List<SimpleDeptVO> getAllSubDepts(String companyId, int level, String primary, int tenantId) throws Exception;
	String getDeptPath(String deptId, int tenantId) throws Exception;
	SimpleDeptVO getSimpleCompany(String deptId, int level, String primary, int tenantId) throws Exception;
	void getAllDepts(SimpleDeptVO sDept, String[] path, String primary, int tenantId, int order, int level);
}
