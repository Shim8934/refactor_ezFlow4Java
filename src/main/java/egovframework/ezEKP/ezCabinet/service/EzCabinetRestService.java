package egovframework.ezEKP.ezCabinet.service;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

public interface EzCabinetRestService {
	public JSONObject checkCabinetAdmin(HttpServletRequest request, String userId) throws Exception;
	public JSONObject getCompanyList(HttpServletRequest request, String id) throws Exception;
	public JSONObject getCompanyTree(HttpServletRequest request, String userId, String companyId) throws Exception;
	public JSONObject getDeptSubNodes(HttpServletRequest request, String id, String deptId, String level) throws Exception;
	
	//Admin company capacity service
	public JSONObject getCompanyCapacity(HttpServletRequest request, String companyId) throws Exception;
	public JSONObject saveCompanyCapacity(HttpServletRequest request, String capacityType, String newCapacity, String companyId) throws Exception;
	
	//Admin user capacity service
	public JSONObject getUserCapacity(HttpServletRequest request, String currPage, String companyId, String userId, String searchStr, String searchOpt, String column, String order, String listCnt) throws Exception;
	public JSONObject saveUserCapacity(HttpServletRequest request, List<String> userList, String capacityType, String newCapacity, String companyId) throws Exception;
	
	//Admin related modules service
	public JSONObject getModuleListForAdmin(HttpServletRequest request, String companyId) throws Exception;
	public JSONObject saveModulesSetting(HttpServletRequest request, JSONArray moduleList, String companyId) throws Exception;
	
	//User related modules service
	public JSONObject getModuleListForUser(HttpServletRequest request, String userId);
	public JSONObject saveModulesSettingForUser(HttpServletRequest request, JSONArray modules, String userId) throws Exception;
	
	//User capacity service
	public JSONObject getUserCapacity(HttpServletRequest request, String userId) throws Exception;
	
	//User preview configuration
	public JSONObject getUserPreviewConfig(HttpServletRequest request, String userId) throws Exception;
	public JSONObject saveUserConfig(HttpServletRequest request, String userId, String prevMode, String listCount, String contentWPrev, String contentHPrev) throws Exception;
	
	//User my cabinet tree
	public JSONObject getMyCabinetTree(HttpServletRequest request, String currentNode, String userId) throws Exception;
	public JSONObject getAllCabinetTree(HttpServletRequest request, String currentNode, String userId) throws Exception;
	public JSONObject getCabinetSubNodes(HttpServletRequest request, String userId, String nodeId) throws Exception;
	public JSONObject getRelatedCabinetTree(HttpServletRequest request, String userId, String currentNode) throws Exception;
	
	//User cabinet management
	public JSONObject addCabinet(HttpServletRequest request, String userId, String parentId, String cabinetName1, String cabinetName2) throws Exception;
	public JSONObject renameCabinet(HttpServletRequest request, String userId, String cabinetId, String cabinetName1, String cabinetName2) throws Exception;
	public JSONObject deleteCabinet(HttpServletRequest request, String userId, String cabinetId) throws Exception;
	public JSONObject moveCabinet(HttpServletRequest request, String userId, String cabinetId, String parentId, String mode) throws Exception;
	
	//User upload attach file
	public JSONObject uploadAttachFile(MultipartHttpServletRequest request, String userId, List<MultipartFile> multiFiles) throws Exception;
	public JSONObject deleteAttachFile(HttpServletRequest request, String userId, String filePath) throws Exception;
	
	//User item
	public JSONObject saveItem(HttpServletRequest request, String userId, String cabinetId, String title, String summary, JSONArray fileArray, JSONArray relatedArr) throws Exception;
	
	//User cabinet information
	public JSONObject getCabinetInfo(HttpServletRequest request, String userId, String cabinetId) throws Exception;
	
	//User get cabinet items
	public JSONObject getCabinetItems(HttpServletRequest request, String userId, String cabinetId, String title, String summary, String recursive, String creatorName, String startDate, String endDate, String column, String order, String srchMode, String srchOption, String listCntSize, String currentPage) throws Exception;
	public JSONObject getCabinetFiles(HttpServletRequest request, String id, String cabinetId) throws Exception;
	public JSONObject getFilesBySearching(HttpServletRequest request, String id, String itemTitle) throws Exception;
	
	//User cabinet items move/delete
	public JSONObject deleteItems(HttpServletRequest request, String userId, List<String> itemList) throws Exception;
	public JSONObject moveItems(HttpServletRequest request, String userId, String cabinetId, String mode, List<String> itemList) throws Exception;
	public JSONObject SaveRelatedItem(HttpServletRequest request, String id, String cabinetId, String title, String author, String normalScreen);
	
}
