package egovframework.ezEKP.ezWebFolder.service.impl;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.Set;

import org.codehaus.jackson.map.ObjectMapper;
import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import egovframework.ezEKP.ezWebFolder.dao.EzWebFolderDAO_m;
import egovframework.ezEKP.ezWebFolder.service.EzWebFolderAdminService;
import egovframework.ezEKP.ezWebFolder.service.EzWebFolderService;
import egovframework.ezEKP.ezWebFolder.service.EzWebFolderService_m;
import egovframework.ezEKP.ezWebFolder.service.EzWebFolderService_y;
import egovframework.ezEKP.ezWebFolder.vo.DuplicateInfoVO;
import egovframework.ezEKP.ezWebFolder.vo.FavoriteVO;
import egovframework.ezEKP.ezWebFolder.vo.FileVO;
import egovframework.ezEKP.ezWebFolder.vo.FolderUserVO;
import egovframework.ezEKP.ezWebFolder.vo.FolderVO;
import egovframework.ezEKP.ezWebFolder.vo.SearchVO;
import egovframework.ezEKP.ezWebFolder.vo.ShareVO;
import egovframework.ezEKP.ezWebFolder.vo.SimpleShareVO;
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
	private EzWebFolderAdminService ezWebFolderAdminService;
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Override
	public List<ShareVO> getSharingList(String subSearchFlag, String userId, String primary, String offset, int startPoint, int pageSize, SearchVO searchInfo, int tenantId) throws Exception {
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
		map.put("subSearchFlag",     subSearchFlag);
		
		List<ShareVO> list = ezWebFolderDAO_m.getSharingList(map);
		
		String folderPath = null;
		
		for (ShareVO vo : list) {
			folderPath = ezWebFolderService.getFolderPath(vo.getFolderPath().split("\\|"), primary, tenantId);
			
			if (vo.getFolderFileType().startsWith("D")) {
				vo.setFolderPath(folderPath.substring(0, folderPath.lastIndexOf(vo.getFileName()) - 1));
			} else {
				vo.setFolderPath(folderPath.substring(0, folderPath.length() - 1));
			}
		}
		
		return list;
	}
	
	@Override
	public List<ShareVO> getSharedList(String subSearchFlag, String userId, String deptId, String compId, String primary, String offset, int startPoint, int pageSize, SearchVO searchInfo, int tenantId) throws Exception {
		String searchStartDate = searchInfo.getSearchStartDate();
		String searchEndDate = searchInfo.getSearchEndDate();
		
		if (!searchStartDate.equals("") && !searchEndDate.equals("")) {
			searchStartDate = commonUtil.getDateStringInUTC(searchStartDate + " 00:00:00", offset, true);
			searchEndDate   = commonUtil.getDateStringInUTC(searchEndDate + " 23:59:59", offset, true);
		}
		
		List<Map<String, String>> idList = getPermissionIdMapList(userId, deptId, compId, tenantId);
		
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
		map.put("subSearchFlag",     subSearchFlag);
		
		List<ShareVO> list = ezWebFolderDAO_m.getSharedList(map);
		
		String folderPath = null;
		
		for (ShareVO vo : list) {
			folderPath = ezWebFolderService.getFolderPath(vo.getFolderPath().split("\\|"), primary, tenantId);
			
			if (vo.getFolderFileType().startsWith("D")) {
				vo.setFolderPath(folderPath.substring(0, folderPath.lastIndexOf(vo.getFileName()) - 1));
			} else {
				vo.setFolderPath(folderPath.substring(0, folderPath.length() - 1));
			}
		}
		
		return list;
	}
	
	@Override
	public Map<String, Long> getSharingCount(String subSearchFlag, String userId, String primary, String offset, int pageSize, SearchVO searchInfo, int tenantId) throws Exception {
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
		map.put("subSearchFlag",     subSearchFlag);
		
		List<Map<String, Object>> list = ezWebFolderDAO_m.getSharingCount(map);
		
		long fileCount	 = 0;
		long folderCount = 0;
		long totalCount	 = 0;
		long totalPage	 = 0;
		
		for (Map<String, Object> info : list) {
			String folderFileType = (String) info.get("folderfileType");
			if (folderFileType.equals("D")) {
				folderCount = (Long) info.get("count");
			} else if (folderFileType.equals("F")) {
				fileCount = (Long) info.get("count");
			}
		}
		
		totalCount	= fileCount + folderCount;
		totalPage	= (totalCount + pageSize - 1) / pageSize;
		
		Map<String, Long> countInfo = new HashMap<String, Long>();
		countInfo.put("fileCount", fileCount);
		countInfo.put("folderCount", folderCount);
		countInfo.put("totalCount", totalCount);
		countInfo.put("totalPage", totalPage);
		countInfo.put("pageSize", (long) pageSize);
		
		LOGGER.debug("countInfo: " + countInfo);
		return countInfo;
	}
	
	@Override
	public Map<String, Long> getSharedCount(String subSearchFlag, String userId, String deptId, String compId, String primary, String offset, int pageSize, SearchVO searchInfo, int tenantId) throws Exception {
		String searchStartDate = searchInfo.getSearchStartDate();
		String searchEndDate = searchInfo.getSearchEndDate();
		
		if (!searchStartDate.equals("") && !searchEndDate.equals("")) {
			searchStartDate = commonUtil.getDateStringInUTC(searchStartDate + " 00:00:00", offset, true);
			searchEndDate   = commonUtil.getDateStringInUTC(searchEndDate + " 23:59:59", offset, true);
		}
		
		List<Map<String, String>> idList = getPermissionIdMapList(userId, deptId, compId, tenantId);
		
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
		map.put("subSearchFlag",     subSearchFlag);
		
		List<Map<String, Object>> list = ezWebFolderDAO_m.getSharedCount(map);
		
		long fileCount	 = 0;
		long folderCount = 0;
		long totalCount	 = 0;
		long totalPage	 = 0;
		
		for (Map<String, Object> info : list) {
			String folderFileType = (String) info.get("folderfileType");
			if (folderFileType.equals("D")) {
				folderCount = (Long) info.get("count");
			} else if (folderFileType.equals("F")) {
				fileCount = (Long) info.get("count");
			}
		}
		
		totalCount	= fileCount + folderCount;
		totalPage	= (totalCount + pageSize - 1) / pageSize;
		
		Map<String, Long> countInfo = new HashMap<String, Long>();
		countInfo.put("fileCount", fileCount);
		countInfo.put("folderCount", folderCount);
		countInfo.put("totalCount", totalCount);
		countInfo.put("totalPage", totalPage);
		countInfo.put("pageSize", (long) pageSize);
		
		LOGGER.debug("countInfo: " + countInfo);
		return countInfo;
	}
	
	@Override
	public String checkShared(String folderFileId, String folderFileType, String folderPath, int tenantId) throws Exception {
		String result = "N";
		
		LOGGER.debug("folderFileId=" + folderFileId + ",folderFileType=" + folderFileType + ",folderPath=" + folderPath);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("folderFileId", folderFileId);
		map.put("folderFileType", folderFileType);
		map.put("tenantId",	tenantId);
		
		if (ezWebFolderDAO_m.checkShared1(map) > 0) {
			result = "Y";
		} else {
			folderPath = folderPath.substring(1, folderPath.length() - 1);
			String[] folderPathArr = folderPath.split("\\|");
			List<String> folderIdList = new ArrayList<String>();
			
			if (folderFileType.equals("F")) {
				for (int i = 0; i < folderPathArr.length; i++) {
					folderIdList.add(folderPathArr[i]);
				}
			} else {
				for (int i = 0; i < folderPathArr.length - 1; i++) {
					folderIdList.add(folderPathArr[i]);
				}
			}
			
			if (folderIdList.size() > 0) {
				map.put("folderIdList", folderIdList);
				
				if (ezWebFolderDAO_m.checkShared2(map) > 0) {
					result = "S";
				}
			}
		}
		
		return result;
	}
	
	@Override
	public List<SimpleShareVO> getShareInfo(String sharerId, String folderFileId, String folderFileType, String compId, String primary, String offset, int tenantId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("sharerId", sharerId);
		map.put("folderFileId", folderFileId);
		map.put("folderFileType", folderFileType);
		map.put("primary", primary);
		map.put("offset", commonUtil.getMinuteUTC(offset));
		map.put("tenantId",	tenantId);
		
		List<SimpleShareVO> shareInfoList = ezWebFolderDAO_m.getShareInfo(map);
		
		for (SimpleShareVO shareInfo : shareInfoList) {
			Map<String, Object> map2 = new HashMap<String, Object>();
			map2.put("shareId", shareInfo.getShareId());
			map2.put("primary", primary);
			map2.put("tenantId", shareInfo.getTenantId());
			map2.put("compId", compId);
			
			shareInfo.setUserList(ezWebFolderDAO_m.getShareSubInfo(map2));
		}
		
		return shareInfoList;
	}
	
	@Override
	public List<Map<String, String>> getPermissionIdMapList(String userId, String deptId, String compId, int tenantId) throws Exception {
		List<Map<String, String>> idList = new ArrayList<Map<String, String>>();
		
		List<String> addjobList = ezWebFolderService_y.getAddJobList(tenantId, userId);
		
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("userId",	userId);
		map.put("tenantId",	tenantId);
		
		List<String> folderUserIdList = ezWebFolderDAO_m.getFolderUserIdList_D(map);
		
		Set<String> idSet = new HashSet<String>();
		idSet.add(deptId);
		idSet.addAll(addjobList);
		idSet.addAll(folderUserIdList);
		
		Map<String, String> idMap = null;
		
		for (String id : idSet) {
			idMap = new HashMap<String, String>();
			idMap.put("id", id);
			idMap.put("type", "D");
			
			idList.add(idMap);
		}
		
		idMap = new HashMap<String, String>();
		idMap.put("id", userId);
		idMap.put("type", "U");
		
		idList.add(idMap);
		
		idMap = new HashMap<String, String>();
		idMap.put("id", compId);
		idMap.put("type", "C");
		
		idList.add(idMap);
		
		LOGGER.debug("idMapList: " + idList);
		return idList;
	}
	
	@Override
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
		
		LOGGER.debug("idList: " + idList);
		return idList;
	}
	
	@Override
	public void insertShare(String sharerId, String folderFileId, String folderFileType, String deptListStr, String userListStr, String offset, int tenantId) throws Exception {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Date date            = new Date();
		String shareDate     = commonUtil.getDateStringInUTC(sdf.format(date), offset, true);
		
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("sharerId", sharerId);
		map.put("folderFileId", folderFileId);
		map.put("folderFileType", folderFileType);
		map.put("userNameList", "");
		map.put("shareDate", shareDate);
		map.put("tenantId", tenantId);
		
		int shareId = ezWebFolderDAO_m.insertShare(map);
		
		map = new HashMap<String, Object>();
		map.put("shareId", shareId);
		map.put("tenantId", tenantId);
		
		String[] deptList = deptListStr.split(",");
		String[] userList = userListStr.split(",");
		
		for (String deptId : deptList) {
			if (deptId.isEmpty()) {
				continue;
			}
			
			map.put("userId", deptId);
			map.put("userType", "D");
			
			ezWebFolderDAO_m.insertShareSub(map);
		}
		
		for (String userId : userList) {
			if (userId.isEmpty()) {
				continue;
			}
			
			map.put("userId", userId);
			map.put("userType", "U");
			
			ezWebFolderDAO_m.insertShareSub(map);
		}
		
		map = new HashMap<String, Object>();
		map.put("shareId", shareId);
		map.put("shareDate", shareDate);
		map.put("deptList", deptList);
		map.put("userList", userList);
		map.put("tenantId", tenantId);
		
		ezWebFolderDAO_m.updateShareUserNameList(map);
	}
	
	@Override
	public void updateShare(String folderFileId, String folderFileType, String sharerId, String deptListStr, String userListStr, String offset, int tenantId) throws Exception {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Date date = new Date();
		String shareDate = commonUtil.getDateStringInUTC(sdf.format(date), offset, true);
		
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("folderFileId", folderFileId);
		map.put("folderFileType", folderFileType);
		map.put("sharerId", sharerId);
		map.put("tenantId", tenantId);
		
		int shareId = ezWebFolderDAO_m.getShareId(map);
		
		map = new HashMap<String, Object>();
		map.put("shareId", shareId);
		map.put("tenantId", tenantId);
		
		ezWebFolderDAO_m.deleteShareSub(map);
		
		String[] deptList = deptListStr.split(",");
		String[] userList = userListStr.split(",");
		
		for (String deptId : deptList) {
			if (deptId.isEmpty()) {
				continue;
			}
			
			map.put("userId", deptId);
			map.put("userType", "D");
			
			ezWebFolderDAO_m.insertShareSub(map);
		}
		
		for (String userId : userList) {
			if (userId.isEmpty()) {
				continue;
			}
			
			map.put("userId", userId);
			map.put("userType", "U");
			
			ezWebFolderDAO_m.insertShareSub(map);
		}
		
		map = new HashMap<String, Object>();
		map.put("shareId", shareId);
		map.put("shareDate", shareDate);
		map.put("deptList", deptList);
		map.put("userList", userList);
		map.put("tenantId", tenantId);
		
		ezWebFolderDAO_m.updateShareUserNameList(map);
	}
	
	@Override
	public void deleteShare(String folderFileId, String folderFileType, String sharerId, int tenantId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("folderFileId",   folderFileId);
		map.put("folderFileType", folderFileType);
		map.put("sharerId",       sharerId);
		map.put("tenantId",       tenantId);
		
		int shareId = ezWebFolderDAO_m.getShareId(map);
		
		map = new HashMap<String, Object>();
		map.put("shareId",  shareId);
		map.put("tenantId", tenantId);
		
		ezWebFolderDAO_m.deleteShare(map);
	}
	
	@Override
	public void deleteShareWithSub(String folderFileId, String folderFileType, int tenantId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("folderFileId", folderFileId);
		map.put("folderFileType", folderFileType);
		map.put("tenantId", tenantId);
		
		ezWebFolderDAO_m.deleteShareWithSub(map);
	}
	
	@Override
	public List<ShareVO> getHiddenSharedList(String userId, String deptId, String compId, String primary, String offset, int startPoint, int pageSize, int tenantId) throws Exception {
		List<Map<String, String>> idList = getPermissionIdMapList(userId, deptId, compId, tenantId);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userId",	         userId);
		map.put("primary",	         primary);
		map.put("offset",	         commonUtil.getMinuteUTC(offset));
		map.put("startPoint",        startPoint);
		map.put("pageSize",	         pageSize);
		map.put("idList",	         idList);
		map.put("tenantId",	         tenantId);
		
		List<ShareVO> list = ezWebFolderDAO_m.getHiddenSharedList(map);
		
		String folderPath = null;
		
		for (ShareVO vo : list) {
			folderPath = ezWebFolderService.getFolderPath(vo.getFolderPath().split("\\|"), primary, tenantId);
			
			if (vo.getFolderFileType().startsWith("D")) {
				vo.setFolderPath(folderPath.substring(0, folderPath.lastIndexOf(vo.getFileName()) - 1));
			} else {
				vo.setFolderPath(folderPath.substring(0, folderPath.length() - 1));
			}
		}
		
		return list;
	}

	@Override
	public Map<String, Long> getHiddenSharedCount(String userId, String deptId, String compId, String primary, String offset, int pageSize, int tenantId) throws Exception {
		List<Map<String, String>> idList = getPermissionIdMapList(userId, deptId, compId, tenantId);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userId",	userId);
		map.put("primary",	primary);
		map.put("offset",	commonUtil.getMinuteUTC(offset));
		map.put("idList",	idList);
		map.put("tenantId",	tenantId);
		
		List<Map<String, Object>> list = ezWebFolderDAO_m.getHiddenSharedCount(map);
		
		long fileCount	 = 0;
		long folderCount = 0;
		long totalCount	 = 0;
		long totalPage	 = 0;
		
		for (Map<String, Object> info : list) {
			String folderFileType = (String) info.get("folderfileType");
			if (folderFileType.equals("D")) {
				folderCount = (Long) info.get("count");
			} else if (folderFileType.equals("F")) {
				fileCount = (Long) info.get("count");
			}
		}
		
		totalCount	= fileCount + folderCount;
		totalPage	= (totalCount + pageSize - 1) / pageSize;
		
		Map<String, Long> countInfo = new HashMap<String, Long>();
		countInfo.put("fileCount", fileCount);
		countInfo.put("folderCount", folderCount);
		countInfo.put("totalCount", totalCount);
		countInfo.put("totalPage", totalPage);
		countInfo.put("pageSize", (long) pageSize);
		
		LOGGER.debug("countInfo: " + countInfo);
		return countInfo;
	}
	
	@Override
	public void hideShare(String folderFileId, String folderFileType, String userId, String deptId, String compId, String offset, int tenantId) throws Exception {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Date date            = new Date();
		String shareDate     = commonUtil.getDateStringInUTC(sdf.format(date), offset, true);
		
		List<Map<String, String>> idList = getPermissionIdMapList(userId, deptId, compId, tenantId);
		
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("folderFileId", folderFileId);
		map.put("folderFileType", folderFileType);
		map.put("idList", idList);
		map.put("hideStatus", "N");
		map.put("userId", userId);
		map.put("tenantId", tenantId);
		
		List<Integer> shareIdList = ezWebFolderDAO_m.getShareIdList(map);
		
		map = new HashMap<String, Object>();
		map.put("userId",   userId);
		map.put("hideDate", shareDate);
		map.put("tenantId", tenantId);
		
		for (int shareId : shareIdList) {
			map.put("shareId", shareId);
			ezWebFolderDAO_m.hideShare(map);
		}
	}
	
	@Override
	public void showShare(String folderFileId, String folderFileType, String userId, String deptId, String compId, String offset, int tenantId) throws Exception {
		List<Map<String, String>> idList = getPermissionIdMapList(userId, deptId, compId, tenantId);
		
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("folderFileId", folderFileId);
		map.put("folderFileType", folderFileType);
		map.put("idList", idList);
		map.put("hideStatus", "Y");
		map.put("userId", userId);
		map.put("tenantId", tenantId);
		
		List<Integer> shareIdList = ezWebFolderDAO_m.getShareIdList(map);
		
		map = new HashMap<String, Object>();
		map.put("userId",   userId);
		map.put("tenantId", tenantId);
		
		for (int shareId : shareIdList) {
			map.put("shareId", shareId);
			ezWebFolderDAO_m.showShare(map);
		}
	}
	
	public String getUserNameList(String[] userArr, String primary, int tenantId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("idList",	Arrays.asList(userArr));
		map.put("primary",	primary);
		map.put("tenantId",	tenantId);
		
		List<String> userNames = ezWebFolderDAO_m.getUserNameList(map);
		
		return String.join(",", userNames);
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public JSONObject getTrashCanList(String realColmn, String order, String userId, String offset, int tenantId, int currPage, int pEnd, 
			String searchExt, String searchFileName, String searchCreateName,String searchFileType, String enrollStartDate, String enrollEndDate,
			String delStartDate, String delEndDate, String mode) throws Exception {
		int totalRows  = 0;
		int totalPages = 0;
		int pStart 	   = 0;
		
		if (!enrollStartDate.equals("") && !enrollEndDate.equals("")) {
			enrollStartDate = commonUtil.getDateStringInUTC(enrollStartDate + " 00:00:00", offset, true);
			enrollEndDate   = commonUtil.getDateStringInUTC(enrollEndDate + " 23:59:59", offset, true);
		}
		
		if (!delStartDate.equals("") && !delEndDate.equals("")) {
			delStartDate = commonUtil.getDateStringInUTC(delStartDate + " 00:00:00", offset, true);
			delEndDate   = commonUtil.getDateStringInUTC(delEndDate + " 23:59:59", offset, true);
		}
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userId", userId);
		map.put("offset", commonUtil.getMinuteUTC(offset));
		map.put("tenantId", tenantId);
		map.put("searchExt", searchExt);
		map.put("searchFileName", searchFileName);
		map.put("searchCreateName", searchCreateName);
		map.put("searchFileType", searchFileType);
		map.put("endrollStartDate", enrollStartDate);
		map.put("endrollEndDate", enrollEndDate);
		map.put("delStartDate", delStartDate);
		map.put("delEndDate", delEndDate);
		map.put("realColmn", realColmn);
		map.put("order", order);
		map.put("mode", mode);
		
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
		
		currPage = totalPages == 0 ? 0 : currPage;
		
		result.put("fileCnt", fileCnt);
		result.put("folderCnt", folderCnt);
		result.put("trashCanList", trashCanList);
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
	public void permanetDeleteSelectedFiles(String[] fileIDList, String[] folderIDList ,LoginVO userInfo, String realPath, String flag) throws Exception {
		LOGGER.debug("permanetDeleteSelectedFiles start." );
		String userName1 = userInfo.getDisplayName1();
		String userName2 = userInfo.getDisplayName2();
		String companyId = userInfo.getCompanyID();
		int tenantId     = userInfo.getTenantId();
		String offset    = userInfo.getOffset();
		String userId    = userInfo.getId();
		System.out.println("flag : " + flag);
		if (flag == null ) {
			flag = "";
		}
		for (String file : fileIDList ) {
			LOGGER.debug("fileDelete");
			if (!file.equals("")) {
				FileVO fileVO = ezWebFolderService.getFileByFileId(file, offset, tenantId);
				if (fileVO != null) {
					int isFileDeleted = deleteFile(file, tenantId, flag);
					
					if (isFileDeleted > 0) {
						realFileDelete(fileVO, realPath, userInfo, userName1,  userName2);
						deleteFavoriteAnyUser(fileVO.getFileId(), "F", tenantId);
						deleteShareWithSub(fileVO.getFileId(), "F", tenantId);
					}
				}
			}
		}
		
		for (String folder : folderIDList) {
			LOGGER.debug("folderDelete");
			if (!folder.equals("")) {
				FolderVO folderVO = ezWebFolderService.getFolderByFolderId(folder, offset, tenantId);
				LOGGER.debug("folderVO != null");
				if (folderVO != null) {
					LOGGER.debug("!folder.equals('')");
					deleteAllFilesInFolder(folderVO, companyId , realPath, userInfo, offset, tenantId, userId, userName1, userName2, flag);
					
					List<String> lowerFolders = getAllFolderIdNotInFolder(folderVO.getFolderPath(), folderVO.getFolderId(), flag);
					
					for (String currentFolder : lowerFolders) {
						LOGGER.debug("currentFolder" + currentFolder);
						
						// 현재 폴더의 정보 가져오기 
						FolderVO currentFolderVO = ezWebFolderService.getFolderByFolderId(currentFolder, offset, tenantId);
						// 현재 및 하위 폴더들 정보 모두 가져오기 
						// 현재 아래와 같이 진행할 경우 아에 자신의 모든것을 지우는 형태임 하지만 모든 것을 지우는 형태로 할게 아니고 그 하위를 지우게 할 거니까 
						// 수정해야함 ( 현재 하위의 폴더를 찾는 )
						System.out.println(flag);
						if (flag =="delete") {
							List<Map<String, Object>> subAllFolder = ezWebFolderService_y.getFolderTree(userId, userInfo.getDeptID(), userInfo.getCompanyID(), currentFolderVO.getFolderType(), 
								userInfo.getPrimary(), tenantId, "delete");
							ObjectMapper oMapper = new ObjectMapper();
							for ( int i = 0 ; i< subAllFolder.size() ; i++ ) {
								
//								String folderId = subAllFolder.get(i).getFolderId();
								Map<String, Object> map = oMapper.convertValue(subAllFolder.get(i), Map.class);
								String folderId = (String) map.get("id");

								FolderVO subFolderVO = ezWebFolderService.getFolderByFolderId(folderId, offset, tenantId);
									
								deleteFavoritesInFolder(folderId, tenantId);
								deleteShareWithSub(folderId, "D", tenantId);
								deleteAllFilesInFolder(subFolderVO, companyId , realPath, userInfo, offset, tenantId, userId, userName1, userName2, flag);
								deleteFolder(subFolderVO, flag);
								
								// 웹폴더 토큰이 존재한다면 삭제
								if ( ezWebFolderService_y.existsUserIdTokenCheck(userId, tenantId).equals("exists") ) {
									ezWebFolderService_y.deleteToken(userId, tenantId);
								}
							}
							
						} else {
							List<FolderVO> subAllFolder = ezWebFolderService.getAllSubFolders(currentFolder, offset, tenantId);
							subAllFolder.add(subAllFolder.size(),folderVO);
							
							FolderVO lowerFolderVO = ezWebFolderService.getFolderByFolderId(currentFolder, offset, tenantId);
									
							int isFolderDeleted = deleteFolder(lowerFolderVO, flag);
							deleteFavoritesInFolder(folderVO.getFolderId(), tenantId);
							deleteShareWithSub(folderVO.getFolderId(), "D", tenantId);
							
							if (isFolderDeleted > 0) {
								deleteAllFilesInFolder(lowerFolderVO, companyId , realPath, userInfo, offset, tenantId, userId, userName1, userName2, flag);
							}
						}
					}
				}
			}
		}
		
		LOGGER.debug("permanetDeleteSelectedFiles end." );
	}

	@Override
	public int realFileDelete(FileVO fileVO, String realPath, LoginVO userInfo, String userName1, String userName2) throws Exception {

		String pDirPath = realPath.substring(0, realPath.length() -1) + fileVO.getFilePath();
		
		File file = new File(pDirPath);
		int isDeleted = -1;
		
		LOGGER.debug("pDirPath=" + pDirPath);
		
		if (file.exists() && file.isFile()) {
			if (file.delete()) {
				isDeleted = 1;
				ezWebFolderService.saveLog("P", userInfo.getCompanyID(), userInfo.getOffset(), userInfo.getId(), userName1, userName2, 
						fileVO.getFileName(), fileVO.getFileSize(), fileVO.getFileExt(), fileVO.getFileTypeName(), userInfo.getTenantId());
				
				LOGGER.debug(fileVO.getFileName() + "delete is success");
			} else {
				LOGGER.debug(fileVO.getFileName() + "delete is fail");
			}
		} else {
			LOGGER.error("File is Not Found : " + fileVO.getFileName());
		}
		
		return isDeleted;
	}
	
	@Override
	public int deleteFile(String fileId, int tenantId, String flag) throws Exception {

		Map<String,Object> map = new HashMap<String, Object>();
		map.put("fileId", fileId);
		map.put("tenantId", tenantId);
		map.put("flag", flag);
		
		int result = ezWebFolderDAO.deleteFile(map);
		
		if (result > 0) {
			LOGGER.debug("deleteFile is success");
		} else {
			LOGGER.debug("deleteFile is fail");
		}
		
		return result;
	}

	@Override
	public int deleteFolder (FolderVO folderVO , String flag) throws Exception {
		// Flag 퇴직자 삭제시 사용자의 모든 데이터 삭제를 위함 
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("folderId", folderVO.getFolderId());
		map.put("tenantId", folderVO.getTenantId());
		map.put("flag", flag);
		
		int result = ezWebFolderDAO.deleteFolder(map);
		
		if (result > 0) {
			LOGGER.debug("deleteFolder is success");
		} else {
			LOGGER.debug("deleteFolder is fail");
		}
		
		return result;
	}
	
	@Override
	public void deleteAllFilesInFolder(FolderVO folderVO, String companyId ,String realPath, LoginVO userInfo, String offset, int tenantId, String userId, String userName1, String userName2, String flag) throws Exception {
		LOGGER.debug("deleteAllFilesInFolder start.");
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("folderId", folderVO.getFolderId());
		map.put("tenantId", folderVO.getTenantId());
		map.put("flag", flag);
		
		List<String> searchFiles = ezWebFolderDAO.selectAllFilesInFolder(map);
		
		for (String file : searchFiles) {
			System.out.println(file);
			map.put("fileId", file);
			FileVO fileVO = ezWebFolderService.getFileByFileId(file, offset, tenantId);
			int result = ezWebFolderDAO.deleteFile(map);
			
			if (result > 0) {
				realFileDelete(fileVO, realPath, userInfo, userName1, userName2);
				ezWebFolderService.saveLog("P", companyId, offset, userId, userName1, userName2, fileVO.getFileName(), fileVO.getFileSize(), fileVO.getFileExt(), fileVO.getFileTypeName(), tenantId);
				deleteFavoriteAnyUser(fileVO.getFileId(), "F", tenantId);
				deleteShareWithSub(fileVO.getFileId(), "F", tenantId);
			}
			
			if (result > 0) {
				LOGGER.debug("deleteAllFilesInFolder is success");
			} else {
				LOGGER.debug("deleteAllFilesInFolder is fail");
			}
		}
		LOGGER.debug("deleteAllFilesInFolder start.");
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
	public boolean restoreFile(FileVO fileVO, int tenantId, String userId, String timeUTC, String companyId, String offset, String userName1, String userName2) throws Exception {
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("fileId",   fileVO.getFileId());
		map.put("tenantId", tenantId);
		map.put("userId",   userId);
		map.put("timeUTC",  timeUTC);
		
		int result = ezWebFolderDAO.restoreFile(map);
		
		if (result > 0) {
			ezWebFolderService.saveLog("RE", companyId, offset, userId, userName1, userName2, fileVO.getFileName(), fileVO.getFileSize(), fileVO.getFileExt(), fileVO.getFileTypeName(), tenantId);
			LOGGER.debug("restoreFile is success");
			
			return true;
		} else {
			LOGGER.debug("restoreFile is fail");
			
			return false;
		}
	}
	
	@Override
	public boolean restoreFolder(String folderId, int tenantId, String userId, String timeUTC) throws Exception{
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("folderId", folderId);
		map.put("tenantId", tenantId);
		map.put("userId",   userId);
		map.put("timeUTC",  timeUTC);
		
		int result = ezWebFolderDAO.restoreFolder(map);
		
		if (result > 0) {
			LOGGER.debug("restoreFolder is success");
			
			return true;
		} else {
			LOGGER.debug("restoreFolder is fail");
			
			return false;
		}
	}
	
	@Override
	public Map<String, Object> restoreTrashCan(String[] fileIDList, String[] folderIDList, int tenantId, String userId, String offset, String companyId, String timeUTC, String userName1, String userName2) throws Exception {
		Map<String, Object> resultMap = new HashMap<>();
		List<DuplicateInfoVO> duplicateList = new ArrayList<>();
		
		boolean isAllRestored = true;
		boolean hasAllParentFolder = true;
		
		for (String file : fileIDList) {
			if (file == null || file.isEmpty()) {
				continue;
			}
			
			FileVO fileVO = ezWebFolderService.getFileByFileId(file, offset, tenantId);

			if (fileVO == null) {
				continue;
			}
			
			FolderVO folderVO = ezWebFolderService.getFolderByFolderId(fileVO.getFolderId(), offset, tenantId);

			if ("Y".equals(folderVO.getUseStatus())) {
				// 중복된 파일이 있으면 스킵 및 list에 추가
				if (duplicateList.addAll(ezWebFolderService.getAllDuplicateInfo(DuplicateInfoVO.Type.FILE, file, fileVO.getFolderId(), offset, tenantId))) {
					continue;
				}
				
				// 불대수 곱 연산
				isAllRestored &= restoreFile(fileVO, tenantId, userId, timeUTC, companyId, offset, userName1, userName2);
			} else {
				isAllRestored = false;
				hasAllParentFolder = false;
			}
		}
		
		for (String folder : folderIDList) {
			if (folder.isEmpty()) {
				continue;
			}

			FolderVO folderVO = ezWebFolderService.getFolderByFolderId(folder, offset, tenantId);
			FolderVO upperFolderVO = ezWebFolderService.getFolderByFolderId(folderVO.getFolderUpper(), offset, tenantId);
			
			if ("Y".equals(upperFolderVO.getUseStatus())) {
				// 중복된 파일이 있으면 스킵 및 list에 추가
				if (duplicateList.addAll(ezWebFolderService.getAllDuplicateInfo(DuplicateInfoVO.Type.DIRECTORY, folder, folderVO.getFolderUpper(), offset, tenantId))) {
					continue;
				}
				
				List<String> lowerFolders = getAllFolderIdNotInFolder(folderVO.getFolderPath(), folderVO.getFolderId(), "");
				
				for (String lowerFolder : lowerFolders) {
					if (restoreFolder(lowerFolder, tenantId, userId, timeUTC)) {
						// 불대수 곱 연산
						isAllRestored &= restoreFileInFolder(lowerFolder, tenantId, userId, timeUTC, companyId, offset, userName1, userName2);
					}
				}
			} else {
				isAllRestored = false;
				hasAllParentFolder = false;
			}
		}
		
		if (isAllRestored && duplicateList.isEmpty()) {
			// 중복되지 않고 성공했다면 0
			resultMap.put("code", 0);
		} else {
			resultMap.put("duplicateInfoArray", duplicateList);
			// 부모 폴더가 없어 실패한 게 있으면 4, 아니면 8
			resultMap.put("code", hasAllParentFolder ? 8 : 4);
		}
		
		return resultMap;
	}
	
	@Override
	public boolean restoreFileInFolder(String folderId, int tenantId, String userId, String timeUTC, String companyId, String offset, String userName1, String userName2) throws Exception {
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("folderId",   folderId);
		map.put("tenantId",   tenantId);
		map.put("userId",     userId);
		map.put("timeUTC",    timeUTC);
		
		boolean success = true;
		List<String> searchFiles = ezWebFolderDAO.selectAllFilesInFolder(map);
		
		for (String file : searchFiles) {
			map.put("fileId", file);
			
			int result = ezWebFolderDAO.restoreFile(map);
			
			if (result > 0) {
				FileVO fileVO = ezWebFolderService.getFileByFileId(file, offset, tenantId);
				ezWebFolderService.saveLog("RE", companyId, offset, userId, userName1, userName2, fileVO.getFileName(), fileVO.getFileSize(), fileVO.getFileExt(), fileVO.getFileTypeName(), tenantId);
				
				LOGGER.debug("restoreFileInFolder is success");
			} else {
				success = false;
				LOGGER.debug("restoreFileInFolder is fail");
			}
		}
		
		return success;
	}
			
	@Override
	public List<FavoriteVO> getFavorites(String userId, String primary, String offset, int tenantId, SearchVO searchInfo, int startIndex, int listCount) throws Exception {
		SearchVO searchDateInfo = createSearchDateInfo(searchInfo, offset);
		
		Map<String, Object> parameterMap = new HashMap<>();
		parameterMap.put("userId", userId);
		parameterMap.put("primary", primary);
		parameterMap.put("offset", commonUtil.getMinuteUTC(offset));
		parameterMap.put("tenantId", tenantId);
		// search info
		parameterMap.put("searchExt", searchInfo.getSearchExt());
		parameterMap.put("searchFileName", searchInfo.getSearchFileName());
		parameterMap.put("searchCreatorName", searchInfo.getSearchCreateName());
		parameterMap.put("searchFileType", searchInfo.getSearchFileType());
		parameterMap.put("searchStartDate", searchDateInfo.getSearchStartDate());
		parameterMap.put("searchEndDate", searchDateInfo.getSearchEndDate());
		parameterMap.put("startIndex", startIndex);
		parameterMap.put("listCount", listCount);
		
		String[] searchTargets = { searchInfo.getSearchExt(), searchInfo.getSearchFileName(), searchInfo.getSearchCreateName() };
		boolean hasSearchKeyword = Arrays.stream(searchTargets).anyMatch(str -> !str.toString().isEmpty());
		
		if (hasSearchKeyword) {
			parameterMap.put("isContainsSubList", "test");
		}
		 
		List<FavoriteVO> result = ezWebFolderDAO.getFavorites(parameterMap);
		String targetPath;
		
		for (FavoriteVO favoriteVO : result) {
			targetPath = favoriteVO.getTargetPath();
			
			if (favoriteVO.getTargetType().startsWith("D_")) {
				targetPath = targetPath.substring(0, targetPath.indexOf(favoriteVO.getTargetId()));
			}
			
			targetPath = ezWebFolderService.getFolderPath(targetPath.split("\\|"), primary, tenantId);
			targetPath = targetPath.substring(0, targetPath.length() - 1);
			favoriteVO.setTargetPath(targetPath);
		}
		
		return result;
	}

	@Override
	public Map<String, Long> getFavoritesCount(String userId, String primary, String offset, int tenantId, SearchVO searchInfo) throws Exception {
		SearchVO searchDateInfo = createSearchDateInfo(searchInfo, offset);
		
		Map<String, Object> parameterMap = new HashMap<>();
		parameterMap.put("userId", userId);
		parameterMap.put("primary", primary);
		parameterMap.put("offset", commonUtil.getMinuteUTC(offset));
		parameterMap.put("tenantId", tenantId);
		// search info
		parameterMap.put("searchExt", searchInfo.getSearchExt());
		parameterMap.put("searchFileName", searchInfo.getSearchFileName());
		parameterMap.put("searchCreatorName", searchInfo.getSearchCreateName());
		parameterMap.put("searchFileType", searchInfo.getSearchFileType());
		parameterMap.put("searchStartDate", searchDateInfo.getSearchStartDate());
		parameterMap.put("searchEndDate", searchDateInfo.getSearchEndDate());

		String[] searchTargets = { searchInfo.getSearchExt(), searchInfo.getSearchFileName(), searchInfo.getSearchCreateName() };
		boolean hasSearchKeyword = Arrays.stream(searchTargets).anyMatch(str -> !str.toString().isEmpty());

		if (hasSearchKeyword) {
			parameterMap.put("isContainsSubList", "test");
		}
		
		Map<String, Long> countMapList = ezWebFolderDAO.getFavoritesCount(parameterMap);
		Long folderCount = Optional.ofNullable(countMapList.get("D")).orElse(0L);
		Long fileCount = Optional.ofNullable(countMapList.get("F")).orElse(0L);

		Map<String, Long> result = new HashMap<>();
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

		Integer count = ezWebFolderDAO.isExistsFavorite(parameterMap);

		LOGGER.debug("is exists: " + (count == 1));
		LOGGER.debug("exists data: " + parameterMap.toString());

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
	public int deleteFavorite(String userId, String targetId, String targetType, int tenantId) throws Exception {
		Map<String, Object> parameterMap = new HashMap<>();
		parameterMap.put("userId", userId);
		parameterMap.put("targetId", targetId);
		parameterMap.put("targetType", targetType);
		parameterMap.put("tenantId", tenantId);

		return ezWebFolderDAO.deleteFavorite(parameterMap);
	}
	
	@Override
	public int deleteFavoriteAnyUser(String targetId, String targetType, int tenantId) throws Exception {
		Map<String, Object> parameterMap = new HashMap<>();
		parameterMap.put("targetId", targetId);
		parameterMap.put("targetType", targetType);
		parameterMap.put("tenantId", tenantId);

		return ezWebFolderDAO.deleteFavorite(parameterMap);
	}
	
	@Override
	public int deleteFavoritesInFolder(String folderId, int tenantId) throws Exception {
		Map<String, Object> parameterMap = new HashMap<>();
		parameterMap.put("folderId", folderId);
		parameterMap.put("tenantId", tenantId);

		return ezWebFolderDAO.deleteFavoritesInFolder(parameterMap);
	}
	
	@Override
	public List<DuplicateInfoVO> moveTrashCan(String[] fileIDList, String[] folderIDList,String folderId, String timeUTC, LoginVO userInfo) throws Exception {
		return moveTrashCan(fileIDList, folderIDList, null, folderId, timeUTC, userInfo, false);
	}

	@Override
	public List<DuplicateInfoVO> moveTrashCan(String[] fileIDList, String[] folderIDList, String[] fileNameList, String folderId, String timeUTC, LoginVO userInfo, boolean overwritable) throws Exception {
		List<DuplicateInfoVO> duplicateList = new ArrayList<>();
		List<String> overwriteList = new ArrayList<>();
		
		String userName1 = userInfo.getDisplayName1();
		String userName2 = userInfo.getDisplayName2();
		String companyId = userInfo.getCompanyID();
		String userId = userInfo.getId();
		String offset = userInfo.getOffset();
		int tenantId = userInfo.getTenantId();
		
		boolean useRename = fileNameList != null;
		
		for (int index = 0; index < fileIDList.length; index++) {
			String file = fileIDList[index];
			
			if (file.isEmpty()) {
				continue;
			}
			
			// 이름 바꾸기를 사용한다면
			if (useRename) {
				FileVO fileVO  = ezWebFolderService.getFileByFileId(file, offset, tenantId);
				// 확장자 붙여서 newFileName 완성
				String newFileName = fileNameList[index];
				
				// 확장자가 없는 파일이 아니라면
				if (!fileVO.getFileExt().equals(".none")) {
					newFileName += "." + fileVO.getFileExt();
				}
				
				// 중복된다면 continue
				if (duplicateList.addAll(ezWebFolderService.getAllDuplicateInfo(newFileName, folderId, offset, tenantId))) {
					continue;
				}
				
				// 이름 바꾸고 continue
				moveRenameFile(file, newFileName, folderId, tenantId, timeUTC);
				continue;
			}
			
			// 중복 체크
			List<DuplicateInfoVO> duplicateInfos = ezWebFolderService.getAllDuplicateInfo(DuplicateInfoVO.Type.FILE, file, folderId, offset, tenantId);
			// 이름이 중복되는 파일이라면 리스트에 넣고 continue			
			if (duplicateInfos.size() > 0) {
				// 덮어쓰기라면
				if (overwritable) {
					// 덮어쓰기 리스트에 추가한다
					overwriteList.add(file);
				} else {
					duplicateList.addAll(duplicateInfos);
				}
				
				continue;
			}
			
			FileVO fileVO  = ezWebFolderService.getFileByFileId(file, offset, tenantId);
			
			if (fileVO != null) {
				moveFile (file, folderId, tenantId , timeUTC);
				
				ezWebFolderService.saveLog("U", companyId, offset, userId, userName1, userName2, fileVO.getFileName(), fileVO.getFileSize(), fileVO.getFileExt(), fileVO.getFileTypeName(), tenantId);
			}
		}
		
		if (overwriteList.size() > 0) {
			ezWebFolderService.moveFiles(folderId, String.join(",", overwriteList), null, "move", "normal", userInfo, true);
		}
		
		for (String folder : folderIDList) {
			if (folder.isEmpty()) {
				continue;
			}
			
			// 이름이 중복되는 폴더라면 리스트에 넣고 continue
			if (duplicateList.addAll(ezWebFolderService.getAllDuplicateInfo(DuplicateInfoVO.Type.DIRECTORY, folder, folderId, offset, tenantId))) {
				continue;
			}
			
			FolderVO folderVO = ezWebFolderService.getFolderByFolderId(folder, offset, tenantId);
			FolderVO destFolderVO = ezWebFolderService.getFolderByFolderId(folderId, offset, tenantId);
			List<String> lowerFolders = getAllFolderIdNotInFolder(folderVO.getFolderPath(), folderVO.getFolderId(), "");

			if (destFolderVO != null) {
				for (String lowerFolder : lowerFolders) {
					FolderVO lowerFolderVO = ezWebFolderService.getFolderByFolderId(lowerFolder, offset, tenantId);
					moveFolder(lowerFolderVO, destFolderVO, userId, offset, tenantId, timeUTC);
					restoreFileInFolder(lowerFolderVO.getFolderId(), tenantId, userId, timeUTC, companyId, offset, userName1, userName2);
				}
			}
		}
		
		return duplicateList;
	}
	
	@Override
	public void moveFolder (FolderVO folderVO, FolderVO destFolderVO, String userId, String offset, int tenantId, String timeUTC) throws Exception {
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
		
	    // TODO: 현재 query상에서 .S 형태로 돌아와서 해놓은것이지만 다른 형식으로 돌아올때에는 수정필요함.
		SimpleDateFormat formatter2 = new SimpleDateFormat("yyyy-MM-DD HH:mm:ss.S");								// db에서 가져온 folder의 timeUTC를 적용한 -9시간
	    Date date1 = formatter2.parse(folderVO.getCreateDate());														// folder의 creatreDate를 가져와서 date방식으로 format
	
	    SimpleDateFormat targetDateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");							// 우리가 지원하는 형식으로 다시 포맷
	    String timeUTCCreate	   = commonUtil.getDateStringInUTC(targetDateFormat.format(date1), offset, true);	// timeUTC 적용
		
		folderVO.setFolderPath(newPath);
		folderVO.setOwnerId(destFolderVO.getOwnerId());
		folderVO.setFolderType(destFolderVO.getFolderType());
		folderVO.setUpdateId(userId);
		folderVO.setUpdateDate(timeUTC);
		folderVO.setCreateDate(timeUTCCreate);
		folderVO.setFolderUpper(destFolderVO.getFolderId());
		folderVO.setFolderLevel(folderVO.getFolderLevel() + levelDistance);
		folderVO.setFolderStep(ezWebFolderAdminService.getMaxFolderStep(destFolderVO.getFolderId(), tenantId));
		folderVO.setUseStatus("Y");
		
		ezWebFolderAdminService.insertFolder(folderVO);
	}
	
	@Override
	public void moveFile (String fileId, String folderId, int tenantId, String timeUTC) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("fileId",   fileId);
		map.put("folderId", folderId);
		map.put("tenantId", tenantId);
		map.put("timeUTC",    timeUTC);
		
		ezWebFolderDAO.moveFile(map);
	}
	
	@Override
	public void moveRenameFile(String fileId, String newName, String folderId, int tenantId, String timeUTC) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("fileId", fileId);
		map.put("newName", newName);
		map.put("folderId", folderId);
		map.put("tenantId", tenantId);
		map.put("timeUTC", timeUTC);
		
		ezWebFolderDAO.moveFile(map);
	}
	
	@Override
	public List<String> getAllFolderIdNotInFolder (String folderPath, String folderId, String flag) throws Exception{
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("folderPath", folderPath);
		map.put("folderId", folderId);
		map.put("flag", flag);
		
		return ezWebFolderDAO.getAllFolderIdNotInFolder(map);
	}
	
	private SearchVO createSearchDateInfo(SearchVO searchInfo, String offset) {
		String startDate = searchInfo.getSearchStartDate();
		String endDate = searchInfo.getSearchEndDate();

		if (startDate.isEmpty() || endDate.isEmpty()) {
			return searchInfo;
		}

		SearchVO result = new SearchVO();
		result.setSearchStartDate(commonUtil.getDateStringInUTC(startDate + " 00:00:00", offset, true));
		result.setSearchEndDate(commonUtil.getDateStringInUTC(endDate + " 23:59:59", offset, true));

		return result;
	}
	
}
