package egovframework.ezEKP.ezCabinet.service;

import javax.servlet.http.HttpServletRequest;

import org.json.simple.JSONObject;

public interface EzCabinetRestService_h {

	JSONObject getDeptMembers(HttpServletRequest request, String userId, String deptId, String srchOption, String srchValue) throws Exception;
	
	JSONObject getShareUserList(HttpServletRequest request, String userId, String cabinetId) throws Exception;
}
