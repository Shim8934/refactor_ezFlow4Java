package egovframework.ezEKP.ezWebFolder.service.impl;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.ListIterator;
import java.util.Locale;
import java.util.Map;
import java.util.Optional;
import java.util.Set;
import java.util.UUID;
import java.util.stream.Collectors;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

import javax.annotation.Resource;
import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.io.FileUtils;
import org.apache.commons.io.IOUtils;
import org.apache.commons.lang3.StringUtils;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.multipart.MultipartFile;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.service.EgovFileMngUtil;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.ezEKP.ezOrgan.vo.OrganDeptVO;
import egovframework.ezEKP.ezWebFolder.dao.EzWebFolderDAO;
import egovframework.ezEKP.ezWebFolder.service.EzWebFolderAdminService;
import egovframework.ezEKP.ezWebFolder.service.EzWebFolderService;
import egovframework.ezEKP.ezWebFolder.service.EzWebFolderService_m;
import egovframework.ezEKP.ezWebFolder.service.EzWebFolderService_y;
import egovframework.ezEKP.ezWebFolder.vo.DuplicateInfoVO;
import egovframework.ezEKP.ezWebFolder.vo.DuplicateInfoVO.Type;
import egovframework.ezEKP.ezWebFolder.vo.FileLogVO;
import egovframework.ezEKP.ezWebFolder.vo.FileTypeVO;
import egovframework.ezEKP.ezWebFolder.vo.FileVO;
import egovframework.ezEKP.ezWebFolder.vo.FolderSimpleVO;
import egovframework.ezEKP.ezWebFolder.vo.FolderUserVO;
import egovframework.ezEKP.ezWebFolder.vo.FolderVO;
import egovframework.ezEKP.ezWebFolder.vo.SimpleDeptVO;
import egovframework.ezEKP.ezWebFolder.vo.SimpleUserVO;
import egovframework.ezEKP.ezWebFolder.vo.UserCapacityVO;
import egovframework.ezEKP.ezWebFolder.vo.WebfolderEnvVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;

@Service("EzWebFolderService")
public class EzWebFolderServiceImpl extends EgovFileMngUtil implements EzWebFolderService {
	@Resource(name = "EzWebFolderDAO")
	private EzWebFolderDAO ezWebFolderDAO;
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private EzWebFolderAdminService ezWebFolderAdminService;
	
	@Autowired
	private EzWebFolderService_m ezWebFolderService_m;
	
	@Autowired
	private EzWebFolderService_y ezWebFolderService_y;
	
	@Autowired
	private EzCommonService ezCommonService;
	
	@Autowired
	private EzOrganService ezOrganService;
	
	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;
	
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
	public void insertFile(FileVO fileVO) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("fileId",      fileVO.getFileId());
		map.put("fileName",    fileVO.getFileName());
		map.put("filePath",    fileVO.getFilePath());
		map.put("fileSize",    fileVO.getFileSize());
		map.put("typeId",      fileVO.getTypeId());
		map.put("downloadCnt", fileVO.getDownloadCnt());
		map.put("fileExt",     fileVO.getFileExt());
		map.put("folderId",    fileVO.getFolderId());
		map.put("useStatus",   fileVO.getUseStatus());
		map.put("createId",    fileVO.getCreateId());
		map.put("createName1", fileVO.getCreateName1());
		map.put("createName2", fileVO.getCreateName2());
		map.put("createDate",  fileVO.getCreateDate().substring(0, 19));
		map.put("updateId",    fileVO.getUpdateId());
		map.put("updateDate",  fileVO.getUpdateDate().substring(0, 19));
		map.put("deleterId",   fileVO.getDeleterId());
		map.put("tenantId",    fileVO.getTenantId());
		
		ezWebFolderDAO.insertFile(map);
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
	public List<FolderSimpleVO> getAllSimpleSubFolders(String folderUpperId, int tenantId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("folderUpper", folderUpperId);
		map.put("tenantId",    tenantId);
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
	public String getFolderUserSequence(int tenantId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("tenantId", tenantId);
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
		List<FileVO> listFiles = getAllFilesInFolder("", "", folder.getFolderId(), "", "0", "", "", "", "", "", "1", 0, 0, userInfo.getPrimary(), userInfo.getOffset(), userInfo.getTenantId());
		
		for (FileVO file : listFiles) {
			saveLog("R", userInfo.getCompanyID(), userInfo.getOffset(), userInfo.getId(), userInfo.getDisplayName1(), userInfo.getDisplayName2(), file.getFileName(), file.getFileSize(), file.getFileExt(), file.getFileTypeName(), userInfo.getTenantId());
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
	}
	
//	@Override
//	public List<FileVO> getDuplicateNameFiles(List<String> fileNames, String parentFolderId, String offset, int tenantId) throws Exception {
//	Map<String, Object> sqlParams = new HashMap<>();
//
//	sqlParams.put("fileNames", fileNames);
//	sqlParams.put("parentFolderId", parentFolderId);
//	sqlParams.put("offset", offset);
//		sqlParams.put("tenantId", tenantId);
//
//		return ezWebFolderDAO.getDuplicateNameFiles(sqlParams);
//	}
//	
//	@Override
//	public List<FolderVO> getDuplicateNameFolders(List<String> folderNames, String parentFolderId, String offset, int tenantId) throws Exception {
//		Map<String, Object> sqlParams = new HashMap<>();
//
//	sqlParams.put("folderNames", folderNames);
//	sqlParams.put("parentFolderId", parentFolderId);
//	sqlParams.put("offset", offset);
//	sqlParams.put("tenantId", tenantId);
//
//	return ezWebFolderDAO.getDuplicateNameFolders(sqlParams);
//}

@Override
public List<DuplicateInfoVO> getAllDuplicateInfo(String fileName, String targetFolderId, String offset, int tenantId) throws Exception {
	Map<String, Object> sqlParams = new HashMap<>();
	
	sqlParams.put("fileName", fileName);
	sqlParams.put("targetFolderId", targetFolderId);
	sqlParams.put("offset", offset);
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
		sqlParams.put("offset", offset);
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
	public List<FileVO> getAllFilesInFolder(String realColmn, String order, String folderId, String originalPath, String searchChk, String startDate, String endDate, String fileExt, String fileName, String userName, String fileType, int startPoint, int pageSize, String primary, String offset, int tenantId) throws Exception {
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
		return ezWebFolderDAO.getAllFilesInFolder(map);
	}

	@Override
	public List<FileVO> getAllFiles(String realColmn, String order, String folderPath, String originalPath, String searchChk, String startDate, String endDate, String fileExt, String fileName,	String userName, String fileType, int startPoint, int pageSize,	String primary, String offset, int tenantId) throws Exception {
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
		if (company.getHasSubFolder() == 1) {
			List<FolderSimpleVO> listSubSimpleFolders = getAllSimpleSubFolders(company.getFolderId(), tenantId);
			company.setListSubFolders(listSubSimpleFolders);
			
			if (mode == 0) {
				for (FolderSimpleVO subFolder: listSubSimpleFolders) {
					getAllSubDepts(subFolder, tenantId, mode);
				}
			}
		}
	}

	@Override
	public void getAllSubDepts(FolderSimpleVO company, int tenantId, String[] fdPath, int order) throws Exception {
		if (company.getHasSubFolder() == 1) {
			List<FolderSimpleVO> listSubSimpleFolders = getAllSimpleSubFolders(company.getFolderId(), tenantId);
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
	public void getAllDepts(SimpleDeptVO sDept, String[] path, String primary, int tenantId, int order, int level) throws Exception {
		if (sDept.getHasSub().equals("1")) {
			List<SimpleDeptVO> listSubSimpleDepts = getAllSimpleSubDepts(sDept.getDeptId(), level, primary, tenantId);
			sDept.setSubDepts(listSubSimpleDepts);
			
			for (SimpleDeptVO subDept: listSubSimpleDepts) {
				if (order < path.length && subDept.getDeptId().equals(path[order])) {
					getAllDepts(subDept, path, primary, tenantId, order + 1, level + 1);
				}
			}
		}
	}

	private List<SimpleDeptVO> getAllSimpleSubDepts(String deptId, int level, String primary, int tenantId) {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("deptId",     deptId);
		map.put("primary",    primary);
		map.put("level",      level);
		map.put("tenantId",   tenantId);
		
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
	public List<SimpleUserVO> getDeptMemberList(String deptId, String primary, int tenantId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("deptId",     deptId);
		map.put("primary",    primary);
		map.put("tenantId",   tenantId);
		
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
				
				ezWebFolderAdminService.insertFolder2(folder);
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
	public List<FolderSimpleVO> getCompanySubSimpleFolder(String userId, String deptId, String compFolderId, String compId, int tenantId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("userId",    userId);
		map.put("deptId",    deptId);
		map.put("compFolderId", compFolderId);
		map.put("tenantId",  tenantId);
		map.put("compId",  compId);
		
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
	public List<FileVO> saveUploadedFiles(List<MultipartFile> multiFileLists, JSONArray nameArray, FolderVO folder, String realPath, LoginVO userInfo) throws Exception {
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
				
				if (_pFileName.indexOf(commonUtil.separator) > 0) {
					_pFileName = _pFileName.split("/")[_pFileName.split("/").length - 1];
				}
				
				pFileName[i] = _pFileName;
			}
		}
		
		String pDirPath = getWebFolderDirPath(tenantId);
		pDirPath        = realPath + pDirPath;
		
		if (!pDirPath.substring(pDirPath.length() - 1).equals(commonUtil.separator)) {
			pDirPath = pDirPath + commonUtil.separator;
		}
		
		File file = new File(pDirPath);
		
		if (!file.exists()) {
			file.mkdir();
		}
		
		List<FileVO> list = new ArrayList<FileVO>();
		
		for (int i = 0; i < cnt; i++) {
			fileSize[i]    = multiFileLists.get(i).getSize();
			int dotPos     = pFileName[i].lastIndexOf(".");
			String extend  = dotPos == -1 ? ".none" : pFileName[i].substring(dotPos + 1);
			String newName = UUID.randomUUID().toString() + "." + extend;
			
			if (extend.length() >= 10) {
				extend = ".etc";
			}
			
			if (useExtension.toLowerCase().contains(extend.toLowerCase()) || useExtension.equals("*")) {
				writeUploadedFile(multiFileLists.get(i), newName, pDirPath);
				FileTypeVO fileType = getFileTypeByFileExt(extend.toLowerCase(), tenantId);
				
				if (fileType == null) {
					fileType = getFileTypeByFileExt("unknown", tenantId);
				}
				
				Date date      = new Date();
				FileVO fileVO  = new FileVO();
				String timeUTC = commonUtil.getDateStringInUTC(formatter.format(date), offset, true);
				
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
				fileVO.setFileId(getMaxFileID(tenantId));
				fileVO.setFilePosition(originalPath + pFileName[i]); //baonk 02-09-2018
				
				insertFile(fileVO);
				list.add(fileVO);
				
				saveLog("C", companyId, offset, userId, userName1, userName2, fileVO.getFileName(), fileVO.getFileSize(), fileVO.getFileExt(), fileType.getTypeName(), tenantId);
			}
		}
		
		return list;
	}

	@Override
	public void getDownloadedFiles(String[] folderIdList, String[] fileIDList, String realPath, LoginVO userInfo, String userAgent, HttpServletRequest request, HttpServletResponse response) throws Exception {
		String userName1 = userInfo.getDisplayName1();
		String userName2 = userInfo.getDisplayName2();
		String offset    = userInfo.getOffset();
		String userId    = userInfo.getId();
		String companyId = userInfo.getCompanyID();
		int tenantId     = userInfo.getTenantId();
		
		if (fileIDList.length == 1 && folderIdList.length == 0) {
			FileVO fileVO    = getFileByFileId(fileIDList[0], offset, tenantId);
			String _fileName = fileVO.getFileName();
			_fileName        = CommonUtil.getEncodedFileNameForDownload(userAgent, _fileName);
			File file        = new File(realPath + fileVO.getFilePath());
			
			if (!file.exists()) {
				throw new FileNotFoundException(fileVO.getFileName());
			}
		
			if (!file.isFile()) {
				throw new FileNotFoundException(fileVO.getFileName());
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
			}
			
			response.getOutputStream().flush();
			response.getOutputStream().close();
			
			updateDownCnt(fileVO.getFileId(), tenantId);
			saveLog("D", companyId, offset, userId, userName1, userName2, fileVO.getFileName(), fileVO.getFileSize(), fileVO.getFileExt(), fileVO.getFileTypeName(), tenantId);
		}
		else {
			SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
			Date today = new Date();
			String fileName                     = "webfolder_download_" + formatter.format(today) + ".zip";
			ZipOutputStream zipOutputStream = null;
			FileInputStream fileInputStream = null;
			
			try {
				//Setting headers
				response.setStatus(HttpServletResponse.SC_OK);
				response.addHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"");
				zipOutputStream                = new ZipOutputStream(response.getOutputStream());
				HashSet<String> nameList       = new HashSet<>();
				HashSet<String> folderNameList = new HashSet<>();
				
				//Package files
				for (int i = 0; i < fileIDList.length; i++) {
					//New zip entry and copying input stream with file to zipOutputStream, after all closing streams
					FileVO fileVO    = getFileByFileId(fileIDList[i], offset, tenantId);
					File file        = new File(realPath + fileVO.getFilePath());
					
					if (!file.exists()) {
						throw new FileNotFoundException(fileVO.getFileName());
					}
					
					if (!file.isFile()) {
						throw new FileNotFoundException(fileVO.getFileName());
					}
					
					String zFileName = fileVO.getFileName();
					
					if (!nameList.contains(zFileName)) {
						nameList.add(zFileName);
					}
					else {
						int pos         = zFileName.lastIndexOf(".");
						String extend   = zFileName.substring(pos + 1);
						String mainName = zFileName.substring(0, pos);
						int k           = 1;
						zFileName       = mainName + "(" + Integer.toString(k) + ")." + extend;
						
						while (nameList.contains(zFileName)) {
							zFileName = mainName + "(" + Integer.toString(++k) + ")." + extend;
						}
						
						nameList.add(zFileName);
					}
					
					zipOutputStream.putNextEntry(new ZipEntry(zFileName));
					fileInputStream = new FileInputStream(file);
					
					IOUtils.copy(fileInputStream, zipOutputStream);
					
					fileInputStream.close();
					zipOutputStream.closeEntry();
					
					updateDownCnt(fileVO.getFileId(), tenantId);
					saveLog("D", companyId, offset, userId, userName1, userName2, fileVO.getFileName(), fileVO.getFileSize(), fileVO.getFileExt(), fileVO.getFileTypeName(), tenantId);
				}
				
				//Package folders
				for (int i = 0; i < folderIdList.length; i++) {
					packFolder(folderNameList, folderIdList[i], "", zipOutputStream, userName1, userName2, offset, userInfo.getPrimary(), userId, companyId, realPath, tenantId);
				}
				
				zipOutputStream.close();
			}
			catch (Exception e) {
				throw e;
			}
			finally {
				if (fileInputStream != null) {
					try { fileInputStream.close(); } catch (Exception e) {}
				}
				
				if (zipOutputStream != null) {
					try { zipOutputStream.closeEntry(); } catch (Exception e) {}
					try { zipOutputStream.close(); } catch (Exception e) {}
				}
			}
		}
	}
	
	private void packFolder(HashSet<String> folderNameList, String folderId, String path, ZipOutputStream zipOutputStream, String userName1, String userName2, String offset, String primary, String userId, String companyId, String realPath, int tenantId) throws Exception {
		FileInputStream fileInputStream = null;
		HashSet<String> inernameList    = new HashSet<>();
		FolderVO folder                 = getFolderByFolderId(folderId, offset, tenantId);
		List<FolderVO> listSubFolder    = getAllSubFolders(folderId, offset, tenantId);
		List<FileVO> filesInFolder      = getAllFilesInFolder("", "", folderId, "", "0", "", "", "", "", "", "1", 0, 0, primary, offset, tenantId);
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
			File file = new File(realPath + innerFile.getFilePath());
			
			if (!file.exists()) {
				throw new FileNotFoundException(innerFile.getFileName());
			}
			
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
			fileInputStream = new FileInputStream(file);
			
			IOUtils.copy(fileInputStream, zipOutputStream);
			
			fileInputStream.close();
			zipOutputStream.closeEntry();
			
			updateDownCnt(innerFile.getFileId(), tenantId);
			saveLog("D", companyId, offset, userId, userName1, userName2, innerFile.getFileName(), innerFile.getFileSize(), innerFile.getFileExt(), innerFile.getFileTypeName(), tenantId);
		}
		
		if (listSubFolder.size() > 0) {
			HashSet<String> subfolderNameList = new HashSet<>();
			for (FolderVO innerfolder : listSubFolder) {
				packFolder(subfolderNameList, innerfolder.getFolderId(), newPath, zipOutputStream, userName1, userName2, offset, primary, userId, companyId, realPath, tenantId);
			}
		}
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
		
		for (int i = 0; i < fileIDList.length; i++) {
			FileVO fileVO = getFileByFileId(fileIDList[i], offset, tenantId);
			
			//ezWebFolderService.deleteFileByFileId(fileIDList[i], loginSimpleVO.getTenantId());
			updateFileUseStatus(userId, fileIDList[i], timeUTC, tenantId);
			saveLog("R", companyId, offset, userId, userName1, userName2, fileVO.getFileName(), fileVO.getFileSize(), fileVO.getFileExt(), fileVO.getFileTypeName(), tenantId);
		}
	}
	
	@Override
	public void deleteSelectedFilesFolders (String[] fileIDList, String[] folderIDList ,LoginVO userInfo) throws Exception {
		String userName1 = userInfo.getDisplayName1();
		String userName2 = userInfo.getDisplayName2();
		String companyId = userInfo.getCompanyID();
		int tenantId     = userInfo.getTenantId();
		String offset    = userInfo.getOffset();
		String userId    = userInfo.getId();
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Date date                  = new Date();
		String timeUTC             = commonUtil.getDateStringInUTC(formatter.format(date), offset, true);
		
		if (!fileIDList[0].equals("-1")) {
			for (int i = 0; i < fileIDList.length; i++) {
				FileVO fileVO = getFileByFileId(fileIDList[i], offset, tenantId);
				
				//ezWebFolderService.deleteFileByFileId(fileIDList[i], loginSimpleVO.getTenantId());
				updateFileUseStatus(userId, fileIDList[i], timeUTC, tenantId);
				saveLog("R", companyId, offset, userId, userName1, userName2, fileVO.getFileName(), fileVO.getFileSize(), fileVO.getFileExt(), fileVO.getFileTypeName(), tenantId);
			}
		}
		if (!folderIDList[0].equals("-1")) {
			for ( int i = 0; i < folderIDList.length; i++ ) {
				ezWebFolderService_y.deleteSubFldAFile(folderIDList[i], tenantId, companyId, userId, timeUTC);
			}
		}
	}
	
	public String getWebFolderDirPath(int tenantId) {
		return commonUtil.getUploadPath("upload_webfolder.ROOT", tenantId) + commonUtil.separator;
	}
	
	@Override
	public synchronized String getMaxFileID(int tenantId) throws Exception {
		int currentMaxFileId = -1;
		String result        = getFileSequence(tenantId);
		currentMaxFileId     = result.equals("")        ? 10000000 : Integer.parseInt(result);
		currentMaxFileId     = (currentMaxFileId == -1) ? 10000000 : (currentMaxFileId + 1);
		return Integer.toString(currentMaxFileId);
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
	public void saveLog(String type, String companyId, String offset, String userId, String userName1, String userName2, String filename, long fileSize, String fileExt, String fileType, int tenantId) throws Exception {
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
		String primary = userInfo.getPrimary();
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
		if (isMove && privileges.equals("normal") && checkFilesOwner(userId, filesForQuery, tenantId) != totalFiles) {
			logger.debug("Privileges!");
			result.put("status", "error");
			result.put("code", 4);
			
			return new JSONObject(result);
		}
		
		// 중복되지 않은 정상 파일 리스트
		List<FileVO> normalFileList = new ArrayList<>(fileList);
		ListIterator<FileVO> normalFileIterator = normalFileList.listIterator();
		
		// 반복문을 돌면서 중복되는 파일을 걸러냄
		while (normalFileIterator.hasNext()) {
			int index = normalFileIterator.nextIndex();
			FileVO file = normalFileIterator.next();
			
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
					duplicateList.add(info);
				}
			}
		}
		
		// 덮어쓰기 파일은 따로 처리
		for (DuplicateInfoVO info : overwriteList) {
			FileVO newFile = getFileByFileId(info.getNewId(), offset, tenantId);
			FileVO oldFile = getFileByFileId(info.getOldId(), offset, tenantId);
			
			// update_date 업데이트
			SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			String currentTimeUTC = commonUtil.getDateStringInUTC(formatter.format(new Date()), offset, true);
			
			oldFile.setUpdateDate(currentTimeUTC);

			// db 부터 업데이트
			updateFileName(oldFile.getFileId(), oldFile.getFileName(), currentTimeUTC, tenantId);
			
			// nio gazuaaaaa!!!!!
			Path sourcePath = Paths.get(servletContext.getRealPath(newFile.getFilePath()));
			Path destPath = Paths.get(servletContext.getRealPath(oldFile.getFilePath()));

			// copy file
			Files.copy(sourcePath, destPath, StandardCopyOption.REPLACE_EXISTING);
			
			// move 라면 원본 파일 삭제
			if (isMove) {
				// use status 부터 T로 바꾸고
				updateFileUseStatus(userId, newFile.getFileId(), currentTimeUTC, tenantId);
				// 영구삭제
				ezWebFolderService_m.permanetDeleteSelectedFiles(new String[] {newFile.getFileId()}, new String[0], userInfo, realPath, "");
			}
			
			saveLog("WR", companyId, offset, userId, userName1, userName2, oldFile.getFileName(), oldFile.getFileSize(), oldFile.getFileExt(), oldFile.getFileTypeName(), tenantId);
		}
		
		// 중복되지 않은 정상 파일에 대한  move 또는 copy 작업
		if (isMove) {
			for (FileVO file : normalFileList) {
				if (useRename) {
					// 새 이름으로 이동
					moveRenameFile(file.getFileId(), folderId, file.getFileName(), tenantId);
				} else {
					// 기존 이름으로 이동
					moveFile(file.getFileId(), folderId, tenantId);
				}
				
				saveLog("MV", companyId, offset, userId, userName1, userName2, file.getFileName(), file.getFileSize(), file.getFileExt(), file.getFileTypeName(), tenantId);
			}
		} else if (fileList.size() > 0) {
			// 중복된게 있으면 filesForQuery 갱신
			if (duplicateList.size() > 0) {
				filesForQuery = "'" + String.join("', '", fileList.stream().map(FileVO::getFileName).toArray(String[]::new)) + "'";
			}
			
			//copy files
			//Check upload conditions
			double totalUploadSize = getTotalFilesSize(filesForQuery, tenantId);
			UserCapacityVO userCapacity = ezWebFolderAdminService.getUserCapacity(userId, primary, userInfo.getTenantId());
			
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
				fileVO.setFolderId(folderId);
				fileVO.setFileId(getMaxFileID(tenantId));
				fileVO.setCreateDate(timeUTC);
				fileVO.setCreateId(userId);
				fileVO.setCreateName1(userName1);
				fileVO.setCreateName2(userName2);
				fileVO.setUpdateId(userId);
				fileVO.setUpdateDate(timeUTC);
				
				String fileName = fileVO.getFileName();
				int dotPos      = fileName.lastIndexOf(".");
				String extend   = dotPos == -1 ? ".none" : fileName.substring(dotPos + 1);
				String newName  = UUID.randomUUID().toString() + "." + extend;
				String newPath  = getWebFolderDirPath(userInfo.getTenantId()) + newName;
				File srcFile    = new File(realPath + fileVO.getFilePath());
				File destFile   = new File(realPath  + newPath);
				destFile.getParentFile().mkdirs(); 
				destFile.createNewFile();
				
				FileUtils.copyFile(srcFile, destFile);
				
				fileVO.setFilePath(newPath);
				insertFile(fileVO);
				
				saveLog("CP", companyId, offset, userId, userName1, userName2, fileVO.getFileName(), fileVO.getFileSize(), fileVO.getFileExt(), fileVO.getFileTypeName(), tenantId);
			}
		}
		
		if (isOverwritable || duplicateList.isEmpty()) {
			result.put("code", 0);
		} else {
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

				// 같은 폴더인지는 js 단에서 처리하니까 상관 없을듯
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
				ezWebFolderAdminService.moveCompanyFolder(folder, destFolder, mode, realPath, userInfo);

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
		
		return ezWebFolderDAO.getAllFolderNameMap(map);
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
	
	
}