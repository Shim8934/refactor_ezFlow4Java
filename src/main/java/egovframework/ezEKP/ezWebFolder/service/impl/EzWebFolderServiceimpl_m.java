package egovframework.ezEKP.ezWebFolder.service.impl;

import java.io.File;
import java.io.FileNotFoundException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.annotation.Resource;

import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import egovframework.ezEKP.ezWebFolder.dao.EzWebFolderDAO_m;
import egovframework.ezEKP.ezWebFolder.service.EzWebFolderService;
import egovframework.ezEKP.ezWebFolder.service.EzWebFolderService_m;
import egovframework.ezEKP.ezWebFolder.service.EzWebFolderService_y;
import egovframework.ezEKP.ezWebFolder.vo.FavoriteFileVO;
import egovframework.ezEKP.ezWebFolder.vo.FileVO;
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
	
	@Resource(name = "EzWebFolderDAO_m")
	private EzWebFolderDAO_m ezWebFolderDAO;
	
	@Autowired
	private EzWebFolderService ezWebFolderService;

	@Autowired
	private EzWebFolderService_y ezWebFolderService_y;
	
	@Autowired
	private CommonUtil commonUtil;
	
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
		
		List<String> idList = getPermissionIdList(userId, deptId, compId, tenantId);
		
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
		
		List<String> idList = getPermissionIdList(userId, deptId, compId, tenantId);
		
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
		
		LOGGER.debug("idList: " + idList.toString());
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
	public JSONObject getTrashCanList(String userId, String offset, int tenantId, int pStart, int pEnd, 
			String searchExt, String searchFileName, String searchCreateName,String searchFileType, String endrollStartDate, String endrollEndDate,
			String delStartDate, String delEndDate) throws Exception {
		LOGGER.debug("getTrashCanList Started.");
		LOGGER.debug("userId=" + userId + ",offset=" + offset + ",tenantId=" + tenantId);
		LOGGER.debug("pStart=" + pStart + ",pEnd=" + pEnd);
		LOGGER.debug("searchExt=" + searchExt + ",searchFileName=" + searchFileName + ",searchCreateName=" + searchCreateName);
		LOGGER.debug("endrollStartDate=" + endrollStartDate + ",endrollEndDate=" + delStartDate + ",delStartDate=" + delStartDate + ",delEndDate=" + delEndDate);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userId", userId);
		map.put("offset", offset);
		map.put("tenantId", tenantId);
		map.put("pStart", pStart);
		map.put("pEnd", pEnd);
		map.put("searchExt", searchExt);
		map.put("searchFileName", searchFileName);
		map.put("searchCreateName", searchCreateName);
		map.put("searchFileType", searchFileType);
		map.put("endrollStartDate", endrollStartDate);
		map.put("endrollEndDate", endrollEndDate);
		map.put("delStartDate", delStartDate);
		map.put("delEndDate", delEndDate);
		
		List<TrashCanVO> trashCanList = ezWebFolderDAO.getTrashCanList(map);
		List<TrashCanVO> resultList = new ArrayList<TrashCanVO>();
		
		JSONObject result = new JSONObject();
		int fileCnt = 0;
		int folderCnt = 0;
		
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
		
		result.put("fileCnt", fileCnt);
		result.put("folderCnt", folderCnt);
		result.put("trashCanList", resultList);
		
		LOGGER.debug("result=" + result);
		LOGGER.debug("getTrashCanList ended.");
		return result;
	}


	@Override
	public String getFolderPath(String folderId, int tenantId) throws Exception {
		LOGGER.debug("getFolderPath Started.");
		LOGGER.debug("folderId=" + folderId + ",tenantId=" + tenantId);

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("folderId", folderId);
		map.put("tenantId", tenantId);
		
		String folderPath = ezWebFolderDAO.getFolderPath(map);
		
		LOGGER.debug("getFolderPath ended.");
		return folderPath;
	}

	@Override
	public void permanetDeleteSelectedFiles(String[] fileIDList, String[] folderIDList ,LoginVO userInfo, String realPath) throws Exception {
		LOGGER.debug("permanetDeleteSelectedFiles Started.");
		LOGGER.debug("fileIDList=" + fileIDList + ",userInfo=" + userInfo + ",realPath=" + realPath);
		
		String userName1 = userInfo.getDisplayName1();
		String userName2 = userInfo.getDisplayName2();
		String companyId = userInfo.getCompanyID();
		int tenantId     = userInfo.getTenantId();
		String offset    = userInfo.getOffset();
		String userId    = userInfo.getId();
		
		for (String file : fileIDList ) {
			FileVO fileVO = ezWebFolderService.getFileByFileId(file, offset, tenantId);
			
			if (fileVO != null) {
				updateFileUseStatus(file, tenantId);
				ezWebFolderService.saveLog("P", companyId, offset, userId, userName1, userName2, fileVO.getFileName(), fileVO.getFileSize(), fileVO.getFileExt(), fileVO.getFileTypeName(), tenantId);
				realFileDelete(fileVO.getFileName(), realPath, userInfo);
			}
		}
		
		for (String folder : folderIDList) {
			FolderVO folderVO = ezWebFolderService.getFolderByFolderId(folder, offset, tenantId);
			
			if (folderVO != null) {
				updateFolderUseStatus(folderVO);
				updateStatusAllFilesInFolder(folderVO);
				realFileDeleteInFolder(folderVO.getFolderPath(), companyId, realPath, userInfo, offset, tenantId);
			}
		}
		
	LOGGER.debug("permanetDeleteSelectedFiles ended");
	}

	@Override
	public void realFileDelete(String fileName, String realPath, LoginVO userInfo) throws Exception {
		LOGGER.debug("realFileDelete Started.");
		LOGGER.debug("fileName=" + fileName + ",realPath=" + realPath + ",uesrInfo=" + userInfo);
		
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
		
		LOGGER.debug("realFileDelete ended.");
	}
	
	@Override
	public void realFileDeleteInFolder(String folderPath, String companyId ,String realPath, LoginVO userInfo, String offset, int tenantId) throws Exception {
		LOGGER.debug("realFileDeleteInFolder Started.");
		LOGGER.debug("folderPath=" + folderPath + ",companyId=" + companyId + ",realPath=" + realPath + ",uesrInfo=" + userInfo);
		
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
		
		LOGGER.debug("realFileDeleteInFolder ended.");
	}
	
	@Override
	public void updateFileUseStatus(String fileId, int tenantId) throws Exception {
		LOGGER.debug("updateFileUseStatus Started.");
		LOGGER.debug("fildId=" + fileId + ",tenantId=" + tenantId);

		Map<String,Object> map = new HashMap<String, Object>();
		map.put("fileId", fileId);
		map.put("tenantId", tenantId);
		
		int result = ezWebFolderDAO.updateFileUseStatus(map);
		
		if (result > 0) {
			LOGGER.debug("updateFileUseStatus is success");
		} else {
			LOGGER.debug("updateFileUseStatus is fail");
		}
		
		LOGGER.debug("updateFileUseStatus ended.");
	}

	@Override
	public void updateFolderUseStatus(FolderVO folderVO) throws Exception {
		LOGGER.debug("updateFolderUseStatus Started.");
		LOGGER.debug("folderVO="  + folderVO);
		
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("folderPath", folderVO.getFolderPath());
		map.put("tenantId", folderVO.getTenantId());
		map.put("companyId", folderVO.getCompanyId());
		
		int result = ezWebFolderDAO.updateFolderUseStatus(map);
		
		if (result > 0) {
			LOGGER.debug("updateFolderUseStatus is success");
		} else {
			LOGGER.debug("updateFolderUseStatus is fail");
		}
		
		LOGGER.debug("updateFolderUseStatus ended.");
	}

	@Override
	public void updateStatusAllFilesInFolder(FolderVO folderVO) throws Exception {
		LOGGER.debug("updateStatusAllFilesInFolder Started.");
		LOGGER.debug("folderVO="  + folderVO);
		
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("folderPath", folderVO.getFolderPath());
		map.put("tenantId", folderVO.getTenantId());
		map.put("companyId", folderVO.getCompanyId());
		
		int result = ezWebFolderDAO.updateStatusAllFilesInFolder(map);
		
		if (result > 0) {
			LOGGER.debug("updateFolderUseStatus is success");
		} else {
			LOGGER.debug("updateFolderUseStatus is fail");
		}
		
		LOGGER.debug("updateStatusAllFilesInFolder ended.");
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
		LOGGER.debug("getFolderByFolderPath Started.");
		
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("folderPath", folderPath);
		map.put("tenantId", tenantId);
		map.put("companyId", companyId);
		
		List<TrashCanVO> folderList = ezWebFolderDAO.getFolderByFolderPath(map);
		
		LOGGER.debug("getFolderByFolderPath ended.");
		return folderList;
	}
	
	private String getWebFolderDirPath(int tenantId) {
		return commonUtil.separator + "fileroot" + commonUtil.separator + tenantId + commonUtil.separator + "webfolder" + commonUtil.separator;
	}
		
	@Override
	public List<FavoriteFileVO> getFavorites(String userId, String offset, int tenantId, SearchVO searchInfo, String startIndex, String endIndex) throws Exception {

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
		parameterMap.put("endIndex", endIndex);

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
}
