package egovframework.ezEKP.ezCabinet.service;

import javax.servlet.http.HttpServletRequest;
import org.json.simple.JSONObject;

public interface EzCabinetRestService_h {
	JSONObject getDeptMembers(HttpServletRequest request, String userId, String deptId, String currentPage) throws Exception;
	
	JSONObject getShareUserList(HttpServletRequest request, String userId, String cabinetId) throws Exception;

	//Get/Save user list type
	JSONObject getUserListType(HttpServletRequest request, String userId) throws Exception;
	JSONObject saveUserListType(HttpServletRequest request, String id, String listType) throws Exception;
}
