package egovframework.ezEKP.ezCabinet.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.annotation.Resource;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import egovframework.ezEKP.ezCabinet.dao.EzCabinetAdminDAO;
import egovframework.ezEKP.ezCabinet.service.EzCabinetAdminService;
import egovframework.ezEKP.ezCabinet.vo.CabinetModuleVO;
import egovframework.ezEKP.ezCabinet.vo.CompanyCapacityVO;
import egovframework.ezEKP.ezCabinet.vo.UserCapacityVO;
import egovframework.ezEKP.ezCabinet.web.EzCabinetAdminController;

@Service
public class EzCabinetAdminServiceImpl implements EzCabinetAdminService {
	@Resource(name = "EzCabinetAdminDAO")
	private EzCabinetAdminDAO ezCabinetAdminDAO;
	
	private static final Logger logger = LoggerFactory.getLogger(EzCabinetAdminController.class);
	
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
	public void saveCompanyCapacity(int type, int newValue, String companyId, int tenantId) throws Exception {
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
		
		for (String userId : userList) {
			map.put("userId",  userId);
			ezCabinetAdminDAO.changeUserCapacity(map);
		}
	}

	@Override
	public List<CabinetModuleVO> getModuleListForAdmin(String companyId, int tenantId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("companyId", companyId);
		map.put("tenantId",  tenantId);
		
		List<CabinetModuleVO> result = ezCabinetAdminDAO.getModuleListForAdmin(map);
		
		if (result == null || result.size() == 0) {
			//Auto insert data
			result.add(new CabinetModuleVO(companyId, "todo"  , 0, tenantId));
			result.add(new CabinetModuleVO(companyId, "schedl", 1, tenantId));
			result.add(new CabinetModuleVO(companyId, "resrc" , 0, tenantId));
			result.add(new CabinetModuleVO(companyId, "projt" , 0, tenantId));
			result.add(new CabinetModuleVO(companyId, "option", 0, tenantId));
			result.add(new CabinetModuleVO(companyId, "email" , 1, tenantId));
			result.add(new CabinetModuleVO(companyId, "commu" , 0, tenantId));
			result.add(new CabinetModuleVO(companyId, "board" , 1, tenantId));
			result.add(new CabinetModuleVO(companyId, "apprv" , 1, tenantId));
			result.add(new CabinetModuleVO(companyId, "addrs" , 0, tenantId));
			result.add(new CabinetModuleVO(companyId, "jounl" , 0, tenantId));
			
			map.put("moduleList", result);
			
			ezCabinetAdminDAO.insertModulForAdmin(map);
		}
		
		return result;
	}

	@Override
	public void saveModulesSetting(JSONArray modules, String companyId, int tenantId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("companyId", companyId);
		map.put("tenantId",  tenantId);
		int moduleLen = modules.size();
		
		for (int i = 0; i < moduleLen; i++) {
			String moduleType = (String)((JSONObject)modules.get(i)).get("module");
			int activeStatus = ((Long)((JSONObject)modules.get(i)).get("actType")).intValue();
			map.put("moduleType",   moduleType);
			map.put("activeStatus", activeStatus);
			
			ezCabinetAdminDAO.saveModulesSetting(map);
		}
	}

	@Override
	public UserCapacityVO getUserCapacity(String userId, String companyId, String primary, int tenantId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("userId",    userId);
		map.put("primary",   primary);
		map.put("tenantId",  tenantId);
		map.put("companyId", companyId);
		
		return ezCabinetAdminDAO.getUserCapacity(map);
	}

}
