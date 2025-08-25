package egovframework.ezEKP.ezWebFolder.service.impl;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Properties;
import java.util.Set;
import java.util.stream.Collectors;

import javax.annotation.Resource;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import egovframework.com.cmm.service.EzFileMngUtil;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezWebFolder.dao.EzWebFolderDAO;
import egovframework.ezEKP.ezWebFolder.dao.EzWebFolderDAO_m;
import egovframework.ezEKP.ezWebFolder.dao.EzWebFolderDAO_y;
import egovframework.ezEKP.ezWebFolder.service.EzWebFolderAdminService;
import egovframework.ezEKP.ezWebFolder.service.EzWebFolderService;
import egovframework.ezEKP.ezWebFolder.service.EzWebFolderService_m;
import egovframework.ezEKP.ezWebFolder.service.EzWebFolderService_y;
import egovframework.ezEKP.ezWebFolder.util.EzWebfolderUtil;
import egovframework.ezEKP.ezWebFolder.vo.FileVO;
import egovframework.ezEKP.ezWebFolder.vo.FileUploadVO;
import egovframework.ezEKP.ezWebFolder.vo.FolderSimpleVO;
import egovframework.ezEKP.ezWebFolder.vo.FolderTreeVO;
import egovframework.ezEKP.ezWebFolder.vo.FolderVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;

@Service("EzWebFolderService_y")
public class EzWebFolderServiceImpl_y extends EzFileMngUtil implements EzWebFolderService_y{
	@Autowired
	private EzCommonService ezCommonService;

	@Autowired
	private Properties globals;
		
	@Autowired
	private EzWebFolderDAO_y ezWebFolderDAO_y;

	@Autowired
	private EzWebFolderDAO_m ezWebFolderDAO_m;

	@Autowired
	private EzWebFolderService ezWebFolderService;

	@Autowired
	private EzWebFolderService_m ezWebFolderService_m;

	@Autowired
	private EzWebFolderAdminService ezWebFolderAdminService;

	@Autowired
	private EzWebfolderUtil webfolderUtil;

	@Resource(name = "EzWebFolderDAO")
	private EzWebFolderDAO ezWebFolderDAO;
	
	private static final Logger logger = LoggerFactory
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
		logger.debug("timeUTC: " + timeUTC);

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
				int folderIdInt = ezWebFolderDAO_y.insertRootFolder(map);
				map.put("newFolderId", String.valueOf(folderIdInt));
				map.put("folderUpper", "");
				logger.debug("folderId:" + folderId + ",folderUpper:" + ",tenantId:" + tenantId);
				ezWebFolderDAO_y.updateFolderPath(map);
				folderId = String.valueOf(folderIdInt); 
				
				if (idMap.get("type").equals("D")) {
					ezWebFolderAdminService.insertFolderUser(
						ezWebFolderAdminService.getMaxFolderUserSeq(tenantId), idMap.get("id"), "dept", folderId, userId,timeUTC, compId, tenantId);
				}
				logger.debug("root folder created. idMap: " + idMap);
			}
		}
	}

	// 사용자 삭제시 그 사용자의 데이터 모두 삭제 위해 flag 추가 
	@Override
	public List<FolderTreeVO> getFolderTree(String userId,
			String deptId, String compId, String folderType, String primary,
			int tenantId, String flag) throws Exception {
		return getFolderTree(userId, deptId, compId, folderType, primary, tenantId, flag, false);
	}
		
	// 사용자 삭제시 그 사용자의 데이터 모두 삭제 위해 flag 추가 
	@Override
	public List<FolderTreeVO> getFolderTree(String userId, String deptId, String compId, String folderType, String primary, int tenantId, String flag, boolean isAdmin) throws Exception {
		
		List<FolderTreeVO> folderTree = new ArrayList<>();
		Map<String, Object> map = new HashMap<String, Object>();

		logger.debug("getFolderTree. userId :" + userId + ", folderType :" + folderType);
		map.put("primary", primary);
		map.put("tenantId", tenantId);
		map.put("compId", compId);

		if (folderType.equals("U") || folderType.equals("")) {
			map.put("userId", userId);
			map.put("flag", flag);
			List<FolderTreeVO> userFolderTree = ezWebFolderDAO_y.getUserFolderTree(map);
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
			List<FolderTreeVO> deptFolderTree = ezWebFolderDAO_y.getDeptFolderTree(map);
			folderTree.addAll(deptFolderTree);
		}

		if (folderType.equals("C") || folderType.equals("")) {
			
			if (!isAdmin) {
				List<String> addjobList = getAddJobList(tenantId, userId);
	
				List<String> managerFolderId = ezWebFolderAdminService.getFolderIdsByManagerUserId(userId, "", compId, tenantId);
				String managerFolderStr = "";
				for (String manger : managerFolderId) {
					managerFolderStr += " OR F.FOLDER_PATH LIKE '%|" + manger +"|%' ";
				}	
				
				// 직위, 직책 권한이 추가 
				List<String> jikWiChekAddjobList = getjikWiChekAddjobList(tenantId, userId, compId);
				
				Map<String, Object> map2 = new HashMap<String, Object>();
				map2.put("userId", userId);
				map2.put("tenantId", tenantId);
				map2.put("companyId", compId);
	
				List<String> folderUserIdList = ezWebFolderDAO_m
						.getFolderUserIdList_D(map2);
	
				Set<String> idSet = new HashSet<String>();
				idSet.add(userId);
				idSet.add(deptId);
				idSet.add(compId);
				idSet.addAll(addjobList);
				idSet.addAll(jikWiChekAddjobList);
				idSet.addAll(folderUserIdList);
	
				// 권한그룹이 추가 : tbl_webfolder_folderuser에 있는 권한 그룹리스트 가져와서 체크
				List<String> groupList = ezWebFolderDAO_y.getWebFolderUserGroupList(map2);
				
				if (groupList != null) {
					for (String groupId : groupList) {
						boolean groupPermissionYN = ezCommonService.getPermissionGroupAccessYN(groupId, compId, tenantId, userId, deptId, true);
						
						if (groupPermissionYN) {
							idSet.add(groupId);
						}
					}
				}
	
				map.put("idList", idSet.toArray(new String[idSet.size()]));
				map.put("compId", compId);
				
				Set<String> userDeptList = new HashSet<String>();
				userDeptList.add(deptId);
				userDeptList.addAll(addjobList);
				map.put("userId", userId);
				map.put("userDeptList", userDeptList.toArray(new String[userDeptList.size()]));
				map.put("managerFolderStr", managerFolderStr);
			
			} else {
				Map<String,Object> comFldMap = new HashMap<String, Object>();
				comFldMap.put("companyId",  compId);
				comFldMap.put("tenantId",   tenantId);
				
				FolderSimpleVO companyFolder = ezWebFolderDAO.getCompanySimpleFolder(comFldMap);
				String folderId = companyFolder.getFolderId();

				String mngStr = " OR F.FOLDER_PATH LIKE '%|" + folderId +"|%' ";
				
				Set<String> idSet = new HashSet<String>();
				idSet.add(compId);
				map.put("idList", new String[] {compId});
				map.put("managerFolderStr", mngStr);
			}
			
			List<FolderTreeVO> compFolderTree = checkFolderParent(ezWebFolderDAO_y.getCompFolderTree(map));

			compFolderTree = checkFolderParent(compFolderTree);
			folderTree.addAll(compFolderTree);
		}

		if (folderType.equals("S") || folderType.equals("")) {
			List<Map<String, String>> idList = ezWebFolderService_m
					.getPermissionIdMapList(userId, deptId, compId, tenantId);

			map.put("userId", userId);
			map.put("idList", idList);
			map.put("compId", compId);

			List<FolderTreeVO> compFolderTree = ezWebFolderDAO_m.getShareFolderTree(map);
			folderTree.addAll(compFolderTree);
		}

		logger.debug("folderTree size: " + folderTree.size());
		return folderTree;
	}

	/**
	 * 상위 권한이 없는 폴더라면 하위의 폴더는 나타나지 않도록 제거 
	 */
	private List<FolderTreeVO> checkFolderParent(List<FolderTreeVO> folderTreeList) {
		logger.debug("checkFolderParent start.");

		List<String> folderIds = folderTreeList.stream().map(FolderTreeVO::getId).collect(Collectors.toList());

		folderTreeList.removeIf(treeVO -> {
			String parentId = treeVO.getParent();

			if (parentId.equals("#") || folderIds.contains(parentId)) {
				return false;
			}

			String id = treeVO.getId();
			logger.debug("parent folder not exists permission. delete folderId={}", id);
			return folderIds.remove(id);
		});

		logger.debug("checkFolderParent end.");
		return folderTreeList;
	}
	
	@Override
	public List<FileVO> getFileList(String folderId, String userId,
			String deptId, int tenantId, String comId, String searchExt,
			String searchFileName, String searchStartDate,
			String searchEndDate, String searchCreateName,
			String searchFileType, String searchPageCount, int pStart,
			int pEnd, String offset, String primary) throws Exception {
		logger.debug("getFileList started");

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

		logger.debug("offset : " + commonUtil.getMinuteUTC(offset));

		List<FileVO> filevo = new ArrayList<FileVO>();
		
		logger.debug("searchExt:"+searchExt+",searchStartDate:"+searchStartDate+",searchEndDate:"+searchEndDate
				+",searchCreateName:"+searchCreateName+",searchFileName:"+searchFileName);
		
		if (!searchExt.equals("") || !searchStartDate.equals("") || !searchEndDate.equals("")
				|| !searchCreateName.equals("") || !searchFileName.equals("")) {
			flag = "1";
			logger.debug("searchExt"+searchExt+"searchStartDate"+searchStartDate+"searchEndDate"+searchEndDate+
					"searchCreateName"+searchCreateName+"searchFileName"+searchFileName);
			
			if (!searchEndDate.equals("") ) {
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

		logger.debug("getFileList ended");
		return filevo;
	}
	
	// root가 모든 파일들이 나오지 않는 메서드 
	@Override
	public List<FileVO> getFileList2(String folderId, String userId,
			String deptId, int tenantId, String comId, String searchExt,
			String searchFileName, String searchStartDate,
			String searchEndDate, String searchCreateName,
			String searchFileType, String searchPageCount, int pStart,
			int pEnd, String offset, String primary, String sortType, String sortColumn) throws Exception {
		logger.debug("getFileList started");
		
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
		map.put("sortType", sortType);
		map.put("sortColumn", sortColumn);
		map.put("folderLevel", detailFld.getFolderLevel());
		
		logger.debug("offset : " + commonUtil.getMinuteUTC(offset));
		
		List<FileVO> filevo = new ArrayList<FileVO>();
		
		if (!searchExt.equals("") || !searchStartDate.equals("") || !searchEndDate.equals("")
				|| !searchCreateName.equals("") || !searchFileName.equals("")) {
			flag = "1";
			logger.debug("searchExt"+searchExt+"searchStartDate"+searchStartDate+"searchEndDate"+searchEndDate+
					"searchCreateName"+searchCreateName+"searchFileName"+searchFileName);
			
			if (!searchEndDate.equals("") ) {
				searchStartDate = searchStartDate + " 00:00:00";
				searchEndDate = searchEndDate + " 23:59:59";
			}
		}
		
		map.put("searchStartDate", searchStartDate);
		map.put("searchEndDate", searchEndDate);
		
		List<Map<String, String>> idList = ezWebFolderService_m.getPermissionIdMapList(userId, deptId, comId, tenantId);
		System.out.println(idList);
		map.put("idList", idList);
		
		List<String> idListUpgrade = new ArrayList<String>();
		for (Map<String, String> id : idList) {
			idListUpgrade.add((String)id.get("id"));
		}
		
		// 직위, 직책 권한이 추가 
		map.put("companyId", comId);
		List<String> jikWiChekAddjobList = getjikWiChekAddjobList(tenantId, userId, comId);
		idListUpgrade.addAll(jikWiChekAddjobList);
		
		// 권한그룹이 추가 : tbl_webfolder_folderuser에 있는 권한 그룹리스트 가져와서 체크
		List<String> groupList = ezWebFolderDAO_y.getWebFolderUserGroupList(map);
		
		if (groupList != null) {
			for (String groupId : groupList) {
				boolean groupPermissionYN = ezCommonService.getPermissionGroupAccessYN(groupId, comId, tenantId, userId, deptId, true);
				
				if (groupPermissionYN) {
					idListUpgrade.add(groupId);
				}
			}
		}
		map.put("idListUpgrade", idListUpgrade);
		
		List<String> addjobList = getAddJobList(tenantId, userId);
		addjobList.add(deptId);
		map.put("userDeptList", addjobList);
		
		map.put("flag", flag);
		
		if (sortType.equals("")){
			map.put("orderByData", ", CASE WHEN FOLDER_SORT = 0 THEN FILE_NAME END, ROOT_ID DESC, HIERARCHICAL_PATH" );
		} else {
			if (sortColumn.equals("CREATE_NAME") || sortColumn.equals("CREATOR_NAME")){
				sortColumn = "CREATE_NAME1";
			} else if (sortColumn.equals("SHARE_STATUS")){
				sortColumn = "FILESHARE_STATUS";
			} else if (sortColumn.equals("TARGET_PATH")){
				sortColumn = "FILE_PATH";
			} else if (sortColumn.equals("TARGET_SIZE")){
				sortColumn = "FILE_SIZE";
			} else if (sortColumn.equals("TARGET_NAME")){
				sortColumn = "FILE_NAME";
			}  else if (sortColumn.equals("TARGET_TYPE") || sortColumn.equals("TARGET_ICON_URL")){
				sortColumn = "TYPE_ICON";
			}  
			
			String secondSort = "";
			secondSort = " , " + sortColumn + " " + sortType;
			
			if (sortColumn.equals("TYPE_ICON") && sortType.equals("DESC")){
				secondSort = " DESC , " + sortColumn + " " + sortType;
			}
			
			secondSort += ", CASE WHEN FOLDER_SORT = 0 THEN FILE_NAME END, ROOT_ID DESC, HIERARCHICAL_PATH " ;
			map.put("orderByData", secondSort);
		}
		
		// C 인데 담당자가 아니라 조건 검색을 해야하는 경우 
		if (folderType.equalsIgnoreCase("C") && ezWebFolderAdminService.getFolderIdsByManagerUserId(userId, folderId, comId, tenantId).size() == 0) {
			map.put("manager", 1);
		} else {
			map.put("manager", 0);
		}

		if (flag.equals("1")) {
			filevo = (List<FileVO>) ezWebFolderDAO_y.searchFileList2(map);
		} else {
			filevo = (List<FileVO>) ezWebFolderDAO_y.getFileList2(map);
		}
		
		logger.debug("getFileList ended");
		return filevo;
	}

	@Override
	public Map<String, Integer> getFileToTalCount(String folderId,
			String userId, String deptId, int tenantId, String companyId,
			String searchExt, String searchFileName, String searchStartDate,
			String searchEndDate, String searchCreateName,
			String searchFileType, String searchPageCount, int pStart,
			int pEnd, String offset, String primary) throws Exception {
		logger.debug("getFileToTalCount started");

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

		logger.debug("offset  :  " + commonUtil.getMinuteUTC(offset));

		int fileTotalCnt = 0;
		int fldTotalCnt = 0;

		if (!searchExt.equals("") || !searchStartDate.equals("") || !searchEndDate.equals("")
				|| !searchCreateName.equals("") || !searchFileName.equals("")) {
			flag = "1";
			logger.debug("searchExt"+searchExt+"searchStartDate"+searchStartDate+"searchEndDate"+searchEndDate+
					"searchCreateName"+searchCreateName+"searchFileName"+searchFileName);
			
			if (!searchEndDate.equals("") ) {
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
			logger.debug("searchFileToTalCount start ");
			if (parentId.equals("root")) {
				fileTotalCnt = ezWebFolderDAO_y.searchFileToTalCountR(map);
			} else {
				fileTotalCnt = ezWebFolderDAO_y.searchFileToTalCount(map);
			}
			logger.debug("searchFileToTalCount end ");
		} else {
			logger.debug("getFileTotalCount start ");
			if (parentId.equals("root")) {
				fileTotalCnt = ezWebFolderDAO_y.getFileTotalCountR(map);
			} else {
				fileTotalCnt = ezWebFolderDAO_y.getFileTotalCount(map);
			}
			logger.debug("getFileTotalCount end ");
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

		logger.debug("getFileToTalCount ended");
		return cnt;
	}

	@Override
	public Map<String, Integer> getFileToTalCount2(String folderId,
			String userId, String deptId, int tenantId, String companyId,
			String searchExt, String searchFileName, String searchStartDate,
			String searchEndDate, String searchCreateName,
			String searchFileType, String searchPageCount, int pStart,
			int pEnd, String offset, String primary) throws Exception {
		logger.debug("getFileToTalCount started");
		
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
		map.put("folderLevel", detailFld.getFolderLevel());
		
		logger.debug("offset  :  " + commonUtil.getMinuteUTC(offset));
		
		int fileTotalCnt = 0;
		int fldTotalCnt = 0;
		
		if (!searchExt.equals("") || !searchStartDate.equals("") || !searchEndDate.equals("")
				|| !searchCreateName.equals("") || !searchFileName.equals("")) {
			flag = "1";
			logger.debug("searchExt"+searchExt+"searchStartDate"+searchStartDate+"searchEndDate"+searchEndDate+
					"searchCreateName"+searchCreateName+"searchFileName"+searchFileName);
			
			if (!searchEndDate.equals("") ) {
				searchStartDate = searchStartDate + " 00:00:00";
				searchEndDate = searchEndDate + " 23:59:59";
			}
		}
		map.put("searchStartDate", searchStartDate);
		map.put("searchEndDate", searchEndDate);
		
		List<Map<String, String>> idList = ezWebFolderService_m.getPermissionIdMapList(userId, deptId, companyId, tenantId);
		System.out.println(idList);
		map.put("idList", idList);
		
		List<String> idListUpgrade = new ArrayList<String>();
		for (Map<String, String> id : idList) {
			idListUpgrade.add((String)id.get("id"));
		}
		
		// 직위, 직책 권한이 추가 
		map.put("companyId", companyId);
		List<String> jikWiChekAddjobList = getjikWiChekAddjobList(tenantId, userId, companyId);
		idListUpgrade.addAll(jikWiChekAddjobList);
		
		// 권한그룹이 추가 : tbl_webfolder_folderuser에 있는 권한 그룹리스트 가져와서 체크
		List<String> groupList = ezWebFolderDAO_y.getWebFolderUserGroupList(map);
		
		if (groupList != null) {
			for (String groupId : groupList) {
				boolean groupPermissionYN = ezCommonService.getPermissionGroupAccessYN(groupId, companyId, tenantId, userId, deptId, true);
				
				if (groupPermissionYN) {
					idListUpgrade.add(groupId);
				}
			}
		}
		map.put("idListUpgrade", idListUpgrade);
		
		List<String> addjobList = getAddJobList(tenantId, userId);
		addjobList.add(deptId);
		map.put("userDeptList", addjobList);
		map.put("flag", flag);
		
		// C 인데 담당자가 아니라 조건 검색을 해야하는 경우 
		if (folderType.equalsIgnoreCase("C") && ezWebFolderAdminService.getFolderIdsByManagerUserId(userId, folderId, companyId, tenantId).size() == 0) {
			map.put("manager", 1);
		} else {
			map.put("manager", 0);
		}
		
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
		
		logger.debug("getFileToTalCount ended");
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
		logger.debug("insertFolder start");
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

		logger.debug("folderType is " + folderType);

		int folderId = ezWebFolderDAO_y.insertFolder(map);
		
		// 2023-05-17 이사라 : NullPointerException 시큐어코딩
		String uppFolderId = Objects.isNull(uppFolder) ? "" : uppFolder.getFolderId();
		
		map.put("newFolderId", folderId);
		map.put("folderUpper", uppFolderId);
		map.put("targetId", folderId);
		logger.debug("folderId:" + folderId + ",folderUpper:"  + uppFolderId + ",tenantId:" + tenantId);
		
		ezWebFolderDAO_y.updateFolderPath(map);
		
		map.put("upperFolderId", uppFolderId);
		map.put("type_f", "D");
		ezWebFolderAdminService.insertFolderUser(map);
		logger.debug("insert folderId is " + folderId);

		if (folderId == 0 ) {
			new Exception();
		} 

		logger.debug("insertFolder ended");
		return Integer.toString(folderId);
	}

	@Override
	public List<Map<String,String>> getFolderUser (String folderId, String comId, int tenantId) throws Exception {
		List<Map<String,String>> folderUserList = new ArrayList<Map<String,String>>();
		Map<String, Object> userTempMap = new HashMap<String, Object>();
		userTempMap.put("folderId", folderId);
		userTempMap.put("comId", comId);
		userTempMap.put("tenantId", tenantId);
		folderUserList = ezWebFolderDAO_y.getFolderUser(userTempMap);
		logger.debug("folderUserList: " + folderUserList);
		return folderUserList ;
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
			String userId, String timeUTC, String rollInfo) throws Exception {

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("folderId", folderId);
		map.put("tenantId", tenantId);
		map.put("comId", comId);
		map.put("userId", userId);
		map.put("timeUTC", timeUTC);
		FolderVO folder = getFolderDetail(folderId, userId, tenantId, comId);
		int result = 0;

		logger.debug("folderId : " + folderId + "comId : " + comId + "userId"
				+ userId + "deleteSubFldAFile  Method");
		
		if (webfolderUtil.isWebfolderAdmin(rollInfo) || (folder.getFolderType().equals("U") && folder.getOwnerId().equals(userId))) {
			result = 1;
		} else {
			result = checkCreatorRecursive(folderId, tenantId, comId, userId);
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
			logger.debug("deleteSubFldAFile is success");
		} else {
			logger.debug("deleteSubFldAFile is fail");
			result = 2;
		}
		return result;
	}

	@Override
	public int checkCreatorRecursive(String folderId, int tenantId, String comId, String userId) throws Exception {
		return checkCreator(folderId, tenantId, comId, userId, true);
	}

	@Override
	public int checkCreator(String folderId, int tenantId, String comId, String userId) throws Exception {
		return checkCreator(folderId, tenantId, comId, userId, false);
	}

	private int checkCreator(String folderId, int tenantId, String comId, String userId, boolean isRecursive)  throws Exception {
		// 담당자는 모든 권한을 가짐
		if (ezWebFolderAdminService.getFolderIdsByManagerUserId(userId, folderId, comId, tenantId).size() > 0) {
			return 1;
		}

		FolderVO folder = getFolderDetail(folderId, userId, tenantId, comId);
		
		if (userId.equals(folder.getOwnerId())) {
			return 1;
		}

		if (!isRecursive && folder.getCreateId().equals(userId)) {
			return 1;
		}

		// 자기 하위에 있는 폴더, 파일들이 모두 본인이 creater인지 확인
		Map<String, Object> map = new HashMap<String, Object>();
		int result = 0;
		int resultFld = 0;
		int resultFile = 0;
		map.put("folderId", folderId);
		map.put("tenantId", tenantId);
		map.put("comId", comId);
		map.put("userId", userId);
		map.put("folderPath", folder.getFolderPath());
		logger.debug("folderId : " + folderId + "comId : " + comId + "userId"
				+ userId + "deleteSubFldAFile  Method");
		resultFld = ezWebFolderDAO_y.checkSubCreater(map);
		logger.debug("resultFld : " + resultFld);

		// resultFile = 2 면 자신이 아닌 사람이 만든 파일이 존재
		resultFile = ezWebFolderDAO_y.checkFileCreater(map);
		logger.debug("resultFile : " + resultFile);
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
		logger.debug("insertEnv Start");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userId", userId);
		map.put("tenantId", tenantId);
		map.put("listCount", listCount);
		ezWebFolderDAO_y.insertEnv(map);
		logger.debug("insertEnv End");
	}

	@Override
	public JSONObject checkPermissionForCreator(String[] folderIds, String[] fileIds, LoginVO user) throws Exception {
		return checkPermissionForCreator(folderIds, fileIds, user, false);
	}

	@Override
	public JSONObject checkPermissionForCreator(String[] folderIds, String[] fileIds, LoginVO user, boolean isRecursive) throws Exception {
		Map<String, Object> result = new HashMap<>();

		if (webfolderUtil.isWebfolderAdmin(user)) {
			result.put("status", "ok");
			result.put("code", 0);
			return new JSONObject(result);
		}

		String userId = user.getId();
		String companyId = user.getCompanyID();
		int tenantId = user.getTenantId();

		if (folderIds != null) {
			for (String folderId : folderIds) {
				if (folderId == null || folderId.isEmpty()) {
					continue;
				}

				int folderCheck = isRecursive
						? checkCreatorRecursive(folderId, tenantId, companyId, userId)
						: checkCreator(folderId, tenantId, companyId, userId);

				if (folderCheck == 0) {
					result.put("status", "error");
					result.put("code", 3);
					return new JSONObject(result);
				}
			}
		}

		if (fileIds != null) {
			for (String fileId : fileIds) {
				if (fileId == null || fileId.isEmpty()) {
					continue;
				}

				FileVO fileVO = ezWebFolderService.getFileByFileId(fileId, "000|+00:00", tenantId);
				Map<String,Object> map = new HashMap<String, Object>();
				map.put("fileId", fileId);
				map.put("tenantId",tenantId);
			
				FolderVO folder = ezWebFolderDAO_y.getFolderDetailByFileId(map);
				
				
				if (folder.getFolderType().equals("C")){
					List<String> dp = ezWebFolderAdminService.getFolderIdsByManagerUserId(userId, fileVO.getFolderId(), companyId, tenantId);
					if (ezWebFolderAdminService.getFolderIdsByManagerUserId(userId, fileVO.getFolderId(), companyId, tenantId).isEmpty()
							&& !fileVO.getCreateId().equals(userId)) {
						result.put("status", "error");
						result.put("code", 3);
						return new JSONObject(result);
					}
				} else if (folder.getFolderType().equals("U")) { // 개인폴더 공유시, 공유대상자가 올린 파일에 대해서 '이동'권한이 없다고 하여 해당 코드 추가
					if (!folder.getOwnerId().equalsIgnoreCase(userId) && !fileVO.getCreateId().equalsIgnoreCase(userId)) {
						result.put("status", "error");
						result.put("code", 3);
						return new JSONObject(result);
					}
				} else {
					if (!fileVO.getCreateId().equalsIgnoreCase(userId)){
						result.put("status", "error");
						result.put("code", 3);
						return new JSONObject(result);
					}
				}
			}
		}

		result.put("status", "ok");
		result.put("code", 0);
		return new JSONObject(result);
	}

	@Override
	public String checkPermission(String userId, String deptId, String comId,
			String folderFileId, String folderFileType, int tenantId)
			throws Exception {
		logger.debug("checkPermission started.");

		String status = "fail";
		Map<String, Object> map = new HashMap<String, Object>();

		map.put("userId", userId);
		map.put("deptId", deptId);
		map.put("comId", comId);
		map.put("tenantId", tenantId);

		FolderVO folderVO = null;
		String parentFolderId = "";
		
		if (folderFileType.equals("F")) {
			map.put("fileId", folderFileId);
			folderVO = ezWebFolderDAO_y.getFolderDetailByFileId(map);
			parentFolderId = folderVO.getFolderId();
		} else {
			map.put("folderId", folderFileId);
			folderVO = ezWebFolderDAO_y.getFolderDetail(map);
			parentFolderId = folderFileId;
		}
		
		if (ezWebFolderAdminService.getFolderIdsByManagerUserId(userId, parentFolderId, comId, tenantId).size() > 0) {
			return status = "ok";
		}

		List<String> idList = ezWebFolderService_m.getPermissionIdList(userId,
				deptId, comId, tenantId);

		// 직위, 직책 권한이 추가 
		List<String> jikWiChekAddjobList = getjikWiChekAddjobList(tenantId, userId, comId);
		idList.addAll(jikWiChekAddjobList);

		// 권한그룹이 추가 : tbl_webfolder_folderuser에 있는 권한 그룹리스트 가져와서 체크
		map.put("companyId", comId);
		List<String> groupList = ezWebFolderDAO_y.getWebFolderUserGroupList(map);
		
		if (groupList != null) {
			for (String groupId : groupList) {
				boolean groupPermissionYN = ezCommonService.getPermissionGroupAccessYN(groupId, comId, tenantId, userId, deptId, true);
				
				if (groupPermissionYN) {
					idList.add(groupId);
				}
			}
		}

		
		if (folderFileType.equalsIgnoreCase("D") && folderVO != null) {
			String folderType = folderVO.getFolderType();
			String folderPath = folderVO.getFolderPath();
			String folderId = folderVO.getFolderId();

			if (folderType.equals("C")) {
				if (folderPath.equals("|" + folderVO.getFolderId() + "|")) {
					if (idList.contains(folderVO.getOwnerId())) {
						status = "ok";
					}
				} else {
					map = new HashMap<String, Object>();

					map.put("folderIdList", folderPath.split("\\|"));
					map.put("folderId", folderFileId);
					map.put("permissionIdList", idList);
					map.put("tenantId", tenantId);
					// 2020-12-11 김은실 - [카이스트] 하위부서를 포함시키지 않도록 했기 때문에, 불필요한 쿼리로 인한 부하를 줄임.
//					List<String> addjobList = getAddJobList(tenantId, userId);
//					addjobList.add(deptId);
//					map.put("userDeptList", addjobList);

					// boolean isExpired = ezWebFolderService.getExpiredMeetingFolders(userId, tenantId).contains(folderId);

					if (ezWebFolderDAO_y.checkCompanyFolderPermission(map) > 0) { //&& !isExpired) {
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
			if (folderFileType.equalsIgnoreCase("F") && !Objects.isNull(folderVO)){ // 2023-05-17 이사라 : NullPointerException 시큐어코딩
				map = new HashMap<String, Object>();

				map.put("fileId", folderFileId);
				map.put("permissionIdList", idList);
				map.put("tenantId", tenantId);

				String folderType = folderVO.getFolderType();

				if ("C".equalsIgnoreCase(folderType)) {
					if (ezWebFolderDAO_y.checkCompanyFilePermission(map) > 0) {
						status = "ok";
					}
				} else if ("D".equalsIgnoreCase(folderType)) {
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
					map.put("folderIdList", folderVO.getFolderPath().split("\\|"));
					map.put("permissionIdList", idList);
					map.put("tenantId", tenantId);

					if (ezWebFolderDAO_m.checkSharePermission(map) > 0) {
						status = "ok";
					}
				}
			} else {
				status = "fail";
			}
		}

		logger.debug("checkPermission ended. status=" + status);
		return status;
	}

	@Override
	public JSONObject checkPermissions(String userId, String deptId,
			String comId, String folders, String files, int tenantId)
			throws Exception {
		logger.debug("checkPermissions started.");
		logger.debug(String
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
			if (permissionChecker.accept(folders, "D") && permissionChecker.accept(files, "F")) {
				logger.debug("permission allowed.");
				result.put("status", "ok");
				result.put("code", 0);
			} else {
				logger.debug("permission denied.");
				result.put("status", "error");
				result.put("code", 3);
			}
		} catch (Exception ex) {
			logger.error(ex.getMessage(), ex);
			result.put("status", "error");
			result.put("code", 2);
		}

		logger.debug(String.format("result: %s", result.toString()));
		logger.debug("checkPermissions ended.");
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
	public JSONObject fileUpdateOverwrite(List<FileUploadVO> multiFileLists, JSONArray nameArray, LoginVO userInfo,
			String folderId, JSONArray fileIdArray , String realPath, int tenantId) throws Exception {
		
		String fileName = "";
		String path = "";
		String userId = userInfo.getId();
		String comId = userInfo.getCompanyID();
		String offset = userInfo.getOffset();
		String primary = userInfo.getPrimary();
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Map<String, Object> result = new HashMap<>();
		long[] fileSize            = new long[multiFileLists.size()];
		
		boolean isEncryptionFolder = ezWebFolderService.isEncryptionFolder(folderId, tenantId);
		boolean useVersionHistory = "YES".equalsIgnoreCase(ezCommonService.getTenantConfig("useWebfolderVersionHistory", tenantId));

		// 파일 가지고 온 array의 이름과 id를 가지고 다시 업로드 시켜야함
		// id의 정보를 가지고 와서 그 id의 정보를 가지고 온다 
		for (int i = 0; i < multiFileLists.size(); i++ ) {
			FileVO filevo = getFolderFileDetailForExplorer("file", (String)(((JSONObject)fileIdArray.get(i)).get("fileIdArray")), userId, tenantId , comId, offset, primary);
			String fileId = filevo.getFileId();
			fileName = filevo.getFilePath();
			String[] arryStrings = fileName.split("/");
			fileName = arryStrings[arryStrings.length-1];
			logger.debug("before fileName is " + fileName);
			
			if (filevo.getFileTypeName() == null) {
				filevo.setFileTypeName(ezWebFolderService.getFileTypeByFileExt("unknown", tenantId).getTypeName());
			}
			
			int dotPos     = fileName.lastIndexOf(".");
			String extend  = dotPos == -1 ? ".none" : fileName.substring(dotPos + 1);
			String newName = webfolderUtil.generateFilePath(extend);
			path = commonUtil.getUploadPath("upload_webfolder.ROOT", tenantId) + commonUtil.separator; 
			logger.debug("new fileName is " + newName);

			// 폴더가 암호화 대상이거나, 첫 번째 파일을 업로드할때 다운로드 불가 옵션을 선택했었다면 암호화하여 저장함
			boolean isEncryptedFile = ezWebFolderService.isEncryptedFile(fileId, tenantId);
			boolean requireEncrypt = isEncryptionFolder || isEncryptedFile;
			
			Date date      = new Date();
			// 실제 파일을 생성
			if (requireEncrypt) {
				writeUploadedFileEncryptKlib(multiFileLists.get(i).getBytes(), realPath + path + newName);
			} else {
				writeUploadedFile(multiFileLists.get(i).getInputStream(), realPath + path + newName);
			}
			
			String timeUTC = commonUtil.getDateStringInUTC(formatter.format(date), offset, true);
			
			fileSize[i]    = multiFileLists.get(i).getSize();
			
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("filePath", path + newName);
			map.put("userId", userId);
			map.put("fileId", filevo.getFileId());
			map.put("tenantId", tenantId);
			map.put("timeUTC",timeUTC);
			map.put("fileSize", fileSize[i] );
			map.put("fileName", filevo.getFileName());
			
			// 새로운 filePath로 경로 생성 및 db 업데이트
			@SuppressWarnings("unused")
			int updateResult = ezWebFolderDAO_y.updateFileRealData(map);
			
			if (useVersionHistory) {
				ezWebFolderService.incrementFileVersion(userInfo, fileId);

				if (requireEncrypt) {
					ezWebFolderService.insertEncryptedFile(fileId, tenantId);
				}
			}

			// 로그 찍기
			ezWebFolderService.saveLog("WR", comId, offset, userId, userInfo.getDisplayName1(), userInfo.getDisplayName2(), tenantId, filevo, "", userInfo.getPrimary());
			
			// db 업데이트 성공시 기존 파일 delete -> ezWebFolderService.incrementFileVersion() 안으로 옮김.
//			File file = new File(realPath + commonUtil.detectPathTraversal(filevo.getFilePath()));
//
//			if (file.exists() && file.isFile()) {
//				if (file.delete()) {
//					logger.debug("delete success.");
//				}
//			} else {
//				logger.debug("file is not exists.");
//			}
			
		}
		result.put("status", "ok");
		result.put("code", 0);

		return new JSONObject(result);
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
	public String folderIdByUserIdAndFolderType(String ownerId, int tenantId, String folderType) throws Exception {
		Map<String, Object> map  = new HashMap<String, Object>();
		map.put("tenantId", tenantId);
		if (folderType == null || folderType.equals("")){
			folderType = "U";
		} 
		map.put("folderType", folderType);
		map.put("ownerId", ownerId);
		
		String folderId = ezWebFolderDAO_y.folderIdByUserIdAndFolderType(map);
		
		return folderId ;
	}

	@Override
	public ArrayList<Map<String, Object>> selectWebfolderFiletoAnother(String userId,  ArrayList<String> param, int tenantId) {
		Map<String, Object> map = new HashMap<String, Object>();
		String[] arr = null;
		List<String> fileList = new ArrayList<String>();
		String query = "";
		
		for (int i = 0; i <param.size(); i++){
			arr = null;
			arr = param.get(i).split("/");
			fileList.add(arr[1]);
		}
		
		map.put("fileList", fileList);
		map.put("tenantId", tenantId);
		
		ArrayList<Map<String, Object>> result = new ArrayList<Map<String,Object>>();
		result = ezWebFolderDAO_y.selectWebfolderFiletoAnother(map);
		
		return result;
	}
	
	// 겸직 리스트 가져오는 메서드
	@Override
	public List<String> getjikWiChekAddjobList(int tenantId, String userId, String compId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("tenantId", tenantId);
		map.put("userId", userId);
		map.put("companyId", compId);
		
		return ezWebFolderDAO_y.getjikWiChekAddjobList(map);
	}

	@Override
	public FileVO selectFileDetail(String fileId, int tenantId) throws Exception {
		Map<String, Object> map = new HashMap<>();

		map.put("fileId", fileId);
		map.put("tenantId", tenantId);

		return ezWebFolderDAO_y.selectFileDetail(map);
	}

	@Override
	public List<Map<String, Object>> getRootFolderListInfo(JSONObject jsonObject)
			throws Exception {
		String userId = (String)jsonObject.get("userId");
		String deptId = (String)jsonObject.get("deptId");
		String comId = (String)jsonObject.get("comId");
		int tenantId = (Integer)jsonObject.get("tenantId");
		String folderType = (String)jsonObject.get("folderType");
		
		System.out.println(jsonObject);
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("userId", userId);
		map.put("tenantId", tenantId);
		map.put("companyId", comId);
		List<String> addjobList = getAddJobList(tenantId, userId);
		List<String> folderUserIdList = ezWebFolderDAO_m.getFolderUserIdList_D(map);

		List<String> jikWiChekAddjobList = getjikWiChekAddjobList(tenantId, userId, comId);
		Set<String> idSet = new HashSet<String>();
		idSet.add(userId);
		idSet.add(deptId);
		idSet.addAll(addjobList);
		if (folderType.equals("C") || folderType.equals("S")) {
			idSet.add(comId);
			idSet.addAll(jikWiChekAddjobList);
			idSet.addAll(folderUserIdList);
		}

		// 권한그룹이 추가 : tbl_webfolder_folderuser에 있는 권한 그룹리스트 가져와서 체크
		List<String> groupList = ezWebFolderDAO_y.getWebFolderUserGroupList(map);
		
		if (groupList != null) {
			for (String groupId : groupList) {
				boolean groupPermissionYN = ezCommonService.getPermissionGroupAccessYN(groupId, comId, tenantId, userId, deptId, true);
				
				if (groupPermissionYN) {
					idSet.add(groupId);
				}
			}
		}

		map.put("idList"		, idSet.toArray(new String[idSet.size()]));
		map.put("tenantId"		, tenantId);
		map.put("folderType"	, (String)jsonObject.get("folderType"));
		map.put("primary"		, (String)jsonObject.get("primary"));
		
		List<Map<String, Object>> result = ezWebFolderDAO_y.selectRootFolderListInfo(map); 
		
		logger.debug("result=" + result);
		return result; 
	}
	
	@Override
	public List<String> idListUpgrade(String userId, String deptId, String comId, int tenantId) throws Exception{
		List<Map<String, String>> idList = ezWebFolderService_m.getPermissionIdMapList(userId, deptId, comId, tenantId);
		Map<String, Object> map = new HashMap<String, Object>();
		System.out.println(idList);
		map.put("tenantId", tenantId);
		
		List<String> idListUpgrade = new ArrayList<String>();
		for (Map<String, String> id : idList) {
			idListUpgrade.add((String)id.get("id"));
		}
		
		// 직위, 직책 권한이 추가 
		map.put("companyId", comId);
		List<String> jikWiChekAddjobList = getjikWiChekAddjobList(tenantId, userId, comId);
		idListUpgrade.addAll(jikWiChekAddjobList);
		
		// 권한그룹 idList 변경 :특정 사용자가 속한 모든 권한그룹의 아이디 목록을 반환하는 Method API(이동호 팀장님_2020-12-10) 
		idListUpgrade.addAll(ezCommonService.getPermissionGroupIdListOfUser(userId, deptId, comId, tenantId));
		
		return idListUpgrade;
	}

	@Override
	public String changeUserFileORFolder(String currFolderId, String userId, String targetId, String folderUsers, String targetType, String offset, int tenantId,
			ArrayList<String> addUser, ArrayList<String> deleteUser, String subFolderType, LoginVO userInfo) throws Exception {
		String result = "OK";
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Date date                  = new Date();
		String timeUTC             = commonUtil.getDateStringInUTC(formatter.format(date), offset, true);
		if (targetType.equalsIgnoreCase("D")){
			String folderId = targetId;
			FolderVO folder            = ezWebFolderService.getFolderByFolderId(folderId, offset, tenantId);
			
			if (folder.getFolderLevel() == 0) {
				return "error";
			}
			
			folder.setUpdateId(userId);
			folder.setTenantId(tenantId);
			
			if (addUser.size() > 0){
				insertListUsers(userId, folderId, folder.getCompanyId(), folderUsers, tenantId, timeUTC, addUser, subFolderType, folder.getFolderPath(), offset);
			}
			
			if (deleteUser.size() > 0){
				
				JSONObject param = new JSONObject();
				param.put("folderId", folderId);
				param.put("tenantId", tenantId);
				param.put("subFolderType", 1);
				param.put("folderPath", folder.getFolderPath());
				List<FileVO> fileList = ezWebFolderAdminService.folderInFileList(param);
				
				ezWebFolderAdminService.deleteSelectedFolderUser(folder.getFolderPath(), deleteUser, tenantId, 0);
				for(int i=0; i<fileList.size(); i++){
					ezWebFolderAdminService.deleteSelectedFileUser(deleteUser, tenantId, fileList.get(i).getFileId());
				}
			}
		} else {
			JSONParser parser          = new JSONParser();
			folderUsers.replace("\\", "");
			if (folderUsers.substring(0,1).equals("\"")){
				folderUsers = folderUsers.substring(1, folderUsers.length()-1);
			}
			JSONArray folderUsersArray = (JSONArray) parser.parse(folderUsers);

			FileVO fileVO = selectFileDetail(targetId, tenantId);
			FolderVO folder = ezWebFolderService.getFolderByFolderId(fileVO.getFolderId(), offset, tenantId);
			
			for(int i=0; i<folderUsersArray.size(); i++){
				JSONObject json    = (JSONObject) folderUsersArray.get(i);
				if(addUser.contains(json.get("userId").toString())){
					// insert 
					ezWebFolderService.insertFileUser(fileVO, "", 
							(String)json.get("userId"), (String)json.get("userType"), folder.getCompanyId());
				}
			}
			
			if (deleteUser.size() > 0){
				ezWebFolderAdminService.deleteSelectedFileUser(deleteUser, tenantId, targetId);
			}
		}
		return result;
	}

	private void insertListUsers(String userId, String folderId, String companyId, String folderUsers, int tenantId, String timeUTC, 
			ArrayList<String> addUser, String subFolderType, String folderPath, String offset) throws Exception{
		List<FolderSimpleVO> subAllFolderInfo = new ArrayList<FolderSimpleVO>();
		JSONParser parser          = new JSONParser();
		folderUsers.replace("\\", "");
		if (folderUsers.substring(0,1).equals("\"")){
			folderUsers = folderUsers.substring(1, folderUsers.length()-1);
		}
		JSONArray folderUsersArray = (JSONArray) parser.parse(folderUsers);
		
		if (subFolderType.equals("1")) {
			subAllFolderInfo = ezWebFolderAdminService.selectSubAllFolder(folderPath, tenantId);
		} else {
			FolderSimpleVO temp = new FolderSimpleVO();
			temp.setFolderId(folderId);
			subAllFolderInfo.add(temp);
		}
		
		for(int j=0; j<subAllFolderInfo.size(); j++){
			String folderIdTemp = subAllFolderInfo.get(j).getFolderId();
			
			for(int i=0; i<folderUsersArray.size(); i++){
				try {
					JSONObject json    = (JSONObject) folderUsersArray.get(i);
					if(addUser.contains(json.get("userId").toString())){
						// insert 
						if(ezWebFolderService.checkFolderUserExists((String)json.get("userId"), folderIdTemp, (Boolean)json.get("folderManager")) == 0){
							ezWebFolderAdminService.insertFolderUser(ezWebFolderAdminService.getMaxFolderUserSeq(tenantId), (String)json.get("userId"), 
									(String)json.get("userType"), folderIdTemp, userId, timeUTC, companyId, 
									tenantId, (Boolean)json.get("subdeptPermitted"), (Boolean)json.get("folderManager"));
						}
					}
				} catch (Exception e) {
					logger.debug("exists userId, so next userInsert.");
					continue;
				}
			}
		}
		if(subFolderType.equals("1")) {
			addFileUserCurrFolder(folderId, offset, tenantId, folderUsers, addUser, subFolderType);
		}
	}
	
	@Override
	public void addFileUserCurrFolder (String currFolderId, String offset, int tenantId, String folderUsers, ArrayList<String> addUser, String subFolderType) throws Exception {
		FolderVO folder            = ezWebFolderService.getFolderByFolderId(currFolderId, offset, tenantId);
		JSONObject param = new JSONObject();
		param.put("folderId", currFolderId);
		param.put("tenantId", tenantId);
		param.put("subFolderType", subFolderType);
		param.put("folderPath", folder.getFolderPath());
		
		JSONParser parser          = new JSONParser();
		folderUsers.replace("\\", "");
		if (folderUsers.substring(0,1).equals("\"")){
			folderUsers = folderUsers.substring(1, folderUsers.length()-1);
		}
		JSONArray folderUsersArray = (JSONArray) parser.parse(folderUsers);
		List<FileVO> fileList = ezWebFolderAdminService.folderInFileList(param);
		
		for(int j=0; j<fileList.size(); j++){
			for(int i=0; i<folderUsersArray.size(); i++){
				JSONObject json    = (JSONObject) folderUsersArray.get(i);
				if(addUser.contains(json.get("userId").toString())){
					if(ezWebFolderService.checkFileUserExists((String)json.get("userId"), fileList.get(j).getFileId()) == 0){
						fileList.get(j).setTenantId(tenantId);
						ezWebFolderService.insertFileUser(fileList.get(j), "", 
								(String)json.get("userId"), (String)json.get("userType"), folder.getCompanyId());
					}
				}
			}
		}
	}
	
}
