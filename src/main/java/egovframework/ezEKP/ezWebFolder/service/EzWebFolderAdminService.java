package egovframework.ezEKP.ezWebFolder.service;

import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;

import egovframework.ezEKP.ezWebFolder.vo.DuplicateInfoVO;
import egovframework.ezEKP.ezWebFolder.vo.FileLogVO;
import egovframework.ezEKP.ezWebFolder.vo.FileVO;
import egovframework.ezEKP.ezWebFolder.vo.FolderSimpleVO;
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
	List<FileLogVO> getListFileLogs(String realColmn, String order, String companyId, String searchChk, String startDate, 
			String endDate, String fileExt, String fileName, String userName, String fileType, String actionType, 
			int startPoint, int endPoint, String primary, String offset, int tenantId, String sortType, String sortColumn, 
			String userId, String adminFlag) throws Exception;
	void insertFileLog(FileLogVO fileLog) throws Exception;
	int insertFolder(FolderVO folder) throws Exception;
	int insertFolder2(FolderVO folder) throws Exception;
	void insertFolderUser(String seq, String userId, String userType, String folderId, String createId, String createDate, String companyId, int tenantId) throws Exception;
	void insertFolderUser(String seq, String userId, String userType, String folderId, String createId, String createDate, String companyId, int tenantId, Boolean subdeptPermitted, Boolean folderManager) throws Exception;
	void deleteFolderUsers(String folderId, int tenantId, String folderManager) throws Exception;
	int getTotalFileLogs(String companyId, String searchChk, String startDate, String endDate, String fileExt, String fileName, String userName, String fileType, 
			String actionType, String primary, int tenantId, String folderId, String adminFlag) throws Exception;
	//int getTotalListUserCapacity(String companyId, String searchStr, String searchOpt, int startPoint, int pageSize, int tenantId, String primary) throws Exception;
	void deleteFolderUsersOfChief(String userId, int tenantId) throws Exception;
	Map<String, Object> addCompanyFolder(String pFolderId, String folderUsers, String folderName, String folderName2, LoginVO userInfo) throws Exception;
	String getMaxFolderID(int tenantId) throws Exception;
	int getMaxFolderStep(String pFolderId, int tenantId) throws Exception;
	Map<String, Object> updateCompanyFolder(String userId, String folderId, String folderUsers, String folderName, String folderName2, String offset, int tenantId
			, ArrayList<String> addUser, ArrayList<String> deleteUser, String subFolderType, LoginVO userInfo
			, ArrayList<String> addUserManager, ArrayList<String> deleteUserManager
			, boolean encryption) throws Exception;
	void addDeptFolders(String companyId, LoginVO userInfo) throws Exception;
	String getMaxFolderUserSeq(int tenantId) throws Exception;
	String getMaxFolderUserSeq(int tenantId, String type) throws Exception;
	void updateSelectedDeptsForChief(List<String> deptsList, LoginVO userInfo) throws Exception;
	List<DuplicateInfoVO> moveCompanyFolder(FolderVO folder, FolderVO destFolder, String mode, String realPath, LoginVO userInfo, String adminCheck) throws Exception;
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
	void deleteFolderUsersByUserId(String userId, String userType, String companyId, int tenantId) throws Exception;
	public void insertListFolderUsers(String userId, String folderId, String companyId, String folderUsers, String timeUTC, int tenantId
			, String type, List<String> addUser, String subFolderType, String folderPath, List<String> addUserManager, String offset) throws Exception;
	void deleteSelectedFolderUser(String folderPath, List<String> userIdList,	int tenantId, int folderManger) throws Exception;
	void deleteSelectedFileUser(List<String> userIdList, int tenantId, String fileId) throws Exception;
	List<String> getFolderIdsByManagerUserId(String userId, String folderId, String companyId, int tenantId) throws Exception;
	List<String> getTopFoldersByManagerUserId(String userId, int tenantId) throws Exception;
	public List<FolderSimpleVO> selectSubAllFolder(String folderPath, int tenantId) throws Exception;
	void insertFolderUser(Map<String, Object> map) throws Exception;
	List<FileVO> folderInFileList(Map<String, Object> map) throws Exception;
}