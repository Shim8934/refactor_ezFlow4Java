package egovframework.ezEKP.ezWebFolder.service.impl;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.net.URLDecoder;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.ListIterator;
import java.util.Map;
import java.util.Objects;
import java.util.Optional;
import java.util.Properties;
import java.util.Set;
import java.util.stream.Collectors;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

import javax.annotation.Resource;
import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.io.FileUtils;
import org.apache.commons.io.FilenameUtils;
import org.apache.commons.io.IOUtils;
import org.apache.commons.lang3.StringUtils;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.FileCopyUtils;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.service.EgovFileMngUtil;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.ezEKP.ezOrgan.vo.OrganDeptVO;
import egovframework.ezEKP.ezOrgan.vo.OrganUserVO;
import egovframework.ezEKP.ezWebFolder.dao.EzWebFolderDAO;
import egovframework.ezEKP.ezWebFolder.dao.EzWebFolderDAO_y;
import egovframework.ezEKP.ezWebFolder.service.EzWebFolderAdminService;
import egovframework.ezEKP.ezWebFolder.service.EzWebFolderService;
import egovframework.ezEKP.ezWebFolder.service.EzWebFolderService_m;
import egovframework.ezEKP.ezWebFolder.service.EzWebFolderService_y;
import egovframework.ezEKP.ezWebFolder.util.EzWebfolderUtil;
import egovframework.ezEKP.ezWebFolder.vo.DuplicateInfoVO;
import egovframework.ezEKP.ezWebFolder.vo.DuplicateInfoVO.Type;
import egovframework.ezEKP.ezWebFolder.vo.FileHistoryVO;
import egovframework.ezEKP.ezWebFolder.vo.FileLogVO;
import egovframework.ezEKP.ezWebFolder.vo.FileUploadVO;
import egovframework.ezEKP.ezWebFolder.vo.FileTypeVO;
import egovframework.ezEKP.ezWebFolder.vo.FileVO;
import egovframework.ezEKP.ezWebFolder.vo.FolderSimpleVO;
import egovframework.ezEKP.ezWebFolder.vo.FolderUserVO;
import egovframework.ezEKP.ezWebFolder.vo.FolderVO;
import egovframework.ezEKP.ezWebFolder.vo.SimpleDeptVO;
import egovframework.ezEKP.ezWebFolder.vo.SimpleUserVO;
import egovframework.ezEKP.ezWebFolder.vo.UserCapacityVO;
import egovframework.ezEKP.ezWebFolder.vo.WebfolderEnvVO;
import egovframework.ezEKP.ezWebFolder.vo.result.ExtensionErrorFile;
import egovframework.ezEKP.ezWebFolder.vo.result.UploadResult;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.fcc.service.KlibUtil;

@Service("EzWebFolderService")
public class EzWebFolderServiceImpl extends EgovFileMngUtil implements EzWebFolderService {
	private static final String HISTORY_FOLDER = "history/";

	@Resource(name = "EzWebFolderDAO")
	private EzWebFolderDAO ezWebFolderDAO;
	
	@Autowired
	private Properties globals;
	
	@Autowired
	private EzWebFolderDAO_y ezWebFolderDAO_y;

	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private EzWebFolderAdminService ezWebFolderAdminService;
	
	@Autowired
	private EzWebFolderService_m ezWebFolderService_m;
	
	@Autowired
	private EzWebFolderService_y ezWebFolderService_y;

	@Autowired
	private EzWebfolderUtil webfolderUtil;

	@Autowired
	private EzCommonService ezCommonService;
	
	@Autowired
	private EzOrganService ezOrganService;
	
	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;
	
	@Autowired
	private KlibUtil kilbUtil;

	@Autowired
	private ServletContext servletContext;
	
	private static final Logger logger = LoggerFactory.getLogger(EzWebFolderServiceImpl.class);
	
	@Override
	public String getFileSequence(int tenantId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("tenantId", tenantId);
		return ezWebFolderDAO.getFileSequence(map);
	}

	@Override
	public int insertFile(FileVO fileVO) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("fileId",      fileVO.getFileId());
		map.put("fileName",    fileVO.getFileName());
		map.put("filePath",    fileVO.getFilePath());
		map.put("fileSize",    fileVO.getFileSize());
		map.put("typeId",      fileVO.getTypeId());
		map.put("downloadCnt", fileVO.getDownloadCnt());
		map.put("fileExt",     fileVO.getFileExt());
		map.put("folderId",    Integer.parseInt(fileVO.getFolderId()));
		map.put("useStatus",   fileVO.getUseStatus());
		map.put("createId",    fileVO.getCreateId());
		map.put("createName1", fileVO.getCreateName1());
		map.put("createName2", fileVO.getCreateName2());
		map.put("createDate",  fileVO.getCreateDate().substring(0, 19));
		map.put("updateId",    fileVO.getUpdateId());
		map.put("updateDate",  fileVO.getUpdateDate().substring(0, 19));
		map.put("deleterId",   fileVO.getDeleterId());
		map.put("tenantId",    fileVO.getTenantId());
		map.put("depth",       fileVO.getDepth());
		map.put("rootId",      fileVO.getRootId());
		map.put("parentId",    fileVO.getParentId());
		map.put("hierarchicalPath", fileVO.getHierarchicalPath());
		int fileId = ezWebFolderDAO.insertFile(map);
		logger.debug("fileId'" + fileId);
		
		if (fileVO.getFileId().equals("")){
			map.put("fileId", 	  fileId);
			map.put("rootId",     String.valueOf(fileId));
			map.put("parentId",   String.valueOf(fileId));
			map.put("hierarchicalPath",   String.valueOf(fileId));
			ezWebFolderDAO.updateFileRoot(map);
		}
		
		return fileId;
	}
	
	@Override
	public void insertFileUser(FileVO fileVO, String seqId, String userId, String userType, String comId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("seqId", 		seqId);
		map.put("fileId",      	fileVO.getFileId());
		map.put("userId",	   	userId);
		map.put("userType",    	userType);
		map.put("createId",    	fileVO.getCreateId());
		map.put("createDate",  	fileVO.getCreateDate().substring(0, 10));
		map.put("comId",  	   	comId);
		map.put("tenantId",    	fileVO.getTenantId());
		
		ezWebFolderDAO.insertFileUser(map);
	}

	@Override
	public FileVO getFileByFileId(String fileId, String offset, int tenantId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("fileId",   fileId);
		map.put("offset",   commonUtil.getMinuteUTC(offset));
		map.put("tenantId", tenantId);
		return ezWebFolderDAO.getFileByFileId(map);
	}

	@Override
	public FileTypeVO getFileTypeByFileExt(String extend, int tenantId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("extension", extend);
		map.put("tenantId",  tenantId);
		
		return ezWebFolderDAO.getFileTypeByFileExt(map);
	}

	@Override
	public void deleteFileByFileId(String fileId, int tenantId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("fileId",   fileId);
		map.put("tenantId", tenantId);
		ezWebFolderDAO.deleteFileByFileId(map);	
	}

	@Override
	public void updateFileUseStatus(String userId, String fileId, String timeUTC, int tenantId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("userId",   userId);
		map.put("fileId",   fileId);
		map.put("tenantId", tenantId);
		map.put("timeUTC",  timeUTC);
		ezWebFolderDAO.updateFileUseStatus(map);
	}

	@Override
	public void updateFileName(String fileId, String newName, String timeUTC, int tenantId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("fileId",   fileId);
		map.put("name",     newName);
		map.put("tenantId", tenantId);
		map.put("timeUTC", timeUTC);
		
		ezWebFolderDAO.updateFileName(map);
	}

	@Override
	public void moveFile(String fileId, String folderId, int tenantId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("fileId",   fileId);
		map.put("folderId", folderId);
		map.put("tenantId", tenantId);
		ezWebFolderDAO.moveFile(map);
	}
	
	@Override
	public void moveRenameFile(String fileId, String folderId, String newFileName, int tenantId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("fileId",   fileId);
		map.put("folderId", folderId);
		map.put("newFileName", newFileName);
		map.put("tenantId", tenantId);
		
		ezWebFolderDAO.moveRenameFile(map);
	}

	@Override
	public String getFileLogSequence(int tenantId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();		
		map.put("tenantId", tenantId);
		return ezWebFolderDAO.getFileLogSequence(map);
	}

	@Override
	public FolderVO getFolderByFolderId(String folderId, String offset, int tenantId) throws Exception {
		logger.debug("getFolderByFolderId " + folderId);
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("folderId", folderId);
		map.put("offset",   commonUtil.getMinuteUTC(offset));
		map.put("tenantId", tenantId);
		return ezWebFolderDAO.getFolderByFolderId(map);
	}

	@Override
	public FolderSimpleVO getSimpleFolder(String folderId, int tenantId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("folderId", folderId);
		map.put("tenantId", tenantId);
		return ezWebFolderDAO.getSimpleSubFolder(map);
		
	}

	@Override
	public List<FolderSimpleVO> getAllSimpleSubFolders(String folderUpperId, int tenantId, List<String> idList) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("folderUpper", folderUpperId);
		map.put("tenantId",    tenantId);
		map.put("idList",      idList);
		map.put("userId",      idList != null && idList.size() > 1 ? idList.get(1) : "");
		return ezWebFolderDAO.getAllSimpleSubFolders(map);
	}

	@Override
	public List<FolderVO> getAllSubFolders(String folderId, String offset, int tenantId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("folderUpper", folderId);
		map.put("offset",      commonUtil.getMinuteUTC(offset));
		map.put("tenantId",    tenantId);
		return ezWebFolderDAO.getAllSubFolders(map);
	}

	@Override
	public FolderVO getRootFolderId(String companyId, String type, String offset, int tenantId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("companyId", companyId);
		map.put("type",      type);
		map.put("tenantId",  tenantId);
		map.put("offset",    commonUtil.getMinuteUTC(offset));
		return ezWebFolderDAO.getRootFolderId(map);
	}

	@Override
	public void updateDownCnt(String fileId, int tenantId) {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("fileId",   fileId);
		map.put("tenantId", tenantId);
		ezWebFolderDAO.updateDownCnt(map);
	}

	@Override
	public List<FolderUserVO> getFolderUsers(String folderId, int tenantId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("folderId", folderId);
		map.put("tenantId", tenantId);
		return ezWebFolderDAO.getFolderUsers(map);
	}
	
	@Override
	public List<FolderUserVO> getFileUsers(String fileId, int tenantId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("fileId", fileId);
		map.put("tenantId", tenantId);
		return ezWebFolderDAO.getFileUsers(map);
	}

	@Override
	public String getFolderSequence(int tenantId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("tenantId", tenantId);
		return ezWebFolderDAO.getFolderSequence(map);
	}

	@Override
	public String getMaxFolderStep(String folderId, int tenantId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("tenantId", tenantId);
		map.put("folderId", folderId);
		return ezWebFolderDAO.getMaxFolderStep(map);
	}

	@Override
	public String getFolderUserSequence(int tenantId, String type) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("tenantId", tenantId);
		map.put("type", type);
		return ezWebFolderDAO.getFolderUserSequence(map);
	}

	@Override
	public void updateFolderUseStatus(FolderVO folder, LoginVO userInfo) throws Exception {
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Date date                  = new Date();
		String timeUTC             = commonUtil.getDateStringInUTC(formatter.format(date), userInfo.getOffset(), true);
		
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("folderPath", folder.getFolderPath());
		map.put("folderId",   folder.getFolderId());
		map.put("userId",     userInfo.getId());
		map.put("tenantId",   userInfo.getTenantId());
		map.put("timeUTC",    timeUTC);
		
		//saveLog
		List<FileVO> listFiles = getAllFilesInFolder("", "", folder.getFolderId(), "", "0", "", "", "", "", "", "1", 0, 0, 
				userInfo.getPrimary(), userInfo.getOffset(), userInfo.getTenantId(), "", "");
		
		for (FileVO file : listFiles) {
			saveLog("R", userInfo.getCompanyID(), userInfo.getOffset(), userInfo.getId(), userInfo.getDisplayName1(), userInfo.getDisplayName2(), userInfo.getTenantId(), file, "", userInfo.getPrimary());
		}
		
		logger.debug("folderPath: " + folder.getFolderPath());
		logger.debug("userId: " + userInfo.getId());
		logger.debug("tenantId: " + userInfo.getTenantId());
		logger.debug("timeUTC: " + timeUTC);
		
		//Update status for all files even in sub folders
		ezWebFolderDAO.updateStatusAllFilesInFolder(map);
		//Update status for folders
		ezWebFolderDAO.updateFolderUseStatus(map);
		//Update status for all sub folders
		ezWebFolderDAO.updateSubFolderUseStatus(map);

		// 2020-10-07 김은실 - (카이스트)커스터 마이징 메뉴: 학처장회의안건 메뉴 리스트 수정
//		if(isDean != null && isDean.equals("Y") && folder.getFolderLevel() == 1){
//			int updateResultInt = ezCommonService.updateTenantConfig("webFolderPathsOfDean", userInfo.getTenantId(), 
//					ezCommonService.getTenantConfig("webFolderPathsOfDean", userInfo.getTenantId()).replace(folder.getFolderPath() + ",", "")	// (a,)b,c -> b,c
//																								   .replace("," + folder.getFolderPath(), "")	// a(,b)(,c) -> a,b a,c
//																								   .replace(folder.getFolderPath(), ""));		// (a) -> ''
//			logger.debug("TenantConfig 'webFolderPathsOfDean' update ResultInt: " + updateResultInt);
//		}
	}

	@Override
	public List<DuplicateInfoVO> getAllDuplicateInfo(String fileName, String targetFolderId, String offset, int tenantId) throws Exception {
		Map<String, Object> sqlParams = new HashMap<>();
		
		sqlParams.put("fileName", fileName);
		sqlParams.put("targetFolderId", targetFolderId);
		sqlParams.put("offset", commonUtil.getMinuteUTC(offset));
		sqlParams.put("tenantId", tenantId);
		
		return ezWebFolderDAO.getAllDuplicateInfo(sqlParams);
	}
	
	@Override
	public List<DuplicateInfoVO> getAllDuplicateInfo(DuplicateInfoVO.Type originElementType, String originElementId, String targetFolderId, String offset, int tenantId) throws Exception {
		return getAllDuplicateInfoForRename(originElementType, originElementId, null, targetFolderId, offset, tenantId);
	}

	@Override
	public List<DuplicateInfoVO> getAllDuplicateInfoForRename(DuplicateInfoVO.Type originElementType, String originElementId, String newName, String targetFolderId, String offset, int tenantId) throws Exception {
		Map<String, Object> sqlParams = new HashMap<>();

		sqlParams.put("targetFolderId", targetFolderId);
		sqlParams.put("offset", commonUtil.getMinuteUTC(offset));
		sqlParams.put("tenantId", tenantId);
		// nullable
		sqlParams.put("newName", newName);
		sqlParams.put("originElementId", originElementId);

		if (originElementType == DuplicateInfoVO.Type.FILE) {
			return ezWebFolderDAO.getAllDuplicateInfoForFile(sqlParams);
		}

		return ezWebFolderDAO.getAllDuplicateInfoForFolder(sqlParams);
	}

	@Override
	public List<FileVO> getAllFilesInFolder(String realColmn, String order, String folderId, String originalPath, String searchChk, 
			String startDate, String endDate, String fileExt, String fileName, String userName, String fileType, int startPoint, int pageSize, 
			String primary, String offset, int tenantId, String sortType, String sortColumn) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("realColmn",    realColmn);
		map.put("order",        order);
		map.put("folderId",     folderId);
		map.put("originalPath", originalPath);
		map.put("fileType",     fileType);
		map.put("searchChk",    searchChk);
		map.put("startDate",    startDate);
		map.put("endDate",      endDate);
		map.put("fileExt",      fileExt);
		map.put("fileName",     fileName);
		map.put("userName",     userName);
		map.put("startPoint",   startPoint);
		map.put("pageSize",     pageSize);
		map.put("offset",       commonUtil.getMinuteUTC(offset));
		map.put("primary",      primary);
		map.put("tenantId",     tenantId);		
		map.put("sortType",     sortType);
		map.put("sortColumn",   sortColumn);
		map.put("orderByData",	sortColumn + " " + sortType);
		return ezWebFolderDAO.getAllFilesInFolder(map);
	}

	@Override
	public List<FileVO> getAllFiles(String realColmn, String order, String folderPath, String originalPath, String searchChk, 
			String startDate, String endDate, String fileExt, String fileName,	String userName, String fileType, int startPoint, 
			int pageSize,	String primary, String offset, int tenantId, String sortType, String sortColumn) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("realColmn",    realColmn);
		map.put("order",        order);
		map.put("folderPath",   folderPath);
		map.put("originalPath", originalPath);
		map.put("fileType",     fileType);
		map.put("searchChk",    searchChk);
		map.put("startDate",    startDate);
		map.put("endDate",      endDate);
		map.put("fileExt",      fileExt);
		map.put("fileName",     fileName);
		map.put("userName",     userName);
		map.put("startPoint",   startPoint);
		map.put("pageSize",     pageSize);
		map.put("offset",       commonUtil.getMinuteUTC(offset));
		map.put("primary",      primary);
		map.put("tenantId",     tenantId);
		map.put("sortType",     sortType);
		map.put("sortColumn",   sortColumn);
		map.put("orderByData",	sortColumn + " " + sortType);
		return ezWebFolderDAO.getAllFiles(map);
	}

	@Override
	public int getTotalFileCnt(String folderId, String searchChk, String startDate, String endDate, String fileExt, String fileName, String userName, String fileType, String primary, int tenantId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("folderId",   folderId);
		map.put("fileType",   fileType);
		map.put("searchChk",  searchChk);
		map.put("startDate",  startDate);
		map.put("endDate",    endDate);
		map.put("fileExt",    fileExt);
		map.put("fileName",   fileName);
		map.put("userName",   userName);
		map.put("primary",    primary);
		map.put("tenantId",   tenantId);
		return ezWebFolderDAO.getTotalFileCnt(map);
	}

	@Override
	public int getTotalFileCnt2(String folderPath, String searchChk, String startDate, String endDate, String fileExt, String fileName,	String userName, String fileType, String primary, int tenantId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("folderPath", folderPath);
		map.put("fileType",   fileType);
		map.put("searchChk",  searchChk);
		map.put("startDate",  startDate);
		map.put("endDate",    endDate);
		map.put("fileExt",    fileExt);
		map.put("fileName",   fileName);
		map.put("userName",   userName);
		map.put("primary",    primary);
		map.put("tenantId",   tenantId);
		return ezWebFolderDAO.getTotalFileCnt2(map);
	}

	@Override
	public void getAllSubDepts(FolderSimpleVO company, int tenantId, int mode) throws Exception {
		getAllSubDepts(company, tenantId, mode, null);
	}
	// 2020-12-14 김은실 - (카이스트)회사 폴더별 관리자 지원 기능: 권한에(idList) 따른 폴더 리스트 특정하기 
	@Override
	public void getAllSubDepts(FolderSimpleVO company, int tenantId, int mode, List<String> idList) throws Exception {
		if (company.getHasSubFolder() == 1) {
			List<FolderSimpleVO> listSubSimpleFolders = getAllSimpleSubFolders(company.getFolderId(), tenantId, idList);
			company.setListSubFolders(listSubSimpleFolders);
			
			if (mode == 0) {
				for (FolderSimpleVO subFolder: listSubSimpleFolders) {
					getAllSubDepts(subFolder, tenantId, mode, idList);
				}
			}
		}
	}

	@Override
	public void getAllSubDepts(FolderSimpleVO company, int tenantId, String[] fdPath, int order) throws Exception {
		if (company.getHasSubFolder() == 1) {
			List<FolderSimpleVO> listSubSimpleFolders = getAllSimpleSubFolders(company.getFolderId(), tenantId, null);
			company.setListSubFolders(listSubSimpleFolders);
			
			for (FolderSimpleVO subFolder: listSubSimpleFolders) {
				if (order < fdPath.length && subFolder.getFolderId().equals(fdPath[order])) {
					getAllSubDepts(subFolder, tenantId, fdPath, order + 1);
				}
			}
		}
	}

	private List<SimpleDeptVO> getAllSimpleDeptsOfCompany(String companyId, int level, String primary, int tenantId) {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("companyId",  companyId);
		map.put("primary",    primary);
		map.put("level",      level);
		map.put("tenantId",   tenantId);
		
		return ezWebFolderDAO.getAllSimpleDeptsOfCompany(map);
	}

	@Override
	public SimpleDeptVO getAllDepts(String companyId, int level, String primary, int tenantId) throws Exception {
		List<SimpleDeptVO> deptList = getAllSimpleDeptsOfCompany(companyId, level, primary, tenantId);
		SimpleDeptVO dept           = deptList.get(0);
		deptList.remove(0);
		dept.setSubDepts(deptList);
		
		return dept;
	}

	@Override
	public SimpleDeptVO getSimpleCompany(String deptId, int level, String primary, int tenantId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("deptId",     deptId);
		map.put("primary",    primary);
		map.put("level",      level);
		map.put("tenantId",   tenantId);
		
		return ezWebFolderDAO.getSimpleCompany(map);
	}

	@Override
	public void getAllDepts(SimpleDeptVO sDept, String[] path, String primary, int tenantId, int order, int level, String adminOrgan) throws Exception {
		if (sDept.getHasSub().equals("1")) {
			List<SimpleDeptVO> listSubSimpleDepts = getAllSimpleSubDepts(sDept.getDeptId(), level, primary, tenantId,adminOrgan);
			sDept.setSubDepts(listSubSimpleDepts);
			
			for (SimpleDeptVO subDept: listSubSimpleDepts) {
				if (order < path.length && subDept.getDeptId().equals(path[order])) {
					getAllDepts(subDept, path, primary, tenantId, order + 1, level + 1, adminOrgan);
				}
			}
		}
	}

	private List<SimpleDeptVO> getAllSimpleSubDepts(String deptId, int level, String primary, int tenantId, String adminOrgan) {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("deptId",     deptId);
		map.put("primary",    primary);
		map.put("level",      level);
		map.put("tenantId",   tenantId);
		map.put("adminOrgan", adminOrgan);
		
		return ezWebFolderDAO.getAllSimpleSubDepts(map);
	}

	@Override
	public String getDeptPath(String deptId, int tenantId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("deptId",     deptId);
		map.put("tenantId",   tenantId);
		return ezWebFolderDAO.getDeptPath(map);
	}

	@Override
	public List<SimpleUserVO> getDeptMemberList(String deptId, String primary, int tenantId, String adminOrgan) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("deptId",     deptId);
		map.put("primary",    primary);
		map.put("tenantId",   tenantId);
		map.put("adminOrgan", adminOrgan);
		
		return ezWebFolderDAO.getDeptMemberList(map);
	}

	@Override
	public List<FolderSimpleVO> getAllSimpleDeptFolder(String companyId, LoginVO userInfo) throws Exception {
		int tenantId           = userInfo.getTenantId();
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("companyId",  companyId);
		map.put("tenantId",   tenantId);
		
		List<FolderSimpleVO> listFolders      = ezWebFolderDAO.getAllSimpleDeptFolder(map);
		List<OrganDeptVO> listDepts           = getAllDepartments(companyId, userInfo.getPrimary(), tenantId);
		Set<String> deptIds                   = listFolders.stream().map(FolderSimpleVO::getOwnerId).collect(Collectors.toSet());
		List<OrganDeptVO> listNotPresentDepts = listDepts.stream().filter(e -> !deptIds.contains(e.getCn())).collect(Collectors.toList());
		
		if (listNotPresentDepts.size() > 0) {
			String userId              = userInfo.getId();
			SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			Date date                  = new Date();
			String timeUTC             = commonUtil.getDateStringInUTC(formatter.format(date), userInfo.getOffset(), true);
			
			for (OrganDeptVO dept : listNotPresentDepts) {
				FolderVO folder = new FolderVO();
				String folderId = ezWebFolderAdminService.getMaxFolderID(tenantId);
				
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
				
				int folderIdInt = ezWebFolderAdminService.insertFolder2(folder);
				folderId = Integer.toString(folderIdInt);
			
				ezWebFolderAdminService.insertFolderUser(ezWebFolderAdminService.getMaxFolderUserSeq(tenantId), dept.getCn(), "dept", folderId, userId, timeUTC, folder.getCompanyId(), tenantId);
			}
			
			listFolders = ezWebFolderDAO.getAllSimpleDeptFolder(map);
		}
		
		return listFolders;
	}

	@Override
	public List<OrganDeptVO> getAllDepartments(String companyId, String primary, int tenantId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("companyId",  companyId);
		map.put("primary",    primary);
		map.put("tenantId",   tenantId);
		
		return ezWebFolderDAO.getAllDepartments(map);
	}

	@Override
	public List<FolderSimpleVO> getDeptFolderTreeForUser(String userId, String deptId, int tenantId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("userId",    userId);
		map.put("deptId",    deptId);
		map.put("tenantId",  tenantId);
		
		List<FolderSimpleVO> listFolders = new ArrayList<FolderSimpleVO>();
		//Check if user is dept chief
		boolean check = checkDepartChief(userId, tenantId);
		
		if (check == true) {
			listFolders = ezWebFolderDAO.getDeptFolderTreeForChief(map);
		}
		else {
			listFolders = ezWebFolderDAO.getDeptFolderTreeForUser(map);
		}
		
		return listFolders;
	}

	@Override
	public FolderSimpleVO getCompanySimpleFolder(String companyID, LoginVO userInfo) throws Exception {
		int tenantId           = userInfo.getTenantId();
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("companyId",  companyID);
		map.put("tenantId",   tenantId);
		
		FolderSimpleVO companyFolder = ezWebFolderDAO.getCompanySimpleFolder(map);
		
		if (companyFolder == null) {
			OrganDeptVO company        = ezOrganService.getDeptInfo(companyID, userInfo.getPrimary(), tenantId);
			FolderVO folder            = new FolderVO();
			SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			Date date                  = new Date();
			String timeUTC             = commonUtil.getDateStringInUTC(formatter.format(date), userInfo.getOffset(), true);
			String folderId            = ezWebFolderAdminService.getMaxFolderID(tenantId);
			
			folder.setFolderId(folderId);
			folder.setFolderLevel(0);
			folder.setFolderName1(company.getDisplayName1());
			folder.setFolderName2(company.getDisplayName2());
			folder.setFolderPath("|" + folderId + "|");
			folder.setFolderStep(0);
			folder.setFolderType("C");
			folder.setFolderUpper("root");
			folder.setOwnerId(company.getCn());
			folder.setUseStatus("Y");
			folder.setUpdateId(userInfo.getId());
			folder.setCreateName1(userInfo.getDisplayName1());
			folder.setCreateName2(userInfo.getDisplayName2());
			folder.setTenantId(tenantId);
			folder.setCompanyId(company.getCn());
			folder.setCreateId(userInfo.getId());
			folder.setCreateDate(timeUTC);
			folder.setUpdateDate(timeUTC);
			
			ezWebFolderAdminService.insertFolder2(folder);
			companyFolder = ezWebFolderDAO.getCompanySimpleFolder(map);
		}
		
		return companyFolder;
	}

	@Override
	public List<FolderSimpleVO> getCompanySubSimpleFolder(String userId, String deptId, String compFolderId, String compId, int tenantId, List<String> idList) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("userId",    userId);
		map.put("deptId",    deptId);
		map.put("compFolderId", compFolderId);
		map.put("tenantId",  tenantId);
		map.put("compId",  compId);
		map.put("idList",  idList);
		
		List<FolderSimpleVO> listFolders = new ArrayList<FolderSimpleVO>();
		
		//Check if user is dept chief
		boolean check = checkDepartChief(userId, tenantId);
		
		if (check == true) {
			listFolders = ezWebFolderDAO.getCompanyFolderTreeForChief(map);
		}
		else {
			listFolders = ezWebFolderDAO.getCompanySubSimpleFolder(map);
		}
		
		return listFolders;
	}

	@Override
	public FolderSimpleVO getUserSimpleFolder(String userId, int tenantId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("userId",    userId);
		map.put("tenantId",  tenantId);
		
		return ezWebFolderDAO.getUserSimpleFolder(map);
	}

	@Override
	public boolean checkDepartChief(String userId, int tenantId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("userId",    userId);
		map.put("tenantId",  tenantId);
		int check = ezWebFolderDAO.checkDepartChief(map);
		
		return check == 0 ? false : true;
	}

	@Override
	public WebfolderEnvVO getListCount(String userId, int tenantId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("userId",    userId);
		map.put("tenantId",  tenantId);
		
		WebfolderEnvVO env = ezWebFolderDAO.getListCount(map);
		
		if (env == null) {
			env = new WebfolderEnvVO();
			env.setTenantId(tenantId);
			env.setCn(userId);
			env.setEnvType("P");
			env.setEnvValue("10");
		}
		
		return env;
	}

	@Override
	public void updateListCount(String userId, String listCount, int tenantId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("userId",    userId);
		map.put("listCount", listCount);
		map.put("tenantId",  tenantId);
		
		ezWebFolderDAO.updateListCount(map);
	}

	@Override
	public List<SimpleDeptVO> getAllDeptsForChief(String userId, int level, String primary, int tenantId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("userId",    userId);
		map.put("level",     level);
		map.put("primary",   primary);
		map.put("tenantId",  tenantId);
		
		return ezWebFolderDAO.getAllDeptsForChief(map);
	}

	@Override
	public List<SimpleDeptVO> getSelectedDeptsForChief(String userId, int level, String primary, int tenantId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("userId",    userId);
		map.put("level",     level);
		map.put("primary",   primary);
		map.put("tenantId",  tenantId);
		
		return ezWebFolderDAO.getSelectedDeptsForChief(map);
	}

	@Override
	public int checkFilesOwner(String userId, String fileList, int tenantId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("userId",    userId);
		map.put("fileList",  fileList);
		map.put("tenantId",  tenantId);
		
		return ezWebFolderDAO.checkFilesOwner(map);
	}
	
	@Override
	public UploadResult saveUploadedFiles(List<FileUploadVO> multiFileLists, JSONArray nameArray, FolderVO folder, String realPath, LoginVO userInfo, boolean isEncrypt, String parentId) throws Exception {
		UploadResult result = new UploadResult();
		int tenantId               = userInfo.getTenantId();
		String userName1           = userInfo.getDisplayName1();
		String userName2           = userInfo.getDisplayName2();
		String companyId           = userInfo.getCompanyID();
		String offset              = userInfo.getOffset();
		String userId              = userInfo.getId();
		int cnt                    = multiFileLists.size();
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		String[] pFileName         = new String[cnt];
		long[] fileSize            = new long[cnt];
		String useExtension        = ezCommonService.getTenantConfig("USE_FileExtension", tenantId);
		String folderPath          = folder.getFolderPath();
		folderPath                 = folderPath.substring(1, folderPath.length() - 1);
		String originalPath        = getFolderPath(folderPath.split("\\|"), userInfo.getPrimary(), tenantId);
		
		if (StringUtils.isNotBlank((String) ((JSONObject)nameArray.get(0)).get("originalFilename"))) {
			for (int i = 0; i < cnt; i++) {
				String _pFileName = (String)((JSONObject)nameArray.get(i)).get("originalFilename");
				_pFileName = URLDecoder.decode(_pFileName,"UTF-8");
				
				if (_pFileName.indexOf(commonUtil.separator) > 0) {
					_pFileName = _pFileName.split("/")[_pFileName.split("/").length - 1];
				}
				
				pFileName[i] = commonUtil.normalizeFileName(_pFileName);
			}
		}
		
		String pDirPath = getWebFolderDirPath(tenantId);
		pDirPath        = realPath + pDirPath;
		
		if (!pDirPath.substring(pDirPath.length() - 1).equals(commonUtil.separator)) {
			pDirPath = pDirPath + commonUtil.separator;
		}
		
		File file = new File(pDirPath);
		
		if (!file.exists()) {
			file.mkdirs();
		}
		
		List<FileVO> list = new ArrayList<FileVO>();
		List<ExtensionErrorFile> failureList = new ArrayList<>();
		boolean isEncryptionFolder = isEncryptionFolder(folder.getFolderId(), tenantId);
		boolean isReply = !parentId.isEmpty();

		FileVO parentFile = null;

		if (isReply) {
			parentFile = getFileByFileId(parentId, offset, tenantId);

			if (parentFile != null) {
				logger.info("is reply file. parentFile is: id: {}, rootId: {}, depth: {}, hierarchicalPath: {}",
						parentId, parentFile.getRootId(), parentFile.getDepth(), parentFile.getHierarchicalPath());
			} else {
				logger.info("is reply file. parentFile is null.");
			}
		}

		for (int i = 0; i < cnt; i++) {
			fileSize[i]    = multiFileLists.get(i).getSize();
			int dotPos     = pFileName[i].lastIndexOf(".");
			String extend  = dotPos == -1 ? ".none" : pFileName[i].substring(dotPos + 1);
			String newName = webfolderUtil.generateFilePath(extend);
			
			if (extend.length() >= 10) {
				extend = "etc";
			}
			
			// dhlee : 20220527 - 파일 업로드 시 .으로 끝나는 파일(예: .jsp.)이 무조건 업로드 허용되는 문제 수정
			if ((!extend.isEmpty() && useExtension.toLowerCase().contains(extend.toLowerCase())) || useExtension.contains("*")) {
				if (isEncryptionFolder || isEncrypt) {
					writeUploadedFileEncryptKlib(multiFileLists.get(i).getBytes(), pDirPath + newName);
				} else {
					writeUploadedFile(multiFileLists.get(i).getInputStream(), pDirPath + newName);
				}

				FileTypeVO fileType = getFileTypeByFileExt(extend.toLowerCase(), tenantId);
				
				if (fileType == null) {
					fileType = getFileTypeByFileExt("unknown", tenantId);
				}
				
				Date date      = new Date();
				FileVO fileVO  = new FileVO();
				String timeUTC = commonUtil.getDateStringInUTC(formatter.format(date), offset, true);
				String fileId = getMaxFileID(tenantId);
				
				fileVO.setCreateDate(timeUTC);
				fileVO.setUpdateDate(timeUTC);
				fileVO.setFileExt(extend);
				fileVO.setFileName(pFileName[i]);
				fileVO.setDownloadCnt(0);
				fileVO.setFilePath(getWebFolderDirPath(tenantId) + newName);
				fileVO.setFileSize(fileSize[i]);
				fileVO.setFolderId(folder.getFolderId());
				fileVO.setTenantId(tenantId);
				fileVO.setCreateId(userId);
				fileVO.setUpdateId(userId);
				fileVO.setFileIconUrl(fileType.getTypeIcon());
				fileVO.setFileShareStatus("0");
				fileVO.setUseStatus("Y");
				fileVO.setTypeId(fileType.getTypeId());
				fileVO.setFavouriteStatus("0");
				fileVO.setCreateName1(userName1);
				fileVO.setCreateName2(userName2);
				fileVO.setFileId(fileId);
				fileVO.setFilePosition(originalPath + pFileName[i]); //baonk 02-09-2018
				fileVO.setFolderName(folder.getFolderName1());

				// 파일 답글 처리
				if (isReply) {
					if (parentFile != null) {
						fileVO.setDepth(parentFile.getDepth() + 1);
						fileVO.setRootId(parentFile.getRootId());
						fileVO.setParentId(parentId);
						fileVO.setHierarchicalPath(parentFile.getHierarchicalPath() + "." + fileId);
					}
				} else {
					fileVO.setDepth(1);
					fileVO.setRootId(fileId);
					fileVO.setParentId(fileId);
					fileVO.setHierarchicalPath(fileId);
				}
				
				fileId = String.valueOf(insertFile(fileVO));
				fileVO.setFileId(fileId);
				
				// 답글이 아닐 때만 권한 넣어주기
				if (!isReply) {
					Map<String,Object> map = new HashMap<String, Object>();
					map.put("targetId", fileId);
					map.put("upperFolderId", folder.getFolderId());
					map.put("tenantId", tenantId);
					map.put("type_f", "F");
					ezWebFolderAdminService.insertFolderUser(map);
				}
				
				// 첫번째 버전은 무조건 생성하도록 한다.
				incrementFileVersion(userInfo, fileVO.getFileId());
				list.add(fileVO);
				
				fileVO.setFileTypeName(fileType.getTypeName());
				
				saveLog("C", companyId, offset, userId, userName1, userName2, tenantId, fileVO, "", userInfo.getPrimary());

				if (isEncryptionFolder || isEncrypt) {
					insertEncryptedFile(fileVO.getFileId(), tenantId);
				}
			} else {
				failureList.add(new ExtensionErrorFile(pFileName[i], ".none".equals(extend) ? "" : extend));
			}
		}
		
		result.setSuccessFiles(list);
		result.setFailureList(failureList);

		return result;
	}

	@Override
	public void getDownloadedFiles(String[] folderIdList, String[] fileIDList, String realPath, LoginVO userInfo, String userAgent, HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		String userName1 = userInfo.getDisplayName1();
		String userName2 = userInfo.getDisplayName2();
		String offset = userInfo.getOffset();
		String userId = userInfo.getId();
		String deptId = userInfo.getDeptID();
		String companyId = userInfo.getCompanyID();
		int tenantId = userInfo.getTenantId();

		if (fileIDList.length == 1 && folderIdList.length == 0) {
			String fileId = fileIDList[0];

			if ("fail".equalsIgnoreCase(ezWebFolderService_y.checkPermission(userId, deptId, companyId, fileId, "F", tenantId))) {
				throw new IllegalAccessException("has no permission. fileId: " + fileId);
			}

			FileVO fileVO = getFileByFileId(fileId, offset, tenantId);
			String _fileName = fileVO.getFileName();
			_fileName = CommonUtil.getEncodedFileNameForDownload(userAgent, _fileName);
			File file = new File(realPath + commonUtil.detectPathTraversal(fileVO.getFilePath()));

			if (!file.isFile()) {
				throw new FileNotFoundException(fileVO.getFileName());
			}

			BufferedInputStream in = null;

			try {
				in = new BufferedInputStream(new FileInputStream(file));
				Path path = Paths.get(realPath + commonUtil.detectPathTraversal(fileVO.getFilePath()));
				String mimetype = Files.probeContentType(path);
				//String mimetype = "application/octet-stream";

				response.setBufferSize(BUFF_SIZE);
				response.setContentType(mimetype);
				response.setHeader("Content-Disposition", "attachment; filename=\"" + _fileName + "\"");
				response.setContentLength((int) file.length());

				FileCopyUtils.copy(in, response.getOutputStream());
			} finally {
				if (in != null) {
					try {
						in.close();
					} catch (Exception ignore) {
						logger.debug("IGNORED: {}", ignore.getMessage());
					}
				}
			}

			response.getOutputStream().flush();
			response.getOutputStream().close();

			updateDownCnt(fileVO.getFileId(), tenantId);
			saveLog("D", companyId, offset, userId, userName1, userName2, tenantId, fileVO, "", userInfo.getPrimary());
		} else {
			SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
			Date today = new Date();
			String fileName = "webfolder_download_" + formatter.format(today) + ".zip";
			ZipOutputStream zipOutputStream = null;

			try {
				//Setting headers
				response.setStatus(HttpServletResponse.SC_OK);
				response.addHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"");
				response.setContentType("application/zip");
				zipOutputStream = new ZipOutputStream(response.getOutputStream());
				HashSet<String> nameList = new HashSet<>();
				HashSet<String> folderNameList = new HashSet<>();

				//Package files
				for (int i = 0; i < fileIDList.length; i++) {
					String fileId = fileIDList[i];

					if ("fail".equalsIgnoreCase(ezWebFolderService_y.checkPermission(userId, userInfo.getDeptID(), companyId, fileId, "F", tenantId))) {
						logger.debug("has no permission. fileId: {}", fileId);
						continue;
					}

					//New zip entry and copying input stream with file to zipOutputStream, after all closing streams
					FileVO fileVO = getFileByFileId(fileId, offset, tenantId);
					File file = new File(realPath + commonUtil.detectPathTraversal(fileVO.getFilePath()));

					if (!file.isFile()) {
						throw new FileNotFoundException(fileVO.getFileName());
					}

					String zFileName = fileVO.getFileName();

					if (!nameList.contains(zFileName)) {
						nameList.add(zFileName);
					} else {
						int pos = zFileName.lastIndexOf(".");
						String extend = zFileName.substring(pos + 1);
						String mainName = zFileName.substring(0, pos);
						int k = 1;
						zFileName = mainName + "(" + Integer.toString(k) + ")." + extend;

						while (nameList.contains(zFileName)) {
							zFileName = mainName + "(" + Integer.toString(++k) + ")." + extend;
						}

						nameList.add(zFileName);
					}

					zipOutputStream.putNextEntry(new ZipEntry(zFileName));
					// CWE-404 보안 취약점 대응
					try (FileInputStream fileInputStream = new FileInputStream(file)) {
						IOUtils.copy(fileInputStream, zipOutputStream);
					}
					zipOutputStream.closeEntry();

					updateDownCnt(fileVO.getFileId(), tenantId);
					saveLog("D", companyId, offset, userId, userName1, userName2, tenantId, fileVO, "", userInfo.getPrimary());
				}

				//Package folders
				for (int i = 0; i < folderIdList.length; i++) {
					packFolder(folderNameList, folderIdList[i], "", zipOutputStream, userName1, userName2, offset, userInfo.getPrimary(), userId, deptId, companyId, realPath, tenantId);
				}
			} catch (Exception e) {
				throw e;
			} finally {
				if (zipOutputStream != null) {
					try {
						zipOutputStream.closeEntry();
					} catch (Exception e) {logger.debug("e.message=" + e.getMessage());}
					try {
						zipOutputStream.close();
					} catch (Exception e) {logger.debug("e.message=" + e.getMessage());}
				}
			}
		}
	}
	
	@SuppressWarnings("unused")
	private void packFolder(HashSet<String> folderNameList, String folderId, String path, ZipOutputStream zipOutputStream,
			String userName1, String userName2, String offset, String primary,
			String userId, String deptId, String companyId, String realPath, int tenantId) throws Exception {

		// 권한 검사
		if ("fail".equalsIgnoreCase(ezWebFolderService_y.checkPermission(userId, deptId, companyId, folderId, "D", tenantId))) {
			logger.debug("has no permission. folderId: {}", folderId);
			return;
		}

		HashSet<String> inernameList    = new HashSet<>();
		FolderVO folder                 = getFolderByFolderId(folderId, offset, tenantId);
		List<FolderVO> listSubFolder    = getAllSubFolders(folderId, offset, tenantId);
		List<FileVO> filesInFolder      = getAllFilesInFolder("", "", folderId, "", "0", "", "", "", "", "", "1", 0, 0, primary, 
				offset, tenantId, "", "");
		String folderName               = primary.equals("1") ? folder.getFolderName1() : folder.getFolderName2();
		
		if (!folderNameList.contains(folderName)) {
			folderNameList.add(folderName);
		}
		else {
			int k           = 1;
			String mainName = folderName;
			folderName      = folderName + "(" + Integer.toString(k) + ")";
			
			while (folderNameList.contains(folderName)) {
				folderName = mainName + "(" + Integer.toString(++k) + ")";
			}
			
			folderNameList.add(folderName);
		}
		
		String newPath = path + folderName + commonUtil.separator;
		
		zipOutputStream.putNextEntry(new ZipEntry(newPath));
		zipOutputStream.closeEntry();
		
		for (FileVO innerFile : filesInFolder) {
			if ("fail".equalsIgnoreCase(ezWebFolderService_y.checkPermission(userId, deptId, companyId, innerFile.getFileId(), "F", tenantId))) {
				logger.debug("has no permission. fileId: {}", innerFile.getFileId());
				continue;
			}

			File file = new File(realPath + commonUtil.detectPathTraversal(innerFile.getFilePath()));
			
			if (!file.isFile()) {
				throw new FileNotFoundException(innerFile.getFileName());
			}
			
			String zFileName = innerFile.getFileName();
			
			if (!inernameList.contains(zFileName)) {
				inernameList.add(zFileName);
			}
			else {
				int pos         = zFileName.lastIndexOf(".");
				String extend   = zFileName.substring(pos + 1);
				String mainName = zFileName.substring(0, pos);
				int k           = 1;
				zFileName       = mainName + "(" + Integer.toString(k) + ")." + extend;
				
				while (inernameList.contains(zFileName)) {
					zFileName = mainName + "(" + Integer.toString(++k) + ")." + extend;
				}
				
				inernameList.add(zFileName);
			}
			
			zipOutputStream.putNextEntry(new ZipEntry(newPath + zFileName));
			// CWE-404 보안 취약점 대응
			try (FileInputStream fileInputStream = new FileInputStream(file)) {			
				IOUtils.copy(fileInputStream, zipOutputStream);
			}
			zipOutputStream.closeEntry();
			
			updateDownCnt(innerFile.getFileId(), tenantId);
			saveLog("D", companyId, offset, userId, userName1, userName2, tenantId, innerFile, "", primary);
		}
		
		if (listSubFolder.size() > 0) {
			HashSet<String> subfolderNameList = new HashSet<>();
			for (FolderVO innerfolder : listSubFolder) {
				packFolder(subfolderNameList, innerfolder.getFolderId(), newPath, zipOutputStream, userName1, userName2, offset, primary, userId, deptId, companyId, realPath, tenantId);
			}
		}
	}
	
	@Override
	public boolean canDelete(String[] fileIdList, String[] folderIdList, String userId, int tenantId) throws Exception {
		FolderVO userRootFolder = getRootFolderId(userId, "U", "000|+00:00", tenantId);
		String userRootPath = userRootFolder.getFolderPath();

		UserCapacityVO userCapacity = ezWebFolderAdminService.getCapacity(userId, "U", "1", tenantId);
		double totalUsed = Double.parseDouble(userCapacity.getTotalUsed());
		double totalCapacity = Double.parseDouble(userCapacity.getTotalCapacity()) * 1_073_741_824;
		double allowedSize = totalCapacity - totalUsed;
		double deleteTotalSize = 0;

		if (fileIdList != null) {
			for (String fileId : fileIdList) {
				if (fileId == null || fileId.isEmpty() || fileId.equals("-1")) {
					continue;
				}

				FileVO file = getFileByFileId(fileId, "000|+00:00", tenantId);
				FolderVO folder = getFolderByFolderId(file.getFolderId(), "000|+00:00", tenantId);

				if (folder.getFolderPath().startsWith(userRootPath)) {
					continue;
				}

				if (allowedSize < (deleteTotalSize += file.getFileSize())) {
					return false;
				}
			}
		}

		if (folderIdList == null || (folderIdList.length == 1 && folderIdList[0].equals("-1"))) {
			return true;
		}

		for (String folderId : folderIdList) {
			if (folderId == null || folderId.isEmpty() || folderId.equals("-1")) {
				continue;
			}

			FolderVO folder = getFolderByFolderId(folderId, "000|+00:00", tenantId);
			String folderPath = folder.getFolderPath();

			if (folderPath.startsWith(userRootPath)) {
				continue;
			}

			if (allowedSize < (deleteTotalSize += ezWebFolderAdminService.getFolderSize(folderPath, tenantId))) {
				return false;
			}
		}

		return true;
	}

	@Override
	public void deleteSelectedFiles(String[] fileIDList, LoginVO userInfo) throws Exception {
		String userName1 = userInfo.getDisplayName1();
		String userName2 = userInfo.getDisplayName2();
		String companyId = userInfo.getCompanyID();
		int tenantId     = userInfo.getTenantId();
		String offset    = userInfo.getOffset();
		String userId    = userInfo.getId();
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Date date                  = new Date();
		String timeUTC             = commonUtil.getDateStringInUTC(formatter.format(date), offset, true);
		
		for (String fileId : fileIDList) {
			if (containsReplyFile(fileId, tenantId)) {
				logger.error("답변 파일을 포함하고 있으면 삭제할 수 없습니다, fileId: {}", fileId);
				continue;
			}

			FileVO fileVO = getFileByFileId(fileId, offset, tenantId);
			
			//ezWebFolderService.deleteFileByFileId(fileIDList[i], loginSimpleVO.getTenantId());
			updateFileUseStatus(userId, fileId, timeUTC, tenantId);
			saveLog("R", companyId, offset, userId, userName1, userName2, tenantId, fileVO, "", userInfo.getPrimary());
		}
	}
	
	@Override
	public String deleteSelectedFilesFolders (String[] fileIDList, String[] folderIDList ,LoginVO userInfo) throws Exception {
		String userName1 = userInfo.getDisplayName1();
		String userName2 = userInfo.getDisplayName2();
		String companyId = userInfo.getCompanyID();
		int tenantId     = userInfo.getTenantId();
		String offset    = userInfo.getOffset();
		String userId    = userInfo.getId();
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Date date                  = new Date();
		String timeUTC             = commonUtil.getDateStringInUTC(formatter.format(date), offset, true);
		
		String returnStr = "OK"; // OK, OK_M_REPLY(다중삭제 중 답글파일 포함), OK_REPLY(단일삭제 중 답글파일 포함)
		int replyFileCnt = 0;
		
		if (fileIDList[0] != null && !fileIDList[0].isEmpty() && !fileIDList[0].equals("-1")) {
			for (String fileId : fileIDList) {
				if (containsReplyFile(fileId, tenantId)) {
					logger.error("답변 파일을 포함하고 있으면 삭제할 수 없습니다, fileId: {}", fileId);
					replyFileCnt++;
					continue;
				}

				FileVO fileVO = getFileByFileId(fileId, offset, tenantId);
				
				//ezWebFolderService.deleteFileByFileId(fileIDList[i], loginSimpleVO.getTenantId());
				updateFileUseStatus(userId, fileId, timeUTC, tenantId);
				saveLog("R", companyId, offset, userId, userName1, userName2, tenantId, fileVO, "", userInfo.getPrimary());
			}
		}
		
		if (folderIDList[0] != null && !folderIDList[0].isEmpty() && !folderIDList[0].equals("-1")) {
			for ( int i = 0; i < folderIDList.length; i++ ) {
				ezWebFolderService_y.deleteSubFldAFile(folderIDList[i], tenantId, companyId, userId, timeUTC, userInfo.getRollInfo());
			}
		}
		
		returnStr = replyFileCnt > 0 ? fileIDList.length > 1 ? "OK_M_REPLY" : "OK_REPLY" : returnStr;
		logger.debug("returnStr=" + returnStr + ", replyFileCnt=" + replyFileCnt);
		return returnStr;
	}
	
	public String getWebFolderDirPath(int tenantId) {
		return commonUtil.getUploadPath("upload_webfolder.ROOT", tenantId) + commonUtil.separator;
	}
	
	@Override
	public synchronized String getMaxFileID(int tenantId) throws Exception {
//		int currentMaxFileId = -1;
//		String result        = getFileSequence(tenantId);
//		currentMaxFileId     = result.equals("")        ? 10000000 : Integer.parseInt(result);
//		currentMaxFileId     = (currentMaxFileId == -1) ? 10000000 : (currentMaxFileId + 1);
//		return Integer.toString(currentMaxFileId);
		return "";
	}
	
	@Override
	public String getFolderPath(String[] path, String primary, int tenantId) throws Exception {
		String result = "";
		
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("path",     Arrays.asList(path));
		map.put("primary",  primary);
		map.put("tenantId", tenantId);
		
		List<String> folderNames = ezWebFolderDAO.getFolderNameList(map);
		result                   = String.join("/", folderNames);
		result                   = result + "/";
		
		return result;
	}
	
	@Override
	public void saveLog(String type, String companyId, String offset, String userId, String userName1, String userName2,
			String filename, long fileSize, String fileExt, String fileType, int tenantId) throws Exception {
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Date date                  = new Date();
		String timeUTC             = commonUtil.getDateStringInUTC(formatter.format(date), offset, true);
		
		//Save log to database
		FileLogVO fileLog = new FileLogVO();
		
		fileLog.setLogType(type);
		fileLog.setCompanyId(companyId);
		fileLog.setCreateDate(timeUTC);
		fileLog.setCreateId(userId);
		fileLog.setCreateName1(userName1);
		fileLog.setCreateName2(userName2);
		fileLog.setFileName(filename);
		fileLog.setFileSize(fileSize);
		fileLog.setFileExt(fileExt);
		fileLog.setFileType(fileType);
		fileLog.setLogId(getMaxLogID(tenantId));
		fileLog.setTenantId(tenantId);
		ezWebFolderAdminService.insertFileLog(fileLog);
	}

	@Override
	public void saveLog(String type, String companyId, String offset,
			String userId, String userName1, String userName2, int tenantId,
			FileVO fileVO, String version, String primary) throws Exception {
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Date date                  = new Date();
		String timeUTC             = commonUtil.getDateStringInUTC(formatter.format(date), offset, true);
		
		//Save log to database
		FileLogVO fileLog = new FileLogVO();
		fileLog.setLogType(type);
		fileLog.setCompanyId(companyId);
		fileLog.setCreateDate(timeUTC);
		fileLog.setCreateId(userId);
		fileLog.setCreateName1(userName1);
		fileLog.setCreateName2(userName2);
		fileLog.setFileName(fileVO.getFileName());
		fileLog.setFileSize(fileVO.getFileSize());
		fileLog.setFileExt(fileVO.getFileExt());
		fileLog.setFileType(fileVO.getFileTypeName());
		fileLog.setLogId(getMaxLogID(tenantId));
		fileLog.setTenantId(tenantId);
		fileLog.setFileId(fileVO.getFileId());

		if (StringUtils.isEmpty(version)){
			Map<String, Object> map = new HashMap<>();

			map.put("fileId", fileVO.getFileId());
			map.put("modifierUserId", userId);
			map.put("offset", commonUtil.getMinuteUTC(offset));
			map.put("tenantId", tenantId);
	
			int latestVersion = ezWebFolderDAO.getCurrentVersion(map);
			version = Integer.toString(latestVersion);
		} 
		
		logger.debug("version:" + version );
		FolderVO folder          = getFolderByFolderId(fileVO.getFolderId(), offset, tenantId);
		String folderPath 		 = "";
		String folderPathName 	 = "";
		String folderId 		 = "";
		String folderName		 = "";
		String topFolderId		 = "";
		String topFolderName	 = "";
		
		if (folder != null){
			folderPath 		= folder.getFolderPath();
			folderPathName 	= getFolderPath(folderPath.split("\\|"), primary, tenantId);
			folderId 		= folder.getFolderId();
			folderName 		= folder.getFolderName1();
			
			if (folder.getFolderLevel() == 0){
				topFolderId = folderId;
				topFolderName 	= folderName;
			} else {
				topFolderId 	= folderPath.split("\\|")[2];
				topFolderName 	= folderPathName.split("\\/")[1];
			}
		}
		
		fileLog.setVersion(version);
		fileLog.setFolderId(folderId);
		fileLog.setFolderName(folderName);
		
		fileLog.setFolderPath(folderPath);
		fileLog.setFolderPathName(folderPathName);
		fileLog.setTopFolderId(topFolderId);
		fileLog.setTopFolderName(topFolderName);
		ezWebFolderAdminService.insertFileLog(fileLog);
		
	}
	
	private String getMaxLogID(int tenantId) throws Exception {
		int currentMaxLogId = -1;
		String result       = getFileLogSequence(tenantId);
		currentMaxLogId     = result.equals("")       ? 1 : Integer.parseInt(result);
		currentMaxLogId     = (currentMaxLogId == -1) ? 1 : (currentMaxLogId + 1);
		return Integer.toString(currentMaxLogId);
	}

	@Override
	public JSONObject moveFiles(String folderId, String fileList, String mode, String privileges, LoginVO userInfo, boolean isOverwritable) throws Exception {
		// 기존 파일 이동
		return moveFiles(folderId, fileList, null, mode, privileges, userInfo, isOverwritable);
	}
	
	@Override
	public JSONObject moveFiles(String folderId, String fileListStr, List<String> nameList, String mode, String privileges, LoginVO userInfo, boolean isOverwritable) throws Exception {
		Map<String, Object> result = new HashMap<>();

		String userName1 = userInfo.getDisplayName1();
		String userName2 = userInfo.getDisplayName2();
		String companyId = userInfo.getCompanyID();
		String userId = userInfo.getId();
		String offset = userInfo.getOffset();
		int tenantId = userInfo.getTenantId();
		String filesForQuery = ("'" + fileListStr + "'").replace(",", "','");
		
		String realPath = servletContext.getRealPath("");
		
		// id 배열에서 vo 리스트로 변경
		String[] fileIdArray = fileListStr.split(",");
		List<FileVO> fileList = new ArrayList<>(fileIdArray.length);
		
		for (String fileId : fileIdArray) {
			fileList.add(getFileByFileId(fileId, offset, tenantId));
		}
		
		int totalFiles = fileList.size();
		boolean useRename = nameList != null;
		
		// nameList 변수는 널 허용이지만, nameList 크기랑 fileIdList 크기가 다르면 파라미터 에러 반환
		if (totalFiles == 0 || (useRename && totalFiles != nameList.size())) {
			logger.debug("Parameter error!");
			result.put("status", "error");
			result.put("code", 1);
			
			return new JSONObject(result);
		}
		
		// 파일 중복 처리
		List<DuplicateInfoVO> duplicateList = new ArrayList<>();
		List<DuplicateInfoVO> overwriteList = new ArrayList<>();

		boolean isMove = mode.equals("move");
		
		// move 타입이고, 어드민이 아닐 때 자기 파일인지 확인
		// 카이스트 커스터마이징 건으로 본인체크 삭제
		/* if (isMove && privileges.equals("normal") && checkFilesOwner(userId, filesForQuery, tenantId) != totalFiles) {
			logger.debug("Privileges!");
			result.put("status", "error");
			result.put("code", 5);
			
			return new JSONObject(result);
		} */
		
		// 중복되지 않은 정상 파일 리스트
		List<FileVO> normalFileList = new ArrayList<>(fileList);
		ListIterator<FileVO> normalFileIterator = normalFileList.listIterator();
		int index = -1;
		
		// 반복문을 돌면서 중복되는 파일을 걸러냄
		while (normalFileIterator.hasNext()) {
			FileVO file = normalFileIterator.next();
			index++;

			// 답변이 포함된 파일은 이동할 수 없음, 그냥 리스트에서 삭제해주고 무시하도록 하자. 어차피 프론트에서 막을거니깐 ㅎ
			// 단, 하위에 답변 파일이 없는 마지막 답변 파일은 이동할 수 있다. 그게 맞는거같다.
			if (isMove && containsReplyFile(file.getFileId(), tenantId)) {
				logger.error("답변이 포함된 파일은 이동할 수 없습니다, fileId: {}, fileName: {}", file.getFileId(), file.getFileName());
				normalFileIterator.remove();
				continue;
			}
			
			if (isNotInheritFolder(file.getFolderId(), tenantId)) {
				logger.error("권한 비상속 폴더 내의 파일 및 폴더는 이동/복사할 수 없습니다, fileId: {}, fileName: {}", file.getFileId(), file.getFileName());
				normalFileIterator.remove();
				continue;
			}

			if (!isMove && isEncryptedFile(file.getFileId(), tenantId)
					&& !userId.equalsIgnoreCase(file.getCreateId())) {
				logger.debug("암호화 된 파일은 복사할 수 없습니다. fileId: {}, fileName: {}", file.getFileId(), file.getFileName());
				normalFileIterator.remove();
				continue;
			}

			// 이름바꾸기를 사용한다면 새 이름으로 설정해줌
			if (useRename) {
				// 확장자 붙이기
				file.setFileName(nameList.get(index) +  "." + file.getFileExt());
			}
			
			// 새 이름(useRename)이나, 기존 이름으로 중복 정보를 쿼리
			Optional<DuplicateInfoVO> firstInfo = getAllDuplicateInfoForRename(Type.FILE, file.getFileId(), file.getFileName(), folderId, offset, tenantId)
					.stream()
					.findFirst();

			// 중복되는 게 있다면
			if (firstInfo.isPresent()) {
				DuplicateInfoVO info = firstInfo.get();
				// 파일 리스트에서 삭제
				normalFileIterator.remove();

				// 덮어쓰기가 가능한 파일은 덮어쓰기 리스트에 추가
				if (isOverwritable && info.isAllFiles()) {
					overwriteList.add(info);
				} else {
					// 중복 리스트에 추가
					if (info.getOldType() == Type.FILE) {
						String status = ezWebFolderService_y.checkPermission(userId, userInfo.getDeptID(),
								userInfo.getCompanyID(), info.getOldId(), "F", userInfo.getTenantId());
						info.setAccessible("ok".equalsIgnoreCase(status));
					}

					duplicateList.add(info);
				}
			}
		}
		
		boolean useVersionHistory = "YES".equalsIgnoreCase(ezCommonService.getTenantConfig("useWebfolderVersionHistory", userInfo.getTenantId()));
		boolean isEncryptionFolder = isEncryptionFolder(folderId, tenantId);

		// 덮어쓰기 파일은 따로 처리
		for (DuplicateInfoVO info : overwriteList) {
			FileVO newFile = getFileByFileId(info.getNewId(), offset, tenantId);
			FileVO oldFile = getFileByFileId(info.getOldId(), offset, tenantId);
			
			// file_size, update_date 업데이트
			SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			String currentTimeUTC = commonUtil.getDateStringInUTC(formatter.format(new Date()), offset, true);
			String createTimeUTC = commonUtil.getDateStringInUTC(formatter.format(formatter.parse(oldFile.getCreateDate())), offset, true);

			boolean isEncryptedNewFile = isEncryptedFile(newFile.getFileId(), tenantId);
			boolean isEncryptedOldFile = isEncryptedFile(oldFile.getFileId(), tenantId);
			// 복사되는 곳이 암호화 폴더거나, 원래 파일이 암호화 파일이고 덮어쓰는 파일이 일반 파일일 때 암호화를 한다.
			boolean requireEncryption = (isEncryptionFolder || isEncryptedOldFile) && !isEncryptedNewFile;
			String newPath = getWebFolderDirPath(userInfo.getTenantId()) + webfolderUtil.generateFilePath(oldFile.getFileExt());

			oldFile.setCreateDate(createTimeUTC);
			oldFile.setUpdateDate(currentTimeUTC);
			oldFile.setFileSize(newFile.getFileSize());
			oldFile.setFilePath(newPath);

			String newFileId = newFile.getFileId();
			newFile.setFileId(String.valueOf(insertFile(oldFile)));

			// Backup the previous history file and insert the new history
			if (useVersionHistory) {
				incrementFileVersion(userInfo, oldFile.getFileId());
			}

			Path sourcePath = Paths.get(servletContext.getRealPath(commonUtil.detectPathTraversal(newFile.getFilePath())));
			Path destPath = Paths.get(servletContext.getRealPath(commonUtil.detectPathTraversal(newPath)));

			Files.createDirectories(destPath.getParent());

			if (requireEncryption) {
				byte[] bytes = commonUtil.readBytesFromFile(sourcePath);
				commonUtil.writeBytesToFile(destPath, kilbUtil.encrypt(bytes));
			} else {
				Files.copy(sourcePath, destPath, StandardCopyOption.REPLACE_EXISTING);
			}

			if (isEncryptionFolder || isEncryptedNewFile || isEncryptedOldFile) {
				insertEncryptedFile(oldFile.getFileId(), tenantId);
			}
			
			// move 라면 원본 파일 삭제
			if (isMove) {
				// use status 부터 T로 바꾸고
				updateFileUseStatus(userId, newFileId, currentTimeUTC, tenantId);
				// 영구삭제
				ezWebFolderService_m.permanetDeleteSelectedFiles(new String[] {newFileId}, new String[0], userInfo, realPath, "");
			}
			
			saveLog("WR", companyId, offset, userId, userName1, userName2, tenantId, oldFile, "", userInfo.getPrimary());
		}
		
		// 중복되지 않은 정상 파일에 대한  move 또는 copy 작업
		if (isMove) {
			UserCapacityVO userCapacity = ezWebFolderAdminService.getCapacity(folderId, userInfo.getPrimary(), userInfo.getTenantId());
			
			double totalUsed = Double.parseDouble(userCapacity.getTotalUsed());
			double totalCapa = Double.parseDouble(userCapacity.getTotalCapacity()) * 1073741824;
			
			if (normalFileList.stream().mapToLong(FileVO::getFileSize).sum() > (totalCapa - totalUsed)) {
				logger.debug("Not enough storage to move/copy these files!");
				result.put("status", "error");
				result.put("code", 4);
				
				return new JSONObject(result);
			}
			
			for (FileVO file : normalFileList) {
				boolean isEncryptedFile = isEncryptedFile(file.getFileId(), tenantId);

				if (useRename) {
					// 새 이름으로 이동
					moveRenameFile(file.getFileId(), folderId, file.getFileName(), tenantId);
					incrementFileVersion(userInfo, file.getFileId());
				} else {
					// 기존 이름으로 이동
					moveFile(file.getFileId(), folderId, tenantId);
				}
				
				if (isEncryptionFolder && !isEncryptedFile) {
					Path sourcePath = Paths.get(servletContext.getRealPath(commonUtil.detectPathTraversal(file.getFilePath())));

					byte[] bytes = commonUtil.readBytesFromFile(sourcePath);
					commonUtil.writeBytesToFile(sourcePath, kilbUtil.encrypt(bytes));

					insertEncryptedFile(file.getFileId(), tenantId);
				} else if (useRename && isEncryptedFile) {
					insertEncryptedFile(file.getFileId(), tenantId);
				}

				saveLog("MV", companyId, offset, userId, userName1, userName2, tenantId, file, "", userInfo.getPrimary());
			}
		} else if (fileList.size() > 0) {
			// 중복된게 있으면 filesForQuery 갱신
			if (duplicateList.size() > 0) {
				filesForQuery = fileList.stream().map(FileVO::getFileId).collect(Collectors.joining("', '", "'", "'"));
			}
			
			//copy files
			//Check upload conditions
			double totalUploadSize = getTotalFilesSize(filesForQuery, tenantId);
			UserCapacityVO userCapacity = ezWebFolderAdminService.getCapacity(folderId, userInfo.getPrimary(), userInfo.getTenantId());
			
			double totalUsed = Double.parseDouble(userCapacity.getTotalUsed());
			double totalCapa = Double.parseDouble(userCapacity.getTotalCapacity()) * 1073741824;
			
			if (totalUploadSize > (totalCapa - totalUsed)) {
				logger.debug("Not enough storage to move/copy these files!");
				result.put("status", "error");
				result.put("code", 4);
				
				return new JSONObject(result);
			}
			
			SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			Date date                  = new Date();
			String timeUTC             = commonUtil.getDateStringInUTC(formatter.format(date), offset, true);
			
			for (FileVO fileVO : normalFileList) {
				String oldFileId = fileVO.getFileId();
				String fileId = getMaxFileID(tenantId);

				fileVO.setFolderId(folderId);
				fileVO.setFileId(fileId);
				fileVO.setCreateDate(timeUTC);
				fileVO.setCreateId(userId);
				fileVO.setCreateName1(userName1);
				fileVO.setCreateName2(userName2);
				fileVO.setUpdateId(userId);
				fileVO.setUpdateDate(timeUTC);
				fileVO.setDepth(1);
				fileVO.setRootId(fileId);
				fileVO.setParentId(fileId);
				fileVO.setHierarchicalPath(fileId);
				fileVO.setDownloadCnt(0);
				
				String fileName = fileVO.getFileName();
				int dotPos      = fileName.lastIndexOf('.');
				String extend   = dotPos == -1 ? ".none" : commonUtil.detectPathTraversal(fileName.substring(dotPos + 1));
				String newName  = webfolderUtil.generateFilePath(extend);
				String newPath  = getWebFolderDirPath(userInfo.getTenantId()) + newName;
				File srcFile    = new File(realPath + commonUtil.detectPathTraversal(fileVO.getFilePath()));
				File destFile   = new File(realPath + newPath);
				destFile.getParentFile().mkdirs();
				destFile.createNewFile();
				
				fileVO.setFilePath(newPath);
				fileId = String.valueOf(insertFile(fileVO));
				fileVO.setFileId(fileId);
				
				Map<String, Object> map = new HashMap<String, Object>();
				map.put("upperId", oldFileId);
				map.put("targetId", fileId);
				map.put("tenantId", userInfo.getTenantId());
				map.put("type_f", "F");
				map.put("copyType", "copy");
				ezWebFolderAdminService.insertFolderUser(map);
				incrementFileVersion(userInfo, fileVO.getFileId());
				
				boolean isEncryptedFile = isEncryptedFile(oldFileId, tenantId);
				boolean requireKlibTransformation = isEncryptionFolder && !isEncryptedFile;

				if (requireKlibTransformation) {
					byte[] bytes = commonUtil.readBytesFromFile(srcFile.toPath());
					commonUtil.writeBytesToFile(destFile.toPath(), kilbUtil.encrypt(bytes));
				} else {
					FileUtils.copyFile(srcFile, destFile);
				}

				if (requireKlibTransformation || isEncryptedFile) {
					insertEncryptedFile(fileId, tenantId);
				}

				saveLog("CP", companyId, offset, userId, userName1, userName2, tenantId, fileVO, "", userInfo.getPrimary());
			}
		}
		
		if (isOverwritable || duplicateList.isEmpty()) {
			result.put("code", 0);
		} else {
			// 덮어쓰기 가능한 순서로 정렬
			duplicateList.sort(null);

			result.put("code", 8);
			result.put("duplicateInfoArray", duplicateList);
		}
		
		result.put("status", "ok");
		
		return new JSONObject(result);
	}
	

	@Override
	public JSONObject moveFolders(String folderList, String destFolderId, String mode, String privileges, LoginVO userInfo) throws Exception {
		Map<String, Object> result = new HashMap<>();
		List<DuplicateInfoVO> duplicateInfoList = new ArrayList<>();
		List<Object> errorList = new ArrayList<>();
		result.put("status", "ok");
		result.put("code", 0);

		if (folderList == null || folderList.isEmpty()) {
			return new JSONObject(result);
		}

		String[] folderIdList = folderList.split(",");

		String offset = userInfo.getOffset();
		int tenantId = userInfo.getTenantId();
		int code;

		forStatement: for (String folderId : folderIdList) {
			// 이미 중복된 이름의 폴더라면 중복 리스트에 넣기 및 건너뛰기
			if (duplicateInfoList.addAll(getAllDuplicateInfo(Type.DIRECTORY, folderId, destFolderId, offset, tenantId))) {
				continue;
			}

			FolderVO folder = getFolderByFolderId(folderId, offset, tenantId);

			process: {
				FolderVO destFolder = getFolderByFolderId(destFolderId, offset, tenantId);

				// 같은 폴더인지는 js 단에서 처리함
				// Check copy/move conditions
				// if (folder.getFolderUpper().equals(destFolderId)) {
				// code = 4;
				// break trial;
				// }

				int pos = destFolder.getFolderPath().indexOf(folder.getFolderPath());

				if (pos != -1) {
					code = 5;
					break process;
				}

				String realPath = servletContext.getRealPath("");
				ezWebFolderAdminService.moveCompanyFolder(folder, destFolder, mode, realPath, userInfo, "user");

				continue forStatement;
			}

			// 에러 처리
			Map<String, Object> errorMap = new HashMap<>();
			errorMap.put("folder", folder);
			errorMap.put("status", "error");
			errorMap.put("code", code);
			errorList.add(errorMap);
		}

		if (errorList.size() > 0) {
			result.put("folderErrorArray", errorList);
		}

		if (duplicateInfoList.size() > 0) {
			result.put("duplicateInfoArray", duplicateInfoList);
			result.put("code", 8);
		}

		return new JSONObject(result);
	}

	@Override
	public double getTotalFilesSize(String fileList, int tenantId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("fileList",  fileList);
		map.put("tenantId", tenantId);
		return ezWebFolderDAO.getTotalFilesSize(map);
	}

	@Override
	public Map<String, String> getAllFolderNameMap(List<String> testbnk, String primary, int tenantId) {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("testbnk",  testbnk);
		map.put("primary",  primary);
		map.put("tenantId", tenantId);
		
		Map<String, String> result = new LinkedHashMap<String, String>();
		Map<String, String> temp = ezWebFolderDAO.getAllFolderNameMap(map);
		
		for (Map.Entry<String, String> entry : temp.entrySet()) {
			result.put(String.valueOf(entry.getKey()), entry.getValue());
		}
		
		return result;
	}

	@Override
	public List<String> getFolderListFromFileId(List<String> fileIds, int tenantId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("fileIds",  fileIds);
		map.put("tenantId", tenantId);
		
		return ezWebFolderDAO.getFolderListFromFileId(map);
	}
	
	@Override
	public List<FolderSimpleVO> getAllSimpleShareFolder(String userId, String deptId, String compId, int tenantId) throws Exception {
		List<Map<String, String>> idList = ezWebFolderService_m.getPermissionIdMapList(userId, deptId, compId, tenantId);
		
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("userId", userId);
		map.put("idList", idList);
		map.put("compId", compId);
		map.put("tenantId", tenantId);
		
		return ezWebFolderDAO.getAllSimpleShareFolder(map);
	}

	@Override
	public void updateFileExt(String fileId, String newFilePath, String fileExt, String realFileExt, String timeUTC, int tenantId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("fileId",   fileId);
		map.put("filePath",   newFilePath);
		map.put("fileExt",     fileExt);
		map.put("realFileExt", realFileExt);
		map.put("tenantId", tenantId);
		map.put("timeUTC", timeUTC);
		
		ezWebFolderDAO.updateFileExt(map);
		
	}

	@Override
	public void insertEncryptionFolder(String folderId, int tenantId) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("folderId", folderId);
		map.put("tenantId", tenantId);

		ezWebFolderDAO.insertEncryptionFolder(map);
		// ezWebFolderDAO.deleteAllChildrenEncryptionFolder(map);
	}

	@Override
	public void deleteEncryptionFolder(String folderId, int tenantId) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("folderId", folderId);
		map.put("tenantId", tenantId);

		ezWebFolderDAO.deleteEncryptionFolder(map);
	}

	@Override
	public void insertEncryptedFile(String fileId, int tenantId) {
		logger.debug("insertEncryptedFile: {}", fileId);
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("fileId", fileId);
		map.put("tenantId", tenantId);

		ezWebFolderDAO.insertEncryptedFile(map);
	}

	@Override
	public void deleteEncryptedLatestVersion(String fileId, int tenantId) {
		logger.debug("deleteEncryptedLatestVersion: {}", fileId);
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("fileId", fileId);
		map.put("tenantId", tenantId);

		ezWebFolderDAO.deleteEncryptedLatestVersion(map);
	}

	@Override
	public void deleteEncryptedAllVersions(String fileId, int tenantId) {
		logger.debug("deleteEncryptedAllVersions: {}", fileId);
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("fileId", fileId);
		map.put("tenantId", tenantId);

		ezWebFolderDAO.deleteEncryptedAllVersions(map);
	}

	@Override
	public void deleteEncryptedVersion(String fileId, int version, int tenantId) {
		logger.debug("deleteEncryptedVersion: {}, version: {}", fileId, version);
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("fileId", fileId);
		map.put("tenantId", tenantId);

		ezWebFolderDAO.deleteEncryptedVersion(map);
	}

	@Override
	public FolderVO getEncryptionRootFolder(String folderId, int tenantId) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("folderId", folderId);
		map.put("tenantId", tenantId);

		return ezWebFolderDAO.getEncryptionRootFolder(map);
	}

	@Override
	public boolean isEncryptionFolder(String folderId, int tenantId) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("folderId", folderId);
		map.put("tenantId", tenantId);

		return ezWebFolderDAO.isEncryptionFolder(map);
	}

	@Override
	public boolean isEncryptedFile(String fileId, int tenantId) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("fileId", fileId);
		map.put("tenantId", tenantId);

		return ezWebFolderDAO.isEncryptedFile(map);
	}

	@Override
	public boolean isEncryptedVersion(String fileId, int version, int tenantId) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("fileId", fileId);
		map.put("version", version);
		map.put("tenantId", tenantId);

		return ezWebFolderDAO.isEncryptedVersion(map);
	}

	@Override
	public boolean isEncryptedFilePath(String filePath) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("filePath", filePath);

		return ezWebFolderDAO.isEncryptedFilePath(map);
	}

	@Override
	public List<FileHistoryVO> getFileHistories(String fileId, String offset, int tenantId) throws Exception {
		Map<String, Object> map = new HashMap<>();
		map.put("fileId", fileId);
		map.put("offset", commonUtil.getMinuteUTC(offset));
		map.put("tenantId", tenantId);

		return ezWebFolderDAO.getFileHistories(map);
	}

	@Override
	public FileHistoryVO getFileHistory(String fileId, int version, String offset, int tenantId) throws Exception {
		Map<String, Object> map = new HashMap<>();
		map.put("fileId", fileId);
		map.put("version", version);
		map.put("offset", commonUtil.getMinuteUTC(offset));
		map.put("tenantId", tenantId);

		return ezWebFolderDAO.getFileHistory(map);
	}

	// 2022-11-18 이사라 - 웹폴더 파일 이름변경 시 원본 파일을 삭제하지 않도록 수정
	@Override
	public void incrementFileVersion(LoginVO user, String fileId) throws Exception {
		incrementFileVersion(user, fileId, true);
	}

	@Override
	public void incrementFileVersion(LoginVO user, String fileId, boolean isdel) throws Exception {
		Map<String, Object> map = new HashMap<>();

		map.put("fileId", fileId);
		map.put("modifierUserId", user.getId());
		map.put("offset", commonUtil.getMinuteUTC(user.getOffset()));
		map.put("tenantId", user.getTenantId());

		FileHistoryVO latestHistory = ezWebFolderDAO.getLatestHistory(map);
		int latestVersion = ezWebFolderDAO.getCurrentVersion(map);
		int nextVersion;

		// 예전 버전기록의 파일을 history 폴더로 백업한다.
		if (latestHistory != null && latestVersion == latestHistory.getVersion()) {
			String newFilePath = copyFileVersionToNewFile(latestHistory, HISTORY_FOLDER, user.getTenantId());

			map.put("version", latestVersion);
			map.put("filePath", newFilePath);

			ezWebFolderDAO.updateFilePathHistory(map);

			nextVersion = latestVersion + 1;

			// db 업데이트 성공시 기존 파일 delete
			File file = new File(servletContext.getRealPath(commonUtil.detectPathTraversal(latestHistory.getFilePath())));

			if (file.exists() && file.isFile() && isdel) {
				if (file.delete()) {
					logger.debug("delete success.");
				}
			} else {
				logger.debug("the file doesn't exists or is renamed only.");
			}

		} else {
			nextVersion = 1;
		}

		logger.debug("incrementFileVersion - latestVersion: {}, lastestHistory: {}, nextVersion: {}",
				latestVersion, latestHistory, nextVersion);

		map.put("version", nextVersion);
		ezWebFolderDAO.insertFileHistory(map);

		// 최초 업로드가 아니라면 버전을 하나 올린다.
		if (nextVersion > 1) {
			ezWebFolderDAO.updateCurrentFileVersion(map);
		}
	}

	@Override
	public void deleteFileVersion(LoginVO user, String fileId, int version) throws Exception {
		Map<String, Object> map = new HashMap<>();
		map.put("fileId", fileId);
		map.put("version", version);
		map.put("deleteUserId", user.getId());
		map.put("tenantId", user.getTenantId());
		ezWebFolderDAO.deleteFileVersion(map);

		FileVO fileVO = getFileByFileId(fileId, user.getOffset(), user.getTenantId()); 
		
		saveLog("R", user.getCompanyID(), user.getOffset(), user.getId(), user.getDisplayName1(), user.getDisplayName2(),
				user.getTenantId(), fileVO, Integer.toString(version), user.getPrimary());
		
	}

	@Override
	public void revertFileVersion(LoginVO user, String fileId, int version) throws Exception {
		String offset = user.getOffset();
		int tenantId = user.getTenantId();
		FileHistoryVO targetHistory = getFileHistory(fileId, version, offset, tenantId);
		FileVO file = getFileByFileId(fileId, offset, tenantId);

		Objects.requireNonNull(targetHistory, "has no version. fileId: " + fileId + ", version: " + version);
		Objects.requireNonNull(file, "has no file. fileId: " + fileId);

		logger.debug("revertFileVersion - fileId: {}, version: {}", fileId, version);

		boolean isEncryptionFolder = isEncryptionFolder(file.getFolderId(), tenantId);
		boolean isEncryptedVersion = isEncryptedVersion(fileId, version, tenantId);
		boolean isEncryptedLatestVersion = isEncryptedFile(fileId, tenantId);

		boolean requireEncryption = (isEncryptionFolder || isEncryptedLatestVersion) && !isEncryptedVersion;

		String currentTimeUTC = commonUtil.getTodayUTCTime("");
		String newFilePath = copyFileVersionToNewFile(targetHistory, "", tenantId);

		Map<String, Object> map = new HashMap<String, Object>();

		map.put("filePath", newFilePath);
		map.put("userId", user.getId());
		map.put("fileId", fileId);
		map.put("tenantId", tenantId);
		map.put("timeUTC", currentTimeUTC);
		map.put("fileSize", targetHistory.getFileSize());
		map.put("fileName", targetHistory.getFileName());

		// 새로운 filePath로 경로 생성 및 db 업데이트
		ezWebFolderDAO_y.updateFileRealData(map);

		// 파일 버전 증가
		incrementFileVersion(user, fileId);

		if (requireEncryption) {
			String realPath = servletContext.getRealPath("");
			Path path = Paths.get(realPath, newFilePath);
			byte[] encryptedBytes = klibUtil.encrypt(commonUtil.readBytesFromFile(path));

			commonUtil.writeBytesToFile(path, encryptedBytes);
		}

		if (isEncryptionFolder || isEncryptedVersion || isEncryptedLatestVersion) {
			insertEncryptedFile(fileId, user.getTenantId());
		}

		FileVO fileVO = getFileByFileId(fileId, offset, tenantId);

		saveLog("WR", user.getCompanyID(), offset, user.getId(), user.getDisplayName1(), user.getDisplayName2(),
				tenantId, fileVO, "", user.getPrimary());
	}

	@Override
	public boolean restoreFileVersionFromTrash(LoginVO user, String fileId, int version) throws Exception {
		FileVO file = getFileByFileId(fileId, user.getOffset(), user.getTenantId());

		// 원래 파일이 휴지통에 없어야 복원이 가능합니다.
		// 원래 파일이 휴지통에 있다면 복원 실패(false)를 반환합니다.
		boolean canRestore = "Y".equals(file.getUseStatus());

		if (canRestore) {
			Map<String, Object> map = new HashMap<>();

			map.put("fileId", fileId);
			map.put("version", version);
			map.put("tenantId", user.getTenantId());

			ezWebFolderDAO.restoreFileVersionFromTrash(map);
		}
		FileVO fileVO = getFileByFileId(fileId, user.getOffset(), user.getTenantId()); 

		saveLog("RE", user.getCompanyID(), user.getOffset(), user.getId(), user.getDisplayName1(), user.getDisplayName2(),
				user.getTenantId(), fileVO, Integer.toString(version), user.getPrimary());

		return canRestore;
	}

	/**
	 * @return 복사된 위치
	 */
	private String copyFileVersionToNewFile(FileHistoryVO history, String subFolder, int tenantId) throws Exception {
		String realPath = servletContext.getRealPath("");
		String webfolderDir = getWebFolderDirPath(tenantId);

		String filePath = history.getFilePath();
		String fileExt = FilenameUtils.getExtension(filePath);

		String newHashPath = webfolderUtil.generateFilePath(fileExt);
		String newFilePath = webfolderDir + subFolder + newHashPath;

		Path source = Paths.get(realPath, filePath);
		Path dest = Paths.get(realPath, newFilePath);
		Path destFolder = dest.getParent();

		if (Files.notExists(destFolder)) {
			Files.createDirectories(destFolder);
		}

		Files.copy(source, dest);

		logger.debug("copyFileVersionToNewFile - source: {}, dest: {}", source, dest);

		return newFilePath;
	}

	@Override
	public void deletePermanetlyFileHistory(String fileId, int version, int tenantId, LoginVO userInfo) throws Exception {
		Map<String, Object> map = new HashMap<>();
		map.put("fileId", fileId);
		map.put("version", version);
		map.put("tenantId", tenantId);

		map.put("offset", "0");

		FileHistoryVO history = ezWebFolderDAO.getFileHistory(map);
		String realPath = servletContext.getRealPath("");
		String path = history.getFilePath();

		if (path.contains(HISTORY_FOLDER)) {
			try {
				Files.deleteIfExists(Paths.get(realPath, path));
			} catch (IOException e) {
				logger.error(e.getMessage(), e);
			}
		}

		ezWebFolderDAO.deletePermanetlyFileHistory(map);
		FileVO fileVO = getFileByFileId(fileId, userInfo.getOffset(), userInfo.getTenantId()); 

		saveLog("P", userInfo.getCompanyID(), userInfo.getOffset(), userInfo.getId(), userInfo.getDisplayName1(), userInfo.getDisplayName2(),
				userInfo.getTenantId(), fileVO, Integer.toString(version), userInfo.getPrimary());
		
	}

	@Override
	public void deletePermanetlyFileHistories(String fileId, int tenantId) {
		Map<String, Object> map = new HashMap<>();
		map.put("fileId", fileId);
		map.put("tenantId", tenantId);

		map.put("offset", "0");

		String realPath = servletContext.getRealPath("");

		for (FileHistoryVO history : ezWebFolderDAO.getFileHistories(map)) {
			String path = history.getFilePath();

			if (path.contains(HISTORY_FOLDER)) {
				try {
					Files.deleteIfExists(Paths.get(realPath, path));
				} catch (IOException e) {
					logger.error(e.getMessage(), e);
				}
			}
		}

		ezWebFolderDAO.deletePermanetFileHistories(map);
	}

	@Override
	public void getDownloadedVersions(String fileId, int[] versions, LoginVO user, String userAgent, HttpServletRequest request, HttpServletResponse response) throws Exception {
		if (versions == null || versions.length == 0) {
			response.sendError(403, "versions must not be null or empty.");
			return;
		}

		if (versions.length > 1) {
			response.sendError(403, "Do not download multiple versions!");
			return;
		}

		String offset = user.getOffset();
		int version = versions[0];
		int tenantId = user.getTenantId();
		FileVO fileVO = getFileByFileId(fileId, offset, tenantId);
		boolean isEncrypted = isEncryptedVersion(fileId, version, tenantId);
		boolean isCreator = fileVO.getCreateId().equals(user.getId());

		if (isEncrypted && !isCreator) {
			response.sendError(403, "Encrypted file cannot be downloaded!");
			return;
		}

		String fileName = fileVO.getFileName();
		String realPath = servletContext.getRealPath("");

		FileHistoryVO history = getFileHistory(fileId, version, offset, tenantId);
		String versionName = FilenameUtils.getBaseName(fileName)
				+ " (" + version + ".0)."
				+ FilenameUtils.getExtension(fileName);
		String downloadName = CommonUtil.getEncodedFileNameForDownload(userAgent, versionName);
		File file = new File(realPath + commonUtil.detectPathTraversal(history.getFilePath()));

		try {
			response.setBufferSize(BUFF_SIZE);
			response.setContentType("application/octet-stream");
			response.setHeader("Content-Disposition", "attachment; filename=\"" + downloadName + "\"");

			long contentLength;

			if (isEncrypted) {
				byte[] decryptedBytes = klibUtil.decrypt(commonUtil.readBytesFromFile(file.toPath()));
				IOUtils.write(decryptedBytes, response.getOutputStream());
				contentLength = decryptedBytes.length;
				decryptedBytes = null;
			} else {
				Files.copy(file.toPath(), response.getOutputStream());
				contentLength = file.length();
			}

			response.setHeader("Content-Length", Long.toString(contentLength));
		} catch (Exception ex) {
			throw ex;
		} finally {
			response.getOutputStream().flush();
			response.getOutputStream().close();
		}

		fileVO.setFileName(fileName + " (" + version + ".0)");
		fileVO.setFileSize(history.getFileSize());

		saveLog("D", user.getCompanyID(), user.getOffset(), user.getId(),
				user.getDisplayName1(), user.getDisplayName2(), tenantId, fileVO, Integer.toString(version), user.getPrimary());
		return;
	}
	
	// 20201126 김수아 : 웹폴더 구성원 이메일 리스트
	@Override
	public String getStringListOfWebFolderMembers(int tenantId, String webFolderId) throws Exception {
		logger.debug("getStringListOfWebFolderMembers started. tenantId=" + tenantId + ", webFolderId=" + webFolderId);
		
		String mailList = "";
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("folderId", webFolderId);
		
		List<OrganUserVO> userList = ezWebFolderDAO.getWebFolderMembers(map);
		
		logger.debug("userList Size=" + userList.size());
		
		if (userList.size() > 0) {
			for (OrganUserVO user : userList) {
				String temp = user.getDisplayName() + " <" + user.getMail() + ">";
				mailList += temp + ",";
			}
			
			mailList.substring(0, mailList.length() - 1);
		}
        
        logger.debug("getStringListOfWebFolderMembers ended.");
        return mailList;
	}

	@Override
	public boolean containsReplyFile(String fileId, int tenantId) {
		Map<String, Object> map = new HashMap<>();
		map.put("fileId", fileId);
		map.put("tenantId", tenantId);

		return ezWebFolderDAO.containsReplyFile(map);
	}

	@Override
	public List<String> getContainsReplyFiles(String folderId, int tenantId) {
		Map<String, Object> map = new HashMap<>();
		map.put("folderId", folderId);
		map.put("tenantId", tenantId);

		return ezWebFolderDAO.getContainsReplyFiles(map);
	}

	@Override
	public List<String> getContainsReplyFiles(List<String> fileIds, int tenantId) {
		Objects.requireNonNull(fileIds, "fileIds must not be null");

		if (fileIds.isEmpty()) {
			return Collections.emptyList();
		}

		Map<String, Object> map = new HashMap<>();
		map.put("fileIds", fileIds);
		map.put("tenantId", tenantId);

		return ezWebFolderDAO.getContainsReplyFiles(map);
	}

	@Override
	public int checkFileUserExists(String userId, String fileId) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userId", userId);
		map.put("fileId", fileId);
		return ezWebFolderDAO.checkFileUserExists(map);
	}
	
	@Override
	public int checkFolderUserExists(String userId, String folderId, Boolean manager) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userId", userId);
		map.put("folderId", folderId);
		map.put("manager", manager == true ? 1 : 0);
		return ezWebFolderDAO.checkFolderUserExists(map);
	}

	@Override
	public List<String> getNotInheritFolders(int tenantId) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("tenantId", tenantId);

		return ezWebFolderDAO.getNotInheritFolders(map);
	}

	@Override
	public boolean isNotInheritFolder(String folderId, int tenantId) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("folderId", folderId);
		map.put("tenantId", tenantId);

		return ezWebFolderDAO.isNotInheritFolder(map);
	}

	@Override
	public boolean containsNotInheritFolder(String[] fileIds, String[] folderIds, int tenantId) throws Exception {
		Set<String> distinctFolderIds = new HashSet<>(Arrays.asList(folderIds));

		distinctFolderIds.addAll(getFolderListFromFileId(Arrays.asList(fileIds), tenantId));

		for (String folderId : distinctFolderIds) {
			if (isNotInheritFolder(folderId, tenantId)) {
				return true;
			}
		}

		return false;
	}

	@Override
	public void insertNotInheritFolder(String folderId, int tenantId) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("folderId", folderId);
		map.put("tenantId", tenantId);

		ezWebFolderDAO.insertNotInheritFolder(map);
	}

	@Override
	public void deleteNotInheritFolder(String folderId, int tenantId) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("folderId", folderId);
		map.put("tenantId", tenantId);

		ezWebFolderDAO.deleteNotInheritFolder(map);
	}
}