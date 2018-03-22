package egovframework.ezEKP.ezWebFolder.service;

import java.util.List;
import egovframework.ezEKP.ezWebFolder.vo.FileLogVO;
import egovframework.ezEKP.ezWebFolder.vo.FolderVO;
import egovframework.ezEKP.ezWebFolder.vo.UserCapacityVO;
import egovframework.ezEKP.ezWebFolder.vo.WebfolderConfigVO;
import egovframework.let.user.login.vo.LoginVO;

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
	void addCompanyFolder(String pFolderId, String folderUsers, String folderName, String folderName2, LoginVO userInfo) throws Exception;
	String getMaxFolderID(int tenantId) throws Exception;
	int getMaxFolderStep(String pFolderId, int tenantId) throws Exception;
	void updateCompanyFolder(String userId, String folderId, String folderUsers, String folderName, String folderName2, String offset, int tenantId) throws Exception;
	void addDeptFolders(String companyId, LoginVO userInfo) throws Exception;
	String getMaxFolderUserSeq(int tenantId) throws Exception;
	void updateSelectedDeptsForChief(List<String> deptsList, String userId, String offset, int tenantId) throws Exception;
	void moveCompanyFolder(FolderVO folder, List<FolderVO> listSubFolder, String destFolderId, String mode, LoginVO userInfo) throws Exception;
	void addPersonalFolder(LoginVO userInfo) throws Exception;
}