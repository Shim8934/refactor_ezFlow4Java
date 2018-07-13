package egovframework.ezEKP.ezCabinet.service.impl;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.stream.Collectors;
import javax.annotation.Resource;
import org.apache.commons.io.FileUtils;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import egovframework.com.cmm.service.EgovFileMngUtil;
import egovframework.ezEKP.ezCabinet.dao.EzCabinetAdminDAO;
import egovframework.ezEKP.ezCabinet.dao.EzCabinetDAO;
import egovframework.ezEKP.ezCabinet.service.EzCabinetService;
import egovframework.ezEKP.ezCabinet.vo.CabinetAttachFileVO;
import egovframework.ezEKP.ezCabinet.vo.CabinetGeneralVO;
import egovframework.ezEKP.ezCabinet.vo.CabinetItemVO;
import egovframework.ezEKP.ezCabinet.vo.CabinetModuleVO;
import egovframework.ezEKP.ezCabinet.vo.CabinetRelationVO;
import egovframework.ezEKP.ezCabinet.vo.CabinetSimpleVO;
import egovframework.ezEKP.ezCabinet.vo.CabinetVO;
import egovframework.ezEKP.ezCabinet.vo.SimpleDeptVO;
import egovframework.ezEKP.ezCabinet.vo.UserCapacityVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;

@Service
public class EzCabinetServiceImpl extends EgovFileMngUtil implements EzCabinetService {
	private static final Logger logger = LoggerFactory.getLogger(EzCabinetServiceImpl.class);
	
	@Resource(name = "EzCabinetDAO")
	private EzCabinetDAO ezCabinetDAO;
	
	@Resource(name = "EzCabinetAdminDAO")
	private EzCabinetAdminDAO ezCabinetAdminDAO;
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Override
	public List<SimpleDeptVO> getAllSubDepts(String companyId, int level, String primary, int tenantId) throws Exception {
		List<SimpleDeptVO> deptList = getAllSimpleSubDepts(companyId, level, primary, tenantId);
		return deptList;
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
	
	@Override
	public CabinetSimpleVO getMyCabinetTreeDetail(String cabinetId, LoginVO userInfo) throws Exception {
		int tenantId           = userInfo.getTenantId();
		String companyId       = userInfo.getCompanyID();
		String userId          = userInfo.getId();
		String primary         = userInfo.getPrimary();
		Map<String,Object> map = new HashMap<String, Object>();
		
		map.put("companyId", companyId);
		map.put("userId",    userId);
		map.put("primary",   primary);
		map.put("tenantId",  tenantId);
		map.put("cabinetId", cabinetId);
		
		CabinetVO cabinet  = ezCabinetDAO.getCabinetById(map);
		String cabinetPath = cabinet.getCabinetPath();
		int cabinetLevel   = cabinet.getCabinetLevel();
		
		if (cabinetLevel == 0) {
			map.put("type", 0);
			return ezCabinetDAO.getRootCabinetTree(map);
		}
		
		cabinetPath           = cabinetPath.substring(1, cabinetPath.length() - 1);
		List<Integer> nodeIds = Arrays.asList(cabinetPath.split("\\|")).stream().map(Integer::parseInt).collect(Collectors.toList());
		nodeIds.remove(nodeIds.size() - 1);
		
		map.put("listNodes", nodeIds);
		List<CabinetSimpleVO> listNodes = ezCabinetDAO.getMyCabinetNodesInDetail(map);
		
		Map<Integer, List<CabinetSimpleVO>> mapCabinet = new HashMap<>();
		mapCabinet.put(cabinetLevel, new ArrayList<CabinetSimpleVO>());
		
		for (int i = listNodes.size() - 1; i >= 0; i--) {
			CabinetSimpleVO cabinetSimple = listNodes.get(i);
			int nodeId                    = nodeIds.get(cabinetLevel - 1);
			
			if (cabinetSimple.getCabinetLevel() == cabinetLevel) {
				mapCabinet.get(cabinetLevel).add(0, cabinetSimple);
			}
			else {
				if (mapCabinet.get(cabinetLevel - 1) == null) {
					mapCabinet.put(cabinetLevel - 1, new ArrayList<CabinetSimpleVO>());
				}
				
				mapCabinet.get(cabinetLevel - 1).add(0, cabinetSimple);
				
				if (cabinetSimple.getCabinetId() == nodeId) {
					cabinetSimple.setSubList(mapCabinet.get(cabinetLevel));
					-- cabinetLevel;
				}
			}
		}
		
		return listNodes.get(0);
	}
	
	@Override
	public CabinetSimpleVO getMyCabinetTreeNormal(String cabinetStr1, String cabinetStr2, LoginVO userInfo) throws Exception {
		int tenantId           = userInfo.getTenantId();
		String companyId       = userInfo.getCompanyID();
		String userId          = userInfo.getId();
		String primary         = userInfo.getPrimary();
		Map<String,Object> map = new HashMap<String, Object>();
		
		map.put("companyId", companyId);
		map.put("userId",    userId);
		map.put("primary",   primary);
		map.put("tenantId",  tenantId);
		map.put("type",      0);
		
		CabinetSimpleVO result = ezCabinetDAO.getRootCabinetTree(map);
		
		if (result == null) {
			CabinetVO cabinet  = generateCabinetVO(cabinetStr1, cabinetStr2, 0, 0, -1, userInfo);
			insertCabinet(cabinet);
			
			String cabinetName = primary.equals("1") ? cabinet.getCabinetName1() : cabinet.getCabinetName2();
			result             = new CabinetSimpleVO(cabinet.getCabinetId(), cabinetName, cabinet.getCabinetName1(), cabinet.getCabinetName2(), 0, cabinet.getCabinetLevel(), cabinet.getCabinetStep(), null);
		}
		
		return result;
	}
	
	@Override
	public void addCabinet(int parentId, String cabName1, String cabName2, LoginVO userInfo) throws Exception {
		CabinetVO cabinet = generateCabinetVO(cabName1, cabName2, -1, 0, parentId, userInfo);
		insertCabinet(cabinet);
	}
	
	private synchronized void insertCabinet(CabinetVO cabinet) {
		ezCabinetDAO.insertCabinet(cabinet);
	}
	
	private synchronized void updateCabinet(CabinetVO cabinet) {
		ezCabinetDAO.updateCabinet(cabinet);
	}
	
	private CabinetVO generateCabinetVO(String cabinetStr1, String cabinetStr2, int level, int type, int parentId, LoginVO userInfo) {
		CabinetVO cabinet          = new CabinetVO();
		int tenantId               = userInfo.getTenantId();
		String companyId           = userInfo.getCompanyID();
		String userId              = userInfo.getId();
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		String timeUTC             = commonUtil.getDateStringInUTC(formatter.format(new Date()), userInfo.getOffset(), true);
		Map<String,Object> map     = new HashMap<String, Object>();
		
		map.put("companyId", companyId);
		map.put("tenantId",  tenantId);
		int cabinetId              = ezCabinetDAO.getMaxCabinetId(map) + 1;
		int cabinetStep            = -1;
		String cabinetPath         = "";
		
		if (level == -1 && parentId != -1) {
			map.put("cabinetId", parentId);
			CabinetVO parent = ezCabinetDAO.getCabinetById(map);
			level            = parent.getCabinetLevel() + 1;
			cabinetPath      = parent.getCabinetPath() + cabinetId + "|";
			cabinetStep      = ezCabinetDAO.getMaxCabinetStep(map) + 1;
		}
		else {
			parentId    = -1;
			cabinetPath = "|" + cabinetId + "|";
			cabinetStep = 0;
		}
		
		cabinet.setCabinetId(cabinetId);
		cabinet.setCabinetLevel(level);
		cabinet.setCabinetStep(cabinetStep);
		cabinet.setCabinetName1(cabinetStr1);
		cabinet.setCabinetName2(cabinetStr2);
		cabinet.setDepartmentId(userInfo.getDeptID());
		cabinet.setDepartmentName1(userInfo.getDeptName1());
		cabinet.setDepartmentName2(userInfo.getDeptName2());
		cabinet.setCreatorId(userId);
		cabinet.setCreatorName1(userInfo.getDisplayName1());
		cabinet.setCreatorName2(userInfo.getDisplayName2());
		cabinet.setCabinetType(type);
		cabinet.setParentId(parentId);
		cabinet.setCabinetPath(cabinetPath);
		cabinet.setCreatedDate(timeUTC);
		cabinet.setUpdatedDate(timeUTC);
		cabinet.setUpdateId(userId);
		cabinet.setDeleterId(null);
		cabinet.setUseStatus(1);
		cabinet.setCompanyId(companyId);
		cabinet.setTenantId(tenantId);
		
		return cabinet;
	}

	@Override
	public List<CabinetSimpleVO> getCabinetSubTree(String cabinetId, LoginVO userInfo) throws Exception {
		int tenantId           = userInfo.getTenantId();
		String primary         = userInfo.getPrimary();
		String companyId       = userInfo.getCompanyID();
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("primary",   primary);
		map.put("cabinetId", cabinetId);
		map.put("companyId", companyId);
		map.put("tenantId",  tenantId);
		
		return ezCabinetDAO.getCabinetSubTree(map);
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public JSONObject renameCabinet(int cabinetId, String cabName1, String cabName2, LoginVO userInfo) throws Exception {
		JSONObject result = new JSONObject();
		int tenantId      = userInfo.getTenantId();
		String companyId  = userInfo.getCompanyID();
		
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("cabinetId", cabinetId);
		map.put("companyId", companyId);
		map.put("tenantId",  tenantId);
		
		CabinetVO cabinet = ezCabinetDAO.getCabinetById(map);
		
		if (cabinet.getCabinetLevel() == 0) {
			result.put("status", "error");
			result.put("code", 4);
			return result;
		}
		
		cabinet.setCabinetName1(cabName1);
		cabinet.setCabinetName2(cabName2);
		
		updateCabinet(cabinet);
		
		result.put("status", "ok");
		result.put("code", 0);
		return result;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public JSONObject deleteCabinet(int cabinetId, LoginVO userInfo) throws Exception {
		JSONObject result = new JSONObject();
		int tenantId      = userInfo.getTenantId();
		
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("cabinetId", cabinetId);
		map.put("tenantId",  tenantId);
		
		CabinetVO cabinet = ezCabinetDAO.getCabinetById(map);
		
		if (cabinet.getCabinetLevel() == 0) {
			result.put("status", "error");
			result.put("code", 4);
			return result;
		}
		
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Date date                  = new Date();
		String timeUTC             = commonUtil.getDateStringInUTC(formatter.format(date), userInfo.getOffset(), true);
		
		map.put("cabinetPath", cabinet.getCabinetPath());
		map.put("userId",      userInfo.getId());
		map.put("tenantId",    tenantId);
		map.put("timeUTC",     timeUTC);
		
		//Delete cabinet and all sub-cabinet
		ezCabinetDAO.deleteSubCabinetList(map);
		
		//Delete all cabinet-items
		ezCabinetDAO.deleteAllCabinetItems(map);
		
		result.put("status", "ok");
		result.put("code", 0);
		return result;
	}

	@SuppressWarnings("unchecked")
	@Override
	public JSONObject checkPermission(List<Integer> cabinetList, List<Integer> itemList, LoginVO userInfo) throws Exception {
		JSONObject result      = new JSONObject();
		String userId          = userInfo.getId();
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("cabinetList", cabinetList);
		map.put("itemList",    itemList);
		map.put("userId",      userId);
		map.put("tenantId",    userInfo.getTenantId());
		
		List<CabinetVO> listCabinet  = ezCabinetDAO.getCabinetListForPermission(map);
		List<CabinetVO> otherCabinet = listCabinet.stream().filter(i -> !i.getCreatorId().equals(userId)).collect(Collectors.toList());
		
		if (otherCabinet.size() == 0) {
			result.put("code", 0);
			return result;
		}
		
		List<Integer> listOtherCabinetId = otherCabinet.stream().map(CabinetVO::getCabinetId).collect(Collectors.toList());
		List<String> otherUserList       = otherCabinet.stream().map(CabinetVO::getCreatorId).collect(Collectors.toList());
		
		map.put("deptId",      userInfo.getDeptID());
		map.put("companyId",   userInfo.getCompanyID());
		List<String> userDeptList = ezCabinetDAO.getUserDepartmentIdList(map);
		map.put("deptList",    userDeptList);
		map.put("others",      otherUserList);
		
		List<CabinetVO> listReceivedCabinet = ezCabinetDAO.getReceivedCabinetListForPermission(map);
		List<String> cabinetPathList        = listReceivedCabinet.stream().filter(i -> i.getSubPermission() == 1).map(CabinetVO::getCabinetPath).collect(Collectors.toList());
		List<Integer> totalSharedCabinet    = new ArrayList<>();
		
		if (cabinetPathList.size() > 0) {
			List<String> pathList = new ArrayList<>(new HashSet<>(cabinetPathList));
			map.put("pathList", pathList);
			totalSharedCabinet    = ezCabinetDAO.getReceivedCabinetIdListForPermission(map);
			totalSharedCabinet.addAll(listReceivedCabinet.stream().filter(i -> i.getSubPermission() == 0).map(CabinetVO::getCabinetId).collect(Collectors.toList()));
		}
		else {
			totalSharedCabinet    = listReceivedCabinet.stream().map(CabinetVO::getCabinetId).collect(Collectors.toList());
		}
		
		if (totalSharedCabinet.containsAll(listOtherCabinetId)) {
			result.put("code", 0);
		}
		else {
			result.put("code", 1);
		}
		
		return result;
	}

	@SuppressWarnings("unchecked")
	@Override
	public JSONObject moveCabinet(int cabinetId, int parentId, String mode, String realPath, LoginVO userInfo) throws Exception {
		JSONObject result      = new JSONObject();
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("cabinetId", cabinetId);
		map.put("tenantId",  userInfo.getTenantId());
		CabinetVO cabinet = ezCabinetDAO.getCabinetById(map);
		
		//Check cabinet condition
		if (cabinet.getCabinetLevel() == 0) {
			result.put("status", "error");
			result.put("code", 4);
			return result;
		}
		
		map.put("cabinetId", parentId);
		CabinetVO parent = ezCabinetDAO.getCabinetById(map);
		
		//Check copy/move conditions
		if (cabinet.getParentId() == (parentId)) {
			result.put("status", "error");
			result.put("code", 5);
			return result;
		}
		
		if (parent.getCabinetPath().indexOf(cabinet.getCabinetPath()) != -1) {
			result.put("status", "error");
			result.put("code", 6);
			return result;
		}
		
		if (mode.equals("move")) {
			moveCabinet(cabinet, parent, userInfo);
		}
		else {
			//Check storage condition
			long cabinetStorage     = getCabinetStorage(cabinet, userInfo);
			UserCapacityVO capacity = getUserCapacity(userInfo);
			
			if (capacity.getCapacityType() == 1) {
				//Check save condition
				long totalUsed      = Long.parseLong(capacity.getTotalUsed());
				long totalCapacity  = capacity.getTotalCapacity() * 1048576;
				
				if (cabinetStorage > (totalCapacity - totalUsed)) {
					logger.debug("Not enough storage to copy this cabinet!");
					result.put("status", "error");
					result.put("code", 7);
					return result;
				}
			}
			
			copyCabinet(cabinet, parent, realPath, userInfo);
		}
		
		result.put("status", "ok");
		result.put("code", 0);
		return result;
	}
	
	private long getCabinetStorage(CabinetVO cabinet, LoginVO userInfo) {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("tenantId",    userInfo.getTenantId());
		map.put("cabinetId",   cabinet.getCabinetId());
		map.put("cabinetPath", cabinet.getCabinetPath());
		return ezCabinetDAO.getCabinetStorage(map);
	}

	private UserCapacityVO getUserCapacity(LoginVO userInfo) {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("userId",    userInfo.getId());
		map.put("primary",   userInfo.getPrimary());
		map.put("tenantId",  userInfo.getTenantId());
		map.put("companyId", userInfo.getCompanyID());
		
		return ezCabinetAdminDAO.getUserCapacity(map);
	}
	
	private void copyCabinet(CabinetVO cabinet, CabinetVO parent, String realPath, LoginVO userInfo) throws Exception {
		String userId                = userInfo.getId();
		String offset                = userInfo.getOffset();
		int tenantId                 = userInfo.getTenantId();
		Map<String,Object> map       = new HashMap<String, Object>();
		map.put("tenantId",  tenantId);
		
		int cabinetId                = cabinet.getCabinetId();
		int newId                    = ezCabinetDAO.getMaxCabinetId(map) + 1;
		String newPath               = parent.getCabinetPath() + newId + "|";
		SimpleDateFormat formatter   = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Date date                    = new Date();
		String timeUTC               = commonUtil.getDateStringInUTC(formatter.format(date), offset, true);
		int levelDistance            = parent.getCabinetLevel() + 1 - cabinet.getCabinetLevel();
		
		cabinet.setCreatorId(userId);
		cabinet.setCreatorName1(userInfo.getDisplayName1());
		cabinet.setCreatorName2(userInfo.getDisplayName2());
		cabinet.setCabinetPath(newPath);
		cabinet.setUpdateId(userId);
		cabinet.setUpdatedDate(timeUTC);
		cabinet.setParentId(parent.getCabinetId());
		cabinet.setCabinetLevel(cabinet.getCabinetLevel() + levelDistance);
		cabinet.setCabinetStep(ezCabinetDAO.getMaxCabinetStep(map) + 1);
		cabinet.setCabinetId(newId);
		
		insertCabinet(cabinet);
		
		copyItems(cabinetId, newId, timeUTC, realPath, userInfo);
		//copy all sub cabinet
		copySubCabinets(cabinetId, newPath, timeUTC, levelDistance, realPath, userInfo);
	}
	
	private void copySubCabinets(int cabinetId, String newPath, String timeUTC, int levelDistance, String realPath, LoginVO userInfo) throws Exception {
		List<CabinetVO> listSubCabinets = getAllSubCabinet(cabinetId, userInfo.getTenantId());
		Map<String,Object> map          = new HashMap<String, Object>();
		map.put("tenantId", userInfo.getTenantId());
		
		if (listSubCabinets != null && listSubCabinets.size() > 0) {
			for (int i = 0; i < listSubCabinets.size(); i++) {
				CabinetVO subCabinet = listSubCabinets.get(i);
				int oldId            = subCabinet.getCabinetId();
				int newSubId         = ezCabinetDAO.getMaxCabinetId(map) + 1;
				String cabinetPath   = newPath + newSubId + "|";
				
				subCabinet.setCabinetPath(cabinetPath);
				subCabinet.setUpdatedDate(timeUTC);
				subCabinet.setCreatorId(userInfo.getId());
				subCabinet.setCreatorName1(userInfo.getDisplayName1());
				subCabinet.setCreatorName2(userInfo.getDisplayName2());
				subCabinet.setUpdateId(userInfo.getId());
				subCabinet.setCabinetLevel(subCabinet.getCabinetLevel() + levelDistance);
				subCabinet.setCabinetId(newSubId);
				
				cabinetPath         = cabinetPath.substring(1, cabinetPath.length() - 1);
				String[] cabinetArr = cabinetPath.split("\\|");
				int upperCabinetId  = Integer.parseInt(cabinetArr[cabinetArr.length - 2]);
				
				subCabinet.setParentId(upperCabinetId);
				
				//Create new cabinet
				insertCabinet(subCabinet);
				
				copyItems(oldId, newSubId, timeUTC, realPath, userInfo);
				
				//copy all sub cabinet
				copySubCabinets(oldId, subCabinet.getCabinetPath(), timeUTC, levelDistance, realPath, userInfo);
			}
		}
	}
	
	private List<CabinetVO> getAllSubCabinet(int cabinetId, int tenantId) {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("parentId", cabinetId);
		map.put("tenantId", tenantId);
		return ezCabinetDAO.getAllSubCabinet(map);
	}

	private void moveCabinet(CabinetVO cabinet, CabinetVO parent, LoginVO userInfo) throws Exception {
		String oldPath             = cabinet.getCabinetPath();
		String newPath             = parent.getCabinetPath() + cabinet.getCabinetId() + "|";
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Date date                  = new Date();
		String timeUTC             = commonUtil.getDateStringInUTC(formatter.format(date), userInfo.getOffset(), true);
		int levelDistance          = parent.getCabinetLevel() + 1 - cabinet.getCabinetLevel();
		Map<String,Object> map     = new HashMap<String, Object>();
		map.put("tenantId",  userInfo.getTenantId());
		map.put("cabinetId", parent.getCabinetId());
		
		cabinet.setCabinetPath(newPath);
		cabinet.setUpdateId(userInfo.getId());
		cabinet.setUpdatedDate(timeUTC);
		cabinet.setParentId(parent.getCabinetId());
		cabinet.setCabinetLevel(cabinet.getCabinetLevel() + levelDistance);
		cabinet.setCabinetStep(ezCabinetDAO.getMaxCabinetStep(map) + 1);
		updateCabinet(cabinet);
		
		//Update list sub cabinet
		moveSubCabinetList(oldPath, newPath, timeUTC, levelDistance, userInfo);
	}
	
	private void moveSubCabinetList(String oldPath, String newPath, String timeUTC, int levelDistance, LoginVO userInfo) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("userId",        userInfo.getId());
		map.put("oldPath",       oldPath);
		map.put("newPath",       newPath);
		map.put("updateTime",    timeUTC);
		map.put("levelDistance", levelDistance);
		map.put("tenantId",      userInfo.getTenantId());
		
		ezCabinetDAO.moveSubCabinetList(map);
	}
	
	private synchronized void copyItems(int cabinetId, int newId, String timeUTC, String realPath, LoginVO userInfo) throws Exception {
		int tenantId  = userInfo.getTenantId();
		String userId = userInfo.getId();
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("tenantId",  tenantId);
		map.put("cabinetId", cabinetId);
		
		List<CabinetItemVO> itemList = ezCabinetDAO.getAllItemsOfCabinet(map);
		
		if (itemList != null && itemList.size() > 0) {
			int newItemId = ezCabinetDAO.getMaxItem(map) + 1;
			for (CabinetItemVO item : itemList) {
				int itemId = item.getItemId();
				//Save new Item
				item.setItemId(newItemId);
				item.setCabinetId(newId);
				item.setCreatorId(userId);
				item.setCreatorName1(userInfo.getDisplayName1());
				item.setCreatorName2(userInfo.getDisplayName2());
				item.setDepartmentId(userInfo.getDeptID());
				item.setDepartmentName1(userInfo.getDeptName1());
				item.setDepartmentName2(userInfo.getDeptName2());
				item.setCreatedDate(timeUTC);
				item.setUpdatedDate(timeUTC);
				item.setUpdateId(userId);
				item.setCompanyId(userInfo.getCompanyID());
				
				ezCabinetDAO.saveItem(item);
				
				map.put("itemId", itemId);
				List<CabinetAttachFileVO> listAttachFile = ezCabinetDAO.getAllAttachFilesOfItem(map);
				
				if (listAttachFile != null && listAttachFile.size() > 0) {
					int attachId = ezCabinetDAO.getMaxAttachId(map) + 1;
					for (CabinetAttachFileVO attach : listAttachFile) {
						String fileName = attach.getFileName();
						int dotPos      = fileName.lastIndexOf(".");
						String extend   = dotPos == -1 ? ".none" : fileName.substring(dotPos + 1);
						String newName  = UUID.randomUUID().toString() + "." + extend;
						String newPath  = getCabinetDirPath(tenantId) + newName;
						File srcFile    = new File(realPath + attach.getFilePath());
						File destFile   = new File(realPath  + newPath);
						
						try {
							FileUtils.copyFile(srcFile, destFile);
						}
						catch (Exception e) {
							e.printStackTrace();
						}
						
						//AttachFile process here
						attach.setItemId(newItemId);
						attach.setFilePath(newPath);
						attach.setAttachId(attachId);
						ezCabinetDAO.saveAttachFile(attach);
						attachId ++;
					}
				}
				
				List<CabinetRelationVO> listRelatedFile = ezCabinetDAO.getAllRelatedFilesOfItem(map);
				
				if (listRelatedFile != null && listRelatedFile.size() > 0) {
					int relationId = ezCabinetDAO.getMaxRelationId(map) + 1;
					for (CabinetRelationVO relatedFile : listRelatedFile) {
						relatedFile.setItemId(newItemId);
						relatedFile.setRelationId(relationId);
						
						ezCabinetDAO.saveRelationFile(relatedFile);
						relationId ++;
					}
				}
				
				newItemId ++;
			}
		}
	}
	
	@Override
	public String saveUploadFile(List<MultipartFile> multiFileLists, JSONArray nameArray, String realPath, int tenantId) throws Exception {
		String pFileName   = (String)((JSONObject)nameArray.get(0)).get("originalFilename");
		String cabinetPath = getCabinetDirPath(tenantId);
		String pDirPath    = realPath + cabinetPath;
		
		File file = new File(pDirPath);
		
		if (!file.exists()) {
			file.mkdir();
		}
		
		int dotPos     = pFileName.lastIndexOf(".");
		String extend  = dotPos == -1 ? ".none" : pFileName.substring(dotPos + 1);
		String newName = UUID.randomUUID().toString() + "." + extend;
		writeUploadedFile(multiFileLists.get(0), newName, pDirPath);
		
		return cabinetPath + newName;
	}
	
	@Override
	public void deleteAttachFile(String filePath, String realPath, int tenantId) throws Exception {
		String pDirPath = realPath + filePath;
		File file       = new File(pDirPath);
		
		if (file.exists()) {
			try {
				file.delete();
			}
			catch (Exception e) {
				e.printStackTrace();
			}
		}
	}
	
	@Override
	public synchronized void saveItem(int cabinetId, JSONArray attacheFiles, JSONArray relatedFiles, String title, String summary, String realPath, LoginVO userInfo) throws Exception {
		String companyId           = userInfo.getCompanyID();
		String userId              = userInfo.getId();
		int tenantId               = userInfo.getTenantId();
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Date date                  = new Date();
		String timeUTC             = commonUtil.getDateStringInUTC(formatter.format(date), userInfo.getOffset(), true);
		Map<String,Object> map     = new HashMap<String, Object>();
		map.put("tenantId", tenantId);
		
		//Save item
		int itemId      = ezCabinetDAO.getMaxItem(map) + 1;
		CabinetItemVO itemVO = new CabinetItemVO();
		itemVO.setCabinetId(cabinetId);
		itemVO.setItemId(itemId);
		itemVO.setItemType(0);
		itemVO.setTitle(title);
		itemVO.setSummary(summary);
		itemVO.setCreatorId(userId);
		itemVO.setCreatorName1(userInfo.getDisplayName1());
		itemVO.setCreatorName2(userInfo.getDisplayName2());
		itemVO.setDepartmentId(userInfo.getDeptID());
		itemVO.setDepartmentName1(userInfo.getDeptName1());
		itemVO.setDepartmentName2(userInfo.getDeptName2());
		itemVO.setConentPath(null);
		itemVO.setCreatedDate(timeUTC);
		itemVO.setUpdatedDate(timeUTC);
		itemVO.setUseStatus(1);
		itemVO.setUpdateId(userId);
		itemVO.setDeleterId(null);
		itemVO.setCompanyId(companyId);
		itemVO.setTenantId(tenantId);
		
		ezCabinetDAO.saveItem(itemVO);
		
		int attachSize  = attacheFiles.size();
		int relatedSize = relatedFiles.size();
		
		//Save attach files
		if (attachSize > 0) {
			int attachId = ezCabinetDAO.getMaxAttachId(map) + 1;
			for (int i = 0; i < attachSize; i++, attachId++) {
				JSONObject fileObj = (JSONObject)attacheFiles.get(i);
				String filePath    = (String)fileObj.get("path");
				String fileName    = (String)fileObj.get("name");
				
				File file          = new File(realPath + filePath);
				long fileSize      = file.length();
				
				CabinetAttachFileVO attachFile = new CabinetAttachFileVO(attachId, itemId, filePath, fileName, fileSize, companyId, tenantId);
				ezCabinetDAO.saveAttachFile(attachFile);
			}
		}
		
		//Save related files
		if (relatedSize > 0) {
			int relationId = ezCabinetDAO.getMaxRelationId(map) + 1;
			
			for (int i = 0; i < relatedSize; i++, relationId++) {
				JSONObject relationObj = (JSONObject)relatedFiles.get(i);
				int relatedItemId = Integer.parseInt((String)relationObj.get("relatedId"));
				
				CabinetRelationVO relationFile = new CabinetRelationVO(relationId, itemId, relatedItemId, companyId, tenantId);
				ezCabinetDAO.saveRelationFile(relationFile);
			}
		}
	}
	
	private String getCabinetDirPath(int tenantId) {
		return commonUtil.separator + "fileroot" + commonUtil.separator + tenantId + commonUtil.separator + "cabinet" + commonUtil.separator;
	}
}
