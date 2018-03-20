package egovframework.ezEKP.ezWebFolder.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.annotation.Resource;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import egovframework.ezEKP.ezWebFolder.dao.EzWebFolderAdminDAO;
import egovframework.ezEKP.ezWebFolder.service.EzWebFolderAdminService;
import egovframework.ezEKP.ezWebFolder.vo.FileLogVO;
import egovframework.ezEKP.ezWebFolder.vo.FolderVO;
import egovframework.ezEKP.ezWebFolder.vo.UserCapacityVO;
import egovframework.ezEKP.ezWebFolder.vo.WebfolderConfigVO;
import egovframework.let.utl.fcc.service.CommonUtil;

@Service("EzWebFolderAdminService")
public class EzWebFolderAdminServiceImpl implements EzWebFolderAdminService {
	@Resource(name = "EzWebFolderAdminDAO")
	private EzWebFolderAdminDAO ezWebFolderAdminDAO;
	
	@Autowired
	private CommonUtil commonUtil;
	
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
	public void updateNewAmount(String userId, String newStorageValue, String companyId, int tenantId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("userId",        userId);
		map.put("totalCapacity", newStorageValue);
		map.put("companyId",     companyId);
		map.put("tenantId",      tenantId);
		ezWebFolderAdminDAO.updateNewAmount(map);
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
}
