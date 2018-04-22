package egovframework.ezEKP.ezWebFolder.service.impl;

import java.io.File;
import java.io.FileNotFoundException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import egovframework.ezEKP.ezWebFolder.dao.EzWebFolderDAO_m;
import egovframework.ezEKP.ezWebFolder.dao.EzWebFolderDAO_y;
import egovframework.ezEKP.ezWebFolder.service.EzWebFolderAdminService;
import egovframework.ezEKP.ezWebFolder.service.EzWebFolderService;
import egovframework.ezEKP.ezWebFolder.service.EzWebFolderService_m;
import egovframework.ezEKP.ezWebFolder.service.EzWebFolderService_y;
import egovframework.ezEKP.ezWebFolder.vo.FavoriteFileVO;
import egovframework.ezEKP.ezWebFolder.vo.FileVO;
import egovframework.ezEKP.ezWebFolder.vo.FolderUserVO;
import egovframework.ezEKP.ezWebFolder.vo.FolderVO;
import egovframework.ezEKP.ezWebFolder.vo.SearchVO;
import egovframework.ezEKP.ezWebFolder.vo.ShareVO;
import egovframework.ezEKP.ezWebFolder.vo.TrashCanVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;

@Service("EzWebFolderService_m")
public class EzWebFolderServiceimpl_m implements EzWebFolderService_m {

	private static final Logger LOGGER = LoggerFactory.getLogger(EzWebFolderServiceimpl_m.class);
	
	@Autowired
	private EzWebFolderDAO_m ezWebFolderDAO_m;
	
	@Autowired
	private EzWebFolderDAO_m ezWebFolderDAO;
	
	@Autowired
	private EzWebFolderService ezWebFolderService;

	@Autowired
	private EzWebFolderService_y ezWebFolderService_y;
	
	@Autowired
	private EzWebFolderDAO_y ezWebFolderDAO_y;
	
	@Autowired
	private EzWebFolderAdminService ezWebFolderAdminService;
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Override
	public void insertIfNotExistRootForder(String userId, String userName1, String userName2, String compId, List<Map<String, String>> permissionIdList, String offset, int tenantId) throws Exception {
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Date date = new Date();
		String timeUTC = commonUtil.getDateStringInUTC(formatter.format(date), offset, true);
		LOGGER.debug("timeUTC: "+ timeUTC);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userId",      userId);
		map.put("compId",      compId);
		map.put("createName1", userName1);
		map.put("createName2", userName2);
		map.put("timeUTC",     timeUTC);
		map.put("tenantId",    tenantId);
		
		for (Map<String, String> idMap : permissionIdList) {
			map.put("ownerId",    idMap.get("id"));
			map.put("folderType", idMap.get("type"));
			
			if (ezWebFolderDAO_m.checkRootFolder(map) == 0) {
				ezWebFolderDAO_m.insertRootFolder(map);
				LOGGER.debug("root folder created. idMap: " + idMap);
			}
		}
	}
	
	@Override
	public List<Map<String, Object>> getFolderTree(String userId, String deptId, String compId, String folderType, String primary, int tenantId) throws Exception {
		List<Map<String, Object>> folderTree = new ArrayList<Map<String, Object>>();
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("primary", primary);
		map.put("tenantId", tenantId);
		
		//TODO: 폴더 트리뷰 정렬 기준?
		if (folderType.equals("U") || folderType.equals("")) {
			map.put("userId", userId);
			List<Map<String, Object>> userFolderTree = ezWebFolderDAO_m.getUserFolderTree(map);
			folderTree.addAll(userFolderTree);
		}
		
		if (folderType.equals("D") || folderType.equals("")) {
			List<String> addjobList = ezWebFolderService_y.getAddJobList(tenantId, userId);
			
			Map<String,Object> map2 = new HashMap<String, Object>();
			map2.put("userId",   userId);
			map2.put("tenantId", tenantId);
			
			List<String> folderUserIdList = ezWebFolderDAO_m.getFolderUserIdList_D(map2);
			
			Set<String> idSet = new HashSet<String>();
			idSet.add(deptId);
			idSet.addAll(addjobList);
			idSet.addAll(folderUserIdList);
			
			map.put("idList", idSet.toArray(new String[idSet.size()]));
			List<Map<String, Object>> deptFolderTree = ezWebFolderDAO_m.getDeptFolderTree(map);
			folderTree.addAll(deptFolderTree);
		}
		
		if (folderType.equals("C") || folderType.equals("")) {
			List<String> addjobList = ezWebFolderService_y.getAddJobList(tenantId, userId);
			
			Map<String,Object> map2 = new HashMap<String, Object>();
			map2.put("userId",   userId);
			map2.put("tenantId", tenantId);
			
			List<String> folderUserIdList = ezWebFolderDAO_m.getFolderUserIdList_D(map2);
			
			Set<String> idSet = new HashSet<String>();
			idSet.add(userId);
			idSet.add(deptId);
			idSet.add(compId);
			idSet.addAll(addjobList);
			idSet.addAll(folderUserIdList);
			
			map.put("idList", idSet.toArray(new String[idSet.size()]));
			map.put("compId", compId);
			List<Map<String, Object>> compFolderTree = ezWebFolderDAO_m.getCompFolderTree(map);
			folderTree.addAll(compFolderTree);
		}
		
		LOGGER.debug("folderTree size: " + folderTree.size());
		return folderTree;
	}
	
	@Override
	public List<ShareVO> getSharingList(String userId, String primary, String offset, int startPoint, int pageSize, SearchVO searchInfo, int tenantId) throws Exception {
		String searchStartDate = searchInfo.getSearchStartDate();
		String searchEndDate = searchInfo.getSearchEndDate();
		
		if (!searchStartDate.equals("") && !searchEndDate.equals("")) {
			searchStartDate = commonUtil.getDateStringInUTC(searchStartDate + " 00:00:00", offset, true);
			searchEndDate   = commonUtil.getDateStringInUTC(searchEndDate + " 23:59:59", offset, true);
		}
		
		Map<String, Object> map = new HashMap<String, Object>(); 
		map.put("userId",		     userId);
		map.put("primary",		     primary);
		map.put("offset",		     commonUtil.getMinuteUTC(offset));
		map.put("startPoint",	     startPoint);
		map.put("pageSize",		     pageSize);
		map.put("tenantId",		     tenantId);
		map.put("searchExt",         searchInfo.getSearchExt());
		map.put("searchFileName",    searchInfo.getSearchFileName());
		map.put("searchCreatorName", searchInfo.getSearchCreateName());
		map.put("searchFileType",    searchInfo.getSearchFileType());
		map.put("searchStartDate",   searchStartDate);
		map.put("searchEndDate",     searchEndDate);
		
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
	public List<ShareVO> getSharedList(String userId, String deptId, String compId, String primary, String offset, int startPoint, int pageSize, SearchVO searchInfo, int tenantId) throws Exception {
		String searchStartDate = searchInfo.getSearchStartDate();
		String searchEndDate = searchInfo.getSearchEndDate();
		
		if (!searchStartDate.equals("") && !searchEndDate.equals("")) {
			searchStartDate = commonUtil.getDateStringInUTC(searchStartDate + " 00:00:00", offset, true);
			searchEndDate   = commonUtil.getDateStringInUTC(searchEndDate + " 23:59:59", offset, true);
		}
		
		List<Map<String, String>> idList = getPermissionIdList(userId, deptId, compId, tenantId);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userId",	         userId);
		map.put("primary",	         primary);
		map.put("offset",	         commonUtil.getMinuteUTC(offset));
		map.put("startPoint",        startPoint);
		map.put("pageSize",	         pageSize);
		map.put("idList",	         idList);
		map.put("tenantId",	         tenantId);
		map.put("searchExt",         searchInfo.getSearchExt());
		map.put("searchFileName",    searchInfo.getSearchFileName());
		map.put("searchCreatorName", searchInfo.getSearchCreateName());
		map.put("searchFileType",    searchInfo.getSearchFileType());
		map.put("searchStartDate",   searchStartDate);
		map.put("searchEndDate",     searchEndDate);
		
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
	public Map<String, Integer> getSharingCount(String userId, String primary, String offset, int pageSize, SearchVO searchInfo, int tenantId) throws Exception {
		String searchStartDate = searchInfo.getSearchStartDate();
		String searchEndDate = searchInfo.getSearchEndDate();
		
		if (!searchStartDate.equals("") && !searchEndDate.equals("")) {
			searchStartDate = commonUtil.getDateStringInUTC(searchStartDate + " 00:00:00", offset, true);
			searchEndDate   = commonUtil.getDateStringInUTC(searchEndDate + " 23:59:59", offset, true);
		}
		
		Map<String, Object> map = new HashMap<String, Object>(); 
		map.put("userId",	         userId);
		map.put("primary",	         primary);
		map.put("offset",	         commonUtil.getMinuteUTC(offset));
		map.put("tenantId",	         tenantId);
		map.put("searchExt",         searchInfo.getSearchExt());
		map.put("searchFileName",    searchInfo.getSearchFileName());
		map.put("searchCreatorName", searchInfo.getSearchCreateName());
		map.put("searchFileType",    searchInfo.getSearchFileType());
		map.put("searchStartDate",   searchStartDate);
		map.put("searchEndDate",     searchEndDate);
		
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
		
		LOGGER.debug("countInfo: " + countInfo);
		return countInfo;
	}
	
	@Override
	public Map<String, Integer> getSharedCount(String userId, String deptId, String compId, String primary, String offset, int pageSize, SearchVO searchInfo, int tenantId) throws Exception {
		String searchStartDate = searchInfo.getSearchStartDate();
		String searchEndDate = searchInfo.getSearchEndDate();
		
		if (!searchStartDate.equals("") && !searchEndDate.equals("")) {
			searchStartDate = commonUtil.getDateStringInUTC(searchStartDate + " 00:00:00", offset, true);
			searchEndDate   = commonUtil.getDateStringInUTC(searchEndDate + " 23:59:59", offset, true);
		}
		
		List<Map<String, String>> idList = getPermissionIdList(userId, deptId, compId, tenantId);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userId",	userId);
		map.put("primary",	primary);
		map.put("offset",	commonUtil.getMinuteUTC(offset));
		map.put("idList",	idList);
		map.put("tenantId",	tenantId);
		map.put("searchExt",         searchInfo.getSearchExt());
		map.put("searchFileName",    searchInfo.getSearchFileName());
		map.put("searchCreatorName", searchInfo.getSearchCreateName());
		map.put("searchFileType",    searchInfo.getSearchFileType());
		map.put("searchStartDate",   searchStartDate);
		map.put("searchEndDate",     searchEndDate);
		
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
		
		LOGGER.debug("countInfo: " + countInfo);
		return countInfo;
	}
	
	@Override
	public boolean isShared(String folderFileId, String folderFileType, String folderPath, int tenantId) throws Exception {
		boolean isShared = false;
		folderPath = folderPath.substring(1, folderPath.length() - 1);
		String[] folderPathArr = folderPath.split("\\|");
		List<String> folderIdList = new ArrayList<String>();
		
		for (String id : folderPathArr) {
			folderIdList.add(id);
		}
		
		String folderId = folderIdList.remove(folderIdList.size() - 1);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("fileId", folderFileId);
		map.put("folderId", folderId);
		map.put("folderFileType", folderFileType);
		map.put("parentIdList", folderIdList);
		map.put("tenantId",	tenantId);
		
		if (ezWebFolderDAO_m.isShared(map) > 0) {
			isShared = true;
		}
		
		return isShared;
	}
	
	@Override
	public List<Map<String, String>> getPermissionIdList(String userId, String deptId, String compId, int tenantId) throws Exception {
		List<Map<String, String>> idList = new ArrayList<Map<String, String>>();
		
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
		
		Map<String, String> idMap = null;
		
		for (String id : idSet) {
			idMap = new HashMap<String, String>();
			idMap.put("id", id);
			
			if (id.equals(userId)) {
				idMap.put("type", "U");
			} else if (id.equals(compId)) {
				idMap.put("type", "C");
			} else {
				idMap.put("type", "D");
			}
			
			idList.add(idMap);
		}
		
		LOGGER.debug("idList: " + idList);
		return idList;
	}
	
	@Override
	public void insertShare(String sharerId, String folderFileId, String folderFileType, List<Map<String, String>> userList, String offset, int tenantId) throws Exception {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Date date            = new Date();
		String shareDate     = commonUtil.getDateStringInUTC(sdf.format(date), offset, true);
		
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("sharerId",       sharerId);
		map.put("folderFileId",   folderFileId);
		map.put("folderFileType", folderFileType);
		map.put("userNameList",   "");
		map.put("shareDate",      shareDate);
		map.put("tenantId",       tenantId);
		
		//TODO: 폴더 또는 파일이 존재하는지, 사용중인지, 권한이 있는지 확인
		
		int shareId = ezWebFolderDAO_m.insertShare(map);
		
		Map<String,Object> map2 = new HashMap<String, Object>();
		map2.put("shareId",       shareId);
		map2.put("tenantId",      tenantId);
		
		for (Map<String, String> userInfo : userList) {
			map2.put("userId",    userInfo.get("id"));
			map2.put("userType",  userInfo.get("type"));
			map2.put("subStatus", userInfo.get("subStatus"));
			
			ezWebFolderDAO_m.insertShareSub(map2);
		}
		
		Map<String,Object> map3 = new HashMap<String, Object>();
		map3.put("shareId",   shareId);
		map3.put("shareDate", shareDate);
		map3.put("idList",    userList);
		map3.put("tenantId",  tenantId);
		
		ezWebFolderDAO_m.updateShareUserNameList(map3);
	}
	
	@Override
	public void updateShare(String shareId, String sharerId, List<Map<String, String>> userList, String offset, int tenantId) throws Exception {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Date date            = new Date();
		String shareDate     = commonUtil.getDateStringInUTC(sdf.format(date), offset, true);
		
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("shareId",       shareId);
		map.put("tenantId",      tenantId);
		
		ezWebFolderDAO_m.deleteShareSub(map);
		
		for (Map<String, String> userInfo : userList) {
			map.put("userId",    userInfo.get("id"));
			map.put("userType",  userInfo.get("type"));
			map.put("subStatus", userInfo.get("subStatus"));
			
			ezWebFolderDAO_m.insertShareSub(map);
		}
		
		Map<String,Object> map2 = new HashMap<String, Object>();
		map2.put("shareId",   shareId);
		map2.put("shareDate", shareDate);
		map2.put("idList",    userList);
		map2.put("tenantId",  tenantId);
		
		ezWebFolderDAO_m.updateShareUserNameList(map2);
	}
	
	@Override
	public void deleteShare(String shareId, String sharerId, String offset, int tenantId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("shareId",  shareId);
		map.put("tenantId", tenantId);
		
		ezWebFolderDAO_m.deleteShare(map);
	}
	
	@Override
	public void hideShare(String shareId, String userId, String offset, int tenantId) throws Exception {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Date date            = new Date();
		String shareDate     = commonUtil.getDateStringInUTC(sdf.format(date), offset, true);
		
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("shareId",  shareId);
		map.put("userId",   userId);
		map.put("hideDate", shareDate);
		map.put("tenantId", tenantId);
		
		ezWebFolderDAO_m.hideShare(map);
	}
	
	@Override
	public void showShare(String shareId, String userId, String offset, int tenantId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("shareId",  shareId);
		map.put("userId",   userId);
		map.put("tenantId", tenantId);
		
		ezWebFolderDAO_m.showShare(map);
	}
	
	@Override
	public int getShareSeq(int tenantId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("tenantId", tenantId);
		return ezWebFolderDAO_m.getShareSeq(map);
	}
	
	public String getUserNameList(String[] userArr, String primary, int tenantId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("idList",	Arrays.asList(userArr));
		map.put("primary",	primary);
		map.put("tenantId",	tenantId);
		
		List<String> userNames = ezWebFolderDAO_m.getUserNameList(map);
		
		return String.join(",", userNames);
	}
	
	public List<String> userDeptList(String userId, int tenantId) throws Exception {
		List<String> result = new ArrayList<String>();
		List<String> temp = new ArrayList<String>();
		Map<String,Object> map = new HashMap<String, Object>();
		String notInDept = "";
		
		map.put("userId", userId);
		map.put("tenantId", tenantId);
		
		result = chiefDeptList(userId, tenantId);
		
		LOGGER.debug("result of chiefDeptList in userDeplist: " + result);
		
		if(result.size() >0) {
			notInDept = makeDeptString(result);
			
			LOGGER.debug("notInDept in userDeptList: " + notInDept);
			
			map.put("notInDept", notInDept);
		}
		
		temp = ezWebFolderDAO_m.userDeptList(map);
		result.addAll(temp);
		
		LOGGER.debug("userDeptList result: " + result);
		
		return result;
	}

	public List<String> chiefDeptPath(String userId, int tenantId)
			throws Exception {
		
		List<String> result = new ArrayList<String>();
		Map<String,Object> map = new HashMap<String, Object>();
		
		map.put("userId", userId);
		map.put("tenantId", tenantId);
		
		result = ezWebFolderDAO_m.chiefDeptPath(map);
		
		LOGGER.debug("chiefDeptPath result: " + result);
		
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
		
		if(path.size() > 0) {
		
			for (int i = 0; i < path.size(); i++) {
				map.put("deptCdPath", path.get(i));
				map.put("notInDept", notInDept);
				
				LOGGER.debug("chiefDeptList map : " + map);
				
				temp = ezWebFolderDAO_m.chiefDeptList(map);
				
				LOGGER.debug("chiefDeptList temp: " + temp);
				
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
				
		LOGGER.debug("chiefDeptList result: " + result);
		
		return result;
	}

	public String makeDeptString(List<String> deptList) {
		
		String result = "";
		
		for (int i = 0; i < deptList.size(); i++) {

			result = result + ",'" + deptList.get(i) + "'";

		}
		
		result = result.substring(1);
		
		LOGGER.debug("makeDeptString result: " + result);
		
		return result;
	}

	@SuppressWarnings("unchecked")
	@Override
	public JSONObject getTrashCanList(String userId, String offset, int tenantId, int currPage, int pEnd, 
			String searchExt, String searchFileName, String searchCreateName,String searchFileType, String endrollStartDate, String endrollEndDate,
			String delStartDate, String delEndDate) throws Exception {
		int totalRows  =  0;
		int totalPages = 0;
		int pStart 	   = 0;
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userId", userId);
		map.put("offset", offset);
		map.put("tenantId", tenantId);
		map.put("searchExt", searchExt);
		map.put("searchFileName", searchFileName);
		map.put("searchCreateName", searchCreateName);
		map.put("searchFileType", searchFileType);
		map.put("endrollStartDate", endrollStartDate);
		map.put("endrollEndDate", endrollEndDate);
		map.put("delStartDate", delStartDate);
		map.put("delEndDate", delEndDate);
		
		JSONObject result = new JSONObject();
		int fileCnt = ezWebFolderDAO.getTrashFileCount(map);
		int folderCnt = ezWebFolderDAO.getTrashFolderCount(map);
		
		totalRows  = fileCnt + folderCnt;
		totalPages = (totalRows + pEnd - 1)/pEnd;
		currPage   = currPage > totalPages ? totalPages : currPage;
		currPage   = currPage == 0         ? 1          : currPage;
		pStart     = (currPage - 1) * pEnd;
		
		map.put("pStart", pStart);
		map.put("pEnd", pEnd);
		
		List<TrashCanVO> trashCanList = ezWebFolderDAO.getTrashCanList(map);
		List<TrashCanVO> resultList = new ArrayList<TrashCanVO>();
		
		currPage = totalPages == 0 ? 0 : currPage;
		fileCnt = 0;
		folderCnt = 0;
		
		if (trashCanList != null) {
			for (TrashCanVO trashCan : trashCanList) {
				if (trashCan.getTrashCanExt().equals("folder")) {
					FolderVO upperFolder = ezWebFolderService.getFolderByFolderId(trashCan.getFolderUpper(), offset, tenantId);
					
					if (upperFolder.getUseStatus().equals("Y")) {
						resultList.add(trashCan);
						folderCnt += 1;
					} 
					
				} else {
					map.put("folderId", trashCan.getFileFolderId());
					String folderPath = ezWebFolderDAO.getFolderPath(map);
					
					if (folderPath != null) {
						trashCan.setTrashCanPath(folderPath);
					}
					
					FolderVO folder = ezWebFolderService.getFolderByFolderId(trashCan.getFileFolderId(), offset, tenantId);
					
					if (folder != null && folder.getUseStatus().equals("Y")) {
						resultList.add(trashCan);
						fileCnt += 1;
					}
				}
			}
		}
		
		totalRows  = fileCnt + folderCnt;
		totalPages = (totalRows + pEnd - 1)/pEnd;
		
		result.put("fileCnt", fileCnt);
		result.put("folderCnt", folderCnt);
		result.put("trashCanList", resultList);
		result.put("totalPages", totalPages);
		result.put("currentPage", currPage);
		result.put("totalRows", totalRows);
		
		LOGGER.debug("result=" + result);
		return result;
	}


	@Override
	public String getFolderPath(String folderId, int tenantId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("folderId", folderId);
		map.put("tenantId", tenantId);
		
		String folderPath = ezWebFolderDAO.getFolderPath(map);
		
		return folderPath;
	}

	@Override
	public void permanetDeleteSelectedFiles(String[] fileIDList, String[] folderIDList ,LoginVO userInfo, String realPath) throws Exception {
		String userName1 = userInfo.getDisplayName1();
		String userName2 = userInfo.getDisplayName2();
		String companyId = userInfo.getCompanyID();
		int tenantId     = userInfo.getTenantId();
		String offset    = userInfo.getOffset();
		String userId    = userInfo.getId();
		
		for (String file : fileIDList ) {
			FileVO fileVO = ezWebFolderService.getFileByFileId(file, offset, tenantId);
			
			if (fileVO != null) {
				deleteFile(file, tenantId);
				ezWebFolderService.saveLog("P", companyId, offset, userId, userName1, userName2, fileVO.getFileName(), fileVO.getFileSize(), fileVO.getFileExt(), fileVO.getFileTypeName(), tenantId);
				realFileDelete(fileVO.getFileName(), realPath, userInfo);
			}
		}
		
		for (String folder : folderIDList) {
			FolderVO folderVO = ezWebFolderService.getFolderByFolderId(folder, offset, tenantId);
			
			if (folderVO != null) {
				deleteFolder(folderVO);
				deleteAllFilesInFolder(folderVO);
				realFileDeleteInFolder(folderVO.getFolderPath(), companyId, realPath, userInfo, offset, tenantId);
			}
		}
	}

	@Override
	public void realFileDelete(String fileName, String realPath, LoginVO userInfo) throws Exception {
		
		String pDirPath = getWebFolderDirPath(userInfo.getTenantId());
		pDirPath = realPath + pDirPath;
		
		if (!pDirPath.substring(pDirPath.length() - 1).equals(commonUtil.separator)) {
			pDirPath = pDirPath + commonUtil.separator;
		}
		
		File file = new File(pDirPath + fileName);
		
		if (file.exists()) {
			if (file.delete()) {
				LOGGER.debug(fileName + "delete is success");
			} else {
				LOGGER.debug(fileName + "delete is fail");
			}
		} else {
			throw new FileNotFoundException(fileName);
		}
	}
	
	@Override
	public void realFileDeleteInFolder(String folderPath, String companyId ,String realPath, LoginVO userInfo, String offset, int tenantId) throws Exception {
		List<TrashCanVO> innerFolderList = getFolderByFolderPath(folderPath, tenantId, companyId);
		
		for (TrashCanVO innerfolder : innerFolderList) {
			List<TrashCanVO> innserFileList = getFileByFolderId(innerfolder.getTrashCanId(), tenantId, userInfo.getId());
			
			if (innserFileList != null) {
				for (TrashCanVO innerfile : innserFileList) {
					FileVO file = ezWebFolderService.getFileByFileId(innerfile.getTrashCanId(), offset, tenantId);
					ezWebFolderService.saveLog("P", companyId, offset, userInfo.getId(),userInfo.getDisplayName1(), userInfo.getDisplayName2(), innerfile.getTrashCanName(), String.valueOf(innerfile.getTrashCanSize()), innerfile.getTrashCanExt(), file.getFileTypeName(), tenantId);
					realFileDelete(innerfile.getTrashCanName(), realPath, userInfo);
				}
			}
		}
		
	}
	
	@Override
	public void deleteFile(String fileId, int tenantId) throws Exception {

		Map<String,Object> map = new HashMap<String, Object>();
		map.put("fileId", fileId);
		map.put("tenantId", tenantId);
		
		int result = ezWebFolderDAO.deleteFile(map);
		
		if (result > 0) {
			LOGGER.debug("deleteFile is success");
		} else {
			LOGGER.debug("deleteFile is fail");
		}
	}

	@Override
	public void deleteFolder (FolderVO folderVO) throws Exception {
		
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("folderPath", folderVO.getFolderPath());
		map.put("tenantId", folderVO.getTenantId());
		map.put("companyId", folderVO.getCompanyId());
		
		int result = ezWebFolderDAO.deleteFolder(map);
		
		if (result > 0) {
			LOGGER.debug("deleteFolder is success");
		} else {
			LOGGER.debug("deleteFolder is fail");
		}
	}

	@Override
	public void deleteAllFilesInFolder(FolderVO folderVO) throws Exception {
		
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("folderPath", folderVO.getFolderPath());
		map.put("tenantId", folderVO.getTenantId());
		map.put("companyId", folderVO.getCompanyId());
		
		int result = ezWebFolderDAO.deleteAllFilesInFolder(map);
		
		if (result > 0) {
			LOGGER.debug("deleteAllFilesInFolder is success");
		} else {
			LOGGER.debug("deleteAllFilesInFolder is fail");
		}
	}

	@Override
	public List<TrashCanVO> getFileByFolderId(String folderId, int tenantId, String userId) throws Exception {
		LOGGER.debug("getFileByFolderId Started.");

		Map<String,Object> map = new HashMap<String, Object>();
		map.put("folderId", folderId);
		map.put("tenantId", tenantId);
		map.put("userId", userId);
		
		List<TrashCanVO> fileList = ezWebFolderDAO.getFileListByFolderId(map);
		
		LOGGER.debug("getFileByFolderId ended");
		return fileList;
	}

	@Override
	public List<TrashCanVO> getFolderByFolderPath(String folderPath, int tenantId, String companyId) throws Exception {
		
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("folderPath", folderPath);
		map.put("tenantId", tenantId);
		map.put("companyId", companyId);
		
		List<TrashCanVO> folderList = ezWebFolderDAO.getFolderByFolderPath(map);
		
		return folderList;
	}
	
	@Override
	public void restoreFile(String fileId, int tenantId, String userId, String timeUTC) throws Exception {
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("fileId", fileId);
		map.put("tenantId", tenantId);
		map.put("userId", userId);
		map.put("timeUTC", timeUTC);
		
		int result = ezWebFolderDAO.restoreFile(map);
		
		if (result > 0) {
			LOGGER.debug("restoreFile is success");
		} else {
			LOGGER.debug("restoreFile is fail");
		}
	}
	
	@Override
	public void restoreFolder(String folderPath, int tenantId, String userId, String companyId, String timeUTC) throws Exception{
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("folderPath", folderPath);
		map.put("tenantId", tenantId);
		map.put("userId", userId);
		map.put("companyId", companyId);
		map.put("timeUTC", timeUTC);
		
		int result = ezWebFolderDAO.restoreFolder(map);
		
		if (result > 0) {
			LOGGER.debug("restoreFolder is success");
		} else {
			LOGGER.debug("restoreFolder is fail");
		}
	}
	
	@Override
	public void restoreTrashCan(String[] fileIDList, String[] folderIDList, int tenantId, String userId, String offset, String companyId, String timeUTC) throws Exception {

		for (String file : fileIDList) {
			if (!file.equals("")) {
				FileVO fileVO  = ezWebFolderService.getFileByFileId(file, offset, tenantId);
				
				if (fileVO != null) {
					FolderVO folderVO = ezWebFolderService.getFolderByFolderId(fileVO.getFolderId(), offset, tenantId);
					
					if (folderVO != null) {
						restoreFile(file, tenantId, userId, timeUTC);
					}
				}
			}
		}
		
		for (String folder : folderIDList) {
			if (!folder.equals("")) {
				FolderVO folderVO = ezWebFolderService.getFolderByFolderId(folder, offset, tenantId);
				FolderVO upperFolderVO = ezWebFolderService.getFolderByFolderId(folderVO.getFolderUpper(), offset, tenantId);
				
				if (upperFolderVO != null && folderVO.getFolderPath().startsWith(upperFolderVO.getFolderPath())) {
					restoreFolder(folderVO.getFolderPath(), tenantId, userId, companyId, timeUTC);
					restoreFileInFolder(folderVO.getFolderPath(), tenantId, userId, timeUTC);
				}
			}
		}
	}
	
	@Override
	public void restoreFileInFolder(String folderPath, int tenantId, String userId, String timeUTC) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("folderPath", folderPath);
		map.put("tenantId", tenantId);
		map.put("userId", userId);
		map.put("timeUTC", timeUTC);
		
		int result = ezWebFolderDAO.restoreAllFilesInFolder(map);
		
		if (result > 0) {
			LOGGER.debug("restoreFileInFolder is success");
		} else {
			LOGGER.debug("restoreFileInFolder is fail");
		}
		
	}
			
	private String getWebFolderDirPath(int tenantId) {
		return commonUtil.separator + "fileroot" + commonUtil.separator + tenantId + commonUtil.separator + "webfolder" + commonUtil.separator;
	}
		
	@Override
	public List<FavoriteFileVO> getFavorites(String userId, String offset, int tenantId, SearchVO searchInfo, int startIndex, int listCount) throws Exception {

		Map<String, Object> parameterMap = new HashMap<>();
		parameterMap.put("userId", userId);
		parameterMap.put("offset", commonUtil.getMinuteUTC(offset));
		parameterMap.put("tenantId", tenantId);
		// search info
		parameterMap.put("searchExt", searchInfo.getSearchExt());
		parameterMap.put("searchFileName", searchInfo.getSearchFileName());
		parameterMap.put("searchCreatorName", searchInfo.getSearchCreateName());
		parameterMap.put("searchFileType", searchInfo.getSearchFileType());
		parameterMap.put("searchStartDate", searchInfo.getSearchStartDate());
		parameterMap.put("searchEndDate", searchInfo.getSearchEndDate());
		parameterMap.put("startIndex", startIndex);
		parameterMap.put("listCount", listCount);

		List<FavoriteFileVO> result = ezWebFolderDAO.getFavorites(parameterMap);

		return result;
	}

	@Override
	public Map<String, Integer> getFavoriteCount(String userId, String offset, int tenantId, SearchVO searchInfo) throws Exception {

		Map<String, Object> parameterMap = new HashMap<>();
		parameterMap.put("userId", userId);
		parameterMap.put("offset", commonUtil.getMinuteUTC(offset));
		parameterMap.put("tenantId", tenantId);
		// search info
		parameterMap.put("searchExt", searchInfo.getSearchExt());
		parameterMap.put("searchFileName", searchInfo.getSearchFileName());
		parameterMap.put("searchCreatorName", searchInfo.getSearchCreateName());
		parameterMap.put("searchFileType", searchInfo.getSearchFileType());
		parameterMap.put("searchStartDate", searchInfo.getSearchStartDate());
		parameterMap.put("searchEndDate", searchInfo.getSearchEndDate());
		
		Integer folderCount = ezWebFolderDAO.getFavoriteFolderCount(parameterMap);
		Integer fileCount = ezWebFolderDAO.getFavoriteFileCount(parameterMap);
		
		Map<String, Integer> result = new HashMap<String, Integer>();
		result.put("totalCount", folderCount + fileCount);
		result.put("folderCount", folderCount);
		result.put("fileCount", fileCount);
		
		return result;
	}
	
	@Override
	public boolean isExistsFavorite(String userId, String targetId, String targetType, int tenantId) throws Exception {
		
		Map<String, Object> parameterMap = new HashMap<>();
		parameterMap.put("userId", userId);
		parameterMap.put("targetId", targetId);
		parameterMap.put("targetType", targetType);
		parameterMap.put("tenantId", tenantId);
		
		LOGGER.debug("insi1: "+parameterMap.toString());

		Integer count = ezWebFolderDAO.isExistsFavorite(parameterMap);
		
		LOGGER.debug("insi: "+(count == 1));
		
		return count == 1;
	}
	
	@Override
	public void addFavorite(String userId, String targetId, String targetType, String createDate, int tenantId) throws Exception {
		
		Map<String, Object> parameterMap = new HashMap<>();
		parameterMap.put("userId", userId);
		parameterMap.put("targetId", targetId);
		parameterMap.put("targetType", targetType);
		parameterMap.put("createDate", createDate);
		parameterMap.put("tenantId", tenantId);

		ezWebFolderDAO.addFavorite(parameterMap);
	}

	@Override
	public void deleteFavorite(String userId, String targetId, String targetType, int tenantId) throws Exception {
		
		Map<String, Object> parameterMap = new HashMap<>();
		parameterMap.put("userId", userId);
		parameterMap.put("targetId", targetId);
		parameterMap.put("targetType", targetType);
		parameterMap.put("tenantId", tenantId);

		ezWebFolderDAO.deleteFavorite(parameterMap);
	}

	@Override
	public void moveTrashCan(String[] fileIDList, String[] folderIDList,String folderId, int tenantId, 
			String userId, String offset, String companyId, String userName1, String userName2, String timeUTC) throws Exception {
		for (String file : fileIDList) {
			if (!file.equals("")) {
				FileVO fileVO  = ezWebFolderService.getFileByFileId(file, offset, tenantId);
				
				if (fileVO != null) {
					moveFile (file, folderId, tenantId , timeUTC);
					ezWebFolderService.saveLog("U", companyId, offset, userId, userName1, userName2, fileVO.getFileName(), fileVO.getFileSize(), fileVO.getFileExt(), fileVO.getFileTypeName(), tenantId);

				}
			}
		}
		
		for (String folder : folderIDList) {
			if (!folder.equals("")) {
				FolderVO folderVO = ezWebFolderService.getFolderByFolderId(folder, offset, tenantId);
				FolderVO destFolderVO = ezWebFolderService.getFolderByFolderId(folderId, offset, tenantId);
				
				if (destFolderVO != null) {
					moveFolder(folderVO, destFolderVO, userId, offset, tenantId, timeUTC);
					restoreFileInFolder(folderVO.getFolderPath(), tenantId, userId, timeUTC);
				}
			}
		}
	}
	
	@Override
	public void moveFolder (FolderVO folderVO, FolderVO destFolderVO, String userId, String offset, int tenantId, String timeUTC) throws Exception {
		String oldPath = folderVO.getFolderPath();
		String newPath = destFolderVO.getFolderPath() + folderVO.getFolderId() + "|";
		int levelDistance = destFolderVO.getFolderLevel() + 1 - folderVO.getFolderLevel();
		
		if (folderVO.getFolderLevel() == 1) {
			ezWebFolderAdminService.deleteFolderUsers(folderVO.getFolderId(), tenantId);
		}
		
		if ((folderVO.getFolderLevel() + levelDistance == 1) && destFolderVO.getFolderType().equals("C")) {
			String folderPath            = folderVO.getFolderPath();
			folderPath                   = folderPath.substring(1, folderPath.length() - 1);
			String ancestorId            = folderVO.getFolderType().equals("C") ? folderPath.split("\\|")[1] : folderPath.split("\\|")[0];
			List<FolderUserVO> listUsers = ezWebFolderService.getFolderUsers(ancestorId, tenantId);
			
			for (FolderUserVO folderUser: listUsers) {
				ezWebFolderAdminService.insertFolderUser(ezWebFolderAdminService.getMaxFolderUserSeq(tenantId), folderUser.getUserId(), folderUser.getUserType(), folderVO.getFolderId(), userId, timeUTC, folderVO.getCompanyId(), tenantId);
			}
		}
		
		folderVO.setFolderPath(newPath);
		folderVO.setOwnerId(destFolderVO.getOwnerId());
		folderVO.setFolderType(destFolderVO.getFolderType());
		folderVO.setUpdateId(userId);
		folderVO.setUpdateDate(timeUTC);
		folderVO.setFolderUpper(destFolderVO.getFolderId());
		folderVO.setFolderLevel(folderVO.getFolderLevel() + levelDistance);
		folderVO.setFolderStep(ezWebFolderAdminService.getMaxFolderStep(destFolderVO.getFolderId(), tenantId));
		folderVO.setUseStatus("Y");
		ezWebFolderAdminService.insertFolder(folderVO);
		
		movSubFolders(userId, destFolderVO.getFolderType(), oldPath, newPath, timeUTC, destFolderVO.getOwnerId(), levelDistance, tenantId);
	}
	
	@Override
	public void movSubFolders(String userId, String folderType, String oldPath, String newPath, String timeUTC, String ownerId,
			int levelDistance, int tenantId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("userId",        userId);
		map.put("folderType",    folderType);
		map.put("oldPath",       oldPath);
		map.put("newPath",       newPath);
		map.put("timeUTC",    timeUTC);
		map.put("ownerId",       ownerId);
		map.put("levelDistance", levelDistance);
		map.put("tenantId",      tenantId);
		
		ezWebFolderDAO.moveSubFolders(map);
	}
	
	public void moveFile (String fileId, String folderId, int tenantId, String timeUTC) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("fileId",   fileId);
		map.put("folderId", folderId);
		map.put("tenantId", tenantId);
		map.put("timeUTC",    timeUTC);
		
		ezWebFolderDAO.moveFile(map);
	}
}
