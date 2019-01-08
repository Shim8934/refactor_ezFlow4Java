package egovframework.ezEKP.ezWebFolder.service.impl;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.UUID;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import egovframework.ezEKP.ezWebFolder.dao.EzWebFolderDAO_m;
import egovframework.ezEKP.ezWebFolder.dao.EzWebFolderDAO_y;
import egovframework.ezEKP.ezWebFolder.service.EzWebFolderAdminService;
import egovframework.ezEKP.ezWebFolder.service.EzWebFolderService_m;
import egovframework.ezEKP.ezWebFolder.service.EzWebFolderService_y;
import egovframework.ezEKP.ezWebFolder.util.EzWebfolderUtil;
import egovframework.ezEKP.ezWebFolder.vo.FileVO;
import egovframework.ezEKP.ezWebFolder.vo.FolderVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.com.cmm.service.EgovFileMngUtil;

@Service("EzWebFolderService_y")
public class EzWebFolderServiceImpl_y extends EgovFileMngUtil implements EzWebFolderService_y{
	@Autowired
	private EzWebFolderDAO_y ezWebFolderDAO_y;

	@Autowired
	private EzWebFolderDAO_m ezWebFolderDAO_m;

	@Autowired
	private EzWebFolderService_m ezWebFolderService_m;

	@Autowired
	private EzWebFolderAdminService ezWebFolderAdminService;

	@Autowired
	private EzWebfolderUtil webfolderUtil;

	private static final Logger LOGGER = LoggerFactory
			.getLogger(EzWebFolderServiceImpl_y.class);

	@Autowired
	private CommonUtil commonUtil;

	public LoginVO getUserInfo(int tenantId, String comId, String userId) {
		Map<String, Object> map = new HashMap<String, Object>();

		map.put("tenantId", tenantId);
		map.put("comId", comId);
		map.put("userId", userId);

		LoginVO userInfo = ezWebFolderDAO_y.getUserInfo(map);
		return userInfo;
	}

	@Override
	public void insertIfNotExistRootForder(String userId, String userName1,
			String userName2, String compId,
			List<Map<String, String>> permissionIdList, String offset,
			int tenantId) throws Exception {
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Date date = new Date();
		String timeUTC = commonUtil.getDateStringInUTC(formatter.format(date),
				offset, true);
		String folderId = ezWebFolderAdminService.getMaxFolderID(tenantId);
		LOGGER.debug("timeUTC: " + timeUTC);

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userId", userId);
		map.put("compId", compId);
		map.put("createName1", userName1);
		map.put("createName2", userName2);
		map.put("timeUTC", timeUTC);
		map.put("tenantId", tenantId);

		for (Map<String, String> idMap : permissionIdList) {
			map.put("ownerId", idMap.get("id"));
			map.put("folderType", idMap.get("type"));

			if (ezWebFolderDAO_y.checkRootFolder(map) == 0) {
				ezWebFolderDAO_y.insertRootFolder(map);
				if (idMap.get("type").equals("D")) {
					ezWebFolderAdminService.insertFolderUser(
						ezWebFolderAdminService.getMaxFolderUserSeq(tenantId), idMap.get("id"), "dept", folderId, userId,timeUTC, compId, tenantId);
				}
				LOGGER.debug("root folder created. idMap: " + idMap);
			}
		}
	}

	// 사용자 삭제시 그 사용자의 데이터 모두 삭제 위해 flag 추가 
	@Override
	public List<Map<String, Object>> getFolderTree(String userId,
			String deptId, String compId, String folderType, String primary,
			int tenantId, String flag) throws Exception {
		List<Map<String, Object>> folderTree = new ArrayList<Map<String, Object>>();
		Map<String, Object> map = new HashMap<String, Object>();

		LOGGER.debug("getFolderTree. userId :" + userId + ", folderType :" + folderType);
		map.put("primary", primary);
		map.put("tenantId", tenantId);

		if (folderType.equals("U") || folderType.equals("")) {
			map.put("userId", userId);
			map.put("flag", flag);
			List<Map<String, Object>> userFolderTree = ezWebFolderDAO_y
					.getUserFolderTree(map);
			folderTree.addAll(userFolderTree);
		}

		if (folderType.equals("D") || folderType.equals("")) {
			List<String> addjobList = getAddJobList(tenantId, userId);

			Map<String, Object> map2 = new HashMap<String, Object>();
			map2.put("userId", userId);
			map2.put("tenantId", tenantId);

			List<String> folderUserIdList = ezWebFolderDAO_m
					.getFolderUserIdList_D(map2);

			Set<String> idSet = new HashSet<String>();
			idSet.add(deptId);
			idSet.addAll(addjobList);
			idSet.addAll(folderUserIdList);

			map.put("idList", idSet.toArray(new String[idSet.size()]));
			List<Map<String, Object>> deptFolderTree = ezWebFolderDAO_y
					.getDeptFolderTree(map);
			folderTree.addAll(deptFolderTree);
		}

		if (folderType.equals("C") || folderType.equals("")) {
			List<String> addjobList = getAddJobList(tenantId, userId);

			Map<String, Object> map2 = new HashMap<String, Object>();
			map2.put("userId", userId);
			map2.put("tenantId", tenantId);

			List<String> folderUserIdList = ezWebFolderDAO_m
					.getFolderUserIdList_D(map2);

			Set<String> idSet = new HashSet<String>();
			idSet.add(userId);
			idSet.add(deptId);
			idSet.add(compId);
			idSet.addAll(addjobList);
			idSet.addAll(folderUserIdList);

			map.put("idList", idSet.toArray(new String[idSet.size()]));
			map.put("compId", compId);
			List<Map<String, Object>> compFolderTree = ezWebFolderDAO_y
					.getCompFolderTree(map);
			folderTree.addAll(compFolderTree);
		}

		if (folderType.equals("S") || folderType.equals("")) {
			List<Map<String, String>> idList = ezWebFolderService_m
					.getPermissionIdMapList(userId, deptId, compId, tenantId);

			map.put("userId", userId);
			map.put("idList", idList);
			map.put("compId", compId);

			List<Map<String, Object>> compFolderTree = ezWebFolderDAO_m
					.getShareFolderTree(map);
			folderTree.addAll(compFolderTree);
		}

		LOGGER.debug("folderTree size: " + folderTree.size());
		return folderTree;
	}

	@Override
	public List<FileVO> getFileList(String folderId, String userId,
			String deptId, int tenantId, String comId, String searchExt,
			String searchFileName, String searchStartDate,
			String searchEndDate, String searchCreateName,
			String searchFileType, String searchPageCount, int pStart,
			int pEnd, String offset, String primary) throws Exception {
		LOGGER.debug("getFileList started");

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("folderId", folderId);
		map.put("tenantId", tenantId);
		map.put("comId", comId);

		FolderVO detailFld = ezWebFolderDAO_y.getFolderDetail(map);
		String parentId = detailFld.getFolderUpper();
		String folderType = detailFld.getFolderType();
		String folderPath = detailFld.getFolderPath();
		String flag = "0";

		map.put("flag", flag);
		map.put("deptId", deptId);
		map.put("userId", userId);
		map.put("folderPath", folderPath);
		map.put("parentId", parentId);
		map.put("folderType", folderType);
		map.put("searchExt", searchExt);
		map.put("searchFileName", searchFileName);
		map.put("searchCreateName", searchCreateName);
		map.put("searchFileType", searchFileType);
		map.put("pStart", pStart);
		map.put("pEnd", pEnd);
		map.put("primary", primary);
		map.put("offset", commonUtil.getMinuteUTC(offset));

		LOGGER.debug("offset : " + commonUtil.getMinuteUTC(offset));

		List<FileVO> filevo = new ArrayList<FileVO>();
		
		LOGGER.debug("searchExt:"+searchExt+",searchStartDate:"+searchStartDate+",searchEndDate:"+searchEndDate
				+",searchCreateName:"+searchCreateName+",searchFileName:"+searchFileName);
		
		if (searchExt != "" || searchStartDate != "" || searchEndDate != ""
				|| searchCreateName != "" || searchFileName != "") {
			flag = "1";
			
			if (searchEndDate != "" ) {
				searchStartDate = searchStartDate + " 00:00:00";
				searchEndDate   = searchEndDate + " 23:59:59";
			}
		}

		map.put("searchStartDate", searchStartDate);
		map.put("searchEndDate", searchEndDate);
		
		List<Map<String, String>> idList = ezWebFolderService_m
				.getPermissionIdMapList(userId, deptId, comId, tenantId);

		map.put("idList", idList);
		map.put("flag", flag);

		if (flag.equals("1")) {
			if (parentId.equals("root")) {
				filevo = (List<FileVO>) ezWebFolderDAO_y.searchFileListR(map);
			} else {
				filevo = (List<FileVO>) ezWebFolderDAO_y.searchFileList(map);
			}
		} else {
			if (parentId.equals("root")) {
				filevo = (List<FileVO>) ezWebFolderDAO_y.getFileListR(map);
			} else {
				filevo = (List<FileVO>) ezWebFolderDAO_y.getFileList(map);
			}
		}

		LOGGER.debug("getFileList ended");
		return filevo;
	}
	
	// root가 모든 파일들이 나오지 않는 메서드 
	@Override
	public List<FileVO> getFileList2(String folderId, String userId,
			String deptId, int tenantId, String comId, String searchExt,
			String searchFileName, String searchStartDate,
			String searchEndDate, String searchCreateName,
			String searchFileType, String searchPageCount, int pStart,
			int pEnd, String offset, String primary) throws Exception {
		LOGGER.debug("getFileList started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("folderId", folderId);
		map.put("tenantId", tenantId);
		map.put("comId", comId);
		
		FolderVO detailFld = ezWebFolderDAO_y.getFolderDetail(map);
		String parentId = detailFld.getFolderUpper();
		String folderType = detailFld.getFolderType();
		String folderPath = detailFld.getFolderPath();
		String flag = "0";
		map.put("ownerId", detailFld.getOwnerId());
		map.put("flag", flag);
		map.put("deptId", deptId);
		map.put("userId", userId);
		map.put("folderPath", folderPath);
		map.put("parentId", parentId);
		map.put("folderType", folderType);
		map.put("searchExt", searchExt);
		map.put("searchFileName", searchFileName);
		map.put("searchCreateName", searchCreateName);
		map.put("searchFileType", searchFileType);
		map.put("pStart", pStart);
		map.put("pEnd", pEnd);
		map.put("primary", primary);
		map.put("offset", commonUtil.getMinuteUTC(offset));
		
		LOGGER.debug("offset : " + commonUtil.getMinuteUTC(offset));
		
		List<FileVO> filevo = new ArrayList<FileVO>();
		
		if (searchExt != "" || searchStartDate != "" || searchEndDate != ""
				|| searchCreateName != "" || searchFileName != "") {
			flag = "1";
			
			if (searchEndDate != "" ) {
				searchStartDate = searchStartDate + " 00:00:00";
				searchEndDate   = searchEndDate + " 23:59:59";
			}
		}
		
		map.put("searchStartDate", searchStartDate);
		map.put("searchEndDate", searchEndDate);
		
		List<Map<String, String>> idList = ezWebFolderService_m.getPermissionIdMapList(userId, deptId, comId, tenantId);
		System.out.println(idList);
		map.put("idList", idList);
		map.put("flag", flag);
		
		if (flag.equals("1")) {
//			if (parentId.equals("root")) {
//				filevo = (List<FileVO>) ezWebFolderDAO_y.searchFileListR(map);
//			} else {
				filevo = (List<FileVO>) ezWebFolderDAO_y.searchFileList2(map);
//			}
		} else {
			filevo = (List<FileVO>) ezWebFolderDAO_y.getFileList2(map);
		}
		
		LOGGER.debug("getFileList ended");
		return filevo;
	}

	@Override
	public Map<String, Integer> getFileToTalCount(String folderId,
			String userId, String deptId, int tenantId, String companyId,
			String searchExt, String searchFileName, String searchStartDate,
			String searchEndDate, String searchCreateName,
			String searchFileType, String searchPageCount, int pStart,
			int pEnd, String offset, String primary) throws Exception {
		LOGGER.debug("getFileToTalCount started");

		Map<String, Object> map = new HashMap<String, Object>();

		map.put("folderId", folderId);
		map.put("tenantId", tenantId);
		map.put("comId", companyId);

		FolderVO detailFld = ezWebFolderDAO_y.getFolderDetail(map);
		String parentId = detailFld.getFolderUpper();
		String folderType = detailFld.getFolderType();
		String folderPath = detailFld.getFolderPath();
		String flag = "0";

		map.put("userId", userId);
		map.put("deptId", deptId);
		map.put("parentId", parentId);
		map.put("folderPath", folderPath);
		map.put("folderType", folderType);
		map.put("searchExt", searchExt);
		map.put("searchFileName", searchFileName);
		map.put("searchCreateName", searchCreateName);
		map.put("searchFileType", searchFileType);
		map.put("searchPageCount", searchPageCount);
		map.put("pStart", pStart);
		map.put("pEnd", pEnd);
		map.put("offset", commonUtil.getMinuteUTC(offset));
		map.put("primary", primary);

		LOGGER.debug("offset  :  " + commonUtil.getMinuteUTC(offset));

		int fileTotalCnt = 0;
		int fldTotalCnt = 0;

		if (searchExt != "" || searchStartDate != "" || searchEndDate != ""
				|| searchCreateName != "" || searchFileName != "") {
			flag = "1";
			
			if (searchEndDate != "" ) {
				searchStartDate = searchStartDate + " 00:00:00";
				searchEndDate   = searchEndDate + " 23:59:59";
				
			}
		}
		
		map.put("searchStartDate", searchStartDate);
		map.put("searchEndDate", searchEndDate);

		List<Map<String, String>> idList = ezWebFolderService_m
				.getPermissionIdMapList(userId, deptId, companyId, tenantId);
		map.put("idList", idList);
		map.put("flag", flag);

		if (flag.equals("1")) {
			LOGGER.debug("searchFileToTalCount start ");
			if (parentId.equals("root")) {
				fileTotalCnt = ezWebFolderDAO_y.searchFileToTalCountR(map);
			} else {
				fileTotalCnt = ezWebFolderDAO_y.searchFileToTalCount(map);
			}
			LOGGER.debug("searchFileToTalCount end ");
		} else {
			LOGGER.debug("getFileTotalCount start ");
			if (parentId.equals("root")) {
				fileTotalCnt = ezWebFolderDAO_y.getFileTotalCountR(map);
			} else {
				fileTotalCnt = ezWebFolderDAO_y.getFileTotalCount(map);
			}
			LOGGER.debug("getFileTotalCount end ");
		}

		fldTotalCnt = ezWebFolderDAO_y.getFldTotalCount(map);

		if (fileTotalCnt < 0) {
			fileTotalCnt = 0;
		}

		if (fldTotalCnt < 0) {
			fldTotalCnt = 0;
		}

		Map<String, Integer> cnt = new HashMap<String, Integer>();

		int totalCount = 0;
		totalCount = fileTotalCnt + fldTotalCnt;

		cnt.put("fileTotalCnt", fileTotalCnt);
		cnt.put("fldTotalCnt", fldTotalCnt);
		cnt.put("totalCount", totalCount);

		LOGGER.debug("getFileToTalCount ended");
		return cnt;
	}

	@Override
	public Map<String, Integer> getFileToTalCount2(String folderId,
			String userId, String deptId, int tenantId, String companyId,
			String searchExt, String searchFileName, String searchStartDate,
			String searchEndDate, String searchCreateName,
			String searchFileType, String searchPageCount, int pStart,
			int pEnd, String offset, String primary) throws Exception {
		LOGGER.debug("getFileToTalCount started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("folderId", folderId);
		map.put("tenantId", tenantId);
		map.put("comId", companyId);
		
		FolderVO detailFld = ezWebFolderDAO_y.getFolderDetail(map);
		String parentId = detailFld.getFolderUpper();
		String folderType = detailFld.getFolderType();
		String folderPath = detailFld.getFolderPath();
		String flag = "0";
		
		map.put("userId", userId);
		map.put("deptId", deptId);
		map.put("parentId", parentId);
		map.put("folderPath", folderPath);
		map.put("folderType", folderType);
		map.put("searchExt", searchExt);
		map.put("searchFileName", searchFileName);
		map.put("searchCreateName", searchCreateName);
		map.put("searchFileType", searchFileType);
		map.put("searchPageCount", searchPageCount);
		map.put("pStart", pStart);
		map.put("pEnd", pEnd);
		map.put("offset", commonUtil.getMinuteUTC(offset));
		map.put("primary", primary);
		
		LOGGER.debug("offset  :  " + commonUtil.getMinuteUTC(offset));
		
		int fileTotalCnt = 0;
		int fldTotalCnt = 0;
		
		if (searchExt != "" || searchStartDate != "" || searchEndDate != ""
				|| searchCreateName != "" || searchFileName != "") {
			flag = "1";
			
			if (searchEndDate != "" ) {
				searchStartDate = searchStartDate + " 00:00:00";
				searchEndDate   = searchEndDate + " 23:59:59";
			}
		}
		map.put("searchStartDate", searchStartDate);
		map.put("searchEndDate", searchEndDate);
		
		List<Map<String, String>> idList = ezWebFolderService_m
				.getPermissionIdMapList(userId, deptId, companyId, tenantId);
		map.put("idList", idList);
		map.put("flag", flag);
		
		if (flag.equals("1")) {
			fileTotalCnt = ezWebFolderDAO_y.searchFileToTalCount2(map);
		} else {
			fileTotalCnt = ezWebFolderDAO_y.getFileTotalCount(map);
		}
		
		fldTotalCnt = ezWebFolderDAO_y.getFldTotalCount2(map);
		
		if (fileTotalCnt < 0) {
			fileTotalCnt = 0;
		}
		
		if (fldTotalCnt < 0) {
			fldTotalCnt = 0;
		}
		
		Map<String, Integer> cnt = new HashMap<String, Integer>();
		
		int totalCount = 0;
		totalCount = fileTotalCnt + fldTotalCnt;
		
		cnt.put("fileTotalCnt", fileTotalCnt);
		cnt.put("fldTotalCnt", fldTotalCnt);
		cnt.put("totalCount", totalCount);
		
		LOGGER.debug("getFileToTalCount ended");
		return cnt;
	}

	@Override
	public FolderVO getFolderDetail(String folderUppId, String userId,
			int tenantId, String comId) throws Exception {
		FolderVO detailFolder = new FolderVO();
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("folderId", folderUppId);
		map.put("tenantId", tenantId);
		map.put("comId", comId);
		map.put("userId", userId);
		detailFolder = ezWebFolderDAO_y.getFolderDetail(map);

		return detailFolder;
	}

	@Override
	public String insertFolder(int tenantId, String comId, String deptId,
			String userId, String folderType, String newFolderName1,
			String newFolderName2, FolderVO uppFolder, String timeUTC)
			throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();

		LoginVO loginvo = getUserInfo(tenantId, comId, userId);
		LOGGER.debug("insertFolder start");
		map.put("tenantId", tenantId);

		if (uppFolder != null) {
			map.put("folderUppId", uppFolder.getFolderId());
			int folderStep = ezWebFolderDAO_y.getFolderStep(map);

			map.put("folderType", uppFolder.getFolderType());
			map.put("folderStep", folderStep);
			map.put("folderLevel", uppFolder.getFolderLevel() + 1);
			map.put("folderPath", uppFolder.getFolderPath());
			map.put("ownerId", uppFolder.getOwnerId());

			// uppFolder가 없으면 최상위 폴더를 만드는거
		} else if (uppFolder == null) {
			map.put("folderUppId", "root");
			map.put("folderType", folderType);
			map.put("folderStep", 0);
			map.put("folderLevel", 0);
			map.put("folderPath", "|");
			if (folderType.equals("C")) {
				map.put("ownerId", comId);
			} else if (folderType.equals("D")) {
				map.put("ownerId", deptId);
			} else if (folderType.equals("U")) {
				map.put("ownerId", userId);
			}
		}
		map.put("folderName1", newFolderName1);
		map.put("folderName2", newFolderName2);
		map.put("createName1", loginvo.getDisplayName1());
		map.put("userId", userId);
		map.put("comId", comId);
		map.put("timeUTC", timeUTC);

		// displayName2가 비어 있는 사람은 displayName을 넣는다.
		if (loginvo.getDisplayName2().equals("")) {
			map.put("createName2", loginvo.getDisplayName1());
		} else {
			map.put("createName2", loginvo.getDisplayName2());
		}

		LOGGER.debug("folderType is " + folderType);

		String result = ezWebFolderDAO_y.insertFolder(map);
		LOGGER.debug("insert folderId is " + result);

		if (result.equals(null)) {
			result = "fail";
		} 

		LOGGER.debug("insertFolder ended");
		return result;
	}

	// 겸직 리스트 가져오는 메서드
	@Override
	public List<String> getAddJobList(int tenantId, String userId)
			throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("tenantId", tenantId);
		map.put("userId", userId);

		return ezWebFolderDAO_y.getAddJobList(map);
	}

	@Override
	public void updateFolder(String folderId, int tenantId, String userId,
			String comId, String newFolderName1, String newFolderName2,
			String timeUTC) throws Exception {

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("folderId", folderId);
		map.put("tenantId", tenantId);
		map.put("comId", comId);
		map.put("timeUTC", timeUTC);
		map.put("newFolderName1", newFolderName1);
		map.put("newFolderName2", newFolderName2);
		ezWebFolderDAO_y.updateFolder(map);
	}

	// 폴더 delete

	@Override
	public int deleteSubFldAFile(String folderId, int tenantId, String comId,
			String userId, String timeUTC) throws Exception {

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("folderId", folderId);
		map.put("tenantId", tenantId);
		map.put("comId", comId);
		map.put("userId", userId);
		map.put("timeUTC", timeUTC);
		FolderVO folder = getFolderDetail(folderId, userId, tenantId, comId);
		int result = 0;

		LOGGER.debug("folderId : " + folderId + "comId : " + comId + "userId"
				+ userId + "deleteSubFldAFile  Method");
		
		if (folder.getFolderType().equals("U") && folder.getOwnerId().equals(userId)) {
			result = 1;
		} else {
			result = checkCreater(folderId, tenantId, comId, userId);
		}

		// result 가 1이 아니면 creater가 자신이 아닌 폴더가 있다는 말
		if (result == 1) {
			// result 1이면 creater가 모두 자신이라는 의미

			// 삭제를 원하는 폴더 삭제 (USE_STATUS = 'T')
			ezWebFolderDAO_y.deleteFolder(map);
			// 하위 폴더 삭제 (USE_STATUS = 'N')
			ezWebFolderDAO_y.deleteSubFolder(map);
			// 하위 파일 삭제 (USE_STATUS = 'N')
			ezWebFolderDAO_y.deleteFileInFolder(map);
			LOGGER.debug("deleteSubFldAFile is success");
		} else {
			LOGGER.debug("deleteSubFldAFile is fail");
			result = 2;
		}
		return result;
	}

	@Override
	public int checkCreater(String folderId, int tenantId, String comId,
			String userId) throws Exception {

		// 자기 하위에 있는 폴더, 파일들이 모두 본인이 creater인지 확인

		Map<String, Object> map = new HashMap<String, Object>();
		FolderVO folder = getFolderDetail(folderId, userId, tenantId, comId);
		int result = 0;
		int resultFld = 0;
		int resultFile = 0;
		map.put("folderId", folderId);
		map.put("tenantId", tenantId);
		map.put("comId", comId);
		map.put("userId", userId);
		map.put("folderPath", folder.getFolderPath());
		LOGGER.debug("folderId : " + folderId + "comId : " + comId + "userId"
				+ userId + "deleteSubFldAFile  Method");
		resultFld = ezWebFolderDAO_y.checkSubCreater(map);
		LOGGER.debug("resultFld : " + resultFld);

		// resultFile = 2 면 자신이 아닌 사람이 만든 파일이 존재
		resultFile = ezWebFolderDAO_y.checkFileCreater(map);
		LOGGER.debug("resultFile : " + resultFile);
		// 1이 리턴되면 모두 다 내가 만든 파일
		if (resultFile == 1 && resultFld == 1) {
			result = 1;
		} else {
			result = 0;
		}
		return result;
	}

	@Override
	public int getUsrListCount(int tenantId, String userId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();

		map.put("tenantId", tenantId);
		map.put("userId", userId);

		int listCount = ezWebFolderDAO_y.getUsrListCnt(map);

		return listCount;
	}

	@Override
	public void insertEnv(String userId, int tenantId, int listCount)
			throws Exception {
		LOGGER.debug("insertEnv Start");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userId", userId);
		map.put("tenantId", tenantId);
		map.put("listCount", listCount);
		ezWebFolderDAO_y.insertEnv(map);
		LOGGER.debug("insertEnv End");
	}

	@Override
	public String checkPermission(String userId, String deptId, String comId,
			String folderFileId, String folderFileType, int tenantId)
			throws Exception {
		LOGGER.debug("checkPermission started.");

		String status = "fail";
		Map<String, Object> map = new HashMap<String, Object>();

		map.put("userId", userId);
		map.put("deptId", deptId);
		map.put("comId", comId);
		map.put("tenantId", tenantId);

		FolderVO folderVO = null;

		if (folderFileType.equals("F")) {
			map.put("fileId", folderFileId);
			folderVO = ezWebFolderDAO_y.getFolderDetailByFileId(map);
		} else {
			map.put("folderId", folderFileId);
			folderVO = ezWebFolderDAO_y.getFolderDetail(map);
		}

		List<String> idList = ezWebFolderService_m.getPermissionIdList(userId,
				deptId, comId, tenantId);

		if (folderVO != null) {
			String folderType = folderVO.getFolderType();
			String folderPath = folderVO.getFolderPath();

			if (folderType.equals("C")) {
				if (folderPath.equals("|" + folderVO.getFolderId() + "|")) {
					if (folderVO.getOwnerId().equals(comId)) {
						status = "ok";
					}
				} else {
					map = new HashMap<String, Object>();

					map.put("folderIdList", folderPath.split("\\|"));
					map.put("permissionIdList", idList);
					map.put("tenantId", tenantId);

					if (ezWebFolderDAO_y.checkCompanyFolderPermission(map) > 0) {
						status = "ok";
					}
				}
			} else if (folderType.equals("D")) {
				if (idList.contains(folderVO.getOwnerId())) {
					status = "ok";
				}
			} else {
				if (folderVO.getOwnerId().equals(userId)) {
					status = "ok";
				}
			}

			if (!status.equals("ok")) {
				map = new HashMap<String, Object>();

				map.put("folderFileId", folderFileId);
				map.put("folderFileType", folderFileType);
				map.put("folderIdList", folderPath.split("\\|"));
				map.put("permissionIdList", idList);
				map.put("tenantId", tenantId);

				if (ezWebFolderDAO_m.checkSharePermission(map) > 0) {
					status = "ok";
				}
			}

		} else {
			status = "fail";
		}

		LOGGER.debug("checkPermission ended. status=" + status);
		return status;
	}

	@Override
	public JSONObject checkPermissions(String userId, String deptId,
			String comId, String folders, String files, int tenantId)
			throws Exception {
		LOGGER.debug("checkPermissions started.");
		LOGGER.debug(String
				.format("userId: %s, deptId: %s, comId: %s, folder: %s, files: %s, tenantId: %d",
						userId, deptId, comId, folders, files, tenantId));

		Map<String, Object> result = new HashMap<>();

		// TODO refactoring (아래는 권장하지 않는 코드입니다, 좋은 방법이 있으면 수정해주세요)
		class PermissionChecker {
			boolean accept(String checkList, String checkType) throws Exception {
				if (checkList == null) {
					return true;
				}

				String[] checkArray = checkList.split(",");

				if (checkArray.length == 1 && checkArray[0].isEmpty()) {
					return true;
				}

				for (String checkId : checkArray) {
					if ("fail".equals(checkPermission(userId, deptId, comId,
							checkId, checkType, tenantId))) {
						return false;
					}
				}

				return true;
			}
		}

		PermissionChecker permissionChecker = new PermissionChecker();

		try {
			if (permissionChecker.accept(folders, "D")
					&& permissionChecker.accept(files, "F")) {
				LOGGER.debug("permission allowed.");
				result.put("status", "ok");
				result.put("code", 0);
			} else {
				LOGGER.debug("permission denied.");
				result.put("status", "error");
				result.put("code", 3);
			}
		} catch (Exception ex) {
			ex.printStackTrace();
			result.put("status", "error");
			result.put("code", 2);
		}

		LOGGER.debug(String.format("result: %s", result.toString()));
		LOGGER.debug("checkPermissions ended.");
		return new JSONObject(result);
	}

	@Override
	public FileVO getFolderFileDetailForExplorer(String fldfile, String fldFileId, String userId, int tenantId,	String comId, 
			String offset, String primary) throws Exception {
		
		FileVO detailData = new FileVO();
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("fldFileId", fldFileId);
		map.put("tenantId", tenantId);
		map.put("comId", comId);
		map.put("userId", userId);
		map.put("offset", commonUtil.getMinuteUTC(offset));
		map.put("primary", primary);
		
		if (fldfile.equals("fld")) {
			detailData = ezWebFolderDAO_y.getFolderDetailForExplorer(map);
		} else if (fldfile.equals("file")) {
			detailData = ezWebFolderDAO_y.getFileDetailForExplorer(map);
		}
		return detailData;
		
	}

	@Override
	public JSONObject fileUpdateOverwrite(List<MultipartFile> multiFileLists, JSONArray nameArray, LoginVO userInfo,
			String folderId, JSONArray fileIdArray , String realPath, int tenantId) throws Exception {
		
		String fileName = "";
		String path = "";
		String userId = userInfo.getId();
		String comId = userInfo.getCompanyID();
		String offset = userInfo.getOffset();
		String primary = userInfo.getPrimary();
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		JSONObject result = new JSONObject();
		long[] fileSize            = new long[multiFileLists.size()];
		
		// 파일 가지고 온 array의 이름과 id를 가지고 다시 업로드 시켜야함
		// id의 정보를 가지고 와서 그 id의 정보를 가지고 온다 
		for (int i = 0; i < multiFileLists.size(); i++ ) {

			FileVO filevo;
			filevo = getFolderFileDetailForExplorer("file", (String)(((JSONObject)fileIdArray.get(i)).get("fileIdArray")), userId, tenantId , comId, offset, primary);
			fileName = filevo.getFilePath();
			String[] arryStrings = fileName.split("/");
			fileName = arryStrings[arryStrings.length-1];
			LOGGER.debug("before fileName is " + fileName);
			
			int dotPos     = fileName.lastIndexOf(".");
			String extend  = dotPos == -1 ? ".none" : fileName.substring(dotPos + 1);
			String newName = webfolderUtil.generateFilePath(extend);
			path = commonUtil.getUploadPath("upload_webfolder.ROOT", tenantId) + commonUtil.separator; 
			LOGGER.debug("new fileName is " + newName);
			
			Date date      = new Date();
			// 실제 파일을 생성
			writeUploadedFile(multiFileLists.get(i), realPath + path + newName);
			
			String timeUTC = commonUtil.getDateStringInUTC(formatter.format(date), offset, true);
			
			fileSize[i]    = multiFileLists.get(i).getSize();
			
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("filePath", path + newName);
			map.put("userId", userId);
			map.put("fileId", filevo.getFileId());
			map.put("tenantId", tenantId);
			map.put("timeUTC",timeUTC);
			map.put("fileSize", fileSize[i] );
			
			// 새로운 filePath로 경로 생성 및 db 업데이트
			int updateResult = ezWebFolderDAO_y.updateFileRealData(map);
			
			// db 업데이트 성공시 기존 파일 delete
			File file = new File(realPath + filevo.getFilePath());
			if (file.exists() && file.isFile()) {
				if (file.delete()) {
					LOGGER.debug("delete success.");
				}
			} else {
				LOGGER.debug("file is not exists.");
			}
			
		}
		result.put("status", "ok");
		result.put("code", 0);
		return result;
	}

	@Override
	public String existsUserIdTokenCheck(String userId, int tenantId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userId", userId);
		map.put("tenantId", tenantId);
		String result = "";
		if (ezWebFolderDAO_y.existsUserIdTokenCheck(map) > 0 ) {
			result = "exists";
		}
		return result;
	}
	
	@Override
	public String setAuthLoginTokenSql(String userId, String token, int tenantId, int device) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userId", userId);
		map.put("token", token);
		map.put("tenantId", tenantId);
		map.put("device", device);
		if (ezWebFolderDAO_y.existsUserIdTokenCheck(map) > 0 ) {
			ezWebFolderDAO_y.deleteAuthLoginTokenSql(map);
		}
		return ezWebFolderDAO_y.setAuthLoginTokenSql(map);
	}

	@Override
	public int existsTokenCheck(String userId, String token, int tenantId) throws Exception {
		int count=0;
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("userId", userId);
		map.put("token", token);
		map.put("tenantId", tenantId);
		
		count = ezWebFolderDAO_y.existsTokenCheck(map);
		
		return count ;
	}
	
	public void deleteToken(String userId,  int tenantId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userId", userId);
		map.put("tenantId", tenantId);
		ezWebFolderDAO_y.deleteAuthLoginTokenSql(map);
	}
	
	@Override
	public String folderIdByUserIdAndFolderType(String userId, int tenantId) throws Exception {
		Map<String, Object> map  = new HashMap<String, Object>();
		map.put("userId", userId);
		map.put("tenantId", tenantId);
		
		String folderId = ezWebFolderDAO_y.folderIdByUserIdAndFolderType(map);
		
		return folderId ;
	}

}
