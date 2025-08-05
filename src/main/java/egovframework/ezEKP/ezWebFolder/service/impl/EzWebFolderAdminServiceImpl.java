package egovframework.ezEKP.ezWebFolder.service.impl;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Properties;
import java.util.function.BiConsumer;
import java.util.function.Consumer;

import javax.annotation.Resource;
import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.io.FileUtils;
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
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.FileCopyUtils;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.service.EzFileMngUtil;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.ezEKP.ezOrgan.vo.OrganDeptVO;
import egovframework.ezEKP.ezWebFolder.dao.EzWebFolderAdminDAO;
import egovframework.ezEKP.ezWebFolder.dao.EzWebFolderDAO_y;
import egovframework.ezEKP.ezWebFolder.service.EzWebFolderAdminService;
import egovframework.ezEKP.ezWebFolder.service.EzWebFolderService;
import egovframework.ezEKP.ezWebFolder.service.EzWebFolderService_y;
import egovframework.ezEKP.ezWebFolder.util.EzWebfolderUtil;
import egovframework.ezEKP.ezWebFolder.vo.DuplicateInfoVO;
import egovframework.ezEKP.ezWebFolder.vo.DuplicateInfoVO.Type;
import egovframework.ezEKP.ezWebFolder.vo.FileLogVO;
import egovframework.ezEKP.ezWebFolder.vo.FileVO;
import egovframework.ezEKP.ezWebFolder.vo.FolderSimpleVO;
import egovframework.ezEKP.ezWebFolder.vo.FolderVO;
import egovframework.ezEKP.ezWebFolder.vo.UserCapacityVO;
import egovframework.ezEKP.ezWebFolder.vo.WebfolderConfigVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.fcc.service.KlibUtil;

@Service("EzWebFolderAdminService")
public class EzWebFolderAdminServiceImpl extends EzFileMngUtil implements EzWebFolderAdminService {
	@Resource(name = "EzWebFolderAdminDAO")
	private EzWebFolderAdminDAO ezWebFolderAdminDAO;
	
	@Autowired
	private Properties globals;
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private EzWebFolderService ezWebFolderService;
	
	@Autowired
	private EzWebFolderService_y ezWebFolderService_y;
	
	@Autowired
	private EzWebFolderDAO_y ezWebfolderDao_y;
	
	@Autowired
	private EzOrganService ezOrganService;
	
	@Autowired
	private EzWebfolderUtil webfolderUtil;

	@Autowired
	private KlibUtil klibUtil;

	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;
	
	@Autowired
	private EzCommonService ezCommonService;

	@Autowired
	private ServletContext servletContext;

	private static final Logger logger = LoggerFactory.getLogger(EzWebFolderAdminServiceImpl.class);
	
	@Override
	public void saveConfig(String companyLimit, String departmentLimit, String userLimit, String uploadLimit, String companyId, int tenantId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("companyLimit", emptyToNull(companyLimit));
		map.put("departmentLimit", emptyToNull(departmentLimit));
		map.put("userLimit", emptyToNull(userLimit));
		map.put("uploadLimit", emptyToNull(uploadLimit));
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);

		if (!companyId.equals("*")) {
			checkExistCompany(map);
		}

		ezWebFolderAdminDAO.saveConfig(map);
	}

	private String emptyToNull(String str) {
		if (str == null) {
			return null;
		}

		if (str.isEmpty()) {
			return null;
		}

		return str;
	}
	
	@Override
	public WebfolderConfigVO getEveryCompanyConfig(int tenantId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("tenantId",  tenantId);

		WebfolderConfigVO result = ezWebFolderAdminDAO.getEveryCompanyConfig(map);

		if (result == null) {
			map.put("companyLimit", "1");
			map.put("departmentLimit", "1");
			map.put("userLimit", "1");
			map.put("uploadLimit", "1");
			map.put("companyId", "*");

			ezWebFolderAdminDAO.saveConfig(map);

			return ezWebFolderAdminDAO.getEveryCompanyConfig(map);
		}

		return result;
	}

	@Override
	public WebfolderConfigVO getWebfolderConfig(String companyId, int tenantId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("companyId", companyId);
		map.put("tenantId",  tenantId);

		checkExistCompany(map);
		WebfolderConfigVO result = ezWebFolderAdminDAO.getWebfolderConfig(map);
		
		if (result == null) {
			Map<String, Object> everyMap = new HashMap<>();
			everyMap.put("companyLimit", "1");
			everyMap.put("departmentLimit", "1");
			everyMap.put("userLimit", "1");
			everyMap.put("uploadLimit", "1");
			everyMap.put("companyId", "*");
			everyMap.put("tenantId", tenantId);

			ezWebFolderAdminDAO.saveConfig(everyMap);

			return ezWebFolderAdminDAO.getWebfolderConfig(map);
		}
		
		return result;
	}

	private void checkExistCompany(Map<String, Object> map) throws Exception {
		if (ezWebFolderAdminDAO.existCompany(map) == 0) {
			throw new IllegalArgumentException("non existent company ID: " + map);
		}
	}

//	@Override
//	public List<CapacityVO> getListUserCapacity(String realColmn, String order, String companyId, String searchStr, String searchOpt, int startPoint, int pageSize, int tenantId, String primary) throws Exception {
//		Map<String,Object> map = new HashMap<String, Object>();
//		map.put("realColmn",  realColmn);
//		map.put("order",      order);
//		map.put("companyId",  companyId);
//		map.put("searchStr",  searchStr);
//		map.put("searchOpt",  searchOpt);
//		map.put("startPoint", startPoint);
//		map.put("pageSize",   pageSize);
//		map.put("tenantId",   tenantId);
//		map.put("primary",    primary);
//		return ezWebFolderAdminDAO.getListUserCapacity(map);
//	}
//
//	@Override
//	public int getTotalListUserCapacity(String companyId, String searchStr, String searchOpt, int startPoint, int pageSize, int tenantId, String primary) throws Exception {
//		Map<String,Object> map = new HashMap<String, Object>();
//		map.put("companyId",  companyId);
//		map.put("searchStr",  searchStr);
//		map.put("searchOpt",  searchOpt);
//		map.put("startPoint", startPoint);
//		map.put("pageSize",   pageSize);
//		map.put("tenantId",   tenantId);
//		map.put("primary",    primary);
//		return ezWebFolderAdminDAO.getTotalListUserCapacity(map);
//	}
//
//	@Override
//	public void updateNewAmount(List<String> targetList, String type, String newStorageValue, String companyId, int tenantId) throws Exception {
//		Map<String,Object> map = new HashMap<String, Object>();
//		map.put("type", type);
//		map.put("totalCapacity", newStorageValue);
//		map.put("companyId", companyId);
//		map.put("tenantId", tenantId);
//		
//		for (String targetId : targetList) {
//			map.put("targetId", targetId);
//			ezWebFolderAdminDAO.updateNewAmount(map);
//		}
//	}

	@Override
	public List<FileLogVO> getListFileLogs(String realColmn, String order, String companyId, String searchChk, 
			String startDate, String endDate, String fileExt, String fileName, String userName, String fileType, 
			String actionType, int startPoint, int pageSize, String primary, String offset, int tenantId, String sortType, 
			String sortColumn, String folderId, String adminFlag) throws Exception {
		logger.debug("getListFileLogs start");
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
		map.put("sortType",   sortType);
		map.put("sortColumn", sortColumn);
		map.put("orderByData", sortColumn + " " + sortType);
		map.put("adminFlag",  adminFlag);
		map.put("folderId",   folderId);
		
		logger.debug("getListFileLogs end");
		return ezWebFolderAdminDAO.getListFileLogs(map);
	}

	@Override
	public int getTotalFileLogs(String companyId, String searchChk, String startDate, String endDate, String fileExt, String fileName, String userName, 
			String fileType, String actionType, String primary, int tenantId, String folderId, String adminFlag) throws Exception {
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
		map.put("adminFlag",  adminFlag);
		map.put("folderId",   folderId);
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
		map.put("fileId",    		fileLog.getFileId());
		map.put("version",    		fileLog.getVersion());
		map.put("folderId",    		fileLog.getFolderId());
		map.put("folderName",   	fileLog.getFolderName());
		map.put("folderPath",   	fileLog.getFolderPath());
		map.put("folderPathName",   fileLog.getFolderPathName());
		map.put("topFolderId",    	fileLog.getTopFolderId());
		map.put("topFolderName",    fileLog.getTopFolderName());
		ezWebFolderAdminDAO.insertFileLog(map);
	}

	@Override
	public int insertFolder(FolderVO folder) throws Exception {
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
		
		int folderId = 0;
		if (folder.getFolderId().isEmpty()){
			folderId = ezWebFolderAdminDAO.insertFolder(map);
			map.put("newFolderId", folderId);
			if (folder.getFolderLevel() == 0){
				map.put("folderPath", "|" + folderId + "|");
			}
		} else {
			folderId = ezWebFolderAdminDAO.updateFolder(map);
		}
		ezWebfolderDao_y.updateFolderPath(map);
		return folderId;
	}

	@Override
	public int insertFolder2(FolderVO folder) throws Exception {
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
		
		int folderId = 0;
		if (folder.getFolderId().isEmpty()){
			folderId = ezWebFolderAdminDAO.insertFolder2(map);
			map.put("newFolderId", folderId);
			if (folder.getFolderLevel() == 0){
				map.put("folderPath", "|" + folderId + "|");
			}
		} else {
			folderId = ezWebFolderAdminDAO.updateFolder2(map);
		}
		ezWebfolderDao_y.updateFolderPath(map);
		
		return folderId;
	}

	@Override
	public void insertFolderUser(String seq, String userId, String userType, String folderId, String createId, String createDate, String companyId, int tenantId) throws Exception {
		insertFolderUser(seq, userId, userType, folderId, createId, createDate, companyId, tenantId, false, false);
	}
	
	@Override
	public void insertFolderUser(String seq, String userId, String userType, String folderId, String createId, String createDate, String companyId, int tenantId, Boolean subdeptPermitted, Boolean folderManager) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("seqId",      seq);
		map.put("userId",     userId);
		map.put("userType",   userType);
		map.put("folderId",   folderId);
		map.put("createId",   createId);
		map.put("createDate", createDate);
		map.put("companyId",  companyId);
		map.put("tenantId",   tenantId);
		map.put("subdeptPermitted", subdeptPermitted? 1 : 0 );
		map.put("folderManager", folderManager? 1 : 0 );
		ezWebFolderAdminDAO.insertFolderUser(map);
	}
	
	// 상위의 폴더, 파일의 권한을 그대로 상속 할 수 있도록 하는 로직/ 만약 copy_type=copy이면 선택된 파일의 권한을 그대로 상속 
	@Override
	public void insertFolderUser(Map<String, Object> map) throws Exception {
		ezWebFolderAdminDAO.insertFolderUserSeq(map);
	}

	@Override
	public void deleteFolderUsers(String folderId, int tenantId, String folderManager) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("folderId", folderId);
		map.put("tenantId", tenantId);
		map.put("folderManager", folderManager);
		ezWebFolderAdminDAO.deleteFolderUsers(map);
	}

	@Override
	public void deleteFolderUsersOfChief(String userId, int tenantId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("userId",   userId);
		map.put("tenantId", tenantId);
		ezWebFolderAdminDAO.deleteFolderUsersOfChief(map);
	}

	@Override
	public void insertListFolderUsers(String userId, String folderId, String companyId, String folderUsers, String timeUTC
			, int tenantId, String type, List<String> addUser, String subFolderType, String folderPath, List<String> addUserManager, String offset) throws Exception {
		JSONParser parser          = new JSONParser();
//		JSONObject json            = (JSONObject) parser.parse(folderUsers);
//		JSONArray userArray        = (JSONArray)json.get("user");
//		JSONArray deptArray        = (JSONArray)json.get("dept");
//		
//		if (userArray != null && userArray.size() > 0) {
//			for (int i = 0; i < userArray.size(); i++) {
//				insertFolderUser(getMaxFolderUserSeq(tenantId), (String)userArray.get(i), "user", folderId, userId, timeUTC, companyId, tenantId);
//			}
//		}
//		
//		if (deptArray != null && deptArray.size() > 0) {
//			for (int i = 0; i < deptArray.size(); i++) {
//				insertFolderUser(getMaxFolderUserSeq(tenantId), (String)deptArray.get(i), "dept", folderId, userId, timeUTC, companyId, tenantId);
//			}
//		}
		folderUsers.replace("\\", "");
		if (folderUsers.substring(0,1).equals("\"")){
			folderUsers = folderUsers.substring(1, folderUsers.length()-1);
		}
		JSONArray folderUsersArray = (JSONArray) parser.parse(folderUsers);
		
		if (folderUsersArray != null && folderUsersArray.size() > 0 ) {
			if(type.equalsIgnoreCase("insert")){
				for (int i = 0; i < folderUsersArray.size(); i++) {
					JSONObject json    = (JSONObject) folderUsersArray.get(i);
					insertFolderUser(getMaxFolderUserSeq(tenantId), (String)json.get("userId"), (String)json.get("userType"), folderId, userId, timeUTC, companyId, tenantId, (Boolean)json.get("subdeptPermitted"), (Boolean)json.get("folderManager"));
				}
			} else {
				List<FolderSimpleVO> subAllFolderInfo = new ArrayList<FolderSimpleVO>();
				logger.debug("subAllFolderInfo=" + subAllFolderInfo);
				String folderIdTemp = folderId;
				
				if (subFolderType.equals("1")){
					subAllFolderInfo = selectSubAllFolder(folderPath, tenantId);
				} else {
					FolderSimpleVO temp = new FolderSimpleVO();
					temp.setFolderId(folderIdTemp);
					subAllFolderInfo.add(temp);
				}
				
				logger.debug("subAllFolderInfo=" + subAllFolderInfo);
				
				for(int j=0; j<subAllFolderInfo.size(); j++){
					folderIdTemp = subAllFolderInfo.get(j).getFolderId();
					
					for(int i=0; i<folderUsersArray.size(); i++){
						try {
							JSONObject json    = (JSONObject) folderUsersArray.get(i);
									// addUserManager(담당자 목록)이 있다는 건 1레벨이긴 함.
							if( ( addUserManager.size() > 0 
									// 이 폴더가 1레벨이 맞는지
									&& ( !subFolderType.equals("1") || subAllFolderInfo.get(j).getFolderLevel() == 1 )
									// addUserManager(담당자 목록에 있으면서) + folderManager(1) 담당자가 맞는지
									&& ( addUserManager.contains(json.get("userId").toString()) && (Boolean)json.get("folderManager") )
									
									// addUser(구성원 목록에 있으면서) + folderManager(0) 구성원이 맞는지
								 )	|| ( addUser.size() > 0 && addUser.contains(json.get("userId").toString()) && !(Boolean)json.get("folderManager") ) 
							 ){
								
								
								if(ezWebFolderService.checkFolderUserExists((String)json.get("userId"), folderIdTemp, (Boolean)json.get("folderManager")) == 0){
									insertFolderUser(getMaxFolderUserSeq(tenantId), (String)json.get("userId"), (String)json.get("userType"), folderIdTemp, userId, timeUTC, companyId, tenantId, (Boolean)json.get("subdeptPermitted"), (Boolean)json.get("folderManager"));
								}
							}
						} catch (Exception e) {
							logger.debug("exists userId, so next userInsert.");
							logger.error(e.getMessage(), e);
							continue;
						}
					}
				}
				
				if(addUser.size()>0 && subFolderType.equals("1")) {
					ezWebFolderService_y.addFileUserCurrFolder(folderId, offset, tenantId, folderUsers, (ArrayList<String>) addUser, subFolderType);
				}
			}
		}
	}
	
	@Override
	public List<FolderSimpleVO> selectSubAllFolder(String folderPath, int tenantId) throws Exception{
		List<FolderSimpleVO> result = new ArrayList<FolderSimpleVO>();
		Map<String, Object> map = new HashMap<>();
		map.put("folderPath", folderPath + "%");
		map.put("tenantId", tenantId);
		result = ezWebFolderAdminDAO.selectSubAllFolder(map);
		return result;
	}

	@Override
	public Map<String, Object> addCompanyFolder(String pFolderId, String folderUsers, String folderName, String folderName2,
			LoginVO userInfo) throws Exception {
		Map<String, Object> result = new HashMap<>();
		String offset              = userInfo.getOffset();
		int tenantId               = userInfo.getTenantId();
		List<DuplicateInfoVO> duplicateList = ezWebFolderService.getAllDuplicateInfo(folderName, pFolderId, offset, tenantId);
		
		// 중복 정보가 있으면 바로 리턴
		if (duplicateList.size() > 0) {
			result.put("status", "ok");
			result.put("code", 8);
			result.put("duplicateInfoArray", duplicateList);
			return result;
		}
		
		String userName1           = userInfo.getDisplayName1();
		String userName2           = userInfo.getDisplayName2();
		String userId              = userInfo.getId();
		FolderVO parentFolder      = ezWebFolderService.getFolderByFolderId(pFolderId, offset, tenantId);
		FolderVO folder            = new FolderVO();
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Date date                  = new Date();
		String timeUTC             = commonUtil.getDateStringInUTC(formatter.format(date), offset, true);
		String folderId            = getMaxFolderID(userInfo.getTenantId());
		int newFolderLevel = parentFolder.getFolderLevel() + 1;

//		ezWebFolderService.insertEncryptionFolder(folderId, tenantId);
		
		folder.setFolderId(folderId);
		folder.setFolderLevel(newFolderLevel);
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
		int folderIdInt = insertFolder(folder);
		folderId = Integer.toString(folderIdInt);
		
		//Insert new folder users
		insertListFolderUsers(userId, folderId, folder.getCompanyId(), folderUsers, timeUTC, tenantId, "insert", null, "", "", null, offset);
		
		result.put("status", "ok");
		result.put("code", 0);

		return result;
	}
	
	@Override
	public Map<String, Object> updateCompanyFolder(String userId, String folderId, String folderUsers, String folderName 
			, String folderName2, String offset, int tenantId, ArrayList<String> addUser, ArrayList<String> deleteUser
			, String subFolderType, LoginVO userInfo, ArrayList<String> addUserManager, ArrayList<String> deleteUserManager
			, boolean encryption) throws Exception {
		Map<String, Object> result = new HashMap<>();
		List<DuplicateInfoVO> duplicateList = new ArrayList<>();
		FolderVO folder            = ezWebFolderService.getFolderByFolderId(folderId, offset, tenantId);
		
		if (folder.getFolderLevel() == 0) {
			logger.debug("folder level 0 is the root folder, so it only processeds with klib encryption flag update");
			return result;
		}

		if (duplicateList.addAll(ezWebFolderService.getAllDuplicateInfo(folderName, folder.getFolderUpper(), offset, tenantId))) {
			if (duplicateList.size() == 1 && duplicateList.get(0).getOldId().equals(folderId)) {
				duplicateList.clear();
			} else {
				result.put("status", "ok");
				result.put("code", 8);
				result.put("duplicateInfoArray", duplicateList);
				return result;
			}
		}

//		String folderPath          = folder.getFolderPath();
//		folderPath                 = folderPath.substring(1, folderPath.length() - 1);
//		String ancestorId          = folderPath.split("\\|")[1];
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Date date                  = new Date();
		String timeUTC             = commonUtil.getDateStringInUTC(formatter.format(date), offset, true);
		
		Date date1 = new Date();
		String createDate = "";
		
		if (folder.getCreateDate().contains(".0")){
			// TODO: 현재 query상에서 .S 형태로 돌아와서 해놓은것이지만 다른 형식으로 돌아올때에는 수정필요함.
			SimpleDateFormat formatter2 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.S");						// db에서 가져온 folder의 timeUTC를 적용한 -9시간
			date1 = formatter2.parse(folder.getCreateDate());																							// folder의 creatreDate를 가져와서 date방식으로 format
			logger.debug("date1:"+date1 + ",folderCreateDate:"+folder.getCreateDate());
			
			SimpleDateFormat targetDateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");					// 우리가 지원하는 형식으로 다시 포맷
			createDate = targetDateFormat.format(date1);
		} else {
			createDate = folder.getCreateDate();
		}
	
	    String timeUTCCreate	   = commonUtil.getDateStringInUTC(createDate, offset, true);	// timeUTC 적용
		
		folder.setFolderName1(folderName);
		folder.setFolderName2(folderName2);
		folder.setUpdateId(userId);
		folder.setTenantId(tenantId);
		folder.setUpdateDate(timeUTC);
		folder.setCreateDate(timeUTCCreate);
		
		insertFolder(folder);
		
		if(addUserManager.size() > 0 || addUser.size() > 0){
			insertListFolderUsers(userId, folderId, folder.getCompanyId(), folderUsers, timeUTC, tenantId, "update", addUser, subFolderType, folder.getFolderPath(), addUserManager, offset);
		}
		
		// 2020-12-09 김은실 - (카이스트)회사 폴더별 관리자 지원 기능
		if (deleteUserManager.size() > 0){
			deleteSelectedFolderUser(folder.getFolderPath(), deleteUserManager, tenantId, 1);
		}
		
		if (deleteUser.size() > 0){
			deleteSelectedFolderUser(folder.getFolderPath(), deleteUser, tenantId, 0);
			JSONObject param = new JSONObject();
			param.put("folderId", folderId);
			param.put("tenantId", tenantId);
			param.put("subFolderType", subFolderType);
			param.put("folderPath", folder.getFolderPath());
			List<FileVO> fileList = folderInFileList(param);
			
			for(int i=0; i<fileList.size(); i++){
				deleteSelectedFileUser(deleteUser, tenantId, fileList.get(i).getFileId());
			}
		}
		
		// 회의실 생성시 자동으로 암호화 들어가므로 주석처리함
		/* boolean useKlib = "yes".equalsIgnoreCase(ezCommonService.getTenantConfig("useWebfolderKlib", tenantId));
		boolean requireUpdateEncryption = useKlib && (encryption ^ ezWebFolderService.isEncryptionFolder(folderId, tenantId));

		if (requireUpdateEncryption) {
			if (encryption) {
				ezWebFolderService.insertEncryptionFolder(folderId, tenantId);
			} else {
				ezWebFolderService.deleteEncryptionFolder(folderId, tenantId);
			}
		} */

		result.put("status", "ok");
		result.put("code", 0);

		return result;
	}

	@Override
	public void deleteSelectedFolderUser(String folderPath, List<String> userIdList, int tenantId, int folderManger) throws Exception{
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("folderPath", folderPath + "%");
		map.put("idList", userIdList);
		map.put("tenantId", tenantId);
		map.put("folderManger", folderManger);
		ezWebFolderAdminDAO.deleteSelectedFolderUser(map);
	}
	
	@Override
	public void deleteSelectedFileUser(List<String> userIdList, int tenantId, String fileId) throws Exception{
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("idList", userIdList);
		map.put("tenantId", tenantId);
		map.put("fileId", fileId);
		logger.debug("map:{}" ,map );
		ezWebFolderAdminDAO.deleteSelectedFileUser(map);
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
			
			int folderIdInt = insertFolder2(folder);
			folderId = Integer.toString(folderIdInt);
			
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
		
		int folderIdInt = insertFolder(folder);
		folderId = Integer.toString(folderIdInt);
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
					int folderIdInt = insertFolder(folderVO);
					folderId = Integer.toString(folderIdInt);
					
					insertFolderUser(getMaxFolderUserSeq(tenantId), dept.getCn(), "dept", folderId, userId, timeUTC, folderVO.getCompanyId(), tenantId);
				}
				
				insertFolderUser(getMaxFolderUserSeq(tenantId), userId, "chief", folderVO.getFolderId(), userId, timeUTC, folderVO.getCompanyId(), tenantId);
			}
		}
	}
	
	@Override
	public List<DuplicateInfoVO> moveCompanyFolder(FolderVO folder, FolderVO destFolder, String mode, String realPath, LoginVO userInfo, String userCheck) throws Exception {
		if (mode.equals("move")) {
			return moveFolder(folder, destFolder, userInfo.getId(), userInfo.getOffset(), userInfo.getTenantId());
		}
		
		return copyFolder(folder, destFolder, realPath, userInfo, userCheck);
	}
	
	@Override
	// 사용되지 않음. (2021-04-13 확인 - 김은실)
	public String getMaxFolderUserSeq(int tenantId, String type) throws Exception {
		int currentMaxolderUserId  = -1;
		String result              = ezWebFolderService.getFolderUserSequence(tenantId, type);
		currentMaxolderUserId      = result.equals("")             ? 1 : Integer.parseInt(result);
		currentMaxolderUserId	   = (currentMaxolderUserId == -1) ? 1 : (currentMaxolderUserId + 1);
		return Integer.toString(currentMaxolderUserId);
	}
	
	public String getMaxFolderUserSeq(int tenantId) throws Exception {
		return "";
	}
	
	@Override
	public String getMaxFolderID(int tenantId) throws Exception {
		return "";
	}
	
	public int getMaxFolderStep(String folderId, int tenantId) throws Exception {
		int currentMaxStep = -1;
		String result      = ezWebFolderService.getMaxFolderStep(folderId, tenantId);
		currentMaxStep     = result.equals("")        ? 1 : Integer.parseInt(result);
		currentMaxStep     = (currentMaxStep == -1)   ? 1 : (currentMaxStep + 1);
		return currentMaxStep;
	}
	
	private List<DuplicateInfoVO> moveFolder(FolderVO folder, FolderVO parentFolder, String userId, String offset, int tenantId) throws Exception {
		List<DuplicateInfoVO> duplicateList = ezWebFolderService.getAllDuplicateInfo(Type.DIRECTORY, folder.getFolderId(), parentFolder.getFolderId(), offset, tenantId);
		
		if (duplicateList.size() > 0) {
			return duplicateList;
		}
		
		String oldPath             = folder.getFolderPath();
		String newPath             = parentFolder.getFolderPath() + folder.getFolderId() + "|";
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Date date                  = new Date();
		String timeUTC             = commonUtil.getDateStringInUTC(formatter.format(date), offset, true);		//updateDate위한 현재시간
		int levelDistance          = parentFolder.getFolderLevel() + 1 - folder.getFolderLevel();
		
		String createDate = "";
		
		if (folder.getCreateDate().contains(".0")){
			// TODO: 현재 query상에서 .S 형태로 돌아와서 해놓은것이지만 다른 형식으로 돌아올때에는 수정필요함.
			SimpleDateFormat formatter2 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.S");						// db에서 가져온 folder의 timeUTC를 적용한 -9시간
			Date date1 = formatter2.parse(folder.getCreateDate());																							// folder의 creatreDate를 가져와서 date방식으로 format
			logger.debug("date1:"+date1 + ",folderCreateDate:"+folder.getCreateDate());
			
			SimpleDateFormat targetDateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");					// 우리가 지원하는 형식으로 다시 포맷
			createDate = targetDateFormat.format(date1);
		} else {
			createDate = folder.getCreateDate();
		}
		
	    String timeUTCCreate	   = commonUtil.getDateStringInUTC(createDate, offset, true);	// timeUTC 적용
		
	    // /* 회사폴더, 부서폴더/개인폴더 로 구분하기 위해서 이동시킬때에도 folderUser를 삭제하지 않도록 한다.
		if (folder.getFolderLevel() == 1 && parentFolder.getFolderType().equals("C")) {
			deleteFolderUsers(folder.getFolderId(), tenantId, "1");
		}
		
		/* 회사폴더 - 모든 폴더들이 구성원을 가지므로 따로 추가해줄 필요가 없음.
			// parentFolder.getFolderLevel() == 0
		if ((folder.getFolderLevel() + levelDistance == 1) && parentFolder.getFolderType().equals("C")) {
			String folderPath            = folder.getFolderPath();
			folderPath                   = folderPath.substring(1, folderPath.length() - 1);
			String ancestorId            = folder.getFolderType().equals("C") ? folderPath.split("\\|")[1] : folderPath.split("\\|")[0];
			List<FolderUserVO> listUsers = ezWebFolderService.getFolderUsers(ancestorId, tenantId);
			// 원부서의 1레벨 folderUser를 따른다.
			
			for (FolderUserVO folderUser: listUsers) {
				insertFolderUser(getMaxFolderUserSeq(tenantId), folderUser.getUserId(), folderUser.getUserType(), folder.getFolderId(), userId, timeUTC, folder.getCompanyId(), tenantId);
			}
		}
		*/
		
		moveListSubFiles(parentFolder.getFolderId(), oldPath, tenantId);

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
		
		return duplicateList;
	}
	
	/**
	 * 이동할 폴더의 모든 파일을 전부 암호화/복호화 한다.<br>
	 * 모든 서브 폴더의 파일도 전부 포함한다.
	 */
	private void moveListSubFiles(String parentFolderId, String oldFolderPath, int tenantId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("folderPath", oldFolderPath);
		map.put("tenantId", tenantId);

		FunctionWithException<byte[], byte[]> transformFunc;
		BiConsumer<String, Integer> updateFunc;

		List<Map<String, Object>> fileList;

		if (ezWebFolderService.isEncryptionFolder(parentFolderId, tenantId)) {
			transformFunc = klibUtil::encrypt;
			updateFunc = ezWebFolderService::insertEncryptedFile;
			fileList = ezWebFolderAdminDAO.getDecryptedAllSubFilePath(map);
		} else {
			transformFunc = klibUtil::decrypt;
			updateFunc = ezWebFolderService::deleteEncryptedLatestVersion;
			fileList = ezWebFolderAdminDAO.getEncryptedAllSubFilePath(map);
		}

		String realPath = servletContext.getRealPath("");

		for (Map<String, Object> file : fileList) {
			String fileId = (String) file.get("FILE_ID");
			String filePath = (String) file.get("FILE_PATH");
			Path path = Paths.get(realPath, filePath);
			byte[] bytes = commonUtil.readBytesFromFile(path);
			byte[] result = transformFunc.apply(bytes);

			commonUtil.writeBytesToFile(path, result);
			updateFunc.accept(fileId, tenantId);
		}
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

	private List<DuplicateInfoVO> copyFolder(FolderVO folder, FolderVO parentFolder, String realPath, LoginVO userInfo, String userCheck) throws Exception {
		String offset = userInfo.getOffset();
		int tenantId = userInfo.getTenantId();
		List<DuplicateInfoVO> duplicateList = ezWebFolderService.getAllDuplicateInfo(Type.DIRECTORY, folder.getFolderId(), parentFolder.getFolderId(), offset, tenantId);
		
		if (duplicateList.size() > 0) {
			return duplicateList;
		}
		
		// 2020-12-15 김은실 - [카이스트]회사 폴더별 관리자 지원 기능 : 관리자가 권한이 체크되어 폴더복사가 안되는 현상 수정.
		String userRoll = userInfo.getRollInfo();
		if(!(userRoll.contains("c=1") || userRoll.contains("k=1") || userRoll.contains("f=1"))
			 && "fail".equalsIgnoreCase(ezWebFolderService_y.checkPermission(userInfo.getId(), userInfo.getDeptID(), userInfo.getCompanyID(), 
				folder.getFolderId(), "D", userInfo.getTenantId()))){
			logger.debug("folder no permission folderId:" + folder.getFolderId());
			return null;
		}
		
		String userId                = userInfo.getId();
		String folderId              = folder.getFolderId();
		//String oldPath               = folder.getFolderPath();
		String newId                 = getMaxFolderID(userInfo.getTenantId());
		String newPath               = parentFolder.getFolderPath() + newId + "|";
		
		SimpleDateFormat formatter   = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Date date                    = new Date();
		String timeUTC               = commonUtil.getDateStringInUTC(formatter.format(date), offset, true);
		int levelDistance            = parentFolder.getFolderLevel() + 1 - folder.getFolderLevel();
		
		if (parentFolder.getFolderType().equals("C")) {
			String folderPath = folder.getFolderPath();
			folderPath        = folderPath.substring(1, folderPath.length() - 1);
			String ancestorId = folder.getFolderType().equals("C") ? folderPath.split("\\|")[1] : folderPath.split("\\|")[0];
			
//			List<FolderUserVO> listUsers = ezWebFolderService.getFolderUsers(ancestorId, tenantId);
			
//			for (FolderUserVO folderUser: listUsers) {
//				insertFolderUser(getMaxFolderUserSeq(tenantId), folderUser.getUserId(), folderUser.getUserType(), newId, userId, timeUTC, folder.getCompanyId(), tenantId);
//			}
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
		int folderIdInt = insertFolder(folder);
		newId = Integer.toString(folderIdInt);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("upperFolderId", folderId);
		map.put("targetId", newId);
		map.put("tenantId", tenantId);
		map.put("type_f", "D");
		insertFolderUser(map);
		copyFile(folderId, newId, timeUTC, realPath, userInfo, userCheck);
		
		//copy all sub folders
		copySubFolders(folderId, parentFolder.getFolderType(), newPath, timeUTC, parentFolder.getOwnerId(), levelDistance, realPath, userInfo, userCheck, newId);

		// 2020-10-07 김은실 - (카이스트)커스터 마이징 메뉴: 학처장회의안건 메뉴 리스트 수정
//		if(isDean != null && isDean.equals("Y") && folder.getFolderLevel() == 1){
//			int updateResultInt = ezCommonService.updateTenantConfig("webFolderPathsOfDean", tenantId, ezCommonService.getTenantConfig("webFolderPathsOfDean", tenantId) + "," + folder.getFolderPath());
//			logger.debug("TenantConfig 'webFolderPathsOfDean' update ResultInt: " + updateResultInt);
//		}
		
		return duplicateList;
	}


	private void copySubFolders(String folderId, String folderType, String newPath, String timeUTC, String ownerId, int levelDistance, 
			String realPath, LoginVO userInfo, String userCheck, String newFolderId) throws Exception {
		List<FolderVO> listSubFolder = ezWebFolderService.getAllSubFolders(folderId, userInfo.getOffset(), userInfo.getTenantId());
		
		if (listSubFolder != null && listSubFolder.size() > 0) {
			for (int i = 0; i < listSubFolder.size(); i++) {
				FolderVO subFld   = listSubFolder.get(i);
				
				if(userCheck.equalsIgnoreCase("user") && "fail".equalsIgnoreCase(ezWebFolderService_y.checkPermission(userInfo.getId(), userInfo.getDeptID(), userInfo.getCompanyID(), 
						subFld.getFolderId(), "D", userInfo.getTenantId()))){
					logger.debug("subFld no permission folderId:" + subFld.getFolderId());
					continue;
				}
				
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
				subFld.setFolderUpper(newFolderId);
				
				//Create new folder
				int folderIdInt = insertFolder(subFld);
				newSubId = Integer.toString(folderIdInt);
				
				Map<String, Object> map = new HashMap<String, Object>();
				map.put("upperFolderId", oldId);
				map.put("targetId", newSubId);
				map.put("tenantId", userInfo.getTenantId());
				map.put("type_f", "D");
				insertFolderUser(map);
				copyFile(oldId, newSubId, timeUTC, realPath, userInfo, userCheck);
				
				//copy all sub folders
				copySubFolders(oldId, folderType, folderPath, timeUTC, ownerId, levelDistance, realPath, userInfo, userCheck, newSubId);
			}
		}
	}

	private void copyFile(String folderId, String newId, String timeUTC, String realPath, LoginVO userInfo, String userCheck) throws Exception {
		List<FileVO> fileList = ezWebFolderService.getAllFilesInFolder("", "", folderId, "", "0", "", "", "", "", "", "1", 0, 0, 
				userInfo.getPrimary(), userInfo.getOffset(), userInfo.getTenantId(), "", "");
		
		if (fileList != null && fileList.size() > 0) {
			String userId = userInfo.getId();

			for (FileVO file : fileList) {
				// 2020-12-15 김은실 - [카이스트]회사 폴더별 관리자 지원 기능 : 관리자가 권한이 체크되어 폴더복사가 안되는 현상 수정.
				String userRoll = userInfo.getRollInfo();
				if(userCheck.equalsIgnoreCase("user") && "fail".equalsIgnoreCase(ezWebFolderService_y.checkPermission(userInfo.getId(), userInfo.getDeptID(), userInfo.getCompanyID(), 
						file.getFileId(), "F", userInfo.getTenantId()))){
					logger.debug("file no permission folderId:" + file.getFileId());
					continue;
				}
				
				String previousFileId = file.getFileId();

				if (ezWebFolderService.isEncryptedFile(previousFileId, userInfo.getTenantId())
						&& !userId.equalsIgnoreCase(file.getCreateId())) {
					logger.debug("암호화 된 파일은 복사할 수 없습니다. fileId: {}, fileName: {}", previousFileId, file.getFileName());
					continue;
				}

				String newFileId = ezWebFolderService.getMaxFileID(userInfo.getTenantId());

				file.setDownloadCnt(0);
				file.setFolderId(newId);
				file.setCreateDate(timeUTC);
				file.setUpdateDate(timeUTC);
				file.setCreateId(userInfo.getId());
				file.setUpdateId(userInfo.getId());
				file.setCreateName1(userInfo.getDisplayName1());
				file.setCreateName2(userInfo.getDisplayName2());
				file.setFileId(newFileId);
				
				String fileName = file.getFileName();
				int dotPos      = fileName.lastIndexOf(".");
				String extend   = dotPos == -1 ? ".none" : commonUtil.detectPathTraversal(fileName.substring(dotPos + 1));
				String newName  = webfolderUtil.generateFilePath(extend);
				String newPath  = ezWebFolderService.getWebFolderDirPath(userInfo.getTenantId()) + newName;
				File srcFile    = new File(realPath + commonUtil.detectPathTraversal(file.getFilePath()));
				File destFile   = new File(realPath  + newPath);
				destFile.getParentFile().mkdirs(); 
				
				boolean isEncryptionFolder = ezWebFolderService.isEncryptionFolder(newId, userInfo.getTenantId());
				boolean isEncryptedFile = ezWebFolderService.isEncryptedFile(previousFileId, userInfo.getTenantId());
				boolean requireKlibTransformation = isEncryptionFolder && !isEncryptedFile;

				if (requireKlibTransformation) {
					byte[] bytes = commonUtil.readBytesFromFile(srcFile.toPath());
					commonUtil.writeBytesToFile(destFile.toPath(), klibUtil.encrypt(bytes));
				} else {
					FileUtils.copyFile(srcFile, destFile);
				}
				
				file.setFilePath(newPath);

				// 파일 답글 처리
				file.setDepth(1);
				file.setRootId(newFileId);
				file.setParentId(newFileId);
				file.setHierarchicalPath(newFileId);

				newFileId = String.valueOf(ezWebFolderService.insertFile(file));

				file.setFileId(newFileId);
				
				logger.debug("newFileId:" + newFileId);
				// 첫번째 버전은 무조건 생성하도록 한다.
				ezWebFolderService.incrementFileVersion(userInfo, newFileId);

				if (requireKlibTransformation || isEncryptedFile) {
					ezWebFolderService.insertEncryptedFile(newFileId, userInfo.getTenantId());
				}

				Map<String, Object> map = new HashMap<String, Object>();
				map.put("upperId", previousFileId);
				map.put("targetId", newFileId);
				map.put("tenantId", userInfo.getTenantId());
				map.put("type_f", "F");
				
				
				map.put("copyType", "copy");
				insertFolderUser(map);
				ezWebFolderService.saveLog("CP", userInfo.getCompanyID(), userInfo.getOffset(), userInfo.getId(), userInfo.getDisplayName1(), userInfo.getDisplayName2(), userInfo.getTenantId(), file, "", userInfo.getPrimary());
			}
		}
	}

	@Override
	public void setDefaultCapacity(String companyValue, String departmentValue, String userValue, String companyId, int tenantId) throws Exception {
		Map<String, Object> map = new HashMap<>();
		map.put("companyValue", companyValue);
		map.put("departmentValue", departmentValue);
		map.put("userValue", userValue);
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);

		ezWebFolderAdminDAO.setDefaultCapacity(map);
	}

	@Override
	public void setCapacities(List<String> cnList, String type, String value, String companyId, int tenantId) throws Exception {
		Consumer<Map<String, Object>> setCapacityFunc = type.equals("C") ? ezWebFolderAdminDAO::setCapacityForCompany : ezWebFolderAdminDAO::setCapacity;
		Map<String, Object> map = new HashMap<>();
		map.put("type", type);
		map.put("value", value);
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);

		for (String cn : cnList) {
			map.put("cn", cn);
			setCapacityFunc.accept(map);
		}
	}

	@Override
	public void deleteCapacities(List<String> cnList, String type, int tenantId) throws Exception {
		Map<String, Object> map = new HashMap<>();
		map.put("list", cnList);
		map.put("type", type);
		map.put("tenantId", tenantId);

		ezWebFolderAdminDAO.deleteCapacities(map);
	}

	@Override
	public List<UserCapacityVO> getCapacityList(String type, String primary, String companyId, int tenantId, String realColumn, String order, String searchKeyword, String searchOption, int startPoint, int pageSize) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("type", type);
		map.put("realColumn", realColumn);
		map.put("order", order);

		if (companyId != null) {
			map.put("companyId", companyId);
		}

		map.put("searchKeyword", searchKeyword);
		map.put("searchOption", searchOption);
		map.put("startPoint", startPoint);
		map.put("pageSize", pageSize);
		map.put("tenantId", tenantId);
		map.put("primary", primary);

		return ezWebFolderAdminDAO.getCapacityList(map);
	}

	@Override
	public int getTotalCapacityCount(String type, String companyId, int tenantId, String searchKeyword, String searchOption) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("type", type);
		map.put("companyId", companyId);
		map.put("searchKeyword", searchKeyword);
		map.put("searchOption", searchOption);
		map.put("tenantId", tenantId);
		map.put("primary", "1");

		return ezWebFolderAdminDAO.getTotalCapacityCount(map);
	}

	@Override
	public UserCapacityVO getCapacity(String cn, String type, String primary, int tenantId) throws Exception {
		Map<String, Object> param = new HashMap<>();
		param.put("cn", cn);
		param.put("type", type);
		param.put("primary", primary);
		param.put("tenantId", tenantId);

		return ezWebFolderAdminDAO.getCapacity(param);
	}

	@Override
	public UserCapacityVO getCapacity(String folderId, String primary, int tenantId) throws Exception {
		FolderVO folder = ezWebFolderService.getFolderByFolderId(folderId, "0|000000", tenantId);

		if (folder.getFolderLevel() > 0) {
			StringBuilder folderPath = new StringBuilder(folder.getFolderPath());
			String rootFolderId = folderPath.deleteCharAt(0).substring(0, folderPath.indexOf("|"));
			folder = ezWebFolderService.getFolderByFolderId(rootFolderId, "0|000000", tenantId);
		}

		return getCapacity(folder.getOwnerId(), folder.getFolderType(), primary, tenantId);
	}

	@Override
	public String createExcelFileLogs(String realPath, String dirPath, List<FileLogVO> listFileLogs, String primary, Locale locale) throws Exception {
		logger.debug("createExcelFileLogs start");
		Date date                  = new Date();
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
		String fileName            = egovMessageSource.getMessage("ezWebFolder.t128", locale) + "_" + formatter.format(date) + ".xlsx";
		String filePath            = dirPath + fileName;
		File file                  = new File(dirPath);
		File file2                 = new File(filePath);
		
		if (file == null || !file.exists()) {
			file.mkdirs();
		}
		else {
			FileUtils.cleanDirectory(file); 
		}
		
		if (file2.exists()) {
			int pos         = fileName.lastIndexOf('.');
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

		rowhead1.createCell(2).setCellValue(egovMessageSource.getMessage("ezWebFolder.t199", locale));
		rowhead1.createCell(3).setCellValue(egovMessageSource.getMessage("webfolder.version", locale));
		
		rowhead1.createCell(4).setCellValue(egovMessageSource.getMessage("ezWebFolder.t157", locale));
		rowhead1.createCell(5).setCellValue(egovMessageSource.getMessage("ezWebFolder.t339", locale));
		rowhead1.createCell(6).setCellValue(egovMessageSource.getMessage("ezWebFolder.t158", locale));
		rowhead1.createCell(7).setCellValue(egovMessageSource.getMessage("ezWebFolder.t159", locale));
		
		rowhead1.getCell(0).setCellStyle(centerStyle);
		rowhead1.getCell(1).setCellStyle(centerStyle2);
		rowhead1.getCell(2).setCellStyle(centerStyle2);
		rowhead1.getCell(3).setCellStyle(centerStyle2);
		rowhead1.getCell(4).setCellStyle(centerStyle2);
		rowhead1.getCell(5).setCellStyle(centerStyle2);
		rowhead1.getCell(6).setCellStyle(centerStyle2);
		rowhead1.getCell(7).setCellStyle(centerStyle2);
		
		int i = 1;
		
		for (FileLogVO fileLog : listFileLogs) {
			Row newRow1 = sheet1.createRow(i);
			
			newRow1.createCell(0).setCellValue(fileLog.getFileExt());
			// 속도 개선을 위해 주석
			//drawPictureInExcel(workbook, sheet1, realPath + fileLog.getFileType(), 0, i);
			newRow1.createCell(1).setCellValue(fileLog.getFileName());
			String pathName = fileLog.getFolderPathName() != null && fileLog.getFolderPathName().length() != 0 
					? fileLog.getFolderPathName().substring(0,fileLog.getFolderPathName().length()-1): "-";
			newRow1.createCell(2).setCellValue(pathName);
			String versionStr = fileLog.getVersion().equals("0") ?  "-" : fileLog.getVersion() + ".0";
			newRow1.createCell(3).setCellValue(versionStr);
			newRow1.createCell(4).setCellValue(formatFileSize(fileLog.getFileSize()));
			newRow1.createCell(5).setCellValue(primary.equals("1") ? fileLog.getCreateName1() : fileLog.getCreateName2());
			
			switch(fileLog.getLogType()) {
				case "C" : newRow1.createCell(6).setCellValue(egovMessageSource.getMessage("ezWebFolder.t160", locale)); break;
				case "D" : newRow1.createCell(6).setCellValue(egovMessageSource.getMessage("ezWebFolder.t161", locale)); break;
				case "U" : newRow1.createCell(6).setCellValue(egovMessageSource.getMessage("ezWebFolder.t162", locale)); break;
				case "R" : newRow1.createCell(6).setCellValue(egovMessageSource.getMessage("ezWebFolder.t111", locale)); break;
				case "P" : newRow1.createCell(6).setCellValue(egovMessageSource.getMessage("ezWebFolder.t19",  locale)); break;
				case "RE": newRow1.createCell(6).setCellValue(egovMessageSource.getMessage("ezWebFolder.t287", locale)); break;
				case "MV": newRow1.createCell(6).setCellValue(egovMessageSource.getMessage("ezWebFolder.t121", locale)); break;
				case "CP": newRow1.createCell(6).setCellValue(egovMessageSource.getMessage("ezWebFolder.t122", locale)); break;
				case "WR": newRow1.createCell(6).setCellValue(egovMessageSource.getMessage("ezWebFolder.t506", locale)); break;
				case "V" : newRow1.createCell(6).setCellValue(egovMessageSource.getMessage("ezWebFolder.t524", locale)); break;
			}
			
			newRow1.createCell(7).setCellValue(fileLog.getCreateDate().substring(0, 19));
			
			newRow1.getCell(0).setCellStyle(centerStyle);
			newRow1.getCell(1).setCellStyle(centerStyle2);
			newRow1.getCell(2).setCellStyle(centerStyle2);
			newRow1.getCell(3).setCellStyle(centerStyle2);
			newRow1.getCell(4).setCellStyle(centerStyle2);
			newRow1.getCell(5).setCellStyle(centerStyle2);
			newRow1.getCell(6).setCellStyle(centerStyle2);
			newRow1.getCell(7).setCellStyle(centerStyle2);
			
			i++;
		}
		
		sheet1.autoSizeColumn(0);
		sheet1.setColumnWidth(0, sheet1.getColumnWidth(0) + 200);
		sheet1.autoSizeColumn(1);
		sheet1.setColumnWidth(2, ((int)(40 * 1.14388)) * 256);
		sheet1.setColumnWidth(3, ((int)(10 * 1.14388)) * 256);
		sheet1.setColumnWidth(4, ((int)(10 * 1.14388)) * 256);
		sheet1.setColumnWidth(5, ((int)(10 * 1.14388)) * 256);
		sheet1.setColumnWidth(6, ((int)(10 * 1.14388)) * 256);
		sheet1.setColumnWidth(7, ((int)(20 * 1.14388)) * 256);
		
		try {
			fileOut = new FileOutputStream(filePath);
			workbook.write(fileOut);
		}
		catch (Exception e) {
			throw e;
		}
		finally {
			// 2023-05-17 이사라 : NullPointerException 시큐어코딩
			//fileOut.close();
			IOUtils.closeQuietly(fileOut);
			workbook.close();
		}
		logger.debug("createExcelFileLogs end");
		return fileName;
	}
	
	@SuppressWarnings("unused")
	private void drawPictureInExcel(Workbook workbook, Sheet sheet1, String picturePath, int colNum, int rowNum) throws Exception {
		// CWE-404 보안 취약점 대응
		try (InputStream inputStream = new FileInputStream(picturePath)) {
			byte[] imageBytes       = IOUtils.toByteArray(inputStream);
			int pictureureIdx       = workbook.addPicture(imageBytes, Workbook.PICTURE_TYPE_PNG);
			
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
	}
	
	private String formatFileSize(double fileSize) {
		String _fileSize = "";
		
		if (fileSize / 1024 / 1024 / 1024 >= 1) {
			double tmp = Math.floor((double)((fileSize / 1024 / 1024 * 10) / 10) * 100) / 100.0;
			_fileSize = String.valueOf(tmp);
			//_fileSize = String.format("%.2f", (double)(fileSize / 1024 / 1024 * 10) / 10);
			_fileSize = _fileSize + "GB";
		}
		else if (fileSize / 1024 / 1024 >= 1) {
			double tmp = Math.floor((double)((fileSize / 1024 / 1024 * 10) / 10) * 100) / 100.0;
			_fileSize = String.valueOf(tmp);
			//_fileSize = String.format("%.2f", (double)(fileSize / 1024 / 1024 * 10) / 10);
			_fileSize = _fileSize + "MB";
		}
		else if (fileSize / 1024 >= 1) {
			double tmp = Math.floor((double)(fileSize / 1024) * 100) / 100.0;
			_fileSize = String.valueOf(tmp);
			//_fileSize = String.format("%.2f", (double)(fileSize / 1024));
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
		File file        = new File(dirPath + commonUtil.detectPathTraversal(fileName));
		
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
				logger.error(e.getMessage(), e);
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

	// 2020-10-27 김은실 - 웹폴더 권한그룹(사용자 범위)추가 : 사용자 삭제, 부서 삭제, 직함 삭제, 권한그룹 삭제 시 TBL_WEBFOLDER_FOLDERUSER의 데이터도 함께 삭제.
	@Override
	public void deleteFolderUsersByUserId(String userId, String userType, String companyId, int tenantId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("userId",   userId);
		map.put("userType",	userType);
		map.put("companyId",companyId);
		map.put("tenantId", tenantId);
		ezWebFolderAdminDAO.deleteFolderUsersByUserId(map);
	}

	private interface FunctionWithException<T, R> {
		R apply(T t) throws Exception;
	}
	
	// 2020-12-03 김은실 - [카이스트]해당 사용자가 담당하는 폴더 아이디들 
	@Override
	public List<String> getFolderIdsByManagerUserId(String userId, String folderId, String companyId, int tenantId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("userId",   userId);      									 // USER_ID       
		map.put("folderId",   	 folderId 	   != null? folderId 	  : ""); // FOLDER_ID       
		map.put("companyId",companyId	 	   != null? companyId 	  : ""); // COMPANY_ID    
		map.put("tenantId", tenantId);    									 // TENANT_ID     
		return ezWebFolderAdminDAO.getFolderIdsByManagerUserId(map);
	}

	@Override
	public List<String> getTopFoldersByManagerUserId(String userId, int tenantId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userId", userId);
		map.put("tenantId", tenantId);
		return ezWebFolderAdminDAO.getTopFoldersByManagerUserId(map);
	}

	@Override
	public List<FileVO> folderInFileList(Map<String, Object> map) throws Exception {
		return ezWebFolderAdminDAO.folderInFileList(map);
	}
}
