package egovframework.ezEKP.ezCabinet.service;

import java.util.List;
import javax.servlet.http.HttpServletRequest;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

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
	
	//User my cabinet 
	public JSONObject getMyCabinetTree(HttpServletRequest request, String currentNode, String userId) throws Exception;
	public JSONObject addCabinet(HttpServletRequest request, String userId, String parentId, String cabinetName1, String cabinetName2) throws Exception;
	public JSONObject getCabinetSubNodes(HttpServletRequest request, String userId, String nodeId) throws Exception;
	public JSONObject renameCabinet(HttpServletRequest request, String userId, String cabinetId, String cabinetName1, String cabinetName2) throws Exception;
}
