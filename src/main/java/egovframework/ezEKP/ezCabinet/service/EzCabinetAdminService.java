package egovframework.ezEKP.ezCabinet.service;

import egovframework.ezEKP.ezCabinet.vo.CompanyCapacityVO;

public interface EzCabinetAdminService {
	//Company capacity
	CompanyCapacityVO getCompanyCapacity(String companyId, int tenantId) throws Exception;
	void saveCompanyCapacity(String newValue, String companyId, int tenantId) throws Exception;

}
