package egovframework.ezEKP.ezCabinet.service;

import javax.servlet.http.HttpServletRequest;
import org.json.simple.JSONObject;

public interface EzCabinetRestService_m {
	//Save related aprroval documents
	JSONObject saveRelatedApproval(HttpServletRequest request, String userId, String mode, String cabinetId, String divContent, String doctitle, String lstAttachLink, String otherAttachLk) throws Exception;
	
	//Save related journal documents
	JSONObject saveRelatedJournal(HttpServletRequest request, String id, String cabinetId, String mode, String title, String createDate, String journalWriter, String journalType, String formName, String content, String attach) throws Exception;
}
