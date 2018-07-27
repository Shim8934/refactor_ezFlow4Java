package egovframework.ezEKP.ezCabinet.service;

import javax.servlet.http.HttpServletRequest;
import org.json.simple.JSONObject;

public interface EzCabinetRestService_m {
	//Save related documents
	public JSONObject saveRelatedApproval(HttpServletRequest request, String userId, String divContent) throws Exception;
}
