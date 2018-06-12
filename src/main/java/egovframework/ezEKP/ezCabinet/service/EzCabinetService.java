package egovframework.ezEKP.ezCabinet.service;

import javax.servlet.http.HttpServletRequest;
import org.json.simple.JSONObject;

public interface EzCabinetService {
	public JSONObject checkCabinetAdmin(HttpServletRequest request, String userId) throws Exception;
	public JSONObject getCompanyList(HttpServletRequest request, String id) throws Exception;
}
