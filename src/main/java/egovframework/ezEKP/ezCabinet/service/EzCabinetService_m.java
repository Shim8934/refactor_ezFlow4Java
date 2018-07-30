package egovframework.ezEKP.ezCabinet.service;

import java.util.Locale;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

import egovframework.let.user.login.vo.LoginVO;

public interface EzCabinetService_m {
	//save ApprovalItem 
	JSONObject saveApprovalItem(String realPath, int cabinetId, String approvalContent, String mode, String doctitle, String lstAttachLink, Locale locale, LoginVO userInfo)throws Exception;
	
	//User item functions
	void saveItem(int cabinetId, JSONArray attacheFiles, JSONArray relatedFiles, String doctitle, String realPath, LoginVO userInfo) throws Exception;
}
