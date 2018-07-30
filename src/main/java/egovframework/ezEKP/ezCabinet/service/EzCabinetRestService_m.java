package egovframework.ezEKP.ezCabinet.service;

import javax.servlet.http.HttpServletRequest;

import org.json.simple.JSONObject;

public interface EzCabinetRestService_m {
	//Save related documents
	JSONObject saveRelatedApproval(HttpServletRequest request, String userId, String mode, String cabinetId, String divContent, String doctitle, String lstAttachLink)throws Exception;
}
