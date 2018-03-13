package egovframework.ezEKP.ezWebFolder.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.annotation.Resource;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import egovframework.ezEKP.ezOrgan.vo.OrganDeptVO;
import egovframework.ezEKP.ezWebFolder.dao.EzWebFolderDAO;
import egovframework.ezEKP.ezWebFolder.service.EzWebFolderService;
import egovframework.ezEKP.ezWebFolder.vo.FileTypeVO;
import egovframework.ezEKP.ezWebFolder.vo.FileVO;
import egovframework.ezEKP.ezWebFolder.vo.FolderSimpleVO;
import egovframework.ezEKP.ezWebFolder.vo.FolderUserVO;
import egovframework.ezEKP.ezWebFolder.vo.FolderVO;
import egovframework.ezEKP.ezWebFolder.vo.SimpleDeptVO;
import egovframework.ezEKP.ezWebFolder.vo.SimpleUserVO;
import egovframework.let.utl.fcc.service.CommonUtil;

@Service("EzWebFolderService")
public class EzWebFolderServiceImpl implements EzWebFolderService {
	@Resource(name = "EzWebFolderDAO")
	private EzWebFolderDAO ezWebFolderDAO;
	
	@Autowired
	private CommonUtil commonUtil;
	
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
		map.put("createDate",  fileVO.getCreateDate());
		map.put("updateId",    fileVO.getUpdateId());
		map.put("updateDate",  fileVO.getUpdateDate());
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
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("extension", extend);
		map.put("tenantId",  tenantId);
		return ezWebFolderDAO.getFileTypeByFileExt(map);
	}

	@Override
	public void deleteFileByFileId(String fileId, int tenantId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("fileId",   fileId);
		map.put("tenantId", tenantId);
		ezWebFolderDAO.deleteFileByFileId(map);	
	}

	@Override
	public void updateFileUseStatus(String fileId, int tenantId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("fileId",   fileId);
		map.put("tenantId", tenantId);
		ezWebFolderDAO.updateFileUseStatus(map);
	}

	@Override
	public void updateFileName(String fileId, String newName, int tenantId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("fileId",   fileId);
		map.put("name",     newName);
		map.put("tenantId", tenantId);
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
	public String getFileLogSequence(int tenantId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();		
		map.put("tenantId", tenantId);
		return ezWebFolderDAO.getFileLogSequence(map);
	}

	@Override
	public FolderVO getFolderByFolderId(String folderId, String offset, int tenantId) throws Exception {
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
	public FolderVO getCompanyFolderId(String companyId, String offset, int tenantId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("companyId", companyId);
		map.put("tenantId",  tenantId);
		map.put("offset",    commonUtil.getMinuteUTC(offset));
		return ezWebFolderDAO.getCompanyFolderId(map);
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
	public void updateFolderUseStatus(String folderPath, int tenantId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("folderPath", folderPath);
		map.put("tenantId",   tenantId);
		ezWebFolderDAO.updateFolderUseStatus(map);
	}

	@Override
	public List<FileVO> getAllFilesInFolder(String folderId, String originalPath, String searchChk, String startDate, String endDate, String fileExt, String fileName, String userName, String fileType, int startPoint, int pageSize, String primary, String offset, int tenantId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
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
	public List<FileVO> getAllFiles(String folderPath, String originalPath, String searchChk, String startDate, String endDate, String fileExt, String fileName,	String userName, String fileType, int startPoint, int pageSize,	String primary, String offset, int tenantId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
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
	public int getTotalFileCnt(String folderId, String searchChk, String startDate, String endDate, String fileExt, String fileName, String userName, String fileType, int startPoint, int pageSize, String primary, int tenantId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("folderId",   folderId);
		map.put("fileType",   fileType);
		map.put("searchChk",  searchChk);
		map.put("startDate",  startDate);
		map.put("endDate",    endDate);
		map.put("fileExt",    fileExt);
		map.put("fileName",   fileName);
		map.put("userName",   userName);
		map.put("startPoint", startPoint);
		map.put("pageSize",   pageSize);
		map.put("primary",    primary);
		map.put("tenantId",   tenantId);
		return ezWebFolderDAO.getTotalFileCnt(map);
	}

	@Override
	public int getTotalFileCnt2(String folderPath, String searchChk, String startDate, String endDate, String fileExt, String fileName,	String userName, String fileType, int startPoint, int pageSize, String primary, int tenantId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("folderPath", folderPath);
		map.put("fileType",   fileType);
		map.put("searchChk",  searchChk);
		map.put("startDate",  startDate);
		map.put("endDate",    endDate);
		map.put("fileExt",    fileExt);
		map.put("fileName",   fileName);
		map.put("userName",   userName);
		map.put("startPoint", startPoint);
		map.put("pageSize",   pageSize);
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
	public List<FolderSimpleVO> getAllSimpleDeptFolder(String companyId, int tenantId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("companyId",  companyId);
		map.put("tenantId",   tenantId);
		
		return ezWebFolderDAO.getAllSimpleDeptFolder(map);
	}

	@Override
	public List<OrganDeptVO> getAllDepartments(String companyId, String primary, int tenantId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("companyId",  companyId);
		map.put("primary",    primary);
		map.put("tenantId",   tenantId);
		
		return ezWebFolderDAO.getAllDepartments(map);
	}

}