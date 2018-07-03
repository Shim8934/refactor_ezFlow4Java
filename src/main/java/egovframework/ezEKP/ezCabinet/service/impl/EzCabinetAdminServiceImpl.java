package egovframework.ezEKP.ezCabinet.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.annotation.Resource;
import org.springframework.stereotype.Service;
import egovframework.ezEKP.ezCabinet.dao.EzCabinetAdminDAO;
import egovframework.ezEKP.ezCabinet.service.EzCabinetAdminService;
import egovframework.ezEKP.ezCabinet.vo.CompanyCapacityVO;
import egovframework.ezEKP.ezCabinet.vo.UserCapacityVO;

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
			result = new CompanyCapacityVO(companyId, 1, "0", tenantId);
		}
		
		return result;
	}

	@Override
	public void saveCompanyCapacity(int type, String newValue, String companyId, int tenantId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("type",      type);
		map.put("capacity",  newValue);
		map.put("companyId", companyId);
		map.put("tenantId",  tenantId);
		ezCabinetAdminDAO.saveCompanyCapacity(map);
	}

	@Override
	public List<UserCapacityVO> getListUserCapacity(String realColmn, String order, String companyId, String searchStr, String searchOpt, int startPoint, int listCnt, int tenantId, String primary) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("realColmn",  realColmn);
		map.put("order",      order);
		map.put("companyId",  companyId);
		map.put("searchStr",  searchStr);
		map.put("searchOpt",  searchOpt);
		map.put("startPoint", startPoint);
		map.put("listCnt",    listCnt);
		map.put("tenantId",   tenantId);
		map.put("primary",    primary);
		return ezCabinetAdminDAO.getListUserCapacity(map);
	}

	@Override
	public int getTotalListUserCapacity(String companyId, String searchStr, String searchOpt, int tenantId, String primary) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("companyId", companyId);
		map.put("searchStr", searchStr);
		map.put("searchOpt", searchOpt);
		map.put("tenantId",  tenantId);
		map.put("primary",   primary);
		return ezCabinetAdminDAO.getTotalListUserCapacity(map);
	}

	@Override
	public void changeUserCapacity(List<String> userList, String newValue, int type, String companyId, int tenantId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("capacity",  newValue);
		map.put("capatype",  type);
		map.put("companyId", companyId);
		map.put("tenantId",  tenantId);
		map.put("userList",  userList);
		
		ezCabinetAdminDAO.changeUserCapacity(map);
	}

}
