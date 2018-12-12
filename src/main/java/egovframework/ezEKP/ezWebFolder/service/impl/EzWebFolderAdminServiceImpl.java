package egovframework.ezEKP.ezWebFolder.service.impl;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.UUID;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.ClientAnchor;
import org.apache.poi.ss.usermodel.ClientAnchor.AnchorType;
import org.apache.poi.ss.usermodel.CreationHelper;
import org.apache.poi.ss.usermodel.Drawing;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.util.IOUtils;
import org.apache.poi.util.Units;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.apache.commons.io.FileUtils;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.FileCopyUtils;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.service.EgovFileMngUtil;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
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
public class EzWebFolderAdminServiceImpl extends EgovFileMngUtil implements EzWebFolderAdminService {
	@Resource(name = "EzWebFolderAdminDAO")
	private EzWebFolderAdminDAO ezWebFolderAdminDAO;
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private EzWebFolderService ezWebFolderService;
	
	@Autowired
	private EzOrganService ezOrganService;
	
	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;
	
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
		WebfolderConfigVO result = ezWebFolderAdminDAO.getWebfolderConfig(map);
		
		if (result == null) {
			result = new WebfolderConfigVO();
			result.setCompanyId(companyId);
			result.setTenantId(tenantId);
			result.setTotalLimit("0");
			result.setUploadLimit("0");
		}
		
		return result;
	}

	@Override
	public List<UserCapacityVO> getListUserCapacity(String realColmn, String order, String companyId, String searchStr, String searchOpt, int startPoint, int pageSize, int tenantId, String primary) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("realColmn",  realColmn);
		map.put("order",      order);
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
	public List<FileLogVO> getListFileLogs(String realColmn, String order, String companyId, String searchChk, String startDate, String endDate, String fileExt, String fileName, String userName, String fileType, String actionType, int startPoint, int pageSize, String primary, String offset, int tenantId) throws Exception {
		logger.debug("Action Type: " + actionType);
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("realColmn",  realColmn);
		map.put("order",      order);
		map.put("companyId",  companyId);
		map.put("searchChk",  searchChk);
		map.put("startDate",  startDate);
		map.put("endDate",    endDate);
		map.put("fileExt",    fileExt);
		map.put("fileName",   fileName);
		map.put("fileType",   fileType);
		map.put("userName",   userName);
		map.put("actionType", actionType);
		map.put("startPoint", startPoint);
		map.put("pageSize",   pageSize);
		map.put("offset",     commonUtil.getMinuteUTC(offset));
		map.put("primary",    primary);
		map.put("tenantId",   tenantId);
		return ezWebFolderAdminDAO.getListFileLogs(map);
	}

	@Override
	public int getTotalFileLogs(String companyId, String searchChk, String startDate, String endDate, String fileExt, String fileName, String userName, String fileType, String actionType, String primary, int tenantId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("companyId",  companyId);
		map.put("searchChk",  searchChk);
		map.put("startDate",  startDate);
		map.put("actionType", actionType);
		map.put("endDate",    endDate);
		map.put("fileExt",    fileExt);
		map.put("fileName",   fileName);
		map.put("fileType",   fileType);
		map.put("userName",   userName);
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
		map.put("createDate",  folder.getCreateDate().substring(0, 19));
		map.put("createName1", folder.getCreateName1());
		map.put("createName2", folder.getCreateName2());
		map.put("updateId",    folder.getUpdateId());
		map.put("updateDate",  folder.getUpdateDate().substring(0, 19));
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
		map.put("createDate",  folder.getCreateDate().substring(0, 19));
		map.put("createName1", folder.getCreateName1());
		map.put("createName2", folder.getCreateName2());
		map.put("updateId",    folder.getUpdateId());
		map.put("updateDate",  folder.getUpdateDate().substring(0, 19));
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
		
		// TODO: 현재 query상에서 .S 형태로 돌아와서 해놓은것이지만 다른 형식으로 돌아올때에는 수정필요함.
		SimpleDateFormat formatter2 = new SimpleDateFormat("yyyy-MM-DD HH:mm:ss.S");						// db에서 가져온 folder의 timeUTC를 적용한 -9시간
	    Date date1 = formatter2.parse(folder.getCreateDate());												// folder의 creatreDate를 가져와서 date방식으로 format
	
	    SimpleDateFormat targetDateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");					// 우리가 지원하는 형식으로 다시 포맷
	    String timeUTCCreate	   = commonUtil.getDateStringInUTC(targetDateFormat.format(date1), offset, true);	// timeUTC 적용
		
		folder.setFolderName1(folderName);
		folder.setFolderName2(folderName2);
		folder.setUpdateId(userId);
		folder.setTenantId(tenantId);
		folder.setUpdateDate(timeUTC);
		folder.setCreateDate(timeUTCCreate);
		
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
	
	public void updateSelectedDeptsForChief(List<String> deptsList, LoginVO userInfo) throws Exception {
		int tenantId               = userInfo.getTenantId();
		String userId              = userInfo.getId();
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Date date                  = new Date();
		String timeUTC             = commonUtil.getDateStringInUTC(formatter.format(date), userInfo.getOffset(), true);
		
		//Delete all folder users
		deleteFolderUsersOfChief(userId, tenantId);
		
		if (deptsList != null && deptsList.size() > 0) {
			//Add new dept list
			for (String deptId : deptsList) {
				logger.debug("deptId: " + deptId);
				FolderVO folderVO = ezWebFolderService.getRootFolderId(deptId, "D", userInfo.getOffset(), tenantId);
						
				if (folderVO == null) {
					OrganDeptVO dept = ezOrganService.getDeptInfo(deptId, userInfo.getPrimary(), tenantId);
					folderVO         = new FolderVO();
					String folderId  = getMaxFolderID(tenantId);
					
					folderVO.setFolderId(folderId);
					folderVO.setFolderLevel(0);
					folderVO.setFolderName1(dept.getDisplayName1());
					folderVO.setFolderName2(dept.getDisplayName2());
					folderVO.setFolderPath("|" + folderId + "|");
					folderVO.setFolderStep(0);
					folderVO.setFolderType("D");
					folderVO.setFolderUpper("root");
					folderVO.setOwnerId(deptId);
					folderVO.setUseStatus("Y");
					folderVO.setUpdateId(userId);
					folderVO.setCreateName1(userInfo.getDisplayName1());
					folderVO.setCreateName2(userInfo.getDisplayName2());
					folderVO.setTenantId(tenantId);
					folderVO.setCompanyId(dept.getExtensionAttribute2());
					folderVO.setCreateId(userId);
					folderVO.setCreateDate(timeUTC);
					folderVO.setUpdateDate(timeUTC);
					
					//Insert folder
					insertFolder(folderVO);
					insertFolderUser(getMaxFolderUserSeq(tenantId), dept.getCn(), "dept", folderId, userId, timeUTC, folderVO.getCompanyId(), tenantId);
				}
				
				insertFolderUser(getMaxFolderUserSeq(tenantId), userId, "chief", folderVO.getFolderId(), userId, timeUTC, folderVO.getCompanyId(), tenantId);
			}
		}
	}
	
	@Override
	public void moveCompanyFolder(FolderVO folder, FolderVO destFolder, String mode, String realPath, LoginVO userInfo) throws Exception {
		if (mode.equals("move")) {
			moveFolder(folder, destFolder, userInfo.getId(), userInfo.getOffset(), userInfo.getTenantId());
		}
		else {
			copyFolder(folder, destFolder, realPath, userInfo);
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
	
	private void moveFolder(FolderVO folder, FolderVO parentFolder, String userId, String offset, int tenantId) throws Exception {
		String oldPath             = folder.getFolderPath();
		String newPath             = parentFolder.getFolderPath() + folder.getFolderId() + "|";
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Date date                  = new Date();
		String timeUTC             = commonUtil.getDateStringInUTC(formatter.format(date), offset, true);		//updateDate위한 현재시간
		int levelDistance          = parentFolder.getFolderLevel() + 1 - folder.getFolderLevel();
		
		// TODO: 현재 query상에서 .S 형태로 돌아와서 해놓은것이지만 다른 형식으로 돌아올때에는 수정필요함.
		SimpleDateFormat formatter2 = new SimpleDateFormat("yyyy-MM-DD HH:mm:ss.S");						// db에서 가져온 folder의 timeUTC를 적용한 -9시간
	    Date date1 = formatter2.parse(folder.getCreateDate());												// folder의 creatreDate를 가져와서 date방식으로 format
	
	    SimpleDateFormat targetDateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");					// 우리가 지원하는 형식으로 다시 포맷
	    String timeUTCCreate	   = commonUtil.getDateStringInUTC(targetDateFormat.format(date1), offset, true);	// timeUTC 적용
		
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
		folder.setCreateDate(timeUTCCreate);
		folder.setUpdateDate(timeUTC);
		folder.setFolderUpper(parentFolder.getFolderId());
		folder.setFolderLevel(folder.getFolderLevel() + levelDistance);
		folder.setFolderStep(getMaxFolderStep(parentFolder.getFolderId(), tenantId));
		insertFolder(folder);
		
		//Update list sub folders
		moveListSubFolders(userId, parentFolder.getFolderType(), oldPath, newPath, timeUTC, parentFolder.getOwnerId(), levelDistance, tenantId);
	}
	
	private void moveListSubFolders(String userId, String folderType, String oldPath, String newPath, String timeUTC, String ownerId, int levelDistance, int tenantId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("userId",        userId);
		map.put("folderType",    folderType);
		map.put("oldPath",       oldPath);
		map.put("newPath",       newPath);
		map.put("updateTime",    timeUTC);
		map.put("ownerId",       ownerId);
		map.put("levelDistance", levelDistance);
		map.put("tenantId",      tenantId);
		
		ezWebFolderAdminDAO.moveListSubFolders(map);
	}

	private void copyFolder(FolderVO folder, FolderVO parentFolder, String realPath, LoginVO userInfo) throws Exception {
		String userId                = userInfo.getId();
		String offset                = userInfo.getOffset();
		int tenantId                 = userInfo.getTenantId();
		String folderId              = folder.getFolderId();
		//String oldPath               = folder.getFolderPath();
		String newId                 = getMaxFolderID(tenantId);
		String newPath               = parentFolder.getFolderPath() + newId + "|";
		SimpleDateFormat formatter   = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Date date                    = new Date();
		String timeUTC               = commonUtil.getDateStringInUTC(formatter.format(date), offset, true);
		int levelDistance            = parentFolder.getFolderLevel() + 1 - folder.getFolderLevel();
		
		if ((folder.getFolderLevel() + levelDistance == 1) && parentFolder.getFolderType().equals("C")) {
			String folderPath = folder.getFolderPath();
			folderPath        = folderPath.substring(1, folderPath.length() - 1);
			String ancestorId = folder.getFolderType().equals("C") ? folderPath.split("\\|")[1] : folderPath.split("\\|")[0];
			
			List<FolderUserVO> listUsers = ezWebFolderService.getFolderUsers(ancestorId, tenantId);
			
			for (FolderUserVO folderUser: listUsers) {
				insertFolderUser(getMaxFolderUserSeq(tenantId), folderUser.getUserId(), folderUser.getUserType(), newId, userId, timeUTC, folder.getCompanyId(), tenantId);
			}
		}
		
		folder.setFolderPath(newPath);
		folder.setOwnerId(parentFolder.getOwnerId());
		folder.setFolderType(parentFolder.getFolderType());
		folder.setCreateId(userId);
		folder.setCreateName1(userInfo.getDisplayName1());
		folder.setCreateName2(userInfo.getDisplayName2());
		folder.setUpdateId(userId);
		folder.setUpdateDate(timeUTC);
		folder.setCreateDate(timeUTC);
		folder.setFolderUpper(parentFolder.getFolderId());
		folder.setFolderLevel(folder.getFolderLevel() + levelDistance);
		folder.setFolderStep(getMaxFolderStep(parentFolder.getFolderId(), tenantId));
		folder.setFolderId(newId);
		
		//Create new folder
		insertFolder(folder);
		copyFile(folderId, newId, timeUTC, realPath, userInfo);
		
		//copy all sub folders
		copySubFolders(folderId, parentFolder.getFolderType(), newPath, timeUTC, parentFolder.getOwnerId(), levelDistance, realPath, userInfo);
	}


	private void copySubFolders(String folderId, String folderType, String newPath, String timeUTC, String ownerId, int levelDistance, String realPath, LoginVO userInfo) throws Exception {
		List<FolderVO> listSubFolder = ezWebFolderService.getAllSubFolders(folderId, userInfo.getOffset(), userInfo.getTenantId());
		
		if (listSubFolder != null && listSubFolder.size() > 0) {
			for (int i = 0; i < listSubFolder.size(); i++) {
				FolderVO subFld   = listSubFolder.get(i);
				String oldId      = subFld.getFolderId();
				String newSubId   = getMaxFolderID(userInfo.getTenantId());
				String folderPath = newPath + newSubId + "|";
				
				subFld.setFolderPath(folderPath);
				subFld.setFolderType(folderType);
				subFld.setOwnerId(ownerId);
				subFld.setCreateDate(timeUTC);
				subFld.setUpdateDate(timeUTC);
				subFld.setCreateId(userInfo.getId());
				subFld.setCreateName1(userInfo.getDisplayName1());
				subFld.setCreateName2(userInfo.getDisplayName2());
				subFld.setUpdateId(userInfo.getId());
				subFld.setFolderLevel(subFld.getFolderLevel() + levelDistance);
				subFld.setFolderId(newSubId);
				
				folderPath           = folderPath.substring(1, folderPath.length() - 1);
				String[] folderArry  = folderPath.split("\\|");
				String upperFolderId = folderArry[folderArry.length - 2];
				
				subFld.setFolderUpper(upperFolderId);
				
				//Create new folder
				insertFolder(subFld);
				copyFile(oldId, newSubId, timeUTC, realPath, userInfo);
				
				//copy all sub folders
				copySubFolders(oldId, folderType, subFld.getFolderPath(), timeUTC, ownerId, levelDistance, realPath, userInfo);
			}
		}
	}

	private void copyFile(String folderId, String newId, String timeUTC, String realPath, LoginVO userInfo) throws Exception {
		List<FileVO> fileList = ezWebFolderService.getAllFilesInFolder("", "", folderId, "", "0", "", "", "", "", "", "1", 0, 0, userInfo.getPrimary(), userInfo.getOffset(), userInfo.getTenantId());
		
		if (fileList != null && fileList.size() > 0) {
			for (FileVO file : fileList) {
				file.setDownloadCnt(0);
				file.setFolderId(newId);
				file.setCreateDate(timeUTC);
				file.setUpdateDate(timeUTC);
				file.setCreateId(userInfo.getId());
				file.setUpdateId(userInfo.getId());
				file.setCreateName1(userInfo.getDisplayName1());
				file.setCreateName2(userInfo.getDisplayName2());
				file.setFileId(ezWebFolderService.getMaxFileID(userInfo.getTenantId()));
				
				String fileName = file.getFileName();
				int dotPos      = fileName.lastIndexOf(".");
				String extend   = dotPos == -1 ? ".none" : fileName.substring(dotPos + 1);
				String newName  = UUID.randomUUID().toString() + "." + extend;
				String newPath  = ezWebFolderService.getWebFolderDirPath(userInfo.getTenantId()) + newName;
				File srcFile    = new File(realPath + file.getFilePath());
				File destFile   = new File(realPath  + newPath);
				destFile.getParentFile().mkdirs(); 
				destFile.createNewFile();
				
				FileUtils.copyFile(srcFile, destFile);
				
				file.setFilePath(newPath);
				ezWebFolderService.insertFile(file);
				ezWebFolderService.saveLog("CP", userInfo.getCompanyID(), userInfo.getOffset(), userInfo.getId(), userInfo.getDisplayName1(), userInfo.getDisplayName2(), file.getFileName(), file.getFileSize(), file.getFileExt(), file.getFileTypeName(), userInfo.getTenantId());
			}
		}
	}

	@Override
	public UserCapacityVO getUserCapacity(String userId, String lang, int tenantId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("userId",   userId);
		map.put("primary",  lang);
		map.put("tenantId", tenantId);
		return ezWebFolderAdminDAO.getUserCapacity(map);
	}

	@Override
	public String createExcelFileLogs(String realPath, String dirPath, List<FileLogVO> listFileLogs, String primary, Locale locale) throws Exception {
		Date date                  = new Date();
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
		String fileName            = egovMessageSource.getMessage("ezWebFolder.t128", locale) + "_" + formatter.format(date) + ".xlsx";
		String filePath            = dirPath + fileName;
		File file                  = new File(dirPath);
		File file2                 = new File(filePath);
		
		if (file == null || !file.exists()) {
			file.mkdir();
		}
		else {
			FileUtils.cleanDirectory(file); 
		}
		
		
		if (file2.exists()) {
			int pos         = fileName.lastIndexOf(".");
			String extend   = fileName.substring(pos + 1);
			String mainName = fileName.substring(0, pos);
			int k           = 1;
			fileName        = mainName + "(" + Integer.toString(k) + ")." + extend;
			filePath        = dirPath + fileName;
			file2           = new File(filePath);
			
			while (file2.exists()) {
				fileName = mainName + "(" + Integer.toString(++k) + ")." + extend;
				filePath = dirPath + fileName;
			}
		}
		
		FileOutputStream fileOut = null;
		Workbook workbook = new XSSFWorkbook();
		
		Sheet sheet1 = workbook.createSheet(egovMessageSource.getMessage("ezWebFolder.t128", locale));
		sheet1.setDefaultRowHeight((short)500);
		
		//Set style
		CellStyle centerStyle = workbook.createCellStyle();
		centerStyle.setWrapText(false);
		centerStyle.setAlignment(CellStyle.ALIGN_CENTER);
		centerStyle.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
		
		CellStyle centerStyle2 = workbook.createCellStyle();
		centerStyle2.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
		
		CellStyle centerStyle3 = workbook.createCellStyle();
		centerStyle3.setAlignment(CellStyle.ALIGN_LEFT);
		centerStyle3.setIndention((short)3);
		centerStyle3.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
		
		//sheet1.setColumnWidth(0, 8 * 256);
		
		//Process first row
		Row rowhead1 = sheet1.createRow(0);
		
		rowhead1.createCell(0).setCellValue(egovMessageSource.getMessage("ezWebFolder.t188", locale));
		rowhead1.createCell(1).setCellValue(egovMessageSource.getMessage("ezWebFolder.t156", locale));
		rowhead1.createCell(2).setCellValue(egovMessageSource.getMessage("ezWebFolder.t157", locale));
		rowhead1.createCell(3).setCellValue(egovMessageSource.getMessage("ezWebFolder.t154", locale));
		rowhead1.createCell(4).setCellValue(egovMessageSource.getMessage("ezWebFolder.t158", locale));
		rowhead1.createCell(5).setCellValue(egovMessageSource.getMessage("ezWebFolder.t159", locale));
		
		rowhead1.getCell(0).setCellStyle(centerStyle);
		rowhead1.getCell(1).setCellStyle(centerStyle2);
		rowhead1.getCell(2).setCellStyle(centerStyle);
		rowhead1.getCell(3).setCellStyle(centerStyle2);
		rowhead1.getCell(4).setCellStyle(centerStyle2);
		rowhead1.getCell(5).setCellStyle(centerStyle2);
		
		int i = 1;
		
		for (FileLogVO fileLog : listFileLogs) {
			Row newRow1 = sheet1.createRow(i);
			
			newRow1.createCell(0).setCellValue(fileLog.getFileExt());
			drawPictureInExcel(workbook, sheet1, realPath + fileLog.getFileType(), 0, i);
			newRow1.createCell(1).setCellValue(fileLog.getFileName());
			newRow1.createCell(2).setCellValue(formatFileSize(fileLog.getFileSize()));
			newRow1.createCell(3).setCellValue(primary.equals("1") ? fileLog.getCreateName1() : fileLog.getCreateName2());
			
			switch(fileLog.getLogType()) {
				case "C" : newRow1.createCell(4).setCellValue(egovMessageSource.getMessage("ezWebFolder.t160", locale)); break;
				case "D" : newRow1.createCell(4).setCellValue(egovMessageSource.getMessage("ezWebFolder.t161", locale)); break;
				case "U" : newRow1.createCell(4).setCellValue(egovMessageSource.getMessage("ezWebFolder.t162", locale)); break;
				case "R" : newRow1.createCell(4).setCellValue(egovMessageSource.getMessage("ezWebFolder.t111", locale)); break;
				case "P" : newRow1.createCell(4).setCellValue(egovMessageSource.getMessage("ezWebFolder.t19",  locale)); break;
				case "RE": newRow1.createCell(4).setCellValue(egovMessageSource.getMessage("ezWebFolder.t287", locale)); break;
				case "MV": newRow1.createCell(4).setCellValue(egovMessageSource.getMessage("ezWebFolder.t121", locale)); break;
				case "CP": newRow1.createCell(4).setCellValue(egovMessageSource.getMessage("ezWebFolder.t122", locale)); break;
				case "WR": newRow1.createCell(4).setCellValue(egovMessageSource.getMessage("ezWebFolder.t506", locale)); break;
			}
			
			newRow1.createCell(5).setCellValue(fileLog.getCreateDate().substring(0, 19));
			
			newRow1.getCell(0).setCellStyle(centerStyle3);
			newRow1.getCell(1).setCellStyle(centerStyle2);
			newRow1.getCell(2).setCellStyle(centerStyle);
			newRow1.getCell(3).setCellStyle(centerStyle2);
			newRow1.getCell(4).setCellStyle(centerStyle2);
			newRow1.getCell(5).setCellStyle(centerStyle2);
			
			i++;
		}
		
		sheet1.autoSizeColumn(0);
		sheet1.setColumnWidth(0, sheet1.getColumnWidth(0) + 200);
		sheet1.autoSizeColumn(1);
		sheet1.setColumnWidth(2, ((int)(10 * 1.14388)) * 256);
		sheet1.setColumnWidth(3, ((int)(30 * 1.14388)) * 256);
		sheet1.setColumnWidth(4, ((int)(20 * 1.14388)) * 256);
		sheet1.setColumnWidth(5, ((int)(22 * 1.14388)) * 256);
		
		try {
			fileOut = new FileOutputStream(filePath);
			workbook.write(fileOut);
			fileOut.close();
		}
		catch (Exception e) {
			throw e;
		}
		finally {
			fileOut.close();
			workbook.close();
		}
		
		return fileName;
	}
	
	private void drawPictureInExcel(Workbook workbook, Sheet sheet1, String picturePath, int colNum, int rowNum) throws Exception {
		InputStream inputStream = new FileInputStream(picturePath);
		byte[] imageBytes       = IOUtils.toByteArray(inputStream);
		int pictureureIdx       = workbook.addPicture(imageBytes, Workbook.PICTURE_TYPE_PNG);
		inputStream.close();
		
		CreationHelper helper   = workbook.getCreationHelper();
		Drawing drawing         = sheet1.createDrawingPatriarch();
		ClientAnchor anchor     = helper.createClientAnchor();
		
		anchor.setCol1(colNum);
		anchor.setRow1(rowNum);
		anchor.setRow2(rowNum);
		anchor.setCol2(colNum );
		
		anchor.setDx1(Units.toEMU(5));
		anchor.setDy1(Units.toEMU(5));
		anchor.setDx2(Units.toEMU(19));
		anchor.setDy2(Units.toEMU(21));
		anchor.setAnchorType(AnchorType.MOVE_AND_RESIZE);
		
		drawing.createPicture(anchor, pictureureIdx);
	}
	
	private String formatFileSize(double fileSize) {
		String _fileSize = "";
		
		if (fileSize / 1024 / 1024 / 1024 >= 1) {
			_fileSize = String.format("%.2f", (double)(fileSize / 1024 / 1024 * 10) / 10);
			_fileSize = _fileSize + "GB";
		}
		else if (fileSize / 1024 / 1024 >= 1) {
			_fileSize = String.format("%.2f", (double)(fileSize / 1024 / 1024 * 10) / 10);
			_fileSize = _fileSize + "MB";
		}
		else if (fileSize / 1024 >= 1) {
			_fileSize = String.format("%.2f", (double)(fileSize / 1024));
			_fileSize = _fileSize + "KB";
		}
		else {
			_fileSize = Double.toString(fileSize) + "B";
		}
		
		return _fileSize;
	}

	@Override
	public void getExcelFile(String fileName, String realPath, String userAgent, HttpServletResponse response, int tenantId) throws Exception {
		String _fileName = CommonUtil.getEncodedFileNameForDownload(userAgent, fileName);
		String dirPath   = ezWebFolderService.getWebFolderDirPath(tenantId);
		dirPath          = realPath + dirPath + "temp" + commonUtil.separator;
		File file        = new File(dirPath + fileName);
		
		if (!file.exists()) {
			throw new FileNotFoundException(fileName);
		}
	
		if (!file.isFile()) {
			throw new FileNotFoundException(fileName);
		}
		
		BufferedInputStream in = null;
		
		try {
			in              = new BufferedInputStream(new FileInputStream(file));
			String mimetype = "application/octet-stream";
			
			response.setBufferSize(BUFF_SIZE);
			response.setContentType(mimetype);
			response.setHeader("Content-Disposition", "attachment; filename=\"" + _fileName + "\"");
			response.setContentLength((int)file.length());
			
			FileCopyUtils.copy(in, response.getOutputStream());
		}
		finally {
			if (in != null) {
				try {
					in.close();
				} catch (Exception ignore) {
					logger.debug("IGNORED: {}", ignore.getMessage());
				}
			}
			
			try {
				file = new File(dirPath + fileName);
				file.delete();
			}
			catch (Exception e) {
				e.printStackTrace();
			}
		}
		
	}

	@Override
	public double getFolderSize(String folderPath, int tenantId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("folderPath",  folderPath);
		map.put("tenantId", tenantId);
		return ezWebFolderAdminDAO.getFolderSize(map);
	}

}
