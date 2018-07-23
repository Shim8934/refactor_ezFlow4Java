package egovframework.ezEKP.ezCabinet.service;

import java.util.List;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import egovframework.ezEKP.ezCabinet.vo.CabinetItemVO;
import egovframework.ezEKP.ezWebFolder.vo.SimpleUserVO;
import egovframework.let.user.login.vo.LoginVO;

public interface EzCabinetService_h {
	List<SimpleUserVO> getShareUserList(String cabinetId, String userId, String primary, String sqlQuery, String searchValue, int tenantId) throws Exception;
	List<SimpleUserVO> getDeptMemberList(String deptId, String primary, int startPoint, int listCount, int tenantId) throws Exception;
	int getTotalDeptMembers(String deptId, int tenantId) throws Exception;
	List<SimpleUserVO> getSearchMemberList(String primary, int startPoint, int i, String srchOption, String srchValue, int tenantId) throws Exception;
	int getTotalSearchMembers(String sqlQuery, String srchValue, int tenantId) throws Exception;
	JSONObject saveShareUserList(JSONArray listUsers, String cabinetId, LoginVO userInfo) throws Exception;
	int isFileCreator(String itemId, String userId, int tenantId) throws Exception;
	CabinetItemVO getFileDetail(String itemId, String userId, String primary, int tenantId) throws Exception;
}
