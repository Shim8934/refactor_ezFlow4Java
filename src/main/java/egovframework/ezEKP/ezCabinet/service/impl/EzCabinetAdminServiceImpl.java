package egovframework.ezEKP.ezCabinet.service.impl;

import java.util.HashMap;
import java.util.Map;
import javax.annotation.Resource;
import org.springframework.stereotype.Service;
import egovframework.ezEKP.ezCabinet.dao.EzCabinetAdminDAO;
import egovframework.ezEKP.ezCabinet.service.EzCabinetAdminService;
import egovframework.ezEKP.ezCabinet.vo.CompanyCapacityVO;

@Service
public class EzCabinetAdminServiceImpl implements EzCabinetAdminService{
	@Resource(name = "EzCabinetAdminDAO")
	private EzCabinetAdminDAO ezCabinetAdminDAO;
	
	@Override
	public CompanyCapacityVO getCompanyCapacity(String companyId, int tenantId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("companyId", companyId);
		map.put("tenantId",  tenantId);
		CompanyCapacityVO result = ezCabinetAdminDAO.getCompanyCapacity(map);
		
		if (result == null) {
			result = new CompanyCapacityVO(companyId, "0", tenantId);
		}
		
		return result;
	}

	@Override
	public void saveCompanyCapacity(String newValue, String companyId, int tenantId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("capacity",  newValue);
		map.put("companyId", companyId);
		map.put("tenantId",  tenantId);
		ezCabinetAdminDAO.saveCompanyCapacity(map);
	}

}
