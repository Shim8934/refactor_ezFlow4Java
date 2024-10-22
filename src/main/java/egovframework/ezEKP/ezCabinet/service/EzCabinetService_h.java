package egovframework.ezEKP.ezCabinet.service;

import java.util.List;
import java.util.Locale;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import egovframework.ezEKP.ezCabinet.vo.CabinetAttachFileVO;
import egovframework.ezEKP.ezCabinet.vo.CabinetItemVO;
import egovframework.ezEKP.ezCabinet.vo.CabinetRelationItemVO;
import egovframework.ezEKP.ezWebFolder.vo.SimpleUserVO;
import egovframework.let.user.login.vo.LoginVO;

public interface EzCabinetService_h {
	List<SimpleUserVO> getShareUserList(String cabinetId, String userId, String primary, String sqlQuery, String searchValue, int tenantId, String searchFlag) throws Exception;
	List<SimpleUserVO> getDeptMemberList(String deptId, String primary, int startPoint, int listCount, int tenantId) throws Exception;
	int getTotalDeptMembers(String deptId, int tenantId) throws Exception;
	List<SimpleUserVO> getSearchMemberList(String primary, int startPoint, int i, String srchOption, String srchValue, int tenantId) throws Exception;
	int getTotalSearchMembers(String sqlQuery, String srchValue, int tenantId) throws Exception;
	JSONObject saveShareUserList(JSONArray listUsers, String cabinetId, LoginVO userInfo) throws Exception;
	CabinetItemVO getFileDetail(String itemId, String primary, String offset, int tenantId) throws Exception;
	List<CabinetAttachFileVO> getAttachFileList(String itemId, int tenantId) throws Exception;
	List<CabinetRelationItemVO> getRelatedFileList(String itemId, int tenantId) throws Exception;
	JSONObject modifyItem(int itemId, JSONArray attacheFiles, JSONArray relatedFiles, String title, String summary, String realPath, LoginVO userInfo) throws Exception;
	JSONObject saveBoardItem(String realPath, String mode, int parseInt, String title, String summary, String boardTitle, String writer, String attach, String content, String dateTime, Locale locale, LoginVO userInfo) throws Exception;
	public void modifyRelatedList(int itemId, JSONArray relatedFiles, LoginVO userInfo) throws Exception;
	public void modifyAttachList(int itemId, JSONArray attacheFiles, String realPath, LoginVO userInfo) throws Exception;
	JSONObject saveOptionItem(String realPath, String mode, int parseInt, String title, String summary, String optionTitle, String writer, String date, String content, String attach, Locale locale, LoginVO userInfo) throws Exception;
	public JSONObject copyRelatedItemAttachFiles(JSONObject attachInf, int attachId, int itemId, String realPath, String cabinetPath, Locale locale, LoginVO userInfo, String modulePath, String uploadPath, List<CabinetAttachFileVO> attachFileList) throws Exception;
	public JSONObject saveListAttachFiles(JSONArray attachList, int itemId, String realPath, String modulePath, String uploadPath, Locale locale, LoginVO userInfo) throws Exception;
	JSONObject saveCommunityItem(String realPath, String mode, int parseInt, String title, String summary, String commuTitle, String writer, String date, String endDate, String content, String attach, Locale locale, LoginVO userInfo) throws Exception;
	JSONObject savePhotoCommunityitem(String realPath, String mode, int parseInt, String title, String summary, String commuTitle, String writer, String content, Locale locale, LoginVO userInfo) throws Exception;
	List<SimpleUserVO> getAncestorShareUserList(String cabinetId, String userId, String primary, int tenantId) throws Exception;
	int checkItemPermission(int cabinetId, LoginVO userInfo) throws Exception;
	JSONObject modifyShareUserList(JSONArray listUsers, String actMode, String cabinetId, LoginVO userInfo) throws Exception;
}
