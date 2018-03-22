package egovframework.ezEKP.ezWebFolder.service.impl;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.annotation.Resource;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import egovframework.ezEKP.ezOrgan.vo.OrganDeptVO;
import egovframework.ezEKP.ezWebFolder.dao.EzWebFolderAdminDAO;
import egovframework.ezEKP.ezWebFolder.service.EzWebFolderAdminService;
import egovframework.ezEKP.ezWebFolder.service.EzWebFolderService;
import egovframework.ezEKP.ezWebFolder.vo.FileLogVO;
import egovframework.ezEKP.ezWebFolder.vo.FileVO;
import egovframework.ezEKP.ezWebFolder.vo.FolderUserVO;
import egovframework.ezEKP.ezWebFolder.vo.FolderVO;
import egovframework.ezEKP.ezWebFolder.vo.UserCapacityVO;
import egovframework.ezEKP.ezWebFolder.vo.WebfolderConfigVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;

@Service("EzWebFolderAdminService")
public class EzWebFolderAdminServiceImpl implements EzWebFolderAdminService {
	@Resource(name = "EzWebFolderAdminDAO")
	private EzWebFolderAdminDAO ezWebFolderAdminDAO;
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private EzWebFolderService ezWebFolderService;
	
	private static final Logger logger = LoggerFactory.getLogger(EzWebFolderAdminServiceImpl.class);
	
	@Override
	public void saveConfig(String personalLimit, String uploadLimit, String companyId, int tenantId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("personalLimit", personalLimit);
		map.put("uploadLimit",   uploadLimit);
		map.put("companyId",     companyId);
		map.put("tenantId",      tenantId);
		ezWebFolderAdminDAO.saveConfig(map);
	}

	@Override
	public WebfolderConfigVO getWebfolderConfig(String companyId, int tenantId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("companyId", companyId);
		map.put("tenantId",  tenantId);
		return ezWebFolderAdminDAO.getWebfolderConfig(map);
	}

	@Override
	public List<UserCapacityVO> getListUserCapacity(String companyId, String searchStr, String searchOpt, int startPoint, int pageSize, int tenantId, String primary) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("companyId",  companyId);
		map.put("searchStr",  searchStr);
		map.put("searchOpt",  searchOpt);
		map.put("startPoint", startPoint);
		map.put("pageSize",   pageSize);
		map.put("tenantId",   tenantId);
		map.put("primary",    primary);
		return ezWebFolderAdminDAO.getListUserCapacity(map);
	}

	@Override
	public int getTotalListUserCapacity(String companyId, String searchStr, String searchOpt, int startPoint, int pageSize, int tenantId, String primary) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("companyId",  companyId);
		map.put("searchStr",  searchStr);
		map.put("searchOpt",  searchOpt);
		map.put("startPoint", startPoint);
		map.put("pageSize",   pageSize);
		map.put("tenantId",   tenantId);
		map.put("primary",    primary);
		return ezWebFolderAdminDAO.getTotalListUserCapacity(map);
	}

	@Override
	public void updateNewAmount(List<String> userList, String newStorageValue, String companyId, int tenantId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("totalCapacity", newStorageValue);
		map.put("companyId",     companyId);
		map.put("tenantId",      tenantId);
		
		for (String userId : userList) {
			map.put("userId",        userId);
			ezWebFolderAdminDAO.updateNewAmount(map);
		}
	}

	@Override
	public List<FileLogVO> getListFileLogs(String companyId, String searchChk, String startDate, String endDate, String fileExt, String fileName, String userName, int startPoint, int pageSize, String primary, String offset, int tenantId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("companyId",  companyId);
		map.put("searchChk",  searchChk);
		map.put("startDate",  startDate);
		map.put("endDate",    endDate);
		map.put("fileExt",    fileExt);
		map.put("fileName",   fileName);
		map.put("userName",   userName);
		map.put("startPoint", startPoint);
		map.put("pageSize",   pageSize);
		map.put("offset",     commonUtil.getMinuteUTC(offset));
		map.put("primary",    primary);
		map.put("tenantId",   tenantId);
		return ezWebFolderAdminDAO.getListFileLogs(map);
	}

	@Override
	public int getTotalFileLogs(String companyId, String searchChk, String startDate, String endDate, String fileExt, String fileName, String userName, int startPoint, int endPoint, String primary, int tenantId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("companyId",  companyId);
		map.put("searchChk",  searchChk);
		map.put("startDate",  startDate);
		map.put("endDate",    endDate);
		map.put("fileExt",    fileExt);
		map.put("fileName",   fileName);
		map.put("userName",   userName);
		map.put("startPoint", startPoint);
		map.put("endPoint",   endPoint);
		map.put("primary",    primary);
		map.put("tenantId",   tenantId);
		return ezWebFolderAdminDAO.getTotalFileLogs(map);
	}

	@Override
	public void insertFileLog(FileLogVO fileLog) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("logId",       fileLog.getLogId());
		map.put("fileType",    fileLog.getFileType());
		map.put("fileName",    fileLog.getFileName());
		map.put("fileSize",    fileLog.getFileSize());
		map.put("fileExt",     fileLog.getFileExt());
		map.put("logType",     fileLog.getLogType());
		map.put("createId",    fileLog.getCreateId());
		map.put("createName1", fileLog.getCreateName1());
		map.put("createName2", fileLog.getCreateName2());
		map.put("createDate",  fileLog.getCreateDate());
		map.put("companyId",   fileLog.getCompanyId());
		map.put("tenantId",    fileLog.getTenantId());
		ezWebFolderAdminDAO.insertFileLog(map);
	}

	@Override
	public void insertFolder(FolderVO folder) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("folderId",    folder.getFolderId());
		map.put("folerName1",  folder.getFolderName1());
		map.put("folerName2",  folder.getFolderName2());
		map.put("folderType",  folder.getFolderType());
		map.put("folderPath",  folder.getFolderPath());
		map.put("folderStep",  folder.getFolderStep());
		map.put("folderLevel", folder.getFolderLevel());
		map.put("folderUpper", folder.getFolderUpper());
		map.put("useStatus",   folder.getUseStatus());
		map.put("ownerId",     folder.getOwnerId());
		map.put("createId",    folder.getCreateId());
		map.put("createDate",  folder.getCreateDate());
		map.put("createName1", folder.getCreateName1());
		map.put("createName2", folder.getCreateName2());
		map.put("updateId",    folder.getUpdateId());
		map.put("updateDate",  folder.getUpdateDate());
		map.put("companyId",   folder.getCompanyId());
		map.put("deleterId",   folder.getDeleterId());
		map.put("tenantId",    folder.getTenantId());
		ezWebFolderAdminDAO.insertFolder(map);
	}

	@Override
	public void insertFolder2(FolderVO folder) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("folderId",    folder.getFolderId());
		map.put("folerName1",  folder.getFolderName1());
		map.put("folerName2",  folder.getFolderName2());
		map.put("folderType",  folder.getFolderType());
		map.put("folderPath",  folder.getFolderPath());
		map.put("folderStep",  folder.getFolderStep());
		map.put("folderLevel", folder.getFolderLevel());
		map.put("folderUpper", folder.getFolderUpper());
		map.put("useStatus",   folder.getUseStatus());
		map.put("ownerId",     folder.getOwnerId());
		map.put("createId",    folder.getCreateId());
		map.put("createDate",  folder.getCreateDate());
		map.put("createName1", folder.getCreateName1());
		map.put("createName2", folder.getCreateName2());
		map.put("updateId",    folder.getUpdateId());
		map.put("updateDate",  folder.getUpdateDate());
		map.put("companyId",   folder.getCompanyId());
		map.put("deleterId",   folder.getDeleterId());
		map.put("tenantId",    folder.getTenantId());
		ezWebFolderAdminDAO.insertFolder2(map);
	}

	@Override
	public void insertFolderUser(String seq, String userId, String userType, String folderId, String createId, String createDate, String companyId, int tenantId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("seqId",      seq);
		map.put("userId",     userId);
		map.put("userType",   userType);
		map.put("folderId",   folderId);
		map.put("createId",   createId);
		map.put("createDate", createDate);
		map.put("companyId",  companyId);
		map.put("tenantId",   tenantId);
		ezWebFolderAdminDAO.insertFolderUser(map);
	}

	@Override
	public void deleteFolderUsers(String folderId, int tenantId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("folderId", folderId);
		map.put("tenantId", tenantId);
		ezWebFolderAdminDAO.deleteFolderUsers(map);
	}

	@Override
	public void deleteFolderUsersOfChief(String userId, int tenantId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("userId",   userId);
		map.put("tenantId", tenantId);
		ezWebFolderAdminDAO.deleteFolderUsersOfChief(map);
	}

	private void insertListFolderUsers(String userId, String folderId, String companyId, String folderUsers, String timeUTC, int tenantId) throws Exception {
		JSONParser parser          = new JSONParser();
		JSONObject json            = (JSONObject) parser.parse(folderUsers);
		JSONArray userArray        = (JSONArray)json.get("user");
		JSONArray deptArray        = (JSONArray)json.get("dept");
		
		if (userArray != null && userArray.size() > 0) {
			for (int i = 0; i < userArray.size(); i++) {
				insertFolderUser(getMaxFolderUserSeq(tenantId), (String)userArray.get(i), "user", folderId, userId, timeUTC, companyId, tenantId);
			}
		}
		
		if (deptArray != null && deptArray.size() > 0) {
			for (int i = 0; i < deptArray.size(); i++) {
				insertFolderUser(getMaxFolderUserSeq(tenantId), (String)deptArray.get(i), "dept", folderId, userId, timeUTC, companyId, tenantId);
			}
		}
	}
	
	@Override
	public void addCompanyFolder(String pFolderId, String folderUsers, String folderName, String folderName2, LoginVO userInfo) throws Exception {
		String userName1           = userInfo.getDisplayName1();
		String userName2           = userInfo.getDisplayName2();
		int tenantId               = userInfo.getTenantId();
		String userId              = userInfo.getId();
		String offset              = userInfo.getOffset();
		FolderVO parentFolder      = ezWebFolderService.getFolderByFolderId(pFolderId, offset, tenantId);
		FolderVO folder            = new FolderVO();
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Date date                  = new Date();
		String timeUTC             = commonUtil.getDateStringInUTC(formatter.format(date), offset, true);
		String folderId            = getMaxFolderID(tenantId);
		
		folder.setFolderId(folderId);
		folder.setFolderLevel(parentFolder.getFolderLevel() + 1);
		folder.setFolderName1(folderName);
		folder.setFolderName2(folderName2);
		folder.setFolderPath(parentFolder.getFolderPath() + folderId + "|");
		folder.setFolderStep(getMaxFolderStep(pFolderId, tenantId));
		folder.setFolderType("C");
		folder.setFolderUpper(parentFolder.getFolderId());
		folder.setOwnerId(parentFolder.getOwnerId());
		folder.setUseStatus("Y");
		folder.setUpdateId(userId);
		folder.setCreateName1(userName1);
		folder.setCreateName2(userName2);
		folder.setTenantId(tenantId);
		folder.setCompanyId(parentFolder.getCompanyId());
		folder.setCreateId(userId);
		folder.setCreateDate(timeUTC);
		folder.setUpdateDate(timeUTC);
		
		//Insert folder
		insertFolder(folder);
		
		//Insert new folder users
		insertListFolderUsers(userId, folderId, folder.getCompanyId(), folderUsers, timeUTC, tenantId);
	}
	
	@Override
	public void updateCompanyFolder(String userId, String folderId, String folderUsers, String folderName, String folderName2, String offset, int tenantId) throws Exception {
		FolderVO folder            = ezWebFolderService.getFolderByFolderId(folderId, offset, tenantId);
		String folderPath          = folder.getFolderPath();
		folderPath                 = folderPath.substring(1, folderPath.length() - 1);
		String ancestorId          = folderPath.split("\\|")[1];
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Date date                  = new Date();
		String timeUTC             = commonUtil.getDateStringInUTC(formatter.format(date), offset, true);
		
		folder.setFolderName1(folderName);
		folder.setFolderName2(folderName2);
		folder.setUpdateId(userId);
		folder.setTenantId(tenantId);
		folder.setUpdateDate(timeUTC);
		
		insertFolder(folder);
		
		if (ancestorId.equals(folderId)) {
			//Delete all folder users
			deleteFolderUsers(folderId, tenantId);
			
			//Insert new folder users
			insertListFolderUsers(userId, folderId, folder.getCompanyId(), folderUsers, timeUTC, tenantId);
		}
	}
	
	@Override
	public void addDeptFolders(String companyId, LoginVO userInfo) throws Exception {
		int tenantId                = userInfo.getTenantId();
		String offset               = userInfo.getOffset();
		String primary              = userInfo.getPrimary();
		String userId               = userInfo.getId();
		SimpleDateFormat formatter  = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Date date                   = new Date();
		String timeUTC              = commonUtil.getDateStringInUTC(formatter.format(date), offset, true);
		
		List<OrganDeptVO> listDepts = ezWebFolderService.getAllDepartments(companyId, primary, tenantId);
		
		logger.debug("List length: " + listDepts.size());
		
		for (OrganDeptVO dept : listDepts) {
			FolderVO folder = new FolderVO();
			String folderId = getMaxFolderID(tenantId);
			
			folder.setFolderId(folderId);
			folder.setFolderLevel(0);
			folder.setFolderName1(dept.getDisplayName1());
			folder.setFolderName2(dept.getDisplayName2());
			folder.setFolderPath("|" + folderId + "|");
			folder.setFolderStep(0);
			folder.setFolderType("D");
			folder.setFolderUpper("root");
			folder.setOwnerId(dept.getCn());
			folder.setUseStatus("Y");
			folder.setUpdateId(userId);
			folder.setCreateName1(userInfo.getDisplayName1());
			folder.setCreateName2(userInfo.getDisplayName2());
			folder.setTenantId(tenantId);
			folder.setCompanyId(companyId);
			folder.setCreateId(userId);
			folder.setCreateDate(timeUTC);
			folder.setUpdateDate(timeUTC);
			
			insertFolder2(folder);
			insertFolderUser(getMaxFolderUserSeq(tenantId), dept.getCn(), "dept", folderId, userId, timeUTC, folder.getCompanyId(), tenantId);
		}
	}
	
	public void addPersonalFolder(LoginVO userInfo) throws Exception {
		FolderVO folder            = new FolderVO();
		int tenantId               = userInfo.getTenantId();
		String offset              = userInfo.getOffset();
		String userId              = userInfo.getId();
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Date date                  = new Date();
		String timeUTC             = commonUtil.getDateStringInUTC(formatter.format(date), offset, true);
		String folderId            = getMaxFolderID(tenantId);
		
		folder.setFolderId(folderId);
		folder.setFolderLevel(0);
		folder.setFolderName1(userInfo.getDisplayName1());
		folder.setFolderName2(userInfo.getDisplayName2());
		folder.setFolderPath("|" + folderId + "|");
		folder.setFolderStep(0);
		folder.setFolderType("U");
		folder.setFolderUpper("root");
		folder.setOwnerId(userInfo.getId());
		folder.setUseStatus("Y");
		folder.setUpdateId(userId);
		folder.setCreateName1(userInfo.getDisplayName1());
		folder.setCreateName2(userInfo.getDisplayName2());
		folder.setTenantId(tenantId);
		folder.setCompanyId(userInfo.getCompanyID());
		folder.setCreateId(userId);
		folder.setCreateDate(timeUTC);
		folder.setUpdateDate(timeUTC);
		
		insertFolder(folder);
		insertFolderUser(getMaxFolderUserSeq(tenantId), userId, "user", folderId, userId, timeUTC, folder.getCompanyId(), tenantId);
	}
	
	public void updateSelectedDeptsForChief(List<String> deptsList, String userId, String offset, int tenantId) throws Exception {
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Date date                  = new Date();
		String timeUTC             = commonUtil.getDateStringInUTC(formatter.format(date), offset, true);
		
		//Delete all folder users
		deleteFolderUsersOfChief(userId, tenantId);
		
		if (deptsList != null && deptsList.size() > 0) {
			//Add new dept list
			for (String deptId : deptsList) {
				FolderVO folderVO = ezWebFolderService.getRootFolderId(deptId, "D", offset, tenantId);
				insertFolderUser(getMaxFolderUserSeq(tenantId), userId, "chief", folderVO.getFolderId(), userId, timeUTC, folderVO.getCompanyId(), tenantId);
			}
		}
	}
	
	@Override
	public void moveCompanyFolder(FolderVO folder, List<FolderVO> listSubFolder, String destFolderId, String mode, LoginVO userInfo) throws Exception {
		
		if (mode.equals("move")) {
			moveFolder(folder, listSubFolder, destFolderId, userInfo.getId(), userInfo.getOffset(), userInfo.getTenantId());
		}
		else {
			copyFolder(folder, listSubFolder, destFolderId, userInfo);
		}
	}
	
	public String getMaxFolderUserSeq(int tenantId) throws Exception {
		int currentMaxolderUserId  = -1;
		String result              = ezWebFolderService.getFolderUserSequence(tenantId);
		currentMaxolderUserId      = result.equals("")             ? 1 : Integer.parseInt(result);
		currentMaxolderUserId	   = (currentMaxolderUserId == -1) ? 1 : (currentMaxolderUserId + 1);
		return Integer.toString(currentMaxolderUserId);
	}
	
	@Override
	public String getMaxFolderID(int tenantId) throws Exception {
		int currentMaxFolderId = -1;
		String result          = ezWebFolderService.getFolderSequence(tenantId);
		currentMaxFolderId     = result.equals("")          ? 1 : Integer.parseInt(result);
		currentMaxFolderId     = (currentMaxFolderId == -1) ? 1 : (currentMaxFolderId + 1);
		return Integer.toString(currentMaxFolderId);
	}
	
	public int getMaxFolderStep(String folderId, int tenantId) throws Exception {
		int currentMaxStep = -1;
		String result      = ezWebFolderService.getMaxFolderStep(folderId, tenantId);
		currentMaxStep     = result.equals("")        ? 1 : Integer.parseInt(result);
		currentMaxStep     = (currentMaxStep == -1)   ? 1 : (currentMaxStep + 1);
		return currentMaxStep;
	}
	
	private void moveFolder(FolderVO folder, List<FolderVO> listSubFolder, String destFolderId, String userId, String offset, int tenantId) throws Exception {
		FolderVO parentFolder      = ezWebFolderService.getFolderByFolderId(destFolderId, offset, tenantId);
		String oldPath             = folder.getFolderPath();
		String newPath             = parentFolder.getFolderPath() + folder.getFolderId() + "|";
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Date date                  = new Date();
		String timeUTC             = commonUtil.getDateStringInUTC(formatter.format(date), offset, true);
		int levelDistance          = parentFolder.getFolderLevel() + 1 - folder.getFolderLevel();
		
		if (folder.getFolderLevel() == 1) {
			//Delete all folder users
			deleteFolderUsers(folder.getFolderId(), tenantId);
		}
		
		if ((folder.getFolderLevel() + levelDistance == 1) && parentFolder.getFolderType().equals("C")) {
			String folderPath            = folder.getFolderPath();
			folderPath                   = folderPath.substring(1, folderPath.length() - 1);
			String ancestorId            = folder.getFolderType().equals("C") ? folderPath.split("\\|")[1] : folderPath.split("\\|")[0];
			List<FolderUserVO> listUsers = ezWebFolderService.getFolderUsers(ancestorId, tenantId);
			
			for (FolderUserVO folderUser: listUsers) {
				insertFolderUser(getMaxFolderUserSeq(tenantId), folderUser.getUserId(), folderUser.getUserType(), folder.getFolderId(), userId, timeUTC, folder.getCompanyId(), tenantId);
			}
		}
		
		folder.setFolderPath(newPath);
		folder.setOwnerId(parentFolder.getOwnerId());
		folder.setFolderType(parentFolder.getFolderType());
		folder.setUpdateId(userId);
		folder.setUpdateDate(timeUTC);
		folder.setFolderUpper(destFolderId);
		folder.setFolderLevel(folder.getFolderLevel() + levelDistance);
		folder.setFolderStep(getMaxFolderStep(destFolderId, tenantId));
		insertFolder(folder);
		
		for (FolderVO subFld : listSubFolder) {
			String folderPath = subFld.getFolderPath();
			folderPath        = folderPath.replace(oldPath, newPath);
			subFld.setFolderPath(folderPath);
			subFld.setUpdateDate(timeUTC);
			subFld.setUpdateId(userId);
			subFld.setFolderLevel(subFld.getFolderLevel() + levelDistance);
			
			//Update Folder
			insertFolder(subFld);
		}
	}
	
	private void copyFolder(FolderVO folder, List<FolderVO> listSubFolder, String destFolderId, LoginVO userInfo) throws Exception {
		String userId              = userInfo.getId();
		String offset              = userInfo.getOffset();
		int tenantId               = userInfo.getTenantId();
		FolderVO parentFolder      = ezWebFolderService.getFolderByFolderId(destFolderId, offset, tenantId);
		String folderId            = folder.getFolderId();
		String oldPath             = folder.getFolderPath();
		String newId               = getMaxFolderID(tenantId);
		String newPath             = parentFolder.getFolderPath() + newId + "|";
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Date date                  = new Date();
		String timeUTC             = commonUtil.getDateStringInUTC(formatter.format(date), offset, true);
		int levelDistance          = parentFolder.getFolderLevel() + 1 - folder.getFolderLevel();
		
		if (folder.getFolderLevel() + levelDistance == 1) {
			String folderPath = folder.getFolderPath();
			folderPath        = folderPath.substring(1, folderPath.length() - 1);
			String ancestorId = folderPath.split("\\|")[1];
			
			List<FolderUserVO> listUsers = ezWebFolderService.getFolderUsers(ancestorId, tenantId);
			
			for (FolderUserVO folderUser: listUsers) {
				insertFolderUser(getMaxFolderUserSeq(tenantId), folderUser.getUserId(), folderUser.getUserType(), folder.getFolderId(), userId, timeUTC, folder.getCompanyId(), tenantId);
			}
		}
		
		folder.setFolderPath(newPath);
		folder.setUpdateId(userId);
		folder.setUpdateDate(timeUTC);
		folder.setFolderUpper(destFolderId);
		folder.setFolderLevel(folder.getFolderLevel() + levelDistance);
		folder.setFolderStep(getMaxFolderStep(destFolderId, tenantId));
		folder.setFolderId(newId);
		
		insertFolder(folder);
		copyFile(folderId, newId, timeUTC, userInfo);
		
		for (int i = 0; i < listSubFolder.size(); i++) {
			FolderVO subFld   = listSubFolder.get(i);
			String oldId      = subFld.getFolderId();
			String newSubId   = getMaxFolderID(tenantId);
			String folderPath = subFld.getFolderPath();
			folderPath        = folderPath.replace(oldPath, newPath);
			folderPath        = folderPath.replace("|" + subFld.getFolderId() + "|", "|" + newSubId + "|");
			
			subFld.setFolderPath(folderPath);
			subFld.setUpdateDate(timeUTC);
			subFld.setUpdateId(userId);
			subFld.setFolderLevel(subFld.getFolderLevel() + levelDistance);
			subFld.setFolderId(newSubId);
			
			folderPath           = folderPath.substring(1, folderPath.length() - 1);
			String[] folderArry  = folderPath.split("\\|");
			String upperFolderId = folderArry[folderArry.length - 2];
			
			subFld.setFolderUpper(upperFolderId);
			
			//Update Folder
			insertFolder(subFld);
			copyFile(oldId, newSubId, timeUTC, userInfo);
		}
	}
	
	private void copyFile(String folderId, String newId, String timeUTC, LoginVO userInfo) throws Exception {
		List<FileVO> fileList = ezWebFolderService.getAllFilesInFolder(folderId, "", "0", "", "", "", "", "", "1", 0, 0, userInfo.getPrimary(), userInfo.getOffset(), userInfo.getTenantId());
		
		if (fileList != null && fileList.size() > 0) {
			for (FileVO file : fileList) {
				file.setDownloadCnt(0);
				file.setFolderId(newId);
				file.setUpdateDate(timeUTC);
				file.setUpdateId(userInfo.getId());
				file.setFileId(ezWebFolderService.getMaxFileID(userInfo.getTenantId()));
				ezWebFolderService.insertFile(file);
				ezWebFolderService.saveLog("C", userInfo.getCompanyID(), userInfo.getOffset(), userInfo.getId(), userInfo.getDisplayName1(), userInfo.getDisplayName2(), file.getFileName(), file.getFileSize(), file.getFileExt(), file.getFileTypeName(), userInfo.getTenantId());
			}
		}
	}
}
