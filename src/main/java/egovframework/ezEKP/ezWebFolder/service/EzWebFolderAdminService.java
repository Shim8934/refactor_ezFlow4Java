package egovframework.ezEKP.ezWebFolder.service;

import java.util.List;
import egovframework.ezEKP.ezWebFolder.vo.FileLogVO;
import egovframework.ezEKP.ezWebFolder.vo.FolderVO;
import egovframework.ezEKP.ezWebFolder.vo.UserCapacityVO;
import egovframework.ezEKP.ezWebFolder.vo.WebfolderConfigVO;

public interface EzWebFolderAdminService {
	void saveConfig(String personalLimit, String uploadLimit, String companyId, int tenantId) throws Exception;
	WebfolderConfigVO getWebfolderConfig(String companyId, int tenantId) throws Exception;
	List<UserCapacityVO> getListUserCapacity(String companyId, String searchStr, String searchOpt, int startPoint, int pageSize, int tenantId, String primary) throws Exception;
	void updateNewAmount(List<String> userList, String newStorageValue, String companyId, int tenantId) throws Exception;
	List<FileLogVO> getListFileLogs(String companyId, String searchChk, String startDate, String endDate, String fileExt, String fileName, String userName, int startPoint, int endPoint, String primary, String offset, int tenantId) throws Exception;
	void insertFileLog(FileLogVO fileLog) throws Exception;
	void insertFolder(FolderVO folder) throws Exception;
	void insertFolder2(FolderVO folder) throws Exception;
	void insertFolderUser(String seq, String userId, String userType, String folderId, String createId, String createDate, String companyId, int tenantId) throws Exception;
	void deleteFolderUsers(String folderId, int tenantId) throws Exception;
	int getTotalFileLogs(String companyId, String searchChk, String startDate, String endDate, String fileExt, String fileName, String userName, int startPoint, int endPoint, String primary, int tenantId) throws Exception;
	int getTotalListUserCapacity(String companyId, String searchStr, String searchOpt, int startPoint, int pageSize, int tenantId, String primary) throws Exception;
	void deleteFolderUsersOfChief(String userId, int tenantId) throws Exception;
	void saveLog(String string, String companyId, String offset, String userId, String userName1, String userName2, String fileName, String fileSize, String fileExt, String typeName, String logId, int tenantId) throws Exception;
}