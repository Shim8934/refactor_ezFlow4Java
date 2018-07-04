package egovframework.ezEKP.ezCabinet.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.annotation.Resource;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.springframework.stereotype.Service;
import egovframework.ezEKP.ezCabinet.dao.EzCabinetAdminDAO;
import egovframework.ezEKP.ezCabinet.dao.EzCabinetDAO;
import egovframework.ezEKP.ezCabinet.service.EzCabinetService;
import egovframework.ezEKP.ezCabinet.vo.CabinetGeneralVO;
import egovframework.ezEKP.ezCabinet.vo.CabinetModuleVO;
import egovframework.ezEKP.ezCabinet.vo.SimpleDeptVO;
@Service
public class EzCabinetServiceImpl implements EzCabinetService {
	@Resource(name = "EzCabinetDAO")
	private EzCabinetDAO ezCabinetDAO;
	
	@Resource(name = "EzCabinetAdminDAO")
	private EzCabinetAdminDAO ezCabinetAdminDAO;
	
	@Override
	public SimpleDeptVO getAllDepts(String companyId, int level, String primary, int tenantId) throws Exception {
		List<SimpleDeptVO> deptList = getAllSimpleDeptsOfCompany(companyId, level, primary, tenantId);
		SimpleDeptVO dept           = deptList.get(0);
		deptList.remove(0);
		dept.setSubDepts(deptList);
		
		return dept;
	}

	@Override
	public String getDeptPath(String deptId, int tenantId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("deptId",     deptId);
		map.put("tenantId",   tenantId);
		return ezCabinetDAO.getDeptPath(map);
	}

	@Override
	public SimpleDeptVO getSimpleCompany(String deptId, int level, String primary, int tenantId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("deptId",     deptId);
		map.put("primary",    primary);
		map.put("level",      level);
		map.put("tenantId",   tenantId);
		
		return ezCabinetDAO.getSimpleCompany(map);
	}

	@Override
	public void getAllDepts(SimpleDeptVO sDept, String[] path, String primary, int tenantId, int order, int level) throws Exception {
		if (sDept.getHasSub().equals("1")) {
			List<SimpleDeptVO> listSubSimpleDepts = getAllSimpleSubDepts(sDept.getDeptId(), level, primary, tenantId);
			sDept.setSubDepts(listSubSimpleDepts);
			
			for (SimpleDeptVO subDept: listSubSimpleDepts) {
				if (order < path.length && subDept.getDeptId().equals(path[order])) {
					getAllDepts(subDept, path, primary, tenantId, order + 1, level + 1);
				}
			}
		}
	}
	
	private List<SimpleDeptVO> getAllSimpleSubDepts(String deptId, int level, String primary, int tenantId) {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("deptId",     deptId);
		map.put("primary",    primary);
		map.put("level",      level);
		map.put("tenantId",   tenantId);
		
		return ezCabinetDAO.getAllSimpleSubDepts(map);
	}
	
	private List<SimpleDeptVO> getAllSimpleDeptsOfCompany(String companyId, int level, String primary, int tenantId) {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("companyId",  companyId);
		map.put("primary",    primary);
		map.put("level",      level);
		map.put("tenantId",   tenantId);
		
		return ezCabinetDAO.getAllSimpleDeptsOfCompany(map);
	}

	@Override
	public List<CabinetModuleVO> getModuleListForUser(String userId, String companyId, int tenantId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("userId",    userId);
		map.put("companyId", companyId);
		map.put("tenantId",  tenantId);
		
		List<CabinetModuleVO> listModule = ezCabinetDAO.getModuleListForUser(map);
		
		if (listModule == null || listModule.size() == 0) {
			listModule = ezCabinetDAO.getActiveModuleListForUser(map);
			
			if (listModule == null  || listModule.size() == 0) {
				List<CabinetModuleVO> listAllModule = ezCabinetAdminDAO.getModuleListForAdmin(map);
				
				if (listAllModule == null  || listAllModule.size() == 0) {
					//Auto insert data
					listAllModule.add(new CabinetModuleVO(companyId, "todo"  , 0, tenantId));
					listAllModule.add(new CabinetModuleVO(companyId, "resrc" , 0, tenantId));
					listAllModule.add(new CabinetModuleVO(companyId, "projt" , 0, tenantId));
					listAllModule.add(new CabinetModuleVO(companyId, "option", 0, tenantId));
					listAllModule.add(new CabinetModuleVO(companyId, "commu" , 0, tenantId));
					listAllModule.add(new CabinetModuleVO(companyId, "addrs" , 0, tenantId));
					listModule.add(new CabinetModuleVO(companyId, "schedl", 1, tenantId));
					listModule.add(new CabinetModuleVO(companyId, "email" , 1, tenantId));
					listModule.add(new CabinetModuleVO(companyId, "board" , 1, tenantId));
					listModule.add(new CabinetModuleVO(companyId, "apprv" , 1, tenantId));
					
					listAllModule.addAll(listModule);
					map.put("moduleList", listAllModule);
					ezCabinetAdminDAO.insertModulForAdmin(map);
				}
			}
		}
		
		return listModule;
	}

	@Override
	public void saveModulesSetting(JSONArray modules, String userId, String companyId, int tenantId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("companyId", companyId);
		map.put("userId",    userId);
		map.put("tenantId",  tenantId);
		int moduleLen = modules.size();
		
		for (int i = 0; i < moduleLen; i++) {
			String moduleType = (String)((JSONObject)modules.get(i)).get("module");
			int activeStatus = ((Long)((JSONObject)modules.get(i)).get("actType")).intValue();
			map.put("moduleType",   moduleType);
			map.put("activeStatus", activeStatus);
			
			ezCabinetDAO.saveModulesSetting(map);
		}
	}

	@Override
	public CabinetGeneralVO getUserPreviewConfig(String userId, String companyId, int tenantId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("companyId", companyId);
		map.put("userId",    userId);
		map.put("tenantId",  tenantId);
		
		return ezCabinetDAO.getUserPreviewConfig(map);
	}

	@Override
	public void saveUserConfig(String prevMode, int listCount, int contentWPrev, int contentHPrev, String userId, String companyId, int tenantId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("companyId",    companyId);
		map.put("userId",       userId);
		map.put("tenantId",     tenantId);
		map.put("prevMode",     prevMode);
		map.put("listCount",    listCount);
		map.put("contentWPrev", contentWPrev);
		map.put("contentHPrev", contentHPrev);
		
		ezCabinetDAO.saveUserConfig(map);
	}
}
