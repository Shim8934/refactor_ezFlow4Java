package egovframework.ezEKP.ezCabinet.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.springframework.stereotype.Service;

import egovframework.ezEKP.ezCabinet.dao.EzCabinetAdminDAO;
import egovframework.ezEKP.ezCabinet.service.EzCabinetAdminService;
import egovframework.ezEKP.ezCabinet.vo.CabinetModuleVO;
import egovframework.ezEKP.ezCabinet.vo.CompanyCapacityVO;
import egovframework.ezEKP.ezCabinet.vo.UserCapacityVO;
import egovframework.let.user.login.vo.LoginVO;

@Service("EzCabinetAdminService")
public class EzCabinetAdminServiceImpl extends EgovAbstractServiceImpl implements EzCabinetAdminService {
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
	public void saveCompanyCapacity(int type, double newValue, String companyId, int tenantId) throws Exception {
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
	public void changeUserCapacity(List<String> userList, double newValue, int type, String companyId, int tenantId) throws Exception {
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
	public void deleteUserCapacity(List<String> userList, String companyId, int tenantId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("companyId", companyId);
		map.put("tenantId",  tenantId);
		
		for (String userId : userList) {
			map.put("userId",  userId);
			ezCabinetAdminDAO.deleteUserCapacity(map);
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
			result = new ArrayList<>();
			result.add(new CabinetModuleVO(companyId, "schedl", 1, tenantId));
			result.add(new CabinetModuleVO(companyId, "resrc" , 1, tenantId));
			result.add(new CabinetModuleVO(companyId, "option", 1, tenantId));
			result.add(new CabinetModuleVO(companyId, "email" , 1, tenantId));
			result.add(new CabinetModuleVO(companyId, "commu" , 1, tenantId));
			result.add(new CabinetModuleVO(companyId, "board" , 1, tenantId));
			result.add(new CabinetModuleVO(companyId, "apprv" , 1, tenantId));
			result.add(new CabinetModuleVO(companyId, "addrs" , 1, tenantId));
			result.add(new CabinetModuleVO(companyId, "jounl" , 1, tenantId));
			
			insertModulForAdmin(result);
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
	
	@Override
	public void insertModulForAdmin(List<CabinetModuleVO> listAllModule) throws Exception {
		for (CabinetModuleVO module : listAllModule) {
			ezCabinetAdminDAO.insertModulForAdmin(module);
		}
	}
	
	@Override
	public String checkModuleActive(String moduleType, LoginVO userInfo) throws Exception {
		String check           = "NO";
		String companyId       = userInfo.getCompanyID();
		int tenantId           = userInfo.getTenantId();
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("companyId", companyId);
		map.put("tenantId",  tenantId);
		
		List<CabinetModuleVO> result = ezCabinetAdminDAO.getModuleListForAdmin(map);
		
		if (result == null || result.size() == 0) {
			//Auto insert data
			result = new ArrayList<>();
			result.add(new CabinetModuleVO(companyId, "schedl", 1, tenantId));
			result.add(new CabinetModuleVO(companyId, "resrc" , 1, tenantId));
			result.add(new CabinetModuleVO(companyId, "option", 1, tenantId));
			result.add(new CabinetModuleVO(companyId, "email" , 1, tenantId));
			result.add(new CabinetModuleVO(companyId, "commu" , 1, tenantId));
			result.add(new CabinetModuleVO(companyId, "board" , 1, tenantId));
			result.add(new CabinetModuleVO(companyId, "apprv" , 1, tenantId));
			result.add(new CabinetModuleVO(companyId, "addrs" , 1, tenantId));
			result.add(new CabinetModuleVO(companyId, "jounl" , 1, tenantId));
			
			insertModulForAdmin(result);
		}
		
		for (CabinetModuleVO module : result) {
			if (module.getModuleType().equals(moduleType) && module.getActiveStatus() == 1) {
				check = "YES";
				break;
			}
		}
		
		return check;
	}
}
