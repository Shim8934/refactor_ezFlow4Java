package egovframework.ezEKP.ezCabinet.service;

import javax.servlet.http.HttpServletRequest;
import org.json.simple.JSONObject;

public interface EzCabinetRestService {
	public JSONObject checkCabinetAdmin(HttpServletRequest request, String userId) throws Exception;
	public JSONObject getCompanyList(HttpServletRequest request, String id) throws Exception;
	public JSONObject getCompanyTree(HttpServletRequest request, String userId, String companyId) throws Exception;
	public JSONObject getDeptSubNodes(HttpServletRequest request, String id, String deptId, String level) throws Exception;
	
	
	//Admin company capacity service
	public JSONObject getCompanyCapacity(HttpServletRequest request, String companyId) throws Exception;
	public JSONObject saveCompanyCapacity(HttpServletRequest request, String newCapacity, String companyId) throws Exception;
}
