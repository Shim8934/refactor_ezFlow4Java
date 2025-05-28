package egovframework.ezEKP.ezCabinet.service;

import javax.servlet.http.HttpServletRequest;
import org.json.simple.JSONObject;

public interface EzCabinetRestService_h {
	//Get department member list
	JSONObject getDeptMembers(HttpServletRequest request, String userId, String deptId, String currentPage) throws Exception;
	
	//Get/Save user list type
	JSONObject getUserListType(HttpServletRequest request, String userId) throws Exception;
	JSONObject saveUserListType(HttpServletRequest request, String id, String listType) throws Exception;
	
	//Cabinet share functions
	JSONObject getShareUserList(HttpServletRequest request, String userId, String cabinetId, String searchOpt, String searchValue, String searchFlag) throws Exception;
	JSONObject getSearchMember(HttpServletRequest request, String userId, String srchOption, String srchValue, String currentPage) throws Exception;
	JSONObject saveShareUserList(HttpServletRequest request, String userId, String cabinetId, String userList) throws Exception;
	JSONObject getAncestorShareUserList(HttpServletRequest request, String userId, String cabinetId) throws Exception;
	JSONObject modifyShareUserList(HttpServletRequest request, String userId, String cabinetId, String userList, String actMode) throws Exception;
	
	//Check file creator
	JSONObject checkPermission(HttpServletRequest request, String userId, String itemId, String cabinetId, int permission) throws Exception;
	
	//Get cabinet item simple/detail information
	JSONObject getFileDetail(HttpServletRequest request, String userId, String itemId) throws Exception;
	JSONObject cabinetItemInfo(HttpServletRequest request, String userId, String itemId) throws Exception;
	
	//Modify file 
	JSONObject modifyItem(HttpServletRequest request, String userId, String itemId, String title, String summary, String fileArray, String relatedArr) throws Exception;
	
	//Save boardModules
	JSONObject saveRelatedBoard(HttpServletRequest request, String userId, String mode, String cabinetId, String title, String summary, String boardTitle, String writer, String dateTime, String attach, String content) throws Exception;
	
	//Save optionModules
	JSONObject saveRelatedOption(HttpServletRequest request, String userId, String mode, String cabinetId, String title, String summary, String optionTitle, String writer, String date, String content, String attach) throws Exception;
	
	//Save communityModules
	JSONObject saveRelatedCommunity(HttpServletRequest request, String userId, String mode, String cabinetId, String title, String summary, String commuTitle, String writer, String date, String endDate, String content, String attach) throws Exception;
	
	//Save communityPhotoModules
	JSONObject saveRelatedPhotoCommunity(HttpServletRequest request, String userId, String mode, String cabinetId, String title, String summary, String commuTitle, String writer, String content) throws Exception;
	
}
