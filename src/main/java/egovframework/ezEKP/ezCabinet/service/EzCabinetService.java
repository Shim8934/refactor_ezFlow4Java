package egovframework.ezEKP.ezCabinet.service;

import java.util.List;
import java.util.Locale;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.springframework.web.multipart.MultipartFile;

import egovframework.ezEKP.ezCabinet.vo.CabinetColumnVO;
import egovframework.ezEKP.ezCabinet.vo.CabinetGeneralVO;
import egovframework.ezEKP.ezCabinet.vo.CabinetItemSearchVO;
import egovframework.ezEKP.ezCabinet.vo.CabinetItemSimpleVO;
import egovframework.ezEKP.ezCabinet.vo.CabinetItemVO;
import egovframework.ezEKP.ezCabinet.vo.CabinetModuleVO;
import egovframework.ezEKP.ezCabinet.vo.CabinetSimpleVO;
import egovframework.ezEKP.ezCabinet.vo.SimpleDeptVO;
import egovframework.ezEKP.ezCabinet.vo.SimpleUserMailVO;
import egovframework.ezEKP.ezCabinet.vo.SimpleUserVO;
import egovframework.ezEKP.ezCabinet.vo.CabinetVO;
import egovframework.let.user.login.vo.LoginVO;

public interface EzCabinetService {
	//Check user permission
	JSONObject checkPermission(List<Integer> cabinetList, List<Integer> itemList, int mode, LoginVO userInfo) throws Exception;
	
	//Company Tree process functions
	List<SimpleDeptVO> getAllSubDepts(String companyId, int level, String primary, int tenantId) throws Exception;
	String getDeptPath(String deptId, int tenantId) throws Exception;
	SimpleDeptVO getSimpleCompany(String deptId, int level, String primary, int tenantId) throws Exception;
	void getAllDepts(SimpleDeptVO sDept, String[] path, String primary, int tenantId, int order, int level) throws Exception;
	
	//User module setting functions
	List<CabinetModuleVO> getModuleListForUser(String userId, String companyId, int tenantId) throws Exception;
	void saveModulesSetting(JSONArray modules, String userId, String companyId, int tenantId) throws Exception;
	
	//User preview config functions
	CabinetGeneralVO getUserPreviewConfig(String userId, String companyID, int tenantId) throws Exception;
	void saveUserConfig(String prevMode, int listCount, int contentWPrev, int contentHPrev, String userId, String companyId, int tenantId) throws Exception;
	
	//User my cabinet tree functions
	CabinetSimpleVO getMyCabinetTreeNormal(LoginVO userInfo) throws Exception;
	CabinetSimpleVO getMyCabinetTreeDetail(String cabinetId, LoginVO userInfo) throws Exception;
	List<CabinetSimpleVO> getCabinetSubTree(String cabinetId, LoginVO userInfo) throws Exception;
	List<CabinetSimpleVO> getRelatedCabinetListForUser(LoginVO userInfo) throws Exception;
	List<CabinetSimpleVO> getUserSharedCabinet(String shareId, LoginVO userInfo) throws Exception;
	List<SimpleUserVO> getSharedUserList(LoginVO userInfo) throws Exception;
	
	//User cabinet management functions
	void addCabinet(int parentId, String cabName1, String cabName2, LoginVO userInfo) throws Exception;
	JSONObject renameCabinet(int cabinetId, String cabName1, String cabName2, LoginVO userInfo) throws Exception;
	JSONObject deleteCabinet(int cabinetId, LoginVO userInfo) throws Exception;
	JSONObject moveCabinet(int cabinetId, int parentId, String mode, String realPath, LoginVO userInfo) throws Exception;
	
	//User upload/download/delete attach file functions
	String saveUploadFile(List<MultipartFile> multiFileLists, JSONArray nameArray, String realPath, int tenantId) throws Exception;
	void deleteAttachFile(String filePath, String realPath, int tenantId) throws Exception;
	void getDownloadedFile(String fileName, String filePath, String realPath, LoginVO userInfo, String userAgent, HttpServletRequest request, HttpServletResponse response) throws Exception;
	
	//User item functions
	JSONObject getItemsBySearching(String cabinetId, int currentPage, int listCntSize, String title, String summary, String creatorName, String startDate, String endDate, String sqlQuery, String srchMode, String srchOption, String order, String column, String recursive, LoginVO userInfo) throws Exception;
	void saveItem(int cabinetId, JSONArray attacheFiles, JSONArray relatedFiles, String title, String summary, String realPath, LoginVO userInfo) throws Exception;
	
	//User get cabinet infor function
	CabinetVO getCabinetById(String cabinetId, int tenantId) throws Exception;
	JSONObject getSharedCabinetInfo(String cabinetId, LoginVO userInfo);
	
	//User get cabinet item list function
	List<CabinetItemVO> getItems(CabinetItemSearchVO searchVO) throws Exception;
	int getTotalItems(CabinetItemSearchVO searchVO) throws Exception;
	List<CabinetItemVO> getItemsRecursive(CabinetItemSearchVO searchVO) throws Exception;
	int getTotalItemsRecursive(CabinetItemSearchVO searchVO) throws Exception;
	int getTotalFiles(String cabinetId, int tenantId) throws Exception;
	int getTotalFilesByTitle(String itemTitle, String id, int tenantId) throws Exception;
	List<CabinetItemSimpleVO> getCabinetFiles(String cabinetId, int startPoint, int listCount, int tenantId) throws Exception;
	List<CabinetItemSimpleVO> getFilesByTitle(String itemTitle, int startPoint, int listCount, String userId, int tenantId) throws Exception;
	
	//User delete/move items function
	void deleteItems(List<Integer> itemIdList, LoginVO userInfo) throws Exception;
	JSONObject moveItems(String realPath, int cabinetId, String mode, List<Integer> itemIdList, LoginVO userInfo) throws Exception;
	
	//Get item size function
	public long getTotalItemsSize(List<Integer> itemIdList, LoginVO userInfo) throws Exception;
	
	//Get all related item columns function
	List<CabinetColumnVO> getAllRelatedColumnsOfItem(int itemId, String primary, int tenantId) throws Exception;
	
	//Save related item functions
	JSONObject saveEmailItem(String realPath, int parseInt, String title, String sender, String attach, String mode, String content, String receiver, String forward, String dateTime, Locale locale, LoginVO userInfo) throws Exception;
	
	//Get email information functions
	List<SimpleUserMailVO> getUserInfoFromEmail(List<String> receiverMail, String primary, int tenantId) throws Exception;
	
	//Modify related email item function 
	JSONObject modifyEmailItem(int currentItemId, String title, JSONArray relatedFiles, LoginVO userInfo) throws Exception;
}
