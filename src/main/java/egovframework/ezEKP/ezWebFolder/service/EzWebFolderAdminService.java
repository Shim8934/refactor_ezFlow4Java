package egovframework.ezEKP.ezWebFolder.service;

import java.util.List;
import java.util.Locale;

import javax.servlet.http.HttpServletResponse;

import egovframework.ezEKP.ezWebFolder.vo.DuplicateInfoVO;
import egovframework.ezEKP.ezWebFolder.vo.FileLogVO;
import egovframework.ezEKP.ezWebFolder.vo.FolderVO;
import egovframework.ezEKP.ezWebFolder.vo.UserCapacityVO;
import egovframework.ezEKP.ezWebFolder.vo.WebfolderConfigVO;
import egovframework.let.user.login.vo.LoginVO;

public interface EzWebFolderAdminService {
	void saveConfig(String companyLimit, String departmentLimit, String userLimit, String uploadLimit, String companyId, int tenantId) throws Exception;
	WebfolderConfigVO getEveryCompanyConfig(int tenantId) throws Exception;
	WebfolderConfigVO getWebfolderConfig(String companyId, int tenantId) throws Exception;
	//List<CapacityVO> getListUserCapacity(String realColmn, String order, String companyId, String searchStr, String searchOpt, int startPoint, int pageSize, int tenantId, String primary) throws Exception;
	//void updateNewAmount(List<String> targetList, String type, String newStorageValue, String companyId, int tenantId) throws Exception;
	List<FileLogVO> getListFileLogs(String realColmn, String order, String companyId, String searchChk, String startDate, String endDate, String fileExt, String fileName, String userName, String fileType, String actionType, int startPoint, int endPoint, String primary, String offset, int tenantId) throws Exception;
	void insertFileLog(FileLogVO fileLog) throws Exception;
	void insertFolder(FolderVO folder) throws Exception;
	void insertFolder2(FolderVO folder) throws Exception;
	void insertFolderUser(String seq, String userId, String userType, String folderId, String createId, String createDate, String companyId, int tenantId) throws Exception;
	void deleteFolderUsers(String folderId, int tenantId) throws Exception;
	int getTotalFileLogs(String companyId, String searchChk, String startDate, String endDate, String fileExt, String fileName, String userName, String fileType, String actionType, String primary, int tenantId) throws Exception;
	//int getTotalListUserCapacity(String companyId, String searchStr, String searchOpt, int startPoint, int pageSize, int tenantId, String primary) throws Exception;
	void deleteFolderUsersOfChief(String userId, int tenantId) throws Exception;
	List<DuplicateInfoVO> addCompanyFolder(String pFolderId, String folderUsers, String folderName, String folderName2, LoginVO userInfo) throws Exception;
	String getMaxFolderID(int tenantId) throws Exception;
	int getMaxFolderStep(String pFolderId, int tenantId) throws Exception;
	List<DuplicateInfoVO> updateCompanyFolder(String userId, String folderId, String folderUsers, String folderName, String folderName2, String offset, int tenantId) throws Exception;
	void addDeptFolders(String companyId, LoginVO userInfo) throws Exception;
	String getMaxFolderUserSeq(int tenantId) throws Exception;
	void updateSelectedDeptsForChief(List<String> deptsList, LoginVO userInfo) throws Exception;
	List<DuplicateInfoVO> moveCompanyFolder(FolderVO folder, FolderVO destFolder, String mode, String realPath, LoginVO userInfo) throws Exception;
	void addPersonalFolder(LoginVO userInfo) throws Exception;
	void setDefaultCapacity(String companyValue, String departmentValue, String userValue, String companyId, int tenantId) throws Exception;
	void setCapacities(List<String> cnList, String type, String value, String companyId, int tenantId) throws Exception;
	void deleteCapacities(List<String> cnList, String type, int tenantId) throws Exception;
	UserCapacityVO getCapacity(String cn, String type, String primary, int tenantId) throws Exception;
	UserCapacityVO getCapacity(String folderId, String primary, int tenantId) throws Exception;
	List<UserCapacityVO> getCapacityList(String type, String primary, String companyId, int tenantId, String realColumn, String order, String searchKeyword, String searchOption, int startPoint, int pageSize) throws Exception;
	int getTotalCapacityCount(String type, String companyId, int tenantId, String searchKeyword, String searchOption) throws Exception;
	String createExcelFileLogs(String realPath, String pDirPath, List<FileLogVO> listFileLogs, String primary, Locale locale) throws Exception;
	void getExcelFile(String fileName, String realPath, String userAgent, HttpServletResponse response, int tenantId) throws Exception;
	double getFolderSize(String folderPath, int tenantId) throws Exception;
}