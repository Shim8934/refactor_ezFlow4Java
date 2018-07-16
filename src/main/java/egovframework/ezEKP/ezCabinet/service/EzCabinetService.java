package egovframework.ezEKP.ezCabinet.service;

import java.util.List;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.springframework.web.multipart.MultipartFile;
import egovframework.ezEKP.ezCabinet.vo.CabinetGeneralVO;
import egovframework.ezEKP.ezCabinet.vo.CabinetItemSearchVO;
import egovframework.ezEKP.ezCabinet.vo.CabinetItemVO;
import egovframework.ezEKP.ezCabinet.vo.CabinetModuleVO;
import egovframework.ezEKP.ezCabinet.vo.CabinetSimpleVO;
import egovframework.ezEKP.ezCabinet.vo.SimpleDeptVO;
import egovframework.ezEKP.ezCabinet.vo.CabinetVO;
import egovframework.let.user.login.vo.LoginVO;

public interface EzCabinetService {
	//Check user permission
	JSONObject checkPermission(List<Integer> cabinetList, List<Integer> itemList, LoginVO userInfo) throws Exception;
	
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
	
	//User cabinet management functions
	void addCabinet(int parentId, String cabName1, String cabName2, LoginVO userInfo) throws Exception;
	JSONObject renameCabinet(int cabinetId, String cabName1, String cabName2, LoginVO userInfo) throws Exception;
	JSONObject deleteCabinet(int cabinetId, LoginVO userInfo) throws Exception;
	JSONObject moveCabinet(int cabinetId, int parentId, String mode, String realPath, LoginVO userInfo) throws Exception;
	
	//User upload attach file functions
	String saveUploadFile(List<MultipartFile> multiFileLists, JSONArray nameArray, String realPath, int tenantId) throws Exception;
	void deleteAttachFile(String filePath, String realPath, int tenantId) throws Exception;
	
	//User item functions
	void saveItem(int cabinetId, JSONArray attacheFiles, JSONArray relatedFiles, String title, String summary, String realPath, LoginVO userInfo) throws Exception;
	
	//User get cabinet infor function
	CabinetVO getCabinetById(String cabinetId, int tenantId) throws Exception;
	
	//User get cabinet item list function
	List<CabinetItemVO> getItems(CabinetItemSearchVO searchVO) throws Exception;
	int getTotalItems(CabinetItemSearchVO searchVO) throws Exception;
	List<CabinetItemVO> getItemsRecursive(CabinetItemSearchVO searchVO) throws Exception;
	int getTotalItemsRecursive(CabinetItemSearchVO searchVO) throws Exception;
	
	//User delete/move items function
	void deleteItems(List<Integer> itemIdList, LoginVO userInfo) throws Exception;
	JSONObject moveItems(String realPath, int cabinetId, String mode, List<Integer> itemIdList, LoginVO userInfo) throws Exception;
}
