package egovframework.ezEKP.ezWebFolder.service.impl;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import egovframework.ezEKP.ezWebFolder.dao.EzWebFolderDAO_m;
import egovframework.ezEKP.ezWebFolder.service.EzWebFolderService;
import egovframework.ezEKP.ezWebFolder.service.EzWebFolderService_m;
import egovframework.ezEKP.ezWebFolder.service.EzWebFolderService_y;
import egovframework.ezEKP.ezWebFolder.vo.ShareVO;

@Service("EzWebFolderService_m")
public class EzWebFolderServiceimpl_m implements EzWebFolderService_m {

	private static final Logger logger = LoggerFactory.getLogger(EzWebFolderServiceimpl_m.class);
	
	@Autowired
	private EzWebFolderDAO_m ezWebFolderDAO_m;
	
	@Autowired
	private EzWebFolderService ezWebFolderService;
	
	@Autowired
	private EzWebFolderService_y ezWebFolderService_y;
	
	@Override
	public List<ShareVO> getSharingList(String userId, String primary, String offset, int startPoint, int pageSize, int tenantId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>(); 
		map.put("userId",		userId);
		map.put("primary",		primary);
		map.put("offset",		offset);
		map.put("startPoint",	startPoint);
		map.put("pageSize",		pageSize);
		map.put("tenantId",		tenantId);
		
		List<ShareVO> list = ezWebFolderDAO_m.getSharingList(map);
		
		for (ShareVO vo : list) {
			// set userList
			String userList = vo.getUserList();
			
			if (userList != null && !userList.isEmpty()) {
				String[] userArr = userList.split(",");
				vo.setUserList(getUserNameList(userArr, primary, tenantId));
			}
			
			// set folderPath
			vo.setFolderPath(ezWebFolderService.getFolderPath(vo.getFolderPath().split("\\|"), primary, tenantId));
		}
		
		return list;
	}
	
	@Override
	public List<ShareVO> getSharedList(String userId, String deptId, String compId, String primary, String offset, int startPoint, int pageSize, int tenantId) throws Exception {
		List<String> idList = getPermissionIdList(userId, deptId, compId, tenantId);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userId",		userId);
		map.put("primary",		primary);
		map.put("offset",		offset);
		map.put("startPoint",	startPoint);
		map.put("pageSize",		pageSize);
		map.put("idList",		idList);
		map.put("tenantId",		tenantId);
		
		List<ShareVO> list = ezWebFolderDAO_m.getSharedList(map);
		
		for (ShareVO vo : list) {
			// set userList
			String userList = vo.getUserList();
			
			if (userList != null && !userList.isEmpty()) {
				String[] userArr = userList.split(",");
				vo.setUserList(getUserNameList(userArr, primary, tenantId));
			}
			
			// set folderPath
			vo.setFolderPath(ezWebFolderService.getFolderPath(vo.getFolderPath().split("\\|"), primary, tenantId));
		}
		
		return list;
	}
	
	@Override
	public Map<String, Integer> getSharingCount(String userId, String primary, String offset, int pageSize, int tenantId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>(); 
		map.put("userId",	userId);
		map.put("primary",	primary);
		map.put("offset",	offset);
		map.put("tenantId",	tenantId);
		
		List<Map<String, Object>> list = ezWebFolderDAO_m.getSharingCount(map);
		
		int fileCount	 = 0;
		int folderCount	 = 0;
		int totalCount	 = 0;
		int totalPage	 = 0;
		
		for (Map<String, Object> info : list) {
			String folderFileType = (String)info.get("FOLDERFILE_TYPE");
			if (folderFileType.equals("D")) {
				folderCount = (int)(long)info.get("COUNT");
			} else if (folderFileType.equals("F")) {
				fileCount = (int)(long)info.get("COUNT");
			}
		}
		
		totalCount	= fileCount + folderCount;
		totalPage	= (totalCount + pageSize - 1) / pageSize;
		
		Map<String, Integer> countInfo = new HashMap<String, Integer>();
		countInfo.put("fileCount", fileCount);
		countInfo.put("folderCount", folderCount);
		countInfo.put("totalCount", totalCount);
		countInfo.put("totalPage", totalPage);
		
		logger.debug("fileCount: " + fileCount + " || folderCount: " + folderCount + " || totalCount: " + totalCount + " || totalPage: " + totalPage);
		return countInfo;
	}
	
	@Override
	public Map<String, Integer> getSharedCount(String userId, String deptId, String compId, String primary, String offset, int pageSize, int tenantId) throws Exception {
		List<String> idList = getPermissionIdList(userId, deptId, compId, tenantId);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userId",	userId);
		map.put("primary",	primary);
		map.put("offset",	offset);
		map.put("idList",	idList);
		map.put("tenantId",	tenantId);
		
		List<Map<String, Object>> list = ezWebFolderDAO_m.getSharedCount(map);
		
		int fileCount	 = 0;
		int folderCount	 = 0;
		int totalCount	 = 0;
		int totalPage	 = 0;
		
		for (Map<String, Object> info : list) {
			String folderFileType = (String)info.get("FOLDERFILE_TYPE");
			if (folderFileType.equals("D")) {
				folderCount = (int)(long)info.get("COUNT");
			} else if (folderFileType.equals("F")) {
				fileCount = (int)(long)info.get("COUNT");
			}
		}
		
		totalCount	= fileCount + folderCount;
		totalPage	= (totalCount + pageSize - 1) / pageSize;
		
		Map<String, Integer> countInfo = new HashMap<String, Integer>();
		countInfo.put("fileCount", fileCount);
		countInfo.put("folderCount", folderCount);
		countInfo.put("totalCount", totalCount);
		countInfo.put("totalPage", totalPage);
		
		logger.debug("fileCount: " + fileCount + " || folderCount: " + folderCount + " || totalCount: " + totalCount + " || totalPage: " + totalPage);
		return countInfo;
	}
	
	@Override
	public int getShareSeq(int tenantId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("tenantId", tenantId);
		return ezWebFolderDAO_m.getShareSeq(map);
	}

	@Override
	public void insertShare(int seqId, String companyId, String userId, String userType, String folderFileId, String folderFileType, String createId, int tenantId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("seqId",          seqId);
		map.put("companyId",      companyId);
		map.put("userId",         userId);
		map.put("userType",       userType);
		map.put("folderFileId",   folderFileId);
		map.put("folderFileType", folderFileType);
		map.put("createId",       createId);
		map.put("tenantId",       tenantId);
		
		ezWebFolderDAO_m.insertShare(map);
	}

	@Override
	public void delShare(String companyId, String folderFileId, String folderFileType, String createId, int tenantId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("companyId",      companyId);
		map.put("folderFileId",   folderFileId);
		map.put("folderFileType", folderFileType);
		map.put("createId",       createId);
		map.put("tenantId",       tenantId);
		
		ezWebFolderDAO_m.delShare(map);
	}

	public String getUserNameList(String[] userArr, String primary, int tenantId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("idList",	Arrays.asList(userArr));
		map.put("primary",	primary);
		map.put("tenantId",	tenantId);
		
		List<String> userNames = ezWebFolderDAO_m.getUserNameList(map);
		
		return String.join(",", userNames);
	}
	
	public List<String> getPermissionIdList(String userId, String deptId, String compId, int tenantId) throws Exception {
		List<String> idList = new ArrayList<String>();
		
		List<String> addjobList = ezWebFolderService_y.getAddJobList(tenantId, userId);
		
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("userId",	userId);
		map.put("tenantId",	tenantId);
		
		List<String> folderUserIdList = ezWebFolderDAO_m.getFolderUserIdList_D(map);
		
		Set<String> idSet = new HashSet<String>();
		idSet.add(userId);
		idSet.add(deptId);
		idSet.add(compId);
		idSet.addAll(addjobList);
		idSet.addAll(folderUserIdList);
		
		idList.addAll(idSet);
		
		return idList;
	}
	
	public List<String> userDeptList(String userId, int tenantId) throws Exception {
		List<String> result = new ArrayList<String>();
		List<String> temp = new ArrayList<String>();
		Map<String,Object> map = new HashMap<String, Object>();
		String notInDept = "";
		
		map.put("userId", userId);
		map.put("tenantId", tenantId);
		
		result = chiefDeptList(userId, tenantId);
		
		logger.debug("result of chiefDeptList in userDeplist: " + result);
		
		if(result.size() >0) {
			notInDept = makeDeptString(result);
			
			logger.debug("notInDept in userDeptList: " + notInDept);
			
			map.put("notInDept", notInDept);
		}
		
		temp = ezWebFolderDAO_m.userDeptList(map);
		result.addAll(temp);
		
		logger.debug("userDeptList result: " + result);
		
		return result;
	}

	public List<String> chiefDeptPath(String userId, int tenantId)
			throws Exception {
		
		List<String> result = new ArrayList<String>();
		Map<String,Object> map = new HashMap<String, Object>();
		
		map.put("userId", userId);
		map.put("tenantId", tenantId);
		
		result = ezWebFolderDAO_m.chiefDeptPath(map);
		
		logger.debug("chiefDeptPath result: " + result);
		
		return result;
	}
	
	public List<String> chiefDeptList(String userId, int tenantId)
			throws Exception {
		
		List<String> result = new ArrayList<String>();
		List<String> temp = new ArrayList<String>();
		List<String> path = new ArrayList<String>();
		Map<String,Object> map = new HashMap<String, Object>();
		String notInDept = "";
		
		map.put("userId", userId);
		map.put("tenantId", tenantId);
		
		path = chiefDeptPath(userId, tenantId);
		
		if(path.size() >0) {
		
			for (int i = 0; i < path.size(); i++) {
				map.put("deptCdPath", path.get(i));
				map.put("notInDept", notInDept);
				
				logger.debug("chiefDeptList map : " + map);
				
				temp = ezWebFolderDAO_m.chiefDeptList(map);
				
				logger.debug("chiefDeptList temp: " + temp);
				
				if(temp.size() >0) {
					
					if(notInDept.isEmpty()) {
						notInDept = notInDept + makeDeptString(temp);
					} else {
						notInDept = notInDept + "," + makeDeptString(temp);
					}
				
				}
				
				result.addAll(temp);
			}

		}
				
		logger.debug("chiefDeptList result: " + result);
		
		return result;
	}

	public String makeDeptString(List<String> deptList) {
		
		String result = "";
		
		for (int i = 0; i < deptList.size(); i++) {
			
			result = result + ",'" + deptList.get(i) + "'";
			
		}
		
		result = result.substring(1);
		
		logger.debug("makeDeptString result: " + result);
		
		return result;
	}

}
