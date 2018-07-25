package egovframework.ezEKP.ezCabinet.service;

import java.util.List;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

import egovframework.ezEKP.ezCabinet.vo.CabinetAttachFileVO;
import egovframework.ezEKP.ezCabinet.vo.CabinetItemVO;
import egovframework.ezEKP.ezCabinet.vo.CabinetRelationItemVO;
import egovframework.ezEKP.ezWebFolder.vo.SimpleUserVO;
import egovframework.let.user.login.vo.LoginVO;

public interface EzCabinetService_h {
	List<SimpleUserVO> getShareUserList(String cabinetId, String userId, String primary, String sqlQuery, String searchValue, int tenantId) throws Exception;
	List<SimpleUserVO> getDeptMemberList(String deptId, String primary, int startPoint, int listCount, int tenantId) throws Exception;
	int getTotalDeptMembers(String deptId, int tenantId) throws Exception;
	List<SimpleUserVO> getSearchMemberList(String primary, int startPoint, int i, String srchOption, String srchValue, int tenantId) throws Exception;
	int getTotalSearchMembers(String sqlQuery, String srchValue, int tenantId) throws Exception;
	JSONObject saveShareUserList(JSONArray listUsers, String cabinetId, LoginVO userInfo) throws Exception;
	CabinetItemVO getFileDetail(String itemId, String primary, String offset, int tenantId) throws Exception;
	List<CabinetAttachFileVO> getAttachFileList(String itemId, int tenantId) throws Exception;
	List<CabinetRelationItemVO> getRelatedFileList(String itemId, int tenantId) throws Exception;
	void modifyItem(int itemId, JSONArray attacheFiles, JSONArray relatedFiles, String title, String summary, String realPath, LoginVO userInfo) throws Exception;
}
