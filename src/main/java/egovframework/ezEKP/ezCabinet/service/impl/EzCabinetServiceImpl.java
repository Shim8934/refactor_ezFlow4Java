package egovframework.ezEKP.ezCabinet.service.impl;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Properties;
import java.util.Set;
import java.util.UUID;
import java.util.stream.Collectors;
import javax.annotation.Resource;
import javax.mail.Folder;
import javax.mail.Message;
import javax.mail.Part;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.commons.io.FileUtils;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.multipart.MultipartFile;
import com.sun.mail.imap.IMAPFolder;
import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.service.EzFileMngUtil;
import egovframework.ezEKP.ezBoard.dao.EzBoardDAO;
import egovframework.ezEKP.ezBoard.vo.BoardAttachVO;
import egovframework.ezEKP.ezCabinet.dao.EzCabinetAdminDAO;
import egovframework.ezEKP.ezCabinet.dao.EzCabinetDAO;
import egovframework.ezEKP.ezCabinet.dao.EzCabinetDAO_h;
import egovframework.ezEKP.ezCabinet.service.EzCabinetAdminService;
import egovframework.ezEKP.ezCabinet.service.EzCabinetService;
import egovframework.ezEKP.ezCabinet.service.EzCabinetService_h;
import egovframework.ezEKP.ezCabinet.vo.CabinetAttachFileVO;
import egovframework.ezEKP.ezCabinet.vo.CabinetColumnVO;
import egovframework.ezEKP.ezCabinet.vo.CabinetGeneralVO;
import egovframework.ezEKP.ezCabinet.vo.CabinetItemSearchVO;
import egovframework.ezEKP.ezCabinet.vo.CabinetItemSimpleVO;
import egovframework.ezEKP.ezCabinet.vo.CabinetItemVO;
import egovframework.ezEKP.ezCabinet.vo.CabinetModuleVO;
import egovframework.ezEKP.ezCabinet.vo.CabinetRelationVO;
import egovframework.ezEKP.ezCabinet.vo.CabinetShareVO;
import egovframework.ezEKP.ezCabinet.vo.CabinetSimpleVO;
import egovframework.ezEKP.ezCabinet.vo.CabinetVO;
import egovframework.ezEKP.ezCabinet.vo.SimpleDeptVO;
import egovframework.ezEKP.ezCabinet.vo.SimpleUserInfoVO;
import egovframework.ezEKP.ezCabinet.vo.SimpleUserMailVO;
import egovframework.ezEKP.ezCabinet.vo.SimpleUserVO;
import egovframework.ezEKP.ezCabinet.vo.UserCapacityVO;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezEmail.logic.IMAPAccess;
import egovframework.ezEKP.ezEmail.util.EzEmailUtil;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;

@Service
public class EzCabinetServiceImpl extends EzFileMngUtil implements EzCabinetService {
	private static final Logger logger = LoggerFactory.getLogger(EzCabinetServiceImpl.class);
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private Properties config;
	
	@Autowired
	private EzEmailUtil ezEmailUtil;
	
	@Autowired
	private EzCabinetService_h cabinetService_h;
	
	@Autowired
	private EzCabinetAdminService cabinetAdminService;
	
	@Resource(name = "EzCabinetDAO")
	private EzCabinetDAO ezCabinetDAO;
	
	@Resource(name = "EzCabinetDAO_h")
	private EzCabinetDAO_h ezCabinetDAO_h;
	
	@Resource(name = "EzCabinetAdminDAO")
	private EzCabinetAdminDAO ezCabinetAdminDAO;
	
	@Resource(name="EzBoardDAO")
	private EzBoardDAO ezBoardDAO;
	
	@Resource(name = "EzCommonService")
	private EzCommonService ezCommonService;
	
	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;
	
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
	
	@Override
	public List<CabinetModuleVO> getModuleListForUser(String userId, String companyId, int tenantId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("userId",    userId);
		map.put("companyId", companyId);
		map.put("tenantId",  tenantId);
		
		List<CabinetModuleVO> listModule       = new ArrayList<>();
		List<CabinetModuleVO> listActiveModule = null;
		
		//Get all admin modules
		List<CabinetModuleVO> listAllModule = ezCabinetAdminDAO.getModuleListForAdmin(map);
		
		if (listAllModule == null || listAllModule.isEmpty()) {
			//Auto insert data
			listAllModule = new ArrayList<>();
			listModule.add(new CabinetModuleVO(companyId, "resrc" , 1, tenantId));
			listModule.add(new CabinetModuleVO(companyId, "option", 1, tenantId));
			listModule.add(new CabinetModuleVO(companyId, "commu" , 1, tenantId));
			listModule.add(new CabinetModuleVO(companyId, "addrs" , 1, tenantId));
			listModule.add(new CabinetModuleVO(companyId, "jounl" , 1, tenantId));
			listModule.add(new CabinetModuleVO(companyId, "email" , 1, tenantId));
			listModule.add(new CabinetModuleVO(companyId, "schedl", 1, tenantId));
			listModule.add(new CabinetModuleVO(companyId, "board" , 1, tenantId));
			listModule.add(new CabinetModuleVO(companyId, "apprv" , 1, tenantId));
			
			listAllModule.addAll(listModule);
			map.put("moduleList", listAllModule);
			cabinetAdminService.insertModulForAdmin(listAllModule);
		}
		else {
			listActiveModule      = listAllModule.stream().filter(module -> module.getActiveStatus() == 1).collect(Collectors.toList());
			List<String> typeList = listActiveModule.stream().map(CabinetModuleVO::getModuleType).collect(Collectors.toList());
			if (!listActiveModule.isEmpty()) {
				map.put("typeList", typeList);
				listModule = ezCabinetDAO.getModuleListForUser(map);
				
				if (listModule != null && !listModule.isEmpty()) {
					if (listModule.size() == listActiveModule.size()) {
						return listModule;
					}
					
					Iterator<CabinetModuleVO> iterator = listActiveModule.iterator();
					while (iterator.hasNext()) {
						CabinetModuleVO module = iterator.next();
						if(listModule.contains(module)){
							iterator.remove();
						}
					}
					
					listActiveModule.addAll(listModule);
				}
				
				return listActiveModule;
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
	public CabinetSimpleVO getMyCabinetTreeNormal(LoginVO userInfo) throws Exception {
		int tenantId           = userInfo.getTenantId();
		String companyId       = userInfo.getCompanyID();
		String userId          = userInfo.getId();
		String primary         = userInfo.getPrimary();
		String cabinetStr1     = egovMessageSource.getMessage("ezCabinet.t169", new Locale(config.getProperty("config.cabinetPrimary")));
		String cabinetStr2     = egovMessageSource.getMessage("ezCabinet.t169", new Locale(config.getProperty("config.cabinetSecondary")));
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
			
			String cabinetName = cabinet.getCabinetName1();
			result             = new CabinetSimpleVO(cabinet.getCabinetId(), cabinetName, cabinet.getCabinetName1(), cabinet.getCabinetName2(), 0, cabinet.getCabinetLevel(), cabinet.getCabinetStep(), null);
		}
		
		return result;
	}
	
	@Override
	public void addCabinet(int parentId, String cabName1, LoginVO userInfo) throws Exception {
		CabinetVO cabinet = generateCabinetVO(cabName1, "", -1, 0, parentId, userInfo);
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
	public JSONObject renameCabinet(int cabinetId, String cabName1, LoginVO userInfo) throws Exception {
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
		
		//Check if this cabinet has children
		int totalChildren = ezCabinetDAO.getTotalChildren(map);
		
		if (totalChildren > 0) {
			result.put("status", "error");
			result.put("code", 8);
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
	public JSONObject checkPermission(List<Integer> cabinetList, List<Integer> itemList, int mode, LoginVO userInfo) throws Exception {
		JSONObject result      = new JSONObject();
		String userId          = userInfo.getId();
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("cabinetList", cabinetList);
		map.put("itemList",    itemList);
		map.put("userId",      userId);
		map.put("tenantId",    userInfo.getTenantId());
		
		List<CabinetVO> listCabinet  = ezCabinetDAO.getCabinetListForPermission(map);
		
		if (listCabinet == null || listCabinet.size() == 0) {
			result.put("code", 1);
			result.put("reason", 1);
			return result;
		}
		
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
		map.put("permMode",    mode);
		
		List<CabinetVO> listReceivedCabinet = ezCabinetDAO.getReceivedCabinetListForPermission(map);
		List<String> cabinetPathList        = listReceivedCabinet.stream().filter(i -> i.getSubPermission() == 1).map(CabinetVO::getCabinetPath).collect(Collectors.toList());
		List<Integer> totalSharedCabinet    = null;
		
		if (!cabinetPathList.isEmpty()) {
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
			result.put("reason", 2);
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
			UserCapacityVO capacity = getUserCapacity(userInfo);
			
			if (capacity.getCapacityType() == 1) {
				//Check save condition
				long cabinetStorage = getCabinetStorage(cabinet, userInfo);
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
		cabinet.setCreatedDate(timeUTC);
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
	
	private void copyItems(int cabinetId, int newId, String timeUTC, String realPath, LoginVO userInfo) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("tenantId",  userInfo.getTenantId());
		map.put("cabinetId", cabinetId);
		
		List<CabinetItemVO> itemList = ezCabinetDAO.getAllItemsOfCabinet(map);
		copyListItems(realPath, timeUTC, itemList, newId, userInfo);
	}
	
	private synchronized void copyListItems(String realPath, String timeUTC, List<CabinetItemVO> itemList, int newCabinetId, LoginVO userInfo) throws Exception {
		int tenantId           = userInfo.getTenantId();
		String userId          = userInfo.getId();
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("tenantId",  tenantId);
		
		if (itemList != null && itemList.size() > 0) {
			int newItemId = ezCabinetDAO.getMaxItem(map) + 1;
			for (CabinetItemVO item : itemList) {
				int itemId     = item.getItemId();
				String ownerId = item.getCreatorId();
				//Save new Item
				item.setItemId(newItemId);
				item.setCabinetId(newCabinetId);
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
				
				saveItem(item);
				
				map.put("itemId", itemId);
				List<CabinetAttachFileVO> listAttachFile = ezCabinetDAO.getAllAttachFilesOfItem(map);
				
				if (listAttachFile != null && listAttachFile.size() > 0) {
					int attachId = ezCabinetDAO.getMaxAttachId(map) + 1;
					for (CabinetAttachFileVO attach : listAttachFile) {
						String fileName = attach.getFileName();
						int dotPos      = fileName.lastIndexOf(".");
						String extend   = dotPos == -1 ? ".none" : fileName.substring(dotPos + 1);
						String newName  = UUID.randomUUID().toString() + "." + extend;
						String newPath  = getCabinetDirPath(tenantId) + commonUtil.detectPathTraversal(newName);
						String attPath  = commonUtil.detectPathTraversal(attach.getFilePath());
						File srcFile    = new File(realPath + attPath);
						File destFile   = new File(realPath + newPath);
						
						try {
							FileUtils.copyFile(srcFile, destFile);
						}
						catch (Exception e) {
							logger.error(e.getMessage(), e);
						}
						
						//AttachFile process here
						attach.setItemId(newItemId);
						attach.setFilePath(newPath);
						attach.setAttachId(attachId);
						saveAttachFile(attach);
						attachId ++;
					}
				}
				
				//Check owner privilege
				if (ownerId.equals(userId)) {
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
				}
				
				//Copy columns
				if (item.getItemType() != 0) {
					//Get related columns
					List<CabinetColumnVO> columnList = getAllRelatedColumnsOfItem(itemId, userInfo.getPrimary(), tenantId);
					for (CabinetColumnVO column : columnList) {
						column.setItemId(newItemId);
					}
					
					saveAllColumns(columnList);
				}
				
				newItemId ++;
			}
		}
	}
	
	@Override
	public String saveUploadFile(List<MultipartFile> multiFileLists, JSONArray nameArray, String realPath, int tenantId) throws Exception {
		String pFileName   = (String)((JSONObject)nameArray.get(0)).get("originalFilename");
		String cabinetPath = getCabinetDirPath(tenantId);
		String pDirPath    = realPath + commonUtil.detectPathTraversal(cabinetPath);
		
		File file = new File(pDirPath);
		
		if (!file.exists() && !file.mkdirs()) {
			throw new IOException();
		}
		
		int dotPos     = pFileName.lastIndexOf(".");
		String extend  = dotPos == -1 ? ".none" : pFileName.substring(dotPos + 1);
		String newName = UUID.randomUUID().toString() + "." + extend;
		writeUploadedFile(multiFileLists.get(0), newName, pDirPath);
		
		return cabinetPath + newName;
	}
	
	@Override
	public void deleteAttachFile(String filePath, String realPath, int tenantId) throws Exception {
		String pDirPath = realPath + commonUtil.detectPathTraversal(filePath);
		File file       = new File(pDirPath);
		
		if (file.exists()) {
			try {
				file.delete();
			}
			catch (Exception e) {
				logger.error(e.getMessage(), e);
			}
		}
	}
	
	@Override
	public synchronized void saveItem(int cabinetId, JSONArray attacheFiles, JSONArray relatedFiles, String title, String summary, String realPath, LoginVO userInfo) throws Exception {
		String companyId           = userInfo.getCompanyID();
		int tenantId               = userInfo.getTenantId();
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Date date                  = new Date();
		String timeUTC             = commonUtil.getDateStringInUTC(formatter.format(date), userInfo.getOffset(), true);
		Map<String,Object> map     = new HashMap<String, Object>();
		map.put("tenantId", tenantId);
		
		//Save item
		int itemId = ezCabinetDAO.getMaxItem(map) + 1;
		addNewItem(cabinetId, itemId, 0, title, summary, null, timeUTC, userInfo);
		
		int attachSize  = attacheFiles.size();
		int relatedSize = relatedFiles.size();
		
		//Save attach files
		if (attachSize > 0) {
			int attachId = ezCabinetDAO.getMaxAttachId(map) + 1;
			for (int i = 0; i < attachSize; i++, attachId++) {
				JSONObject fileObj = (JSONObject)attacheFiles.get(i);
				String filePath    = (String)fileObj.get("path");
				String fileName    = (String)fileObj.get("name");
				
				File file          = new File(realPath + commonUtil.detectPathTraversal(filePath));
				long fileSize      = file.length();
				
				CabinetAttachFileVO attachFile = new CabinetAttachFileVO(attachId, itemId, filePath, fileName, fileSize, "", companyId, tenantId);
				saveAttachFile(attachFile);
			}
		}
		
		//Save related files
		if (relatedSize > 0) {
			int relationId = ezCabinetDAO.getMaxRelationId(map) + 1;
			
			for (int i = 0; i < relatedSize; i++, relationId++) {
				JSONObject relationObj = (JSONObject)relatedFiles.get(i);
				int relatedItemId = Integer.parseInt((String)relationObj.get("itemId"));
				
				CabinetRelationVO relationFile = new CabinetRelationVO(relationId, itemId, relatedItemId, companyId, tenantId);
				ezCabinetDAO.saveRelationFile(relationFile);
			}
		}
	}
	
	private synchronized void saveItem(CabinetItemVO itemVO) {
		ezCabinetDAO.saveItem(itemVO);
	}
	
	private String getCabinetDirPath(int tenantId) {
		return commonUtil.getUploadPath("upload_cabinet.ROOT", tenantId) + commonUtil.separator;
	}
	
	@Override
	public CabinetVO getCabinetById(String cabinetId, int tenantId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("cabinetId", cabinetId);
		map.put("tenantId",  tenantId);
		
		return ezCabinetDAO.getCabinetById(map);
	}
	
	@Override
	public List<CabinetItemVO> getItems(CabinetItemSearchVO searchVO) throws Exception {
		return ezCabinetDAO.getItems(searchVO);
	}
	
	@Override
	public int getTotalItems(CabinetItemSearchVO searchVO) throws Exception {
		return ezCabinetDAO.getTotalItems(searchVO);
	}
	
	@Override
	public List<CabinetItemVO> getItemsRecursive(CabinetItemSearchVO searchVO) throws Exception {
		return ezCabinetDAO.getItemsRecursive(searchVO);
	}
	
	@Override
	public int getTotalItemsRecursive(CabinetItemSearchVO searchVO) throws Exception {
		return ezCabinetDAO.getTotalItemsRecursive(searchVO);
	}
	
	@Override
	public void deleteItems(List<Integer> itemIdList, LoginVO userInfo) throws Exception {
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Date date                  = new Date();
		String timeUTC             = commonUtil.getDateStringInUTC(formatter.format(date), userInfo.getOffset(), true);
		Map<String,Object> map     = new HashMap<String, Object>();
		map.put("tenantId",   userInfo.getTenantId());
		map.put("itemList",   itemIdList);
		map.put("userId",     userInfo.getId());
		map.put("updateTime", timeUTC);
		
		ezCabinetDAO.deleteItems(map);
	}
	
	@Override
	public List<CabinetSimpleVO> getRelatedCabinetListForUser(LoginVO userInfo) throws Exception {
		int tenantId                  = userInfo.getTenantId();
		String userId                 = userInfo.getId();
		List<CabinetModuleVO> modules = getModuleListForUser(userId, userInfo.getCompanyID(), tenantId);
		List<Integer> moduleTypes     = modules.stream().filter(i -> i.getActiveStatus() == 1).map(CabinetModuleVO::getType).collect(Collectors.toList());
		List<CabinetSimpleVO> result  = new ArrayList<>();
		
		if (moduleTypes == null || moduleTypes.size() == 0) {
			return result;
		}
		
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("listType", moduleTypes);
		map.put("tenantId", tenantId);
		map.put("userId",   userId);
		
		List<CabinetVO> list = ezCabinetDAO.getRelatedCabinetListForUser(map);
		if (list == null || list.size() == 0) {
			list = insertRelatedCabinet(moduleTypes, userInfo);
		}
		else {
			if (list.size() < moduleTypes.size()) {
				List<Integer> existedModules = list.stream().map(CabinetVO::getCabinetType).collect(Collectors.toList());
				moduleTypes.removeAll(existedModules);
				List<CabinetVO> remainModule = insertRelatedCabinet(moduleTypes, userInfo);
				list.addAll(remainModule);
			}
		}
		
		result = generateSimpleCabinet(list, userInfo.getPrimary());
		
		return result;
	}
	
	private List<CabinetSimpleVO> generateSimpleCabinet(List<CabinetVO> list, String primary) {
		List<CabinetSimpleVO> result = new ArrayList<>();
		Collections.sort(list, (CabinetVO cabinet1, CabinetVO cabinet2) -> Integer.compare(cabinet1.getOrderFromType(), cabinet2.getOrderFromType()));
		
		for (CabinetVO cabinet : list) {
			String cabinetName            = cabinet.getCabinetName1();
			CabinetSimpleVO simpleCabinet = new CabinetSimpleVO(cabinet.getCabinetId(), cabinetName, cabinet.getCabinetName1(), cabinet.getCabinetName2(), 0, 0, 0, null);
			result.add(simpleCabinet);
		}
		
		return result;
	}
	
	private synchronized List<CabinetVO> insertRelatedCabinet(List<Integer> moduleTypes, LoginVO userInfo) throws Exception {
		List<CabinetVO> result = new ArrayList<>();
		
		for (int moduleType : moduleTypes) {
			String cabinetStr1 = egovMessageSource.getMessage("ezCabinet.m" + moduleType, new Locale(config.getProperty("config.cabinetPrimary")));
			String cabinetStr2 = egovMessageSource.getMessage("ezCabinet.m" + moduleType, new Locale(config.getProperty("config.cabinetSecondary")));
			CabinetVO cabinet  = generateCabinetVO(cabinetStr1, cabinetStr2, 0, moduleType, -1, userInfo);
			insertCabinet(cabinet);
			result.add(cabinet);
		}
		
		return result;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public JSONObject moveItems(String realPath, int cabinetId, String mode, List<Integer> itemIdList, LoginVO userInfo) throws Exception {
		JSONObject result      = new JSONObject();
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("cabinetId", cabinetId);
		map.put("tenantId",  userInfo.getTenantId());
		CabinetVO cabinet      = ezCabinetDAO.getCabinetById(map);
		
		//Check cabinet
		if (cabinet == null || cabinet.getUseStatus() == 0) {
			result.put("status", "error");
			result.put("code", 2);
			return result;
		}
		
		map.put("itemId",   itemIdList.get(0));
		CabinetItemVO checkItem    = ezCabinetDAO.getItemById(map);
		
		//Check move/copy condition
		if (cabinetId == checkItem.getCabinetId()) {
			result.put("status", "error");
			result.put("code", 5);
			return result;
		}
		
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Date date                  = new Date();
		String timeUTC             = commonUtil.getDateStringInUTC(formatter.format(date), userInfo.getOffset(), true);
		
		if (mode.equals("move")) {
			moveItemsForUser(cabinetId, timeUTC, itemIdList, userInfo);
		}
		else {
			//Check storage condition
			UserCapacityVO capacity = getUserCapacity(userInfo);
			
			if (capacity.getCapacityType() == 1) {
				//Check save condition
				long totalItemsSize = getTotalItemsSize(itemIdList, userInfo);
				long totalUsed      = Long.parseLong(capacity.getTotalUsed());
				long totalCapacity  = capacity.getTotalCapacity() * 1048576;
				
				if (totalItemsSize > (totalCapacity - totalUsed)) {
					logger.debug("Not enough storage to copy these files!");
					result.put("status", "error");
					result.put("code", 4);
					return result;
				}
			}
			
			List<CabinetItemVO> itemList = getItemsFromIdList(itemIdList, userInfo);
			copyListItems(realPath, timeUTC, itemList, cabinetId, userInfo);
		}
		
		result.put("status", "ok");
		result.put("code", 0);
		return result;
	}
	
	private List<CabinetItemVO> getItemsFromIdList(List<Integer> itemIdList, LoginVO userInfo) {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("tenantId", userInfo.getTenantId());
		map.put("itemList", itemIdList);
		
		return ezCabinetDAO.getItemsFromIdList(map);
	}
	
	public long getTotalItemsSize(List<Integer> itemIdList, LoginVO userInfo) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("tenantId", userInfo.getTenantId());
		map.put("itemList", itemIdList);
		
		return ezCabinetDAO.getTotalItemsSize(map);
	}
	
	private void moveItemsForUser(int cabinetId, String timeUTC, List<Integer> itemIdList, LoginVO userInfo) {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("cabinetId",  cabinetId);
		map.put("userId",     userInfo.getId());
		map.put("tenantId",   userInfo.getTenantId());
		map.put("itemList",   itemIdList);
		map.put("updateTime", timeUTC);
		
		ezCabinetDAO.moveItemsForUser(map);
	}
	
	@Override
	public List<CabinetItemSimpleVO> getCabinetFiles(String cabinetId, int startPoint, int listCount, int tenantId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("cabinetId",  cabinetId);
		map.put("tenantId",   tenantId);
		map.put("startPoint", startPoint);
		map.put("listCount",  listCount);
		
		return ezCabinetDAO.getCabinetFiles(map);
	}
	
	@Override
	public List<CabinetItemSimpleVO> getFilesByTitle(String itemTitle, int startPoint, int listCount, String userId, int tenantId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("title",      itemTitle);
		map.put("startPoint", startPoint);
		map.put("listCount",  listCount);
		map.put("userId",     userId);
		map.put("tenantId",   tenantId);
		
		return ezCabinetDAO.getFilesByTitle(map);
	}
	
	@Override
	public int getTotalFiles(String cabinetId, int tenantId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("cabinetId", cabinetId);
		map.put("tenantId",  tenantId);
		
		return ezCabinetDAO.getTotalFiles(map);
	}
	
	@Override
	public int getTotalFilesByTitle(String itemTitle, String userId, int tenantId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("title",    itemTitle);
		map.put("userId",   userId);
		map.put("tenantId", tenantId);
		
		return ezCabinetDAO.getTotalFilesByTitle(map);
	}
	
	@Override
	public List<SimpleUserVO> getSharedUserList(LoginVO userInfo) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("userId",    userInfo.getId());
		map.put("tenantId",  userInfo.getTenantId());
		map.put("primary",   userInfo.getPrimary());
		map.put("deptId",    userInfo.getDeptID());
		map.put("companyId", userInfo.getCompanyID());
		
		List<String> userDeptList = ezCabinetDAO.getUserDepartmentIdList(map);
		map.put("deptList",  userDeptList);
		
		return ezCabinetDAO.getSharedUserList(map);
	}
	
	@Override
	public List<CabinetSimpleVO> getUserSharedCabinet(String shareId, LoginVO userInfo) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("userId",    userInfo.getId());
		map.put("tenantId",  userInfo.getTenantId());
		map.put("primary",   userInfo.getPrimary());
		map.put("deptId",    userInfo.getDeptID());
		map.put("companyId", userInfo.getCompanyID());
		
		List<String> userDeptList = ezCabinetDAO.getUserDepartmentIdList(map);
		map.put("deptList", userDeptList);
		map.put("shareId",  shareId);
		
		List<CabinetSimpleVO> cabinetList = ezCabinetDAO.getUserSharedCabinet(map);
		removeDuplicateCabinet(cabinetList);
		return cabinetList;
	}
	
	@Override
	public List<CabinetSimpleVO> getMyShareCabinet(LoginVO userInfo) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("userId",    userInfo.getId());
		map.put("tenantId",  userInfo.getTenantId());
		map.put("primary",   userInfo.getPrimary());
		
		List<CabinetSimpleVO> cabinetList = ezCabinetDAO.getMySharedCabinetList(map);
		removeDuplicateCabinet(cabinetList);
		return cabinetList;
	}
	
	private void removeDuplicateCabinet(List<CabinetSimpleVO> cabinetList) {
		//Check if duplicate cabinet exist
		Set<Integer> cabinetIds = cabinetList.stream().map(CabinetSimpleVO::getCabinetId).collect(Collectors.toSet());
		if (cabinetIds.size() != cabinetList.size()) {
			List<CabinetSimpleVO> tempList   = new ArrayList<>();
			Map<Integer, Integer> cabinetMap = new HashMap<>();
			
			for (int i = 0; i < cabinetList.size(); i++) {
				int crrId = cabinetList.get(i).getCabinetId();
				if (!cabinetMap.containsKey(crrId)) {
					cabinetMap.put(crrId, i);
				}
				else {
					cabinetList.get(cabinetMap.get(crrId)).setHasSub(1);
				}
			}
			
			cabinetMap.forEach((key, value) -> {tempList.add(cabinetList.get(value));});
			cabinetList.clear();
			cabinetList.addAll(tempList);
		}
		
		//Check duplicate cabinet
		List<Integer> cabinetIdHasChildPerm = cabinetList.stream().filter(cab -> cab.getHasSub() == 1).map(CabinetSimpleVO::getCabinetId).collect(Collectors.toList());
		Iterator<CabinetSimpleVO> it        = cabinetList.iterator();
		
		while(it.hasNext()) {
			int checkflag          = 0;
			CabinetSimpleVO crrCab = it.next();
			String cabinetPath     = crrCab.getCabinetPath();
			cabinetPath            = cabinetPath.substring(1, cabinetPath.length() - 1);
			List<Integer> nodeIds  = Arrays.asList(cabinetPath.split("\\|")).stream().map(Integer::parseInt).collect(Collectors.toList());
			nodeIds.remove(nodeIds.size() - 1);
			
			for (int ancestorId : nodeIds) {
				if (cabinetIdHasChildPerm.contains(ancestorId)) {
					checkflag = 1;
					break;
				}
			}
			
			if (checkflag == 1) {
				it.remove();
			}
		}
		
		//Sort cabinetList
		cabinetList.sort(Comparator.comparing(CabinetSimpleVO::getCabinetLevel).thenComparing(CabinetSimpleVO::getCabinetName));
		//Collections.sort(cabinetList, (CabinetSimpleVO c1, CabinetSimpleVO c2) -> c1.getCabinetName().compareTo(c2.getCabinetName()));
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public JSONObject getSharedCabinetInfo(String cabinetId, LoginVO userInfo) {
		JSONObject result      = new JSONObject();
		int tenantId           = userInfo.getTenantId();
		int writePermission    = 0;
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("cabinetId", cabinetId);
		map.put("tenantId",  tenantId);
		map.put("primary",   userInfo.getPrimary());
		map.put("deptId",    userInfo.getDeptID());
		map.put("companyId", userInfo.getCompanyID());
		map.put("userId",    userInfo.getId());
		
		CabinetVO cabinet     = ezCabinetDAO.getCabinetById(map);
		String cabinetPath    = cabinet.getCabinetPath();
		cabinetPath           = cabinetPath.substring(1, cabinetPath.length() - 1);
		List<Integer> nodeIds = Arrays.asList(cabinetPath.split("\\|")).stream().map(Integer::parseInt).collect(Collectors.toList());
		nodeIds.remove(nodeIds.size() - 1);
		map.put("listNodes", nodeIds);
		
		List<String> userDeptList = ezCabinetDAO.getUserDepartmentIdList(map);
		map.put("deptList", userDeptList);
		
		List<CabinetShareVO> listShared = ezCabinetDAO.getSharedCabinetListById(map);
		
		if (listShared == null || listShared.size() == 0) {
			result.put("status", "error");
			result.put("code", 2);
			return result;
		}
		
		for (CabinetShareVO share : listShared) {
			if (share.getPermission() == 1) {
				writePermission = 1;
				break;
			}
		}
		
		cabinet.setCabinetName(cabinet.getCabinetName1());
		cabinet.setPermission(writePermission);
		
		result.put("cabinet", cabinet);
		result.put("status", "ok");
		result.put("code", 0);
		return result;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public JSONObject getItemsBySearching(String cabinetId, int currentPage, int listCntSize, String title, String summary, String creatorName, String startDate, String endDate, String sqlQuery, String srchMode, String srchOption, String order, String column, String recursive, LoginVO userInfo) throws Exception {
		JSONObject result            = new JSONObject();
		String userId                = userInfo.getId();
		int tenantId                 = userInfo.getTenantId();
		String primary               = userInfo.getPrimary(); // 1 or 2
		String offset                = userInfo.getOffset();
		String offsetMinute          = commonUtil.getMinuteUTC(offset);
		int startPoint               = 0;
		int totalItems               = 0;
		int totalPages               = 0;
		boolean subSearchflag        = false;
		
		logger.debug("Offset: " + offset);
		
		/* 2024-07-01 홍승비 - SQL Injection 수정 > 정렬 조건 쿼리에서 $ 기호 제거 */
		String orderCol = "";
		String orderSort = "";
		if (!column.equals("") && !order.equals("")) {
			orderSort = order;
			
			switch(column) {
				case "it": orderCol = "item_type"; break;
				case "tt": orderCol = "title"; break;
				case "un": orderCol = ("creator_name" + primary); break;
				case "cd": orderCol = "create_date"; break;
				case "is": orderCol = "item_size"; break;
				default  : orderCol = "item_type"; break;
			}
		}
		
		if (!startDate.equals("")) {
			String startDateTmp = startDate + " 00:00:00";
			String endDateTmp   = endDate + " 23:59:59";
			startDate           = commonUtil.getDateStringInUTC(startDateTmp, offset, true);
			endDate             = commonUtil.getDateStringInUTC(endDateTmp, offset, true);
		}
		
		title       = title.replace("\\", "\\\\").replace("%", "\\%").replace("_", "\\_");
		summary     = summary.replace("\\", "\\\\").replace("%", "\\%").replace("_", "\\_");
		creatorName = creatorName.replace("\\", "\\\\").replace("%", "\\%").replace("_", "\\_");
		
		CabinetItemSearchVO searchVO = new CabinetItemSearchVO(Integer.parseInt(cabinetId), listCntSize, tenantId, userId, primary, offsetMinute, title, summary, creatorName, startDate, endDate, orderCol, orderSort, srchMode, srchOption);
		List<CabinetItemVO> itemList = new ArrayList<>();
		
		if (srchMode.equals("2") && recursive.equals("1")) {
			CabinetVO cabinet = getCabinetById(cabinetId, userInfo.getTenantId());
			
			if (!cabinet.getCreatorId().equals(userId)) {
				String cabinetPath    = cabinet.getCabinetPath();
				cabinetPath           = cabinetPath.substring(1, cabinetPath.length() - 1);
				List<Integer> nodeIds = Arrays.asList(cabinetPath.split("\\|")).stream().map(Integer::parseInt).collect(Collectors.toList());
				nodeIds.remove(nodeIds.size() - 1);
				Map<String,Object> map = new HashMap<String, Object>();
				map.put("cabinetId", cabinetId);
				map.put("tenantId",  tenantId);
				map.put("sharerId",  cabinet.getCreatorId());
				map.put("sharedId",  userId);
				map.put("listNodes", nodeIds);
				
				//Get user dept list
				map.put("deptId",    userInfo.getDeptID());
				map.put("companyId", userInfo.getCompanyID());
				map.put("userId",    userId);
				List<String> userDeptList = ezCabinetDAO.getUserDepartmentIdList(map);
				map.put("deptList", userDeptList);
				
				List<CabinetShareVO> listShared = ezCabinetDAO.checkSubPermission(map);
				
				if (listShared != null && listShared.size() > 0) {
					searchVO.setCabinetPath(cabinet.getCabinetPath());
					subSearchflag = true;
				}
			}
			else {
				searchVO.setCabinetPath(cabinet.getCabinetPath());
				subSearchflag = true;
			}
		}
		
		if (subSearchflag == true) {
			totalItems  = getTotalItemsRecursive(searchVO);
			totalPages  = (totalItems + listCntSize - 1) / listCntSize;
			currentPage = currentPage > totalPages ? totalPages : currentPage;
			currentPage = currentPage == 0         ? 1          : currentPage;
			startPoint  = (currentPage - 1) * listCntSize;
			searchVO.setStartPoint(startPoint);
			itemList    = getItemsRecursive(searchVO);
		}
		else {
			totalItems  = getTotalItems(searchVO);
			totalPages  = (totalItems + listCntSize - 1) / listCntSize;
			currentPage = currentPage > totalPages ? totalPages : currentPage;
			currentPage = currentPage == 0         ? 1          : currentPage;
			startPoint  = (currentPage - 1) * listCntSize;
			searchVO.setStartPoint(startPoint);
			itemList    = getItems(searchVO);
		}
		
		result.put("itemList",    itemList);
		result.put("totalPages",  totalPages);
		result.put("totalRows",   totalItems);
		result.put("currentPage", currentPage);
		result.put("status", "ok");
		result.put("code", 0);
		
		return result;
	}
	
	@Override
	public void getDownloadedFile(String fileName, String filePath, String realPath, LoginVO userInfo, String userAgent, HttpServletRequest request, HttpServletResponse response) throws Exception {
		String _fileName = fileName;
		_fileName        = CommonUtil.getEncodedFileNameForDownload(userAgent, _fileName);
		File file        = new File(realPath + commonUtil.detectPathTraversal(filePath));
		
		if (!file.exists()) {
			throw new FileNotFoundException(fileName);
		}
		
		if (!file.isFile()) {
			throw new FileNotFoundException(fileName);
		}
		
		BufferedInputStream in = null;
		
		try {
			in                 = new BufferedInputStream(new FileInputStream(file));
			String mimetype    = "application/octet-stream";
			
			response.setBufferSize(BUFF_SIZE);
			response.setContentType(mimetype);
			response.setHeader("Content-Disposition", "attachment; filename=\"" + _fileName + "\"");
			response.setContentLength((int)file.length());
			
			FileCopyUtils.copy(in, response.getOutputStream());
		}
		catch (Exception e) {
			throw e;
		}
		finally {
			if (in != null) {
				try {
					in.close();
				}
				catch (Exception ignore) {
					logger.debug("IGNORED: {}", ignore.getMessage());
					throw ignore;
				}
			}
		}
		
		response.getOutputStream().flush();
		response.getOutputStream().close();
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public JSONObject saveEmailItem(String realPath, int cabinetId, String title, String summary, String mailTitle, String sender, String attach, String mode, String content, String receiver, String forward, String dateTime, Locale locale, LoginVO userInfo) throws Exception {
		JSONObject result      = new JSONObject();
		String userId          = userInfo.getId();
		int tenantId           = userInfo.getTenantId();
		String companyId       = userInfo.getCompanyID();
		JSONParser jp          = new JSONParser();
		String dateColumn      = userInfo.getEmail().equals(sender) ? "ezEmail.t704" : "ezEmail.t657";
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("tenantId", tenantId);
		
		//Process email image content
		content = content.replaceAll("/ezEmail/downloadInline.do\\?", "/ezEmail/downloadInlineDotNet.do?userId=" + URLEncoder.encode(userId, "UTF-8") + "&amp;");
		
		//Get itemId
		int itemId = ezCabinetDAO.getMaxItem(map) + 1;
		
		//Save attach files
		if (!attach.equals("")) {
			JSONArray attachList               = (JSONArray) jp.parse(attach);
			long remainStorage                 = -1;
			long totalAttachSize               = 0;
			List<CabinetAttachFileVO> fileList = new ArrayList<>();
			String cabinetPath                 = getCabinetDirPath(tenantId);
			File file                          = new File(realPath + commonUtil.detectPathTraversal(cabinetPath));
			UserCapacityVO capacity            = cabinetAdminService.getUserCapacity(userInfo.getId(), userInfo.getCompanyID(), userInfo.getPrimary(), tenantId);
			int totalCnt                       = attachList.size();
			int attachId                       = ezCabinetDAO.getMaxAttachId(map) + 1;
			
			if (!file.exists() && !file.mkdirs()) {
				throw new IOException();
			}
			
			for (int i = 0; i < totalCnt; i++, attachId++) {
				JSONObject attachInf = (JSONObject) attachList.get(i);
				copyEmailAttachFiles(fileList, attachInf, attachId, itemId, realPath, cabinetPath, locale, companyId, userId, tenantId);
			}
			
			if (capacity.getCapacityType() == 1) {
				long totalUsed  = Long.parseLong(capacity.getTotalUsed());
				long totalCap   = capacity.getTotalCapacity() * 1048576;
				remainStorage   = totalCap - totalUsed;
				totalAttachSize = fileList.stream().mapToLong(CabinetAttachFileVO::getFileSize).sum();
				
				if (totalAttachSize > remainStorage) {
					//Delete temp files
					try {
						for (CabinetAttachFileVO fileAttach : fileList) {
							File tempFile = new File(realPath + commonUtil.detectPathTraversal(fileAttach.getFilePath()));
							if (!tempFile.delete()) {
								throw new IOException();
							}
						}
						
						logger.debug("Not enough storage to upload these files!");
						result.put("status", "error");
						result.put("code", 4);
						return result;
					}
					catch (Exception e) {
						logger.error(e.getMessage(), e);
						logger.debug("Not enough storage to upload these files!");
						result.put("status", "error");
						result.put("code", 4);
						return result;
					}
				}
			}
			
			//Save information to database
			for (CabinetAttachFileVO fileAttach : fileList) {
				saveAttachFile(fileAttach);
			}
		}
		
		//Add email item
		int moduleType = 1; //mail module
		addRelatedItem(itemId, moduleType, cabinetId, title, summary, content, mode, userInfo);
		
		//Save email columns information
		List<String> receiverList      = (List<String>) jp.parse(receiver);
		List<CabinetColumnVO> listColm = new ArrayList<>();
		listColm.add(createNewRelatedColumn("mailTitle", itemId, "ezCabinet.t62",mailTitle, companyId, tenantId));
		listColm.add(createNewRelatedColumn("sender"   , itemId, "ezEmail.t161", sender   , companyId, tenantId));
		listColm.add(createNewRelatedColumn("emailTime", itemId, dateColumn    , dateTime , companyId, tenantId));
		listColm.add(createNewRelatedColumn("receiver" , itemId, "ezEmail.t66" , String.join(";", receiverList), companyId, tenantId));
		
		if (!forward.equals("")) {
			List<String> forwardList = (List<String>) jp.parse(forward);
			if (forwardList.size() > 0) {
				listColm.add(createNewRelatedColumn("forward", itemId, "ezEmail.t555", String.join(";", forwardList), companyId, tenantId));
			}
		}
		
		saveAllColumns(listColm);
		
		result.put("status", "ok");
		result.put("code", 0);
		return result;
	}
	
	private void copyEmailAttachFiles(List<CabinetAttachFileVO> attachFileList, JSONObject attachInf, int attachId, int itemId, String realPath, String cabinetPath, Locale locale, String companyId, String userId, int tenantId) throws Exception{
		JSONObject fileHref = (JSONObject) attachInf.get("fileHref");
		String fileName     = attachInf.get("fileName").toString();
		String folderPath   = fileHref.get("folderPath").toString();
		String uId          = fileHref.get("uid").toString();
		String fname        = fileHref.get("uid").toString();
		String strIndex     = fileHref.get("index").toString();
		String password     = commonUtil.getMailPassword();
		String domainName   = ezCommonService.getTenantConfig("DomainName", tenantId);
		String userEmail    = userId + "@" + domainName;
		int dotPos          = fileName.lastIndexOf('.');
		String extend       = dotPos == -1 ? ".none" : fileName.substring(dotPos + 1);
		String newName      = UUID.randomUUID().toString() + "." + extend;
		String pDirPath     = realPath + cabinetPath;
		String filePath     = cabinetPath + newName;
		String newFilePath  = pDirPath + File.separator + commonUtil.detectPathTraversal(newName);
		
		logger.debug("userEmail: " + userEmail);
		logger.debug("UID: " + uId + " || Folder path: " + folderPath + " || File name: " + fname);
		
		IMAPAccess ia = null;
		
		try {
			int index = Integer.parseInt(strIndex);
			int uid   = Integer.parseInt(uId)     ;
			ia        = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"), userEmail, password, egovMessageSource, locale, ezEmailUtil);
			Folder f  = ia.getFolder(folderPath);
			
			if (f == null || !f.exists()) {
				logger.error("Folder not found. folderPath=" + folderPath);
			}
			else {
				f.open(Folder.READ_ONLY);
				Message message = null;
				if (f.isOpen() && f instanceof IMAPFolder) {
					message = ((IMAPFolder)f).getMessageByUID(uid);
				}
				
				if (message == null) {
					logger.error("Message not found. uid=" + uid);
					throw new FileNotFoundException();
				}
				else {
					Part part = index == -1 ? message : ezEmailUtil.getAttachPart(message, index);
					
					if (part == null) {
						logger.error("AttachPart not found. AttachPartIndex=" + index);
						throw new FileNotFoundException();
					}
					else {
						// 2023-05-31 이사라 : 시큐어코딩 리소스 close
						//InputStream input   = null;
						//OutputStream output = null;
						File newAttachFile = new File(newFilePath);
						
						try (InputStream input = part.getInputStream();
							 OutputStream output =new FileOutputStream(newAttachFile)) {
							//input              = part.getInputStream();
							//File newAttachFile = new File(newFilePath);
							//output             = new FileOutputStream(newAttachFile);
							byte[] buffer      = new byte[4096];
							int byteRead       = 0;
							
							while ((byteRead = input.read(buffer)) != -1) {
								output.write(buffer, 0, byteRead);
							}
						}
						catch(IOException e1) {
							throw e1;
						}
						finally {
							ia.close();
							/*if (input != null) {
								try { input.close(); } catch (IOException e2) {throw e2;}
							}
							if (output != null) {
								try {output.flush();} catch (IOException e3) {throw e3;}
								try {output.close();} catch (IOException e4) {throw e4;}
							}*/
						}
					}
				}
			}
		}
		catch (RuntimeException e) {
			throw e;
		}
		catch (Exception e5) {
			throw e5;
		}
		finally {
			if (ia != null) {
				ia.close();
			}
		}
		
		//Save Attach to database
		File readfile = new File(newFilePath);
		long fileSize = readfile.length();
		
		CabinetAttachFileVO attachFile = new CabinetAttachFileVO(attachId, itemId, filePath, fileName, fileSize, "", companyId, tenantId);
		attachFileList.add(attachFile);
	}
	
	private synchronized void saveAttachFile(CabinetAttachFileVO attachFile) {
		ezCabinetDAO.saveAttachFile(attachFile);
	}
	
	private synchronized void saveAllColumns(List<CabinetColumnVO> listColm) {
		for (CabinetColumnVO column : listColm) {
			ezCabinetDAO.saveRelatedColumn(column);
		}
	}
	
	@Override
	public List<CabinetColumnVO> getAllRelatedColumnsOfItem(int itemId, String primary, int tenantId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("itemId",    itemId);
		map.put("tenantId",  tenantId);
		map.put("primary",   primary);
		
		return ezCabinetDAO.getAllRelatedColumnsOfItem(map);
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public JSONObject modifyRelatedItem(int itemId, String title, String summary, JSONArray relatedFiles, LoginVO userInfo) throws Exception {
		JSONObject result      = new JSONObject();
		int tenantId           = userInfo.getTenantId();
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("tenantId", tenantId);
		map.put("itemId",   itemId);
		
		CabinetItemVO itemVO = ezCabinetDAO.getItemById(map);
		
		itemVO.setTitle(title);
		itemVO.setSummary(summary);
		ezCabinetDAO_h.modifyItem(itemVO);
		
		//modify related files
		cabinetService_h.modifyRelatedList(itemId, relatedFiles, userInfo);
		
		result.put("status", "ok");
		result.put("code", 0);
		return result;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public JSONObject saveGroupAddressItem(int cabinetId, String title, String summary, String mode, String groupName, String content, String createUser, String createDate, String changeUser, String changeDate, LoginVO userInfo) throws Exception {
		JSONObject result      = new JSONObject();
		int tenantId           = userInfo.getTenantId();
		String companyId       = userInfo.getCompanyID();
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("tenantId", tenantId);
		
		//Get itemId
		int itemId = ezCabinetDAO.getMaxItem(map) + 1;
		
		//Add group address item
		int moduleType = 8; //address module
		addRelatedItem(itemId, moduleType, cabinetId, title, summary, content, mode, userInfo);
		
		//Save group columns information
		List<CabinetColumnVO> listColm = new ArrayList<>();
		listColm.add(createNewRelatedColumn("groupName"  , itemId, "ezAddress.t304", groupName , companyId, tenantId));
		listColm.add(createNewRelatedColumn("creator"    , itemId, "ezAddress.t286", createUser, companyId, tenantId));
		listColm.add(createNewRelatedColumn("createdate" , itemId, "ezAddress.t288", createDate, companyId, tenantId));
		listColm.add(createNewRelatedColumn("modifier"   , itemId, "ezAddress.t289", changeUser, companyId, tenantId));
		listColm.add(createNewRelatedColumn("modifydate" , itemId, "ezAddress.t290", changeDate, companyId, tenantId));
		listColm.add(createNewRelatedColumn("addresstype", itemId, "ezAddress.t290", "group"   , companyId, tenantId));
		
		saveAllColumns(listColm);
		
		result.put("status", "ok");
		result.put("code", 0);
		return result;
	}
	
	private CabinetColumnVO createNewRelatedColumn(String columnId, int itemId, String messageName, String columnValue, String companyId, int tenantId) {
		String columnName1 = egovMessageSource.getMessage(messageName, new Locale(config.getProperty("config.cabinetPrimary")));
		String columnName2 = egovMessageSource.getMessage(messageName, new Locale(config.getProperty("config.cabinetSecondary")));
		return new CabinetColumnVO(columnId, itemId, columnName1, columnName2, columnValue, companyId, tenantId);
	}
	
	private void addNewItem(int cabinetId, int itemId, int moduleType, String title, String summary, String content, String timeUTC, LoginVO userInfo) {
		String userId        = userInfo.getId();
		CabinetItemVO itemVO = new CabinetItemVO();
		itemVO.setCabinetId(cabinetId);
		itemVO.setItemId(itemId);
		itemVO.setItemType(moduleType);
		itemVO.setTitle(title);
		itemVO.setSummary(summary);
		itemVO.setCreatorId(userId);
		itemVO.setCreatorName1(userInfo.getDisplayName1());
		itemVO.setCreatorName2(userInfo.getDisplayName2());
		itemVO.setDepartmentId(userInfo.getDeptID());
		itemVO.setDepartmentName1(userInfo.getDeptName1());
		itemVO.setDepartmentName2(userInfo.getDeptName2());
		itemVO.setContentPath(content);
		itemVO.setCreatedDate(timeUTC);
		itemVO.setUpdatedDate(timeUTC);
		itemVO.setUseStatus(1);
		itemVO.setUpdateId(userId);
		itemVO.setDeleterId(null);
		itemVO.setCompanyId(userInfo.getCompanyID());
		itemVO.setTenantId(userInfo.getTenantId());
		
		saveItem(itemVO);
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public JSONObject saveNormalAddressItem(int cabinetId, String title, String summary, String mode, String createUser, String createDate, String changeUser, String changeDate, String company, String department, String position, String email, String compNumber, String userNumber, String faxNumber, String homePage, String companyZip, String compAddr, String homeZip, String homeAddr, String memo, LoginVO userInfo) throws Exception {
		JSONObject result      = new JSONObject();
		int tenantId           = userInfo.getTenantId();
		String companyId       = userInfo.getCompanyID();
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("tenantId", tenantId);
		
		//Get itemId
		int itemId = ezCabinetDAO.getMaxItem(map) + 1;
		
		//Add normal address item
		int moduleType = 8; //address module
		addRelatedItem(itemId, moduleType, cabinetId, title, summary, null, mode, userInfo);
		
		//Save normal columns information
		List<CabinetColumnVO> listColm = new ArrayList<>();
		listColm.add(createNewRelatedColumn("creator"    , itemId, "ezAddress.t286", createUser, companyId, tenantId));
		listColm.add(createNewRelatedColumn("createdate" , itemId, "ezAddress.t288", createDate, companyId, tenantId));
		listColm.add(createNewRelatedColumn("modifier"   , itemId, "ezAddress.t289", changeUser, companyId, tenantId));
		listColm.add(createNewRelatedColumn("modifydate" , itemId, "ezAddress.t290", changeDate, companyId, tenantId));
		listColm.add(createNewRelatedColumn("company"    , itemId, "ezAddress.t51" , company   , companyId, tenantId));
		listColm.add(createNewRelatedColumn("department" , itemId, "ezAddress.t54" , department, companyId, tenantId));
		listColm.add(createNewRelatedColumn("position"   , itemId, "main.t77"      , position  , companyId, tenantId));
		listColm.add(createNewRelatedColumn("email"      , itemId, "ezAddress.t291", email     , companyId, tenantId));
		listColm.add(createNewRelatedColumn("compnumber" , itemId, "ezAddress.t192", compNumber, companyId, tenantId));
		listColm.add(createNewRelatedColumn("usernumber" , itemId, "ezAddress.t189", userNumber, companyId, tenantId));
		listColm.add(createNewRelatedColumn("faxnumber"  , itemId, "ezAddress.t292", faxNumber , companyId, tenantId));
		listColm.add(createNewRelatedColumn("homepage"   , itemId, "ezAddress.t293", homePage  , companyId, tenantId));
		listColm.add(createNewRelatedColumn("companyzip" , itemId, "ezAddress.t295", companyZip, companyId, tenantId));
		listColm.add(createNewRelatedColumn("compaddr"   , itemId, "ezAddress.t295", compAddr  , companyId, tenantId));
		listColm.add(createNewRelatedColumn("homezip"    , itemId, "ezAddress.t296", homeZip   , companyId, tenantId));
		listColm.add(createNewRelatedColumn("homeaddr"   , itemId, "ezAddress.t296", homeAddr  , companyId, tenantId));
		listColm.add(createNewRelatedColumn("memo"       , itemId, "ezAddress.t91" , memo      , companyId, tenantId));
		listColm.add(createNewRelatedColumn("addresstype", itemId, "ezAddress.t290", "normal"  , companyId, tenantId));
		
		saveAllColumns(listColm);
		
		result.put("status", "ok");
		result.put("code", 0);
		return result;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public JSONObject saveResourceItem(int cabinetId, String resTitle, String content, String title, String summary, String mode, String createUser, String resDate, String resItem, LoginVO userInfo) throws Exception {
		JSONObject result      = new JSONObject();
		int tenantId           = userInfo.getTenantId();
		String companyId       = userInfo.getCompanyID();
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("tenantId", tenantId);
		
		//Get itemId
		int itemId = ezCabinetDAO.getMaxItem(map) + 1;
		
		//Add resource item
		int moduleType = 11; //resource module
		addRelatedItem(itemId, moduleType, cabinetId, title, summary, content, mode, userInfo);
		
		//Save resource columns information
		List<CabinetColumnVO> listColm = new ArrayList<>();
		listColm.add(createNewRelatedColumn("resTitle"     , itemId, "ezCabinet.t62"  , resTitle  , companyId, tenantId));
		listColm.add(createNewRelatedColumn("creator"      , itemId, "ezResource.t193", createUser, companyId, tenantId));
		listColm.add(createNewRelatedColumn("resourcedate" , itemId, "ezResource.t197", resDate   , companyId, tenantId));
		listColm.add(createNewRelatedColumn("resourceitem" , itemId, "ezResource.t374", resItem   , companyId, tenantId));
		
		saveAllColumns(listColm);
		
		result.put("status", "ok");
		result.put("code", 0);
		return result;
	}
	
	private synchronized void addRelatedItem(int itemId, int moduleType, int cabinetId, String title, String summary, String content, String mode, LoginVO userInfo) throws Exception {
		String userId              = userInfo.getId();
		int tenantId               = userInfo.getTenantId();
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		String timeUTC             = commonUtil.getDateStringInUTC(formatter.format(new Date()), userInfo.getOffset(), true);
		int itemCabinetId          = -1;
		
		if (mode.equals("0")) {
			Map<String,Object> map = new HashMap<String, Object>();
			map.put("userId",   userId);
			map.put("tenantId", tenantId);
			map.put("type",     moduleType);
			
			CabinetVO cabinet = ezCabinetDAO.getRootCabinetByType(map);
			itemCabinetId     = cabinet.getCabinetId();
		}
		else {
			itemCabinetId = cabinetId;
		}
		
		//Add item
		addNewItem(itemCabinetId, itemId, moduleType, title, summary, content, timeUTC, userInfo);
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public JSONObject saveScheduleItem(int cabinetId, String realPath, String title, String summary, String mode, String scheduleTitle, String createUser, String createDate, String scheduleDate, String location, String publicstatus, String groupname, String attendant, String scheduletype, String attach, String content, Locale locale, LoginVO userInfo) throws Exception {
		JSONObject result      = new JSONObject();
		int tenantId           = userInfo.getTenantId();
		String companyId       = userInfo.getCompanyID();
		JSONParser jp          = new JSONParser();
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("tenantId", tenantId);
		
		//Get itemId
		int itemId = ezCabinetDAO.getMaxItem(map) + 1;
		
		//Save attach files
		if (!attach.equals("")) {
			JSONArray attachList = (JSONArray) jp.parse(attach);
			result               = cabinetService_h.saveListAttachFiles(attachList, itemId, realPath, "upload_schedule.ROOT", "", locale, userInfo);
			if (!result.get("status").equals("ok")) {
				return result;
			}
		}
		
		//Add schedule item
		int moduleType = 4; //schedule module
		addRelatedItem(itemId, moduleType, cabinetId, title, summary, content, mode, userInfo);
		
		//Save schedule columns information
		List<CabinetColumnVO> listColm = new ArrayList<>();
		listColm.add(createNewRelatedColumn("scheduleTitle", itemId, "ezCabinet.t62"  , scheduleTitle, companyId, tenantId));
		listColm.add(createNewRelatedColumn("creator"      , itemId, "ezSchedule.t161", createUser   , companyId, tenantId));
		listColm.add(createNewRelatedColumn("createdate"   , itemId, "ezSchedule.t306", createDate   , companyId, tenantId));
		listColm.add(createNewRelatedColumn("publicstatus" , itemId, "ezSchedule.t309", publicstatus , companyId, tenantId));
		listColm.add(createNewRelatedColumn("scheduledate" , itemId, "ezSchedule.t318", scheduleDate , companyId, tenantId));
		listColm.add(createNewRelatedColumn("location"     , itemId, "ezSchedule.t273", location     , companyId, tenantId));
		listColm.add(createNewRelatedColumn("scheduletype" , itemId, "ezCabinet.t143" , scheduletype , companyId, tenantId));
		
		if (!groupname.equals("")) {
			listColm.add(createNewRelatedColumn("groupname"   , itemId, "ezSchedule.t159", groupname   , companyId, tenantId));
		}
		
		if (!attendant.equals("")) {
			List<String> attendantList = (List<String>) jp.parse(attendant);
			if (attendantList.size() > 0) {
				listColm.add(createNewRelatedColumn("attendant", itemId, "ezSchedule.t163", String.join(";", attendantList), companyId, tenantId));
			}
		}
		
		saveAllColumns(listColm);
		
		result.put("status", "ok");
		result.put("code", 0);
		return result;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public JSONObject saveTodoItem(int cabinetId, String realPath, String title, String mode, String createUser, String createDate, String priority, String memo, String tasktype, String executor, String shareList, String attach, String content, Locale locale, LoginVO userInfo) throws Exception {
		JSONObject result      = new JSONObject();
		int tenantId           = userInfo.getTenantId();
		String companyId       = userInfo.getCompanyID();
		JSONParser jp          = new JSONParser();
		String shareStr        = "";
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("tenantId", tenantId);
		
		//Get itemId
		int itemId = ezCabinetDAO.getMaxItem(map) + 1;
		
		//Save attach files
		if (!attach.equals("")) {
			JSONArray attachList = (JSONArray) jp.parse(attach);
			result               = cabinetService_h.saveListAttachFiles(attachList, itemId, realPath, "", "", locale, userInfo);
			if (!result.get("status").equals("ok")) {
				return result;
			}
		}
		
		//Add todo item
		int moduleType = 5; //todo module
		addRelatedItem(itemId, moduleType, cabinetId, title, "", content, mode, userInfo);
		
		if (!shareList.equals("")) {
			List<String> shareUsers = (List<String>) jp.parse(shareList);
			
			if (shareUsers.size() > 0) {
				shareStr = String.join(";", shareUsers);
			}
		}
		
		//Save todo columns information
		List<CabinetColumnVO> listColm = new ArrayList<>();
		listColm.add(createNewRelatedColumn("creator"   , itemId, "ezTask.t117" , createUser, companyId, tenantId));
		listColm.add(createNewRelatedColumn("createdate", itemId, "ezTask.t155" , createDate, companyId, tenantId));
		listColm.add(createNewRelatedColumn("priority"  , itemId, "ezTask.t156" , priority  , companyId, tenantId));
		listColm.add(createNewRelatedColumn("memo"      , itemId, "ezTask.t170" , memo      , companyId, tenantId));
		listColm.add(createNewRelatedColumn("tasktype"  , itemId, "ezTask.t2003", tasktype  , companyId, tenantId));
		listColm.add(createNewRelatedColumn("executor"  , itemId, "ezTask.t2005", executor  , companyId, tenantId));
		listColm.add(createNewRelatedColumn("sharelist" , itemId, "ezTask.t157" , shareStr  , companyId, tenantId));
		
		saveAllColumns(listColm);
		
		result.put("status", "ok");
		result.put("code", 0);
		return result;
	}
	
	@Override
	public List<SimpleUserMailVO> getUserInfoFromEmail(List<String> receiverMail, String primary, int tenantId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("mailList",  receiverMail);
		map.put("tenantId",  tenantId);
		map.put("primary",   primary);
		
		return ezCabinetDAO.getUserInfoFromEmail(map);
	}
	
	@Override
	public SimpleUserInfoVO getSimpleUserInfo(String userId, String primary, int tenantId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("userId",   userId);
		map.put("tenantId", tenantId);
		map.put("primary",  primary);
		
		return ezCabinetDAO.getSimpleUserInfo(map);
	}
	
	@Override
	public List<SimpleUserInfoVO> getUsersInfoFromIdList(List<String> attendIds, String primary, int tenantId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("attendIds", attendIds);
		map.put("tenantId",  tenantId);
		map.put("primary",   primary);
		
		return ezCabinetDAO.getUsersInfoFromIdList(map);
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public JSONObject savePhotoBoard(int cabinetId, String realPath, String title, String summary, String boardTitle, String mode, String createUser, String createDate, String descript, String boardId, String boardItemId, Locale locale, LoginVO userInfo) throws Exception {
		int tenantId           = userInfo.getTenantId();
		String companyId       = userInfo.getCompanyID();
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("tenantId", tenantId);
		
		//Get itemId
		int itemId = ezCabinetDAO.getMaxItem(map) + 1;
		
		List<BoardAttachVO> photoViewList = getAllPhoto(boardItemId, boardId, tenantId);
		JSONArray attachList = new JSONArray();
		
		for (BoardAttachVO boardPhoto : photoViewList) {
			JSONObject photo = new JSONObject();
			String photoPath = boardPhoto.getFilePath();
			int position     = photoPath.lastIndexOf("/");
			String realName  = photoPath.substring(position + 1);
			
			if (realName.startsWith("s_")) {
				realName = realName.substring(2);
			}
			
			String firstPath = photoPath.substring(0, position + 1);
			
			photo.put("fileName", boardPhoto.getImageName());
			photo.put("filePath", firstPath + realName);
			photo.put("fileDesc", boardPhoto.getFileContent());
			attachList.add(photo);
		}
		
		//Save attach files
		JSONObject result = cabinetService_h.saveListAttachFiles(attachList, itemId, realPath, "", "", locale, userInfo);
		if (!result.get("status").equals("ok")) {
			return result;
		}
		
		//Add board item
		int moduleType = 3; //board module
		addRelatedItem(itemId, moduleType, cabinetId, title, summary, null, mode, userInfo);
		
		//Save board columns information
		List<CabinetColumnVO> listColm = new ArrayList<>();
		listColm.add(createNewRelatedColumn("boardTitle" , itemId, "ezCabinet.t62", boardTitle , companyId, tenantId));
		listColm.add(createNewRelatedColumn("boardWriter", itemId, "ezBoard.t223" , createUser , companyId, tenantId));
		listColm.add(createNewRelatedColumn("boardTime"  , itemId, "ezBoard.t224" , createDate , companyId, tenantId));
		listColm.add(createNewRelatedColumn("boardId"    , itemId, "ezBoard.t224" , boardId    , companyId, tenantId));
		listColm.add(createNewRelatedColumn("boardDesc"  , itemId, "ezBoard.t1008", descript   , companyId, tenantId));
		listColm.add(createNewRelatedColumn("boardItemId", itemId, "ezBoard.t224" , boardItemId, companyId, tenantId));
		listColm.add(createNewRelatedColumn("boardType"  , itemId, "ezBoard.t224" , "photo"    , companyId, tenantId));
		
		saveAllColumns(listColm);
		
		result.put("status", "ok");
		result.put("code", 0);
		return result;
	}
	
	public List<BoardAttachVO> getAllPhoto(String boardItemId, String boardId, int tenantId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_pItemID",  boardItemId);
		map.put("v_pBoardID", boardId);
		map.put("v_TENANTID", tenantId);
		
		return ezBoardDAO.photoViewDBAll(map);
	}
}
